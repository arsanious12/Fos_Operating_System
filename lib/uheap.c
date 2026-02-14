#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP
//==============================================
int __firstTimeFlag = 1;

struct uheap_page {
    int marked;
    uint32 va;
    uint32 size;
};
struct uheap_page uheap_pages[NUM_OF_UHEAP_PAGES];

void uheap_init() {
    if (__firstTimeFlag) {
        initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
        uheapPlaceStrategy = sys_get_uheap_strategy();
        uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
        uheapPageAllocBreak = uheapPageAllocStart;
        __firstTimeFlag = 0;

        for (uint32 i = 0; i < NUM_OF_UHEAP_PAGES; i++) {
            uheap_pages[i].marked = 0;
            uheap_pages[i].size = 0;
            uheap_pages[i].va = 0;
        }
    }
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL
//==============================================
int get_page(void* va) {
    int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE | PERM_UHPAGE);
    if (ret < 0)
        panic("get_page() in user: failed to allocate page from the kernel");
    return 0;
}

//==============================================
// [3] RETURN A PAGE TO THE KERNEL
//==============================================
void return_page(void* va) {
    int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
    if (ret < 0)
        panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void mark_uheap(uint32 startva, uint32 end, uint32 size, int flag) {
    for (uint32 k = startva; k < end + flag * PAGE_SIZE; k += PAGE_SIZE) {
        uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].marked = 1;
        uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].size = size;
        uheap_pages[(k - uheapPageAllocStart) / PAGE_SIZE].va = startva;
    }
    sys_allocate_user_mem(startva, ROUNDUP(size, PAGE_SIZE));
}

//=================================
// [1] ALLOCATE SPACE IN USER HEAP
//=================================
void* malloc(uint32 size) {
    uheap_init();
    if (size == 0) return NULL;

    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
        return (uint32*) alloc_block(size);
    }

    uint32 startva = uheapPageAllocStart;
    int flag = 0;
    int j = 0;
    uint32 SumOfSizes = 0;

    // Try exact fit
    for (uint32 i = uheapPageAllocStart; i < uheapPageAllocBreak && j < NUM_OF_UHEAP_PAGES; i += PAGE_SIZE, j++) {
        if (!uheap_pages[j].marked) {
            SumOfSizes += PAGE_SIZE;
            if (!flag) {
                startva = i;
                flag = 1;
            }
            if (SumOfSizes == ROUNDUP(size, PAGE_SIZE) && (j + 1 < NUM_OF_UHEAP_PAGES && uheap_pages[j + 1].marked == 1)) {
                mark_uheap(startva, i, size, 1);
                return (uint32*) startva;
            }
        } else {
            flag = 0;
            SumOfSizes = 0;
        }
    }

    // Worst fit
    uint32 maxsize = 0, StartOfMaxVa = 0;
    j = 0; SumOfSizes = 0; flag = 0;
    for (uint32 i = uheapPageAllocStart; i < uheapPageAllocBreak && j < NUM_OF_UHEAP_PAGES; i += PAGE_SIZE, j++) {
        if (!uheap_pages[j].marked) {
            SumOfSizes += PAGE_SIZE;
            if (maxsize < SumOfSizes) {
                maxsize = SumOfSizes;
                StartOfMaxVa = startva;
            }
            if (!flag) {
                startva = i;
                flag = 1;
            }
        } else {
            flag = 0;
            SumOfSizes = 0;
        }
    }
    if (maxsize > size) {
        mark_uheap(StartOfMaxVa, StartOfMaxVa + ROUNDUP(size, PAGE_SIZE), size, 0);
        return (uint32*) StartOfMaxVa;
    }

    // Extend heap
    if (ROUNDUP(size, PAGE_SIZE) <= (USER_HEAP_MAX - uheapPageAllocBreak)) {
        startva = uheapPageAllocBreak;
        uheapPageAllocBreak += ROUNDUP(size, PAGE_SIZE);
        mark_uheap(startva, uheapPageAllocBreak, size, 1);
        return (uint32*) startva;
    }

    return NULL;
}

//=================================
// [2] FREE SPACE FROM USER HEAP
//=================================
void free(void* virtual_address) {
    uint32 vra = (uint32) virtual_address;
    if (vra >= dynAllocStart && vra < dynAllocEnd) {
        free_block(virtual_address);
        return;
    }

    if (vra < uheapPageAllocStart || vra >= uheapPageAllocBreak) {
        panic("invalid address");
    }

    uint32 size = uheap_pages[(vra - uheapPageAllocStart)/PAGE_SIZE].size;
    int ct = (size + PAGE_SIZE - 1) / PAGE_SIZE;

    for (uint32 i = vra; i < vra + ct * PAGE_SIZE; i += PAGE_SIZE) {
        size = uheap_pages[(vra - uheapPageAllocStart)/PAGE_SIZE].size;
        sys_free_user_mem(i, size);
        uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].marked = 0;
        uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].va = 0;
        uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].size = 0;
    }

    uint32 NextPageVa = vra + ct * PAGE_SIZE;
    if (NextPageVa == uheapPageAllocBreak) {
        for (uint32 i = uheapPageAllocBreak - PAGE_SIZE; i >= uheapPageAllocStart; i -= PAGE_SIZE) {
            if (uheap_pages[(i - uheapPageAllocStart)/PAGE_SIZE].marked) {
                uheapPageAllocBreak = i + PAGE_SIZE;
                break;
            }
        }
        if (NextPageVa == uheapPageAllocBreak) {
            uheapPageAllocBreak = uheapPageAllocStart;
        }
    }
}

int is_allocated(uint32 va) {
    return uheap_pages[(va - uheapPageAllocStart) >> 12].marked;
}

//=================================
// [3] ALLOCATE SHARED VARIABLE
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
    uheap_init();
    if (size == 0) return NULL;

    size = ROUNDUP(size, PAGE_SIZE);
    if (sys_size_of_shared_object(sys_getenvid(), sharedVarName) >= 1) return NULL;

    uint32 start_address = uheapPageAllocStart, end_address = uheapPageAllocBreak;
    uint32 res_address = 0;

    // Exact fit
    for (uint32 i = start_address; i < end_address;) {
        if (!is_allocated(i)) {
            uint32 j = i;
            while (j < end_address && !is_allocated(j)) j += PAGE_SIZE;
            if (j - i == size) { res_address = i; break; }
            i = j;
        } else i += PAGE_SIZE;
    }

    // Worst fit
    if (!res_address) {
        uint32 max_size = 0;
        for (uint32 i = start_address; i < end_address;) {
            if (!is_allocated(i)) {
                uint32 j = i;
                while (j < end_address && !is_allocated(j)) j += PAGE_SIZE;
                if (j - i >= size && j - i > max_size) { res_address = i; max_size = j - i; }
                i = j;
            } else i += PAGE_SIZE;
        }
    }

    // Extend heap
    if (!res_address && size + uheapPageAllocBreak <= USER_HEAP_MAX) {
        res_address = uheapPageAllocBreak;
        uheapPageAllocBreak += size;
    }

    if (!res_address) return NULL;
    if (sys_create_shared_object(sharedVarName, size, isWritable, (uint32*)res_address) == E_NO_SHARE)
        return NULL;

    mark_uheap(res_address, res_address + size, size, 0);
    return (uint32*) res_address;
}

//=================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE
//=================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
    uheap_init();
    int shr_size = sys_size_of_shared_object(ownerEnvID, sharedVarName);
    if (shr_size == E_SHARED_MEM_NOT_EXISTS) return NULL;

    uint32 start_address = uheapPageAllocStart, end_address = uheapPageAllocBreak;
    uint32 size = ROUNDUP(shr_size, PAGE_SIZE);
    uint32 res_address = 0;

    // Exact fit
    for (uint32 i = start_address; i < end_address;) {
        if (!is_allocated(i)) {
            uint32 j = i;
            while (j < end_address && !is_allocated(j)) j += PAGE_SIZE;
            if (j - i == size) { res_address = i; break; }
            i = j;
        } else i += PAGE_SIZE;
    }

    // Worst fit
    if (!res_address) {
        uint32 max_size = 0;
        for (uint32 i = start_address; i < end_address;) {
            if (!is_allocated(i)) {
                uint32 j = i;
                while (j < end_address && !is_allocated(j)) j += PAGE_SIZE;
                if (j - i >= size && j - i > max_size) { res_address = i; max_size = j - i; }
                i = j;
            } else i += PAGE_SIZE;
        }
    }

    // Extend heap
    if (!res_address && size + uheapPageAllocBreak <= USER_HEAP_MAX) {
        res_address = uheapPageAllocBreak;
        uheapPageAllocBreak += size;
    }

    if (!res_address) return NULL;
    if (sys_get_shared_object(ownerEnvID, sharedVarName, (uint32*)res_address) == E_SHARED_MEM_NOT_EXISTS)
        return NULL;

    mark_uheap(res_address, res_address + size, size, 0);
    return (uint32*) res_address;
}

//=================================
// BONUS FUNCTIONS
//=================================
void *realloc(void *virtual_address, uint32 new_size) {
    uheap_init();
    panic("realloc() is not implemented yet...!!");
}

void sfree(void* virtual_address) {
    panic("sfree() is not implemented yet...!!");
}
