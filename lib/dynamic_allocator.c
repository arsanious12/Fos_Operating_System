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
// [1] GET PAGE VA
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
    if (ptrPageInfo < &pageBlockInfoArr[0] ||
        ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE / PAGE_SIZE])
        panic("to_page_va called with invalid pageInfoPtr");

    int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
    return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
}

//==================================
// [2] GET PAGE INFO OF PAGE VA
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
    int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
    if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE / PAGE_SIZE)
        panic("to_page_info called with invalid va");

    return &pageBlockInfoArr[idxInPageInfoArr];
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===========================
// h) Get index by block size
//===========================
int get_idx_by_size(uint32 size)
{
    int idx = 0;
    for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i)
    {
        if ((1 << i) >= size) break;
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

	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize free block lists for each size
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i)
	{
		LIST_INIT(&freeBlockLists[i]);
	}

	// Initialize page info array and add pages to freePagesList
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	for (int i = 0; i < pCount; ++i)
	{
		pageBlockInfoArr[i].block_size = 0;
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
}

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	struct PageInfoElement* pg_t=to_page_info((uint32)va);
	return pg_t->block_size;
	//panic("get_block_size() Not implemented yet");
}

// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================

void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
	uint32 pg_va = to_page_va(pageInfo);
	get_page((uint32 *)pg_va);

	int num_blocks = PAGE_SIZE / blk_size;

	pageInfo->num_of_free_blocks = num_blocks;
	pageInfo->block_size = blk_size;

	int idx = get_idx_by_size(blk_size);

	for (uint32 i = 0; i < num_blocks; ++i)
	{
		struct BlockElement *blk = (struct BlockElement *)(pg_va + i * blk_size);
		LIST_INSERT_TAIL(&freeBlockLists[idx], blk);
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
	int idx = get_idx_by_size(size);

	// Case 1: free block available in requested size
	if (freeBlockLists[idx].size > 0)
	{
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
		LIST_REMOVE(&freeBlockLists[idx], blk);

		struct PageInfoElement *pg = to_page_info((uint32)blk);
		pg->num_of_free_blocks--;
		return blk;
	}

	// Case 2: no free block but free pages available
	if (freePagesList.size > 0)
	{
		struct PageInfoElement *pg = LIST_FIRST(&freePagesList);
		LIST_REMOVE(&freePagesList, pg);

		split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), pg);

		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
		LIST_REMOVE(&freeBlockLists[idx], blk);

		struct PageInfoElement *pg_res = to_page_info((uint32)blk);
		pg_res->num_of_free_blocks--;
		return blk;
	}

	// Case 3: try larger block sizes
	while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE))
	{
		if (freeBlockLists[idx].size > 0)
		{
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
			LIST_REMOVE(&freeBlockLists[idx], blk);

			struct PageInfoElement *pg = to_page_info((uint32)blk);
			pg->num_of_free_blocks--;
			return blk;
		}
		idx++;
	}

	// Case 4: no free blocks/pages available
	panic("no free blocks!");
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
	struct BlockElement *blk = (struct BlockElement *)va;
	struct PageInfoElement *pg = to_page_info((uint32)va);
	uint32 blk_size = pg->block_size;
	int idx = get_idx_by_size(blk_size);

	pg->num_of_free_blocks++;
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk);

	// If all blocks are free, return page
	int total_blocks = PAGE_SIZE / blk_size;
	if (pg->num_of_free_blocks == total_blocks)
	{
		uint32 pg_va = to_page_va(pg);
		for (uint32 i = 0; i < PAGE_SIZE; i += blk_size)
		{
			struct BlockElement *b = (struct BlockElement *)(pg_va + i);
			LIST_REMOVE(&freeBlockLists[idx], b);
		}

		pg->block_size = 0;
		pg->num_of_free_blocks = 0;

		LIST_INSERT_TAIL(&freePagesList, pg);
		return_page((uint32 *)pg_va);
	}
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
