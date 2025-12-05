/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
			panic("to_page_va called with invalid pageInfoPtr");
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
}

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
		panic("to_page_info called with invalid pa");
	return &pageBlockInfoArr[idxInPageInfoArr];
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//=====================//
// h) get el index for suitable size
//=====================//
int get_idx_by_size(uint32 size){
	 int idx=0;
	for (int i=LOG2_MIN_SIZE; i<=LOG2_MAX_SIZE ; ++i) {
		if((1 << i) >= size) break;
		 idx++;
	}
	return idx;
}



//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
		is_initialized = 1;
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator

	//setup el bounds bta3et el dynamicallocator.
	dynAllocStart= daStart;
	dynAllocEnd= daEnd;

	// binit el freePages 3shan add feha el available pageBlockInfo ..
	LIST_INIT(&freePagesList);

	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	// hninit kol list fel freeblocklists by iterating over each size..
	for (int i=0; i<=(LOG2_MAX_SIZE-LOG2_MIN_SIZE);++i){
		LIST_INIT(&freeBlockLists[i]);
	}

	// 3dad el pages fel dynamic bet el bounds.
	int pCount =(daEnd-daStart)/PAGE_SIZE;
	// hniterate 3la kol pageBlockInfo w n resetaha w push it fel free Pages list.
	for (int i =0;i<pCount; ++i) {
	     pageBlockInfoArr[i].block_size=0;
	     pageBlockInfoArr[i].num_of_free_blocks=0;
	     LIST_INSERT_TAIL(&freePagesList,&pageBlockInfoArr[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// bel virtual address hn get el page info and by el pointer return blk-size. .
	struct PageInfoElement* pg_t=to_page_info((uint32)va);
	// cprintf("%x\n",(uint32)va);
	return pg_t->block_size;
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}

// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
	 //from the pageInfo we get the virtual address. .
	 //w hnsave page in memory.
	 uint32 pgva=(uint32)to_page_va(pageInfo);
	 get_page((uint32*)pgva);

	 // el blk count ely fel page.
	 int cblk=PAGE_SIZE/blk_size;

	 //bnassign el new values fe pageInfo.
	 pageInfo->num_of_free_blocks=cblk;
	 pageInfo->block_size = blk_size;
	 //get el index lel size ..
	 int idx=get_idx_by_size(blk_size);
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the pgva.
	 for(uint32 i=0; i<cblk;++i) {
		 struct BlockElement *b_toA=(struct BlockElement*)(pgva+ i*blk_size);
		 // addign to the list fo suitable size. .
		 LIST_INSERT_TAIL(&freeBlockLists[idx],b_toA);
	 }
 }


//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	//hngeb suitable index for the size..
	int idx = get_idx_by_size(size);

	//((case1):el blk bel size is available)
	if (freeBlockLists[idx].size > 0) {
		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *resBlk=LIST_FIRST(&freeBlockLists[idx]);
	    LIST_REMOVE(&freeBlockLists[idx], resBlk);
	    // update pageBlockInfoArr
	    struct PageInfoElement *pgn = to_page_info((uint32)resBlk);
	    pgn->num_of_free_blocks--;
	    return resBlk;
	}else{///(case2)mfesh free block bs there is available pages.
			//(case3)mfesh freeblks wla pages so-> try sizeup el blk.
		if(freePagesList.size > 0){ //have free pages(case2).
			// get page to split and use from freepagesList.
			struct PageInfoElement *pgn=LIST_FIRST(&freePagesList);
			 LIST_REMOVE(&freePagesList,pgn);
			//from page to freeblockList by the pageInfo and the block size.
			 split_page_to_blocks(1<<(idx+LOG2_MIN_SIZE),pgn);
			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *resBlk=LIST_FIRST(&freeBlockLists[idx]);
		    LIST_REMOVE(&freeBlockLists[idx],resBlk);
		    // update pageBlockInfoArr
		    struct PageInfoElement *ppgn=to_page_info((uint32)resBlk);
		    ppgn->num_of_free_blocks--;
		    return resBlk;
		}else{//(case3):
			// hnincrease el size of power2 as smaller than maxsize and no av. blocks
			while (idx<=(LOG2_MAX_SIZE-LOG2_MIN_SIZE)&&freeBlockLists[idx].size==0) {
				idx++;
				//lw found free block
				if(freeBlockLists[idx].size>0){
				// remove from the list and updat the pageInfoArr free blocks.
				// pop from the freeBlockList.
					struct BlockElement *resBlk = LIST_FIRST(&freeBlockLists[idx]);
					LIST_REMOVE(&freeBlockLists[idx], resBlk);
				// update pageBlockInfoArr
					struct PageInfoElement *pgn=to_page_info((uint32)resBlk);
					pgn->num_of_free_blocks--;
					return resBlk;
				}
			}
		}
	}
	//(case4)lw mfesh el etnin so panic..
	panic("no free blocks!");
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	//sleep(dChannel_blocked);
	return NULL;
}

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	//bel virtual address hngeb el page wel block wl size..
	struct BlockElement* frBlk=(struct BlockElement*)va;
	struct PageInfoElement *pgf=to_page_info((uint32)va);
	uint32 blk_size = pgf->block_size;

	// its index in the freeBlocklist.
	int idx = get_idx_by_size(blk_size);

	//adding el block lel page
	pgf->num_of_free_blocks++;
	LIST_INSERT_TAIL(&freeBlockLists[idx], frBlk);

	//(case)lw all block fe el page free: free el page.
	int blkC=PAGE_SIZE/blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pgf->num_of_free_blocks==blkC) {
		uint32 pgtoF=to_page_va(pgf);
		// remove all blk in the freeBlockList.
		for (uint32 i=0; i<PAGE_SIZE; i+=blk_size) {
			struct BlockElement *blk=(struct BlockElement*)(pgtoF+i);
			LIST_REMOVE(&freeBlockLists[idx],blk);
		}
		// reset page info.
		pgf->block_size = 0;
		pgf->num_of_free_blocks = 0;
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList,pgf);
		// make it available in memory.
		return_page((uint32*)to_page_va(pgf));
	}
	//panic("free_block() Not implemented yet");
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line

	panic("realloc_block() Not implemented yet");
}
