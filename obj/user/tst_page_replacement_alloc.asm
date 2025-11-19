
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 3d 01 00 00       	call   800173 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 	//Stack
		} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 80 00       	push   $0x800000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 65 19 00 00       	call   8019b7 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 00 1d 80 00       	push   $0x801d00
  800066:	6a 1c                	push   $0x1c
  800068:	68 74 1d 80 00       	push   $0x801d74
  80006d:	e8 b1 02 00 00       	call   800323 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 7e 15 00 00       	call   8015f5 <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 c1 15 00 00       	call   801640 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800082:	c6 05 9f d0 80 00 61 	movb   $0x61,0x80d09f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800089:	a0 9f e0 80 00       	mov    0x80e09f,%al
  80008e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800091:	a0 9f f0 80 00       	mov    0x80f09f,%al
  800096:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800099:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a0:	eb 4a                	jmp    8000ec <_main+0xb4>
	{
		__arr__[i] = -1 ;
  8000a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a5:	05 a0 30 80 00       	add    $0x8030a0,%eax
  8000aa:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ + garbage5;
  8000ad:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b2:	8a 00                	mov    (%eax),%al
  8000b4:	88 c2                	mov    %al,%dl
  8000b6:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *__ptr2__ + garbage4;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 c2                	mov    %al,%dl
  8000c7:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	88 45 f7             	mov    %al,-0x9(%ebp)
		__ptr__++ ; __ptr2__++ ;
  8000cf:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d4:	40                   	inc    %eax
  8000d5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000da:	a1 04 30 80 00       	mov    0x803004,%eax
  8000df:	40                   	inc    %eax
  8000e0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000e5:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000ec:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000f3:	7e ad                	jle    8000a2 <_main+0x6a>
		__ptr__++ ; __ptr2__++ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	68 98 1d 80 00       	push   $0x801d98
  8000fd:	6a 03                	push   $0x3
  8000ff:	e8 1a 05 00 00       	call   80061e <cprintf_colored>
  800104:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800107:	e8 34 15 00 00       	call   801640 <sys_pf_calculate_allocated_pages>
  80010c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	68 c8 1d 80 00       	push   $0x801dc8
  800119:	6a 3f                	push   $0x3f
  80011b:	68 74 1d 80 00       	push   $0x801d74
  800120:	e8 fe 01 00 00       	call   800323 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800125:	e8 cb 14 00 00       	call   8015f5 <sys_calculate_free_frames>
  80012a:	89 c3                	mov    %eax,%ebx
  80012c:	e8 dd 14 00 00       	call   80160e <sys_calculate_modified_frames>
  800131:	01 d8                	add    %ebx,%eax
  800133:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800139:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80013c:	74 1d                	je     80015b <_main+0x123>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  80013e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800141:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 00                	push   $0x0
  80014a:	68 34 1e 80 00       	push   $0x801e34
  80014f:	6a 43                	push   $0x43
  800151:	68 74 1d 80 00       	push   $0x801d74
  800156:	e8 c8 01 00 00       	call   800323 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [ALLOCATION] is completed successfully\n");
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 b4 1e 80 00       	push   $0x801eb4
  800163:	6a 0a                	push   $0xa
  800165:	e8 b4 04 00 00       	call   80061e <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	return;
  80016d:	90                   	nop
}
  80016e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80017c:	e8 3d 16 00 00       	call   8017be <sys_getenvindex>
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800187:	89 d0                	mov    %edx,%eax
  800189:	c1 e0 02             	shl    $0x2,%eax
  80018c:	01 d0                	add    %edx,%eax
  80018e:	c1 e0 03             	shl    $0x3,%eax
  800191:	01 d0                	add    %edx,%eax
  800193:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80019a:	01 d0                	add    %edx,%eax
  80019c:	c1 e0 02             	shl    $0x2,%eax
  80019f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a4:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a9:	a1 60 30 80 00       	mov    0x803060,%eax
  8001ae:	8a 40 20             	mov    0x20(%eax),%al
  8001b1:	84 c0                	test   %al,%al
  8001b3:	74 0d                	je     8001c2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001b5:	a1 60 30 80 00       	mov    0x803060,%eax
  8001ba:	83 c0 20             	add    $0x20,%eax
  8001bd:	a3 50 30 80 00       	mov    %eax,0x803050

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c6:	7e 0a                	jle    8001d2 <libmain+0x5f>
		binaryname = argv[0];
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	8b 00                	mov    (%eax),%eax
  8001cd:	a3 50 30 80 00       	mov    %eax,0x803050

	// call user main routine
	_main(argc, argv);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	e8 58 fe ff ff       	call   800038 <_main>
  8001e0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e3:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	0f 84 01 01 00 00    	je     8002f1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f6:	bb 00 20 80 00       	mov    $0x802000,%ebx
  8001fb:	ba 0e 00 00 00       	mov    $0xe,%edx
  800200:	89 c7                	mov    %eax,%edi
  800202:	89 de                	mov    %ebx,%esi
  800204:	89 d1                	mov    %edx,%ecx
  800206:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800208:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80020b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800210:	b0 00                	mov    $0x0,%al
  800212:	89 d7                	mov    %edx,%edi
  800214:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800216:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80021d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	50                   	push   %eax
  800224:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80022a:	50                   	push   %eax
  80022b:	e8 c4 17 00 00       	call   8019f4 <sys_utilities>
  800230:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800233:	e8 0d 13 00 00       	call   801545 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	68 20 1f 80 00       	push   $0x801f20
  800240:	e8 ac 03 00 00       	call   8005f1 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800248:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	74 18                	je     800267 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80024f:	e8 be 17 00 00       	call   801a12 <sys_get_optimal_num_faults>
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	50                   	push   %eax
  800258:	68 48 1f 80 00       	push   $0x801f48
  80025d:	e8 8f 03 00 00       	call   8005f1 <cprintf>
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	eb 59                	jmp    8002c0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800267:	a1 60 30 80 00       	mov    0x803060,%eax
  80026c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800272:	a1 60 30 80 00       	mov    0x803060,%eax
  800277:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 6c 1f 80 00       	push   $0x801f6c
  800287:	e8 65 03 00 00       	call   8005f1 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80028f:	a1 60 30 80 00       	mov    0x803060,%eax
  800294:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80029a:	a1 60 30 80 00       	mov    0x803060,%eax
  80029f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002a5:	a1 60 30 80 00       	mov    0x803060,%eax
  8002aa:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002b0:	51                   	push   %ecx
  8002b1:	52                   	push   %edx
  8002b2:	50                   	push   %eax
  8002b3:	68 94 1f 80 00       	push   $0x801f94
  8002b8:	e8 34 03 00 00       	call   8005f1 <cprintf>
  8002bd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c0:	a1 60 30 80 00       	mov    0x803060,%eax
  8002c5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	50                   	push   %eax
  8002cf:	68 ec 1f 80 00       	push   $0x801fec
  8002d4:	e8 18 03 00 00       	call   8005f1 <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	68 20 1f 80 00       	push   $0x801f20
  8002e4:	e8 08 03 00 00       	call   8005f1 <cprintf>
  8002e9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ec:	e8 6e 12 00 00       	call   80155f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f1:	e8 1f 00 00 00       	call   800315 <exit>
}
  8002f6:	90                   	nop
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800305:	83 ec 0c             	sub    $0xc,%esp
  800308:	6a 00                	push   $0x0
  80030a:	e8 7b 14 00 00       	call   80178a <sys_destroy_env>
  80030f:	83 c4 10             	add    $0x10,%esp
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <exit>:

void
exit(void)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031b:	e8 d0 14 00 00       	call   8017f0 <sys_exit_env>
}
  800320:	90                   	nop
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800329:	8d 45 10             	lea    0x10(%ebp),%eax
  80032c:	83 c0 04             	add    $0x4,%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800332:	a1 78 71 82 00       	mov    0x827178,%eax
  800337:	85 c0                	test   %eax,%eax
  800339:	74 16                	je     800351 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033b:	a1 78 71 82 00       	mov    0x827178,%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	68 64 20 80 00       	push   $0x802064
  800349:	e8 a3 02 00 00       	call   8005f1 <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800351:	a1 50 30 80 00       	mov    0x803050,%eax
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 6c 20 80 00       	push   $0x80206c
  800365:	6a 74                	push   $0x74
  800367:	e8 b2 02 00 00       	call   80061e <cprintf_colored>
  80036c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	ff 75 f4             	pushl  -0xc(%ebp)
  800378:	50                   	push   %eax
  800379:	e8 04 02 00 00       	call   800582 <vcprintf>
  80037e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	6a 00                	push   $0x0
  800386:	68 94 20 80 00       	push   $0x802094
  80038b:	e8 f2 01 00 00       	call   800582 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800393:	e8 7d ff ff ff       	call   800315 <exit>

	// should not return here
	while (1) ;
  800398:	eb fe                	jmp    800398 <_panic+0x75>

0080039a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a0:	a1 60 30 80 00       	mov    0x803060,%eax
  8003a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	74 14                	je     8003c6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 98 20 80 00       	push   $0x802098
  8003ba:	6a 26                	push   $0x26
  8003bc:	68 e4 20 80 00       	push   $0x8020e4
  8003c1:	e8 5d ff ff ff       	call   800323 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d4:	e9 c5 00 00 00       	jmp    80049e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	75 08                	jne    8003f6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f1:	e9 a5 00 00 00       	jmp    80049b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800404:	eb 69                	jmp    80046f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800406:	a1 60 30 80 00       	mov    0x803060,%eax
  80040b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	01 c0                	add    %eax,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	c1 e0 03             	shl    $0x3,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8a 40 04             	mov    0x4(%eax),%al
  800422:	84 c0                	test   %al,%al
  800424:	75 46                	jne    80046c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800426:	a1 60 30 80 00       	mov    0x803060,%eax
  80042b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800431:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800434:	89 d0                	mov    %edx,%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	c1 e0 03             	shl    $0x3,%eax
  80043d:	01 c8                	add    %ecx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80044c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	01 c8                	add    %ecx,%eax
  80045d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045f:	39 c2                	cmp    %eax,%edx
  800461:	75 09                	jne    80046c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800463:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80046a:	eb 15                	jmp    800481 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e8             	incl   -0x18(%ebp)
  80046f:	a1 60 30 80 00       	mov    0x803060,%eax
  800474:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80047a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047d:	39 c2                	cmp    %eax,%edx
  80047f:	77 85                	ja     800406 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800485:	75 14                	jne    80049b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 f0 20 80 00       	push   $0x8020f0
  80048f:	6a 3a                	push   $0x3a
  800491:	68 e4 20 80 00       	push   $0x8020e4
  800496:	e8 88 fe ff ff       	call   800323 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80049b:	ff 45 f0             	incl   -0x10(%ebp)
  80049e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a4:	0f 8c 2f ff ff ff    	jl     8003d9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b8:	eb 26                	jmp    8004e0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004ba:	a1 60 30 80 00       	mov    0x803060,%eax
  8004bf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c8:	89 d0                	mov    %edx,%eax
  8004ca:	01 c0                	add    %eax,%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	c1 e0 03             	shl    $0x3,%eax
  8004d1:	01 c8                	add    %ecx,%eax
  8004d3:	8a 40 04             	mov    0x4(%eax),%al
  8004d6:	3c 01                	cmp    $0x1,%al
  8004d8:	75 03                	jne    8004dd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004da:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004dd:	ff 45 e0             	incl   -0x20(%ebp)
  8004e0:	a1 60 30 80 00       	mov    0x803060,%eax
  8004e5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ee:	39 c2                	cmp    %eax,%edx
  8004f0:	77 c8                	ja     8004ba <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004f8:	74 14                	je     80050e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	68 44 21 80 00       	push   $0x802144
  800502:	6a 44                	push   $0x44
  800504:	68 e4 20 80 00       	push   $0x8020e4
  800509:	e8 15 fe ff ff       	call   800323 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80050e:	90                   	nop
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	53                   	push   %ebx
  800515:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 48 01             	lea    0x1(%eax),%ecx
  800520:	8b 55 0c             	mov    0xc(%ebp),%edx
  800523:	89 0a                	mov    %ecx,(%edx)
  800525:	8b 55 08             	mov    0x8(%ebp),%edx
  800528:	88 d1                	mov    %dl,%cl
  80052a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800531:	8b 45 0c             	mov    0xc(%ebp),%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053b:	75 30                	jne    80056d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80053d:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  800543:	a0 84 30 80 00       	mov    0x803084,%al
  800548:	0f b6 c0             	movzbl %al,%eax
  80054b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054e:	8b 09                	mov    (%ecx),%ecx
  800550:	89 cb                	mov    %ecx,%ebx
  800552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800555:	83 c1 08             	add    $0x8,%ecx
  800558:	52                   	push   %edx
  800559:	50                   	push   %eax
  80055a:	53                   	push   %ebx
  80055b:	51                   	push   %ecx
  80055c:	e8 a0 0f 00 00       	call   801501 <sys_cputs>
  800561:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 40 04             	mov    0x4(%eax),%eax
  800573:	8d 50 01             	lea    0x1(%eax),%edx
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057c:	90                   	nop
  80057d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80058b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800592:	00 00 00 
	b.cnt = 0;
  800595:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80059c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059f:	ff 75 0c             	pushl  0xc(%ebp)
  8005a2:	ff 75 08             	pushl  0x8(%ebp)
  8005a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ab:	50                   	push   %eax
  8005ac:	68 11 05 80 00       	push   $0x800511
  8005b1:	e8 5a 02 00 00       	call   800810 <vprintfmt>
  8005b6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005b9:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  8005bf:	a0 84 30 80 00       	mov    0x803084,%al
  8005c4:	0f b6 c0             	movzbl %al,%eax
  8005c7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005cd:	52                   	push   %edx
  8005ce:	50                   	push   %eax
  8005cf:	51                   	push   %ecx
  8005d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d6:	83 c0 08             	add    $0x8,%eax
  8005d9:	50                   	push   %eax
  8005da:	e8 22 0f 00 00       	call   801501 <sys_cputs>
  8005df:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005e2:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  8005e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ef:	c9                   	leave  
  8005f0:	c3                   	ret    

008005f1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f7:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  8005fe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800601:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 f4             	pushl  -0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 6f ff ff ff       	call   800582 <vcprintf>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	c1 e0 08             	shl    $0x8,%eax
  800631:	a3 7c 71 82 00       	mov    %eax,0x82717c
	va_start(ap, fmt);
  800636:	8d 45 0c             	lea    0xc(%ebp),%eax
  800639:	83 c0 04             	add    $0x4,%eax
  80063c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 f4             	pushl  -0xc(%ebp)
  800648:	50                   	push   %eax
  800649:	e8 34 ff ff ff       	call   800582 <vcprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800654:	c7 05 7c 71 82 00 00 	movl   $0x700,0x82717c
  80065b:	07 00 00 

	return cnt;
  80065e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800661:	c9                   	leave  
  800662:	c3                   	ret    

00800663 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800663:	55                   	push   %ebp
  800664:	89 e5                	mov    %esp,%ebp
  800666:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800669:	e8 d7 0e 00 00       	call   801545 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80066e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800671:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	ff 75 f4             	pushl  -0xc(%ebp)
  80067d:	50                   	push   %eax
  80067e:	e8 ff fe ff ff       	call   800582 <vcprintf>
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800689:	e8 d1 0e 00 00       	call   80155f <sys_unlock_cons>
	return cnt;
  80068e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800691:	c9                   	leave  
  800692:	c3                   	ret    

00800693 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800693:	55                   	push   %ebp
  800694:	89 e5                	mov    %esp,%ebp
  800696:	53                   	push   %ebx
  800697:	83 ec 14             	sub    $0x14,%esp
  80069a:	8b 45 10             	mov    0x10(%ebp),%eax
  80069d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b1:	77 55                	ja     800708 <printnum+0x75>
  8006b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b6:	72 05                	jb     8006bd <printnum+0x2a>
  8006b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006bb:	77 4b                	ja     800708 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	52                   	push   %edx
  8006cc:	50                   	push   %eax
  8006cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8006d3:	e8 a8 13 00 00       	call   801a80 <__udivdi3>
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	ff 75 20             	pushl  0x20(%ebp)
  8006e1:	53                   	push   %ebx
  8006e2:	ff 75 18             	pushl  0x18(%ebp)
  8006e5:	52                   	push   %edx
  8006e6:	50                   	push   %eax
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	ff 75 08             	pushl  0x8(%ebp)
  8006ed:	e8 a1 ff ff ff       	call   800693 <printnum>
  8006f2:	83 c4 20             	add    $0x20,%esp
  8006f5:	eb 1a                	jmp    800711 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	ff 75 20             	pushl  0x20(%ebp)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800708:	ff 4d 1c             	decl   0x1c(%ebp)
  80070b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070f:	7f e6                	jg     8006f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800711:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800714:	bb 00 00 00 00       	mov    $0x0,%ebx
  800719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071f:	53                   	push   %ebx
  800720:	51                   	push   %ecx
  800721:	52                   	push   %edx
  800722:	50                   	push   %eax
  800723:	e8 68 14 00 00       	call   801b90 <__umoddi3>
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	05 b4 23 80 00       	add    $0x8023b4,%eax
  800730:	8a 00                	mov    (%eax),%al
  800732:	0f be c0             	movsbl %al,%eax
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	50                   	push   %eax
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	ff d0                	call   *%eax
  800741:	83 c4 10             	add    $0x10,%esp
}
  800744:	90                   	nop
  800745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800751:	7e 1c                	jle    80076f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	8d 50 08             	lea    0x8(%eax),%edx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 10                	mov    %edx,(%eax)
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	83 e8 08             	sub    $0x8,%eax
  800768:	8b 50 04             	mov    0x4(%eax),%edx
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	eb 40                	jmp    8007af <getuint+0x65>
	else if (lflag)
  80076f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800773:	74 1e                	je     800793 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	8d 50 04             	lea    0x4(%eax),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	89 10                	mov    %edx,(%eax)
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 e8 04             	sub    $0x4,%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	ba 00 00 00 00       	mov    $0x0,%edx
  800791:	eb 1c                	jmp    8007af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	8d 50 04             	lea    0x4(%eax),%edx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	89 10                	mov    %edx,(%eax)
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	83 e8 04             	sub    $0x4,%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007af:	5d                   	pop    %ebp
  8007b0:	c3                   	ret    

008007b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b8:	7e 1c                	jle    8007d6 <getint+0x25>
		return va_arg(*ap, long long);
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	8d 50 08             	lea    0x8(%eax),%edx
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	89 10                	mov    %edx,(%eax)
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	83 e8 08             	sub    $0x8,%eax
  8007cf:	8b 50 04             	mov    0x4(%eax),%edx
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	eb 38                	jmp    80080e <getint+0x5d>
	else if (lflag)
  8007d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007da:	74 1a                	je     8007f6 <getint+0x45>
		return va_arg(*ap, long);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	8d 50 04             	lea    0x4(%eax),%edx
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	89 10                	mov    %edx,(%eax)
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	83 e8 04             	sub    $0x4,%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	99                   	cltd   
  8007f4:	eb 18                	jmp    80080e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	8d 50 04             	lea    0x4(%eax),%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	89 10                	mov    %edx,(%eax)
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 e8 04             	sub    $0x4,%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	99                   	cltd   
}
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	56                   	push   %esi
  800814:	53                   	push   %ebx
  800815:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800818:	eb 17                	jmp    800831 <vprintfmt+0x21>
			if (ch == '\0')
  80081a:	85 db                	test   %ebx,%ebx
  80081c:	0f 84 c1 03 00 00    	je     800be3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	53                   	push   %ebx
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800831:	8b 45 10             	mov    0x10(%ebp),%eax
  800834:	8d 50 01             	lea    0x1(%eax),%edx
  800837:	89 55 10             	mov    %edx,0x10(%ebp)
  80083a:	8a 00                	mov    (%eax),%al
  80083c:	0f b6 d8             	movzbl %al,%ebx
  80083f:	83 fb 25             	cmp    $0x25,%ebx
  800842:	75 d6                	jne    80081a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800844:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800848:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800856:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80085d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800864:	8b 45 10             	mov    0x10(%ebp),%eax
  800867:	8d 50 01             	lea    0x1(%eax),%edx
  80086a:	89 55 10             	mov    %edx,0x10(%ebp)
  80086d:	8a 00                	mov    (%eax),%al
  80086f:	0f b6 d8             	movzbl %al,%ebx
  800872:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800875:	83 f8 5b             	cmp    $0x5b,%eax
  800878:	0f 87 3d 03 00 00    	ja     800bbb <vprintfmt+0x3ab>
  80087e:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  800885:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800887:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80088b:	eb d7                	jmp    800864 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80088d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800891:	eb d1                	jmp    800864 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800893:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80089a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089d:	89 d0                	mov    %edx,%eax
  80089f:	c1 e0 02             	shl    $0x2,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	01 c0                	add    %eax,%eax
  8008a6:	01 d8                	add    %ebx,%eax
  8008a8:	83 e8 30             	sub    $0x30,%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	8a 00                	mov    (%eax),%al
  8008b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b9:	7e 3e                	jle    8008f9 <vprintfmt+0xe9>
  8008bb:	83 fb 39             	cmp    $0x39,%ebx
  8008be:	7f 39                	jg     8008f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008c3:	eb d5                	jmp    80089a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 c0 04             	add    $0x4,%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 e8 04             	sub    $0x4,%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d9:	eb 1f                	jmp    8008fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008df:	79 83                	jns    800864 <vprintfmt+0x54>
				width = 0;
  8008e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e8:	e9 77 ff ff ff       	jmp    800864 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f4:	e9 6b ff ff ff       	jmp    800864 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fe:	0f 89 60 ff ff ff    	jns    800864 <vprintfmt+0x54>
				width = precision, precision = -1;
  800904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800911:	e9 4e ff ff ff       	jmp    800864 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800916:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800919:	e9 46 ff ff ff       	jmp    800864 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	83 c0 04             	add    $0x4,%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	83 e8 04             	sub    $0x4,%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	50                   	push   %eax
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			break;
  80093e:	e9 9b 02 00 00       	jmp    800bde <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800954:	85 db                	test   %ebx,%ebx
  800956:	79 02                	jns    80095a <vprintfmt+0x14a>
				err = -err;
  800958:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80095a:	83 fb 64             	cmp    $0x64,%ebx
  80095d:	7f 0b                	jg     80096a <vprintfmt+0x15a>
  80095f:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  800966:	85 f6                	test   %esi,%esi
  800968:	75 19                	jne    800983 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80096a:	53                   	push   %ebx
  80096b:	68 c5 23 80 00       	push   $0x8023c5
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 70 02 00 00       	call   800beb <printfmt>
  80097b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097e:	e9 5b 02 00 00       	jmp    800bde <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800983:	56                   	push   %esi
  800984:	68 ce 23 80 00       	push   $0x8023ce
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	ff 75 08             	pushl  0x8(%ebp)
  80098f:	e8 57 02 00 00       	call   800beb <printfmt>
  800994:	83 c4 10             	add    $0x10,%esp
			break;
  800997:	e9 42 02 00 00       	jmp    800bde <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 c0 04             	add    $0x4,%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 30                	mov    (%eax),%esi
  8009ad:	85 f6                	test   %esi,%esi
  8009af:	75 05                	jne    8009b6 <vprintfmt+0x1a6>
				p = "(null)";
  8009b1:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  8009b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ba:	7e 6d                	jle    800a29 <vprintfmt+0x219>
  8009bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009c0:	74 67                	je     800a29 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	50                   	push   %eax
  8009c9:	56                   	push   %esi
  8009ca:	e8 1e 03 00 00       	call   800ced <strnlen>
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d5:	eb 16                	jmp    8009ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	50                   	push   %eax
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f1:	7f e4                	jg     8009d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f3:	eb 34                	jmp    800a29 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f9:	74 1c                	je     800a17 <vprintfmt+0x207>
  8009fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fe:	7e 05                	jle    800a05 <vprintfmt+0x1f5>
  800a00:	83 fb 7e             	cmp    $0x7e,%ebx
  800a03:	7e 12                	jle    800a17 <vprintfmt+0x207>
					putch('?', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 3f                	push   $0x3f
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	eb 0f                	jmp    800a26 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a26:	ff 4d e4             	decl   -0x1c(%ebp)
  800a29:	89 f0                	mov    %esi,%eax
  800a2b:	8d 70 01             	lea    0x1(%eax),%esi
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	0f be d8             	movsbl %al,%ebx
  800a33:	85 db                	test   %ebx,%ebx
  800a35:	74 24                	je     800a5b <vprintfmt+0x24b>
  800a37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3b:	78 b8                	js     8009f5 <vprintfmt+0x1e5>
  800a3d:	ff 4d e0             	decl   -0x20(%ebp)
  800a40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a44:	79 af                	jns    8009f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a46:	eb 13                	jmp    800a5b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 20                	push   $0x20
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a58:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5f:	7f e7                	jg     800a48 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a61:	e9 78 01 00 00       	jmp    800bde <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6f:	50                   	push   %eax
  800a70:	e8 3c fd ff ff       	call   8007b1 <getint>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a84:	85 d2                	test   %edx,%edx
  800a86:	79 23                	jns    800aab <vprintfmt+0x29b>
				putch('-', putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	6a 2d                	push   $0x2d
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9e:	f7 d8                	neg    %eax
  800aa0:	83 d2 00             	adc    $0x0,%edx
  800aa3:	f7 da                	neg    %edx
  800aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab2:	e9 bc 00 00 00       	jmp    800b73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 e8             	pushl  -0x18(%ebp)
  800abd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac0:	50                   	push   %eax
  800ac1:	e8 84 fc ff ff       	call   80074a <getuint>
  800ac6:	83 c4 10             	add    $0x10,%esp
  800ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad6:	e9 98 00 00 00       	jmp    800b73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	6a 58                	push   $0x58
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	ff d0                	call   *%eax
  800ae8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	6a 58                	push   $0x58
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	6a 58                	push   $0x58
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
			break;
  800b0b:	e9 ce 00 00 00       	jmp    800bde <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 30                	push   $0x30
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	6a 78                	push   $0x78
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 c0 04             	add    $0x4,%eax
  800b36:	89 45 14             	mov    %eax,0x14(%ebp)
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	83 e8 04             	sub    $0x4,%eax
  800b3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b52:	eb 1f                	jmp    800b73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 e8             	pushl  -0x18(%ebp)
  800b5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5d:	50                   	push   %eax
  800b5e:	e8 e7 fb ff ff       	call   80074a <getuint>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7a:	83 ec 04             	sub    $0x4,%esp
  800b7d:	52                   	push   %edx
  800b7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	ff 75 f0             	pushl  -0x10(%ebp)
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	ff 75 08             	pushl  0x8(%ebp)
  800b8e:	e8 00 fb ff ff       	call   800693 <printnum>
  800b93:	83 c4 20             	add    $0x20,%esp
			break;
  800b96:	eb 46                	jmp    800bde <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	53                   	push   %ebx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	ff d0                	call   *%eax
  800ba4:	83 c4 10             	add    $0x10,%esp
			break;
  800ba7:	eb 35                	jmp    800bde <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ba9:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800bb0:	eb 2c                	jmp    800bde <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bb2:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800bb9:	eb 23                	jmp    800bde <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	6a 25                	push   $0x25
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bcb:	ff 4d 10             	decl   0x10(%ebp)
  800bce:	eb 03                	jmp    800bd3 <vprintfmt+0x3c3>
  800bd0:	ff 4d 10             	decl   0x10(%ebp)
  800bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd6:	48                   	dec    %eax
  800bd7:	8a 00                	mov    (%eax),%al
  800bd9:	3c 25                	cmp    $0x25,%al
  800bdb:	75 f3                	jne    800bd0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bdd:	90                   	nop
		}
	}
  800bde:	e9 35 fc ff ff       	jmp    800818 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800be3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bf1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf4:	83 c0 04             	add    $0x4,%eax
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800c00:	50                   	push   %eax
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	ff 75 08             	pushl  0x8(%ebp)
  800c07:	e8 04 fc ff ff       	call   800810 <vprintfmt>
  800c0c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0f:	90                   	nop
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8b 40 08             	mov    0x8(%eax),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8b 10                	mov    (%eax),%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8b 40 04             	mov    0x4(%eax),%eax
  800c2f:	39 c2                	cmp    %eax,%edx
  800c31:	73 12                	jae    800c45 <sprintputch+0x33>
		*b->buf++ = ch;
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	8d 48 01             	lea    0x1(%eax),%ecx
  800c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3e:	89 0a                	mov    %ecx,(%edx)
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	88 10                	mov    %dl,(%eax)
}
  800c45:	90                   	nop
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c6d:	74 06                	je     800c75 <vsnprintf+0x2d>
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	7f 07                	jg     800c7c <vsnprintf+0x34>
		return -E_INVAL;
  800c75:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7a:	eb 20                	jmp    800c9c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7c:	ff 75 14             	pushl  0x14(%ebp)
  800c7f:	ff 75 10             	pushl  0x10(%ebp)
  800c82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c85:	50                   	push   %eax
  800c86:	68 12 0c 80 00       	push   $0x800c12
  800c8b:	e8 80 fb ff ff       	call   800810 <vprintfmt>
  800c90:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c96:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca7:	83 c0 04             	add    $0x4,%eax
  800caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cad:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb3:	50                   	push   %eax
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	ff 75 08             	pushl  0x8(%ebp)
  800cba:	e8 89 ff ff ff       	call   800c48 <vsnprintf>
  800cbf:	83 c4 10             	add    $0x10,%esp
  800cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd7:	eb 06                	jmp    800cdf <strlen+0x15>
		n++;
  800cd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	75 f1                	jne    800cd9 <strlen+0xf>
		n++;
	return n;
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfa:	eb 09                	jmp    800d05 <strnlen+0x18>
		n++;
  800cfc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cff:	ff 45 08             	incl   0x8(%ebp)
  800d02:	ff 4d 0c             	decl   0xc(%ebp)
  800d05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d09:	74 09                	je     800d14 <strnlen+0x27>
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	75 e8                	jne    800cfc <strnlen+0xf>
		n++;
	return n;
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d25:	90                   	nop
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d38:	8a 12                	mov    (%edx),%dl
  800d3a:	88 10                	mov    %dl,(%eax)
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	84 c0                	test   %al,%al
  800d40:	75 e4                	jne    800d26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 1f                	jmp    800d7b <strncpy+0x34>
		*dst++ = *src;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8d 50 01             	lea    0x1(%eax),%edx
  800d62:	89 55 08             	mov    %edx,0x8(%ebp)
  800d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d68:	8a 12                	mov    (%edx),%dl
  800d6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	74 03                	je     800d78 <strncpy+0x31>
			src++;
  800d75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d78:	ff 45 fc             	incl   -0x4(%ebp)
  800d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d81:	72 d9                	jb     800d5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d98:	74 30                	je     800dca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d9a:	eb 16                	jmp    800db2 <strlcpy+0x2a>
			*dst++ = *src++;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	89 55 08             	mov    %edx,0x8(%ebp)
  800da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dae:	8a 12                	mov    (%edx),%dl
  800db0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db2:	ff 4d 10             	decl   0x10(%ebp)
  800db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db9:	74 09                	je     800dc4 <strlcpy+0x3c>
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	75 d8                	jne    800d9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd0:	29 c2                	sub    %eax,%edx
  800dd2:	89 d0                	mov    %edx,%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd9:	eb 06                	jmp    800de1 <strcmp+0xb>
		p++, q++;
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	74 0e                	je     800df8 <strcmp+0x22>
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 10                	mov    (%eax),%dl
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	38 c2                	cmp    %al,%dl
  800df6:	74 e3                	je     800ddb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	0f b6 d0             	movzbl %al,%edx
  800e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	0f b6 c0             	movzbl %al,%eax
  800e08:	29 c2                	sub    %eax,%edx
  800e0a:	89 d0                	mov    %edx,%eax
}
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e11:	eb 09                	jmp    800e1c <strncmp+0xe>
		n--, p++, q++;
  800e13:	ff 4d 10             	decl   0x10(%ebp)
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e20:	74 17                	je     800e39 <strncmp+0x2b>
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	84 c0                	test   %al,%al
  800e29:	74 0e                	je     800e39 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 10                	mov    (%eax),%dl
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	38 c2                	cmp    %al,%dl
  800e37:	74 da                	je     800e13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3d:	75 07                	jne    800e46 <strncmp+0x38>
		return 0;
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	eb 14                	jmp    800e5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	0f b6 d0             	movzbl %al,%edx
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 c0             	movzbl %al,%eax
  800e56:	29 c2                	sub    %eax,%edx
  800e58:	89 d0                	mov    %edx,%eax
}
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 04             	sub    $0x4,%esp
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e68:	eb 12                	jmp    800e7c <strchr+0x20>
		if (*s == c)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e72:	75 05                	jne    800e79 <strchr+0x1d>
			return (char *) s;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	eb 11                	jmp    800e8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	84 c0                	test   %al,%al
  800e83:	75 e5                	jne    800e6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e98:	eb 0d                	jmp    800ea7 <strfind+0x1b>
		if (*s == c)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ea2:	74 0e                	je     800eb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea4:	ff 45 08             	incl   0x8(%ebp)
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	84 c0                	test   %al,%al
  800eae:	75 ea                	jne    800e9a <strfind+0xe>
  800eb0:	eb 01                	jmp    800eb3 <strfind+0x27>
		if (*s == c)
			break;
  800eb2:	90                   	nop
	return (char *) s;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ec4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec8:	76 63                	jbe    800f2d <memset+0x75>
		uint64 data_block = c;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	99                   	cltd   
  800ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eda:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ede:	c1 e0 08             	shl    $0x8,%eax
  800ee1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eed:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ef1:	c1 e0 10             	shl    $0x10,%eax
  800ef4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f00:	89 c2                	mov    %eax,%edx
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
  800f07:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f0a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f0d:	eb 18                	jmp    800f27 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f0f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f12:	8d 41 08             	lea    0x8(%ecx),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	89 01                	mov    %eax,(%ecx)
  800f20:	89 51 04             	mov    %edx,0x4(%ecx)
  800f23:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f27:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2b:	77 e2                	ja     800f0f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f31:	74 23                	je     800f56 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f36:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f39:	eb 0e                	jmp    800f49 <memset+0x91>
			*p8++ = (uint8)c;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f47:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f49:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	75 e5                	jne    800f3b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f6d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f71:	76 24                	jbe    800f97 <memcpy+0x3c>
		while(n >= 8){
  800f73:	eb 1c                	jmp    800f91 <memcpy+0x36>
			*d64 = *s64;
  800f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f78:	8b 50 04             	mov    0x4(%eax),%edx
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f80:	89 01                	mov    %eax,(%ecx)
  800f82:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f85:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f89:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f8d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f91:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f95:	77 de                	ja     800f75 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	74 31                	je     800fce <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fa9:	eb 16                	jmp    800fc1 <memcpy+0x66>
			*d8++ = *s8++;
  800fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fae:	8d 50 01             	lea    0x1(%eax),%edx
  800fb1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fba:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fbd:	8a 12                	mov    (%edx),%dl
  800fbf:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	75 dd                	jne    800fab <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800feb:	73 50                	jae    80103d <memmove+0x6a>
  800fed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff8:	76 43                	jbe    80103d <memmove+0x6a>
		s += n;
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801006:	eb 10                	jmp    801018 <memmove+0x45>
			*--d = *--s;
  801008:	ff 4d f8             	decl   -0x8(%ebp)
  80100b:	ff 4d fc             	decl   -0x4(%ebp)
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8a 10                	mov    (%eax),%dl
  801013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801016:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	89 55 10             	mov    %edx,0x10(%ebp)
  801021:	85 c0                	test   %eax,%eax
  801023:	75 e3                	jne    801008 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801025:	eb 23                	jmp    80104a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	8d 50 01             	lea    0x1(%eax),%edx
  80102d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801030:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801033:	8d 4a 01             	lea    0x1(%edx),%ecx
  801036:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801039:	8a 12                	mov    (%edx),%dl
  80103b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	8d 50 ff             	lea    -0x1(%eax),%edx
  801043:	89 55 10             	mov    %edx,0x10(%ebp)
  801046:	85 c0                	test   %eax,%eax
  801048:	75 dd                	jne    801027 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801061:	eb 2a                	jmp    80108d <memcmp+0x3e>
		if (*s1 != *s2)
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	8a 10                	mov    (%eax),%dl
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	38 c2                	cmp    %al,%dl
  80106f:	74 16                	je     801087 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	0f b6 d0             	movzbl %al,%edx
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 c0             	movzbl %al,%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	eb 18                	jmp    80109f <memcmp+0x50>
		s1++, s2++;
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	8d 50 ff             	lea    -0x1(%eax),%edx
  801093:	89 55 10             	mov    %edx,0x10(%ebp)
  801096:	85 c0                	test   %eax,%eax
  801098:	75 c9                	jne    801063 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010b2:	eb 15                	jmp    8010c9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f b6 d0             	movzbl %al,%edx
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	0f b6 c0             	movzbl %al,%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	74 0d                	je     8010d3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010cf:	72 e3                	jb     8010b4 <memfind+0x13>
  8010d1:	eb 01                	jmp    8010d4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010d3:	90                   	nop
	return (void *) s;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ed:	eb 03                	jmp    8010f2 <strtol+0x19>
		s++;
  8010ef:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 20                	cmp    $0x20,%al
  8010f9:	74 f4                	je     8010ef <strtol+0x16>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 09                	cmp    $0x9,%al
  801102:	74 eb                	je     8010ef <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 2b                	cmp    $0x2b,%al
  80110b:	75 05                	jne    801112 <strtol+0x39>
		s++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
  801110:	eb 13                	jmp    801125 <strtol+0x4c>
	else if (*s == '-')
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	3c 2d                	cmp    $0x2d,%al
  801119:	75 0a                	jne    801125 <strtol+0x4c>
		s++, neg = 1;
  80111b:	ff 45 08             	incl   0x8(%ebp)
  80111e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	74 06                	je     801131 <strtol+0x58>
  80112b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80112f:	75 20                	jne    801151 <strtol+0x78>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 30                	cmp    $0x30,%al
  801138:	75 17                	jne    801151 <strtol+0x78>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	40                   	inc    %eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 78                	cmp    $0x78,%al
  801142:	75 0d                	jne    801151 <strtol+0x78>
		s += 2, base = 16;
  801144:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801148:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80114f:	eb 28                	jmp    801179 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801155:	75 15                	jne    80116c <strtol+0x93>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 30                	cmp    $0x30,%al
  80115e:	75 0c                	jne    80116c <strtol+0x93>
		s++, base = 8;
  801160:	ff 45 08             	incl   0x8(%ebp)
  801163:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80116a:	eb 0d                	jmp    801179 <strtol+0xa0>
	else if (base == 0)
  80116c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801170:	75 07                	jne    801179 <strtol+0xa0>
		base = 10;
  801172:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 2f                	cmp    $0x2f,%al
  801180:	7e 19                	jle    80119b <strtol+0xc2>
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 39                	cmp    $0x39,%al
  801189:	7f 10                	jg     80119b <strtol+0xc2>
			dig = *s - '0';
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f be c0             	movsbl %al,%eax
  801193:	83 e8 30             	sub    $0x30,%eax
  801196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801199:	eb 42                	jmp    8011dd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	3c 60                	cmp    $0x60,%al
  8011a2:	7e 19                	jle    8011bd <strtol+0xe4>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 7a                	cmp    $0x7a,%al
  8011ab:	7f 10                	jg     8011bd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	0f be c0             	movsbl %al,%eax
  8011b5:	83 e8 57             	sub    $0x57,%eax
  8011b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bb:	eb 20                	jmp    8011dd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3c 40                	cmp    $0x40,%al
  8011c4:	7e 39                	jle    8011ff <strtol+0x126>
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 5a                	cmp    $0x5a,%al
  8011cd:	7f 30                	jg     8011ff <strtol+0x126>
			dig = *s - 'A' + 10;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f be c0             	movsbl %al,%eax
  8011d7:	83 e8 37             	sub    $0x37,%eax
  8011da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e3:	7d 19                	jge    8011fe <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011e5:	ff 45 08             	incl   0x8(%ebp)
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011eb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f9:	e9 7b ff ff ff       	jmp    801179 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011fe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801203:	74 08                	je     80120d <strtol+0x134>
		*endptr = (char *) s;
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
  80120b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80120d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801211:	74 07                	je     80121a <strtol+0x141>
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	f7 d8                	neg    %eax
  801218:	eb 03                	jmp    80121d <strtol+0x144>
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <ltostr>:

void
ltostr(long value, char *str)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80122c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801237:	79 13                	jns    80124c <ltostr+0x2d>
	{
		neg = 1;
  801239:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801246:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801249:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801254:	99                   	cltd   
  801255:	f7 f9                	idiv   %ecx
  801257:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80125a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125d:	8d 50 01             	lea    0x1(%eax),%edx
  801260:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801263:	89 c2                	mov    %eax,%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126d:	83 c2 30             	add    $0x30,%edx
  801270:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801275:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80127a:	f7 e9                	imul   %ecx
  80127c:	c1 fa 02             	sar    $0x2,%edx
  80127f:	89 c8                	mov    %ecx,%eax
  801281:	c1 f8 1f             	sar    $0x1f,%eax
  801284:	29 c2                	sub    %eax,%edx
  801286:	89 d0                	mov    %edx,%eax
  801288:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80128b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128f:	75 bb                	jne    80124c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801291:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129b:	48                   	dec    %eax
  80129c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80129f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a3:	74 3d                	je     8012e2 <ltostr+0xc3>
		start = 1 ;
  8012a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ac:	eb 34                	jmp    8012e2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	01 d0                	add    %edx,%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 c2                	add    %eax,%edx
  8012d7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012da:	88 02                	mov    %al,(%edx)
		start++ ;
  8012dc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012df:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e8:	7c c4                	jl     8012ae <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012f5:	90                   	nop
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	e8 c4 f9 ff ff       	call   800cca <strlen>
  801306:	83 c4 04             	add    $0x4,%esp
  801309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80130c:	ff 75 0c             	pushl  0xc(%ebp)
  80130f:	e8 b6 f9 ff ff       	call   800cca <strlen>
  801314:	83 c4 04             	add    $0x4,%esp
  801317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80131a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801328:	eb 17                	jmp    801341 <strcconcat+0x49>
		final[s] = str1[s] ;
  80132a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	01 c8                	add    %ecx,%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80133e:	ff 45 fc             	incl   -0x4(%ebp)
  801341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801344:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801347:	7c e1                	jl     80132a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801350:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801357:	eb 1f                	jmp    801378 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135c:	8d 50 01             	lea    0x1(%eax),%edx
  80135f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801362:	89 c2                	mov    %eax,%edx
  801364:	8b 45 10             	mov    0x10(%ebp),%eax
  801367:	01 c2                	add    %eax,%edx
  801369:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 c8                	add    %ecx,%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801375:	ff 45 f8             	incl   -0x8(%ebp)
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137e:	7c d9                	jl     801359 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801380:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c6 00 00             	movb   $0x0,(%eax)
}
  80138b:	90                   	nop
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b1:	eb 0c                	jmp    8013bf <strsplit+0x31>
			*string++ = 0;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8d 50 01             	lea    0x1(%eax),%edx
  8013b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013bc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	84 c0                	test   %al,%al
  8013c6:	74 18                	je     8013e0 <strsplit+0x52>
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	0f be c0             	movsbl %al,%eax
  8013d0:	50                   	push   %eax
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	e8 83 fa ff ff       	call   800e5c <strchr>
  8013d9:	83 c4 08             	add    $0x8,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	75 d3                	jne    8013b3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 5a                	je     801443 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 f8 0f             	cmp    $0xf,%eax
  8013f1:	75 07                	jne    8013fa <strsplit+0x6c>
		{
			return 0;
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	eb 66                	jmp    801460 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	8d 48 01             	lea    0x1(%eax),%ecx
  801402:	8b 55 14             	mov    0x14(%ebp),%edx
  801405:	89 0a                	mov    %ecx,(%edx)
  801407:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801418:	eb 03                	jmp    80141d <strsplit+0x8f>
			string++;
  80141a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	84 c0                	test   %al,%al
  801424:	74 8b                	je     8013b1 <strsplit+0x23>
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	0f be c0             	movsbl %al,%eax
  80142e:	50                   	push   %eax
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	e8 25 fa ff ff       	call   800e5c <strchr>
  801437:	83 c4 08             	add    $0x8,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 dc                	je     80141a <strsplit+0x8c>
			string++;
	}
  80143e:	e9 6e ff ff ff       	jmp    8013b1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801443:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801444:	8b 45 14             	mov    0x14(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801450:	8b 45 10             	mov    0x10(%ebp),%eax
  801453:	01 d0                	add    %edx,%eax
  801455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80145b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80146e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801475:	eb 4a                	jmp    8014c1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801477:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	01 c2                	add    %eax,%edx
  80147f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 c8                	add    %ecx,%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80148b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801491:	01 d0                	add    %edx,%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	3c 40                	cmp    $0x40,%al
  801497:	7e 25                	jle    8014be <str2lower+0x5c>
  801499:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	01 d0                	add    %edx,%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	3c 5a                	cmp    $0x5a,%al
  8014a5:	7f 17                	jg     8014be <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	01 d0                	add    %edx,%eax
  8014af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b5:	01 ca                	add    %ecx,%edx
  8014b7:	8a 12                	mov    (%edx),%dl
  8014b9:	83 c2 20             	add    $0x20,%edx
  8014bc:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014be:	ff 45 fc             	incl   -0x4(%ebp)
  8014c1:	ff 75 0c             	pushl  0xc(%ebp)
  8014c4:	e8 01 f8 ff ff       	call   800cca <strlen>
  8014c9:	83 c4 04             	add    $0x4,%esp
  8014cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014cf:	7f a6                	jg     801477 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	57                   	push   %edi
  8014da:	56                   	push   %esi
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014eb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014f1:	cd 30                	int    $0x30
  8014f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	5b                   	pop    %ebx
  8014fd:	5e                   	pop    %esi
  8014fe:	5f                   	pop    %edi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80150d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801510:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	51                   	push   %ecx
  80151a:	52                   	push   %edx
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	50                   	push   %eax
  80151f:	6a 00                	push   $0x0
  801521:	e8 b0 ff ff ff       	call   8014d6 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_cgetc>:

int
sys_cgetc(void)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 02                	push   $0x2
  80153b:	e8 96 ff ff ff       	call   8014d6 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 03                	push   $0x3
  801554:	e8 7d ff ff ff       	call   8014d6 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 04                	push   $0x4
  80156e:	e8 63 ff ff ff       	call   8014d6 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	90                   	nop
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	6a 08                	push   $0x8
  80158c:	e8 45 ff ff ff       	call   8014d6 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80159b:	8b 75 18             	mov    0x18(%ebp),%esi
  80159e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	56                   	push   %esi
  8015ab:	53                   	push   %ebx
  8015ac:	51                   	push   %ecx
  8015ad:	52                   	push   %edx
  8015ae:	50                   	push   %eax
  8015af:	6a 09                	push   $0x9
  8015b1:	e8 20 ff ff ff       	call   8014d6 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    

008015c0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	6a 0a                	push   $0xa
  8015d0:	e8 01 ff ff ff       	call   8014d6 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	6a 0b                	push   $0xb
  8015eb:	e8 e6 fe ff ff       	call   8014d6 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 0c                	push   $0xc
  801604:	e8 cd fe ff ff       	call   8014d6 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 0d                	push   $0xd
  80161d:	e8 b4 fe ff ff       	call   8014d6 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 0e                	push   $0xe
  801636:	e8 9b fe ff ff       	call   8014d6 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 0f                	push   $0xf
  80164f:	e8 82 fe ff ff       	call   8014d6 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 10                	push   $0x10
  801669:	e8 68 fe ff ff       	call   8014d6 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 11                	push   $0x11
  801682:	e8 4f fe ff ff       	call   8014d6 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	90                   	nop
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_cputc>:

void
sys_cputc(const char c)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801699:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	50                   	push   %eax
  8016a6:	6a 01                	push   $0x1
  8016a8:	e8 29 fe ff ff       	call   8014d6 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	90                   	nop
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 14                	push   $0x14
  8016c2:	e8 0f fe ff ff       	call   8014d6 <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	90                   	nop
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	51                   	push   %ecx
  8016e6:	52                   	push   %edx
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	50                   	push   %eax
  8016eb:	6a 15                	push   $0x15
  8016ed:	e8 e4 fd ff ff       	call   8014d6 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	52                   	push   %edx
  801707:	50                   	push   %eax
  801708:	6a 16                	push   $0x16
  80170a:	e8 c7 fd ff ff       	call   8014d6 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801717:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	51                   	push   %ecx
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	6a 17                	push   $0x17
  801729:	e8 a8 fd ff ff       	call   8014d6 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 18                	push   $0x18
  801746:	e8 8b fd ff ff       	call   8014d6 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	ff 75 14             	pushl  0x14(%ebp)
  80175b:	ff 75 10             	pushl  0x10(%ebp)
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	50                   	push   %eax
  801762:	6a 19                	push   $0x19
  801764:	e8 6d fd ff ff       	call   8014d6 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	50                   	push   %eax
  80177d:	6a 1a                	push   $0x1a
  80177f:	e8 52 fd ff ff       	call   8014d6 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	90                   	nop
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	50                   	push   %eax
  801799:	6a 1b                	push   $0x1b
  80179b:	e8 36 fd ff ff       	call   8014d6 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 05                	push   $0x5
  8017b4:	e8 1d fd ff ff       	call   8014d6 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 06                	push   $0x6
  8017cd:	e8 04 fd ff ff       	call   8014d6 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 07                	push   $0x7
  8017e6:	e8 eb fc ff ff       	call   8014d6 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_exit_env>:


void sys_exit_env(void)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 1c                	push   $0x1c
  8017ff:	e8 d2 fc ff ff       	call   8014d6 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801810:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801813:	8d 50 04             	lea    0x4(%eax),%edx
  801816:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	52                   	push   %edx
  801820:	50                   	push   %eax
  801821:	6a 1d                	push   $0x1d
  801823:	e8 ae fc ff ff       	call   8014d6 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
	return result;
  80182b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	89 01                	mov    %eax,(%ecx)
  801836:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	c9                   	leave  
  80183d:	c2 04 00             	ret    $0x4

00801840 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	ff 75 10             	pushl  0x10(%ebp)
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	6a 13                	push   $0x13
  801852:	e8 7f fc ff ff       	call   8014d6 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return ;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_rcr2>:
uint32 sys_rcr2()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 1e                	push   $0x1e
  80186c:	e8 65 fc ff ff       	call   8014d6 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801882:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	50                   	push   %eax
  80188f:	6a 1f                	push   $0x1f
  801891:	e8 40 fc ff ff       	call   8014d6 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
	return ;
  801899:	90                   	nop
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <rsttst>:
void rsttst()
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 21                	push   $0x21
  8018ab:	e8 26 fc ff ff       	call   8014d6 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b3:	90                   	nop
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018c2:	8b 55 18             	mov    0x18(%ebp),%edx
  8018c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	ff 75 10             	pushl  0x10(%ebp)
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 20                	push   $0x20
  8018d6:	e8 fb fb ff ff       	call   8014d6 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return ;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <chktst>:
void chktst(uint32 n)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	ff 75 08             	pushl  0x8(%ebp)
  8018ef:	6a 22                	push   $0x22
  8018f1:	e8 e0 fb ff ff       	call   8014d6 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <inctst>:

void inctst()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 23                	push   $0x23
  80190b:	e8 c6 fb ff ff       	call   8014d6 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <gettst>:
uint32 gettst()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 24                	push   $0x24
  801925:	e8 ac fb ff ff       	call   8014d6 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 25                	push   $0x25
  80193e:	e8 93 fb ff ff       	call   8014d6 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
  801946:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	return uheapPlaceStrategy ;
  80194b:	a1 c0 70 82 00       	mov    0x8270c0,%eax
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 08             	pushl  0x8(%ebp)
  801968:	6a 26                	push   $0x26
  80196a:	e8 67 fb ff ff       	call   8014d6 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
	return ;
  801972:	90                   	nop
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801979:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	53                   	push   %ebx
  801988:	51                   	push   %ecx
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 27                	push   $0x27
  80198d:	e8 44 fb ff ff       	call   8014d6 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	6a 28                	push   $0x28
  8019ad:	e8 24 fb ff ff       	call   8014d6 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	51                   	push   %ecx
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 29                	push   $0x29
  8019cd:	e8 04 fb ff ff       	call   8014d6 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	6a 12                	push   $0x12
  8019e9:	e8 e8 fa ff ff       	call   8014d6 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f1:	90                   	nop
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 2a                	push   $0x2a
  801a07:	e8 ca fa ff ff       	call   8014d6 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
	return;
  801a0f:	90                   	nop
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 2b                	push   $0x2b
  801a21:	e8 b0 fa ff ff       	call   8014d6 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 2d                	push   $0x2d
  801a3c:	e8 95 fa ff ff       	call   8014d6 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 2c                	push   $0x2c
  801a58:	e8 79 fa ff ff       	call   8014d6 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 48 25 80 00       	push   $0x802548
  801a71:	68 25 01 00 00       	push   $0x125
  801a76:	68 7b 25 80 00       	push   $0x80257b
  801a7b:	e8 a3 e8 ff ff       	call   800323 <_panic>

00801a80 <__udivdi3>:
  801a80:	55                   	push   %ebp
  801a81:	57                   	push   %edi
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	83 ec 1c             	sub    $0x1c,%esp
  801a87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a97:	89 ca                	mov    %ecx,%edx
  801a99:	89 f8                	mov    %edi,%eax
  801a9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a9f:	85 f6                	test   %esi,%esi
  801aa1:	75 2d                	jne    801ad0 <__udivdi3+0x50>
  801aa3:	39 cf                	cmp    %ecx,%edi
  801aa5:	77 65                	ja     801b0c <__udivdi3+0x8c>
  801aa7:	89 fd                	mov    %edi,%ebp
  801aa9:	85 ff                	test   %edi,%edi
  801aab:	75 0b                	jne    801ab8 <__udivdi3+0x38>
  801aad:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab2:	31 d2                	xor    %edx,%edx
  801ab4:	f7 f7                	div    %edi
  801ab6:	89 c5                	mov    %eax,%ebp
  801ab8:	31 d2                	xor    %edx,%edx
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	f7 f5                	div    %ebp
  801abe:	89 c1                	mov    %eax,%ecx
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	f7 f5                	div    %ebp
  801ac4:	89 cf                	mov    %ecx,%edi
  801ac6:	89 fa                	mov    %edi,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	39 ce                	cmp    %ecx,%esi
  801ad2:	77 28                	ja     801afc <__udivdi3+0x7c>
  801ad4:	0f bd fe             	bsr    %esi,%edi
  801ad7:	83 f7 1f             	xor    $0x1f,%edi
  801ada:	75 40                	jne    801b1c <__udivdi3+0x9c>
  801adc:	39 ce                	cmp    %ecx,%esi
  801ade:	72 0a                	jb     801aea <__udivdi3+0x6a>
  801ae0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ae4:	0f 87 9e 00 00 00    	ja     801b88 <__udivdi3+0x108>
  801aea:	b8 01 00 00 00       	mov    $0x1,%eax
  801aef:	89 fa                	mov    %edi,%edx
  801af1:	83 c4 1c             	add    $0x1c,%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5f                   	pop    %edi
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    
  801af9:	8d 76 00             	lea    0x0(%esi),%esi
  801afc:	31 ff                	xor    %edi,%edi
  801afe:	31 c0                	xor    %eax,%eax
  801b00:	89 fa                	mov    %edi,%edx
  801b02:	83 c4 1c             	add    $0x1c,%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5f                   	pop    %edi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	f7 f7                	div    %edi
  801b10:	31 ff                	xor    %edi,%edi
  801b12:	89 fa                	mov    %edi,%edx
  801b14:	83 c4 1c             	add    $0x1c,%esp
  801b17:	5b                   	pop    %ebx
  801b18:	5e                   	pop    %esi
  801b19:	5f                   	pop    %edi
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    
  801b1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b21:	89 eb                	mov    %ebp,%ebx
  801b23:	29 fb                	sub    %edi,%ebx
  801b25:	89 f9                	mov    %edi,%ecx
  801b27:	d3 e6                	shl    %cl,%esi
  801b29:	89 c5                	mov    %eax,%ebp
  801b2b:	88 d9                	mov    %bl,%cl
  801b2d:	d3 ed                	shr    %cl,%ebp
  801b2f:	89 e9                	mov    %ebp,%ecx
  801b31:	09 f1                	or     %esi,%ecx
  801b33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b37:	89 f9                	mov    %edi,%ecx
  801b39:	d3 e0                	shl    %cl,%eax
  801b3b:	89 c5                	mov    %eax,%ebp
  801b3d:	89 d6                	mov    %edx,%esi
  801b3f:	88 d9                	mov    %bl,%cl
  801b41:	d3 ee                	shr    %cl,%esi
  801b43:	89 f9                	mov    %edi,%ecx
  801b45:	d3 e2                	shl    %cl,%edx
  801b47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4b:	88 d9                	mov    %bl,%cl
  801b4d:	d3 e8                	shr    %cl,%eax
  801b4f:	09 c2                	or     %eax,%edx
  801b51:	89 d0                	mov    %edx,%eax
  801b53:	89 f2                	mov    %esi,%edx
  801b55:	f7 74 24 0c          	divl   0xc(%esp)
  801b59:	89 d6                	mov    %edx,%esi
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	f7 e5                	mul    %ebp
  801b5f:	39 d6                	cmp    %edx,%esi
  801b61:	72 19                	jb     801b7c <__udivdi3+0xfc>
  801b63:	74 0b                	je     801b70 <__udivdi3+0xf0>
  801b65:	89 d8                	mov    %ebx,%eax
  801b67:	31 ff                	xor    %edi,%edi
  801b69:	e9 58 ff ff ff       	jmp    801ac6 <__udivdi3+0x46>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b74:	89 f9                	mov    %edi,%ecx
  801b76:	d3 e2                	shl    %cl,%edx
  801b78:	39 c2                	cmp    %eax,%edx
  801b7a:	73 e9                	jae    801b65 <__udivdi3+0xe5>
  801b7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b7f:	31 ff                	xor    %edi,%edi
  801b81:	e9 40 ff ff ff       	jmp    801ac6 <__udivdi3+0x46>
  801b86:	66 90                	xchg   %ax,%ax
  801b88:	31 c0                	xor    %eax,%eax
  801b8a:	e9 37 ff ff ff       	jmp    801ac6 <__udivdi3+0x46>
  801b8f:	90                   	nop

00801b90 <__umoddi3>:
  801b90:	55                   	push   %ebp
  801b91:	57                   	push   %edi
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 1c             	sub    $0x1c,%esp
  801b97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ba3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ba7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801baf:	89 f3                	mov    %esi,%ebx
  801bb1:	89 fa                	mov    %edi,%edx
  801bb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb7:	89 34 24             	mov    %esi,(%esp)
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	75 1a                	jne    801bd8 <__umoddi3+0x48>
  801bbe:	39 f7                	cmp    %esi,%edi
  801bc0:	0f 86 a2 00 00 00    	jbe    801c68 <__umoddi3+0xd8>
  801bc6:	89 c8                	mov    %ecx,%eax
  801bc8:	89 f2                	mov    %esi,%edx
  801bca:	f7 f7                	div    %edi
  801bcc:	89 d0                	mov    %edx,%eax
  801bce:	31 d2                	xor    %edx,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	39 f0                	cmp    %esi,%eax
  801bda:	0f 87 ac 00 00 00    	ja     801c8c <__umoddi3+0xfc>
  801be0:	0f bd e8             	bsr    %eax,%ebp
  801be3:	83 f5 1f             	xor    $0x1f,%ebp
  801be6:	0f 84 ac 00 00 00    	je     801c98 <__umoddi3+0x108>
  801bec:	bf 20 00 00 00       	mov    $0x20,%edi
  801bf1:	29 ef                	sub    %ebp,%edi
  801bf3:	89 fe                	mov    %edi,%esi
  801bf5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bf9:	89 e9                	mov    %ebp,%ecx
  801bfb:	d3 e0                	shl    %cl,%eax
  801bfd:	89 d7                	mov    %edx,%edi
  801bff:	89 f1                	mov    %esi,%ecx
  801c01:	d3 ef                	shr    %cl,%edi
  801c03:	09 c7                	or     %eax,%edi
  801c05:	89 e9                	mov    %ebp,%ecx
  801c07:	d3 e2                	shl    %cl,%edx
  801c09:	89 14 24             	mov    %edx,(%esp)
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	d3 e0                	shl    %cl,%eax
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c16:	d3 e0                	shl    %cl,%eax
  801c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c20:	89 f1                	mov    %esi,%ecx
  801c22:	d3 e8                	shr    %cl,%eax
  801c24:	09 d0                	or     %edx,%eax
  801c26:	d3 eb                	shr    %cl,%ebx
  801c28:	89 da                	mov    %ebx,%edx
  801c2a:	f7 f7                	div    %edi
  801c2c:	89 d3                	mov    %edx,%ebx
  801c2e:	f7 24 24             	mull   (%esp)
  801c31:	89 c6                	mov    %eax,%esi
  801c33:	89 d1                	mov    %edx,%ecx
  801c35:	39 d3                	cmp    %edx,%ebx
  801c37:	0f 82 87 00 00 00    	jb     801cc4 <__umoddi3+0x134>
  801c3d:	0f 84 91 00 00 00    	je     801cd4 <__umoddi3+0x144>
  801c43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c47:	29 f2                	sub    %esi,%edx
  801c49:	19 cb                	sbb    %ecx,%ebx
  801c4b:	89 d8                	mov    %ebx,%eax
  801c4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c51:	d3 e0                	shl    %cl,%eax
  801c53:	89 e9                	mov    %ebp,%ecx
  801c55:	d3 ea                	shr    %cl,%edx
  801c57:	09 d0                	or     %edx,%eax
  801c59:	89 e9                	mov    %ebp,%ecx
  801c5b:	d3 eb                	shr    %cl,%ebx
  801c5d:	89 da                	mov    %ebx,%edx
  801c5f:	83 c4 1c             	add    $0x1c,%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5f                   	pop    %edi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    
  801c67:	90                   	nop
  801c68:	89 fd                	mov    %edi,%ebp
  801c6a:	85 ff                	test   %edi,%edi
  801c6c:	75 0b                	jne    801c79 <__umoddi3+0xe9>
  801c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c73:	31 d2                	xor    %edx,%edx
  801c75:	f7 f7                	div    %edi
  801c77:	89 c5                	mov    %eax,%ebp
  801c79:	89 f0                	mov    %esi,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f5                	div    %ebp
  801c7f:	89 c8                	mov    %ecx,%eax
  801c81:	f7 f5                	div    %ebp
  801c83:	89 d0                	mov    %edx,%eax
  801c85:	e9 44 ff ff ff       	jmp    801bce <__umoddi3+0x3e>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	89 c8                	mov    %ecx,%eax
  801c8e:	89 f2                	mov    %esi,%edx
  801c90:	83 c4 1c             	add    $0x1c,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5f                   	pop    %edi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	3b 04 24             	cmp    (%esp),%eax
  801c9b:	72 06                	jb     801ca3 <__umoddi3+0x113>
  801c9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ca1:	77 0f                	ja     801cb2 <__umoddi3+0x122>
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	29 f9                	sub    %edi,%ecx
  801ca7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cab:	89 14 24             	mov    %edx,(%esp)
  801cae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cb6:	8b 14 24             	mov    (%esp),%edx
  801cb9:	83 c4 1c             	add    $0x1c,%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5f                   	pop    %edi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
  801cc1:	8d 76 00             	lea    0x0(%esi),%esi
  801cc4:	2b 04 24             	sub    (%esp),%eax
  801cc7:	19 fa                	sbb    %edi,%edx
  801cc9:	89 d1                	mov    %edx,%ecx
  801ccb:	89 c6                	mov    %eax,%esi
  801ccd:	e9 71 ff ff ff       	jmp    801c43 <__umoddi3+0xb3>
  801cd2:	66 90                	xchg   %ax,%ax
  801cd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cd8:	72 ea                	jb     801cc4 <__umoddi3+0x134>
  801cda:	89 d9                	mov    %ebx,%ecx
  801cdc:	e9 62 ff ff ff       	jmp    801c43 <__umoddi3+0xb3>
