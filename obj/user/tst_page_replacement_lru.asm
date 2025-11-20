
obj/user/tst_page_replacement_lru:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 9e 01 00 00       	call   8001d4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x809000, 0x800000, 0x80a000, 0x803000,0x801000,0x804000,0x80b000,0x80c000,0x827000,0x802000,	//Code & Data
		0xeebfd000, 	//Stack
} ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003e:	6a 01                	push   $0x1
  800040:	68 00 00 80 00       	push   $0x800000
  800045:	6a 0b                	push   $0xb
  800047:	68 20 30 80 00       	push   $0x803020
  80004c:	e8 c7 19 00 00       	call   801a18 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 1d 80 00       	push   $0x801d60
  800065:	6a 1d                	push   $0x1d
  800067:	68 d4 1d 80 00       	push   $0x801dd4
  80006c:	e8 13 03 00 00       	call   800384 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800071:	c6 05 df d0 80 00 61 	movb   $0x61,0x80d0df

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800078:	a0 df e0 80 00       	mov    0x80e0df,%al
  80007d:	88 45 eb             	mov    %al,-0x15(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800080:	a0 df f0 80 00       	mov    0x80f0df,%al
  800085:	88 45 ea             	mov    %al,-0x16(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80008f:	eb 26                	jmp    8000b7 <_main+0x7f>
	{
		__arr__[i] = -1 ;
  800091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800094:	05 e0 30 80 00       	add    $0x8030e0,%eax
  800099:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  80009c:	a1 00 30 80 00       	mov    0x803000,%eax
  8000a1:	8a 00                	mov    (%eax),%al
  8000a3:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *__ptr2__ ;
  8000a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000b0:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000b7:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000be:	7e d1                	jle    800091 <_main+0x59>
	}

	//===================


	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f4 1d 80 00       	push   $0x801df4
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 b0 05 00 00       	call   80067f <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 0d 1e 80 00       	push   $0x801e0d
  8000e6:	6a 3d                	push   $0x3d
  8000e8:	68 d4 1d 80 00       	push   $0x801dd4
  8000ed:	e8 92 02 00 00       	call   800384 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 0d 1e 80 00       	push   $0x801e0d
  800106:	6a 3e                	push   $0x3e
  800108:	68 d4 1d 80 00       	push   $0x801dd4
  80010d:	e8 72 02 00 00       	call   800384 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE LRU algorithm... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 1c 1e 80 00       	push   $0x801e1c
  80011a:	6a 03                	push   $0x3
  80011c:	e8 5e 05 00 00       	call   80067f <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0, 0); //order is not important in LRU
  800124:	6a 00                	push   $0x0
  800126:	6a 00                	push   $0x0
  800128:	6a 0b                	push   $0xb
  80012a:	68 60 30 80 00       	push   $0x803060
  80012f:	e8 e4 18 00 00       	call   801a18 <sys_check_WS_list>
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("LRU alg. failed.. trace it by printing WS before and after page fault");
  80013a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80013e:	74 14                	je     800154 <_main+0x11c>
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	68 40 1e 80 00       	push   $0x801e40
  800148:	6a 43                	push   $0x43
  80014a:	68 d4 1d 80 00       	push   $0x801dd4
  80014f:	e8 30 02 00 00       	call   800384 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Disk Access... \n");
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	68 88 1e 80 00       	push   $0x801e88
  80015c:	6a 03                	push   $0x3
  80015e:	e8 1c 05 00 00       	call   80067f <cprintf_colored>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 17;
  800166:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
		uint32 expectedNumOfWrites = 6;
  80016d:	c7 45 e0 06 00 00 00 	movl   $0x6,-0x20(%ebp)
		uint32 expectedNumOfReads = 17;
  800174:	c7 45 dc 11 00 00 00 	movl   $0x11,-0x24(%ebp)
		if (myEnv->nPageIn != expectedNumOfReads || myEnv->nPageOut != expectedNumOfWrites || myEnv->pageFaultsCounter != expectedNumOfFaults)
  80017b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800180:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800186:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800189:	75 20                	jne    8001ab <_main+0x173>
  80018b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800190:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800196:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800199:	75 10                	jne    8001ab <_main+0x173>
  80019b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a0:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001a9:	74 14                	je     8001bf <_main+0x187>
			panic("LRU alg. failed.. unexpected number of disk access");
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 b0 1e 80 00       	push   $0x801eb0
  8001b3:	6a 4b                	push   $0x4b
  8001b5:	68 d4 1d 80 00       	push   $0x801dd4
  8001ba:	e8 c5 01 00 00       	call   800384 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	68 e4 1e 80 00       	push   $0x801ee4
  8001c7:	6a 0a                	push   $0xa
  8001c9:	e8 b1 04 00 00       	call   80067f <cprintf_colored>
  8001ce:	83 c4 10             	add    $0x10,%esp
	return;
  8001d1:	90                   	nop
}
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	57                   	push   %edi
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001dd:	e8 3d 16 00 00       	call   80181f <sys_getenvindex>
  8001e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	c1 e0 02             	shl    $0x2,%eax
  8001ed:	01 d0                	add    %edx,%eax
  8001ef:	c1 e0 03             	shl    $0x3,%eax
  8001f2:	01 d0                	add    %edx,%eax
  8001f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001fb:	01 d0                	add    %edx,%eax
  8001fd:	c1 e0 02             	shl    $0x2,%eax
  800200:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800205:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80020f:	8a 40 20             	mov    0x20(%eax),%al
  800212:	84 c0                	test   %al,%al
  800214:	74 0d                	je     800223 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800216:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80021b:	83 c0 20             	add    $0x20,%eax
  80021e:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800227:	7e 0a                	jle    800233 <libmain+0x5f>
		binaryname = argv[0];
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022c:	8b 00                	mov    (%eax),%eax
  80022e:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	e8 f7 fd ff ff       	call   800038 <_main>
  800241:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800244:	a1 8c 30 80 00       	mov    0x80308c,%eax
  800249:	85 c0                	test   %eax,%eax
  80024b:	0f 84 01 01 00 00    	je     800352 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800251:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800257:	bb 30 20 80 00       	mov    $0x802030,%ebx
  80025c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800261:	89 c7                	mov    %eax,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	89 d1                	mov    %edx,%ecx
  800267:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800269:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80026c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800271:	b0 00                	mov    $0x0,%al
  800273:	89 d7                	mov    %edx,%edi
  800275:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800277:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80027e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	50                   	push   %eax
  800285:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80028b:	50                   	push   %eax
  80028c:	e8 c4 17 00 00       	call   801a55 <sys_utilities>
  800291:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800294:	e8 0d 13 00 00       	call   8015a6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	68 50 1f 80 00       	push   $0x801f50
  8002a1:	e8 ac 03 00 00       	call   800652 <cprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	74 18                	je     8002c8 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b0:	e8 be 17 00 00       	call   801a73 <sys_get_optimal_num_faults>
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	50                   	push   %eax
  8002b9:	68 78 1f 80 00       	push   $0x801f78
  8002be:	e8 8f 03 00 00       	call   800652 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb 59                	jmp    800321 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002cd:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002d3:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002d8:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 9c 1f 80 00       	push   $0x801f9c
  8002e8:	e8 65 03 00 00       	call   800652 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002f5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002fb:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800300:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800306:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80030b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 c4 1f 80 00       	push   $0x801fc4
  800319:	e8 34 03 00 00       	call   800652 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800326:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 1c 20 80 00       	push   $0x80201c
  800335:	e8 18 03 00 00       	call   800652 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 50 1f 80 00       	push   $0x801f50
  800345:	e8 08 03 00 00       	call   800652 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80034d:	e8 6e 12 00 00       	call   8015c0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800352:	e8 1f 00 00 00       	call   800376 <exit>
}
  800357:	90                   	nop
  800358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035b:	5b                   	pop    %ebx
  80035c:	5e                   	pop    %esi
  80035d:	5f                   	pop    %edi
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	6a 00                	push   $0x0
  80036b:	e8 7b 14 00 00       	call   8017eb <sys_destroy_env>
  800370:	83 c4 10             	add    $0x10,%esp
}
  800373:	90                   	nop
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <exit>:

void
exit(void)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037c:	e8 d0 14 00 00       	call   801851 <sys_exit_env>
}
  800381:	90                   	nop
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80038a:	8d 45 10             	lea    0x10(%ebp),%eax
  80038d:	83 c0 04             	add    $0x4,%eax
  800390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800393:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 16                	je     8003b2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80039c:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	50                   	push   %eax
  8003a5:	68 94 20 80 00       	push   $0x802094
  8003aa:	e8 a3 02 00 00       	call   800652 <cprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003b2:	a1 90 30 80 00       	mov    0x803090,%eax
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	50                   	push   %eax
  8003c1:	68 9c 20 80 00       	push   $0x80209c
  8003c6:	6a 74                	push   $0x74
  8003c8:	e8 b2 02 00 00       	call   80067f <cprintf_colored>
  8003cd:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d9:	50                   	push   %eax
  8003da:	e8 04 02 00 00       	call   8005e3 <vcprintf>
  8003df:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	6a 00                	push   $0x0
  8003e7:	68 c4 20 80 00       	push   $0x8020c4
  8003ec:	e8 f2 01 00 00       	call   8005e3 <vcprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f4:	e8 7d ff ff ff       	call   800376 <exit>

	// should not return here
	while (1) ;
  8003f9:	eb fe                	jmp    8003f9 <_panic+0x75>

008003fb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800401:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800406:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	39 c2                	cmp    %eax,%edx
  800411:	74 14                	je     800427 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 c8 20 80 00       	push   $0x8020c8
  80041b:	6a 26                	push   $0x26
  80041d:	68 14 21 80 00       	push   $0x802114
  800422:	e8 5d ff ff ff       	call   800384 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80042e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800435:	e9 c5 00 00 00       	jmp    8004ff <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80043a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	85 c0                	test   %eax,%eax
  80044d:	75 08                	jne    800457 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80044f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800452:	e9 a5 00 00 00       	jmp    8004fc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800457:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800465:	eb 69                	jmp    8004d0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800467:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80046c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800472:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800475:	89 d0                	mov    %edx,%eax
  800477:	01 c0                	add    %eax,%eax
  800479:	01 d0                	add    %edx,%eax
  80047b:	c1 e0 03             	shl    $0x3,%eax
  80047e:	01 c8                	add    %ecx,%eax
  800480:	8a 40 04             	mov    0x4(%eax),%al
  800483:	84 c0                	test   %al,%al
  800485:	75 46                	jne    8004cd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800487:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80048c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800492:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800495:	89 d0                	mov    %edx,%eax
  800497:	01 c0                	add    %eax,%eax
  800499:	01 d0                	add    %edx,%eax
  80049b:	c1 e0 03             	shl    $0x3,%eax
  80049e:	01 c8                	add    %ecx,%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004ad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c8                	add    %ecx,%eax
  8004be:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c0:	39 c2                	cmp    %eax,%edx
  8004c2:	75 09                	jne    8004cd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004c4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cb:	eb 15                	jmp    8004e2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cd:	ff 45 e8             	incl   -0x18(%ebp)
  8004d0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004d5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004de:	39 c2                	cmp    %eax,%edx
  8004e0:	77 85                	ja     800467 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e6:	75 14                	jne    8004fc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 20 21 80 00       	push   $0x802120
  8004f0:	6a 3a                	push   $0x3a
  8004f2:	68 14 21 80 00       	push   $0x802114
  8004f7:	e8 88 fe ff ff       	call   800384 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fc:	ff 45 f0             	incl   -0x10(%ebp)
  8004ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800502:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800505:	0f 8c 2f ff ff ff    	jl     80043a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800519:	eb 26                	jmp    800541 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800520:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800529:	89 d0                	mov    %edx,%eax
  80052b:	01 c0                	add    %eax,%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	c1 e0 03             	shl    $0x3,%eax
  800532:	01 c8                	add    %ecx,%eax
  800534:	8a 40 04             	mov    0x4(%eax),%al
  800537:	3c 01                	cmp    $0x1,%al
  800539:	75 03                	jne    80053e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80053b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053e:	ff 45 e0             	incl   -0x20(%ebp)
  800541:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800546:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	77 c8                	ja     80051b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800556:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800559:	74 14                	je     80056f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 74 21 80 00       	push   $0x802174
  800563:	6a 44                	push   $0x44
  800565:	68 14 21 80 00       	push   $0x802114
  80056a:	e8 15 fe ff ff       	call   800384 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056f:	90                   	nop
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	53                   	push   %ebx
  800576:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 48 01             	lea    0x1(%eax),%ecx
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	89 0a                	mov    %ecx,(%edx)
  800586:	8b 55 08             	mov    0x8(%ebp),%edx
  800589:	88 d1                	mov    %dl,%cl
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800592:	8b 45 0c             	mov    0xc(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	3d ff 00 00 00       	cmp    $0xff,%eax
  80059c:	75 30                	jne    8005ce <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80059e:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005a4:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005a9:	0f b6 c0             	movzbl %al,%eax
  8005ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005af:	8b 09                	mov    (%ecx),%ecx
  8005b1:	89 cb                	mov    %ecx,%ebx
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	83 c1 08             	add    $0x8,%ecx
  8005b9:	52                   	push   %edx
  8005ba:	50                   	push   %eax
  8005bb:	53                   	push   %ebx
  8005bc:	51                   	push   %ecx
  8005bd:	e8 a0 0f 00 00       	call   801562 <sys_cputs>
  8005c2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 40 04             	mov    0x4(%eax),%eax
  8005d4:	8d 50 01             	lea    0x1(%eax),%edx
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005dd:	90                   	nop
  8005de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e1:	c9                   	leave  
  8005e2:	c3                   	ret    

008005e3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f3:	00 00 00 
	b.cnt = 0;
  8005f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005fd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	68 72 05 80 00       	push   $0x800572
  800612:	e8 5a 02 00 00       	call   800871 <vprintfmt>
  800617:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80061a:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  800620:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800625:	0f b6 c0             	movzbl %al,%eax
  800628:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80062e:	52                   	push   %edx
  80062f:	50                   	push   %eax
  800630:	51                   	push   %ecx
  800631:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800637:	83 c0 08             	add    $0x8,%eax
  80063a:	50                   	push   %eax
  80063b:	e8 22 0f 00 00       	call   801562 <sys_cputs>
  800640:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800643:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  80064a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800650:	c9                   	leave  
  800651:	c3                   	ret    

00800652 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800658:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  80065f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800662:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 f4             	pushl  -0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	e8 6f ff ff ff       	call   8005e3 <vcprintf>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800685:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	c1 e0 08             	shl    $0x8,%eax
  800692:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  800697:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069a:	83 c0 04             	add    $0x4,%eax
  80069d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a9:	50                   	push   %eax
  8006aa:	e8 34 ff ff ff       	call   8005e3 <vcprintf>
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006b5:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  8006bc:	07 00 00 

	return cnt;
  8006bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ca:	e8 d7 0e 00 00       	call   8015a6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	50                   	push   %eax
  8006df:	e8 ff fe ff ff       	call   8005e3 <vcprintf>
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ea:	e8 d1 0e 00 00       	call   8015c0 <sys_unlock_cons>
	return cnt;
  8006ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	53                   	push   %ebx
  8006f8:	83 ec 14             	sub    $0x14,%esp
  8006fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800707:	8b 45 18             	mov    0x18(%ebp),%eax
  80070a:	ba 00 00 00 00       	mov    $0x0,%edx
  80070f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800712:	77 55                	ja     800769 <printnum+0x75>
  800714:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800717:	72 05                	jb     80071e <printnum+0x2a>
  800719:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80071c:	77 4b                	ja     800769 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800721:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800724:	8b 45 18             	mov    0x18(%ebp),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	ff 75 f0             	pushl  -0x10(%ebp)
  800734:	e8 ab 13 00 00       	call   801ae4 <__udivdi3>
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	83 ec 04             	sub    $0x4,%esp
  80073f:	ff 75 20             	pushl  0x20(%ebp)
  800742:	53                   	push   %ebx
  800743:	ff 75 18             	pushl  0x18(%ebp)
  800746:	52                   	push   %edx
  800747:	50                   	push   %eax
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	ff 75 08             	pushl  0x8(%ebp)
  80074e:	e8 a1 ff ff ff       	call   8006f4 <printnum>
  800753:	83 c4 20             	add    $0x20,%esp
  800756:	eb 1a                	jmp    800772 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	ff 75 20             	pushl  0x20(%ebp)
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800769:	ff 4d 1c             	decl   0x1c(%ebp)
  80076c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800770:	7f e6                	jg     800758 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800772:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800775:	bb 00 00 00 00       	mov    $0x0,%ebx
  80077a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800780:	53                   	push   %ebx
  800781:	51                   	push   %ecx
  800782:	52                   	push   %edx
  800783:	50                   	push   %eax
  800784:	e8 6b 14 00 00       	call   801bf4 <__umoddi3>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800791:	8a 00                	mov    (%eax),%al
  800793:	0f be c0             	movsbl %al,%eax
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	50                   	push   %eax
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
}
  8007a5:	90                   	nop
  8007a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b2:	7e 1c                	jle    8007d0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	8d 50 08             	lea    0x8(%eax),%edx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	89 10                	mov    %edx,(%eax)
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	83 e8 08             	sub    $0x8,%eax
  8007c9:	8b 50 04             	mov    0x4(%eax),%edx
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	eb 40                	jmp    800810 <getuint+0x65>
	else if (lflag)
  8007d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d4:	74 1e                	je     8007f4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	8d 50 04             	lea    0x4(%eax),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 10                	mov    %edx,(%eax)
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	eb 1c                	jmp    800810 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	8d 50 04             	lea    0x4(%eax),%edx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	89 10                	mov    %edx,(%eax)
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	83 e8 04             	sub    $0x4,%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800815:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800819:	7e 1c                	jle    800837 <getint+0x25>
		return va_arg(*ap, long long);
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	8d 50 08             	lea    0x8(%eax),%edx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	89 10                	mov    %edx,(%eax)
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	83 e8 08             	sub    $0x8,%eax
  800830:	8b 50 04             	mov    0x4(%eax),%edx
  800833:	8b 00                	mov    (%eax),%eax
  800835:	eb 38                	jmp    80086f <getint+0x5d>
	else if (lflag)
  800837:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80083b:	74 1a                	je     800857 <getint+0x45>
		return va_arg(*ap, long);
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	8d 50 04             	lea    0x4(%eax),%edx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 10                	mov    %edx,(%eax)
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	99                   	cltd   
  800855:	eb 18                	jmp    80086f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	8d 50 04             	lea    0x4(%eax),%edx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	89 10                	mov    %edx,(%eax)
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	83 e8 04             	sub    $0x4,%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	99                   	cltd   
}
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	56                   	push   %esi
  800875:	53                   	push   %ebx
  800876:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	eb 17                	jmp    800892 <vprintfmt+0x21>
			if (ch == '\0')
  80087b:	85 db                	test   %ebx,%ebx
  80087d:	0f 84 c1 03 00 00    	je     800c44 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	53                   	push   %ebx
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	8d 50 01             	lea    0x1(%eax),%edx
  800898:	89 55 10             	mov    %edx,0x10(%ebp)
  80089b:	8a 00                	mov    (%eax),%al
  80089d:	0f b6 d8             	movzbl %al,%ebx
  8008a0:	83 fb 25             	cmp    $0x25,%ebx
  8008a3:	75 d6                	jne    80087b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008be:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c8:	8d 50 01             	lea    0x1(%eax),%edx
  8008cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ce:	8a 00                	mov    (%eax),%al
  8008d0:	0f b6 d8             	movzbl %al,%ebx
  8008d3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008d6:	83 f8 5b             	cmp    $0x5b,%eax
  8008d9:	0f 87 3d 03 00 00    	ja     800c1c <vprintfmt+0x3ab>
  8008df:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8008e6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008e8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ec:	eb d7                	jmp    8008c5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ee:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008f2:	eb d1                	jmp    8008c5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fe:	89 d0                	mov    %edx,%eax
  800900:	c1 e0 02             	shl    $0x2,%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	01 c0                	add    %eax,%eax
  800907:	01 d8                	add    %ebx,%eax
  800909:	83 e8 30             	sub    $0x30,%eax
  80090c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	8a 00                	mov    (%eax),%al
  800914:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800917:	83 fb 2f             	cmp    $0x2f,%ebx
  80091a:	7e 3e                	jle    80095a <vprintfmt+0xe9>
  80091c:	83 fb 39             	cmp    $0x39,%ebx
  80091f:	7f 39                	jg     80095a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800921:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800924:	eb d5                	jmp    8008fb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80093a:	eb 1f                	jmp    80095b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	79 83                	jns    8008c5 <vprintfmt+0x54>
				width = 0;
  800942:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800949:	e9 77 ff ff ff       	jmp    8008c5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80094e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800955:	e9 6b ff ff ff       	jmp    8008c5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80095a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	0f 89 60 ff ff ff    	jns    8008c5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800972:	e9 4e ff ff ff       	jmp    8008c5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800977:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80097a:	e9 46 ff ff ff       	jmp    8008c5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 c0 04             	add    $0x4,%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	50                   	push   %eax
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	ff d0                	call   *%eax
  80099c:	83 c4 10             	add    $0x10,%esp
			break;
  80099f:	e9 9b 02 00 00       	jmp    800c3f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009b5:	85 db                	test   %ebx,%ebx
  8009b7:	79 02                	jns    8009bb <vprintfmt+0x14a>
				err = -err;
  8009b9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009bb:	83 fb 64             	cmp    $0x64,%ebx
  8009be:	7f 0b                	jg     8009cb <vprintfmt+0x15a>
  8009c0:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8009c7:	85 f6                	test   %esi,%esi
  8009c9:	75 19                	jne    8009e4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009cb:	53                   	push   %ebx
  8009cc:	68 e5 23 80 00       	push   $0x8023e5
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	ff 75 08             	pushl  0x8(%ebp)
  8009d7:	e8 70 02 00 00       	call   800c4c <printfmt>
  8009dc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009df:	e9 5b 02 00 00       	jmp    800c3f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e4:	56                   	push   %esi
  8009e5:	68 ee 23 80 00       	push   $0x8023ee
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 57 02 00 00       	call   800c4c <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			break;
  8009f8:	e9 42 02 00 00       	jmp    800c3f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	83 c0 04             	add    $0x4,%eax
  800a03:	89 45 14             	mov    %eax,0x14(%ebp)
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	83 e8 04             	sub    $0x4,%eax
  800a0c:	8b 30                	mov    (%eax),%esi
  800a0e:	85 f6                	test   %esi,%esi
  800a10:	75 05                	jne    800a17 <vprintfmt+0x1a6>
				p = "(null)";
  800a12:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800a17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1b:	7e 6d                	jle    800a8a <vprintfmt+0x219>
  800a1d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a21:	74 67                	je     800a8a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	50                   	push   %eax
  800a2a:	56                   	push   %esi
  800a2b:	e8 1e 03 00 00       	call   800d4e <strnlen>
  800a30:	83 c4 10             	add    $0x10,%esp
  800a33:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a36:	eb 16                	jmp    800a4e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a38:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	50                   	push   %eax
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	7f e4                	jg     800a38 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a54:	eb 34                	jmp    800a8a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a5a:	74 1c                	je     800a78 <vprintfmt+0x207>
  800a5c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a5f:	7e 05                	jle    800a66 <vprintfmt+0x1f5>
  800a61:	83 fb 7e             	cmp    $0x7e,%ebx
  800a64:	7e 12                	jle    800a78 <vprintfmt+0x207>
					putch('?', putdat);
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	6a 3f                	push   $0x3f
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	ff d0                	call   *%eax
  800a73:	83 c4 10             	add    $0x10,%esp
  800a76:	eb 0f                	jmp    800a87 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a87:	ff 4d e4             	decl   -0x1c(%ebp)
  800a8a:	89 f0                	mov    %esi,%eax
  800a8c:	8d 70 01             	lea    0x1(%eax),%esi
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be d8             	movsbl %al,%ebx
  800a94:	85 db                	test   %ebx,%ebx
  800a96:	74 24                	je     800abc <vprintfmt+0x24b>
  800a98:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9c:	78 b8                	js     800a56 <vprintfmt+0x1e5>
  800a9e:	ff 4d e0             	decl   -0x20(%ebp)
  800aa1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa5:	79 af                	jns    800a56 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa7:	eb 13                	jmp    800abc <vprintfmt+0x24b>
				putch(' ', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 20                	push   $0x20
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab9:	ff 4d e4             	decl   -0x1c(%ebp)
  800abc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac0:	7f e7                	jg     800aa9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ac2:	e9 78 01 00 00       	jmp    800c3f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 e8             	pushl  -0x18(%ebp)
  800acd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad0:	50                   	push   %eax
  800ad1:	e8 3c fd ff ff       	call   800812 <getint>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae5:	85 d2                	test   %edx,%edx
  800ae7:	79 23                	jns    800b0c <vprintfmt+0x29b>
				putch('-', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 2d                	push   $0x2d
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aff:	f7 d8                	neg    %eax
  800b01:	83 d2 00             	adc    $0x0,%edx
  800b04:	f7 da                	neg    %edx
  800b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b09:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b0c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b13:	e9 bc 00 00 00       	jmp    800bd4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b21:	50                   	push   %eax
  800b22:	e8 84 fc ff ff       	call   8007ab <getuint>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b30:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b37:	e9 98 00 00 00       	jmp    800bd4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 58                	push   $0x58
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	6a 58                	push   $0x58
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 58                	push   $0x58
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	e9 ce 00 00 00       	jmp    800c3f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 30                	push   $0x30
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 78                	push   $0x78
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b91:	8b 45 14             	mov    0x14(%ebp),%eax
  800b94:	83 c0 04             	add    $0x4,%eax
  800b97:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9d:	83 e8 04             	sub    $0x4,%eax
  800ba0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bb3:	eb 1f                	jmp    800bd4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbe:	50                   	push   %eax
  800bbf:	e8 e7 fb ff ff       	call   8007ab <getuint>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bcd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdb:	83 ec 04             	sub    $0x4,%esp
  800bde:	52                   	push   %edx
  800bdf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be2:	50                   	push   %eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	ff 75 f0             	pushl  -0x10(%ebp)
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	ff 75 08             	pushl  0x8(%ebp)
  800bef:	e8 00 fb ff ff       	call   8006f4 <printnum>
  800bf4:	83 c4 20             	add    $0x20,%esp
			break;
  800bf7:	eb 46                	jmp    800c3f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
			break;
  800c08:	eb 35                	jmp    800c3f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c0a:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800c11:	eb 2c                	jmp    800c3f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c13:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800c1a:	eb 23                	jmp    800c3f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	6a 25                	push   $0x25
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	ff d0                	call   *%eax
  800c29:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2c:	ff 4d 10             	decl   0x10(%ebp)
  800c2f:	eb 03                	jmp    800c34 <vprintfmt+0x3c3>
  800c31:	ff 4d 10             	decl   0x10(%ebp)
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	48                   	dec    %eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	3c 25                	cmp    $0x25,%al
  800c3c:	75 f3                	jne    800c31 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c3e:	90                   	nop
		}
	}
  800c3f:	e9 35 fc ff ff       	jmp    800879 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c44:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c52:	8d 45 10             	lea    0x10(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	ff 75 08             	pushl  0x8(%ebp)
  800c68:	e8 04 fc ff ff       	call   800871 <vprintfmt>
  800c6d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c70:	90                   	nop
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	8b 40 08             	mov    0x8(%eax),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 10                	mov    (%eax),%edx
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8b 40 04             	mov    0x4(%eax),%eax
  800c90:	39 c2                	cmp    %eax,%edx
  800c92:	73 12                	jae    800ca6 <sprintputch+0x33>
		*b->buf++ = ch;
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9f:	89 0a                	mov    %ecx,(%edx)
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	88 10                	mov    %dl,(%eax)
}
  800ca6:	90                   	nop
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	01 d0                	add    %edx,%eax
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cce:	74 06                	je     800cd6 <vsnprintf+0x2d>
  800cd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd4:	7f 07                	jg     800cdd <vsnprintf+0x34>
		return -E_INVAL;
  800cd6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdb:	eb 20                	jmp    800cfd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdd:	ff 75 14             	pushl  0x14(%ebp)
  800ce0:	ff 75 10             	pushl  0x10(%ebp)
  800ce3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce6:	50                   	push   %eax
  800ce7:	68 73 0c 80 00       	push   $0x800c73
  800cec:	e8 80 fb ff ff       	call   800871 <vprintfmt>
  800cf1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d05:	8d 45 10             	lea    0x10(%ebp),%eax
  800d08:	83 c0 04             	add    $0x4,%eax
  800d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d11:	ff 75 f4             	pushl  -0xc(%ebp)
  800d14:	50                   	push   %eax
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	ff 75 08             	pushl  0x8(%ebp)
  800d1b:	e8 89 ff ff ff       	call   800ca9 <vsnprintf>
  800d20:	83 c4 10             	add    $0x10,%esp
  800d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d38:	eb 06                	jmp    800d40 <strlen+0x15>
		n++;
  800d3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 f1                	jne    800d3a <strlen+0xf>
		n++;
	return n;
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5b:	eb 09                	jmp    800d66 <strnlen+0x18>
		n++;
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	ff 4d 0c             	decl   0xc(%ebp)
  800d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6a:	74 09                	je     800d75 <strnlen+0x27>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 e8                	jne    800d5d <strnlen+0xf>
		n++;
	return n;
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d86:	90                   	nop
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d99:	8a 12                	mov    (%edx),%dl
  800d9b:	88 10                	mov    %dl,(%eax)
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e4                	jne    800d87 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbb:	eb 1f                	jmp    800ddc <strncpy+0x34>
		*dst++ = *src;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8d 50 01             	lea    0x1(%eax),%edx
  800dc3:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc9:	8a 12                	mov    (%edx),%dl
  800dcb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	84 c0                	test   %al,%al
  800dd4:	74 03                	je     800dd9 <strncpy+0x31>
			src++;
  800dd6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd9:	ff 45 fc             	incl   -0x4(%ebp)
  800ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de2:	72 d9                	jb     800dbd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df9:	74 30                	je     800e2b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfb:	eb 16                	jmp    800e13 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 08             	mov    %edx,0x8(%ebp)
  800e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e13:	ff 4d 10             	decl   0x10(%ebp)
  800e16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1a:	74 09                	je     800e25 <strlcpy+0x3c>
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	75 d8                	jne    800dfd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e31:	29 c2                	sub    %eax,%edx
  800e33:	89 d0                	mov    %edx,%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e3a:	eb 06                	jmp    800e42 <strcmp+0xb>
		p++, q++;
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	74 0e                	je     800e59 <strcmp+0x22>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 10                	mov    (%eax),%dl
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	38 c2                	cmp    %al,%dl
  800e57:	74 e3                	je     800e3c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	0f b6 d0             	movzbl %al,%edx
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	0f b6 c0             	movzbl %al,%eax
  800e69:	29 c2                	sub    %eax,%edx
  800e6b:	89 d0                	mov    %edx,%eax
}
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e72:	eb 09                	jmp    800e7d <strncmp+0xe>
		n--, p++, q++;
  800e74:	ff 4d 10             	decl   0x10(%ebp)
  800e77:	ff 45 08             	incl   0x8(%ebp)
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e81:	74 17                	je     800e9a <strncmp+0x2b>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	84 c0                	test   %al,%al
  800e8a:	74 0e                	je     800e9a <strncmp+0x2b>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 10                	mov    (%eax),%dl
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	38 c2                	cmp    %al,%dl
  800e98:	74 da                	je     800e74 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	75 07                	jne    800ea7 <strncmp+0x38>
		return 0;
  800ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea5:	eb 14                	jmp    800ebb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 d0             	movzbl %al,%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 c0             	movzbl %al,%eax
  800eb7:	29 c2                	sub    %eax,%edx
  800eb9:	89 d0                	mov    %edx,%eax
}
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec9:	eb 12                	jmp    800edd <strchr+0x20>
		if (*s == c)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed3:	75 05                	jne    800eda <strchr+0x1d>
			return (char *) s;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	eb 11                	jmp    800eeb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eda:	ff 45 08             	incl   0x8(%ebp)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	84 c0                	test   %al,%al
  800ee4:	75 e5                	jne    800ecb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 04             	sub    $0x4,%esp
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef9:	eb 0d                	jmp    800f08 <strfind+0x1b>
		if (*s == c)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f03:	74 0e                	je     800f13 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	75 ea                	jne    800efb <strfind+0xe>
  800f11:	eb 01                	jmp    800f14 <strfind+0x27>
		if (*s == c)
			break;
  800f13:	90                   	nop
	return (char *) s;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f25:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f29:	76 63                	jbe    800f8e <memset+0x75>
		uint64 data_block = c;
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	99                   	cltd   
  800f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f32:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f3f:	c1 e0 08             	shl    $0x8,%eax
  800f42:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f45:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f52:	c1 e0 10             	shl    $0x10,%eax
  800f55:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f58:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	89 c2                	mov    %eax,%edx
  800f63:	b8 00 00 00 00       	mov    $0x0,%eax
  800f68:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f6b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f6e:	eb 18                	jmp    800f88 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f70:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f73:	8d 41 08             	lea    0x8(%ecx),%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7f:	89 01                	mov    %eax,(%ecx)
  800f81:	89 51 04             	mov    %edx,0x4(%ecx)
  800f84:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f88:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8c:	77 e2                	ja     800f70 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	74 23                	je     800fb7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f97:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9a:	eb 0e                	jmp    800faa <memset+0x91>
			*p8++ = (uint8)c;
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9f:	8d 50 01             	lea    0x1(%eax),%edx
  800fa2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 e5                	jne    800f9c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fce:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd2:	76 24                	jbe    800ff8 <memcpy+0x3c>
		while(n >= 8){
  800fd4:	eb 1c                	jmp    800ff2 <memcpy+0x36>
			*d64 = *s64;
  800fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd9:	8b 50 04             	mov    0x4(%eax),%edx
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe1:	89 01                	mov    %eax,(%ecx)
  800fe3:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fe6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fea:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fee:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ff2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff6:	77 de                	ja     800fd6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ff8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffc:	74 31                	je     80102f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801001:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801007:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80100a:	eb 16                	jmp    801022 <memcpy+0x66>
			*d8++ = *s8++;
  80100c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80101e:	8a 12                	mov    (%edx),%dl
  801020:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	8d 50 ff             	lea    -0x1(%eax),%edx
  801028:	89 55 10             	mov    %edx,0x10(%ebp)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 dd                	jne    80100c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801049:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104c:	73 50                	jae    80109e <memmove+0x6a>
  80104e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801059:	76 43                	jbe    80109e <memmove+0x6a>
		s += n;
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801067:	eb 10                	jmp    801079 <memmove+0x45>
			*--d = *--s;
  801069:	ff 4d f8             	decl   -0x8(%ebp)
  80106c:	ff 4d fc             	decl   -0x4(%ebp)
  80106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801072:	8a 10                	mov    (%eax),%dl
  801074:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801077:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107f:	89 55 10             	mov    %edx,0x10(%ebp)
  801082:	85 c0                	test   %eax,%eax
  801084:	75 e3                	jne    801069 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801086:	eb 23                	jmp    8010ab <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801094:	8d 4a 01             	lea    0x1(%edx),%ecx
  801097:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109a:	8a 12                	mov    (%edx),%dl
  80109c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	75 dd                	jne    801088 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c2:	eb 2a                	jmp    8010ee <memcmp+0x3e>
		if (*s1 != *s2)
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	8a 10                	mov    (%eax),%dl
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	38 c2                	cmp    %al,%dl
  8010d0:	74 16                	je     8010e8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f b6 d0             	movzbl %al,%edx
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	0f b6 c0             	movzbl %al,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	eb 18                	jmp    801100 <memcmp+0x50>
		s1++, s2++;
  8010e8:	ff 45 fc             	incl   -0x4(%ebp)
  8010eb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	75 c9                	jne    8010c4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801108:	8b 55 08             	mov    0x8(%ebp),%edx
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801113:	eb 15                	jmp    80112a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	0f b6 d0             	movzbl %al,%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	0f b6 c0             	movzbl %al,%eax
  801123:	39 c2                	cmp    %eax,%edx
  801125:	74 0d                	je     801134 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801130:	72 e3                	jb     801115 <memfind+0x13>
  801132:	eb 01                	jmp    801135 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801134:	90                   	nop
	return (void *) s;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801147:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114e:	eb 03                	jmp    801153 <strtol+0x19>
		s++;
  801150:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 20                	cmp    $0x20,%al
  80115a:	74 f4                	je     801150 <strtol+0x16>
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 09                	cmp    $0x9,%al
  801163:	74 eb                	je     801150 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 2b                	cmp    $0x2b,%al
  80116c:	75 05                	jne    801173 <strtol+0x39>
		s++;
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	eb 13                	jmp    801186 <strtol+0x4c>
	else if (*s == '-')
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 2d                	cmp    $0x2d,%al
  80117a:	75 0a                	jne    801186 <strtol+0x4c>
		s++, neg = 1;
  80117c:	ff 45 08             	incl   0x8(%ebp)
  80117f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	74 06                	je     801192 <strtol+0x58>
  80118c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801190:	75 20                	jne    8011b2 <strtol+0x78>
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	3c 30                	cmp    $0x30,%al
  801199:	75 17                	jne    8011b2 <strtol+0x78>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	40                   	inc    %eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 78                	cmp    $0x78,%al
  8011a3:	75 0d                	jne    8011b2 <strtol+0x78>
		s += 2, base = 16;
  8011a5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b0:	eb 28                	jmp    8011da <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 15                	jne    8011cd <strtol+0x93>
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 30                	cmp    $0x30,%al
  8011bf:	75 0c                	jne    8011cd <strtol+0x93>
		s++, base = 8;
  8011c1:	ff 45 08             	incl   0x8(%ebp)
  8011c4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011cb:	eb 0d                	jmp    8011da <strtol+0xa0>
	else if (base == 0)
  8011cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d1:	75 07                	jne    8011da <strtol+0xa0>
		base = 10;
  8011d3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	3c 2f                	cmp    $0x2f,%al
  8011e1:	7e 19                	jle    8011fc <strtol+0xc2>
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	3c 39                	cmp    $0x39,%al
  8011ea:	7f 10                	jg     8011fc <strtol+0xc2>
			dig = *s - '0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	0f be c0             	movsbl %al,%eax
  8011f4:	83 e8 30             	sub    $0x30,%eax
  8011f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fa:	eb 42                	jmp    80123e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 60                	cmp    $0x60,%al
  801203:	7e 19                	jle    80121e <strtol+0xe4>
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 7a                	cmp    $0x7a,%al
  80120c:	7f 10                	jg     80121e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	0f be c0             	movsbl %al,%eax
  801216:	83 e8 57             	sub    $0x57,%eax
  801219:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121c:	eb 20                	jmp    80123e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	3c 40                	cmp    $0x40,%al
  801225:	7e 39                	jle    801260 <strtol+0x126>
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 5a                	cmp    $0x5a,%al
  80122e:	7f 30                	jg     801260 <strtol+0x126>
			dig = *s - 'A' + 10;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	0f be c0             	movsbl %al,%eax
  801238:	83 e8 37             	sub    $0x37,%eax
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80123e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801241:	3b 45 10             	cmp    0x10(%ebp),%eax
  801244:	7d 19                	jge    80125f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801250:	89 c2                	mov    %eax,%edx
  801252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125a:	e9 7b ff ff ff       	jmp    8011da <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80125f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801260:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801264:	74 08                	je     80126e <strtol+0x134>
		*endptr = (char *) s;
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	8b 55 08             	mov    0x8(%ebp),%edx
  80126c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80126e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801272:	74 07                	je     80127b <strtol+0x141>
  801274:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801277:	f7 d8                	neg    %eax
  801279:	eb 03                	jmp    80127e <strtol+0x144>
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <ltostr>:

void
ltostr(long value, char *str)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80128d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801298:	79 13                	jns    8012ad <ltostr+0x2d>
	{
		neg = 1;
  80129a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012aa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b5:	99                   	cltd   
  8012b6:	f7 f9                	idiv   %ecx
  8012b8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 d0                	add    %edx,%eax
  8012cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ce:	83 c2 30             	add    $0x30,%edx
  8012d1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012db:	f7 e9                	imul   %ecx
  8012dd:	c1 fa 02             	sar    $0x2,%edx
  8012e0:	89 c8                	mov    %ecx,%eax
  8012e2:	c1 f8 1f             	sar    $0x1f,%eax
  8012e5:	29 c2                	sub    %eax,%edx
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f0:	75 bb                	jne    8012ad <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fc:	48                   	dec    %eax
  8012fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801300:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801304:	74 3d                	je     801343 <ltostr+0xc3>
		start = 1 ;
  801306:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80130d:	eb 34                	jmp    801343 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80130f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 c8                	add    %ecx,%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801330:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133b:	88 02                	mov    %al,(%edx)
		start++ ;
  80133d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801340:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801346:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801349:	7c c4                	jl     80130f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801356:	90                   	nop
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80135f:	ff 75 08             	pushl  0x8(%ebp)
  801362:	e8 c4 f9 ff ff       	call   800d2b <strlen>
  801367:	83 c4 04             	add    $0x4,%esp
  80136a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80136d:	ff 75 0c             	pushl  0xc(%ebp)
  801370:	e8 b6 f9 ff ff       	call   800d2b <strlen>
  801375:	83 c4 04             	add    $0x4,%esp
  801378:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801389:	eb 17                	jmp    8013a2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138e:	8b 45 10             	mov    0x10(%ebp),%eax
  801391:	01 c2                	add    %eax,%edx
  801393:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	01 c8                	add    %ecx,%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80139f:	ff 45 fc             	incl   -0x4(%ebp)
  8013a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a8:	7c e1                	jl     80138b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b8:	eb 1f                	jmp    8013d9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bd:	8d 50 01             	lea    0x1(%eax),%edx
  8013c0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	01 c2                	add    %eax,%edx
  8013ca:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 c8                	add    %ecx,%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d6:	ff 45 f8             	incl   -0x8(%ebp)
  8013d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013df:	7c d9                	jl     8013ba <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	8b 00                	mov    (%eax),%eax
  801400:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801407:	8b 45 10             	mov    0x10(%ebp),%eax
  80140a:	01 d0                	add    %edx,%eax
  80140c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801412:	eb 0c                	jmp    801420 <strsplit+0x31>
			*string++ = 0;
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8d 50 01             	lea    0x1(%eax),%edx
  80141a:	89 55 08             	mov    %edx,0x8(%ebp)
  80141d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	84 c0                	test   %al,%al
  801427:	74 18                	je     801441 <strsplit+0x52>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	50                   	push   %eax
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 83 fa ff ff       	call   800ebd <strchr>
  80143a:	83 c4 08             	add    $0x8,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	75 d3                	jne    801414 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	84 c0                	test   %al,%al
  801448:	74 5a                	je     8014a4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	83 f8 0f             	cmp    $0xf,%eax
  801452:	75 07                	jne    80145b <strsplit+0x6c>
		{
			return 0;
  801454:	b8 00 00 00 00       	mov    $0x0,%eax
  801459:	eb 66                	jmp    8014c1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145b:	8b 45 14             	mov    0x14(%ebp),%eax
  80145e:	8b 00                	mov    (%eax),%eax
  801460:	8d 48 01             	lea    0x1(%eax),%ecx
  801463:	8b 55 14             	mov    0x14(%ebp),%edx
  801466:	89 0a                	mov    %ecx,(%edx)
  801468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146f:	8b 45 10             	mov    0x10(%ebp),%eax
  801472:	01 c2                	add    %eax,%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801479:	eb 03                	jmp    80147e <strsplit+0x8f>
			string++;
  80147b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	74 8b                	je     801412 <strsplit+0x23>
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	0f be c0             	movsbl %al,%eax
  80148f:	50                   	push   %eax
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	e8 25 fa ff ff       	call   800ebd <strchr>
  801498:	83 c4 08             	add    $0x8,%esp
  80149b:	85 c0                	test   %eax,%eax
  80149d:	74 dc                	je     80147b <strsplit+0x8c>
			string++;
	}
  80149f:	e9 6e ff ff ff       	jmp    801412 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a8:	8b 00                	mov    (%eax),%eax
  8014aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d6:	eb 4a                	jmp    801522 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	01 c2                	add    %eax,%edx
  8014e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	01 c8                	add    %ecx,%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	01 d0                	add    %edx,%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 40                	cmp    $0x40,%al
  8014f8:	7e 25                	jle    80151f <str2lower+0x5c>
  8014fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	3c 5a                	cmp    $0x5a,%al
  801506:	7f 17                	jg     80151f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	01 d0                	add    %edx,%eax
  801510:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	01 ca                	add    %ecx,%edx
  801518:	8a 12                	mov    (%edx),%dl
  80151a:	83 c2 20             	add    $0x20,%edx
  80151d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80151f:	ff 45 fc             	incl   -0x4(%ebp)
  801522:	ff 75 0c             	pushl  0xc(%ebp)
  801525:	e8 01 f8 ff ff       	call   800d2b <strlen>
  80152a:	83 c4 04             	add    $0x4,%esp
  80152d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801530:	7f a6                	jg     8014d8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801549:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80154f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801552:	cd 30                	int    $0x30
  801554:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5e                   	pop    %esi
  80155f:	5f                   	pop    %edi
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	8b 45 10             	mov    0x10(%ebp),%eax
  80156b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80156e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801571:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	51                   	push   %ecx
  80157b:	52                   	push   %edx
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	50                   	push   %eax
  801580:	6a 00                	push   $0x0
  801582:	e8 b0 ff ff ff       	call   801537 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_cgetc>:

int
sys_cgetc(void)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 02                	push   $0x2
  80159c:	e8 96 ff ff ff       	call   801537 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 03                	push   $0x3
  8015b5:	e8 7d ff ff ff       	call   801537 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	90                   	nop
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 04                	push   $0x4
  8015cf:	e8 63 ff ff ff       	call   801537 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	90                   	nop
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	52                   	push   %edx
  8015ea:	50                   	push   %eax
  8015eb:	6a 08                	push   $0x8
  8015ed:	e8 45 ff ff ff       	call   801537 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	56                   	push   %esi
  8015fb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8015ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801602:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	56                   	push   %esi
  80160c:	53                   	push   %ebx
  80160d:	51                   	push   %ecx
  80160e:	52                   	push   %edx
  80160f:	50                   	push   %eax
  801610:	6a 09                	push   $0x9
  801612:	e8 20 ff ff ff       	call   801537 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5e                   	pop    %esi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	6a 0a                	push   $0xa
  801631:	e8 01 ff ff ff       	call   801537 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	ff 75 08             	pushl  0x8(%ebp)
  80164a:	6a 0b                	push   $0xb
  80164c:	e8 e6 fe ff ff       	call   801537 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 0c                	push   $0xc
  801665:	e8 cd fe ff ff       	call   801537 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 0d                	push   $0xd
  80167e:	e8 b4 fe ff ff       	call   801537 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 0e                	push   $0xe
  801697:	e8 9b fe ff ff       	call   801537 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 0f                	push   $0xf
  8016b0:	e8 82 fe ff ff       	call   801537 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	6a 10                	push   $0x10
  8016ca:	e8 68 fe ff ff       	call   801537 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 11                	push   $0x11
  8016e3:	e8 4f fe ff ff       	call   801537 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	90                   	nop
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_cputc>:

void
sys_cputc(const char c)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	50                   	push   %eax
  801707:	6a 01                	push   $0x1
  801709:	e8 29 fe ff ff       	call   801537 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	90                   	nop
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 14                	push   $0x14
  801723:	e8 0f fe ff ff       	call   801537 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	8b 45 10             	mov    0x10(%ebp),%eax
  801737:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80173a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80173d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	6a 00                	push   $0x0
  801746:	51                   	push   %ecx
  801747:	52                   	push   %edx
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	50                   	push   %eax
  80174c:	6a 15                	push   $0x15
  80174e:	e8 e4 fd ff ff       	call   801537 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 16                	push   $0x16
  80176b:	e8 c7 fd ff ff       	call   801537 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801778:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	51                   	push   %ecx
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 17                	push   $0x17
  80178a:	e8 a8 fd ff ff       	call   801537 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	6a 18                	push   $0x18
  8017a7:	e8 8b fd ff ff       	call   801537 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 14             	pushl  0x14(%ebp)
  8017bc:	ff 75 10             	pushl  0x10(%ebp)
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	6a 19                	push   $0x19
  8017c5:	e8 6d fd ff ff       	call   801537 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	50                   	push   %eax
  8017de:	6a 1a                	push   $0x1a
  8017e0:	e8 52 fd ff ff       	call   801537 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	50                   	push   %eax
  8017fa:	6a 1b                	push   $0x1b
  8017fc:	e8 36 fd ff ff       	call   801537 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 05                	push   $0x5
  801815:	e8 1d fd ff ff       	call   801537 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 06                	push   $0x6
  80182e:	e8 04 fd ff ff       	call   801537 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 07                	push   $0x7
  801847:	e8 eb fc ff ff       	call   801537 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_exit_env>:


void sys_exit_env(void)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 1c                	push   $0x1c
  801860:	e8 d2 fc ff ff       	call   801537 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801871:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801874:	8d 50 04             	lea    0x4(%eax),%edx
  801877:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 1d                	push   $0x1d
  801884:	e8 ae fc ff ff       	call   801537 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
	return result;
  80188c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801892:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801895:	89 01                	mov    %eax,(%ecx)
  801897:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	c9                   	leave  
  80189e:	c2 04 00             	ret    $0x4

008018a1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 13                	push   $0x13
  8018b3:	e8 7f fc ff ff       	call   801537 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_rcr2>:
uint32 sys_rcr2()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 1e                	push   $0x1e
  8018cd:	e8 65 fc ff ff       	call   801537 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018e3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	50                   	push   %eax
  8018f0:	6a 1f                	push   $0x1f
  8018f2:	e8 40 fc ff ff       	call   801537 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fa:	90                   	nop
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <rsttst>:
void rsttst()
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 21                	push   $0x21
  80190c:	e8 26 fc ff ff       	call   801537 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
	return ;
  801914:	90                   	nop
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801923:	8b 55 18             	mov    0x18(%ebp),%edx
  801926:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 20                	push   $0x20
  801937:	e8 fb fb ff ff       	call   801537 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return ;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <chktst>:
void chktst(uint32 n)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	6a 22                	push   $0x22
  801952:	e8 e0 fb ff ff       	call   801537 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
	return ;
  80195a:	90                   	nop
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <inctst>:

void inctst()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 23                	push   $0x23
  80196c:	e8 c6 fb ff ff       	call   801537 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
	return ;
  801974:	90                   	nop
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <gettst>:
uint32 gettst()
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 24                	push   $0x24
  801986:	e8 ac fb ff ff       	call   801537 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 25                	push   $0x25
  80199f:	e8 93 fb ff ff       	call   801537 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
  8019a7:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  8019ac:	a1 00 71 82 00       	mov    0x827100,%eax
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 08             	pushl  0x8(%ebp)
  8019c9:	6a 26                	push   $0x26
  8019cb:	e8 67 fb ff ff       	call   801537 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d3:	90                   	nop
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	53                   	push   %ebx
  8019e9:	51                   	push   %ecx
  8019ea:	52                   	push   %edx
  8019eb:	50                   	push   %eax
  8019ec:	6a 27                	push   $0x27
  8019ee:	e8 44 fb ff ff       	call   801537 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 28                	push   $0x28
  801a0e:	e8 24 fb ff ff       	call   801537 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	51                   	push   %ecx
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 29                	push   $0x29
  801a2e:	e8 04 fb ff ff       	call   801537 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 10             	pushl  0x10(%ebp)
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 12                	push   $0x12
  801a4a:	e8 e8 fa ff ff       	call   801537 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a52:	90                   	nop
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 2a                	push   $0x2a
  801a68:	e8 ca fa ff ff       	call   801537 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
	return;
  801a70:	90                   	nop
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 2b                	push   $0x2b
  801a82:	e8 b0 fa ff ff       	call   801537 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	ff 75 08             	pushl  0x8(%ebp)
  801a9b:	6a 2d                	push   $0x2d
  801a9d:	e8 95 fa ff ff       	call   801537 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
	return;
  801aa5:	90                   	nop
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	6a 2c                	push   $0x2c
  801ab9:	e8 79 fa ff ff       	call   801537 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	68 68 25 80 00       	push   $0x802568
  801ad2:	68 25 01 00 00       	push   $0x125
  801ad7:	68 9b 25 80 00       	push   $0x80259b
  801adc:	e8 a3 e8 ff ff       	call   800384 <_panic>
  801ae1:	66 90                	xchg   %ax,%ax
  801ae3:	90                   	nop

00801ae4 <__udivdi3>:
  801ae4:	55                   	push   %ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 1c             	sub    $0x1c,%esp
  801aeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801af7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afb:	89 ca                	mov    %ecx,%edx
  801afd:	89 f8                	mov    %edi,%eax
  801aff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b03:	85 f6                	test   %esi,%esi
  801b05:	75 2d                	jne    801b34 <__udivdi3+0x50>
  801b07:	39 cf                	cmp    %ecx,%edi
  801b09:	77 65                	ja     801b70 <__udivdi3+0x8c>
  801b0b:	89 fd                	mov    %edi,%ebp
  801b0d:	85 ff                	test   %edi,%edi
  801b0f:	75 0b                	jne    801b1c <__udivdi3+0x38>
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	31 d2                	xor    %edx,%edx
  801b18:	f7 f7                	div    %edi
  801b1a:	89 c5                	mov    %eax,%ebp
  801b1c:	31 d2                	xor    %edx,%edx
  801b1e:	89 c8                	mov    %ecx,%eax
  801b20:	f7 f5                	div    %ebp
  801b22:	89 c1                	mov    %eax,%ecx
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	f7 f5                	div    %ebp
  801b28:	89 cf                	mov    %ecx,%edi
  801b2a:	89 fa                	mov    %edi,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	39 ce                	cmp    %ecx,%esi
  801b36:	77 28                	ja     801b60 <__udivdi3+0x7c>
  801b38:	0f bd fe             	bsr    %esi,%edi
  801b3b:	83 f7 1f             	xor    $0x1f,%edi
  801b3e:	75 40                	jne    801b80 <__udivdi3+0x9c>
  801b40:	39 ce                	cmp    %ecx,%esi
  801b42:	72 0a                	jb     801b4e <__udivdi3+0x6a>
  801b44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b48:	0f 87 9e 00 00 00    	ja     801bec <__udivdi3+0x108>
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	89 fa                	mov    %edi,%edx
  801b55:	83 c4 1c             	add    $0x1c,%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5f                   	pop    %edi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    
  801b5d:	8d 76 00             	lea    0x0(%esi),%esi
  801b60:	31 ff                	xor    %edi,%edi
  801b62:	31 c0                	xor    %eax,%eax
  801b64:	89 fa                	mov    %edi,%edx
  801b66:	83 c4 1c             	add    $0x1c,%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5f                   	pop    %edi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	f7 f7                	div    %edi
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	89 fa                	mov    %edi,%edx
  801b78:	83 c4 1c             	add    $0x1c,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
  801b80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b85:	89 eb                	mov    %ebp,%ebx
  801b87:	29 fb                	sub    %edi,%ebx
  801b89:	89 f9                	mov    %edi,%ecx
  801b8b:	d3 e6                	shl    %cl,%esi
  801b8d:	89 c5                	mov    %eax,%ebp
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 ed                	shr    %cl,%ebp
  801b93:	89 e9                	mov    %ebp,%ecx
  801b95:	09 f1                	or     %esi,%ecx
  801b97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b9b:	89 f9                	mov    %edi,%ecx
  801b9d:	d3 e0                	shl    %cl,%eax
  801b9f:	89 c5                	mov    %eax,%ebp
  801ba1:	89 d6                	mov    %edx,%esi
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 ee                	shr    %cl,%esi
  801ba7:	89 f9                	mov    %edi,%ecx
  801ba9:	d3 e2                	shl    %cl,%edx
  801bab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 e8                	shr    %cl,%eax
  801bb3:	09 c2                	or     %eax,%edx
  801bb5:	89 d0                	mov    %edx,%eax
  801bb7:	89 f2                	mov    %esi,%edx
  801bb9:	f7 74 24 0c          	divl   0xc(%esp)
  801bbd:	89 d6                	mov    %edx,%esi
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	f7 e5                	mul    %ebp
  801bc3:	39 d6                	cmp    %edx,%esi
  801bc5:	72 19                	jb     801be0 <__udivdi3+0xfc>
  801bc7:	74 0b                	je     801bd4 <__udivdi3+0xf0>
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	31 ff                	xor    %edi,%edi
  801bcd:	e9 58 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bd8:	89 f9                	mov    %edi,%ecx
  801bda:	d3 e2                	shl    %cl,%edx
  801bdc:	39 c2                	cmp    %eax,%edx
  801bde:	73 e9                	jae    801bc9 <__udivdi3+0xe5>
  801be0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801be3:	31 ff                	xor    %edi,%edi
  801be5:	e9 40 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	31 c0                	xor    %eax,%eax
  801bee:	e9 37 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bf3:	90                   	nop

00801bf4 <__umoddi3>:
  801bf4:	55                   	push   %ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 1c             	sub    $0x1c,%esp
  801bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c13:	89 f3                	mov    %esi,%ebx
  801c15:	89 fa                	mov    %edi,%edx
  801c17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c1b:	89 34 24             	mov    %esi,(%esp)
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	75 1a                	jne    801c3c <__umoddi3+0x48>
  801c22:	39 f7                	cmp    %esi,%edi
  801c24:	0f 86 a2 00 00 00    	jbe    801ccc <__umoddi3+0xd8>
  801c2a:	89 c8                	mov    %ecx,%eax
  801c2c:	89 f2                	mov    %esi,%edx
  801c2e:	f7 f7                	div    %edi
  801c30:	89 d0                	mov    %edx,%eax
  801c32:	31 d2                	xor    %edx,%edx
  801c34:	83 c4 1c             	add    $0x1c,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    
  801c3c:	39 f0                	cmp    %esi,%eax
  801c3e:	0f 87 ac 00 00 00    	ja     801cf0 <__umoddi3+0xfc>
  801c44:	0f bd e8             	bsr    %eax,%ebp
  801c47:	83 f5 1f             	xor    $0x1f,%ebp
  801c4a:	0f 84 ac 00 00 00    	je     801cfc <__umoddi3+0x108>
  801c50:	bf 20 00 00 00       	mov    $0x20,%edi
  801c55:	29 ef                	sub    %ebp,%edi
  801c57:	89 fe                	mov    %edi,%esi
  801c59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c5d:	89 e9                	mov    %ebp,%ecx
  801c5f:	d3 e0                	shl    %cl,%eax
  801c61:	89 d7                	mov    %edx,%edi
  801c63:	89 f1                	mov    %esi,%ecx
  801c65:	d3 ef                	shr    %cl,%edi
  801c67:	09 c7                	or     %eax,%edi
  801c69:	89 e9                	mov    %ebp,%ecx
  801c6b:	d3 e2                	shl    %cl,%edx
  801c6d:	89 14 24             	mov    %edx,(%esp)
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	d3 e0                	shl    %cl,%eax
  801c74:	89 c2                	mov    %eax,%edx
  801c76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7a:	d3 e0                	shl    %cl,%eax
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c84:	89 f1                	mov    %esi,%ecx
  801c86:	d3 e8                	shr    %cl,%eax
  801c88:	09 d0                	or     %edx,%eax
  801c8a:	d3 eb                	shr    %cl,%ebx
  801c8c:	89 da                	mov    %ebx,%edx
  801c8e:	f7 f7                	div    %edi
  801c90:	89 d3                	mov    %edx,%ebx
  801c92:	f7 24 24             	mull   (%esp)
  801c95:	89 c6                	mov    %eax,%esi
  801c97:	89 d1                	mov    %edx,%ecx
  801c99:	39 d3                	cmp    %edx,%ebx
  801c9b:	0f 82 87 00 00 00    	jb     801d28 <__umoddi3+0x134>
  801ca1:	0f 84 91 00 00 00    	je     801d38 <__umoddi3+0x144>
  801ca7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cab:	29 f2                	sub    %esi,%edx
  801cad:	19 cb                	sbb    %ecx,%ebx
  801caf:	89 d8                	mov    %ebx,%eax
  801cb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cb5:	d3 e0                	shl    %cl,%eax
  801cb7:	89 e9                	mov    %ebp,%ecx
  801cb9:	d3 ea                	shr    %cl,%edx
  801cbb:	09 d0                	or     %edx,%eax
  801cbd:	89 e9                	mov    %ebp,%ecx
  801cbf:	d3 eb                	shr    %cl,%ebx
  801cc1:	89 da                	mov    %ebx,%edx
  801cc3:	83 c4 1c             	add    $0x1c,%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5f                   	pop    %edi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    
  801ccb:	90                   	nop
  801ccc:	89 fd                	mov    %edi,%ebp
  801cce:	85 ff                	test   %edi,%edi
  801cd0:	75 0b                	jne    801cdd <__umoddi3+0xe9>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	31 d2                	xor    %edx,%edx
  801cd9:	f7 f7                	div    %edi
  801cdb:	89 c5                	mov    %eax,%ebp
  801cdd:	89 f0                	mov    %esi,%eax
  801cdf:	31 d2                	xor    %edx,%edx
  801ce1:	f7 f5                	div    %ebp
  801ce3:	89 c8                	mov    %ecx,%eax
  801ce5:	f7 f5                	div    %ebp
  801ce7:	89 d0                	mov    %edx,%eax
  801ce9:	e9 44 ff ff ff       	jmp    801c32 <__umoddi3+0x3e>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	89 c8                	mov    %ecx,%eax
  801cf2:	89 f2                	mov    %esi,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	3b 04 24             	cmp    (%esp),%eax
  801cff:	72 06                	jb     801d07 <__umoddi3+0x113>
  801d01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d05:	77 0f                	ja     801d16 <__umoddi3+0x122>
  801d07:	89 f2                	mov    %esi,%edx
  801d09:	29 f9                	sub    %edi,%ecx
  801d0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d0f:	89 14 24             	mov    %edx,(%esp)
  801d12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d1a:	8b 14 24             	mov    (%esp),%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	2b 04 24             	sub    (%esp),%eax
  801d2b:	19 fa                	sbb    %edi,%edx
  801d2d:	89 d1                	mov    %edx,%ecx
  801d2f:	89 c6                	mov    %eax,%esi
  801d31:	e9 71 ff ff ff       	jmp    801ca7 <__umoddi3+0xb3>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d3c:	72 ea                	jb     801d28 <__umoddi3+0x134>
  801d3e:	89 d9                	mov    %ebx,%ecx
  801d40:	e9 62 ff ff ff       	jmp    801ca7 <__umoddi3+0xb3>
