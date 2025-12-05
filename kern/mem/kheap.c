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
uint32 ka2ep__add[1024*1024];
struct sleeplock kmallocSle;
struct sleeplock VaSle,PaSle;

void kheap_init()
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		for(uint32 i=0;i<1024*1024;i++){
			ka2ep__add[i] = 0;
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
struct kheap_page khop__page[arrSize];

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
    ka2ep__add[f_idx] = page_va;
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
    		ka2ep__add[f_idx] = 0;
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
void kheap__aloc(uint32 ztart,uint32 end,uint32 size,int flag){
	//cprintf("in fun\n");
    for (uint32 k = ztart; k < end + flag * PAGE_SIZE; k += PAGE_SIZE) {
    	/*struct FrameInfo *NewFrame=NULL;
    	allocate_frame(&NewFrame);
    	map_frame(ptr_page_directory,NewFrame,k,PERM_PRESENT|PERM_WRITEABLE);*/
    	int r = get_page((uint32*)k);

    	//cprintf("pa: %x --- va: %x\n",kheap_physical_address(k)>>12,k);
    	//cprintf("arr: %x\n",kheap_address[(kheap_physical_address(k)>>12)]);

        khop__page[(k - kheapPageAllocStart) / PAGE_SIZE].allocated = 1;
        khop__page[(k - kheapPageAllocStart) / PAGE_SIZE].size = size;
        khop__page[(k - kheapPageAllocStart) / PAGE_SIZE].va = ztart;
    	//kheap_address[(kheap_physical_address(k)>>12)] = k;


        // If I have 3KB allocated then what is the fit algo (worst or exact)
	}
	//cprintf("out fun\n");

}
void* kmalloc(unsigned int size)
{
	/*cprintf("Memory Start///////////// %x\n");
	uint32 k=-1;
	for(uint32 i = kheapPageAllocStart;i< kheapPageAllocBreak;i+= PAGE_SIZE){
		if(kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va !=k){
			cprintf("VA: %x, %x, %d\n",kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
					,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].size + kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
					,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated);
			k = kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va;
		}
	}
	cprintf("Memory END ///////////////////////\n");*/
	acquire_sleeplock(&kmallocSle);
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		uint32 vaa = (uint32)alloc_block(size);
		uint32 pag__va = to_page_va(to_page_info(vaa));
		//kheap_address[kheap_physical_address(page_va) >> 12] = page_va;
		/*cprintf("blk va: %x, of pageVa: %x, idx in kadd: %d\n", va, page_va, kheap_physical_address(page_va) >> 12);*/
		release_sleeplock(&kmallocSle);
		return (uint32 *)vaa;
	}
	else {
		/*if (kheapPageAllocStart == kheapPageAllocBreak) {
			if (kheapPageAllocBreak + ROUNDUP(size, PAGE_SIZE) < KERNEL_HEAP_MAX) {
				kheapPageAllocBreak += ROUNDUP(size, PAGE_SIZE);
			}
			else {
				return NULL;
			}
		}*/
		//////////////////////////Exact Fit//////////////////
		int flag = 0;
		uint32 startva = kheapPageAllocStart;
		int j = 0;
		int FExactFit = 0;
		int FworstFit = 0;
		uint32 ZumOfZizes = 0;   //3KB ->
		for (uint32 i = kheapPageAllocStart; i < kheapPageAllocBreak && j < arrSize; i += PAGE_SIZE, j++) {

			if (khop__page[j].allocated !=1) {

				ZumOfZizes += PAGE_SIZE;
				if (flag !=1) {  //
					startva = i;
					flag = 1;
				}
				if (ZumOfZizes == ROUNDUP(size,PAGE_SIZE) && (j + 1 < arrSize && khop__page[j + 1].allocated == 1)) {
					kheap__aloc(startva,i,size,1);
					//cprintf("Exact fit: %u\n",size);
					release_sleeplock(&kmallocSle);
					return (uint32*)startva;
				}
			}
			else {
				flag = 0;
				ZumOfZizes = 0;
			}
		}

		/////////////////////////////////worst fit///////////////////////////////
		uint32 A7rak = 0;
		uint32 StartOfMaxVa;
		j = 0;
		//cprintf("Worzt \n");
		ZumOfZizes = 0;
		flag = 0;
		for (uint32 i = kheapPageAllocStart; i < kheapPageAllocBreak && j < arrSize; i += PAGE_SIZE, j++) {
			//cprintf("start of loop\n");
			if (!khop__page[j].allocated) {
				ZumOfZizes += PAGE_SIZE;
				if (A7rak < ZumOfZizes) {
					A7rak = ZumOfZizes;
					StartOfMaxVa = startva;
				}
				if (flag !=1) {
					///g3g3
					startva = i;
					flag = 1;
				}
			}
			else {
				flag = 0;
				ZumOfZizes = 0;
			}

		}
		if (A7rak > size) {
			kheap__aloc(StartOfMaxVa,StartOfMaxVa+ROUNDUP(size,PAGE_SIZE),size,0);
			//cprintf("Start Va: %x\n",StartOfMaxVa);
			//cprintf("End: %x\n",StartOfMaxVa+ROUNDUP(size,PAGE_SIZE));
			//cprintf("Worst fit: %u\n  ",size);
			release_sleeplock(&kmallocSle);
			return (uint32*)StartOfMaxVa;
		}
		////////////////////Extend/////////////////////////////////
		if(ROUNDUP(size,PAGE_SIZE) <= (KERNEL_HEAP_MAX-kheapPageAllocBreak)){
			//cprintf("Extend Break:%x\n",kheapPageAllocBreak);
			startva = kheapPageAllocBreak;
			kheapPageAllocBreak +=ROUNDUP(size,PAGE_SIZE);
			kheap__aloc(startva,kheapPageAllocBreak,size,1);
			release_sleeplock(&kmallocSle);
			return (uint32*)startva;
		}
		/*cprintf("Memory Start///////////// %x\n");
		uint32 k=-1;
		for(uint32 i = kheapPageAllocStart;i< kheapPageAllocBreak;i+= PAGE_SIZE){
			if(kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va !=k){
				cprintf("VA: %x, %x, %d\n",kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
						,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].size + kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
						,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated);
				k = kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va;
			}
		}
		cprintf("Memory END ///////////////////////\n");*/
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
		/*
		if(elm->num_of_free_blocks + 1 == PAGE_SIZE/elm->block_size){
			kheap_address[kheap_physical_address(va)>>12] = 0;
		}
		*/
		free_block(virtual_address);
		release_sleeplock(&kmallocSle);
		return;
	}
	if(va<kheapPageAllocStart||va>=kheapPageAllocBreak /*!kheap_pages[(va - kheapPageAllocStart)/PAGE_SIZE].allocated*/){
		/*cprintf("Memory Start///////////// va: %x  break: %x start: %x\n",virtual_address,kheapPageAllocBreak,kheapPageAllocStart);
		uint32 k=-1;
		for(uint32 i = kheapPageAllocStart;i< kheapPageAllocBreak;i+= PAGE_SIZE){
			if(kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va !=k){
				cprintf("VA: %x, %x, %d\n",kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
						,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].size + kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
						,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated);
				k = kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va;
			}
		}
		cprintf("Memory END ///////////////////////\n");*/
		panic("not in range");
	}
	Size=khop__page[(va - kheapPageAllocStart)/PAGE_SIZE].size;
	if(Size % PAGE_SIZE !=0){
		page_cnt = (Size/PAGE_SIZE) + 1;
	}
	else {
		page_cnt = (Size/PAGE_SIZE);
	}
	//cprintf("%x\n",kheap_pages[j].va);
	//cprintf("%d\n",kheap_pages[j].size/PAGE_SIZE);
	//m=j;

	for(uint32 i=va;i < va + page_cnt*PAGE_SIZE;i += PAGE_SIZE){
		//kheap_address[(kheap_physical_address(i)>>12)] = 0;
		return_page((uint32*)i);
		khop__page[(i - kheapPageAllocStart)/PAGE_SIZE].allocated=0;
		khop__page[(i - kheapPageAllocStart)/PAGE_SIZE].va=0;
		khop__page[(i - kheapPageAllocStart)/PAGE_SIZE].size=0;
	}
///////////////////////////////////Check Break Arsanious///////////////////////////////////////////////////////////

	uint32 NexPagva = va + (page_cnt)*PAGE_SIZE;
	if(NexPagva == kheapPageAllocBreak){
		for(uint32 i = kheapPageAllocBreak-PAGE_SIZE; i>= kheapPageAllocStart;i -=PAGE_SIZE){
			if(khop__page[(i - kheapPageAllocStart)/PAGE_SIZE].allocated){
				kheapPageAllocBreak = i + PAGE_SIZE;
				break;
			}
		}
		if(NexPagva == kheapPageAllocBreak){
			kheapPageAllocBreak = kheapPageAllocStart;
		}

	}
	release_sleeplock(&kmallocSle);
	/*cprintf("Memory Start After///////////// %x\n",virtual_address);
				 k=-1;
				for(uint32 i = kheapPageAllocStart;i< kheapPageAllocBreak;i+= PAGE_SIZE){
					if(kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va !=k){
						cprintf("VA: %x, %x, %d\n",kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
								,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].size + kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va
								,kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].allocated);
						k = kheap_pages[(i - kheapPageAllocStart)/PAGE_SIZE].va;
					}
				}
				cprintf("Memory END After///////////////////////\n");*/

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
	uint32 offzet=physical_address & 0xFFF;
	uint32 fnum=physical_address>>12;
	uint32 va = (ka2ep__add[fnum]&~0xFFF)|offzet;
	if(ka2ep__add[fnum]!=0){
		release_sleeplock(&VaSle);
		return va;
	}
	release_sleeplock(&VaSle);
	return 0;
	/*for (uint32 i = 0; i < (1024 * 1024); i++){
		cprintf("%d\n",i);

		if ((vpt[i] & 0xFFFFF000) == fnum)
		{
			return (i << PGSHIFT) | offset;
		}
	}*/
	//panic("kheap_virtual_address() is not implemented yet...!!");

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

		if(ret == TABLE_NOT_EXIST||!khop__page[(virtual_address - kheapPageAllocStart)/PAGE_SIZE].allocated){
			release_sleeplock(&PaSle);
			return 0;
			//ptr_page_table = create_page_table(ptr_page_directory, (uint32)virtual_address);
		}
		uint32 pagFNum = ptr_page_table[PTX(virtual_address)]&(0xFFFFF000);
		release_sleeplock(&PaSle);
		return (pagFNum | PGOFF(virtual_address));
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

		// if the block not allocated before
		// if(virtual_address < allocStartAdd || virtual_address >= allocEndAdd) return 0;
		uint32 *ptr_page_table = NULL;
		int ret = get_page_table(ptr_page_directory, (uint32)virtual_address, &ptr_page_table);
		if(ret == TABLE_NOT_EXIST){
			cprintf("TABLE_NOT_EXIST\n");
			release_sleeplock(&PaSle);
			return 0;
		}
		uint32 pagFNum = ptr_page_table[PTX(virtual_address)]&(0xFFFFF000);
		release_sleeplock(&PaSle);
		return (pagFNum | PGOFF(virtual_address));
		/*
		struct PageInfoElement* elm = to_page_info(virtual_address);
		uint32 allocatedBlocks = PAGE_SIZE/elm->block_size - elm->num_of_free_blocks;
		uint32 allocatedSize = elm->block_size * allocatedBlocks; //offset
		int idx = 0;
		for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
			if ((1 << i) == elm->block_size)
				break;
			 idx++;
		}
		uint32 page_va = to_page_va(elm);
		uint32 *ptr_page_table = NULL;
		int ret = get_page_table(ptr_page_directory, (uint32)virtual_address, &ptr_page_table);
		if(ret == TABLE_NOT_EXIST){
			cprintf("TABLE_NOT_EXIST\n");
			return 0;
		}
		uint32 startAddress = ROUNDDOWN(page_va, PAGE_SIZE);
		uint32 endAddress = startAddress + (uint32)elm->block_size * (uint32)elm->num_of_free_blocks;
		if(virtual_address >= startAddress && virtual_address < endAddress){
			struct BlockElement* blk = LIST_FIRST(&freeBlockLists[idx]);
			for (int i = 0; i < freeBlockLists[idx].size; ++i){
				if((uint32)blk == virtual_address) return 0;
				blk = LIST_NEXT(blk);
			}
			uint32 pageFrameNum = ptr_page_table[PTX(virtual_address)]&(0xFFFFF000);
			return (pageFrameNum | PGOFF(virtual_address));

		}
		  if(elm->num_of_free_blocks == 0){
			endAddress += PAGE_SIZE;
		}
		*/
	}
	release_sleeplock(&PaSle);
	return 0;

	//panic("kheap_physical_address() is not implemented yet...!!");
}

/*unsigned int PaToVa(unsigned int idx){
	return
}*/

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
