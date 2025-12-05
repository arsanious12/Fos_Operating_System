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
//Search for the given shared object in the "shares_list"
//Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share* find_share(int32 ownerID, char* name)
{
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
			//cprintf("shared var name = %s compared with %s\n", name, shr->name);
			if(shr->ownerID == ownerID && strcmp(name, shr->name)==0)
			{
				//cprintf("%s found\n", name);
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

//==============================
// [3] Get Size of Share Object:
//==============================
int size_of_shared_object(int32 ownerID, char* shareName)
{
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share* ptr_share = find_share(ownerID, shareName);
	if (ptr_share == NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}
//===========================================================


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
	//Comment the following line
#if USE_KHEAP
	struct Share* ptr_shared_object = (struct Share*)kmalloc(sizeof(struct Share));

	if(ptr_shared_object == NULL){
		return NULL;
	}

	ptr_shared_object->ID = (uint32)ptr_shared_object & ~(0x80000000);
	ptr_shared_object->ownerID = ownerID;
	int l = strlen(shareName);
	for (int i = 0; i < l; ++i){
			ptr_shared_object->name[i] = shareName[i];
	}
	ptr_shared_object->name[l] = '\0';
	ptr_shared_object->size = size;
	ptr_shared_object->isWritable = isWritable;
	ptr_shared_object->references = 1;

	int framesCount = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;

	ptr_shared_object->framesStorage = (struct FrameInfo**) kmalloc(framesCount * sizeof(struct FrameInfo *));

	if(ptr_shared_object->framesStorage == NULL) {
		kfree(ptr_shared_object);
		return NULL;
	}

	for (int i= 0; i< framesCount; ++i){
		ptr_shared_object->framesStorage[i] = 0;
	}
	return ptr_shared_object;
	//panic("alloc_share() is not implemented yet...!!");

#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//void print_allshare(){
//	cprintf("\n");
//	int count = LIST_SIZE(&(AllShares.shares_list));
//	struct Share* elm = LIST_FIRST(&(AllShares.shares_list));
//	for (int i =0; i< count; ++i){
//		cprintf("%x:%d:%s\n", elm, elm->references, elm->name);
//		if(LIST_NEXT(elm) == NULL) break;
//		elm = LIST_NEXT(elm);
//	}
//	cprintf("\n");
//}


//=========================
// [4] Create Share Object:
//=========================

int create_shared_object(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
#if USE_KHEAP
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #3 create_shared_object
	//Your code is here
	//Comment the following line
	//panic("create_shared_object() is not implemented yet...!!");
	acquire_kspinlock(&AllShares.shareslock);
	struct Env* myenv = get_cpu_proc();

	//cprintf("\n\n before allocating: ");
	//print_allshare();

	// check if exist
	struct Share* ptr = find_share(ownerID, shareName);
	if(ptr != NULL) {
		//cprintf("no creating new object already exist\n");
		release_kspinlock(&AllShares.shareslock);
		return E_SHARED_MEM_EXISTS;
	}

	// get frames to be mapped
	int framesCount = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
	uint32 va = (uint32)virtual_address;

	// allocating the share object
	struct Share* ptr_shared_object = alloc_share(ownerID, shareName, size, isWritable);
	if(ptr_shared_object == NULL) {
		release_kspinlock(&AllShares.shareslock);
		return E_NO_SHARE;
	}

	//set permission to uhpage and if(iswritable)
	int perm = PERM_UHPAGE|PERM_USER|PERM_WRITEABLE;

	// iterate over the frames and allocating pages from them
	for (int i = 0; i < framesCount; ++i){
		int ret = alloc_page(myenv->env_page_directory, va + PAGE_SIZE*i, perm, 0);

		uint32* ptr_pg_table = NULL;
		get_page_table(myenv->env_page_directory, va + PAGE_SIZE*i, &ptr_pg_table);

		struct FrameInfo* cur_frame = get_frame_info(myenv->env_page_directory, va + PAGE_SIZE*i, &ptr_pg_table);
		ptr_shared_object->framesStorage[i] = cur_frame;
	}


	//acquire_kspinlock(&AllShares.shareslock);
	LIST_INSERT_TAIL(&AllShares.shares_list, ptr_shared_object);

	release_kspinlock(&AllShares.shareslock);

	//cprintf("\n\n after allocating: ");
	//print_allshare();

	return ptr_shared_object->ID;
	// This function should create the shared object at the given virtual address with the given size
	// and return the ShareObjectID
	// RETURN:
	//	a) ID of the shared object (its VA after masking out its msb) if success
	//	b) E_SHARED_MEM_EXISTS if the shared object already exists
	//	c) E_NO_SHARE if failed to create a shared object
#else
	panic("not handled when KERN HEAP is disabled");
#endif

}

//======================
// [5] Get Share Object:
//======================
int get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
#if USE_KHEAP
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #5 get_shared_object
	//Your code is here
	//Comment the following line
	//panic("get_shared_object() is not implemented yet...!!");
	struct Env* myenv = get_cpu_proc(); //The calling

	//cprintf("\ncurrent shared list: ");
	//print_allshare();

	struct Share* ptr_shared_object = find_share(ownerID, shareName);

	if(ptr_shared_object == NULL){
		return E_SHARED_MEM_NOT_EXISTS;
	}

	uint32 size = ROUNDUP(ptr_shared_object->size, PAGE_SIZE);
	int framesCount = size / PAGE_SIZE;
	uint32 va = (uint32)virtual_address;

	int perm = PERM_UHPAGE|PERM_USER;
	if(ptr_shared_object->isWritable) perm|=PERM_WRITEABLE;

	for (int i = 0; i < framesCount; ++i){
		uint32* ptr_pg_table = NULL;
		int ret = get_page_table(myenv->env_page_directory, va + PAGE_SIZE*i, &ptr_pg_table);
		if(ret == TABLE_NOT_EXIST){
			ptr_pg_table = create_page_table(myenv->env_page_directory, va + PAGE_SIZE*i);
		}
		int r = map_frame(myenv->env_page_directory,ptr_shared_object->framesStorage[i],va + PAGE_SIZE*i,perm);
		ptr_shared_object->framesStorage[i]->references++;
	}
	ptr_shared_object->references++;
	return ptr_shared_object->ID;
	// 	This function should share the required object in the heap of the current environment
	//	starting from the given virtual_address with the specified permissions of the object: read_only/writable
	// 	and return the ShareObjectID
	// RETURN:
	//	a) ID of the shared object (its VA after masking out its msb) if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists
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
//delete the given shared object from the "shares_list"
//it should free its framesStorage and the share object itself
void free_share(struct Share* ptrShare)
{
#if USE_KHEAP
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - free_share
	//Your code is here
	//Comment the following line
	panic("free_share() is not implemented yet...!!");
	acquire_kspinlock(&AllShares.shareslock);
	LIST_REMOVE(&AllShares.shares_list, ptrShare);
	kfree(ptrShare);
	release_kspinlock(&AllShares.shareslock);
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
			//cprintf("shared var name = %s compared with %s\n", name, shr->name);
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

	struct Env* myenv = get_cpu_proc(); //The calling environment

	struct Share* shr_to_del = get_share_object_ID(sharedObjectID);
	if(shr_to_del==NULL) return E_SHARED_MEM_NOT_EXISTS;


	uint32 size = ROUNDUP(shr_to_del->size, PAGE_SIZE);
	int framesCount = size / PAGE_SIZE;
	uint32 va = (uint32)startVA;

	for (int i = 0; i < framesCount; ++i){
		unmap_frame(myenv->env_page_directory,va + PAGE_SIZE*i);
	}
	shr_to_del->references--;

	if(shr_to_del->references == 0){
		for (int i = 0; i< framesCount; ++i){
			free_frame(shr_to_del->framesStorage[i]);
		}
		kfree(shr_to_del->framesStorage);
		free_share(shr_to_del);
	}
	tlbflush();
	return 0;
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
