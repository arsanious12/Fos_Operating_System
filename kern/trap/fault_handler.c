/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <kern/cpu/cpu.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/mem/memory_manager.h>
#include <kern/mem/kheap.h>
#include <inc/queue.h>

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}
/*2024*/ void setFASTNchanceCLOCK(bool fast){ FASTNchanceCLOCK = fast; };
/*2025*/ void setPageReplacmentAlgorithmOPTIMAL(){ _PageRepAlgoType = PG_REP_OPTIMAL; };

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmOPTIMAL(){if(_PageRepAlgoType == PG_REP_OPTIMAL) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//==================
// [0] INIT HANDLER:
//==================
void fault_handler_init()
{
	//setPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX);
	//setPageReplacmentAlgorithmOPTIMAL();
	setPageReplacmentAlgorithmCLOCK();
	//setPageReplacmentAlgorithmModifiedCLOCK();
	enableBuffering(0);
	enableModifiedBuffer(0) ;
	setModifiedBufferLength(1000);
}
//==================
// [1] MAIN HANDLER:
//==================
/*2022*/
uint32 last_eip = 0;
uint32 before_last_eip = 0;
uint32 last_fault_va = 0;
uint32 before_last_fault_va = 0;
int8 num_repeated_fault  = 0;
extern uint32 sys_calculate_free_frames() ;

struct Env* last_faulted_env = NULL;
void fault_handler(struct Trapframe *tf)
{
	//cprintf("fault_handler\n");
	/******************************************************/
	// Read processor's CR2 register to find the faulting address
	uint32 fault_va = rcr2();
	//cprintf("************Faulted VA = %x************\n", fault_va);
	//	print_trapframe(tf);
	/******************************************************/

	//If same fault va for 3 times, then panic
	//UPDATE: 3 FAULTS MUST come from the same environment (or the kernel)
	struct Env* cur_env = get_cpu_proc();
	if (last_fault_va == fault_va && last_faulted_env == cur_env)
	{
		num_repeated_fault++ ;
		if (num_repeated_fault == 3)
		{
			print_trapframe(tf);
			panic("Failed to handle fault! fault @ at va = %x from eip = %x causes va (%x) to be faulted for 3 successive times\n", before_last_fault_va, before_last_eip, fault_va);
		}
	}
	else
	{
		before_last_fault_va = last_fault_va;
		before_last_eip = last_eip;
		num_repeated_fault = 0;
	}
	last_eip = (uint32)tf->tf_eip;
	last_fault_va = fault_va ;
	last_faulted_env = cur_env;
	/******************************************************/
	//2017: Check stack overflow for Kernel
	int userTrap = 0;
	if ((tf->tf_cs & 3) == 3) {
		userTrap = 1;
	}
	if (!userTrap)
	{
		struct cpu* c = mycpu();
		//cprintf("trap from KERNEL\n");
		if (cur_env && fault_va >= (uint32)cur_env->kstack && fault_va < (uint32)cur_env->kstack + PAGE_SIZE)
			panic("User Kernel Stack: overflow exception!");
		else if (fault_va >= (uint32)c->stack && fault_va < (uint32)c->stack + PAGE_SIZE)
			panic("Sched Kernel Stack of CPU #%d: overflow exception!", c - CPUS);
#if USE_KHEAP
		if (fault_va >= KERNEL_HEAP_MAX)
			panic("Kernel: heap overflow exception!");
#endif
	}
	//2017: Check stack underflow for User
	else
	{
		//cprintf("trap from USER\n");
		if (fault_va >= USTACKTOP && fault_va < USER_TOP)
			panic("User: stack underflow exception!");
	}

	//get a pointer to the environment that caused the fault at runtime
	//cprintf("curenv = %x\n", cur_env);
	//cprintf("%d\n",userTrap);
	struct Env* faulted_env = cur_env;
	if (faulted_env == NULL)
	{
		//cprintf("\nFaulted VA = %x\n", fault_va);
		print_trapframe(tf);
		panic("faulted env == NULL!");
	}
	//check the faulted address, is it a table or not ?
	//If the directory entry of the faulted address is NOT PRESENT then
	if ( (faulted_env->env_page_directory[PDX(fault_va)] & PERM_PRESENT) != PERM_PRESENT)
	{
		faulted_env->tableFaultsCounter ++ ;
		table_fault_handler(faulted_env, fault_va);
	}
	else
	{
		if (userTrap)
		{
			//cprintf("userTrap1\n");
			int perm = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
			if (fault_va >= USER_LIMIT)
			{
				//cprintf("cancelloo1\n");
				env_exit();
			}
			else if (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)
			{
				if (!(perm & PERM_UHPAGE)){
					//cprintf("cancelloo2\n");
					env_exit();}
			}
			else if ((perm & PERM_PRESENT) && (perm & ~PERM_WRITEABLE))
			{
				//cprintf("cancelloo3\n");
				env_exit();
			}




						//01110111101
						//0000 0001 0000 0000  // arsanious perm

			/*============================================================================================*/
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #2 Check for invalid pointers
			//(e.g. pointing to unmarked user heap page, kernel or wrong access rights),
			//your code is here

			/*============================================================================================*/
		}

		/*2022: Check if fault due to Access Rights */
		int perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
/*
		while(perms){
			if(perms&1) cprintf("%d", 1);
			perms >>= 1;
		}
*/
		if (perms & PERM_PRESENT)
			panic("Page @va=%x is exist! page fault due to violation of ACCESS RIGHTS\n", fault_va) ;
		/*============================================================================================*/


		// we have normal page fault =============================================================
		faulted_env->pageFaultsCounter ++ ;

//				cprintf("[%08s] user PAGE fault va %08x\n", faulted_env->prog_name, fault_va);
//				cprintf("\nPage working set BEFORE fault handler...\n");
//				env_page_ws_print(faulted_env);
		//int ffb = sys_calculate_free_frames();

		if(isBufferingEnabled())
		{
			__page_fault_handler_with_buffering(faulted_env, fault_va);
		}
		else
		{
			page_fault_handler(faulted_env, fault_va);
		}

		//		cprintf("\nPage working set AFTER fault handler...\n");
		//		env_page_ws_print(faulted_env);
		//		int ffa = sys_calculate_free_frames();
		//		cprintf("fault handling @%x: difference in free frames (after - before = %d)\n", fault_va, ffa - ffb);
	}

	/*************************************************************/
	//Refresh the TLB cache
	tlbflush();
	/*************************************************************/
}


//=========================
// [2] TABLE FAULT HANDLER:
//=========================
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//=========================
// [3] PAGE FAULT HANDLER:
//=========================
/* Calculate the number of page faults according th the OPTIMAL replacement strategy
 * Given:
 * 	1. Initial Working Set List (that the process started with)
 * 	2. Max Working Set Size
 * 	3. Page References List (contains the stream of referenced VAs till the process finished)
 *
 * 	IMPORTANT: This function SHOULD NOT change any of the given lists
 */
struct WorkingSetElement* FindVic(struct PageRef_List *pageReferences,struct WS_List *initWorkingSet,struct PageRefElement *it){
	struct WS_List tmp;
	LIST_INIT(&tmp);
	struct WorkingSetElement *elem = NULL;
	LIST_FOREACH(elem,initWorkingSet){
		LIST_INSERT_TAIL(&tmp,elem);
	}
	while (1==1){
		int flag = 0;
		uint32 va = it->virtual_address;
		elem =NULL;
		LIST_FOREACH(elem,initWorkingSet){
			if(va == (uint32)elem->virtual_address){
				LIST_REMOVE(&tmp,elem);
				break;
			}
		}
		if(LIST_SIZE(&tmp)==1 || LIST_NEXT(it) == NULL){
			return LIST_FIRST(&tmp);
		}
		it = LIST_NEXT(it);
	}
	return NULL;

}
int get_optimal_num_faults(struct WS_List *initWorkingSet, int maxWSSize, struct PageRef_List *pageReferences)
{
	//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #2 get_optimal_num_faults
	//Your code is here
	//Comment the following line
	//panic("get_optimal_num_faults() is not implemented yet...!!");
	struct PageRefElement *it = NULL;
	int cnt = 0;                              // 1 2 3 4 5 6 7 8 9 10
	LIST_FOREACH(it,pageReferences){
		struct WorkingSetElement *elem=NULL;
		uint32 va = it->virtual_address;
		int flag = 0;
		LIST_FOREACH(elem,initWorkingSet){
			if(va == (uint32)elem->virtual_address){
				flag = 1;
			}
		}
		if(flag==0){
			if(LIST_SIZE(initWorkingSet)==maxWSSize){
				struct WorkingSetElement *vic = FindVic(pageReferences,initWorkingSet,it);
				LIST_INSERT_BEFORE(initWorkingSet,vic,(struct WorkingSetElement *)va);
				LIST_REMOVE(initWorkingSet,vic);
				cprintf("warm\n");
			}
			else{
				cprintf("cold\n");
				LIST_INSERT_TAIL(initWorkingSet,(struct WorkingSetElement *)va);
			}
			cnt++;
		}
	}
	cprintf("cnt: %d\n",cnt);
	return cnt;

}

void ClearActive(struct Env * faulted_env,uint32 fault_va){
	while(LIST_SIZE(&faulted_env->ActiveList) > 0){
		struct WorkingSetElement *IT = LIST_FIRST(&faulted_env->ActiveList);
		LIST_REMOVE(&faulted_env->ActiveList , IT);
		//env_page_ws_invalidate(faulted_env,IT->virtual_address);
		//kfree(IT);
		//unmap_frame(faulted_env->env_page_directory,IT->virtual_address);
		pt_set_page_permissions(faulted_env->env_page_directory,fault_va,0,PERM_PRESENT);
	}

}
void AddToActive(struct Env * faulted_env, uint32 fault_va){
	struct WorkingSetElement* newElem = env_page_ws_list_create_element(faulted_env,fault_va);
	LIST_INSERT_TAIL(&(faulted_env->ActiveList),newElem);
	struct FrameInfo *fr=NULL;
	allocate_frame(&fr);
	map_frame(faulted_env->env_page_directory,fr,fault_va,PERM_WRITEABLE|PERM_UHPAGE|PERM_PRESENT|PERM_USER);
	//pt_set_page_permissions(faulted_env->env_page_directory,fault_va,PERM_WRITEABLE|PERM_UHPAGE|PERM_PRESENT|PERM_USER,0);

}
void AddToRef(struct Env * faulted_env, uint32 fault_va){
	struct PageRefElement *ele = (struct PageRefElement* )kmalloc(sizeof(struct PageRefElement));
	if(ele == NULL){
		panic("No space in kheap");
	}
	ele->virtual_address = fault_va;
	LIST_INSERT_TAIL(&faulted_env->referenceStreamList , ele);
	LIST_FOREACH(ele,&faulted_env->referenceStreamList){
		cprintf("va: %x\n",ele->virtual_address);
	}
	//struct FrameInfo fr=NULL;
	//allocate_frame(&fr);
	//pt_set_page_permissions(faulted_env->env_page_directory,fault_va,PERM_WRITEABLE|PERM_UHPAGE|PERM_PRESENT|PERM_USER,0);
	//map_frame(faulted_env->env_page_directory,fr,fault_va,PERM_WRITEABLE|PERM_UHPAGE|PERM_PRESENT|PERM_USER);
	//pt_set_page_permissions(faulted_env->env_page_directory,fault_va,PERM_WRITEABLE|PERM_UHPAGE|PERM_PRESENT|PERM_USER,0);
	//pt_set_page_permissions(faulted_env->env_page_directory , fault_va , PERM_PRESENT , 0);

}

void page_fault_handler(struct Env * faulted_env, uint32 fault_va)
{
#if USE_KHEAP
	if (isPageReplacmentAlgorithmOPTIMAL())
	{
		//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #1 Optimal Reference Stream
		//Your code is here
		//Comment the following line
		//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");

		// [1]: keep track active WS
		// [2]: if faulted page not in memory, read it from disk
		//      else, just set its Present bit
		// [3]: if the faulted page in the active WS, do nothing
		//      else, if Active WS is full, reset present & delete all its pages
		// [4]: Add the faulted page to the Active WS
		// [5]: Add faulted page to the end of the ref3erence stream list

		/*
		uint32* pg_table = NULL;
		if(!get_frame_info(faulted_env->env_page_directory, fault_va, &pg_table)){
			int o = pf_read_env_page(faulted_env , &fault_va);
		}
		//cprintf("%x, RO:%x\n",fault_va,ROUNDDOWN(fault_va,PAGE_SIZE));
		//cprintf("%d",faulted_env->page_WS_max_size);
		//fault_va = ROUNDDOWN(fault_va,PAGE_SIZE);

		struct WorkingSetElement *IT = NULL;

		IT = NULL;
		bool flag=0;
		LIST_FOREACH(IT , &faulted_env->ActiveList ){
			if((uint32)IT->virtual_address == fault_va){
				flag = 1;
			}

		}
		if(flag == 0){
			//env_page_ws_print(faulted_env);
			//cprintf("Not Exist in A_WS\n");
			int o = pf_read_env_page(faulted_env , &fault_va);
			cprintf("%d\n",faulted_env->page_WS_max_size);
			if (LIST_SIZE(&(faulted_env->ActiveList)) == faulted_env->page_WS_max_size){
				ClearActive(faulted_env,fault_va);
				//fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
			}
			AddToRef(faulted_env,fault_va);
			AddToActive(faulted_env,fault_va);

		}
		 //env_page_ws_print(faulted_env);
*/
	}
	else
	{
		struct WorkingSetElement *victimWSElement = NULL;
		uint32 wsSize = LIST_SIZE(&(faulted_env->page_WS_list));
		if(wsSize < (faulted_env->page_WS_max_size))
		{
			cprintf("//////////////Before pl////////////////");
			//env_page_ws_print(faulted_env);
			//env_page_ws_print(faulted_env);
			fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
			struct FrameInfo *NewFrame=NULL;

			allocate_frame(&NewFrame);
			map_frame(faulted_env->env_page_directory,NewFrame,fault_va,PERM_WRITEABLE|PERM_PRESENT|PERM_UHPAGE|PERM_USER|PERM_USED);
			int res = pf_read_env_page(faulted_env,(uint32*)fault_va);
			//cprintf("Ah\n");
			int to_be_placed = 0;
			if(res == E_PAGE_NOT_EXIST_IN_PF){
				//cprintf("Ah2\n");
				if(((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va>= USTACKBOTTOM && fault_va< USTACKTOP))){
					//cprintf("Ah3\n");
					to_be_placed = 1;

				}
			}else{
				to_be_placed = 1;
			}
			if(to_be_placed){
				struct WorkingSetElement* newElem = env_page_ws_list_create_element(faulted_env,fault_va);
				if(faulted_env->page_last_WS_element == NULL || faulted_env->page_last_WS_element == LIST_FIRST(&faulted_env->page_WS_list)){
					LIST_INSERT_TAIL(&(faulted_env->page_WS_list),newElem);
				}
				else{
					LIST_INSERT_BEFORE(&(faulted_env->page_WS_list),faulted_env->page_last_WS_element,newElem);
					//faulted_env->page_last_WS_element = LIST_NEXT(faulted_env->page_last_WS_element);
				}
				uint32 curSize = LIST_SIZE(&faulted_env->page_WS_list);
				if (curSize == faulted_env->page_WS_max_size && faulted_env->page_last_WS_element == NULL){
					faulted_env->page_last_WS_element = (struct WorkingSetElement*)LIST_FIRST(&faulted_env->page_WS_list);
				}

			}else{
				unmap_frame(faulted_env->env_page_directory, fault_va);

				env_exit();
			}
			//env_page_ws_print(faulted_env);
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
			//Your code is here
			//Comment the following line
			//panic("page_fault_handler().PLACEMENT is not implemented yet...!!");

		}
		else
		{
			if (isPageReplacmentAlgorithmCLOCK())
			{
				fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
				struct FrameInfo *NewFrame=NULL;
				allocate_frame(&NewFrame);
				map_frame(faulted_env->env_page_directory,NewFrame,fault_va,PERM_WRITEABLE|PERM_PRESENT|PERM_UHPAGE|PERM_USER);
				int res = pf_read_env_page(faulted_env,(uint32 *)fault_va);
				//cprintf("Ah\n");
				int placed = 0;
				if(res == E_PAGE_NOT_EXIST_IN_PF){
					if(((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va>= USTACKBOTTOM && fault_va< USTACKTOP))){
						placed = 1;

					}
				}else{
					placed = 1;
				}
				if(placed){

					struct WorkingSetElement* newElem = env_page_ws_list_create_element(faulted_env, fault_va);
					struct WorkingSetElement *it = faulted_env->page_last_WS_element;
					while (1 == 1) {
						uint32 va = (uint32)it->virtual_address;
					    if (( pt_get_page_permissions(faulted_env->env_page_directory, va) & PERM_USED) == PERM_USED) {
					        pt_set_page_permissions(faulted_env->env_page_directory, va, 0, PERM_USED);

					        if (LIST_NEXT(it) == NULL){
					            it = (struct WorkingSetElement*) LIST_FIRST(&faulted_env->page_WS_list);
					        }
					        else{
					            it = LIST_NEXT(it);
					        }
					    } else {
					        if ((pt_get_page_permissions(faulted_env->env_page_directory, va) & PERM_MODIFIED) == PERM_MODIFIED) {
								//cprintf("MODIF\n");
					            uint32 *table = NULL;
					            get_page_table(faulted_env->env_page_directory, va, &table);
					            struct FrameInfo *ff = get_frame_info(faulted_env->env_page_directory, va, &table);
					            pf_update_env_page(faulted_env, va, ff);
								//cprintf("MODIF done\n");
					        }
					        unmap_frame(faulted_env->env_page_directory, va);
					        LIST_INSERT_BEFORE(&(faulted_env->page_WS_list), it, newElem);
							LIST_REMOVE(&(faulted_env->page_WS_list), it);
							kfree(it);
					        if (LIST_NEXT(newElem) == NULL)
					            faulted_env->page_last_WS_element = (struct WorkingSetElement*) LIST_FIRST(&faulted_env->page_WS_list);
					        else
					            faulted_env->page_last_WS_element = LIST_NEXT(newElem);
					        break;
					    }
					}

				}else{
					//cprintf("no alloc\n");
					unmap_frame(faulted_env->env_page_directory, fault_va);
					env_exit();
				}

				//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #3 Clock Replacement
				//Your code is here
				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");


			}
			else if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
			{

				/////////////////////////////////////////////LRU/////////////////////////////////////////////////
				 cprintf("IN LRU\n");
				 struct WorkingSetElement*wst=LIST_FIRST(&(faulted_env->page_WS_list));//3lshan ageb a'al wahed fehom used atl3o victim
				 victimWSElement=wst;
				 struct WorkingSetElement *it=NULL;
				LIST_FOREACH( it , &faulted_env->page_WS_list){//h loop 3la elWS kolha atl3 a'al used fehom
					if(it->time_stamp < victimWSElement->time_stamp){
						victimWSElement=it;
					}

				}

				//3lshan y write lw hya modified
				uint32 pe=pt_get_page_permissions(faulted_env->env_page_directory,victimWSElement->virtual_address);
				if(pe&PERM_MODIFIED){
					uint32 *p=NULL;
					get_page_table(faulted_env->env_page_directory,victimWSElement->virtual_address,&p);
					struct FrameInfo*fr=get_frame_info(faulted_env->env_page_directory,victimWSElement->virtual_address,&p);
					pf_update_env_page(faulted_env,victimWSElement->virtual_address,fr);
				}
				fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
				unmap_frame(faulted_env->env_page_directory,victimWSElement->virtual_address);
				LIST_REMOVE(&(faulted_env->page_WS_list),victimWSElement);
				struct FrameInfo *NewFrame=NULL;
				allocate_frame(&NewFrame);
				map_frame(faulted_env->env_page_directory,NewFrame,fault_va,PERM_WRITEABLE|PERM_PRESENT|PERM_UHPAGE|PERM_USER);
				int res = pf_read_env_page(faulted_env,(uint32*)fault_va);
				//cprintf("Ah\n");
				int to_be_placed = 0;
				if(res == E_PAGE_NOT_EXIST_IN_PF){
					//cprintf("Ah2\n");
					if(((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va>= USTACKBOTTOM && fault_va< USTACKTOP))){
						//cprintf("Ah3\n");
						to_be_placed = 1;

					}
				}else{
					to_be_placed = 1;
				}
				if(to_be_placed){
					struct WorkingSetElement* newElem = env_page_ws_list_create_element(faulted_env,fault_va);
					LIST_INSERT_TAIL(&(faulted_env->page_WS_list),newElem);
					uint32 curSize = LIST_SIZE(&faulted_env->page_WS_list);
					if (curSize == faulted_env->page_WS_max_size){
						faulted_env->page_last_WS_element = (struct WorkingSetElement*)LIST_FIRST(&faulted_env->page_WS_list);
					}
				}else{
					unmap_frame(faulted_env->env_page_directory, fault_va);
					env_exit();
				}
				//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
				//Your code is here
				//Comment the following line
				//panic("page_fault_handler().PLACEMENT is not implemented yet...!!");

				//env_page_ws_print(faulted_env);

				//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #2 LRU Aging Replacement
				//Your code is here
				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
			else if (isPageReplacmentAlgorithmModifiedCLOCK())
			{

						  //cprintf("in function \n");
						struct Env* e =  faulted_env;
						struct WorkingSetElement *victimWSElement = NULL;
						struct WorkingSetElement *fb=NULL;//for FALLBACK (0,1)
						struct WorkingSetElement *hell=e->page_last_WS_element;
						bool ty1=0;
						if(hell == NULL){//lw dy awel run yebda' mn elhead
							//cprintf("NULL hell \n");
							hell=LIST_FIRST(&(e->page_WS_list));
						}
						uint32 wCount=LIST_SIZE(&(e->page_WS_list));
						//cprintf("List of size : %d\n",wCount);
						uint32 check=0;
						while(victimWSElement==NULL){
							//cprintf("in while LOOP \n");
						 int pe=pt_get_page_permissions(e->env_page_directory,hell->virtual_address);
						  if(pe<0|| !(pe&PERM_PRESENT) )// lw elpage not present aw invalid
						  {
							 //hell=LIST_NEXT(hell);//skip it
							  if(LIST_NEXT(hell)==NULL){
								hell=LIST_FIRST(&(e->page_WS_list));

							  }
							  else
								hell=LIST_NEXT(hell);
							 // check++;
							  continue;
						  }
						  int us=(pe&PERM_USED);
						  int mo=(pe&PERM_MODIFIED);
						  if(ty1==0){
							  //cprintf("IN IF \n");
						  if(!us&&!mo){
							  //cprintf("0,0\n");
							  victimWSElement=hell;
							  if(LIST_NEXT(hell)==NULL){
								  e->page_last_WS_element=LIST_FIRST(&(e->page_WS_list));
							   }
							  else
								  e->page_last_WS_element=LIST_NEXT(hell);
							  break;
						  }
						  }
						  else{
							 // cprintf("ELSE \n");
						  if(!us&&mo&&fb==NULL){
							  //cprintf("0,1\n");
							  victimWSElement=hell;
							  if(LIST_NEXT(hell)==NULL){
								 e->page_last_WS_element=LIST_FIRST(&(e->page_WS_list));
								}
							  else
								e->page_last_WS_element=LIST_NEXT(hell);
							  break;
						   }
						  if(us){
							  //cprintf("1 HELL %x\n",hell);
							  pt_set_page_permissions(e->env_page_directory,hell->virtual_address,0,PERM_USED); //3lshan akhleha zero llnext iteration
		//					  if(LIST_NEXT(hell)==NULL)
		//					 	hell=LIST_FIRST(&(e->page_WS_list));
		//					  else
		//					   hell=LIST_NEXT(hell);
		//					  check++;
		//					  continue;
						  }
						  }
						  if(LIST_NEXT(hell)==NULL){
							hell=LIST_FIRST(&(e->page_WS_list));
							e->page_last_WS_element=LIST_FIRST(&(e->page_WS_list));

						  }
						  else{
						   hell=LIST_NEXT(hell);
						   e->page_last_WS_element=hell;
						  }
						  check++;
						  if(check==wCount){
							check=0;
							 if(ty1==0){
							  ty1=1;
							  }
							 else
							  ty1=0;

						  }

						}

		//				  if(victimWSElement==NULL){
		//					  cprintf("FALLBACK %d\n",fb);
		//					  victimWSElement=fb;
		//				  }
						  if(victimWSElement==NULL){//Nothing matched f hashel elly hell is pointing to

							  //cprintf("CHECK %d\n",check);
							  victimWSElement=hell;
						   }
						  uint32 pe=pt_get_page_permissions(e->env_page_directory,victimWSElement->virtual_address);
						  if(pe&PERM_MODIFIED){
							  //cprintf("Modify\n");
							uint32 *p=NULL;
							get_page_table(e->env_page_directory,victimWSElement->virtual_address,&p);
							struct FrameInfo*fr=get_frame_info(e->env_page_directory,victimWSElement->virtual_address,&p);
							pf_update_env_page(e,victimWSElement->virtual_address,fr);
						}
						struct WorkingSetElement *NNN = LIST_NEXT(victimWSElement);
						if(NNN==NULL){
						 //cprintf("FIFO\n");
						 NNN=LIST_FIRST(&(e->page_WS_list));
						}

						fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
						unmap_frame(e->env_page_directory,victimWSElement->virtual_address);
						LIST_REMOVE(&faulted_env->page_WS_list, victimWSElement);

						//cprintf("List of size AFTER : %d\n",LIST_SIZE(&(e->page_WS_list)));
						if(LIST_EMPTY(&(e->page_WS_list)))
						  e->page_last_WS_element=NULL;
						else
						 e->page_last_WS_element=NNN;

						struct FrameInfo *NewFrame=NULL;
						allocate_frame(&NewFrame);
						map_frame(e->env_page_directory,NewFrame,fault_va,PERM_WRITEABLE|PERM_PRESENT|PERM_UHPAGE|PERM_USER|PERM_USED);
						int res = pf_read_env_page(e,(uint32*)fault_va);
						//cprintf("Ah\n");
						int to_be_placed = 0;
						if(res == E_PAGE_NOT_EXIST_IN_PF){
							//cprintf("Ah2\n");
							if(((fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) || (fault_va>= USTACKBOTTOM && fault_va< USTACKTOP))){
							//cprintf("Ah3\n");
							to_be_placed = 1;
							}
						}
						else{
						to_be_placed = 1;
						}
						if(to_be_placed){

							struct WorkingSetElement* newElem = env_page_ws_list_create_element(faulted_env,fault_va);
							if(faulted_env->page_last_WS_element == NULL || faulted_env->page_last_WS_element == LIST_FIRST(&faulted_env->page_WS_list)){
								LIST_INSERT_TAIL(&(faulted_env->page_WS_list),newElem);
							}
							else{
								LIST_INSERT_BEFORE(&(faulted_env->page_WS_list),faulted_env->page_last_WS_element,newElem);
								//faulted_env->page_last_WS_element = LIST_NEXT(faulted_env->page_last_WS_element);
							}

							uint32 curSize = LIST_SIZE(&faulted_env->page_WS_list);
							if (curSize == faulted_env->page_WS_max_size && faulted_env->page_last_WS_element == NULL){
								faulted_env->page_last_WS_element = (struct WorkingSetElement*)LIST_FIRST(&faulted_env->page_WS_list);
							}
						}else{
							//cprintf("PPPP\n");
						unmap_frame(e->env_page_directory, fault_va);
						env_exit();
						}
						//cprintf("AFTER: \n");
						//env_page_ws_print(e);
						//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Modified Clock Replacement
						//Your code is here
						//Comment the following line
						//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
		}
	}
#endif
}


void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}



