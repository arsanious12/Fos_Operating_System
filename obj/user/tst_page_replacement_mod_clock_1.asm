
obj/user/tst_page_replacement_mod_clock_1:     file format elf32-i386


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
  800031:	e8 a1 01 00 00       	call   8001d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedFinalVAs[11] = {
		0x827000, 0x808000, 0x802000, 0x803000, 0x809000, 0x800000, 0x801000, 0x804000, 0x80b000, 0x80c000,  	//Code & Data
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
  80004c:	e8 ca 19 00 00       	call   801a1b <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 1d 80 00       	push   $0x801d60
  800065:	6a 1b                	push   $0x1b
  800067:	68 d4 1d 80 00       	push   $0x801dd4
  80006c:	e8 16 03 00 00       	call   800387 <_panic>
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
		//*ptr = *ptr2 ;
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
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 fc 1d 80 00       	push   $0x801dfc
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 b3 05 00 00       	call   800682 <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 15 1e 80 00       	push   $0x801e15
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 d4 1d 80 00       	push   $0x801dd4
  8000ed:	e8 95 02 00 00       	call   800387 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 15 1e 80 00       	push   $0x801e15
  800106:	6a 3b                	push   $0x3b
  800108:	68 d4 1d 80 00       	push   $0x801dd4
  80010d:	e8 75 02 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE MODIFIED CLOCK algorithm... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 24 1e 80 00       	push   $0x801e24
  80011a:	6a 03                	push   $0x3
  80011c:	e8 61 05 00 00       	call   800682 <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x80b000, 1);
  800124:	6a 01                	push   $0x1
  800126:	68 00 b0 80 00       	push   $0x80b000
  80012b:	6a 0b                	push   $0xb
  80012d:	68 60 30 80 00       	push   $0x803060
  800132:	e8 e4 18 00 00       	call   801a1b <sys_check_WS_list>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("MODIFIED CLOCK alg. failed.. trace it by printing WS before and after page fault");
  80013d:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 54 1e 80 00       	push   $0x801e54
  80014b:	6a 40                	push   $0x40
  80014d:	68 d4 1d 80 00       	push   $0x801dd4
  800152:	e8 30 02 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Disk Access... \n");
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	68 a8 1e 80 00       	push   $0x801ea8
  80015f:	6a 03                	push   $0x3
  800161:	e8 1c 05 00 00       	call   800682 <cprintf_colored>
  800166:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 20;
  800169:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
		uint32 expectedNumOfWrites = 6;
  800170:	c7 45 e0 06 00 00 00 	movl   $0x6,-0x20(%ebp)
		uint32 expectedNumOfReads = 20;
  800177:	c7 45 dc 14 00 00 00 	movl   $0x14,-0x24(%ebp)
		if (myEnv->nPageIn != expectedNumOfReads || myEnv->nPageOut != expectedNumOfWrites || myEnv->pageFaultsCounter != expectedNumOfFaults)
  80017e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800183:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800189:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80018c:	75 20                	jne    8001ae <_main+0x176>
  80018e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800193:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800199:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80019c:	75 10                	jne    8001ae <_main+0x176>
  80019e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a3:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
			panic("MODIFIED CLOCK alg. failed.. unexpected number of disk access");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 d0 1e 80 00       	push   $0x801ed0
  8001b6:	6a 48                	push   $0x48
  8001b8:	68 d4 1d 80 00       	push   $0x801dd4
  8001bd:	e8 c5 01 00 00       	call   800387 <_panic>
	}
	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [MODIFIED CLOCK Alg.] is completed successfully.\n");
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 10 1f 80 00       	push   $0x801f10
  8001ca:	6a 0a                	push   $0xa
  8001cc:	e8 b1 04 00 00       	call   800682 <cprintf_colored>
  8001d1:	83 c4 10             	add    $0x10,%esp
	return;
  8001d4:	90                   	nop
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e0:	e8 3d 16 00 00       	call   801822 <sys_getenvindex>
  8001e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001eb:	89 d0                	mov    %edx,%eax
  8001ed:	c1 e0 02             	shl    $0x2,%eax
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	01 d0                	add    %edx,%eax
  8001f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001fe:	01 d0                	add    %edx,%eax
  800200:	c1 e0 02             	shl    $0x2,%eax
  800203:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800208:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800212:	8a 40 20             	mov    0x20(%eax),%al
  800215:	84 c0                	test   %al,%al
  800217:	74 0d                	je     800226 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800219:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80021e:	83 c0 20             	add    $0x20,%eax
  800221:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022a:	7e 0a                	jle    800236 <libmain+0x5f>
		binaryname = argv[0];
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	ff 75 0c             	pushl  0xc(%ebp)
  80023c:	ff 75 08             	pushl  0x8(%ebp)
  80023f:	e8 f4 fd ff ff       	call   800038 <_main>
  800244:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800247:	a1 8c 30 80 00       	mov    0x80308c,%eax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	0f 84 01 01 00 00    	je     800355 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800254:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80025a:	bb 68 20 80 00       	mov    $0x802068,%ebx
  80025f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800264:	89 c7                	mov    %eax,%edi
  800266:	89 de                	mov    %ebx,%esi
  800268:	89 d1                	mov    %edx,%ecx
  80026a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80026c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80026f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800274:	b0 00                	mov    $0x0,%al
  800276:	89 d7                	mov    %edx,%edi
  800278:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80027a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800281:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	50                   	push   %eax
  800288:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	e8 c4 17 00 00       	call   801a58 <sys_utilities>
  800294:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800297:	e8 0d 13 00 00       	call   8015a9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 88 1f 80 00       	push   $0x801f88
  8002a4:	e8 ac 03 00 00       	call   800655 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 18                	je     8002cb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b3:	e8 be 17 00 00       	call   801a76 <sys_get_optimal_num_faults>
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	50                   	push   %eax
  8002bc:	68 b0 1f 80 00       	push   $0x801fb0
  8002c1:	e8 8f 03 00 00       	call   800655 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	eb 59                	jmp    800324 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002cb:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002d0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002d6:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002db:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	52                   	push   %edx
  8002e5:	50                   	push   %eax
  8002e6:	68 d4 1f 80 00       	push   $0x801fd4
  8002eb:	e8 65 03 00 00       	call   800655 <cprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f3:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002f8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002fe:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800303:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800309:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80030e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800314:	51                   	push   %ecx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	68 fc 1f 80 00       	push   $0x801ffc
  80031c:	e8 34 03 00 00       	call   800655 <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800324:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800329:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	50                   	push   %eax
  800333:	68 54 20 80 00       	push   $0x802054
  800338:	e8 18 03 00 00       	call   800655 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 88 1f 80 00       	push   $0x801f88
  800348:	e8 08 03 00 00       	call   800655 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800350:	e8 6e 12 00 00       	call   8015c3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800355:	e8 1f 00 00 00       	call   800379 <exit>
}
  80035a:	90                   	nop
  80035b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035e:	5b                   	pop    %ebx
  80035f:	5e                   	pop    %esi
  800360:	5f                   	pop    %edi
  800361:	5d                   	pop    %ebp
  800362:	c3                   	ret    

00800363 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	6a 00                	push   $0x0
  80036e:	e8 7b 14 00 00       	call   8017ee <sys_destroy_env>
  800373:	83 c4 10             	add    $0x10,%esp
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <exit>:

void
exit(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037f:	e8 d0 14 00 00       	call   801854 <sys_exit_env>
}
  800384:	90                   	nop
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80038d:	8d 45 10             	lea    0x10(%ebp),%eax
  800390:	83 c0 04             	add    $0x4,%eax
  800393:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800396:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 16                	je     8003b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80039f:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	50                   	push   %eax
  8003a8:	68 cc 20 80 00       	push   $0x8020cc
  8003ad:	e8 a3 02 00 00       	call   800655 <cprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003b5:	a1 90 30 80 00       	mov    0x803090,%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	ff 75 0c             	pushl  0xc(%ebp)
  8003c0:	ff 75 08             	pushl  0x8(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	68 d4 20 80 00       	push   $0x8020d4
  8003c9:	6a 74                	push   $0x74
  8003cb:	e8 b2 02 00 00       	call   800682 <cprintf_colored>
  8003d0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dc:	50                   	push   %eax
  8003dd:	e8 04 02 00 00       	call   8005e6 <vcprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	6a 00                	push   $0x0
  8003ea:	68 fc 20 80 00       	push   $0x8020fc
  8003ef:	e8 f2 01 00 00       	call   8005e6 <vcprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f7:	e8 7d ff ff ff       	call   800379 <exit>

	// should not return here
	while (1) ;
  8003fc:	eb fe                	jmp    8003fc <_panic+0x75>

008003fe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800404:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800409:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800412:	39 c2                	cmp    %eax,%edx
  800414:	74 14                	je     80042a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 00 21 80 00       	push   $0x802100
  80041e:	6a 26                	push   $0x26
  800420:	68 4c 21 80 00       	push   $0x80214c
  800425:	e8 5d ff ff ff       	call   800387 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800438:	e9 c5 00 00 00       	jmp    800502 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80043d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800440:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	01 d0                	add    %edx,%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	75 08                	jne    80045a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800452:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800455:	e9 a5 00 00 00       	jmp    8004ff <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80045a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800461:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800468:	eb 69                	jmp    8004d3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80046f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800475:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8a 40 04             	mov    0x4(%eax),%al
  800486:	84 c0                	test   %al,%al
  800488:	75 46                	jne    8004d0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80048f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800495:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800498:	89 d0                	mov    %edx,%eax
  80049a:	01 c0                	add    %eax,%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	c1 e0 03             	shl    $0x3,%eax
  8004a1:	01 c8                	add    %ecx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	01 c8                	add    %ecx,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c3:	39 c2                	cmp    %eax,%edx
  8004c5:	75 09                	jne    8004d0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004ce:	eb 15                	jmp    8004e5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d0:	ff 45 e8             	incl   -0x18(%ebp)
  8004d3:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e1:	39 c2                	cmp    %eax,%edx
  8004e3:	77 85                	ja     80046a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e9:	75 14                	jne    8004ff <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004eb:	83 ec 04             	sub    $0x4,%esp
  8004ee:	68 58 21 80 00       	push   $0x802158
  8004f3:	6a 3a                	push   $0x3a
  8004f5:	68 4c 21 80 00       	push   $0x80214c
  8004fa:	e8 88 fe ff ff       	call   800387 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004ff:	ff 45 f0             	incl   -0x10(%ebp)
  800502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800505:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800508:	0f 8c 2f ff ff ff    	jl     80043d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800515:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051c:	eb 26                	jmp    800544 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800523:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800529:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052c:	89 d0                	mov    %edx,%eax
  80052e:	01 c0                	add    %eax,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	c1 e0 03             	shl    $0x3,%eax
  800535:	01 c8                	add    %ecx,%eax
  800537:	8a 40 04             	mov    0x4(%eax),%al
  80053a:	3c 01                	cmp    $0x1,%al
  80053c:	75 03                	jne    800541 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80053e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800541:	ff 45 e0             	incl   -0x20(%ebp)
  800544:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800549:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	39 c2                	cmp    %eax,%edx
  800554:	77 c8                	ja     80051e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800559:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80055c:	74 14                	je     800572 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80055e:	83 ec 04             	sub    $0x4,%esp
  800561:	68 ac 21 80 00       	push   $0x8021ac
  800566:	6a 44                	push   $0x44
  800568:	68 4c 21 80 00       	push   $0x80214c
  80056d:	e8 15 fe ff ff       	call   800387 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800572:	90                   	nop
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	53                   	push   %ebx
  800579:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80057c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	8d 48 01             	lea    0x1(%eax),%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	89 0a                	mov    %ecx,(%edx)
  800589:	8b 55 08             	mov    0x8(%ebp),%edx
  80058c:	88 d1                	mov    %dl,%cl
  80058e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800591:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80059f:	75 30                	jne    8005d1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005a1:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005a7:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005ac:	0f b6 c0             	movzbl %al,%eax
  8005af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b2:	8b 09                	mov    (%ecx),%ecx
  8005b4:	89 cb                	mov    %ecx,%ebx
  8005b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b9:	83 c1 08             	add    $0x8,%ecx
  8005bc:	52                   	push   %edx
  8005bd:	50                   	push   %eax
  8005be:	53                   	push   %ebx
  8005bf:	51                   	push   %ecx
  8005c0:	e8 a0 0f 00 00       	call   801565 <sys_cputs>
  8005c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d4:	8b 40 04             	mov    0x4(%eax),%eax
  8005d7:	8d 50 01             	lea    0x1(%eax),%edx
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e0:	90                   	nop
  8005e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 75 05 80 00       	push   $0x800575
  800615:	e8 5a 02 00 00       	call   800874 <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80061d:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  800623:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800628:	0f b6 c0             	movzbl %al,%eax
  80062b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	51                   	push   %ecx
  800634:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063a:	83 c0 08             	add    $0x8,%eax
  80063d:	50                   	push   %eax
  80063e:	e8 22 0f 00 00       	call   801565 <sys_cputs>
  800643:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800646:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  80064d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80065b:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  800662:	8d 45 0c             	lea    0xc(%ebp),%eax
  800665:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 f4             	pushl  -0xc(%ebp)
  800671:	50                   	push   %eax
  800672:	e8 6f ff ff ff       	call   8005e6 <vcprintf>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80067d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800688:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	c1 e0 08             	shl    $0x8,%eax
  800695:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  80069a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069d:	83 c0 04             	add    $0x4,%eax
  8006a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ac:	50                   	push   %eax
  8006ad:	e8 34 ff ff ff       	call   8005e6 <vcprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006b8:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  8006bf:	07 00 00 

	return cnt;
  8006c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    

008006c7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006c7:	55                   	push   %ebp
  8006c8:	89 e5                	mov    %esp,%ebp
  8006ca:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006cd:	e8 d7 0e 00 00       	call   8015a9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006d2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e1:	50                   	push   %eax
  8006e2:	e8 ff fe ff ff       	call   8005e6 <vcprintf>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ed:	e8 d1 0e 00 00       	call   8015c3 <sys_unlock_cons>
	return cnt;
  8006f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	53                   	push   %ebx
  8006fb:	83 ec 14             	sub    $0x14,%esp
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070a:	8b 45 18             	mov    0x18(%ebp),%eax
  80070d:	ba 00 00 00 00       	mov    $0x0,%edx
  800712:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800715:	77 55                	ja     80076c <printnum+0x75>
  800717:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071a:	72 05                	jb     800721 <printnum+0x2a>
  80071c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80071f:	77 4b                	ja     80076c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800721:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800724:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800727:	8b 45 18             	mov    0x18(%ebp),%eax
  80072a:	ba 00 00 00 00       	mov    $0x0,%edx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	ff 75 f4             	pushl  -0xc(%ebp)
  800734:	ff 75 f0             	pushl  -0x10(%ebp)
  800737:	e8 a8 13 00 00       	call   801ae4 <__udivdi3>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	83 ec 04             	sub    $0x4,%esp
  800742:	ff 75 20             	pushl  0x20(%ebp)
  800745:	53                   	push   %ebx
  800746:	ff 75 18             	pushl  0x18(%ebp)
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	ff 75 08             	pushl  0x8(%ebp)
  800751:	e8 a1 ff ff ff       	call   8006f7 <printnum>
  800756:	83 c4 20             	add    $0x20,%esp
  800759:	eb 1a                	jmp    800775 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	ff 75 20             	pushl  0x20(%ebp)
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80076c:	ff 4d 1c             	decl   0x1c(%ebp)
  80076f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800773:	7f e6                	jg     80075b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800775:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800778:	bb 00 00 00 00       	mov    $0x0,%ebx
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800783:	53                   	push   %ebx
  800784:	51                   	push   %ecx
  800785:	52                   	push   %edx
  800786:	50                   	push   %eax
  800787:	e8 68 14 00 00       	call   801bf4 <__umoddi3>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	05 14 24 80 00       	add    $0x802414,%eax
  800794:	8a 00                	mov    (%eax),%al
  800796:	0f be c0             	movsbl %al,%eax
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	50                   	push   %eax
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	ff d0                	call   *%eax
  8007a5:	83 c4 10             	add    $0x10,%esp
}
  8007a8:	90                   	nop
  8007a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b5:	7e 1c                	jle    8007d3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	8d 50 08             	lea    0x8(%eax),%edx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	89 10                	mov    %edx,(%eax)
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	83 e8 08             	sub    $0x8,%eax
  8007cc:	8b 50 04             	mov    0x4(%eax),%edx
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	eb 40                	jmp    800813 <getuint+0x65>
	else if (lflag)
  8007d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d7:	74 1e                	je     8007f7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 04             	lea    0x4(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 04             	sub    $0x4,%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	eb 1c                	jmp    800813 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800818:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80081c:	7e 1c                	jle    80083a <getint+0x25>
		return va_arg(*ap, long long);
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	8d 50 08             	lea    0x8(%eax),%edx
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	89 10                	mov    %edx,(%eax)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	83 e8 08             	sub    $0x8,%eax
  800833:	8b 50 04             	mov    0x4(%eax),%edx
  800836:	8b 00                	mov    (%eax),%eax
  800838:	eb 38                	jmp    800872 <getint+0x5d>
	else if (lflag)
  80083a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80083e:	74 1a                	je     80085a <getint+0x45>
		return va_arg(*ap, long);
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	8d 50 04             	lea    0x4(%eax),%edx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	89 10                	mov    %edx,(%eax)
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	83 e8 04             	sub    $0x4,%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	99                   	cltd   
  800858:	eb 18                	jmp    800872 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 04             	lea    0x4(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	99                   	cltd   
}
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	56                   	push   %esi
  800878:	53                   	push   %ebx
  800879:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087c:	eb 17                	jmp    800895 <vprintfmt+0x21>
			if (ch == '\0')
  80087e:	85 db                	test   %ebx,%ebx
  800880:	0f 84 c1 03 00 00    	je     800c47 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	53                   	push   %ebx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800895:	8b 45 10             	mov    0x10(%ebp),%eax
  800898:	8d 50 01             	lea    0x1(%eax),%edx
  80089b:	89 55 10             	mov    %edx,0x10(%ebp)
  80089e:	8a 00                	mov    (%eax),%al
  8008a0:	0f b6 d8             	movzbl %al,%ebx
  8008a3:	83 fb 25             	cmp    $0x25,%ebx
  8008a6:	75 d6                	jne    80087e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cb:	8d 50 01             	lea    0x1(%eax),%edx
  8008ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d1:	8a 00                	mov    (%eax),%al
  8008d3:	0f b6 d8             	movzbl %al,%ebx
  8008d6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008d9:	83 f8 5b             	cmp    $0x5b,%eax
  8008dc:	0f 87 3d 03 00 00    	ja     800c1f <vprintfmt+0x3ab>
  8008e2:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  8008e9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ef:	eb d7                	jmp    8008c8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008f5:	eb d1                	jmp    8008c8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	c1 e0 02             	shl    $0x2,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	01 c0                	add    %eax,%eax
  80090a:	01 d8                	add    %ebx,%eax
  80090c:	83 e8 30             	sub    $0x30,%eax
  80090f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800912:	8b 45 10             	mov    0x10(%ebp),%eax
  800915:	8a 00                	mov    (%eax),%al
  800917:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091a:	83 fb 2f             	cmp    $0x2f,%ebx
  80091d:	7e 3e                	jle    80095d <vprintfmt+0xe9>
  80091f:	83 fb 39             	cmp    $0x39,%ebx
  800922:	7f 39                	jg     80095d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800924:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800927:	eb d5                	jmp    8008fe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	83 c0 04             	add    $0x4,%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80093d:	eb 1f                	jmp    80095e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80093f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800943:	79 83                	jns    8008c8 <vprintfmt+0x54>
				width = 0;
  800945:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80094c:	e9 77 ff ff ff       	jmp    8008c8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800951:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800958:	e9 6b ff ff ff       	jmp    8008c8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80095d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80095e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800962:	0f 89 60 ff ff ff    	jns    8008c8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800975:	e9 4e ff ff ff       	jmp    8008c8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80097d:	e9 46 ff ff ff       	jmp    8008c8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	83 c0 04             	add    $0x4,%eax
  800988:	89 45 14             	mov    %eax,0x14(%ebp)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 e8 04             	sub    $0x4,%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	50                   	push   %eax
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
			break;
  8009a2:	e9 9b 02 00 00       	jmp    800c42 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	83 c0 04             	add    $0x4,%eax
  8009ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 e8 04             	sub    $0x4,%eax
  8009b6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009b8:	85 db                	test   %ebx,%ebx
  8009ba:	79 02                	jns    8009be <vprintfmt+0x14a>
				err = -err;
  8009bc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009be:	83 fb 64             	cmp    $0x64,%ebx
  8009c1:	7f 0b                	jg     8009ce <vprintfmt+0x15a>
  8009c3:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  8009ca:	85 f6                	test   %esi,%esi
  8009cc:	75 19                	jne    8009e7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ce:	53                   	push   %ebx
  8009cf:	68 25 24 80 00       	push   $0x802425
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	ff 75 08             	pushl  0x8(%ebp)
  8009da:	e8 70 02 00 00       	call   800c4f <printfmt>
  8009df:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e2:	e9 5b 02 00 00       	jmp    800c42 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e7:	56                   	push   %esi
  8009e8:	68 2e 24 80 00       	push   $0x80242e
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 57 02 00 00       	call   800c4f <printfmt>
  8009f8:	83 c4 10             	add    $0x10,%esp
			break;
  8009fb:	e9 42 02 00 00       	jmp    800c42 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	83 c0 04             	add    $0x4,%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 30                	mov    (%eax),%esi
  800a11:	85 f6                	test   %esi,%esi
  800a13:	75 05                	jne    800a1a <vprintfmt+0x1a6>
				p = "(null)";
  800a15:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	7e 6d                	jle    800a8d <vprintfmt+0x219>
  800a20:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a24:	74 67                	je     800a8d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	50                   	push   %eax
  800a2d:	56                   	push   %esi
  800a2e:	e8 1e 03 00 00       	call   800d51 <strnlen>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a39:	eb 16                	jmp    800a51 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a3b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	50                   	push   %eax
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a55:	7f e4                	jg     800a3b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a57:	eb 34                	jmp    800a8d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a5d:	74 1c                	je     800a7b <vprintfmt+0x207>
  800a5f:	83 fb 1f             	cmp    $0x1f,%ebx
  800a62:	7e 05                	jle    800a69 <vprintfmt+0x1f5>
  800a64:	83 fb 7e             	cmp    $0x7e,%ebx
  800a67:	7e 12                	jle    800a7b <vprintfmt+0x207>
					putch('?', putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	6a 3f                	push   $0x3f
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	eb 0f                	jmp    800a8a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	53                   	push   %ebx
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a8d:	89 f0                	mov    %esi,%eax
  800a8f:	8d 70 01             	lea    0x1(%eax),%esi
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	0f be d8             	movsbl %al,%ebx
  800a97:	85 db                	test   %ebx,%ebx
  800a99:	74 24                	je     800abf <vprintfmt+0x24b>
  800a9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9f:	78 b8                	js     800a59 <vprintfmt+0x1e5>
  800aa1:	ff 4d e0             	decl   -0x20(%ebp)
  800aa4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa8:	79 af                	jns    800a59 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aaa:	eb 13                	jmp    800abf <vprintfmt+0x24b>
				putch(' ', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 20                	push   $0x20
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800abc:	ff 4d e4             	decl   -0x1c(%ebp)
  800abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac3:	7f e7                	jg     800aac <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ac5:	e9 78 01 00 00       	jmp    800c42 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad3:	50                   	push   %eax
  800ad4:	e8 3c fd ff ff       	call   800815 <getint>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae8:	85 d2                	test   %edx,%edx
  800aea:	79 23                	jns    800b0f <vprintfmt+0x29b>
				putch('-', putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	6a 2d                	push   $0x2d
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	ff d0                	call   *%eax
  800af9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b02:	f7 d8                	neg    %eax
  800b04:	83 d2 00             	adc    $0x0,%edx
  800b07:	f7 da                	neg    %edx
  800b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b16:	e9 bc 00 00 00       	jmp    800bd7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b21:	8d 45 14             	lea    0x14(%ebp),%eax
  800b24:	50                   	push   %eax
  800b25:	e8 84 fc ff ff       	call   8007ae <getuint>
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3a:	e9 98 00 00 00       	jmp    800bd7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	6a 58                	push   $0x58
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 58                	push   $0x58
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 58                	push   $0x58
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			break;
  800b6f:	e9 ce 00 00 00       	jmp    800c42 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	6a 30                	push   $0x30
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	6a 78                	push   $0x78
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b94:	8b 45 14             	mov    0x14(%ebp),%eax
  800b97:	83 c0 04             	add    $0x4,%eax
  800b9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800baf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bb6:	eb 1f                	jmp    800bd7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	e8 e7 fb ff ff       	call   8007ae <getuint>
  800bc7:	83 c4 10             	add    $0x10,%esp
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bde:	83 ec 04             	sub    $0x4,%esp
  800be1:	52                   	push   %edx
  800be2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 f4             	pushl  -0xc(%ebp)
  800be9:	ff 75 f0             	pushl  -0x10(%ebp)
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	ff 75 08             	pushl  0x8(%ebp)
  800bf2:	e8 00 fb ff ff       	call   8006f7 <printnum>
  800bf7:	83 c4 20             	add    $0x20,%esp
			break;
  800bfa:	eb 46                	jmp    800c42 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	53                   	push   %ebx
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			break;
  800c0b:	eb 35                	jmp    800c42 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c0d:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800c14:	eb 2c                	jmp    800c42 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c16:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800c1d:	eb 23                	jmp    800c42 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	6a 25                	push   $0x25
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2f:	ff 4d 10             	decl   0x10(%ebp)
  800c32:	eb 03                	jmp    800c37 <vprintfmt+0x3c3>
  800c34:	ff 4d 10             	decl   0x10(%ebp)
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	48                   	dec    %eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	3c 25                	cmp    $0x25,%al
  800c3f:	75 f3                	jne    800c34 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c41:	90                   	nop
		}
	}
  800c42:	e9 35 fc ff ff       	jmp    80087c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c47:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c55:	8d 45 10             	lea    0x10(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 04 fc ff ff       	call   800874 <vprintfmt>
  800c70:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c73:	90                   	nop
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8b 40 08             	mov    0x8(%eax),%eax
  800c7f:	8d 50 01             	lea    0x1(%eax),%edx
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8b 10                	mov    (%eax),%edx
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8b 40 04             	mov    0x4(%eax),%eax
  800c93:	39 c2                	cmp    %eax,%edx
  800c95:	73 12                	jae    800ca9 <sprintputch+0x33>
		*b->buf++ = ch;
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	89 0a                	mov    %ecx,(%edx)
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	88 10                	mov    %dl,(%eax)
}
  800ca9:	90                   	nop
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	01 d0                	add    %edx,%eax
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ccd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd1:	74 06                	je     800cd9 <vsnprintf+0x2d>
  800cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd7:	7f 07                	jg     800ce0 <vsnprintf+0x34>
		return -E_INVAL;
  800cd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cde:	eb 20                	jmp    800d00 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce0:	ff 75 14             	pushl  0x14(%ebp)
  800ce3:	ff 75 10             	pushl  0x10(%ebp)
  800ce6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce9:	50                   	push   %eax
  800cea:	68 76 0c 80 00       	push   $0x800c76
  800cef:	e8 80 fb ff ff       	call   800874 <vprintfmt>
  800cf4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d08:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0b:	83 c0 04             	add    $0x4,%eax
  800d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	ff 75 f4             	pushl  -0xc(%ebp)
  800d17:	50                   	push   %eax
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	ff 75 08             	pushl  0x8(%ebp)
  800d1e:	e8 89 ff ff ff       	call   800cac <vsnprintf>
  800d23:	83 c4 10             	add    $0x10,%esp
  800d26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3b:	eb 06                	jmp    800d43 <strlen+0x15>
		n++;
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 f1                	jne    800d3d <strlen+0xf>
		n++;
	return n;
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5e:	eb 09                	jmp    800d69 <strnlen+0x18>
		n++;
  800d60:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d63:	ff 45 08             	incl   0x8(%ebp)
  800d66:	ff 4d 0c             	decl   0xc(%ebp)
  800d69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6d:	74 09                	je     800d78 <strnlen+0x27>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	84 c0                	test   %al,%al
  800d76:	75 e8                	jne    800d60 <strnlen+0xf>
		n++;
	return n;
  800d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d89:	90                   	nop
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 08             	mov    %edx,0x8(%ebp)
  800d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	84 c0                	test   %al,%al
  800da4:	75 e4                	jne    800d8a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbe:	eb 1f                	jmp    800ddf <strncpy+0x34>
		*dst++ = *src;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8d 50 01             	lea    0x1(%eax),%edx
  800dc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	74 03                	je     800ddc <strncpy+0x31>
			src++;
  800dd9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ddc:	ff 45 fc             	incl   -0x4(%ebp)
  800ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de5:	72 d9                	jb     800dc0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfc:	74 30                	je     800e2e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfe:	eb 16                	jmp    800e16 <strlcpy+0x2a>
			*dst++ = *src++;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8d 50 01             	lea    0x1(%eax),%edx
  800e06:	89 55 08             	mov    %edx,0x8(%ebp)
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e12:	8a 12                	mov    (%edx),%dl
  800e14:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e16:	ff 4d 10             	decl   0x10(%ebp)
  800e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1d:	74 09                	je     800e28 <strlcpy+0x3c>
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 d8                	jne    800e00 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	29 c2                	sub    %eax,%edx
  800e36:	89 d0                	mov    %edx,%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e3d:	eb 06                	jmp    800e45 <strcmp+0xb>
		p++, q++;
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	74 0e                	je     800e5c <strcmp+0x22>
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 10                	mov    (%eax),%dl
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	38 c2                	cmp    %al,%dl
  800e5a:	74 e3                	je     800e3f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 d0             	movzbl %al,%edx
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	0f b6 c0             	movzbl %al,%eax
  800e6c:	29 c2                	sub    %eax,%edx
  800e6e:	89 d0                	mov    %edx,%eax
}
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    

00800e72 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e75:	eb 09                	jmp    800e80 <strncmp+0xe>
		n--, p++, q++;
  800e77:	ff 4d 10             	decl   0x10(%ebp)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e84:	74 17                	je     800e9d <strncmp+0x2b>
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	84 c0                	test   %al,%al
  800e8d:	74 0e                	je     800e9d <strncmp+0x2b>
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 10                	mov    (%eax),%dl
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	38 c2                	cmp    %al,%dl
  800e9b:	74 da                	je     800e77 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	75 07                	jne    800eaa <strncmp+0x38>
		return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea8:	eb 14                	jmp    800ebe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	0f b6 d0             	movzbl %al,%edx
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	0f b6 c0             	movzbl %al,%eax
  800eba:	29 c2                	sub    %eax,%edx
  800ebc:	89 d0                	mov    %edx,%eax
}
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 04             	sub    $0x4,%esp
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ecc:	eb 12                	jmp    800ee0 <strchr+0x20>
		if (*s == c)
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed6:	75 05                	jne    800edd <strchr+0x1d>
			return (char *) s;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	eb 11                	jmp    800eee <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800edd:	ff 45 08             	incl   0x8(%ebp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	84 c0                	test   %al,%al
  800ee7:	75 e5                	jne    800ece <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800efc:	eb 0d                	jmp    800f0b <strfind+0x1b>
		if (*s == c)
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f06:	74 0e                	je     800f16 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f08:	ff 45 08             	incl   0x8(%ebp)
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	75 ea                	jne    800efe <strfind+0xe>
  800f14:	eb 01                	jmp    800f17 <strfind+0x27>
		if (*s == c)
			break;
  800f16:	90                   	nop
	return (char *) s;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1a:	c9                   	leave  
  800f1b:	c3                   	ret    

00800f1c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f28:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2c:	76 63                	jbe    800f91 <memset+0x75>
		uint64 data_block = c;
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	99                   	cltd   
  800f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f35:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f42:	c1 e0 08             	shl    $0x8,%eax
  800f45:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f48:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f51:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f55:	c1 e0 10             	shl    $0x10,%eax
  800f58:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f5b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f64:	89 c2                	mov    %eax,%edx
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f6e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f71:	eb 18                	jmp    800f8b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f73:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f76:	8d 41 08             	lea    0x8(%ecx),%eax
  800f79:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f82:	89 01                	mov    %eax,(%ecx)
  800f84:	89 51 04             	mov    %edx,0x4(%ecx)
  800f87:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f8b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8f:	77 e2                	ja     800f73 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	74 23                	je     800fba <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9d:	eb 0e                	jmp    800fad <memset+0x91>
			*p8++ = (uint8)c;
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	8d 50 01             	lea    0x1(%eax),%edx
  800fa5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fab:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 e5                	jne    800f9f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fd1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd5:	76 24                	jbe    800ffb <memcpy+0x3c>
		while(n >= 8){
  800fd7:	eb 1c                	jmp    800ff5 <memcpy+0x36>
			*d64 = *s64;
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	8b 50 04             	mov    0x4(%eax),%edx
  800fdf:	8b 00                	mov    (%eax),%eax
  800fe1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe4:	89 01                	mov    %eax,(%ecx)
  800fe6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fe9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fed:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ff1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ff5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff9:	77 de                	ja     800fd9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	74 31                	je     801032 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x66>
			*d8++ = *s8++;
  80100f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f3:	75 bb                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ff:	48                   	dec    %eax
  801300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801303:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801307:	74 3d                	je     801346 <ltostr+0xc3>
		start = 1 ;
  801309:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801310:	eb 34                	jmp    801346 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80131f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 c2                	add    %eax,%edx
  801327:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	01 c8                	add    %ecx,%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801333:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	01 c2                	add    %eax,%edx
  80133b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133e:	88 02                	mov    %al,(%edx)
		start++ ;
  801340:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801343:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134c:	7c c4                	jl     801312 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801359:	90                   	nop
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801362:	ff 75 08             	pushl  0x8(%ebp)
  801365:	e8 c4 f9 ff ff       	call   800d2e <strlen>
  80136a:	83 c4 04             	add    $0x4,%esp
  80136d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 b6 f9 ff ff       	call   800d2e <strlen>
  801378:	83 c4 04             	add    $0x4,%esp
  80137b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138c:	eb 17                	jmp    8013a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	01 c2                	add    %eax,%edx
  801396:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a2:	ff 45 fc             	incl   -0x4(%ebp)
  8013a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ab:	7c e1                	jl     80138e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bb:	eb 1f                	jmp    8013dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c0:	8d 50 01             	lea    0x1(%eax),%edx
  8013c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c6:	89 c2                	mov    %eax,%edx
  8013c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 c8                	add    %ecx,%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d9:	ff 45 f8             	incl   -0x8(%ebp)
  8013dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e2:	7c d9                	jl     8013bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ef:	90                   	nop
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140a:	8b 45 10             	mov    0x10(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801415:	eb 0c                	jmp    801423 <strsplit+0x31>
			*string++ = 0;
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 08             	mov    %edx,0x8(%ebp)
  801420:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	74 18                	je     801444 <strsplit+0x52>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	0f be c0             	movsbl %al,%eax
  801434:	50                   	push   %eax
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 83 fa ff ff       	call   800ec0 <strchr>
  80143d:	83 c4 08             	add    $0x8,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	75 d3                	jne    801417 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	84 c0                	test   %al,%al
  80144b:	74 5a                	je     8014a7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144d:	8b 45 14             	mov    0x14(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	83 f8 0f             	cmp    $0xf,%eax
  801455:	75 07                	jne    80145e <strsplit+0x6c>
		{
			return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
  80145c:	eb 66                	jmp    8014c4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	8d 48 01             	lea    0x1(%eax),%ecx
  801466:	8b 55 14             	mov    0x14(%ebp),%edx
  801469:	89 0a                	mov    %ecx,(%edx)
  80146b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801472:	8b 45 10             	mov    0x10(%ebp),%eax
  801475:	01 c2                	add    %eax,%edx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147c:	eb 03                	jmp    801481 <strsplit+0x8f>
			string++;
  80147e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	84 c0                	test   %al,%al
  801488:	74 8b                	je     801415 <strsplit+0x23>
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	0f be c0             	movsbl %al,%eax
  801492:	50                   	push   %eax
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	e8 25 fa ff ff       	call   800ec0 <strchr>
  80149b:	83 c4 08             	add    $0x8,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	74 dc                	je     80147e <strsplit+0x8c>
			string++;
	}
  8014a2:	e9 6e ff ff ff       	jmp    801415 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d9:	eb 4a                	jmp    801525 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	01 c2                	add    %eax,%edx
  8014e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	01 c8                	add    %ecx,%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f5:	01 d0                	add    %edx,%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	3c 40                	cmp    $0x40,%al
  8014fb:	7e 25                	jle    801522 <str2lower+0x5c>
  8014fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	3c 5a                	cmp    $0x5a,%al
  801509:	7f 17                	jg     801522 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801516:	8b 55 08             	mov    0x8(%ebp),%edx
  801519:	01 ca                	add    %ecx,%edx
  80151b:	8a 12                	mov    (%edx),%dl
  80151d:	83 c2 20             	add    $0x20,%edx
  801520:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801522:	ff 45 fc             	incl   -0x4(%ebp)
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	e8 01 f8 ff ff       	call   800d2e <strlen>
  80152d:	83 c4 04             	add    $0x4,%esp
  801530:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801533:	7f a6                	jg     8014db <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	57                   	push   %edi
  80153e:	56                   	push   %esi
  80153f:	53                   	push   %ebx
  801540:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8b 55 0c             	mov    0xc(%ebp),%edx
  801549:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801552:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801555:	cd 30                	int    $0x30
  801557:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5f                   	pop    %edi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	8b 45 10             	mov    0x10(%ebp),%eax
  80156e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801571:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801574:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	6a 00                	push   $0x0
  80157d:	51                   	push   %ecx
  80157e:	52                   	push   %edx
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	50                   	push   %eax
  801583:	6a 00                	push   $0x0
  801585:	e8 b0 ff ff ff       	call   80153a <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	90                   	nop
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_cgetc>:

int
sys_cgetc(void)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 02                	push   $0x2
  80159f:	e8 96 ff ff ff       	call   80153a <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 03                	push   $0x3
  8015b8:	e8 7d ff ff ff       	call   80153a <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 04                	push   $0x4
  8015d2:	e8 63 ff ff ff       	call   80153a <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	52                   	push   %edx
  8015ed:	50                   	push   %eax
  8015ee:	6a 08                	push   $0x8
  8015f0:	e8 45 ff ff ff       	call   80153a <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801602:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801605:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
  801610:	51                   	push   %ecx
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	6a 09                	push   $0x9
  801615:	e8 20 ff ff ff       	call   80153a <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801620:	5b                   	pop    %ebx
  801621:	5e                   	pop    %esi
  801622:	5d                   	pop    %ebp
  801623:	c3                   	ret    

00801624 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	6a 0a                	push   $0xa
  801634:	e8 01 ff ff ff       	call   80153a <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	6a 0b                	push   $0xb
  80164f:	e8 e6 fe ff ff       	call   80153a <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 0c                	push   $0xc
  801668:	e8 cd fe ff ff       	call   80153a <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 0d                	push   $0xd
  801681:	e8 b4 fe ff ff       	call   80153a <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 0e                	push   $0xe
  80169a:	e8 9b fe ff ff       	call   80153a <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 0f                	push   $0xf
  8016b3:	e8 82 fe ff ff       	call   80153a <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	6a 10                	push   $0x10
  8016cd:	e8 68 fe ff ff       	call   80153a <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 11                	push   $0x11
  8016e6:	e8 4f fe ff ff       	call   80153a <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	90                   	nop
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	50                   	push   %eax
  80170a:	6a 01                	push   $0x1
  80170c:	e8 29 fe ff ff       	call   80153a <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 14                	push   $0x14
  801726:	e8 0f fe ff ff       	call   80153a <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	90                   	nop
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	8b 45 10             	mov    0x10(%ebp),%eax
  80173a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80173d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801740:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	51                   	push   %ecx
  80174a:	52                   	push   %edx
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	50                   	push   %eax
  80174f:	6a 15                	push   $0x15
  801751:	e8 e4 fd ff ff       	call   80153a <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80175e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	52                   	push   %edx
  80176b:	50                   	push   %eax
  80176c:	6a 16                	push   $0x16
  80176e:	e8 c7 fd ff ff       	call   80153a <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	51                   	push   %ecx
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	6a 17                	push   $0x17
  80178d:	e8 a8 fd ff ff       	call   80153a <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	52                   	push   %edx
  8017a7:	50                   	push   %eax
  8017a8:	6a 18                	push   $0x18
  8017aa:	e8 8b fd ff ff       	call   80153a <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	ff 75 14             	pushl  0x14(%ebp)
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	50                   	push   %eax
  8017c6:	6a 19                	push   $0x19
  8017c8:	e8 6d fd ff ff       	call   80153a <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	50                   	push   %eax
  8017e1:	6a 1a                	push   $0x1a
  8017e3:	e8 52 fd ff ff       	call   80153a <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	90                   	nop
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	50                   	push   %eax
  8017fd:	6a 1b                	push   $0x1b
  8017ff:	e8 36 fd ff ff       	call   80153a <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 05                	push   $0x5
  801818:	e8 1d fd ff ff       	call   80153a <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 06                	push   $0x6
  801831:	e8 04 fd ff ff       	call   80153a <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 07                	push   $0x7
  80184a:	e8 eb fc ff ff       	call   80153a <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_exit_env>:


void sys_exit_env(void)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 1c                	push   $0x1c
  801863:	e8 d2 fc ff ff       	call   80153a <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801874:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801877:	8d 50 04             	lea    0x4(%eax),%edx
  80187a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	52                   	push   %edx
  801884:	50                   	push   %eax
  801885:	6a 1d                	push   $0x1d
  801887:	e8 ae fc ff ff       	call   80153a <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return result;
  80188f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801892:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801895:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801898:	89 01                	mov    %eax,(%ecx)
  80189a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	c9                   	leave  
  8018a1:	c2 04 00             	ret    $0x4

008018a4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	ff 75 10             	pushl  0x10(%ebp)
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	6a 13                	push   $0x13
  8018b6:	e8 7f fc ff ff       	call   80153a <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018be:	90                   	nop
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 1e                	push   $0x1e
  8018d0:	e8 65 fc ff ff       	call   80153a <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018e6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	50                   	push   %eax
  8018f3:	6a 1f                	push   $0x1f
  8018f5:	e8 40 fc ff ff       	call   80153a <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fd:	90                   	nop
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <rsttst>:
void rsttst()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 21                	push   $0x21
  80190f:	e8 26 fc ff ff       	call   80153a <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return ;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	8b 45 14             	mov    0x14(%ebp),%eax
  801923:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801926:	8b 55 18             	mov    0x18(%ebp),%edx
  801929:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	ff 75 10             	pushl  0x10(%ebp)
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 20                	push   $0x20
  80193a:	e8 fb fb ff ff       	call   80153a <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
	return ;
  801942:	90                   	nop
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <chktst>:
void chktst(uint32 n)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 22                	push   $0x22
  801955:	e8 e0 fb ff ff       	call   80153a <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <inctst>:

void inctst()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 23                	push   $0x23
  80196f:	e8 c6 fb ff ff       	call   80153a <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <gettst>:
uint32 gettst()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 24                	push   $0x24
  801989:	e8 ac fb ff ff       	call   80153a <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 25                	push   $0x25
  8019a2:	e8 93 fb ff ff       	call   80153a <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
  8019aa:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  8019af:	a1 00 71 82 00       	mov    0x827100,%eax
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 26                	push   $0x26
  8019ce:	e8 67 fb ff ff       	call   80153a <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	53                   	push   %ebx
  8019ec:	51                   	push   %ecx
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	6a 27                	push   $0x27
  8019f1:	e8 44 fb ff ff       	call   80153a <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 28                	push   $0x28
  801a11:	e8 24 fb ff ff       	call   80153a <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	51                   	push   %ecx
  801a2a:	ff 75 10             	pushl  0x10(%ebp)
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 29                	push   $0x29
  801a31:	e8 04 fb ff ff       	call   80153a <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 10             	pushl  0x10(%ebp)
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	6a 12                	push   $0x12
  801a4d:	e8 e8 fa ff ff       	call   80153a <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
	return ;
  801a55:	90                   	nop
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 2a                	push   $0x2a
  801a6b:	e8 ca fa ff ff       	call   80153a <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 2b                	push   $0x2b
  801a85:	e8 b0 fa ff ff       	call   80153a <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 2d                	push   $0x2d
  801aa0:	e8 95 fa ff ff       	call   80153a <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	ff 75 08             	pushl  0x8(%ebp)
  801aba:	6a 2c                	push   $0x2c
  801abc:	e8 79 fa ff ff       	call   80153a <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac4:	90                   	nop
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801acd:	83 ec 04             	sub    $0x4,%esp
  801ad0:	68 a8 25 80 00       	push   $0x8025a8
  801ad5:	68 25 01 00 00       	push   $0x125
  801ada:	68 db 25 80 00       	push   $0x8025db
  801adf:	e8 a3 e8 ff ff       	call   800387 <_panic>

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
