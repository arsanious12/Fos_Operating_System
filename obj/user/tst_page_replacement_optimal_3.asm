
obj/user/tst_page_replacement_optimal_3:     file format elf32-i386


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
  800031:	e8 28 01 00 00       	call   80015e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x800000, 0x801000, 0x802000,		//Code
		0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000, 	//Data
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
  80004c:	e8 51 19 00 00       	call   8019a2 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 e0 1c 80 00       	push   $0x801ce0
  800065:	6a 1c                	push   $0x1c
  800067:	68 54 1d 80 00       	push   $0x801d54
  80006c:	e8 9d 02 00 00       	call   80030e <_panic>
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
  8000c3:	68 7a 1d 80 00       	push   $0x801d7a
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 3a 05 00 00       	call   800609 <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 93 1d 80 00       	push   $0x801d93
  8000e6:	6a 3b                	push   $0x3b
  8000e8:	68 54 1d 80 00       	push   $0x801d54
  8000ed:	e8 1c 02 00 00       	call   80030e <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 93 1d 80 00       	push   $0x801d93
  800106:	6a 3c                	push   $0x3c
  800108:	68 54 1d 80 00       	push   $0x801d54
  80010d:	e8 fc 01 00 00       	call   80030e <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Faults... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 a0 1d 80 00       	push   $0x801da0
  80011a:	6a 03                	push   $0x3
  80011c:	e8 e8 04 00 00       	call   800609 <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 8;
  800124:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		if (sys_get_optimal_num_faults() != expectedNumOfFaults)
  80012b:	e8 cd 18 00 00       	call   8019fd <sys_get_optimal_num_faults>
  800130:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800133:	74 14                	je     800149 <_main+0x111>
			panic("OPTIMAL alg. failed.. unexpected number of faults");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 c4 1d 80 00       	push   $0x801dc4
  80013d:	6a 42                	push   $0x42
  80013f:	68 54 1d 80 00       	push   $0x801d54
  800144:	e8 c5 01 00 00       	call   80030e <_panic>
	}
	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #3 [OPTIMAL Alg.] is completed successfully.\n");
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 f8 1d 80 00       	push   $0x801df8
  800151:	6a 0a                	push   $0xa
  800153:	e8 b1 04 00 00       	call   800609 <cprintf_colored>
  800158:	83 c4 10             	add    $0x10,%esp
	return;
  80015b:	90                   	nop
}
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800167:	e8 3d 16 00 00       	call   8017a9 <sys_getenvindex>
  80016c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80016f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800172:	89 d0                	mov    %edx,%eax
  800174:	c1 e0 02             	shl    $0x2,%eax
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 03             	shl    $0x3,%eax
  80017c:	01 d0                	add    %edx,%eax
  80017e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800185:	01 d0                	add    %edx,%eax
  800187:	c1 e0 02             	shl    $0x2,%eax
  80018a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80018f:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800194:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800199:	8a 40 20             	mov    0x20(%eax),%al
  80019c:	84 c0                	test   %al,%al
  80019e:	74 0d                	je     8001ad <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001a0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a5:	83 c0 20             	add    $0x20,%eax
  8001a8:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b1:	7e 0a                	jle    8001bd <libmain+0x5f>
		binaryname = argv[0];
  8001b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b6:	8b 00                	mov    (%eax),%eax
  8001b8:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	e8 6d fe ff ff       	call   800038 <_main>
  8001cb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001ce:	a1 8c 30 80 00       	mov    0x80308c,%eax
  8001d3:	85 c0                	test   %eax,%eax
  8001d5:	0f 84 01 01 00 00    	je     8002dc <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001db:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e1:	bb 4c 1f 80 00       	mov    $0x801f4c,%ebx
  8001e6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001eb:	89 c7                	mov    %eax,%edi
  8001ed:	89 de                	mov    %ebx,%esi
  8001ef:	89 d1                	mov    %edx,%ecx
  8001f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001f6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001fb:	b0 00                	mov    $0x0,%al
  8001fd:	89 d7                	mov    %edx,%edi
  8001ff:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800201:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800208:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	50                   	push   %eax
  80020f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 c4 17 00 00       	call   8019df <sys_utilities>
  80021b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80021e:	e8 0d 13 00 00       	call   801530 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 6c 1e 80 00       	push   $0x801e6c
  80022b:	e8 ac 03 00 00       	call   8005dc <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800233:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800236:	85 c0                	test   %eax,%eax
  800238:	74 18                	je     800252 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80023a:	e8 be 17 00 00       	call   8019fd <sys_get_optimal_num_faults>
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	50                   	push   %eax
  800243:	68 94 1e 80 00       	push   $0x801e94
  800248:	e8 8f 03 00 00       	call   8005dc <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	eb 59                	jmp    8002ab <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800252:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800257:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80025d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800262:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800268:	83 ec 04             	sub    $0x4,%esp
  80026b:	52                   	push   %edx
  80026c:	50                   	push   %eax
  80026d:	68 b8 1e 80 00       	push   $0x801eb8
  800272:	e8 65 03 00 00       	call   8005dc <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80027a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80027f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800285:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80028a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800290:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800295:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80029b:	51                   	push   %ecx
  80029c:	52                   	push   %edx
  80029d:	50                   	push   %eax
  80029e:	68 e0 1e 80 00       	push   $0x801ee0
  8002a3:	e8 34 03 00 00       	call   8005dc <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ab:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002b0:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	50                   	push   %eax
  8002ba:	68 38 1f 80 00       	push   $0x801f38
  8002bf:	e8 18 03 00 00       	call   8005dc <cprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	68 6c 1e 80 00       	push   $0x801e6c
  8002cf:	e8 08 03 00 00       	call   8005dc <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002d7:	e8 6e 12 00 00       	call   80154a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002dc:	e8 1f 00 00 00       	call   800300 <exit>
}
  8002e1:	90                   	nop
  8002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	6a 00                	push   $0x0
  8002f5:	e8 7b 14 00 00       	call   801775 <sys_destroy_env>
  8002fa:	83 c4 10             	add    $0x10,%esp
}
  8002fd:	90                   	nop
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <exit>:

void
exit(void)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800306:	e8 d0 14 00 00       	call   8017db <sys_exit_env>
}
  80030b:	90                   	nop
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800314:	8d 45 10             	lea    0x10(%ebp),%eax
  800317:	83 c0 04             	add    $0x4,%eax
  80031a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80031d:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  800322:	85 c0                	test   %eax,%eax
  800324:	74 16                	je     80033c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800326:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	50                   	push   %eax
  80032f:	68 b0 1f 80 00       	push   $0x801fb0
  800334:	e8 a3 02 00 00       	call   8005dc <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80033c:	a1 90 30 80 00       	mov    0x803090,%eax
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	50                   	push   %eax
  80034b:	68 b8 1f 80 00       	push   $0x801fb8
  800350:	6a 74                	push   $0x74
  800352:	e8 b2 02 00 00       	call   800609 <cprintf_colored>
  800357:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80035a:	8b 45 10             	mov    0x10(%ebp),%eax
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	ff 75 f4             	pushl  -0xc(%ebp)
  800363:	50                   	push   %eax
  800364:	e8 04 02 00 00       	call   80056d <vcprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	6a 00                	push   $0x0
  800371:	68 e0 1f 80 00       	push   $0x801fe0
  800376:	e8 f2 01 00 00       	call   80056d <vcprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80037e:	e8 7d ff ff ff       	call   800300 <exit>

	// should not return here
	while (1) ;
  800383:	eb fe                	jmp    800383 <_panic+0x75>

00800385 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800390:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800396:	8b 45 0c             	mov    0xc(%ebp),%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	74 14                	je     8003b1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 e4 1f 80 00       	push   $0x801fe4
  8003a5:	6a 26                	push   $0x26
  8003a7:	68 30 20 80 00       	push   $0x802030
  8003ac:	e8 5d ff ff ff       	call   80030e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003bf:	e9 c5 00 00 00       	jmp    800489 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	8b 00                	mov    (%eax),%eax
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	75 08                	jne    8003e1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003d9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003dc:	e9 a5 00 00 00       	jmp    800486 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ef:	eb 69                	jmp    80045a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f1:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003f6:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	01 c0                	add    %eax,%eax
  800403:	01 d0                	add    %edx,%eax
  800405:	c1 e0 03             	shl    $0x3,%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8a 40 04             	mov    0x4(%eax),%al
  80040d:	84 c0                	test   %al,%al
  80040f:	75 46                	jne    800457 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800411:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800416:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80041c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	01 c0                	add    %eax,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 c8                	add    %ecx,%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800432:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800437:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	01 c8                	add    %ecx,%eax
  800448:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044a:	39 c2                	cmp    %eax,%edx
  80044c:	75 09                	jne    800457 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80044e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800455:	eb 15                	jmp    80046c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800457:	ff 45 e8             	incl   -0x18(%ebp)
  80045a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80045f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	39 c2                	cmp    %eax,%edx
  80046a:	77 85                	ja     8003f1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80046c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800470:	75 14                	jne    800486 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 3c 20 80 00       	push   $0x80203c
  80047a:	6a 3a                	push   $0x3a
  80047c:	68 30 20 80 00       	push   $0x802030
  800481:	e8 88 fe ff ff       	call   80030e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800486:	ff 45 f0             	incl   -0x10(%ebp)
  800489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048f:	0f 8c 2f ff ff ff    	jl     8003c4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800495:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a3:	eb 26                	jmp    8004cb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a5:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004aa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	01 c0                	add    %eax,%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	c1 e0 03             	shl    $0x3,%eax
  8004bc:	01 c8                	add    %ecx,%eax
  8004be:	8a 40 04             	mov    0x4(%eax),%al
  8004c1:	3c 01                	cmp    $0x1,%al
  8004c3:	75 03                	jne    8004c8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e0             	incl   -0x20(%ebp)
  8004cb:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d9:	39 c2                	cmp    %eax,%edx
  8004db:	77 c8                	ja     8004a5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e3:	74 14                	je     8004f9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e5:	83 ec 04             	sub    $0x4,%esp
  8004e8:	68 90 20 80 00       	push   $0x802090
  8004ed:	6a 44                	push   $0x44
  8004ef:	68 30 20 80 00       	push   $0x802030
  8004f4:	e8 15 fe ff ff       	call   80030e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f9:	90                   	nop
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	53                   	push   %ebx
  800500:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 48 01             	lea    0x1(%eax),%ecx
  80050b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050e:	89 0a                	mov    %ecx,(%edx)
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	88 d1                	mov    %dl,%cl
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	3d ff 00 00 00       	cmp    $0xff,%eax
  800526:	75 30                	jne    800558 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800528:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  80052e:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800533:	0f b6 c0             	movzbl %al,%eax
  800536:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800539:	8b 09                	mov    (%ecx),%ecx
  80053b:	89 cb                	mov    %ecx,%ebx
  80053d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800540:	83 c1 08             	add    $0x8,%ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	53                   	push   %ebx
  800546:	51                   	push   %ecx
  800547:	e8 a0 0f 00 00       	call   8014ec <sys_cputs>
  80054c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055b:	8b 40 04             	mov    0x4(%eax),%eax
  80055e:	8d 50 01             	lea    0x1(%eax),%edx
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
  800564:	89 50 04             	mov    %edx,0x4(%eax)
}
  800567:	90                   	nop
  800568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056b:	c9                   	leave  
  80056c:	c3                   	ret    

0080056d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800576:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057d:	00 00 00 
	b.cnt = 0;
  800580:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800587:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058a:	ff 75 0c             	pushl  0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800596:	50                   	push   %eax
  800597:	68 fc 04 80 00       	push   $0x8004fc
  80059c:	e8 5a 02 00 00       	call   8007fb <vprintfmt>
  8005a1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005a4:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005aa:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005af:	0f b6 c0             	movzbl %al,%eax
  8005b2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005b8:	52                   	push   %edx
  8005b9:	50                   	push   %eax
  8005ba:	51                   	push   %ecx
  8005bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c1:	83 c0 08             	add    $0x8,%eax
  8005c4:	50                   	push   %eax
  8005c5:	e8 22 0f 00 00       	call   8014ec <sys_cputs>
  8005ca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cd:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  8005d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e2:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  8005e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	e8 6f ff ff ff       	call   80056d <vcprintf>
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800604:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800607:	c9                   	leave  
  800608:	c3                   	ret    

00800609 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
  80060c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80060f:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	c1 e0 08             	shl    $0x8,%eax
  80061c:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	83 c0 04             	add    $0x4,%eax
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	ff 75 f4             	pushl  -0xc(%ebp)
  800633:	50                   	push   %eax
  800634:	e8 34 ff ff ff       	call   80056d <vcprintf>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80063f:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  800646:	07 00 00 

	return cnt;
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800654:	e8 d7 0e 00 00       	call   801530 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800659:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 f4             	pushl  -0xc(%ebp)
  800668:	50                   	push   %eax
  800669:	e8 ff fe ff ff       	call   80056d <vcprintf>
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800674:	e8 d1 0e 00 00       	call   80154a <sys_unlock_cons>
	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	53                   	push   %ebx
  800682:	83 ec 14             	sub    $0x14,%esp
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800691:	8b 45 18             	mov    0x18(%ebp),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069c:	77 55                	ja     8006f3 <printnum+0x75>
  80069e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a1:	72 05                	jb     8006a8 <printnum+0x2a>
  8006a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a6:	77 4b                	ja     8006f3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ab:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b6:	52                   	push   %edx
  8006b7:	50                   	push   %eax
  8006b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006be:	e8 a9 13 00 00       	call   801a6c <__udivdi3>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	83 ec 04             	sub    $0x4,%esp
  8006c9:	ff 75 20             	pushl  0x20(%ebp)
  8006cc:	53                   	push   %ebx
  8006cd:	ff 75 18             	pushl  0x18(%ebp)
  8006d0:	52                   	push   %edx
  8006d1:	50                   	push   %eax
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 a1 ff ff ff       	call   80067e <printnum>
  8006dd:	83 c4 20             	add    $0x20,%esp
  8006e0:	eb 1a                	jmp    8006fc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 0c             	pushl  0xc(%ebp)
  8006e8:	ff 75 20             	pushl  0x20(%ebp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	ff d0                	call   *%eax
  8006f0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f3:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fa:	7f e6                	jg     8006e2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070a:	53                   	push   %ebx
  80070b:	51                   	push   %ecx
  80070c:	52                   	push   %edx
  80070d:	50                   	push   %eax
  80070e:	e8 69 14 00 00       	call   801b7c <__umoddi3>
  800713:	83 c4 10             	add    $0x10,%esp
  800716:	05 f4 22 80 00       	add    $0x8022f4,%eax
  80071b:	8a 00                	mov    (%eax),%al
  80071d:	0f be c0             	movsbl %al,%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
}
  80072f:	90                   	nop
  800730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800738:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073c:	7e 1c                	jle    80075a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	8d 50 08             	lea    0x8(%eax),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	89 10                	mov    %edx,(%eax)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 e8 08             	sub    $0x8,%eax
  800753:	8b 50 04             	mov    0x4(%eax),%edx
  800756:	8b 00                	mov    (%eax),%eax
  800758:	eb 40                	jmp    80079a <getuint+0x65>
	else if (lflag)
  80075a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075e:	74 1e                	je     80077e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	8d 50 04             	lea    0x4(%eax),%edx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	89 10                	mov    %edx,(%eax)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	83 e8 04             	sub    $0x4,%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	eb 1c                	jmp    80079a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	8d 50 04             	lea    0x4(%eax),%edx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	89 10                	mov    %edx,(%eax)
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	83 e8 04             	sub    $0x4,%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a3:	7e 1c                	jle    8007c1 <getint+0x25>
		return va_arg(*ap, long long);
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	8d 50 08             	lea    0x8(%eax),%edx
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	89 10                	mov    %edx,(%eax)
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	83 e8 08             	sub    $0x8,%eax
  8007ba:	8b 50 04             	mov    0x4(%eax),%edx
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	eb 38                	jmp    8007f9 <getint+0x5d>
	else if (lflag)
  8007c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c5:	74 1a                	je     8007e1 <getint+0x45>
		return va_arg(*ap, long);
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	8d 50 04             	lea    0x4(%eax),%edx
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	89 10                	mov    %edx,(%eax)
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	83 e8 04             	sub    $0x4,%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	99                   	cltd   
  8007df:	eb 18                	jmp    8007f9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	8d 50 04             	lea    0x4(%eax),%edx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	89 10                	mov    %edx,(%eax)
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	83 e8 04             	sub    $0x4,%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	99                   	cltd   
}
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	56                   	push   %esi
  8007ff:	53                   	push   %ebx
  800800:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800803:	eb 17                	jmp    80081c <vprintfmt+0x21>
			if (ch == '\0')
  800805:	85 db                	test   %ebx,%ebx
  800807:	0f 84 c1 03 00 00    	je     800bce <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	53                   	push   %ebx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081c:	8b 45 10             	mov    0x10(%ebp),%eax
  80081f:	8d 50 01             	lea    0x1(%eax),%edx
  800822:	89 55 10             	mov    %edx,0x10(%ebp)
  800825:	8a 00                	mov    (%eax),%al
  800827:	0f b6 d8             	movzbl %al,%ebx
  80082a:	83 fb 25             	cmp    $0x25,%ebx
  80082d:	75 d6                	jne    800805 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800833:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800841:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800848:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084f:	8b 45 10             	mov    0x10(%ebp),%eax
  800852:	8d 50 01             	lea    0x1(%eax),%edx
  800855:	89 55 10             	mov    %edx,0x10(%ebp)
  800858:	8a 00                	mov    (%eax),%al
  80085a:	0f b6 d8             	movzbl %al,%ebx
  80085d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800860:	83 f8 5b             	cmp    $0x5b,%eax
  800863:	0f 87 3d 03 00 00    	ja     800ba6 <vprintfmt+0x3ab>
  800869:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  800870:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800872:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800876:	eb d7                	jmp    80084f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800878:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087c:	eb d1                	jmp    80084f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800885:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800888:	89 d0                	mov    %edx,%eax
  80088a:	c1 e0 02             	shl    $0x2,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	01 c0                	add    %eax,%eax
  800891:	01 d8                	add    %ebx,%eax
  800893:	83 e8 30             	sub    $0x30,%eax
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800899:	8b 45 10             	mov    0x10(%ebp),%eax
  80089c:	8a 00                	mov    (%eax),%al
  80089e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a4:	7e 3e                	jle    8008e4 <vprintfmt+0xe9>
  8008a6:	83 fb 39             	cmp    $0x39,%ebx
  8008a9:	7f 39                	jg     8008e4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ab:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ae:	eb d5                	jmp    800885 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	83 c0 04             	add    $0x4,%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c4:	eb 1f                	jmp    8008e5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	79 83                	jns    80084f <vprintfmt+0x54>
				width = 0;
  8008cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d3:	e9 77 ff ff ff       	jmp    80084f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008df:	e9 6b ff ff ff       	jmp    80084f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e9:	0f 89 60 ff ff ff    	jns    80084f <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fc:	e9 4e ff ff ff       	jmp    80084f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800901:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800904:	e9 46 ff ff ff       	jmp    80084f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	50                   	push   %eax
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			break;
  800929:	e9 9b 02 00 00       	jmp    800bc9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	83 c0 04             	add    $0x4,%eax
  800934:	89 45 14             	mov    %eax,0x14(%ebp)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 e8 04             	sub    $0x4,%eax
  80093d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093f:	85 db                	test   %ebx,%ebx
  800941:	79 02                	jns    800945 <vprintfmt+0x14a>
				err = -err;
  800943:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800945:	83 fb 64             	cmp    $0x64,%ebx
  800948:	7f 0b                	jg     800955 <vprintfmt+0x15a>
  80094a:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 19                	jne    80096e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800955:	53                   	push   %ebx
  800956:	68 05 23 80 00       	push   $0x802305
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 70 02 00 00       	call   800bd6 <printfmt>
  800966:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800969:	e9 5b 02 00 00       	jmp    800bc9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096e:	56                   	push   %esi
  80096f:	68 0e 23 80 00       	push   $0x80230e
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	e8 57 02 00 00       	call   800bd6 <printfmt>
  80097f:	83 c4 10             	add    $0x10,%esp
			break;
  800982:	e9 42 02 00 00       	jmp    800bc9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	83 c0 04             	add    $0x4,%eax
  80098d:	89 45 14             	mov    %eax,0x14(%ebp)
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 e8 04             	sub    $0x4,%eax
  800996:	8b 30                	mov    (%eax),%esi
  800998:	85 f6                	test   %esi,%esi
  80099a:	75 05                	jne    8009a1 <vprintfmt+0x1a6>
				p = "(null)";
  80099c:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  8009a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a5:	7e 6d                	jle    800a14 <vprintfmt+0x219>
  8009a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ab:	74 67                	je     800a14 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	50                   	push   %eax
  8009b4:	56                   	push   %esi
  8009b5:	e8 1e 03 00 00       	call   800cd8 <strnlen>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c0:	eb 16                	jmp    8009d8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	50                   	push   %eax
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dc:	7f e4                	jg     8009c2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009de:	eb 34                	jmp    800a14 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e4:	74 1c                	je     800a02 <vprintfmt+0x207>
  8009e6:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e9:	7e 05                	jle    8009f0 <vprintfmt+0x1f5>
  8009eb:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ee:	7e 12                	jle    800a02 <vprintfmt+0x207>
					putch('?', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 3f                	push   $0x3f
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
  800a00:	eb 0f                	jmp    800a11 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	53                   	push   %ebx
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a11:	ff 4d e4             	decl   -0x1c(%ebp)
  800a14:	89 f0                	mov    %esi,%eax
  800a16:	8d 70 01             	lea    0x1(%eax),%esi
  800a19:	8a 00                	mov    (%eax),%al
  800a1b:	0f be d8             	movsbl %al,%ebx
  800a1e:	85 db                	test   %ebx,%ebx
  800a20:	74 24                	je     800a46 <vprintfmt+0x24b>
  800a22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a26:	78 b8                	js     8009e0 <vprintfmt+0x1e5>
  800a28:	ff 4d e0             	decl   -0x20(%ebp)
  800a2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2f:	79 af                	jns    8009e0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a31:	eb 13                	jmp    800a46 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 20                	push   $0x20
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a43:	ff 4d e4             	decl   -0x1c(%ebp)
  800a46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4a:	7f e7                	jg     800a33 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4c:	e9 78 01 00 00       	jmp    800bc9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 3c fd ff ff       	call   80079c <getint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6f:	85 d2                	test   %edx,%edx
  800a71:	79 23                	jns    800a96 <vprintfmt+0x29b>
				putch('-', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	6a 2d                	push   $0x2d
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a89:	f7 d8                	neg    %eax
  800a8b:	83 d2 00             	adc    $0x0,%edx
  800a8e:	f7 da                	neg    %edx
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a96:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9d:	e9 bc 00 00 00       	jmp    800b5e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa8:	8d 45 14             	lea    0x14(%ebp),%eax
  800aab:	50                   	push   %eax
  800aac:	e8 84 fc ff ff       	call   800735 <getuint>
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac1:	e9 98 00 00 00       	jmp    800b5e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	6a 58                	push   $0x58
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	6a 58                	push   $0x58
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	ff d0                	call   *%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 58                	push   $0x58
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	e9 ce 00 00 00       	jmp    800bc9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	6a 30                	push   $0x30
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 78                	push   $0x78
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1e:	83 c0 04             	add    $0x4,%eax
  800b21:	89 45 14             	mov    %eax,0x14(%ebp)
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	83 e8 04             	sub    $0x4,%eax
  800b2a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3d:	eb 1f                	jmp    800b5e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 e8             	pushl  -0x18(%ebp)
  800b45:	8d 45 14             	lea    0x14(%ebp),%eax
  800b48:	50                   	push   %eax
  800b49:	e8 e7 fb ff ff       	call   800735 <getuint>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b57:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	52                   	push   %edx
  800b69:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6c:	50                   	push   %eax
  800b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b70:	ff 75 f0             	pushl  -0x10(%ebp)
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	ff 75 08             	pushl  0x8(%ebp)
  800b79:	e8 00 fb ff ff       	call   80067e <printnum>
  800b7e:	83 c4 20             	add    $0x20,%esp
			break;
  800b81:	eb 46                	jmp    800bc9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			break;
  800b92:	eb 35                	jmp    800bc9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b94:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800b9b:	eb 2c                	jmp    800bc9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b9d:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800ba4:	eb 23                	jmp    800bc9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 25                	push   $0x25
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb6:	ff 4d 10             	decl   0x10(%ebp)
  800bb9:	eb 03                	jmp    800bbe <vprintfmt+0x3c3>
  800bbb:	ff 4d 10             	decl   0x10(%ebp)
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	48                   	dec    %eax
  800bc2:	8a 00                	mov    (%eax),%al
  800bc4:	3c 25                	cmp    $0x25,%al
  800bc6:	75 f3                	jne    800bbb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bc8:	90                   	nop
		}
	}
  800bc9:	e9 35 fc ff ff       	jmp    800803 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bce:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdc:	8d 45 10             	lea    0x10(%ebp),%eax
  800bdf:	83 c0 04             	add    $0x4,%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be5:	8b 45 10             	mov    0x10(%ebp),%eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	50                   	push   %eax
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	ff 75 08             	pushl  0x8(%ebp)
  800bf2:	e8 04 fc ff ff       	call   8007fb <vprintfmt>
  800bf7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bfa:	90                   	nop
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	8b 40 08             	mov    0x8(%eax),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8b 10                	mov    (%eax),%edx
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8b 40 04             	mov    0x4(%eax),%eax
  800c1a:	39 c2                	cmp    %eax,%edx
  800c1c:	73 12                	jae    800c30 <sprintputch+0x33>
		*b->buf++ = ch;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 48 01             	lea    0x1(%eax),%ecx
  800c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c29:	89 0a                	mov    %ecx,(%edx)
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	88 10                	mov    %dl,(%eax)
}
  800c30:	90                   	nop
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	01 d0                	add    %edx,%eax
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c58:	74 06                	je     800c60 <vsnprintf+0x2d>
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	7f 07                	jg     800c67 <vsnprintf+0x34>
		return -E_INVAL;
  800c60:	b8 03 00 00 00       	mov    $0x3,%eax
  800c65:	eb 20                	jmp    800c87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c67:	ff 75 14             	pushl  0x14(%ebp)
  800c6a:	ff 75 10             	pushl  0x10(%ebp)
  800c6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c70:	50                   	push   %eax
  800c71:	68 fd 0b 80 00       	push   $0x800bfd
  800c76:	e8 80 fb ff ff       	call   8007fb <vprintfmt>
  800c7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c98:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9e:	50                   	push   %eax
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 89 ff ff ff       	call   800c33 <vsnprintf>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc2:	eb 06                	jmp    800cca <strlen+0x15>
		n++;
  800cc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc7:	ff 45 08             	incl   0x8(%ebp)
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	84 c0                	test   %al,%al
  800cd1:	75 f1                	jne    800cc4 <strlen+0xf>
		n++;
	return n;
  800cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce5:	eb 09                	jmp    800cf0 <strnlen+0x18>
		n++;
  800ce7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cea:	ff 45 08             	incl   0x8(%ebp)
  800ced:	ff 4d 0c             	decl   0xc(%ebp)
  800cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf4:	74 09                	je     800cff <strnlen+0x27>
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	75 e8                	jne    800ce7 <strnlen+0xf>
		n++;
	return n;
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d10:	90                   	nop
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8d 50 01             	lea    0x1(%eax),%edx
  800d17:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d23:	8a 12                	mov    (%edx),%dl
  800d25:	88 10                	mov    %dl,(%eax)
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	84 c0                	test   %al,%al
  800d2b:	75 e4                	jne    800d11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d45:	eb 1f                	jmp    800d66 <strncpy+0x34>
		*dst++ = *src;
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8d 50 01             	lea    0x1(%eax),%edx
  800d4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d53:	8a 12                	mov    (%edx),%dl
  800d55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	74 03                	je     800d63 <strncpy+0x31>
			src++;
  800d60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d63:	ff 45 fc             	incl   -0x4(%ebp)
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6c:	72 d9                	jb     800d47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	74 30                	je     800db5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d85:	eb 16                	jmp    800d9d <strlcpy+0x2a>
			*dst++ = *src++;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d99:	8a 12                	mov    (%edx),%dl
  800d9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9d:	ff 4d 10             	decl   0x10(%ebp)
  800da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da4:	74 09                	je     800daf <strlcpy+0x3c>
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	75 d8                	jne    800d87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbb:	29 c2                	sub    %eax,%edx
  800dbd:	89 d0                	mov    %edx,%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc4:	eb 06                	jmp    800dcc <strcmp+0xb>
		p++, q++;
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 0e                	je     800de3 <strcmp+0x22>
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8a 10                	mov    (%eax),%dl
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	38 c2                	cmp    %al,%dl
  800de1:	74 e3                	je     800dc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	0f b6 d0             	movzbl %al,%edx
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	0f b6 c0             	movzbl %al,%eax
  800df3:	29 c2                	sub    %eax,%edx
  800df5:	89 d0                	mov    %edx,%eax
}
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfc:	eb 09                	jmp    800e07 <strncmp+0xe>
		n--, p++, q++;
  800dfe:	ff 4d 10             	decl   0x10(%ebp)
  800e01:	ff 45 08             	incl   0x8(%ebp)
  800e04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0b:	74 17                	je     800e24 <strncmp+0x2b>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	84 c0                	test   %al,%al
  800e14:	74 0e                	je     800e24 <strncmp+0x2b>
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 10                	mov    (%eax),%dl
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	38 c2                	cmp    %al,%dl
  800e22:	74 da                	je     800dfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e28:	75 07                	jne    800e31 <strncmp+0x38>
		return 0;
  800e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2f:	eb 14                	jmp    800e45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f b6 d0             	movzbl %al,%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	0f b6 c0             	movzbl %al,%eax
  800e41:	29 c2                	sub    %eax,%edx
  800e43:	89 d0                	mov    %edx,%eax
}
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 04             	sub    $0x4,%esp
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e53:	eb 12                	jmp    800e67 <strchr+0x20>
		if (*s == c)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5d:	75 05                	jne    800e64 <strchr+0x1d>
			return (char *) s;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	eb 11                	jmp    800e75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	84 c0                	test   %al,%al
  800e6e:	75 e5                	jne    800e55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e83:	eb 0d                	jmp    800e92 <strfind+0x1b>
		if (*s == c)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8d:	74 0e                	je     800e9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8f:	ff 45 08             	incl   0x8(%ebp)
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	75 ea                	jne    800e85 <strfind+0xe>
  800e9b:	eb 01                	jmp    800e9e <strfind+0x27>
		if (*s == c)
			break;
  800e9d:	90                   	nop
	return (char *) s;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800eaf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb3:	76 63                	jbe    800f18 <memset+0x75>
		uint64 data_block = c;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	99                   	cltd   
  800eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ebc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ec9:	c1 e0 08             	shl    $0x8,%eax
  800ecc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ecf:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800edc:	c1 e0 10             	shl    $0x10,%eax
  800edf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eeb:	89 c2                	mov    %eax,%edx
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ef8:	eb 18                	jmp    800f12 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800efa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800efd:	8d 41 08             	lea    0x8(%ecx),%eax
  800f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f09:	89 01                	mov    %eax,(%ecx)
  800f0b:	89 51 04             	mov    %edx,0x4(%ecx)
  800f0e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f12:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f16:	77 e2                	ja     800efa <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1c:	74 23                	je     800f41 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f24:	eb 0e                	jmp    800f34 <memset+0x91>
			*p8++ = (uint8)c;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f32:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	75 e5                	jne    800f26 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f58:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5c:	76 24                	jbe    800f82 <memcpy+0x3c>
		while(n >= 8){
  800f5e:	eb 1c                	jmp    800f7c <memcpy+0x36>
			*d64 = *s64;
  800f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f63:	8b 50 04             	mov    0x4(%eax),%edx
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f6b:	89 01                	mov    %eax,(%ecx)
  800f6d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f70:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f74:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f78:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f7c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f80:	77 de                	ja     800f60 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	74 31                	je     800fb9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f94:	eb 16                	jmp    800fac <memcpy+0x66>
			*d8++ = *s8++;
  800f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f99:	8d 50 01             	lea    0x1(%eax),%edx
  800f9c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fa8:	8a 12                	mov    (%edx),%dl
  800faa:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	75 dd                	jne    800f96 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd6:	73 50                	jae    801028 <memmove+0x6a>
  800fd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fde:	01 d0                	add    %edx,%eax
  800fe0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe3:	76 43                	jbe    801028 <memmove+0x6a>
		s += n;
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ff1:	eb 10                	jmp    801003 <memmove+0x45>
			*--d = *--s;
  800ff3:	ff 4d f8             	decl   -0x8(%ebp)
  800ff6:	ff 4d fc             	decl   -0x4(%ebp)
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	8a 10                	mov    (%eax),%dl
  800ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801001:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	8d 50 ff             	lea    -0x1(%eax),%edx
  801009:	89 55 10             	mov    %edx,0x10(%ebp)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	75 e3                	jne    800ff3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801010:	eb 23                	jmp    801035 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	8d 50 01             	lea    0x1(%eax),%edx
  801018:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801021:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801024:	8a 12                	mov    (%edx),%dl
  801026:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102e:	89 55 10             	mov    %edx,0x10(%ebp)
  801031:	85 c0                	test   %eax,%eax
  801033:	75 dd                	jne    801012 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80104c:	eb 2a                	jmp    801078 <memcmp+0x3e>
		if (*s1 != *s2)
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	8a 10                	mov    (%eax),%dl
  801053:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	38 c2                	cmp    %al,%dl
  80105a:	74 16                	je     801072 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80105c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f b6 d0             	movzbl %al,%edx
  801064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	0f b6 c0             	movzbl %al,%eax
  80106c:	29 c2                	sub    %eax,%edx
  80106e:	89 d0                	mov    %edx,%eax
  801070:	eb 18                	jmp    80108a <memcmp+0x50>
		s1++, s2++;
  801072:	ff 45 fc             	incl   -0x4(%ebp)
  801075:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107e:	89 55 10             	mov    %edx,0x10(%ebp)
  801081:	85 c0                	test   %eax,%eax
  801083:	75 c9                	jne    80104e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	8b 45 10             	mov    0x10(%ebp),%eax
  801098:	01 d0                	add    %edx,%eax
  80109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80109d:	eb 15                	jmp    8010b4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f b6 d0             	movzbl %al,%edx
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	0f b6 c0             	movzbl %al,%eax
  8010ad:	39 c2                	cmp    %eax,%edx
  8010af:	74 0d                	je     8010be <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010b1:	ff 45 08             	incl   0x8(%ebp)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ba:	72 e3                	jb     80109f <memfind+0x13>
  8010bc:	eb 01                	jmp    8010bf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010be:	90                   	nop
	return (void *) s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d8:	eb 03                	jmp    8010dd <strtol+0x19>
		s++;
  8010da:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 20                	cmp    $0x20,%al
  8010e4:	74 f4                	je     8010da <strtol+0x16>
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	3c 09                	cmp    $0x9,%al
  8010ed:	74 eb                	je     8010da <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 2b                	cmp    $0x2b,%al
  8010f6:	75 05                	jne    8010fd <strtol+0x39>
		s++;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	eb 13                	jmp    801110 <strtol+0x4c>
	else if (*s == '-')
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	3c 2d                	cmp    $0x2d,%al
  801104:	75 0a                	jne    801110 <strtol+0x4c>
		s++, neg = 1;
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	74 06                	je     80111c <strtol+0x58>
  801116:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80111a:	75 20                	jne    80113c <strtol+0x78>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 30                	cmp    $0x30,%al
  801123:	75 17                	jne    80113c <strtol+0x78>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	40                   	inc    %eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 78                	cmp    $0x78,%al
  80112d:	75 0d                	jne    80113c <strtol+0x78>
		s += 2, base = 16;
  80112f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801133:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80113a:	eb 28                	jmp    801164 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80113c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801140:	75 15                	jne    801157 <strtol+0x93>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 30                	cmp    $0x30,%al
  801149:	75 0c                	jne    801157 <strtol+0x93>
		s++, base = 8;
  80114b:	ff 45 08             	incl   0x8(%ebp)
  80114e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801155:	eb 0d                	jmp    801164 <strtol+0xa0>
	else if (base == 0)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	75 07                	jne    801164 <strtol+0xa0>
		base = 10;
  80115d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 2f                	cmp    $0x2f,%al
  80116b:	7e 19                	jle    801186 <strtol+0xc2>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 39                	cmp    $0x39,%al
  801174:	7f 10                	jg     801186 <strtol+0xc2>
			dig = *s - '0';
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	83 e8 30             	sub    $0x30,%eax
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801184:	eb 42                	jmp    8011c8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 60                	cmp    $0x60,%al
  80118d:	7e 19                	jle    8011a8 <strtol+0xe4>
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 7a                	cmp    $0x7a,%al
  801196:	7f 10                	jg     8011a8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	0f be c0             	movsbl %al,%eax
  8011a0:	83 e8 57             	sub    $0x57,%eax
  8011a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a6:	eb 20                	jmp    8011c8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	3c 40                	cmp    $0x40,%al
  8011af:	7e 39                	jle    8011ea <strtol+0x126>
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	3c 5a                	cmp    $0x5a,%al
  8011b8:	7f 30                	jg     8011ea <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	0f be c0             	movsbl %al,%eax
  8011c2:	83 e8 37             	sub    $0x37,%eax
  8011c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ce:	7d 19                	jge    8011e9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011e4:	e9 7b ff ff ff       	jmp    801164 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011e9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ee:	74 08                	je     8011f8 <strtol+0x134>
		*endptr = (char *) s;
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fc:	74 07                	je     801205 <strtol+0x141>
  8011fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801201:	f7 d8                	neg    %eax
  801203:	eb 03                	jmp    801208 <strtol+0x144>
  801205:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <ltostr>:

void
ltostr(long value, char *str)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801217:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80121e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801222:	79 13                	jns    801237 <ltostr+0x2d>
	{
		neg = 1;
  801224:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801231:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801234:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80123f:	99                   	cltd   
  801240:	f7 f9                	idiv   %ecx
  801242:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801245:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80124e:	89 c2                	mov    %eax,%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801258:	83 c2 30             	add    $0x30,%edx
  80125b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80125d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801260:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801265:	f7 e9                	imul   %ecx
  801267:	c1 fa 02             	sar    $0x2,%edx
  80126a:	89 c8                	mov    %ecx,%eax
  80126c:	c1 f8 1f             	sar    $0x1f,%eax
  80126f:	29 c2                	sub    %eax,%edx
  801271:	89 d0                	mov    %edx,%eax
  801273:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127a:	75 bb                	jne    801237 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80127c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	48                   	dec    %eax
  801287:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80128a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80128e:	74 3d                	je     8012cd <ltostr+0xc3>
		start = 1 ;
  801290:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801297:	eb 34                	jmp    8012cd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	01 c2                	add    %eax,%edx
  8012ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	01 c8                	add    %ecx,%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 c2                	add    %eax,%edx
  8012c2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c5:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ca:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d3:	7c c4                	jl     801299 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e0:	90                   	nop
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	e8 c4 f9 ff ff       	call   800cb5 <strlen>
  8012f1:	83 c4 04             	add    $0x4,%esp
  8012f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	e8 b6 f9 ff ff       	call   800cb5 <strlen>
  8012ff:	83 c4 04             	add    $0x4,%esp
  801302:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80130c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801313:	eb 17                	jmp    80132c <strcconcat+0x49>
		final[s] = str1[s] ;
  801315:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	01 c2                	add    %eax,%edx
  80131d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	01 c8                	add    %ecx,%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801329:	ff 45 fc             	incl   -0x4(%ebp)
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801332:	7c e1                	jl     801315 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801334:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80133b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801342:	eb 1f                	jmp    801363 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801344:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 c2                	add    %eax,%edx
  801354:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	01 c8                	add    %ecx,%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801360:	ff 45 f8             	incl   -0x8(%ebp)
  801363:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801366:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801369:	7c d9                	jl     801344 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80136b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c6 00 00             	movb   $0x0,(%eax)
}
  801376:	90                   	nop
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80137c:	8b 45 14             	mov    0x14(%ebp),%eax
  80137f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801385:	8b 45 14             	mov    0x14(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	01 d0                	add    %edx,%eax
  801396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80139c:	eb 0c                	jmp    8013aa <strsplit+0x31>
			*string++ = 0;
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8d 50 01             	lea    0x1(%eax),%edx
  8013a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 18                	je     8013cb <strsplit+0x52>
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	0f be c0             	movsbl %al,%eax
  8013bb:	50                   	push   %eax
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	e8 83 fa ff ff       	call   800e47 <strchr>
  8013c4:	83 c4 08             	add    $0x8,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	75 d3                	jne    80139e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	84 c0                	test   %al,%al
  8013d2:	74 5a                	je     80142e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	83 f8 0f             	cmp    $0xf,%eax
  8013dc:	75 07                	jne    8013e5 <strsplit+0x6c>
		{
			return 0;
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e3:	eb 66                	jmp    80144b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	8b 00                	mov    (%eax),%eax
  8013ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ed:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f0:	89 0a                	mov    %ecx,(%edx)
  8013f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 c2                	add    %eax,%edx
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801403:	eb 03                	jmp    801408 <strsplit+0x8f>
			string++;
  801405:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	84 c0                	test   %al,%al
  80140f:	74 8b                	je     80139c <strsplit+0x23>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	0f be c0             	movsbl %al,%eax
  801419:	50                   	push   %eax
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	e8 25 fa ff ff       	call   800e47 <strchr>
  801422:	83 c4 08             	add    $0x8,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	74 dc                	je     801405 <strsplit+0x8c>
			string++;
	}
  801429:	e9 6e ff ff ff       	jmp    80139c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80142e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80142f:	8b 45 14             	mov    0x14(%ebp),%eax
  801432:	8b 00                	mov    (%eax),%eax
  801434:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801446:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801460:	eb 4a                	jmp    8014ac <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	01 c2                	add    %eax,%edx
  80146a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	01 c8                	add    %ecx,%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 40                	cmp    $0x40,%al
  801482:	7e 25                	jle    8014a9 <str2lower+0x5c>
  801484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 5a                	cmp    $0x5a,%al
  801490:	7f 17                	jg     8014a9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801492:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	01 d0                	add    %edx,%eax
  80149a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	01 ca                	add    %ecx,%edx
  8014a2:	8a 12                	mov    (%edx),%dl
  8014a4:	83 c2 20             	add    $0x20,%edx
  8014a7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014a9:	ff 45 fc             	incl   -0x4(%ebp)
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	e8 01 f8 ff ff       	call   800cb5 <strlen>
  8014b4:	83 c4 04             	add    $0x4,%esp
  8014b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ba:	7f a6                	jg     801462 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	57                   	push   %edi
  8014c5:	56                   	push   %esi
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014d9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014dc:	cd 30                	int    $0x30
  8014de:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	5b                   	pop    %ebx
  8014e8:	5e                   	pop    %esi
  8014e9:	5f                   	pop    %edi
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	51                   	push   %ecx
  801505:	52                   	push   %edx
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	50                   	push   %eax
  80150a:	6a 00                	push   $0x0
  80150c:	e8 b0 ff ff ff       	call   8014c1 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	90                   	nop
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_cgetc>:

int
sys_cgetc(void)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 02                	push   $0x2
  801526:	e8 96 ff ff ff       	call   8014c1 <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 03                	push   $0x3
  80153f:	e8 7d ff ff ff       	call   8014c1 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	90                   	nop
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 04                	push   $0x4
  801559:	e8 63 ff ff ff       	call   8014c1 <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	52                   	push   %edx
  801574:	50                   	push   %eax
  801575:	6a 08                	push   $0x8
  801577:	e8 45 ff ff ff       	call   8014c1 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801586:	8b 75 18             	mov    0x18(%ebp),%esi
  801589:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80158c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
  801597:	51                   	push   %ecx
  801598:	52                   	push   %edx
  801599:	50                   	push   %eax
  80159a:	6a 09                	push   $0x9
  80159c:	e8 20 ff ff ff       	call   8014c1 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a7:	5b                   	pop    %ebx
  8015a8:	5e                   	pop    %esi
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    

008015ab <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	6a 0a                	push   $0xa
  8015bb:	e8 01 ff ff ff       	call   8014c1 <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	6a 0b                	push   $0xb
  8015d6:	e8 e6 fe ff ff       	call   8014c1 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 0c                	push   $0xc
  8015ef:	e8 cd fe ff ff       	call   8014c1 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 0d                	push   $0xd
  801608:	e8 b4 fe ff ff       	call   8014c1 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 0e                	push   $0xe
  801621:	e8 9b fe ff ff       	call   8014c1 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 0f                	push   $0xf
  80163a:	e8 82 fe ff ff       	call   8014c1 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 08             	pushl  0x8(%ebp)
  801652:	6a 10                	push   $0x10
  801654:	e8 68 fe ff ff       	call   8014c1 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 11                	push   $0x11
  80166d:	e8 4f fe ff ff       	call   8014c1 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_cputc>:

void
sys_cputc(const char c)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801684:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	50                   	push   %eax
  801691:	6a 01                	push   $0x1
  801693:	e8 29 fe ff ff       	call   8014c1 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 14                	push   $0x14
  8016ad:	e8 0f fe ff ff       	call   8014c1 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	90                   	nop
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	6a 00                	push   $0x0
  8016d0:	51                   	push   %ecx
  8016d1:	52                   	push   %edx
  8016d2:	ff 75 0c             	pushl  0xc(%ebp)
  8016d5:	50                   	push   %eax
  8016d6:	6a 15                	push   $0x15
  8016d8:	e8 e4 fd ff ff       	call   8014c1 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	52                   	push   %edx
  8016f2:	50                   	push   %eax
  8016f3:	6a 16                	push   $0x16
  8016f5:	e8 c7 fd ff ff       	call   8014c1 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801702:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801705:	8b 55 0c             	mov    0xc(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	51                   	push   %ecx
  801710:	52                   	push   %edx
  801711:	50                   	push   %eax
  801712:	6a 17                	push   $0x17
  801714:	e8 a8 fd ff ff       	call   8014c1 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801721:	8b 55 0c             	mov    0xc(%ebp),%edx
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	52                   	push   %edx
  80172e:	50                   	push   %eax
  80172f:	6a 18                	push   $0x18
  801731:	e8 8b fd ff ff       	call   8014c1 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	ff 75 14             	pushl  0x14(%ebp)
  801746:	ff 75 10             	pushl  0x10(%ebp)
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	50                   	push   %eax
  80174d:	6a 19                	push   $0x19
  80174f:	e8 6d fd ff ff       	call   8014c1 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	50                   	push   %eax
  801768:	6a 1a                	push   $0x1a
  80176a:	e8 52 fd ff ff       	call   8014c1 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	50                   	push   %eax
  801784:	6a 1b                	push   $0x1b
  801786:	e8 36 fd ff ff       	call   8014c1 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 05                	push   $0x5
  80179f:	e8 1d fd ff ff       	call   8014c1 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 06                	push   $0x6
  8017b8:	e8 04 fd ff ff       	call   8014c1 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 07                	push   $0x7
  8017d1:	e8 eb fc ff ff       	call   8014c1 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_exit_env>:


void sys_exit_env(void)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 1c                	push   $0x1c
  8017ea:	e8 d2 fc ff ff       	call   8014c1 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017fe:	8d 50 04             	lea    0x4(%eax),%edx
  801801:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 1d                	push   $0x1d
  80180e:	e8 ae fc ff ff       	call   8014c1 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
	return result;
  801816:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801819:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181f:	89 01                	mov    %eax,(%ecx)
  801821:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	c9                   	leave  
  801828:	c2 04 00             	ret    $0x4

0080182b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	6a 13                	push   $0x13
  80183d:	e8 7f fc ff ff       	call   8014c1 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
	return ;
  801845:	90                   	nop
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_rcr2>:
uint32 sys_rcr2()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 1e                	push   $0x1e
  801857:	e8 65 fc ff ff       	call   8014c1 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80186d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	50                   	push   %eax
  80187a:	6a 1f                	push   $0x1f
  80187c:	e8 40 fc ff ff       	call   8014c1 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return ;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <rsttst>:
void rsttst()
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 21                	push   $0x21
  801896:	e8 26 fc ff ff       	call   8014c1 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return ;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018ad:	8b 55 18             	mov    0x18(%ebp),%edx
  8018b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	ff 75 10             	pushl  0x10(%ebp)
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	6a 20                	push   $0x20
  8018c1:	e8 fb fb ff ff       	call   8014c1 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c9:	90                   	nop
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <chktst>:
void chktst(uint32 n)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	6a 22                	push   $0x22
  8018dc:	e8 e0 fb ff ff       	call   8014c1 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e4:	90                   	nop
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <inctst>:

void inctst()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 23                	push   $0x23
  8018f6:	e8 c6 fb ff ff       	call   8014c1 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <gettst>:
uint32 gettst()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 24                	push   $0x24
  801910:	e8 ac fb ff ff       	call   8014c1 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 25                	push   $0x25
  801929:	e8 93 fb ff ff       	call   8014c1 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
  801931:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  801936:	a1 00 71 82 00       	mov    0x827100,%eax
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 26                	push   $0x26
  801955:	e8 67 fb ff ff       	call   8014c1 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801964:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801967:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	53                   	push   %ebx
  801973:	51                   	push   %ecx
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 27                	push   $0x27
  801978:	e8 44 fb ff ff       	call   8014c1 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 28                	push   $0x28
  801998:	e8 24 fb ff ff       	call   8014c1 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	51                   	push   %ecx
  8019b1:	ff 75 10             	pushl  0x10(%ebp)
  8019b4:	52                   	push   %edx
  8019b5:	50                   	push   %eax
  8019b6:	6a 29                	push   $0x29
  8019b8:	e8 04 fb ff ff       	call   8014c1 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 12                	push   $0x12
  8019d4:	e8 e8 fa ff ff       	call   8014c1 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 2a                	push   $0x2a
  8019f2:	e8 ca fa ff ff       	call   8014c1 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 2b                	push   $0x2b
  801a0c:	e8 b0 fa ff ff       	call   8014c1 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 2d                	push   $0x2d
  801a27:	e8 95 fa ff ff       	call   8014c1 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 2c                	push   $0x2c
  801a43:	e8 79 fa ff ff       	call   8014c1 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	68 88 24 80 00       	push   $0x802488
  801a5c:	68 25 01 00 00       	push   $0x125
  801a61:	68 bb 24 80 00       	push   $0x8024bb
  801a66:	e8 a3 e8 ff ff       	call   80030e <_panic>
  801a6b:	90                   	nop

00801a6c <__udivdi3>:
  801a6c:	55                   	push   %ebp
  801a6d:	57                   	push   %edi
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 1c             	sub    $0x1c,%esp
  801a73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a83:	89 ca                	mov    %ecx,%edx
  801a85:	89 f8                	mov    %edi,%eax
  801a87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a8b:	85 f6                	test   %esi,%esi
  801a8d:	75 2d                	jne    801abc <__udivdi3+0x50>
  801a8f:	39 cf                	cmp    %ecx,%edi
  801a91:	77 65                	ja     801af8 <__udivdi3+0x8c>
  801a93:	89 fd                	mov    %edi,%ebp
  801a95:	85 ff                	test   %edi,%edi
  801a97:	75 0b                	jne    801aa4 <__udivdi3+0x38>
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9e:	31 d2                	xor    %edx,%edx
  801aa0:	f7 f7                	div    %edi
  801aa2:	89 c5                	mov    %eax,%ebp
  801aa4:	31 d2                	xor    %edx,%edx
  801aa6:	89 c8                	mov    %ecx,%eax
  801aa8:	f7 f5                	div    %ebp
  801aaa:	89 c1                	mov    %eax,%ecx
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	f7 f5                	div    %ebp
  801ab0:	89 cf                	mov    %ecx,%edi
  801ab2:	89 fa                	mov    %edi,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	39 ce                	cmp    %ecx,%esi
  801abe:	77 28                	ja     801ae8 <__udivdi3+0x7c>
  801ac0:	0f bd fe             	bsr    %esi,%edi
  801ac3:	83 f7 1f             	xor    $0x1f,%edi
  801ac6:	75 40                	jne    801b08 <__udivdi3+0x9c>
  801ac8:	39 ce                	cmp    %ecx,%esi
  801aca:	72 0a                	jb     801ad6 <__udivdi3+0x6a>
  801acc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ad0:	0f 87 9e 00 00 00    	ja     801b74 <__udivdi3+0x108>
  801ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  801adb:	89 fa                	mov    %edi,%edx
  801add:	83 c4 1c             	add    $0x1c,%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5f                   	pop    %edi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    
  801ae5:	8d 76 00             	lea    0x0(%esi),%esi
  801ae8:	31 ff                	xor    %edi,%edi
  801aea:	31 c0                	xor    %eax,%eax
  801aec:	89 fa                	mov    %edi,%edx
  801aee:	83 c4 1c             	add    $0x1c,%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	f7 f7                	div    %edi
  801afc:	31 ff                	xor    %edi,%edi
  801afe:	89 fa                	mov    %edi,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b0d:	89 eb                	mov    %ebp,%ebx
  801b0f:	29 fb                	sub    %edi,%ebx
  801b11:	89 f9                	mov    %edi,%ecx
  801b13:	d3 e6                	shl    %cl,%esi
  801b15:	89 c5                	mov    %eax,%ebp
  801b17:	88 d9                	mov    %bl,%cl
  801b19:	d3 ed                	shr    %cl,%ebp
  801b1b:	89 e9                	mov    %ebp,%ecx
  801b1d:	09 f1                	or     %esi,%ecx
  801b1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b23:	89 f9                	mov    %edi,%ecx
  801b25:	d3 e0                	shl    %cl,%eax
  801b27:	89 c5                	mov    %eax,%ebp
  801b29:	89 d6                	mov    %edx,%esi
  801b2b:	88 d9                	mov    %bl,%cl
  801b2d:	d3 ee                	shr    %cl,%esi
  801b2f:	89 f9                	mov    %edi,%ecx
  801b31:	d3 e2                	shl    %cl,%edx
  801b33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b37:	88 d9                	mov    %bl,%cl
  801b39:	d3 e8                	shr    %cl,%eax
  801b3b:	09 c2                	or     %eax,%edx
  801b3d:	89 d0                	mov    %edx,%eax
  801b3f:	89 f2                	mov    %esi,%edx
  801b41:	f7 74 24 0c          	divl   0xc(%esp)
  801b45:	89 d6                	mov    %edx,%esi
  801b47:	89 c3                	mov    %eax,%ebx
  801b49:	f7 e5                	mul    %ebp
  801b4b:	39 d6                	cmp    %edx,%esi
  801b4d:	72 19                	jb     801b68 <__udivdi3+0xfc>
  801b4f:	74 0b                	je     801b5c <__udivdi3+0xf0>
  801b51:	89 d8                	mov    %ebx,%eax
  801b53:	31 ff                	xor    %edi,%edi
  801b55:	e9 58 ff ff ff       	jmp    801ab2 <__udivdi3+0x46>
  801b5a:	66 90                	xchg   %ax,%ax
  801b5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b60:	89 f9                	mov    %edi,%ecx
  801b62:	d3 e2                	shl    %cl,%edx
  801b64:	39 c2                	cmp    %eax,%edx
  801b66:	73 e9                	jae    801b51 <__udivdi3+0xe5>
  801b68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b6b:	31 ff                	xor    %edi,%edi
  801b6d:	e9 40 ff ff ff       	jmp    801ab2 <__udivdi3+0x46>
  801b72:	66 90                	xchg   %ax,%ax
  801b74:	31 c0                	xor    %eax,%eax
  801b76:	e9 37 ff ff ff       	jmp    801ab2 <__udivdi3+0x46>
  801b7b:	90                   	nop

00801b7c <__umoddi3>:
  801b7c:	55                   	push   %ebp
  801b7d:	57                   	push   %edi
  801b7e:	56                   	push   %esi
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 1c             	sub    $0x1c,%esp
  801b83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b9b:	89 f3                	mov    %esi,%ebx
  801b9d:	89 fa                	mov    %edi,%edx
  801b9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba3:	89 34 24             	mov    %esi,(%esp)
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	75 1a                	jne    801bc4 <__umoddi3+0x48>
  801baa:	39 f7                	cmp    %esi,%edi
  801bac:	0f 86 a2 00 00 00    	jbe    801c54 <__umoddi3+0xd8>
  801bb2:	89 c8                	mov    %ecx,%eax
  801bb4:	89 f2                	mov    %esi,%edx
  801bb6:	f7 f7                	div    %edi
  801bb8:	89 d0                	mov    %edx,%eax
  801bba:	31 d2                	xor    %edx,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	39 f0                	cmp    %esi,%eax
  801bc6:	0f 87 ac 00 00 00    	ja     801c78 <__umoddi3+0xfc>
  801bcc:	0f bd e8             	bsr    %eax,%ebp
  801bcf:	83 f5 1f             	xor    $0x1f,%ebp
  801bd2:	0f 84 ac 00 00 00    	je     801c84 <__umoddi3+0x108>
  801bd8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bdd:	29 ef                	sub    %ebp,%edi
  801bdf:	89 fe                	mov    %edi,%esi
  801be1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 e0                	shl    %cl,%eax
  801be9:	89 d7                	mov    %edx,%edi
  801beb:	89 f1                	mov    %esi,%ecx
  801bed:	d3 ef                	shr    %cl,%edi
  801bef:	09 c7                	or     %eax,%edi
  801bf1:	89 e9                	mov    %ebp,%ecx
  801bf3:	d3 e2                	shl    %cl,%edx
  801bf5:	89 14 24             	mov    %edx,(%esp)
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	d3 e0                	shl    %cl,%eax
  801bfc:	89 c2                	mov    %eax,%edx
  801bfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c02:	d3 e0                	shl    %cl,%eax
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c0c:	89 f1                	mov    %esi,%ecx
  801c0e:	d3 e8                	shr    %cl,%eax
  801c10:	09 d0                	or     %edx,%eax
  801c12:	d3 eb                	shr    %cl,%ebx
  801c14:	89 da                	mov    %ebx,%edx
  801c16:	f7 f7                	div    %edi
  801c18:	89 d3                	mov    %edx,%ebx
  801c1a:	f7 24 24             	mull   (%esp)
  801c1d:	89 c6                	mov    %eax,%esi
  801c1f:	89 d1                	mov    %edx,%ecx
  801c21:	39 d3                	cmp    %edx,%ebx
  801c23:	0f 82 87 00 00 00    	jb     801cb0 <__umoddi3+0x134>
  801c29:	0f 84 91 00 00 00    	je     801cc0 <__umoddi3+0x144>
  801c2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c33:	29 f2                	sub    %esi,%edx
  801c35:	19 cb                	sbb    %ecx,%ebx
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c3d:	d3 e0                	shl    %cl,%eax
  801c3f:	89 e9                	mov    %ebp,%ecx
  801c41:	d3 ea                	shr    %cl,%edx
  801c43:	09 d0                	or     %edx,%eax
  801c45:	89 e9                	mov    %ebp,%ecx
  801c47:	d3 eb                	shr    %cl,%ebx
  801c49:	89 da                	mov    %ebx,%edx
  801c4b:	83 c4 1c             	add    $0x1c,%esp
  801c4e:	5b                   	pop    %ebx
  801c4f:	5e                   	pop    %esi
  801c50:	5f                   	pop    %edi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    
  801c53:	90                   	nop
  801c54:	89 fd                	mov    %edi,%ebp
  801c56:	85 ff                	test   %edi,%edi
  801c58:	75 0b                	jne    801c65 <__umoddi3+0xe9>
  801c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5f:	31 d2                	xor    %edx,%edx
  801c61:	f7 f7                	div    %edi
  801c63:	89 c5                	mov    %eax,%ebp
  801c65:	89 f0                	mov    %esi,%eax
  801c67:	31 d2                	xor    %edx,%edx
  801c69:	f7 f5                	div    %ebp
  801c6b:	89 c8                	mov    %ecx,%eax
  801c6d:	f7 f5                	div    %ebp
  801c6f:	89 d0                	mov    %edx,%eax
  801c71:	e9 44 ff ff ff       	jmp    801bba <__umoddi3+0x3e>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	89 c8                	mov    %ecx,%eax
  801c7a:	89 f2                	mov    %esi,%edx
  801c7c:	83 c4 1c             	add    $0x1c,%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5f                   	pop    %edi
  801c82:	5d                   	pop    %ebp
  801c83:	c3                   	ret    
  801c84:	3b 04 24             	cmp    (%esp),%eax
  801c87:	72 06                	jb     801c8f <__umoddi3+0x113>
  801c89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c8d:	77 0f                	ja     801c9e <__umoddi3+0x122>
  801c8f:	89 f2                	mov    %esi,%edx
  801c91:	29 f9                	sub    %edi,%ecx
  801c93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c97:	89 14 24             	mov    %edx,(%esp)
  801c9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ca2:	8b 14 24             	mov    (%esp),%edx
  801ca5:	83 c4 1c             	add    $0x1c,%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5f                   	pop    %edi
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    
  801cad:	8d 76 00             	lea    0x0(%esi),%esi
  801cb0:	2b 04 24             	sub    (%esp),%eax
  801cb3:	19 fa                	sbb    %edi,%edx
  801cb5:	89 d1                	mov    %edx,%ecx
  801cb7:	89 c6                	mov    %eax,%esi
  801cb9:	e9 71 ff ff ff       	jmp    801c2f <__umoddi3+0xb3>
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cc4:	72 ea                	jb     801cb0 <__umoddi3+0x134>
  801cc6:	89 d9                	mov    %ebx,%ecx
  801cc8:	e9 62 ff ff ff       	jmp    801c2f <__umoddi3+0xb3>
