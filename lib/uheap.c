#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;

struct uheap_page{

	int mkd;
	uint32 vrrdd;
	uint32 sz;
};
struct uheap_page uheap_pages[NUM_OF_UHEAP_PAGES];
//bool uheap[1024*1024];

void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;
		__firstTimeFlag = 0;
		//for (int i = 0; i < 1024*1024; ++i) uheap[i] = 0;
		//b3rf el struct &arr
		for(uint32 i=0;i<NUM_OF_UHEAP_PAGES;i++){
			uheap_pages[i].mkd= 0;
			uheap_pages[i].sz= 0;
			uheap_pages[i].vrrdd= 0;
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

////bdl kol shwya aktb
void mark_uheap(uint32 startva,uint32 end,uint32 size,int flag){
	uint32 messi;
	for (messi=startva;messi<end+flag*PAGE_SIZE;messi+=PAGE_SIZE) {

		 //uheap[(k - uheapPageAllocStart) / PAGE_SIZE] = 1;
		 uheap_pages[(messi-uheapPageAllocStart)/PAGE_SIZE].mkd=1;
		 uheap_pages[(messi-uheapPageAllocStart)/PAGE_SIZE].sz=size;
		 uheap_pages[(messi-uheapPageAllocStart)/PAGE_SIZE].vrrdd=startva;

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


	else{
		///////////////////////////////////exacttttttttttttttttt///////////////////////////////////

	int flag=0;
	uint32 startva=uheapPageAllocStart;
	int j=0;
	int doctor=0;//efit
	int mohndes=0;//wfit
	uint32 totals=0;


	for (uint32 i=uheapPageAllocStart;i<uheapPageAllocBreak&&j<NUM_OF_UHEAP_PAGES;i+=PAGE_SIZE,j++){
		if (uheap_pages[j].mkd!=1) {
			totals+=PAGE_SIZE;
			if (flag!=1) {
				startva=i;
				flag=1;
			}
		if (totals==ROUNDUP(size,PAGE_SIZE)&& (j +1<NUM_OF_UHEAP_PAGES&& uheap_pages[j +1].mkd==1)) {
			mark_uheap(startva,i,size,1);
			//cprintf("%d\n",totals);
			return (uint32*)startva;
			}
		}
		else {
			flag=0;
			totals=0;
		}

	}
	//////////////////////////////////////////worsttttttttttttttt///////////////////////////////////
uint32 m_s_w_f=0;
uint32 Start_m_s_w_f_Va;
		j = 0;

		totals=0;
		flag=0;
	for (uint32 i=uheapPageAllocStart; i<uheapPageAllocBreak&&j<NUM_OF_UHEAP_PAGES;i+=PAGE_SIZE,j++) {

		if (!uheap_pages[j].mkd) {
			totals += PAGE_SIZE;
			if (m_s_w_f<totals) {
				m_s_w_f=totals;
				Start_m_s_w_f_Va=startva;
			}
		 if (flag!=1) {
			startva=i;
				flag=1;
				}
			}
			else {
				flag=0;
				totals=0;
			}

		}
		if (m_s_w_f >size) {
			mark_uheap(Start_m_s_w_f_Va,Start_m_s_w_f_Va+ROUNDUP(size,PAGE_SIZE),size,0);
			//cprintf("%d\n",Start_m_s_w_f_Va);
			return (uint32*)Start_m_s_w_f_Va;

		}
		/////////////////////////////////////////move break/////////////////////////////////
		if(ROUNDUP(size,PAGE_SIZE)<=(USER_HEAP_MAX-uheapPageAllocBreak)){
			//cprintf("cancelooooooooo \n");
			startva = uheapPageAllocBreak;
			uheapPageAllocBreak+=ROUNDUP(size,PAGE_SIZE);
			mark_uheap(startva,uheapPageAllocBreak,size,1);
			return(uint32*)startva;

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
	uint32 rm_addr=0;
		if(vra>=dynAllocStart&&vra<dynAllocEnd){
			free_block(virtual_address);
			return;
		}
	if(vra<uheapPageAllocStart||vra>=uheapPageAllocBreak ){
		panic("invalid address");
	}
	else{
		size=uheap_pages[(vra-uheapPageAllocStart)/PAGE_SIZE].sz;
		if(size%PAGE_SIZE!=0){
				ct=(size/PAGE_SIZE)+1;
			}
			else {
				ct=(size/PAGE_SIZE);
			}
	for(uint32 i=vra;i < vra + ct*PAGE_SIZE;i += PAGE_SIZE){
		size=uheap_pages[(vra - uheapPageAllocStart)/PAGE_SIZE].sz;
		rm_addr=i;
		sys_free_user_mem(rm_addr,size);

		//uheap[(i - uheapPageAllocStart)/PAGE_SIZE] = 0;

		uheap_pages[(rm_addr-uheapPageAllocStart)/PAGE_SIZE].mkd=0;
		uheap_pages[(rm_addr-uheapPageAllocStart)/PAGE_SIZE].vrrdd=0;
		uheap_pages[(rm_addr-uheapPageAllocStart)/PAGE_SIZE].sz=0;


		}

	uint32 nep=vra+(ct)*PAGE_SIZE;
	/////////////////hrag3 el break///////////////////////////////
		if(nep==uheapPageAllocBreak){
		for(uint32 i=uheapPageAllocBreak-PAGE_SIZE; i>=uheapPageAllocStart;i-=PAGE_SIZE){
			if(uheap_pages[(i-uheapPageAllocStart)/PAGE_SIZE].mkd){
				uheapPageAllocBreak=i +PAGE_SIZE;
				break;
			}
		}
			if(nep==uheapPageAllocBreak){
			uheapPageAllocBreak=uheapPageAllocStart;
			}
	}

     }
}

int is_allocated(uint32 va){
	return uheap_pages[(va - uheapPageAllocStart) >> 12].mkd;
}

//int entrance_count = 0;
//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//cprintf("env id is : %d\n", sys_getenvid());
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//=============================================================
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	// Your code is here
	 uint32 srt=uheapPageAllocStart;
	uint32 nd=uheapPageAllocBreak;
	size=ROUNDUP(size, PAGE_SIZE);


    int r = sys_size_of_shared_object(sys_getenvid(), sharedVarName);
    if(r >= 1) return NULL;
	//cprintf("size: %d\n", r);

	///hansearch 3la ely adha bzabt..
	uint32 re = 0;
	for (uint32 i=srt; i<nd;){
		if(!is_allocated(i)){
			// el j htstrt mn i.> double pointer
			uint32 j=i;
			uint32 gp_span =0;//calc space bet j and i..
			while(j < nd &&!is_allocated(j)) {//j bt3ady 3la el not alloc
				j +=PAGE_SIZE;
			}
			gp_span =j-i; // diff betw. 2 pointers.
			if(gp_span ==size) { // if exact found..
				re=i;
				break;
			}
			i =j; // jump over gap-> to j..
		}else{
			i +=PAGE_SIZE;////lw i alloc zawd page_size.. iteerate..
		}
	}
	if(re==0) {
		//lw ml'ash value y3mal
		uint32 max_size=0;
		for (uint32 i=srt;i <nd;){ // it mn startl 7d end
			if(!is_allocated(i)){ // lw it not alloc
				uint32 j =i;
				uint32 gp_span =0;
				while(j < nd &&!is_allocated(j)){//j bt3ady 3la el not alloc
					j +=PAGE_SIZE;
				}
				gp_span =j-i; ///diff betw.2 pointers.
				if(gp_span>=size && gp_span > max_size){ // lw el msafa el fadya akber mn ely etsagelt..
					re= i;
					max_size =gp_span;
				}
				i =j;
			} else {
				i +=PAGE_SIZE;
			}
		}
	}

	if(re == 0){ // lw no value found extedn logic lw size + break asghar mn el max.. accetpted
		uint32 nds =size+uheapPageAllocBreak;
		if(nds<=USER_HEAP_MAX){
			re = uheapPageAllocBreak;
			uheapPageAllocBreak += size;
		}
	}
	if(re == 0) return NULL;

	int ret = sys_create_shared_object(sharedVarName, size, isWritable, (uint32*)re);
	if(ret == E_NO_SHARE) return NULL;


	mark_uheap(re, re+size, size, 0);
	//cprintf("%s successfully allocated in %x\n", sharedVarName, res_address);
	return (uint32*) re;
	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//cprintf(" ===== sget %s called and env id is : %d\n", sharedVarName,sys_getenvid());
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================

	int shr_size = sys_size_of_shared_object(ownerEnvID, sharedVarName);
	if(shr_size == E_SHARED_MEM_NOT_EXISTS){
		return NULL;
	}

	 uint32 srt=uheapPageAllocStart;
	uint32 nd=uheapPageAllocBreak;
	uint32 size=ROUNDUP(shr_size, PAGE_SIZE);

    ///hansearch 3la ely adha bzabt..
	uint32 re = 0;
	for (uint32 i=srt; i<nd;){
		if(!is_allocated(i)){
			// el j htstrt mn i.> double pointer
			uint32 j=i;
			uint32 gp_span =0;//calc space bet j and i..
			while(j < nd &&!is_allocated(j)) {//j bt3ady 3la el not alloc
				j +=PAGE_SIZE;
			}
			gp_span =j-i; // diff betw. 2 pointers.
			if(gp_span ==size) { // if exact found..
				re=i;
				break;
			}
			i =j; // jump over gap-> to j..
		}else{
			i +=PAGE_SIZE;////lw i alloc zawd page_size.. iteerate..
		}
	}
	if(re==0) {
		//lw ml'ash value y3mal
		uint32 max_size=0;
		for (uint32 i=srt;i <nd;){ // it mn startl 7d end
			if(!is_allocated(i)){ // lw it not alloc
				uint32 j =i;
				uint32 gp_span =0;
				while(j < nd &&!is_allocated(j)){//j bt3ady 3la el not alloc
					j +=PAGE_SIZE;
				}
				gp_span =j-i; ///diff betw.2 pointers.
				if(gp_span>=size && gp_span > max_size){ // lw el msafa el fadya akber mn ely etsagelt..
					re= i;
					max_size =gp_span;
				}
				i =j;
			} else {
				i +=PAGE_SIZE;
			}
		}
	}

	if(re==0) { // lw no value found extedn logic lw size + break asghar mn el max.. accetpted
		uint32 nds =size+uheapPageAllocBreak;
		if(nds<=USER_HEAP_MAX){
			re = uheapPageAllocBreak;
			uheapPageAllocBreak +=size;
		}
	}

	if(re ==0) { // lw msh mwgoda
		return NULL;
	}

	int ret = sys_get_shared_object(ownerEnvID, sharedVarName, (uint32*)re);
	if(ret==E_SHARED_MEM_NOT_EXISTS) { // lw msh feelmem ..
		return NULL;
	}
	mark_uheap(re, re+size, size, 0);

	return (uint32*)re;
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	//panic("sget() is not implemented yet...!!");
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

	//int32 objId = sys_get_shared_object_id(virtual_address);
	//sys_delete_shared_object(objId, virtual_address);
	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
