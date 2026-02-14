#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #0 kheap_init [GIVEN]
//Remember to initialize locks (if any)
struct kheap_page{
	int allocated;
	uint32 va;
	uint32 size;
};
uint32 kheap_addresses[1024*1024];
struct sleeplock kmallocSle;
struct sleeplock VaSle,PaSle;

void kheap_init()
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		for(uint32 i=0;i<1024*1024;i++){
			kheap_addresses[i] = 0;
		}
		initialize_dynamic_allocator(KERNEL_HEAP_START, KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE);
		set_kheap_strategy(KHP_PLACE_CUSTOMFIT);
		kheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		kheapPageAllocBreak = kheapPageAllocStart;
		init_sleeplock(&kmallocSle,"kmallocSem");
		init_sleeplock(&VaSle,"VaSem");
		init_sleeplock(&PaSle,"PaSem");

	}
	//==================================================================================
	//==================================================================================
}
#define arrSize (KERNEL_HEAP_MAX - KERNEL_HEAP_START)/PAGE_SIZE
struct kheap_page kheap_pages[arrSize];

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
    uint32 page_va = ROUNDDOWN((uint32)va, PAGE_SIZE);
    int ret = alloc_page(ptr_page_directory, page_va, PERM_WRITEABLE, 1);
    if (ret < 0)
        return ret;
    uint32 *ptr = NULL;
    if (get_page_table(ptr_page_directory, page_va, &ptr) == TABLE_NOT_EXIST)
        panic("get_page: table missing after alloc_page!");

    uint32 f_idx = (ptr[PTX(page_va)]& 0xFFFFF000)>>12;
    kheap_addresses[f_idx] = page_va;
    return 0;
}



//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
    uint32 page_va = ROUNDDOWN((uint32)va, PAGE_SIZE);

    uint32 *ptr = NULL;
    if (get_page_table(ptr_page_directory, page_va, &ptr) == TABLE_IN_MEMORY) {
    	uint32 frame = ptr[PTX(page_va)];
    	if(frame & PERM_PRESENT){
    		uint32 f_idx = (frame & 0xFFFFF000) >> 12;
    		kheap_addresses[f_idx] = 0;
    	}
    }

    unmap_frame(ptr_page_directory, page_va);
}



//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===================================
// [1] ALLOCATE SPACE IN KERNEL HEAP:
//===================================
void kheap_alloc(uint32 start,uint32 end,uint32 size,int flag){

    for (uint32 k = start; k < end + flag * PAGE_SIZE; k += PAGE_SIZE) {

    	int ret = get_page((uint32*)k);
    	kheap_pages[(k - kheapPageAllocStart) / PAGE_SIZE].allocated = 1;
    	kheap_pages[(k - kheapPageAllocStart) / PAGE_SIZE].size = size;
    	kheap_pages[(k - kheapPageAllocStart) / PAGE_SIZE].va = start;
	}

}
void* kmalloc(unsigned int size)
{
	
	acquire_sleeplock(&kmallocSle);
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		uint32 va = (uint32)alloc_block(size);
		uint32 page_va = to_page_va(to_page_info(va));
		release_sleeplock(&kmallocSle);
		return (uint32 *)va;
	}
	else {
		
		//////////////////////////Exact Fit//////////////////
		int flag = 0;
		uint32 startva = kheapPageAllocStart;
		int j = 0;
		//int FExactFit = 0;
		//int FworstFit = 0;
		uint32 SumOfSizes = 0;   
		for (uint32 i = kheapPageAllocStart; i < kheapPageAllocBreak && j < arrSize; i += PAGE_SIZE, j++) {

			if (kheap_pages[j].allocated !=1) {

				SumOfSizes += PAGE_SIZE;
				if (flag !=1) { 
					startva = i;
					flag = 1;
				}
				if (SumOfSizes == ROUNDUP(size,PAGE_SIZE) && (j + 1 < arrSize && kheap_pages[j + 1].allocated == 1)) {
					kheap_alloc(startva,i,size,1);
					release_sleeplock(&kmallocSle);
					return (uint32*)startva;
				}
			}
			else {
				flag = 0;
				SumOfSizes = 0;
			}
		}

		/////////////////////////////////worst fit///////////////////////////////
		uint32 MaxSize = 0;
		uint32 StartOfMaxVa;
		j = 0;
		SumOfSizes = 0;
		flag = 0;
		for (uint32 i = kheapPageAllocStart; i < kheapPageAllocBreak && j < arrSize; i += PAGE_SIZE, j++) {
			if (!kheap_pages[j].allocated) {
				SumOfSizes += PAGE_SIZE;
				if (MaxSize < SumOfSizes) {
					MaxSize = SumOfSizes;
					StartOfMaxVa = startva;
				}
				if (flag !=1) {
					startva = i;
					flag = 1;
				}
			}
			else {
				flag = 0;
				SumOfSizes = 0;
			}

		}
		if (MaxSize > size) {
			kheap_alloc(StartOfMaxVa,StartOfMaxVa+ROUNDUP(size,PAGE_SIZE),size,0);
			release_sleeplock(&kmallocSle);
			return (uint32*)StartOfMaxVa;
		}

		////////////////////Extend/////////////////////////////////
		if(ROUNDUP(size,PAGE_SIZE) <= (KERNEL_HEAP_MAX-kheapPageAllocBreak)){

			startva = kheapPageAllocBreak;
			kheapPageAllocBreak +=ROUNDUP(size,PAGE_SIZE);
			kheap_alloc(startva,kheapPageAllocBreak,size,1);
			release_sleeplock(&kmallocSle);
			return (uint32*)startva;
		}

	}
	release_sleeplock(&kmallocSle);
	return NULL;

	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #1 kmalloc
	//Your code is here
	//Comment the following line
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");

	//TODO: [PROJECT'25.BONUS#3] FAST PAGE ALLOCATOR
}

//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================
void kfree(void* virtual_address)

{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #2 kfree
			//Your code is here
			//Comment the following line
			//panic("kfree() is not implemented yet...!!");
	acquire_sleeplock(&kmallocSle);
	uint32 va = (uint32) virtual_address;
	uint32 Size = 0;
	int page_cnt=0;
	if(va >= dynAllocStart && va < dynAllocEnd){
		struct PageInfoElement* elm = to_page_info(va);
		free_block(virtual_address);
		release_sleeplock(&kmallocSle);
		return;
	}
	if(va<kheapPageAllocStart||va>=kheapPageAllocBreak){
		panic("not in range");
	}
	Size=kheap_pages[(va - kheapPageAllocStart)/PAGE_SIZE].size;
	if(Size % PAGE_SIZE !=0){
		page_cnt = (Size/PAGE_SIZE) + 1;
	}
	else {
		page_cnt = (Size/PAGE_SIZE);
	}

	for(uint32 i=va;i < va + page_cnt*PAGE_SIZE;i += PAGE_SIZE){
		return_page((uint32*)i);
		kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated=0;
		kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va=0;
		kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].size=0;
	}
///////////////////////////////////Check Break///////////////////////////////////////////////////////////

	uint32 NexPageVa = va + (page_cnt)*PAGE_SIZE;
	if(NexPageVa == kheapPageAllocBreak){
		for(uint32 i = kheapPageAllocBreak-PAGE_SIZE; i>= kheapPageAllocStart;i -=PAGE_SIZE){
			if(kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated){
				kheapPageAllocBreak = i + PAGE_SIZE;
				break;
			}
		}
		if(NexPageVa == kheapPageAllocBreak){
			kheapPageAllocBreak = kheapPageAllocStart;
		}

	}
	release_sleeplock(&kmallocSle);

}






//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #3 kheap_virtual_address
	//Your code is here
	//Comment the following line
	//acquire_sleeplock(&VaSle);
	uint32 offset=physical_address & 0xFFF;
	uint32 frame_number=physical_address>>12;
	uint32 va = (kheap_addresses[frame_number]&~0xFFF)|offset;
	if(kheap_addresses[frame_number]!=0){
		release_sleeplock(&VaSle);
		return va;
	}
	release_sleeplock(&VaSle);
	return 0;

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}


//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #4 kheap_physical_address
	//Your code is here
	//Comment the following line
	acquire_sleeplock(&PaSle);
	if(virtual_address >= kheapPageAllocStart && virtual_address < kheapPageAllocBreak){
		uint32 *ptr_page_table = NULL;
		int ret = get_page_table(ptr_page_directory, (uint32)virtual_address, &ptr_page_table);

		if(ret == TABLE_NOT_EXIST||!kheap_pages[(virtual_address - kheapPageAllocStart)/PAGE_SIZE].allocated){
			release_sleeplock(&PaSle);
			return 0;
		}
		uint32 page_FrameNum = ptr_page_table[PTX(virtual_address)]&(0xFFFFF000);
		release_sleeplock(&PaSle);
		return (page_FrameNum | PGOFF(virtual_address));
	}
	else if(virtual_address >= dynAllocStart && virtual_address < dynAllocEnd){
		struct PageInfoElement* elm = to_page_info(virtual_address);

		// if the page not available.
		if(elm->block_size == 0) {
			release_sleeplock(&PaSle);
			return 0;
		}

		uint32 allocStartAdd = to_page_va(elm);
		uint32 allocEndAdd = allocStartAdd + PAGE_SIZE;

		uint32 *ptr_page_table = NULL;
		int ret = get_page_table(ptr_page_directory, (uint32)virtual_address, &ptr_page_table);
		if(ret == TABLE_NOT_EXIST){
			cprintf("TABLE_NOT_EXIST\n");
			release_sleeplock(&PaSle);
			return 0;
		}
		uint32 page_FrameNum = ptr_page_table[PTX(virtual_address)]&(0xFFFFF000);
		release_sleeplock(&PaSle);
		return (page_FrameNum | PGOFF(virtual_address));
	}
	release_sleeplock(&PaSle);
	return 0;

}


//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

extern __inline__ uint32 get_block_size(void *va);

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line
	panic("krealloc() is not implemented yet...!!");
}
