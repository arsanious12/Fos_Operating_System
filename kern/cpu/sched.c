#include "sched.h"

#include <inc/assert.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/trap.h>
#include <kern/mem/kheap.h>
#include <kern/mem/memory_manager.h>
#include <kern/tests/utilities.h>
#include <kern/cmd/command_prompt.h>
#include <kern/cpu/cpu.h>
#include <kern/cpu/picirq.h>


uint32 isSchedMethodRR(){return (scheduler_method == SCH_RR);}
uint32 isSchedMethodMLFQ(){return (scheduler_method == SCH_MLFQ); }
uint32 isSchedMethodBSD(){return(scheduler_method == SCH_BSD); }
uint32 isSchedMethodPRIRR(){return(scheduler_method == SCH_PRIRR); }

//===================================================================================//
//============================ SCHEDULER FUNCTIONS ==================================//
//===================================================================================//
static struct Env* (*sched_next[])(void) = {
[SCH_RR]    fos_scheduler_RR,
[SCH_MLFQ]  fos_scheduler_MLFQ,
[SCH_BSD]   fos_scheduler_BSD,
[SCH_PRIRR]   fos_scheduler_PRIRR,

};

//===================================
// [1] Default Scheduler Initializer:
//===================================
void sched_init()
{
	old_pf_counter = 0;

	sched_init_RR(INIT_QUANTUM_IN_MS);

	init_queue(&ProcessQueues.env_new_queue);
	init_queue(&ProcessQueues.env_exit_queue);

	mycpu()->scheduler_status = SCH_STOPPED;

	/*2024: initialize lock to protect these Qs in MULTI-CORE case only*/
	init_kspinlock(&ProcessQueues.qlock, "process queues lock");
}

//=========================
// [2] Main FOS Scheduler:
//=========================

void
fos_scheduler(void)
{
	//ensure that the scheduler is invoked while interrupt is disabled
	if (read_eflags() & FL_IF)
		panic("fos_scheduler: called while the interrupt is enabled!");

	//cprintf("inside scheduler - timer cnt = %d\n", kclock_read_cnt0());
	struct Env *p;
	struct cpu *c = mycpu();
	c->proc = 0;

	chk1();
	c->scheduler_status = SCH_STARTED;

	//This variable should be set to the next environment to be run (if any)
	struct Env* next_env = NULL;

	//2024: should be outer loop as long as there's any BLOCKED processes.
	//Ref: xv6-x86 OS
	int is_any_blocked = 0;
	do
	{
		// Enable interrupts on this processor for a while to allow BLOCKED process to resume
		// The most recent process to run may have had interrupts turned off; enable them
		// to avoid a deadlock if all processes are waiting.
		sti();

		// Check ready queue(s) looking for process to run.
		//cprintf("\n[FOS_SCHEDULER] acquire: lock status before acquire = %d\n", qlock.locked);
		acquire_kspinlock(&(ProcessQueues.qlock));  //lock: to protect ready & blocked Qs in multi-CPU
		//cprintf("ACQUIRED\n");
		do
		{
			//Get next env according to the current scheduler
			next_env = sched_next[scheduler_method]() ;

			if(next_env != NULL)
			{
				//cprintf("\nScheduler select program '%s' [%d]... clock counter = %d\n", next_env->prog_name, next_env->env_id, kclock_read_cnt0());
				// Switch to chosen process. It is the process's job to release qlock
				// and then reacquire it before jumping back to us.
				set_cpu_proc(next_env);
				switchuvm(next_env);

				//Change its status to RUNNING
				next_env->env_status = ENV_RUNNING;

				//Context switch to it
				context_switch(&(c->scheduler), next_env->context);

				//ensure that the qlock is still held after returning from the process
				if(!holding_kspinlock(&ProcessQueues.qlock))
				{
					printcallstack(&ProcessQueues.qlock);
					panic("fos_scheduler(): qlock is either not held or held by another CPU!");
				}

				//Stop the clock now till finding a next proc (if any).
				//This is to avoid clock interrupt inside the scheduler after sti() of the outer loop
				kclock_stop();
				//cprintf("\n[IEN = %d] clock is stopped! returned to scheduler after context_switch. curenv = %d\n", (read_eflags() & FL_IF) == 0? 0:1, c->proc == NULL? 0 : c->proc->env_id);

				// Process is done running for now. It should have changed its p->status before coming back.
				//If no process on CPU, switch to the kernel
				assert(get_cpu_proc() == c->proc);
				int status = c->proc->env_status ;
				assert(status != ENV_RUNNING);
				if (status == ENV_READY)
				{
					//OK... will be placed to the correct ready Q in the next iteration
				}
				else
				{
					//					cprintf("scheduler: process %d is BLOCKED/EXITED\n", c->proc->env_id);
					switchkvm();
					struct Env* __e__ = c->proc;
					set_cpu_proc(NULL);
				}
			}
		} while(next_env);

		//2024 - check if there's any blocked process?
		is_any_blocked = 0;
		for (int i = 0; i < NENV; ++i)
		{
			if (envs[i].env_status == ENV_BLOCKED)
			{
				is_any_blocked = 1;
				break;
			}
		}
		release_kspinlock(&ProcessQueues.qlock);  //release lock: to protect ready & blocked Qs in multi-CPU
		//cprintf("\n[FOS_SCHEDULER] release: lock status after = %d\n", qlock.locked);
	} while (is_any_blocked > 0);

	/*2015*///No more envs... curenv doesn't exist any more! return back to command prompt
	{
		//cprintf("[sched] no envs - nothing more to do!\n");
		get_into_prompt();
	}

}

//=============================
// [3] Initialize RR Scheduler:
//=============================
void sched_init_RR(uint8 quantum)
{
	// Create 1 ready queue for the RR
	num_of_ready_queues = 1;
#if USE_KHEAP
	sched_delete_ready_queues();
	ProcessQueues.env_ready_queues = kmalloc(sizeof(struct Env_Queue));
	quantums = kmalloc(num_of_ready_queues * sizeof(uint8)) ;
#endif
	quantums[0] = quantum;
	kclock_set_quantum(quantums[0]);
	init_queue(&(ProcessQueues.env_ready_queues[0]));
	//=========================================
	//DON'T CHANGE THESE LINES=================
	uint16 cnt0 = kclock_read_cnt0_latch() ; //read after write to ensure it's set to the desired value
	cprintf("*	RR scheduler with initial clock = %d\n", cnt0);
	mycpu()->scheduler_status = SCH_STOPPED;
	scheduler_method = SCH_RR;
	//=========================================
	//=========================================
}

//===============================
// [4] Initialize MLFQ Scheduler:
//===============================
void sched_init_MLFQ(uint8 numOfLevels, uint8 *quantumOfEachLevel)
{
	panic("Not implemented yet");


	//=========================================
	//DON'T CHANGE THESE LINES=================
	uint16 cnt0 = kclock_read_cnt0_latch() ; //read after write to ensure it's set to the desired value
	cprintf("*	MLFQ scheduler with initial clock = %d\n", cnt0);
	mycpu()->scheduler_status = SCH_STOPPED;
	scheduler_method = SCH_MLFQ;
	//=========================================
	//=========================================

}

//===============================
// [5] Initialize BSD Scheduler:
//===============================
void sched_init_BSD(uint8 numOfLevels, uint8 quantum)
{
	panic("Not implemented yet");


	//=========================================
	//DON'T CHANGE THESE LINES=================
	uint16 cnt0 = kclock_read_cnt0_latch() ; //read after write to ensure it's set to the desired value
	cprintf("*	BSD scheduler with initial clock = %d\n", cnt0);
	mycpu()->scheduler_status = SCH_STOPPED;
	scheduler_method = SCH_BSD;
	//=========================================
	//=========================================
}

//======================================
// [6] Initialize PRIORITY RR Scheduler:
//======================================
void sched_init_PRIRR(uint8 numOfPriorities, uint8 quantum, uint32 starvThresh)
{
#if USE_KHEAP
//	    cprintf("init 1\n");
		//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #2 sched_init_PRIRR
		//Your code is here
		//Comment the following line
		//panic("sched_init_PRIRR() is not implemented yet...!!");
	   sched_delete_ready_queues();
//	   cprintf("Queue deleted ! \n");
	   ProcessQueues.env_ready_queues = kmalloc(sizeof(struct Env_Queue) * numOfPriorities);
	   quantums = kmalloc(sizeof(uint8));
	   for (int i=0;i<numOfPriorities;i++){
	      init_queue(&(ProcessQueues.env_ready_queues[i]));

//	      cprintf("%d\n" ,queue_size(&(ProcessQueues.env_ready_queues[i])));
	   }

//	   cprintf("init After Loop\n");
       num_of_ready_queues = numOfPriorities;
       sched_set_starv_thresh(starvThresh);
       kclock_set_quantum(quantum);
       quantums[0] = quantum;
//       cprintf("init END \n");

	//=========================================
	//DON'T CHANGE THESE LINES=================
	uint16 cnt0 = kclock_read_cnt0_latch() ; //read after write to ensure it's set to the desired value
	cprintf("*	PRIORITY RR scheduler with initial clock = %d\n", cnt0);
	mycpu()->scheduler_status = SCH_STOPPED;
	scheduler_method = SCH_PRIRR;
#endif
	//=========================================
	//=========================================
}

//=========================
// [7] RR Scheduler:
//=========================
struct Env* fos_scheduler_RR()
{
	// Implement simple round-robin scheduling.
	// Pick next environment from the ready queue,
	// and switch to such environment if found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	/*To protect process Qs (or info of current process) in multi-CPU************************/
	if(!holding_kspinlock(&ProcessQueues.qlock))
		panic("fos_scheduler_RR: q.lock is not held by this CPU while it's expected to be.");
	/****************************************************************************************/
	struct Env *next_env = NULL;
	struct Env *cur_env = get_cpu_proc();
	//If the curenv is still exist, then insert it again in the ready queue
	if (cur_env != NULL)
	{
		//cprintf("RR: [%d] with status %d will be added to ready Q", cur_env->env_id, cur_env->env_status);
		enqueue(&(ProcessQueues.env_ready_queues[0]), cur_env);
	}

	//Pick the next environment from the ready queue
	next_env = dequeue(&(ProcessQueues.env_ready_queues[0]));

	//Reset the quantum
	//2017: Reset the value of CNT0 for the next clock interval
	kclock_set_quantum(quantums[0]);
	//uint16 cnt0 = kclock_read_cnt0_latch() ;
	//cprintf("CLOCK INTERRUPT AFTER RESET: Counter0 Value = %d\n", cnt0 );

	return next_env;
}

//=========================
// [8] MLFQ Scheduler:
//=========================
struct Env* fos_scheduler_MLFQ()
{
	//Apply the MLFQ with the specified levels to pick up the next environment
	//Note: the "curenv" (if exist) should be placed in its correct queue
	/*To protect process Qs (or info of current process) in multi-CPU************************/
	if(!holding_kspinlock(&ProcessQueues.qlock))
		panic("fos_scheduler_MLFQ: q.lock is not held by this CPU while it's expected to be.");
	/****************************************************************************************/
	panic("Not implemented yet");
}

//=========================
// [9] BSD Scheduler:
//=========================
struct Env* fos_scheduler_BSD()
{
	/*To protect process Qs (or info of current process) in multi-CPU************************/
	if(!holding_kspinlock(&ProcessQueues.qlock))
		panic("fos_scheduler_BSD: q.lock is not held by this CPU while it's expected to be.");
	/****************************************************************************************/
	panic("Not implemented yet");
}

//=============================
// [10] PRIORITY RR Scheduler:
//=============================
struct Env* fos_scheduler_PRIRR()
{
//	cprintf("Next 1\n");
	/*To protect process Qs (or info of current process) in multi-CPU************************/
	if(!holding_kspinlock(&ProcessQueues.qlock))
		panic("fos_scheduler_PRIRR: q.lock is not held by this CPU while it's expected to be.");
	/****************************************************************************************/
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #3 fos_scheduler_PRIRR
	//Your code is here
	//Comment the following line
	//panic("fos_scheduler_PRIRR() is not implemented yet...!!");
	struct Env *Bavly = get_cpu_proc();
//	cprintf("Next After if \n");
	if(Bavly != NULL){
//		cprintf("Next in Bavly != NULL \n");

		sched_insert_ready(Bavly);


	}
	struct Env *next =  NULL;
	for(int i = 0 ; i < num_of_ready_queues;i++){
		if(queue_size(&(ProcessQueues.env_ready_queues[i])) > 0) {

			next = dequeue(&(ProcessQueues.env_ready_queues[i]));
//             cprintf("%d\n" , next->priority);
			break;
		}
	}
	kclock_set_quantum(quantums[0]);
	return next;
}

//========================================
// [11] Clock Interrupt Handler
//	  (Automatically Called Every Quantum)
//========================================
void clock_interrupt_handler(struct Trapframe* tf)
{
	if (isSchedMethodPRIRR())
	{
		//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #4 clock_interrupt_handler
		//Your code is here
		//Comment the following line
		//panic("clock_interrupt_handler() is not implemented yet...!!");

		      for(int i=1;i<num_of_ready_queues;i++){
		            struct Env * ptr_env=NULL;
		            LIST_FOREACH(ptr_env,&(ProcessQueues.env_ready_queues[i]))
		            {
		                if(++(ptr_env->nClocks)>Threshold){
		                    env_set_priority(ptr_env->env_id,(ptr_env->priority)-1);
		                    ptr_env->nClocks=0;
		                }
		            }
		        }

	}

	/********DON'T CHANGE THESE LINES***********/
	ticks++ ;
	struct Env* p = get_cpu_proc();
	if (p == NULL)
	{
//		cprintf("\n??????????????????? p == NULL ?????????????????????\n");
//		cprintf("IRQ0 mask = %d\n", irq_get_mask(0));
//		cprintf("caller IEN = %d, EIP = %x\n", tf->tf_eflags & FL_IF, tf->tf_eip);
//		cprintf("scheduler status = %d\n", mycpu()->scheduler_status) ;
		//panic("clock_interrupt_handler: no running process at the cpu! unexpected clock interrupt in the kernel!");
	}
	else
	{
		p->nClocks++ ;
		if(isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
		{
			update_WS_time_stamps();
		}
		//cprintf("\n***************\nClock Handler\n***************\n") ;
		//fos_scheduler();
		yield();
	}
	/*****************************************/
}

//===================================================================
// [9] Update LRU Timestamp of WS Elements
//	  (Automatically Called Every Quantum in case of LRU Time Approx)
//===================================================================
void update_WS_time_stamps()
{
#if USE_KHEAP
    //cprintf("in time stamp\n");
    //cprintf("%d\n",0>>1);
    struct Env* e = get_cpu_proc();
    //env_page_ws_print(e);
    //for(int i = 0 ; i<1024;i++){
	//struct Env e=&envs[i];
	//if(e->env_status == ENV_FREE)
	//continue; //skip free env
	//if(LIST_EMPTY(&e->page_WS_list))
	//continue; // skip if no working set
	struct WorkingSetElement *wst= NULL;
	//cprintf("AFTER\n");
	LIST_FOREACH( wst , &e->page_WS_list)
	{
		//cprintf("Time Stamp BEFORE : %d\n",wst->time_stamp);
		wst->time_stamp>>=1; //shift wst right
		//cprintf("Time Stamp AFTER : %d\n",wst->time_stamp);
		uint32 pe=pt_get_page_permissions(e->env_page_directory,wst->virtual_address);
		int ac=0;
		if(pe&PERM_USED) //check for recently used or not
		  ac=1;
		if(ac){
			wst->time_stamp|=0x80000000; //set MSB 3lshan a mark ano recently used
			pt_set_page_permissions(e->env_page_directory,wst->virtual_address,0,PERM_USED); //3lshan a3mel clear ll iteration elly gaya

	}
		//cprintf("In Con\n");
		//cprintf("\n");

	//}


}
#else
	panic("not kheap");
#endif
        //env_page_ws_print(e);



    //TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #1 update_WS_time_stamps
    //Your code is here
    //Comment the following line
    //panic("update_WS_time_stamps is not implemented yet...!!");

}
