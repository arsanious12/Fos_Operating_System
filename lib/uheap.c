#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;

struct uheap_page{

	int marked;
	uint32 va;
	uint32 size;
};
struct uheap_page uheap_pages[NUM_OF_UHEAP_PAGES];
bool uheap[1024*1024];

void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;

		__firstTimeFlag = 0;
		for (int i = 0; i < 1024*1024; ++i) uheap[i] = 0;
		for(uint32 i=0;i<=NUM_OF_UHEAP_PAGES;i++){
			uheap_pages[i].marked = 0;
			uheap_pages[i].size = 0;
			uheap_pages[i].va = 0;



		}


	}
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
		panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================


void mark_uheap(uint32 startva,uint32 end,uint32 size,int flag){
	uint32 k;
	for (k = startva; k < end + flag * PAGE_SIZE; k += PAGE_SIZE) {
		 uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].marked = 1;
		 uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].size = size;
		 uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].va = startva;

	}
	sys_allocate_user_mem(startva,ROUNDUP(size,PAGE_SIZE));

}

void* malloc(uint32 size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	/*panic("malloc() is not implemented yet...!!");*/
	//////////////////////////dyn..alloc..//////////////////////////////
	if(size<=DYN_ALLOC_MAX_BLOCK_SIZE){
		uint32 vra=(uint32)alloc_block(size);
		return (uint32 *)vra;
		}
	/////////////////////////////page///////////////////////////////////////////////

	else{
		///////////////////////////////////exact///////////////////////////////////

	int flag =0;
	uint32 startva = uheapPageAllocStart;
	int j =0;
	int FoundExactFit = 0;
	int FoundworstFit = 0;
	uint32 SumOfSizes = 0;

	for (uint32 i = uheapPageAllocStart; i < uheapPageAllocBreak && j < NUM_OF_UHEAP_PAGES; i += PAGE_SIZE, j++){
		if (uheap_pages[j].marked !=1) {

			SumOfSizes += PAGE_SIZE;
			if (flag !=1) {
				startva = i;
				flag = 1;
			}
		if (SumOfSizes == ROUNDUP(size,PAGE_SIZE) && (j + 1 < NUM_OF_UHEAP_PAGES && uheap_pages[j + 1].marked == 1)) {

			mark_uheap(startva,i,size,1);
			return (uint32*)startva;



			}
		}
		else {
			flag = 0;
			SumOfSizes = 0;
		}

	}
	//////////////////////////////////////////worst///////////////////////////////////
uint32 maxsize = 0;
uint32 StartOfMaxVa;
		j = 0;

		SumOfSizes = 0;
		flag = 0;
	for (uint32 i = uheapPageAllocStart; i < uheapPageAllocBreak && j < NUM_OF_UHEAP_PAGES; i += PAGE_SIZE, j++) {

		if (!uheap_pages[j].marked) {
			SumOfSizes += PAGE_SIZE;
			if (maxsize < SumOfSizes) {
				maxsize = SumOfSizes;
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
		if (maxsize > size) {
			mark_uheap(StartOfMaxVa,StartOfMaxVa+ROUNDUP(size,PAGE_SIZE),size,0);
			return (uint32*)StartOfMaxVa;

		}
		/////////////////////////////////////////Extend/////////////////////////////////
		if(ROUNDUP(size,PAGE_SIZE) <= (USER_HEAP_MAX-uheapPageAllocBreak)){
			//cprintf("cancelooooooooooooooooo \n");

			startva = uheapPageAllocBreak;
			uheapPageAllocBreak +=ROUNDUP(size,PAGE_SIZE);
			mark_uheap(startva,uheapPageAllocBreak,size,1);
			return (uint32*)startva;

		}
	}
	return NULL;

	}



//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	//panic("free() is not implemented yet...!!");
	uint32 vra = (uint32) virtual_address;
	uint32 size = 0;
	int ct=0;
		if(vra >= dynAllocStart && vra < dynAllocEnd){
			struct PageInfoElement* elm = to_page_info(vra);
			free_block(virtual_address);
			return;
		}
	if(vra<uheapPageAllocStart||vra>=uheapPageAllocBreak ){
		panic("invalid address");
	}
	else{
		size=uheap_pages[(vra - uheapPageAllocStart)/PAGE_SIZE].size;
		if(size % PAGE_SIZE !=0){
				ct = (size/PAGE_SIZE) + 1;
			}
			else {
				ct = (size/PAGE_SIZE);
			}
	for(uint32 i=vra;i < vra + ct*PAGE_SIZE;i += PAGE_SIZE){
		size=uheap_pages[(vra - uheapPageAllocStart)/PAGE_SIZE].size;
		sys_free_user_mem(i,size);
		uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].marked=0;
		uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].va=0;
		uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].size=0;

		}
	uint32 NextPageVa = vra + (ct)*PAGE_SIZE;
		if(NextPageVa == uheapPageAllocBreak){
		for(uint32 i = uheapPageAllocBreak-PAGE_SIZE; i>= uheapPageAllocStart;i -=PAGE_SIZE){
			if(uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].marked){
				uheapPageAllocBreak = i + PAGE_SIZE;
				break;
			}
		}
			if(NextPageVa == uheapPageAllocBreak){
			uheapPageAllocBreak = uheapPageAllocStart;
			}
	}

     }
}
int is_allocated(uint32 va){
	return uheap[va >> 12];
}
//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================


	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
}


//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//


//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
	panic("realloc() is not implemented yet...!!");
}


//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
