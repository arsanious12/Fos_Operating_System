#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] INITIALIZE SHARES:
//===========================
//Initialize the list and the corresponding lock
void sharing_init()
{
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list);
	init_kspinlock(&AllShares.shareslock, "shares lock");
	//init_sleeplock(&AllShares.sharessleeplock, "shares sleep lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [2] Find Share Object:
//=========================
struct Share* find_share(int32 ownerID, char* name)
{
#if USE_KHEAP
    struct Share *found_share = NULL;
    bool already_held = holding_kspinlock(&(AllShares.shareslock));
    if (!already_held) acquire_kspinlock(&(AllShares.shareslock));

    struct Share *current_share;
    LIST_FOREACH(current_share, &(AllShares.shares_list))
    {
        if (current_share->ownerID == ownerID && strcmp(name, current_share->name) == 0)
        {
            found_share = current_share;
            break;
        }
    }

    if (!already_held) release_kspinlock(&(AllShares.shareslock));
    return found_share;
#else
    panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [3] Get Size of Share Object:
//==============================
int size_of_shared_object(int32 ownerID, char* shareName)
{
    struct Share* share_ptr = find_share(ownerID, shareName);
    if (share_ptr == NULL)
        return E_SHARED_MEM_NOT_EXISTS;
    return share_ptr->size;
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=====================================
// [1] Alloc & Initialize Share Object:
//=====================================
//Allocates a new shared object and initialize its member
//It dynamically creates the "framesStorage"
//Return: allocatedObject (pointer to struct Share) passed by reference
struct Share* alloc_share(int32 ownerID, char* shareName, uint32 size, uint8 isWritable)
{
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #1 alloc_share
	//Your code is here
#if USE_KHEAP
    struct Share* new_share = (struct Share*) kmalloc(sizeof(struct Share));
    if (!new_share) return NULL;

    new_share->ID         = (uint32)new_share & ~(0x80000000);
    new_share->ownerID    = ownerID;
    strncpy(new_share->name, shareName, sizeof(new_share->name) - 1);
    new_share->name[sizeof(new_share->name) - 1] = '\0';
    new_share->size       = size;
    new_share->isWritable = isWritable;
    new_share->references = 1;

    int frame_count = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
    new_share->framesStorage = (struct FrameInfo**) kmalloc(frame_count * sizeof(struct FrameInfo*));
    if (!new_share->framesStorage) { kfree(new_share); return NULL; }

    for (int frame_idx = 0; frame_idx < frame_count; ++frame_idx)
        new_share->framesStorage[frame_idx] = NULL;

    return new_share;
#else
    panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [4] Create Share Object:
//=========================

int create_shared_object(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
#if USE_KHEAP
    struct Env* current_env = get_cpu_proc();
    acquire_kspinlock(&AllShares.shareslock);

    struct Share* existing_share = find_share(ownerID, shareName);
    if (existing_share) { release_kspinlock(&AllShares.shareslock); return E_SHARED_MEM_EXISTS; }

    int frame_count = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
    uint32 start_va = (uint32) virtual_address;

    struct Share* new_share = alloc_share(ownerID, shareName, size, isWritable);
    if (!new_share) { release_kspinlock(&AllShares.shareslock); return E_NO_SHARE; }

    int permissions = PERM_UHPAGE | PERM_USER | PERM_WRITEABLE;

    for (int frame_idx = 0; frame_idx < frame_count; ++frame_idx)
    {
        alloc_page(current_env->env_page_directory, start_va + PAGE_SIZE*frame_idx, permissions, 0);
        uint32* page_table = NULL;
        get_page_table(current_env->env_page_directory, start_va + PAGE_SIZE*frame_idx, &page_table);
        struct FrameInfo* cur_frame = get_frame_info(current_env->env_page_directory, start_va + PAGE_SIZE*frame_idx, &page_table);
        new_share->framesStorage[frame_idx] = cur_frame;
    }

    LIST_INSERT_TAIL(&AllShares.shares_list, new_share);
    release_kspinlock(&AllShares.shareslock);

    return new_share->ID;
#else
    panic("not handled when KERN HEAP is disabled");
#endif
}

//======================
// [5] Get Share Object:
//======================
int get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #5 get_shared_object
	//Your code is here
#if USE_KHEAP
    struct Env* current_env = get_cpu_proc();
    struct Share* target_share = find_share(ownerID, shareName);
    if (!target_share) return E_SHARED_MEM_NOT_EXISTS;

    int total_size = ROUNDUP(target_share->size, PAGE_SIZE);
    int frame_count = total_size / PAGE_SIZE;
    uint32 start_va = (uint32) virtual_address;

    int permissions = PERM_UHPAGE | PERM_USER;
    if (target_share->isWritable) permissions |= PERM_WRITEABLE;

    for (int frame_idx = 0; frame_idx < frame_count; ++frame_idx)
    {
        uint32* page_table = NULL;
        int ret = get_page_table(current_env->env_page_directory, start_va + PAGE_SIZE*frame_idx, &page_table);
        if (ret == TABLE_NOT_EXIST) page_table = create_page_table(current_env->env_page_directory, start_va + PAGE_SIZE*frame_idx);
        map_frame(current_env->env_page_directory, target_share->framesStorage[frame_idx], start_va + PAGE_SIZE*frame_idx, permissions);
        target_share->framesStorage[frame_idx]->references++;
    }

    target_share->references++;
    return target_share->ID;
#else
    panic("not handled when KERN HEAP is disabled");
#endif

}
//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//
//=========================
// [1] Delete Share Object:
//=========================
void free_share(struct Share* ptrShare)
{
#if USE_KHEAP
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - free_share
	//Your code is here
	panic("free_share() is not implemented yet...!!");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}


struct Share* get_share_object_ID(int32 sharedObjectID){
#if USE_KHEAP
	struct Share * ret = NULL;
	bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
	if (!wasHeld)
	{
		acquire_kspinlock(&(AllShares.shareslock));
	}
	{
		struct Share * shr ;
		LIST_FOREACH(shr, &(AllShares.shares_list))
		{
			if(shr->ID == sharedObjectID)
			{
				ret = shr;
				break;
			}
		}
	}
	if (!wasHeld)
	{
		release_kspinlock(&(AllShares.shareslock));
	}
	return ret;
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

int32 get_shared_object_id(void* virtual_address){
#if USE_KHEAP
	struct Share * ret = NULL;
	struct Env * e = get_cpu_proc();
	uint32 va = (uint32)virtual_address;
	bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
	if (!wasHeld)
	{
		acquire_kspinlock(&(AllShares.shareslock));
	}
	{
		struct Share * shr ;
		LIST_FOREACH(shr, &(AllShares.shares_list))
		{
			uint32 size = ROUNDUP(shr->size, PAGE_SIZE);
			int framesCount = size / PAGE_SIZE;

			for (int i = 0; i < framesCount; ++i){
				uint32* ptr_pg_table = NULL;
				int ret = get_page_table(e->env_page_directory, (va + PAGE_SIZE*i), &ptr_pg_table);
				if(ret == TABLE_NOT_EXIST){
					continue;
				}
				if(shr->framesStorage[i] != get_frame_info(e->env_page_directory, (va + PAGE_SIZE*i), &ptr_pg_table)){
					continue;
				}
			}
			ret = shr;
			break;
		}
	}
	if (!wasHeld)
	{
		release_kspinlock(&(AllShares.shareslock));
	}
	return ret->ID;
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [2] Free Share Object:
//=========================
int delete_shared_object(int32 sharedObjectID, void *startVA)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - delete_shared_object
	//Your code is here
	//Comment the following line
	panic("delete_shared_object() is not implemented yet...!!");

	// This function should free (delete) the shared object from the User Heapof the current environment
	// If this is the last shared env, then the "frames_store" should be cleared and the shared object should be deleted
	// RETURN:
	//	a) 0 if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists

	// Steps:
	//	1) Get the shared object from the "shares" array (use get_share_object_ID())
	//	2) Unmap it from the current environment "myenv"
	//	3) If one or more table becomes empty, remove it
	//	4) Update references
	//	5) If this is the last share, delete the share object (use free_share())
	//	6) Flush the cache "tlbflush()"

}
