
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 0c 01 00 00       	call   800142 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	printStats = 0;
  80003e:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  800045:	00 00 00 

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800048:	a1 20 40 80 00       	mov    0x804020,%eax
  80004d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800053:	a1 20 40 80 00       	mov    0x804020,%eax
  800058:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005e:	39 c2                	cmp    %eax,%edx
  800060:	72 14                	jb     800076 <_main+0x3e>
			panic("Please increase the WS size");
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	68 e0 29 80 00       	push   $0x8029e0
  80006a:	6a 0f                	push   $0xf
  80006c:	68 fc 29 80 00       	push   $0x8029fc
  800071:	e8 7c 02 00 00       	call   8002f2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  80007d:	e8 db 18 00 00       	call   80195d <sys_getparentenvid>
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 1c 2a 80 00       	push   $0x802a1c
  80008a:	50                   	push   %eax
  80008b:	e8 6e 15 00 00       	call   8015fe <sget>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 20 2a 80 00       	push   $0x802a20
  80009e:	e8 1d 05 00 00       	call   8005c0 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000a6:	e8 d7 19 00 00       	call   801a82 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 48 2a 80 00       	push   $0x802a48
  8000b3:	e8 08 05 00 00       	call   8005c0 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z and be completed.
	env_sleep(6000);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 70 17 00 00       	push   $0x1770
  8000c3:	e8 e5 25 00 00       	call   8026ad <env_sleep>
  8000c8:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=4) ;// panic("test failed");
  8000cb:	90                   	nop
  8000cc:	e8 cb 19 00 00       	call   801a9c <gettst>
  8000d1:	83 f8 04             	cmp    $0x4,%eax
  8000d4:	75 f6                	jne    8000cc <_main+0x94>

	freeFrames = sys_calculate_free_frames() ;
  8000d6:	e8 a0 16 00 00       	call   80177b <sys_calculate_free_frames>
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e4:	e8 56 15 00 00       	call   80163f <sfree>
  8000e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 68 2a 80 00       	push   $0x802a68
  8000f4:	e8 c7 04 00 00       	call   8005c0 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
	expected = 2+1; /*2pages+1table*/
  8000fc:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of x\nframes_storage of x: should be cleared now\n", expected);
  800103:	e8 73 16 00 00       	call   80177b <sys_calculate_free_frames>
  800108:	89 c2                	mov    %eax,%edx
  80010a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010d:	29 c2                	sub    %eax,%edx
  80010f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800112:	39 c2                	cmp    %eax,%edx
  800114:	74 14                	je     80012a <_main+0xf2>
  800116:	ff 75 e8             	pushl  -0x18(%ebp)
  800119:	68 80 2a 80 00       	push   $0x802a80
  80011e:	6a 29                	push   $0x29
  800120:	68 fc 29 80 00       	push   $0x8029fc
  800125:	e8 c8 01 00 00       	call   8002f2 <_panic>

	//To indicate that it's completed successfully
	cprintf("SlaveB1 is completed.\n");
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	68 10 2b 80 00       	push   $0x802b10
  800132:	e8 89 04 00 00       	call   8005c0 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	inctst();
  80013a:	e8 43 19 00 00       	call   801a82 <inctst>
	return;
  80013f:	90                   	nop
}
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
  800148:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80014b:	e8 f4 17 00 00       	call   801944 <sys_getenvindex>
  800150:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800153:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800156:	89 d0                	mov    %edx,%eax
  800158:	c1 e0 02             	shl    $0x2,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 03             	shl    $0x3,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 02             	shl    $0x2,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 40 20             	mov    0x20(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	83 c0 20             	add    $0x20,%eax
  80018c:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x5f>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b2:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	0f 84 01 01 00 00    	je     8002c0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c5:	bb 20 2c 80 00       	mov    $0x802c20,%ebx
  8001ca:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cf:	89 c7                	mov    %eax,%edi
  8001d1:	89 de                	mov    %ebx,%esi
  8001d3:	89 d1                	mov    %edx,%ecx
  8001d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001da:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001df:	b0 00                	mov    $0x0,%al
  8001e1:	89 d7                	mov    %edx,%edi
  8001e3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 7b 19 00 00       	call   801b7a <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800202:	e8 c4 14 00 00       	call   8016cb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 40 2b 80 00       	push   $0x802b40
  80020f:	e8 ac 03 00 00       	call   8005c0 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021a:	85 c0                	test   %eax,%eax
  80021c:	74 18                	je     800236 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80021e:	e8 75 19 00 00       	call   801b98 <sys_get_optimal_num_faults>
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	50                   	push   %eax
  800227:	68 68 2b 80 00       	push   $0x802b68
  80022c:	e8 8f 03 00 00       	call   8005c0 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	eb 59                	jmp    80028f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800236:	a1 20 40 80 00       	mov    0x804020,%eax
  80023b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800241:	a1 20 40 80 00       	mov    0x804020,%eax
  800246:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	52                   	push   %edx
  800250:	50                   	push   %eax
  800251:	68 8c 2b 80 00       	push   $0x802b8c
  800256:	e8 65 03 00 00       	call   8005c0 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800269:	a1 20 40 80 00       	mov    0x804020,%eax
  80026e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80027f:	51                   	push   %ecx
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 b4 2b 80 00       	push   $0x802bb4
  800287:	e8 34 03 00 00       	call   8005c0 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 40 80 00       	mov    0x804020,%eax
  800294:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 0c 2c 80 00       	push   $0x802c0c
  8002a3:	e8 18 03 00 00       	call   8005c0 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 40 2b 80 00       	push   $0x802b40
  8002b3:	e8 08 03 00 00       	call   8005c0 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002bb:	e8 25 14 00 00       	call   8016e5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c0:	e8 1f 00 00 00       	call   8002e4 <exit>
}
  8002c5:	90                   	nop
  8002c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    

008002ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	6a 00                	push   $0x0
  8002d9:	e8 32 16 00 00       	call   801910 <sys_destroy_env>
  8002de:	83 c4 10             	add    $0x10,%esp
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <exit>:

void
exit(void)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ea:	e8 87 16 00 00       	call   801976 <sys_exit_env>
}
  8002ef:	90                   	nop
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fb:	83 c0 04             	add    $0x4,%eax
  8002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800301:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	74 16                	je     800320 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80030a:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	50                   	push   %eax
  800313:	68 84 2c 80 00       	push   $0x802c84
  800318:	e8 a3 02 00 00       	call   8005c0 <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800320:	a1 04 40 80 00       	mov    0x804004,%eax
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	50                   	push   %eax
  80032f:	68 8c 2c 80 00       	push   $0x802c8c
  800334:	6a 74                	push   $0x74
  800336:	e8 b2 02 00 00       	call   8005ed <cprintf_colored>
  80033b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80033e:	8b 45 10             	mov    0x10(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 04 02 00 00       	call   800551 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	6a 00                	push   $0x0
  800355:	68 b4 2c 80 00       	push   $0x802cb4
  80035a:	e8 f2 01 00 00       	call   800551 <vcprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800362:	e8 7d ff ff ff       	call   8002e4 <exit>

	// should not return here
	while (1) ;
  800367:	eb fe                	jmp    800367 <_panic+0x75>

00800369 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80036f:	a1 20 40 80 00       	mov    0x804020,%eax
  800374:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	39 c2                	cmp    %eax,%edx
  80037f:	74 14                	je     800395 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	68 b8 2c 80 00       	push   $0x802cb8
  800389:	6a 26                	push   $0x26
  80038b:	68 04 2d 80 00       	push   $0x802d04
  800390:	e8 5d ff ff ff       	call   8002f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a3:	e9 c5 00 00 00       	jmp    80046d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	85 c0                	test   %eax,%eax
  8003bb:	75 08                	jne    8003c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c0:	e9 a5 00 00 00       	jmp    80046a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d3:	eb 69                	jmp    80043e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003da:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e3:	89 d0                	mov    %edx,%eax
  8003e5:	01 c0                	add    %eax,%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	c1 e0 03             	shl    $0x3,%eax
  8003ec:	01 c8                	add    %ecx,%eax
  8003ee:	8a 40 04             	mov    0x4(%eax),%al
  8003f1:	84 c0                	test   %al,%al
  8003f3:	75 46                	jne    80043b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800403:	89 d0                	mov    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	c1 e0 03             	shl    $0x3,%eax
  80040c:	01 c8                	add    %ecx,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800413:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800416:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800420:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	01 c8                	add    %ecx,%eax
  80042c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	75 09                	jne    80043b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800432:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800439:	eb 15                	jmp    800450 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043b:	ff 45 e8             	incl   -0x18(%ebp)
  80043e:	a1 20 40 80 00       	mov    0x804020,%eax
  800443:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044c:	39 c2                	cmp    %eax,%edx
  80044e:	77 85                	ja     8003d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800454:	75 14                	jne    80046a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800456:	83 ec 04             	sub    $0x4,%esp
  800459:	68 10 2d 80 00       	push   $0x802d10
  80045e:	6a 3a                	push   $0x3a
  800460:	68 04 2d 80 00       	push   $0x802d04
  800465:	e8 88 fe ff ff       	call   8002f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046a:	ff 45 f0             	incl   -0x10(%ebp)
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	0f 8c 2f ff ff ff    	jl     8003a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800479:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800487:	eb 26                	jmp    8004af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800489:	a1 20 40 80 00       	mov    0x804020,%eax
  80048e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800494:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	c1 e0 03             	shl    $0x3,%eax
  8004a0:	01 c8                	add    %ecx,%eax
  8004a2:	8a 40 04             	mov    0x4(%eax),%al
  8004a5:	3c 01                	cmp    $0x1,%al
  8004a7:	75 03                	jne    8004ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ac:	ff 45 e0             	incl   -0x20(%ebp)
  8004af:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	77 c8                	ja     800489 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c7:	74 14                	je     8004dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 64 2d 80 00       	push   $0x802d64
  8004d1:	6a 44                	push   $0x44
  8004d3:	68 04 2d 80 00       	push   $0x802d04
  8004d8:	e8 15 fe ff ff       	call   8002f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	89 0a                	mov    %ecx,(%edx)
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	88 d1                	mov    %dl,%cl
  8004f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800500:	8b 45 0c             	mov    0xc(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	3d ff 00 00 00       	cmp    $0xff,%eax
  80050a:	75 30                	jne    80053c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80050c:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800512:	a0 44 40 80 00       	mov    0x804044,%al
  800517:	0f b6 c0             	movzbl %al,%eax
  80051a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051d:	8b 09                	mov    (%ecx),%ecx
  80051f:	89 cb                	mov    %ecx,%ebx
  800521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800524:	83 c1 08             	add    $0x8,%ecx
  800527:	52                   	push   %edx
  800528:	50                   	push   %eax
  800529:	53                   	push   %ebx
  80052a:	51                   	push   %ecx
  80052b:	e8 57 11 00 00       	call   801687 <sys_cputs>
  800530:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	8b 40 04             	mov    0x4(%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 0c             	mov    0xc(%ebp),%eax
  800548:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054b:	90                   	nop
  80054c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80055a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800561:	00 00 00 
	b.cnt = 0;
  800564:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	68 e0 04 80 00       	push   $0x8004e0
  800580:	e8 5a 02 00 00       	call   8007df <vprintfmt>
  800585:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800588:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80058e:	a0 44 40 80 00       	mov    0x804044,%al
  800593:	0f b6 c0             	movzbl %al,%eax
  800596:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80059c:	52                   	push   %edx
  80059d:	50                   	push   %eax
  80059e:	51                   	push   %ecx
  80059f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a5:	83 c0 08             	add    $0x8,%eax
  8005a8:	50                   	push   %eax
  8005a9:	e8 d9 10 00 00       	call   801687 <sys_cputs>
  8005ae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b1:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8005b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005be:	c9                   	leave  
  8005bf:	c3                   	ret    

008005c0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c6:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8005cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005dc:	50                   	push   %eax
  8005dd:	e8 6f ff ff ff       	call   800551 <vcprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f3:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	c1 e0 08             	shl    $0x8,%eax
  800600:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800605:	8d 45 0c             	lea    0xc(%ebp),%eax
  800608:	83 c0 04             	add    $0x4,%eax
  80060b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	ff 75 f4             	pushl  -0xc(%ebp)
  800617:	50                   	push   %eax
  800618:	e8 34 ff ff ff       	call   800551 <vcprintf>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800623:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  80062a:	07 00 00 

	return cnt;
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800638:	e8 8e 10 00 00       	call   8016cb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80063d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 f4             	pushl  -0xc(%ebp)
  80064c:	50                   	push   %eax
  80064d:	e8 ff fe ff ff       	call   800551 <vcprintf>
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800658:	e8 88 10 00 00       	call   8016e5 <sys_unlock_cons>
	return cnt;
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800660:	c9                   	leave  
  800661:	c3                   	ret    

00800662 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	53                   	push   %ebx
  800666:	83 ec 14             	sub    $0x14,%esp
  800669:	8b 45 10             	mov    0x10(%ebp),%eax
  80066c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800675:	8b 45 18             	mov    0x18(%ebp),%eax
  800678:	ba 00 00 00 00       	mov    $0x0,%edx
  80067d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800680:	77 55                	ja     8006d7 <printnum+0x75>
  800682:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800685:	72 05                	jb     80068c <printnum+0x2a>
  800687:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80068a:	77 4b                	ja     8006d7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80068f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	52                   	push   %edx
  80069b:	50                   	push   %eax
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a2:	e8 c5 20 00 00       	call   80276c <__udivdi3>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	ff 75 20             	pushl  0x20(%ebp)
  8006b0:	53                   	push   %ebx
  8006b1:	ff 75 18             	pushl  0x18(%ebp)
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 a1 ff ff ff       	call   800662 <printnum>
  8006c1:	83 c4 20             	add    $0x20,%esp
  8006c4:	eb 1a                	jmp    8006e0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	ff 75 20             	pushl  0x20(%ebp)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006da:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006de:	7f e6                	jg     8006c6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ee:	53                   	push   %ebx
  8006ef:	51                   	push   %ecx
  8006f0:	52                   	push   %edx
  8006f1:	50                   	push   %eax
  8006f2:	e8 85 21 00 00       	call   80287c <__umoddi3>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	05 d4 2f 80 00       	add    $0x802fd4,%eax
  8006ff:	8a 00                	mov    (%eax),%al
  800701:	0f be c0             	movsbl %al,%eax
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	50                   	push   %eax
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
}
  800713:	90                   	nop
  800714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800720:	7e 1c                	jle    80073e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	8d 50 08             	lea    0x8(%eax),%edx
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	89 10                	mov    %edx,(%eax)
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	83 e8 08             	sub    $0x8,%eax
  800737:	8b 50 04             	mov    0x4(%eax),%edx
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	eb 40                	jmp    80077e <getuint+0x65>
	else if (lflag)
  80073e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800742:	74 1e                	je     800762 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
  800760:	eb 1c                	jmp    80077e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	8d 50 04             	lea    0x4(%eax),%edx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	89 10                	mov    %edx,(%eax)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	83 e8 04             	sub    $0x4,%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800783:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800787:	7e 1c                	jle    8007a5 <getint+0x25>
		return va_arg(*ap, long long);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 08             	lea    0x8(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 08             	sub    $0x8,%eax
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	eb 38                	jmp    8007dd <getint+0x5d>
	else if (lflag)
  8007a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a9:	74 1a                	je     8007c5 <getint+0x45>
		return va_arg(*ap, long);
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	8d 50 04             	lea    0x4(%eax),%edx
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	89 10                	mov    %edx,(%eax)
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	83 e8 04             	sub    $0x4,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	99                   	cltd   
  8007c3:	eb 18                	jmp    8007dd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 04             	sub    $0x4,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	99                   	cltd   
}
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	56                   	push   %esi
  8007e3:	53                   	push   %ebx
  8007e4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e7:	eb 17                	jmp    800800 <vprintfmt+0x21>
			if (ch == '\0')
  8007e9:	85 db                	test   %ebx,%ebx
  8007eb:	0f 84 c1 03 00 00    	je     800bb2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	53                   	push   %ebx
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	8d 50 01             	lea    0x1(%eax),%edx
  800806:	89 55 10             	mov    %edx,0x10(%ebp)
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f b6 d8             	movzbl %al,%ebx
  80080e:	83 fb 25             	cmp    $0x25,%ebx
  800811:	75 d6                	jne    8007e9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800813:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800817:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80081e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800825:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80082c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800833:	8b 45 10             	mov    0x10(%ebp),%eax
  800836:	8d 50 01             	lea    0x1(%eax),%edx
  800839:	89 55 10             	mov    %edx,0x10(%ebp)
  80083c:	8a 00                	mov    (%eax),%al
  80083e:	0f b6 d8             	movzbl %al,%ebx
  800841:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800844:	83 f8 5b             	cmp    $0x5b,%eax
  800847:	0f 87 3d 03 00 00    	ja     800b8a <vprintfmt+0x3ab>
  80084d:	8b 04 85 f8 2f 80 00 	mov    0x802ff8(,%eax,4),%eax
  800854:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800856:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80085a:	eb d7                	jmp    800833 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80085c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800860:	eb d1                	jmp    800833 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800869:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086c:	89 d0                	mov    %edx,%eax
  80086e:	c1 e0 02             	shl    $0x2,%eax
  800871:	01 d0                	add    %edx,%eax
  800873:	01 c0                	add    %eax,%eax
  800875:	01 d8                	add    %ebx,%eax
  800877:	83 e8 30             	sub    $0x30,%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80087d:	8b 45 10             	mov    0x10(%ebp),%eax
  800880:	8a 00                	mov    (%eax),%al
  800882:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800885:	83 fb 2f             	cmp    $0x2f,%ebx
  800888:	7e 3e                	jle    8008c8 <vprintfmt+0xe9>
  80088a:	83 fb 39             	cmp    $0x39,%ebx
  80088d:	7f 39                	jg     8008c8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800892:	eb d5                	jmp    800869 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 c0 04             	add    $0x4,%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 e8 04             	sub    $0x4,%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008a8:	eb 1f                	jmp    8008c9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ae:	79 83                	jns    800833 <vprintfmt+0x54>
				width = 0;
  8008b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008b7:	e9 77 ff ff ff       	jmp    800833 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008bc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c3:	e9 6b ff ff ff       	jmp    800833 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cd:	0f 89 60 ff ff ff    	jns    800833 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e0:	e9 4e ff ff ff       	jmp    800833 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008e8:	e9 46 ff ff ff       	jmp    800833 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	50                   	push   %eax
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	ff d0                	call   *%eax
  80090a:	83 c4 10             	add    $0x10,%esp
			break;
  80090d:	e9 9b 02 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800923:	85 db                	test   %ebx,%ebx
  800925:	79 02                	jns    800929 <vprintfmt+0x14a>
				err = -err;
  800927:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800929:	83 fb 64             	cmp    $0x64,%ebx
  80092c:	7f 0b                	jg     800939 <vprintfmt+0x15a>
  80092e:	8b 34 9d 40 2e 80 00 	mov    0x802e40(,%ebx,4),%esi
  800935:	85 f6                	test   %esi,%esi
  800937:	75 19                	jne    800952 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800939:	53                   	push   %ebx
  80093a:	68 e5 2f 80 00       	push   $0x802fe5
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	e8 70 02 00 00       	call   800bba <printfmt>
  80094a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80094d:	e9 5b 02 00 00       	jmp    800bad <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800952:	56                   	push   %esi
  800953:	68 ee 2f 80 00       	push   $0x802fee
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 57 02 00 00       	call   800bba <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			break;
  800966:	e9 42 02 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 30                	mov    (%eax),%esi
  80097c:	85 f6                	test   %esi,%esi
  80097e:	75 05                	jne    800985 <vprintfmt+0x1a6>
				p = "(null)";
  800980:	be f1 2f 80 00       	mov    $0x802ff1,%esi
			if (width > 0 && padc != '-')
  800985:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800989:	7e 6d                	jle    8009f8 <vprintfmt+0x219>
  80098b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80098f:	74 67                	je     8009f8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	50                   	push   %eax
  800998:	56                   	push   %esi
  800999:	e8 1e 03 00 00       	call   800cbc <strnlen>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a4:	eb 16                	jmp    8009bc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	50                   	push   %eax
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c0:	7f e4                	jg     8009a6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c2:	eb 34                	jmp    8009f8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009c8:	74 1c                	je     8009e6 <vprintfmt+0x207>
  8009ca:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cd:	7e 05                	jle    8009d4 <vprintfmt+0x1f5>
  8009cf:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d2:	7e 12                	jle    8009e6 <vprintfmt+0x207>
					putch('?', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 3f                	push   $0x3f
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	eb 0f                	jmp    8009f5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	53                   	push   %ebx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f8:	89 f0                	mov    %esi,%eax
  8009fa:	8d 70 01             	lea    0x1(%eax),%esi
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	0f be d8             	movsbl %al,%ebx
  800a02:	85 db                	test   %ebx,%ebx
  800a04:	74 24                	je     800a2a <vprintfmt+0x24b>
  800a06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0a:	78 b8                	js     8009c4 <vprintfmt+0x1e5>
  800a0c:	ff 4d e0             	decl   -0x20(%ebp)
  800a0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a13:	79 af                	jns    8009c4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a15:	eb 13                	jmp    800a2a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	6a 20                	push   $0x20
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	ff d0                	call   *%eax
  800a24:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a27:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2e:	7f e7                	jg     800a17 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a30:	e9 78 01 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3e:	50                   	push   %eax
  800a3f:	e8 3c fd ff ff       	call   800780 <getint>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a53:	85 d2                	test   %edx,%edx
  800a55:	79 23                	jns    800a7a <vprintfmt+0x29b>
				putch('-', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	6a 2d                	push   $0x2d
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6d:	f7 d8                	neg    %eax
  800a6f:	83 d2 00             	adc    $0x0,%edx
  800a72:	f7 da                	neg    %edx
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a81:	e9 bc 00 00 00       	jmp    800b42 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 84 fc ff ff       	call   800719 <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a9e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa5:	e9 98 00 00 00       	jmp    800b42 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	6a 58                	push   $0x58
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 58                	push   $0x58
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 58                	push   $0x58
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	e9 ce 00 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 30                	push   $0x30
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	ff d0                	call   *%eax
  800aec:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 78                	push   $0x78
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b1a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b21:	eb 1f                	jmp    800b42 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 e8             	pushl  -0x18(%ebp)
  800b29:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2c:	50                   	push   %eax
  800b2d:	e8 e7 fb ff ff       	call   800719 <getuint>
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b3b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b42:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b49:	83 ec 04             	sub    $0x4,%esp
  800b4c:	52                   	push   %edx
  800b4d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b50:	50                   	push   %eax
  800b51:	ff 75 f4             	pushl  -0xc(%ebp)
  800b54:	ff 75 f0             	pushl  -0x10(%ebp)
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	e8 00 fb ff ff       	call   800662 <printnum>
  800b62:	83 c4 20             	add    $0x20,%esp
			break;
  800b65:	eb 46                	jmp    800bad <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			break;
  800b76:	eb 35                	jmp    800bad <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b78:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800b7f:	eb 2c                	jmp    800bad <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b81:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800b88:	eb 23                	jmp    800bad <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 25                	push   $0x25
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9a:	ff 4d 10             	decl   0x10(%ebp)
  800b9d:	eb 03                	jmp    800ba2 <vprintfmt+0x3c3>
  800b9f:	ff 4d 10             	decl   0x10(%ebp)
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	48                   	dec    %eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	3c 25                	cmp    $0x25,%al
  800baa:	75 f3                	jne    800b9f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bac:	90                   	nop
		}
	}
  800bad:	e9 35 fc ff ff       	jmp    8007e7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc3:	83 c0 04             	add    $0x4,%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	ff 75 08             	pushl  0x8(%ebp)
  800bd6:	e8 04 fc ff ff       	call   8007df <vprintfmt>
  800bdb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bde:	90                   	nop
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 40 08             	mov    0x8(%eax),%eax
  800bea:	8d 50 01             	lea    0x1(%eax),%edx
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8b 10                	mov    (%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 40 04             	mov    0x4(%eax),%eax
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	73 12                	jae    800c14 <sprintputch+0x33>
		*b->buf++ = ch;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	8d 48 01             	lea    0x1(%eax),%ecx
  800c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0d:	89 0a                	mov    %ecx,(%edx)
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	88 10                	mov    %dl,(%eax)
}
  800c14:	90                   	nop
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
  800c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3c:	74 06                	je     800c44 <vsnprintf+0x2d>
  800c3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c42:	7f 07                	jg     800c4b <vsnprintf+0x34>
		return -E_INVAL;
  800c44:	b8 03 00 00 00       	mov    $0x3,%eax
  800c49:	eb 20                	jmp    800c6b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4b:	ff 75 14             	pushl  0x14(%ebp)
  800c4e:	ff 75 10             	pushl  0x10(%ebp)
  800c51:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c54:	50                   	push   %eax
  800c55:	68 e1 0b 80 00       	push   $0x800be1
  800c5a:	e8 80 fb ff ff       	call   8007df <vprintfmt>
  800c5f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c65:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c73:	8d 45 10             	lea    0x10(%ebp),%eax
  800c76:	83 c0 04             	add    $0x4,%eax
  800c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	ff 75 08             	pushl  0x8(%ebp)
  800c89:	e8 89 ff ff ff       	call   800c17 <vsnprintf>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca6:	eb 06                	jmp    800cae <strlen+0x15>
		n++;
  800ca8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cab:	ff 45 08             	incl   0x8(%ebp)
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	84 c0                	test   %al,%al
  800cb5:	75 f1                	jne    800ca8 <strlen+0xf>
		n++;
	return n;
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc9:	eb 09                	jmp    800cd4 <strnlen+0x18>
		n++;
  800ccb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 4d 0c             	decl   0xc(%ebp)
  800cd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd8:	74 09                	je     800ce3 <strnlen+0x27>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e8                	jne    800ccb <strnlen+0xf>
		n++;
	return n;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf4:	90                   	nop
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8d 50 01             	lea    0x1(%eax),%edx
  800cfb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d01:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d07:	8a 12                	mov    (%edx),%dl
  800d09:	88 10                	mov    %dl,(%eax)
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	75 e4                	jne    800cf5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d29:	eb 1f                	jmp    800d4a <strncpy+0x34>
		*dst++ = *src;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	89 55 08             	mov    %edx,0x8(%ebp)
  800d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d37:	8a 12                	mov    (%edx),%dl
  800d39:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	74 03                	je     800d47 <strncpy+0x31>
			src++;
  800d44:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d47:	ff 45 fc             	incl   -0x4(%ebp)
  800d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d50:	72 d9                	jb     800d2b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	74 30                	je     800d99 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d69:	eb 16                	jmp    800d81 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8d 50 01             	lea    0x1(%eax),%edx
  800d71:	89 55 08             	mov    %edx,0x8(%ebp)
  800d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d77:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7d:	8a 12                	mov    (%edx),%dl
  800d7f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d88:	74 09                	je     800d93 <strlcpy+0x3c>
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 d8                	jne    800d6b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9f:	29 c2                	sub    %eax,%edx
  800da1:	89 d0                	mov    %edx,%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da8:	eb 06                	jmp    800db0 <strcmp+0xb>
		p++, q++;
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	74 0e                	je     800dc7 <strcmp+0x22>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 10                	mov    (%eax),%dl
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	38 c2                	cmp    %al,%dl
  800dc5:	74 e3                	je     800daa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de0:	eb 09                	jmp    800deb <strncmp+0xe>
		n--, p++, q++;
  800de2:	ff 4d 10             	decl   0x10(%ebp)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800deb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800def:	74 17                	je     800e08 <strncmp+0x2b>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	84 c0                	test   %al,%al
  800df8:	74 0e                	je     800e08 <strncmp+0x2b>
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 10                	mov    (%eax),%dl
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	38 c2                	cmp    %al,%dl
  800e06:	74 da                	je     800de2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0c:	75 07                	jne    800e15 <strncmp+0x38>
		return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	eb 14                	jmp    800e29 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	0f b6 d0             	movzbl %al,%edx
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	29 c2                	sub    %eax,%edx
  800e27:	89 d0                	mov    %edx,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e37:	eb 12                	jmp    800e4b <strchr+0x20>
		if (*s == c)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e41:	75 05                	jne    800e48 <strchr+0x1d>
			return (char *) s;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	eb 11                	jmp    800e59 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	84 c0                	test   %al,%al
  800e52:	75 e5                	jne    800e39 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 04             	sub    $0x4,%esp
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e67:	eb 0d                	jmp    800e76 <strfind+0x1b>
		if (*s == c)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e71:	74 0e                	je     800e81 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	84 c0                	test   %al,%al
  800e7d:	75 ea                	jne    800e69 <strfind+0xe>
  800e7f:	eb 01                	jmp    800e82 <strfind+0x27>
		if (*s == c)
			break;
  800e81:	90                   	nop
	return (char *) s;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e93:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e97:	76 63                	jbe    800efc <memset+0x75>
		uint64 data_block = c;
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	99                   	cltd   
  800e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ead:	c1 e0 08             	shl    $0x8,%eax
  800eb0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ec0:	c1 e0 10             	shl    $0x10,%eax
  800ec3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800edc:	eb 18                	jmp    800ef6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ede:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee1:	8d 41 08             	lea    0x8(%ecx),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eed:	89 01                	mov    %eax,(%ecx)
  800eef:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efa:	77 e2                	ja     800ede <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 23                	je     800f25 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f05:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f08:	eb 0e                	jmp    800f18 <memset+0x91>
			*p8++ = (uint8)c;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f16:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 e5                	jne    800f0a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f3c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f40:	76 24                	jbe    800f66 <memcpy+0x3c>
		while(n >= 8){
  800f42:	eb 1c                	jmp    800f60 <memcpy+0x36>
			*d64 = *s64;
  800f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f47:	8b 50 04             	mov    0x4(%eax),%edx
  800f4a:	8b 00                	mov    (%eax),%eax
  800f4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4f:	89 01                	mov    %eax,(%ecx)
  800f51:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f54:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f58:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f5c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f60:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f64:	77 de                	ja     800f44 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6a:	74 31                	je     800f9d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f78:	eb 16                	jmp    800f90 <memcpy+0x66>
			*d8++ = *s8++;
  800f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 dd                	jne    800f7a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fba:	73 50                	jae    80100c <memmove+0x6a>
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc7:	76 43                	jbe    80100c <memmove+0x6a>
		s += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd5:	eb 10                	jmp    800fe7 <memmove+0x45>
			*--d = *--s;
  800fd7:	ff 4d f8             	decl   -0x8(%ebp)
  800fda:	ff 4d fc             	decl   -0x4(%ebp)
  800fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe0:	8a 10                	mov    (%eax),%dl
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 e3                	jne    800fd7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff4:	eb 23                	jmp    801019 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801002:	8d 4a 01             	lea    0x1(%edx),%ecx
  801005:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801008:	8a 12                	mov    (%edx),%dl
  80100a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 dd                	jne    800ff6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801030:	eb 2a                	jmp    80105c <memcmp+0x3e>
		if (*s1 != *s2)
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 10                	mov    (%eax),%dl
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	38 c2                	cmp    %al,%dl
  80103e:	74 16                	je     801056 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f b6 c0             	movzbl %al,%eax
  801050:	29 c2                	sub    %eax,%edx
  801052:	89 d0                	mov    %edx,%eax
  801054:	eb 18                	jmp    80106e <memcmp+0x50>
		s1++, s2++;
  801056:	ff 45 fc             	incl   -0x4(%ebp)
  801059:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 c9                	jne    801032 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801081:	eb 15                	jmp    801098 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f b6 d0             	movzbl %al,%edx
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	0f b6 c0             	movzbl %al,%eax
  801091:	39 c2                	cmp    %eax,%edx
  801093:	74 0d                	je     8010a2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109e:	72 e3                	jb     801083 <memfind+0x13>
  8010a0:	eb 01                	jmp    8010a3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a2:	90                   	nop
	return (void *) s;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bc:	eb 03                	jmp    8010c1 <strtol+0x19>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 20                	cmp    $0x20,%al
  8010c8:	74 f4                	je     8010be <strtol+0x16>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 09                	cmp    $0x9,%al
  8010d1:	74 eb                	je     8010be <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2b                	cmp    $0x2b,%al
  8010da:	75 05                	jne    8010e1 <strtol+0x39>
		s++;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	eb 13                	jmp    8010f4 <strtol+0x4c>
	else if (*s == '-')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2d                	cmp    $0x2d,%al
  8010e8:	75 0a                	jne    8010f4 <strtol+0x4c>
		s++, neg = 1;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f8:	74 06                	je     801100 <strtol+0x58>
  8010fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fe:	75 20                	jne    801120 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 17                	jne    801120 <strtol+0x78>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	40                   	inc    %eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 78                	cmp    $0x78,%al
  801111:	75 0d                	jne    801120 <strtol+0x78>
		s += 2, base = 16;
  801113:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801117:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111e:	eb 28                	jmp    801148 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	75 15                	jne    80113b <strtol+0x93>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 30                	cmp    $0x30,%al
  80112d:	75 0c                	jne    80113b <strtol+0x93>
		s++, base = 8;
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801139:	eb 0d                	jmp    801148 <strtol+0xa0>
	else if (base == 0)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	75 07                	jne    801148 <strtol+0xa0>
		base = 10;
  801141:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 2f                	cmp    $0x2f,%al
  80114f:	7e 19                	jle    80116a <strtol+0xc2>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 39                	cmp    $0x39,%al
  801158:	7f 10                	jg     80116a <strtol+0xc2>
			dig = *s - '0';
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 30             	sub    $0x30,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801168:	eb 42                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 60                	cmp    $0x60,%al
  801171:	7e 19                	jle    80118c <strtol+0xe4>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 7a                	cmp    $0x7a,%al
  80117a:	7f 10                	jg     80118c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	0f be c0             	movsbl %al,%eax
  801184:	83 e8 57             	sub    $0x57,%eax
  801187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118a:	eb 20                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 40                	cmp    $0x40,%al
  801193:	7e 39                	jle    8011ce <strtol+0x126>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 5a                	cmp    $0x5a,%al
  80119c:	7f 30                	jg     8011ce <strtol+0x126>
			dig = *s - 'A' + 10;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 e8 37             	sub    $0x37,%eax
  8011a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b2:	7d 19                	jge    8011cd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c8:	e9 7b ff ff ff       	jmp    801148 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	74 08                	je     8011dc <strtol+0x134>
		*endptr = (char *) s;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e0:	74 07                	je     8011e9 <strtol+0x141>
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	f7 d8                	neg    %eax
  8011e7:	eb 03                	jmp    8011ec <strtol+0x144>
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <ltostr>:

void
ltostr(long value, char *str)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801206:	79 13                	jns    80121b <ltostr+0x2d>
	{
		neg = 1;
  801208:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801215:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801218:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801223:	99                   	cltd   
  801224:	f7 f9                	idiv   %ecx
  801226:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801229:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123c:	83 c2 30             	add    $0x30,%edx
  80123f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801241:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801244:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801249:	f7 e9                	imul   %ecx
  80124b:	c1 fa 02             	sar    $0x2,%edx
  80124e:	89 c8                	mov    %ecx,%eax
  801250:	c1 f8 1f             	sar    $0x1f,%eax
  801253:	29 c2                	sub    %eax,%edx
  801255:	89 d0                	mov    %edx,%eax
  801257:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125e:	75 bb                	jne    80121b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	48                   	dec    %eax
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801272:	74 3d                	je     8012b1 <ltostr+0xc3>
		start = 1 ;
  801274:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127b:	eb 34                	jmp    8012b1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 c2                	add    %eax,%edx
  801292:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	01 c8                	add    %ecx,%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b7:	7c c4                	jl     80127d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 c4 f9 ff ff       	call   800c99 <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	e8 b6 f9 ff ff       	call   800c99 <strlen>
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f7:	eb 17                	jmp    801310 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130d:	ff 45 fc             	incl   -0x4(%ebp)
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801316:	7c e1                	jl     8012f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801326:	eb 1f                	jmp    801347 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801344:	ff 45 f8             	incl   -0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c d9                	jl     801328 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	eb 0c                	jmp    80138e <strsplit+0x31>
			*string++ = 0;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	89 55 08             	mov    %edx,0x8(%ebp)
  80138b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	84 c0                	test   %al,%al
  801395:	74 18                	je     8013af <strsplit+0x52>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f be c0             	movsbl %al,%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 83 fa ff ff       	call   800e2b <strchr>
  8013a8:	83 c4 08             	add    $0x8,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 d3                	jne    801382 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 5a                	je     801412 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	83 f8 0f             	cmp    $0xf,%eax
  8013c0:	75 07                	jne    8013c9 <strsplit+0x6c>
		{
			return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb 66                	jmp    80142f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8b 00                	mov    (%eax),%eax
  8013ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d4:	89 0a                	mov    %ecx,(%edx)
  8013d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e7:	eb 03                	jmp    8013ec <strsplit+0x8f>
			string++;
  8013e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 8b                	je     801380 <strsplit+0x23>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f be c0             	movsbl %al,%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	e8 25 fa ff ff       	call   800e2b <strchr>
  801406:	83 c4 08             	add    $0x8,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 dc                	je     8013e9 <strsplit+0x8c>
			string++;
	}
  80140d:	e9 6e ff ff ff       	jmp    801380 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801412:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801444:	eb 4a                	jmp    801490 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80145a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	3c 40                	cmp    $0x40,%al
  801466:	7e 25                	jle    80148d <str2lower+0x5c>
  801468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 5a                	cmp    $0x5a,%al
  801474:	7f 17                	jg     80148d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
  801484:	01 ca                	add    %ecx,%edx
  801486:	8a 12                	mov    (%edx),%dl
  801488:	83 c2 20             	add    $0x20,%edx
  80148b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80148d:	ff 45 fc             	incl   -0x4(%ebp)
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	e8 01 f8 ff ff       	call   800c99 <strlen>
  801498:	83 c4 04             	add    $0x4,%esp
  80149b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80149e:	7f a6                	jg     801446 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 42                	je     8014f6 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	68 00 00 00 82       	push   $0x82000000
  8014bc:	68 00 00 00 80       	push   $0x80000000
  8014c1:	e8 00 08 00 00       	call   801cc6 <initialize_dynamic_allocator>
  8014c6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014c9:	e8 e7 05 00 00       	call   801ab5 <sys_get_uheap_strategy>
  8014ce:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014d3:	a1 40 40 80 00       	mov    0x804040,%eax
  8014d8:	05 00 10 00 00       	add    $0x1000,%eax
  8014dd:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014e2:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8014e7:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8014ec:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8014f3:	00 00 00 
	}
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801508:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	68 06 04 00 00       	push   $0x406
  801515:	50                   	push   %eax
  801516:	e8 e4 01 00 00       	call   8016ff <__sys_allocate_page>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801525:	79 14                	jns    80153b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 68 31 80 00       	push   $0x803168
  80152f:	6a 1f                	push   $0x1f
  801531:	68 a4 31 80 00       	push   $0x8031a4
  801536:	e8 b7 ed ff ff       	call   8002f2 <_panic>
	return 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80154e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801551:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	50                   	push   %eax
  80155a:	e8 e7 01 00 00       	call   801746 <__sys_unmap_frame>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801569:	79 14                	jns    80157f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	68 b0 31 80 00       	push   $0x8031b0
  801573:	6a 2a                	push   $0x2a
  801575:	68 a4 31 80 00       	push   $0x8031a4
  80157a:	e8 73 ed ff ff       	call   8002f2 <_panic>
}
  80157f:	90                   	nop
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801588:	e8 18 ff ff ff       	call   8014a5 <uheap_init>
	if (size == 0) return NULL ;
  80158d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801591:	75 07                	jne    80159a <malloc+0x18>
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 14                	jmp    8015ae <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	68 f0 31 80 00       	push   $0x8031f0
  8015a2:	6a 3e                	push   $0x3e
  8015a4:	68 a4 31 80 00       	push   $0x8031a4
  8015a9:	e8 44 ed ff ff       	call   8002f2 <_panic>
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 18 32 80 00       	push   $0x803218
  8015be:	6a 49                	push   $0x49
  8015c0:	68 a4 31 80 00       	push   $0x8031a4
  8015c5:	e8 28 ed ff ff       	call   8002f2 <_panic>

008015ca <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 18             	sub    $0x18,%esp
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015d6:	e8 ca fe ff ff       	call   8014a5 <uheap_init>
	if (size == 0) return NULL ;
  8015db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015df:	75 07                	jne    8015e8 <smalloc+0x1e>
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e6:	eb 14                	jmp    8015fc <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 3c 32 80 00       	push   $0x80323c
  8015f0:	6a 5a                	push   $0x5a
  8015f2:	68 a4 31 80 00       	push   $0x8031a4
  8015f7:	e8 f6 ec ff ff       	call   8002f2 <_panic>
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801604:	e8 9c fe ff ff       	call   8014a5 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	68 64 32 80 00       	push   $0x803264
  801611:	6a 6a                	push   $0x6a
  801613:	68 a4 31 80 00       	push   $0x8031a4
  801618:	e8 d5 ec ff ff       	call   8002f2 <_panic>

0080161d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801623:	e8 7d fe ff ff       	call   8014a5 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	68 88 32 80 00       	push   $0x803288
  801630:	68 88 00 00 00       	push   $0x88
  801635:	68 a4 31 80 00       	push   $0x8031a4
  80163a:	e8 b3 ec ff ff       	call   8002f2 <_panic>

0080163f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 b0 32 80 00       	push   $0x8032b0
  80164d:	68 9b 00 00 00       	push   $0x9b
  801652:	68 a4 31 80 00       	push   $0x8031a4
  801657:	e8 96 ec ff ff       	call   8002f2 <_panic>

0080165c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	57                   	push   %edi
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
  801662:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801671:	8b 7d 18             	mov    0x18(%ebp),%edi
  801674:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801677:	cd 30                	int    $0x30
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80167c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
  801690:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801693:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801696:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	6a 00                	push   $0x0
  80169f:	51                   	push   %ecx
  8016a0:	52                   	push   %edx
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	50                   	push   %eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	e8 b0 ff ff ff       	call   80165c <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 02                	push   $0x2
  8016c1:	e8 96 ff ff ff       	call   80165c <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 03                	push   $0x3
  8016da:	e8 7d ff ff ff       	call   80165c <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	90                   	nop
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 04                	push   $0x4
  8016f4:	e8 63 ff ff ff       	call   80165c <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	90                   	nop
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	6a 08                	push   $0x8
  801712:	e8 45 ff ff ff       	call   80165c <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801721:	8b 75 18             	mov    0x18(%ebp),%esi
  801724:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801727:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	51                   	push   %ecx
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 09                	push   $0x9
  801737:	e8 20 ff ff ff       	call   80165c <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 0a                	push   $0xa
  801756:	e8 01 ff ff ff       	call   80165c <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	6a 0b                	push   $0xb
  801771:	e8 e6 fe ff ff       	call   80165c <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 0c                	push   $0xc
  80178a:	e8 cd fe ff ff       	call   80165c <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 0d                	push   $0xd
  8017a3:	e8 b4 fe ff ff       	call   80165c <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 0e                	push   $0xe
  8017bc:	e8 9b fe ff ff       	call   80165c <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 0f                	push   $0xf
  8017d5:	e8 82 fe ff ff       	call   80165c <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	6a 10                	push   $0x10
  8017ef:	e8 68 fe ff ff       	call   80165c <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 11                	push   $0x11
  801808:	e8 4f fe ff ff       	call   80165c <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_cputc>:

void
sys_cputc(const char c)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80181f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	50                   	push   %eax
  80182c:	6a 01                	push   $0x1
  80182e:	e8 29 fe ff ff       	call   80165c <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 14                	push   $0x14
  801848:	e8 0f fe ff ff       	call   80165c <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	8b 45 10             	mov    0x10(%ebp),%eax
  80185c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80185f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801862:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	51                   	push   %ecx
  80186c:	52                   	push   %edx
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	50                   	push   %eax
  801871:	6a 15                	push   $0x15
  801873:	e8 e4 fd ff ff       	call   80165c <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 16                	push   $0x16
  801890:	e8 c7 fd ff ff       	call   80165c <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80189d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	51                   	push   %ecx
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 17                	push   $0x17
  8018af:	e8 a8 fd ff ff       	call   80165c <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 18                	push   $0x18
  8018cc:	e8 8b fd ff ff       	call   80165c <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	ff 75 14             	pushl  0x14(%ebp)
  8018e1:	ff 75 10             	pushl  0x10(%ebp)
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	50                   	push   %eax
  8018e8:	6a 19                	push   $0x19
  8018ea:	e8 6d fd ff ff       	call   80165c <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	50                   	push   %eax
  801903:	6a 1a                	push   $0x1a
  801905:	e8 52 fd ff ff       	call   80165c <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	90                   	nop
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	50                   	push   %eax
  80191f:	6a 1b                	push   $0x1b
  801921:	e8 36 fd ff ff       	call   80165c <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 05                	push   $0x5
  80193a:	e8 1d fd ff ff       	call   80165c <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 06                	push   $0x6
  801953:	e8 04 fd ff ff       	call   80165c <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 07                	push   $0x7
  80196c:	e8 eb fc ff ff       	call   80165c <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_exit_env>:


void sys_exit_env(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 1c                	push   $0x1c
  801985:	e8 d2 fc ff ff       	call   80165c <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801996:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801999:	8d 50 04             	lea    0x4(%eax),%edx
  80199c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 1d                	push   $0x1d
  8019a9:	e8 ae fc ff ff       	call   80165c <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ba:	89 01                	mov    %eax,(%ecx)
  8019bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	c9                   	leave  
  8019c3:	c2 04 00             	ret    $0x4

008019c6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 10             	pushl  0x10(%ebp)
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 13                	push   $0x13
  8019d8:	e8 7f fc ff ff       	call   80165c <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 1e                	push   $0x1e
  8019f2:	e8 65 fc ff ff       	call   80165c <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a08:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	50                   	push   %eax
  801a15:	6a 1f                	push   $0x1f
  801a17:	e8 40 fc ff ff       	call   80165c <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1f:	90                   	nop
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <rsttst>:
void rsttst()
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 21                	push   $0x21
  801a31:	e8 26 fc ff ff       	call   80165c <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
	return ;
  801a39:	90                   	nop
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	8b 45 14             	mov    0x14(%ebp),%eax
  801a45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a48:	8b 55 18             	mov    0x18(%ebp),%edx
  801a4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 20                	push   $0x20
  801a5c:	e8 fb fb ff ff       	call   80165c <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <chktst>:
void chktst(uint32 n)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 22                	push   $0x22
  801a77:	e8 e0 fb ff ff       	call   80165c <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7f:	90                   	nop
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <inctst>:

void inctst()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 23                	push   $0x23
  801a91:	e8 c6 fb ff ff       	call   80165c <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
	return ;
  801a99:	90                   	nop
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <gettst>:
uint32 gettst()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 24                	push   $0x24
  801aab:	e8 ac fb ff ff       	call   80165c <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 25                	push   $0x25
  801ac4:	e8 93 fb ff ff       	call   80165c <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
  801acc:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801ad1:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 26                	push   $0x26
  801af0:	e8 67 fb ff ff       	call   80165c <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	53                   	push   %ebx
  801b0e:	51                   	push   %ecx
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 27                	push   $0x27
  801b13:	e8 44 fb ff ff       	call   80165c <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 28                	push   $0x28
  801b33:	e8 24 fb ff ff       	call   80165c <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 29                	push   $0x29
  801b53:	e8 04 fb ff ff       	call   80165c <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 12                	push   $0x12
  801b6f:	e8 e8 fa ff ff       	call   80165c <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return ;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 2a                	push   $0x2a
  801b8d:	e8 ca fa ff ff       	call   80165c <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 2b                	push   $0x2b
  801ba7:	e8 b0 fa ff ff       	call   80165c <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	ff 75 08             	pushl  0x8(%ebp)
  801bc0:	6a 2d                	push   $0x2d
  801bc2:	e8 95 fa ff ff       	call   80165c <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	ff 75 0c             	pushl  0xc(%ebp)
  801bd9:	ff 75 08             	pushl  0x8(%ebp)
  801bdc:	6a 2c                	push   $0x2c
  801bde:	e8 79 fa ff ff       	call   80165c <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
	return ;
  801be6:	90                   	nop
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 d4 32 80 00       	push   $0x8032d4
  801bf7:	68 25 01 00 00       	push   $0x125
  801bfc:	68 07 33 80 00       	push   $0x803307
  801c01:	e8 ec e6 ff ff       	call   8002f2 <_panic>

00801c06 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801c0c:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801c13:	72 09                	jb     801c1e <to_page_va+0x18>
  801c15:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801c1c:	72 14                	jb     801c32 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 18 33 80 00       	push   $0x803318
  801c26:	6a 15                	push   $0x15
  801c28:	68 43 33 80 00       	push   $0x803343
  801c2d:	e8 c0 e6 ff ff       	call   8002f2 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	ba 60 40 80 00       	mov    $0x804060,%edx
  801c3a:	29 d0                	sub    %edx,%eax
  801c3c:	c1 f8 02             	sar    $0x2,%eax
  801c3f:	89 c2                	mov    %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	c1 e0 02             	shl    $0x2,%eax
  801c46:	01 d0                	add    %edx,%eax
  801c48:	c1 e0 02             	shl    $0x2,%eax
  801c4b:	01 d0                	add    %edx,%eax
  801c4d:	c1 e0 02             	shl    $0x2,%eax
  801c50:	01 d0                	add    %edx,%eax
  801c52:	89 c1                	mov    %eax,%ecx
  801c54:	c1 e1 08             	shl    $0x8,%ecx
  801c57:	01 c8                	add    %ecx,%eax
  801c59:	89 c1                	mov    %eax,%ecx
  801c5b:	c1 e1 10             	shl    $0x10,%ecx
  801c5e:	01 c8                	add    %ecx,%eax
  801c60:	01 c0                	add    %eax,%eax
  801c62:	01 d0                	add    %edx,%eax
  801c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6a:	c1 e0 0c             	shl    $0xc,%eax
  801c6d:	89 c2                	mov    %eax,%edx
  801c6f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c74:	01 d0                	add    %edx,%eax
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801c7e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c83:	8b 55 08             	mov    0x8(%ebp),%edx
  801c86:	29 c2                	sub    %eax,%edx
  801c88:	89 d0                	mov    %edx,%eax
  801c8a:	c1 e8 0c             	shr    $0xc,%eax
  801c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801c90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c94:	78 09                	js     801c9f <to_page_info+0x27>
  801c96:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c9d:	7e 14                	jle    801cb3 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	68 5c 33 80 00       	push   $0x80335c
  801ca7:	6a 22                	push   $0x22
  801ca9:	68 43 33 80 00       	push   $0x803343
  801cae:	e8 3f e6 ff ff       	call   8002f2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	01 c0                	add    %eax,%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	c1 e0 02             	shl    $0x2,%eax
  801cbf:	05 60 40 80 00       	add    $0x804060,%eax
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	05 00 00 00 02       	add    $0x2000000,%eax
  801cd4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cd7:	73 16                	jae    801cef <initialize_dynamic_allocator+0x29>
  801cd9:	68 80 33 80 00       	push   $0x803380
  801cde:	68 a6 33 80 00       	push   $0x8033a6
  801ce3:	6a 34                	push   $0x34
  801ce5:	68 43 33 80 00       	push   $0x803343
  801cea:	e8 03 e6 ff ff       	call   8002f2 <_panic>
		is_initialized = 1;
  801cef:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801cf6:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801d09:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801d10:	00 00 00 
  801d13:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801d1a:	00 00 00 
  801d1d:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801d24:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	2b 45 08             	sub    0x8(%ebp),%eax
  801d2d:	c1 e8 0c             	shr    $0xc,%eax
  801d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d3a:	e9 c8 00 00 00       	jmp    801e07 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d42:	89 d0                	mov    %edx,%eax
  801d44:	01 c0                	add    %eax,%eax
  801d46:	01 d0                	add    %edx,%eax
  801d48:	c1 e0 02             	shl    $0x2,%eax
  801d4b:	05 68 40 80 00       	add    $0x804068,%eax
  801d50:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	01 c0                	add    %eax,%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	c1 e0 02             	shl    $0x2,%eax
  801d61:	05 6a 40 80 00       	add    $0x80406a,%eax
  801d66:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801d6b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d71:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d74:	89 c8                	mov    %ecx,%eax
  801d76:	01 c0                	add    %eax,%eax
  801d78:	01 c8                	add    %ecx,%eax
  801d7a:	c1 e0 02             	shl    $0x2,%eax
  801d7d:	05 64 40 80 00       	add    $0x804064,%eax
  801d82:	89 10                	mov    %edx,(%eax)
  801d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	01 c0                	add    %eax,%eax
  801d8b:	01 d0                	add    %edx,%eax
  801d8d:	c1 e0 02             	shl    $0x2,%eax
  801d90:	05 64 40 80 00       	add    $0x804064,%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	85 c0                	test   %eax,%eax
  801d99:	74 1b                	je     801db6 <initialize_dynamic_allocator+0xf0>
  801d9b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801da1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	01 c0                	add    %eax,%eax
  801da8:	01 c8                	add    %ecx,%eax
  801daa:	c1 e0 02             	shl    $0x2,%eax
  801dad:	05 60 40 80 00       	add    $0x804060,%eax
  801db2:	89 02                	mov    %eax,(%edx)
  801db4:	eb 16                	jmp    801dcc <initialize_dynamic_allocator+0x106>
  801db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	01 c0                	add    %eax,%eax
  801dbd:	01 d0                	add    %edx,%eax
  801dbf:	c1 e0 02             	shl    $0x2,%eax
  801dc2:	05 60 40 80 00       	add    $0x804060,%eax
  801dc7:	a3 48 40 80 00       	mov    %eax,0x804048
  801dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcf:	89 d0                	mov    %edx,%eax
  801dd1:	01 c0                	add    %eax,%eax
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	c1 e0 02             	shl    $0x2,%eax
  801dd8:	05 60 40 80 00       	add    $0x804060,%eax
  801ddd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de5:	89 d0                	mov    %edx,%eax
  801de7:	01 c0                	add    %eax,%eax
  801de9:	01 d0                	add    %edx,%eax
  801deb:	c1 e0 02             	shl    $0x2,%eax
  801dee:	05 60 40 80 00       	add    $0x804060,%eax
  801df3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801df9:	a1 54 40 80 00       	mov    0x804054,%eax
  801dfe:	40                   	inc    %eax
  801dff:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e04:	ff 45 f4             	incl   -0xc(%ebp)
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e0d:	0f 8c 2c ff ff ff    	jl     801d3f <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e1a:	eb 36                	jmp    801e52 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1f:	c1 e0 04             	shl    $0x4,%eax
  801e22:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	c1 e0 04             	shl    $0x4,%eax
  801e33:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	c1 e0 04             	shl    $0x4,%eax
  801e44:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e4f:	ff 45 f0             	incl   -0x10(%ebp)
  801e52:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801e56:	7e c4                	jle    801e1c <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801e58:	90                   	nop
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	50                   	push   %eax
  801e68:	e8 0b fe ff ff       	call   801c78 <to_page_info>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 40 08             	mov    0x8(%eax),%eax
  801e79:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	e8 77 fd ff ff       	call   801c06 <to_page_va>
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801e95:	b8 00 10 00 00       	mov    $0x1000,%eax
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	f7 75 08             	divl   0x8(%ebp)
  801ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	50                   	push   %eax
  801eac:	e8 48 f6 ff ff       	call   8014f9 <get_page>
  801eb1:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801eb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eba:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec4:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801ecf:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801ed6:	eb 19                	jmp    801ef1 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edb:	ba 01 00 00 00       	mov    $0x1,%edx
  801ee0:	88 c1                	mov    %al,%cl
  801ee2:	d3 e2                	shl    %cl,%edx
  801ee4:	89 d0                	mov    %edx,%eax
  801ee6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ee9:	74 0e                	je     801ef9 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801eeb:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801eee:	ff 45 f0             	incl   -0x10(%ebp)
  801ef1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801ef5:	7e e1                	jle    801ed8 <split_page_to_blocks+0x5a>
  801ef7:	eb 01                	jmp    801efa <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801ef9:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801efa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f01:	e9 a7 00 00 00       	jmp    801fad <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	0f af 45 08          	imul   0x8(%ebp),%eax
  801f0d:	89 c2                	mov    %eax,%edx
  801f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f12:	01 d0                	add    %edx,%eax
  801f14:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801f17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f1b:	75 14                	jne    801f31 <split_page_to_blocks+0xb3>
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	68 bc 33 80 00       	push   $0x8033bc
  801f25:	6a 7c                	push   $0x7c
  801f27:	68 43 33 80 00       	push   $0x803343
  801f2c:	e8 c1 e3 ff ff       	call   8002f2 <_panic>
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	c1 e0 04             	shl    $0x4,%eax
  801f37:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f3c:	8b 10                	mov    (%eax),%edx
  801f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f41:	89 50 04             	mov    %edx,0x4(%eax)
  801f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f47:	8b 40 04             	mov    0x4(%eax),%eax
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	74 14                	je     801f62 <split_page_to_blocks+0xe4>
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	c1 e0 04             	shl    $0x4,%eax
  801f54:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f59:	8b 00                	mov    (%eax),%eax
  801f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f5e:	89 10                	mov    %edx,(%eax)
  801f60:	eb 11                	jmp    801f73 <split_page_to_blocks+0xf5>
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	c1 e0 04             	shl    $0x4,%eax
  801f68:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f71:	89 02                	mov    %eax,(%edx)
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	c1 e0 04             	shl    $0x4,%eax
  801f79:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f82:	89 02                	mov    %eax,(%edx)
  801f84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	c1 e0 04             	shl    $0x4,%eax
  801f93:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f98:	8b 00                	mov    (%eax),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	c1 e0 04             	shl    $0x4,%eax
  801fa3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fa8:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801faa:	ff 45 ec             	incl   -0x14(%ebp)
  801fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801fb3:	0f 82 4d ff ff ff    	jb     801f06 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801fb9:	90                   	nop
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801fc2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801fc9:	76 19                	jbe    801fe4 <alloc_block+0x28>
  801fcb:	68 e0 33 80 00       	push   $0x8033e0
  801fd0:	68 a6 33 80 00       	push   $0x8033a6
  801fd5:	68 8a 00 00 00       	push   $0x8a
  801fda:	68 43 33 80 00       	push   $0x803343
  801fdf:	e8 0e e3 ff ff       	call   8002f2 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801fe4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801feb:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801ff2:	eb 19                	jmp    80200d <alloc_block+0x51>
		if((1 << i) >= size) break;
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff7:	ba 01 00 00 00       	mov    $0x1,%edx
  801ffc:	88 c1                	mov    %al,%cl
  801ffe:	d3 e2                	shl    %cl,%edx
  802000:	89 d0                	mov    %edx,%eax
  802002:	3b 45 08             	cmp    0x8(%ebp),%eax
  802005:	73 0e                	jae    802015 <alloc_block+0x59>
		idx++;
  802007:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80200a:	ff 45 f0             	incl   -0x10(%ebp)
  80200d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802011:	7e e1                	jle    801ff4 <alloc_block+0x38>
  802013:	eb 01                	jmp    802016 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802015:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	c1 e0 04             	shl    $0x4,%eax
  80201c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802021:	8b 00                	mov    (%eax),%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	0f 84 df 00 00 00    	je     80210a <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	c1 e0 04             	shl    $0x4,%eax
  802031:	05 80 c0 81 00       	add    $0x81c080,%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80203b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80203f:	75 17                	jne    802058 <alloc_block+0x9c>
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	68 01 34 80 00       	push   $0x803401
  802049:	68 9e 00 00 00       	push   $0x9e
  80204e:	68 43 33 80 00       	push   $0x803343
  802053:	e8 9a e2 ff ff       	call   8002f2 <_panic>
  802058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 10                	je     802071 <alloc_block+0xb5>
  802061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802064:	8b 00                	mov    (%eax),%eax
  802066:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802069:	8b 52 04             	mov    0x4(%edx),%edx
  80206c:	89 50 04             	mov    %edx,0x4(%eax)
  80206f:	eb 14                	jmp    802085 <alloc_block+0xc9>
  802071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802074:	8b 40 04             	mov    0x4(%eax),%eax
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	c1 e2 04             	shl    $0x4,%edx
  80207d:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802083:	89 02                	mov    %eax,(%edx)
  802085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802088:	8b 40 04             	mov    0x4(%eax),%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	74 0f                	je     80209e <alloc_block+0xe2>
  80208f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802092:	8b 40 04             	mov    0x4(%eax),%eax
  802095:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802098:	8b 12                	mov    (%edx),%edx
  80209a:	89 10                	mov    %edx,(%eax)
  80209c:	eb 13                	jmp    8020b1 <alloc_block+0xf5>
  80209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a1:	8b 00                	mov    (%eax),%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8020af:	89 02                	mov    %eax,(%edx)
  8020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	c1 e0 04             	shl    $0x4,%eax
  8020ca:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020cf:	8b 00                	mov    (%eax),%eax
  8020d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c1 e0 04             	shl    $0x4,%eax
  8020da:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020df:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8020e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	50                   	push   %eax
  8020e8:	e8 8b fb ff ff       	call   801c78 <to_page_info>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8020f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8020fa:	48                   	dec    %eax
  8020fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020fe:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802105:	e9 bc 02 00 00       	jmp    8023c6 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80210a:	a1 54 40 80 00       	mov    0x804054,%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	0f 84 7d 02 00 00    	je     802394 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802117:	a1 48 40 80 00       	mov    0x804048,%eax
  80211c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80211f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802123:	75 17                	jne    80213c <alloc_block+0x180>
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 01 34 80 00       	push   $0x803401
  80212d:	68 a9 00 00 00       	push   $0xa9
  802132:	68 43 33 80 00       	push   $0x803343
  802137:	e8 b6 e1 ff ff       	call   8002f2 <_panic>
  80213c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	85 c0                	test   %eax,%eax
  802143:	74 10                	je     802155 <alloc_block+0x199>
  802145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802148:	8b 00                	mov    (%eax),%eax
  80214a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80214d:	8b 52 04             	mov    0x4(%edx),%edx
  802150:	89 50 04             	mov    %edx,0x4(%eax)
  802153:	eb 0b                	jmp    802160 <alloc_block+0x1a4>
  802155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802158:	8b 40 04             	mov    0x4(%eax),%eax
  80215b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802163:	8b 40 04             	mov    0x4(%eax),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 0f                	je     802179 <alloc_block+0x1bd>
  80216a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216d:	8b 40 04             	mov    0x4(%eax),%eax
  802170:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802173:	8b 12                	mov    (%edx),%edx
  802175:	89 10                	mov    %edx,(%eax)
  802177:	eb 0a                	jmp    802183 <alloc_block+0x1c7>
  802179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	a3 48 40 80 00       	mov    %eax,0x804048
  802183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802196:	a1 54 40 80 00       	mov    0x804054,%eax
  80219b:	48                   	dec    %eax
  80219c:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	83 c0 03             	add    $0x3,%eax
  8021a7:	ba 01 00 00 00       	mov    $0x1,%edx
  8021ac:	88 c1                	mov    %al,%cl
  8021ae:	d3 e2                	shl    %cl,%edx
  8021b0:	89 d0                	mov    %edx,%eax
  8021b2:	83 ec 08             	sub    $0x8,%esp
  8021b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021b8:	50                   	push   %eax
  8021b9:	e8 c0 fc ff ff       	call   801e7e <split_page_to_blocks>
  8021be:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	c1 e0 04             	shl    $0x4,%eax
  8021c7:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021d5:	75 17                	jne    8021ee <alloc_block+0x232>
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 01 34 80 00       	push   $0x803401
  8021df:	68 b0 00 00 00       	push   $0xb0
  8021e4:	68 43 33 80 00       	push   $0x803343
  8021e9:	e8 04 e1 ff ff       	call   8002f2 <_panic>
  8021ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 10                	je     802207 <alloc_block+0x24b>
  8021f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021ff:	8b 52 04             	mov    0x4(%edx),%edx
  802202:	89 50 04             	mov    %edx,0x4(%eax)
  802205:	eb 14                	jmp    80221b <alloc_block+0x25f>
  802207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220a:	8b 40 04             	mov    0x4(%eax),%eax
  80220d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802210:	c1 e2 04             	shl    $0x4,%edx
  802213:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802219:	89 02                	mov    %eax,(%edx)
  80221b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 0f                	je     802234 <alloc_block+0x278>
  802225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802228:	8b 40 04             	mov    0x4(%eax),%eax
  80222b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80222e:	8b 12                	mov    (%edx),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	eb 13                	jmp    802247 <alloc_block+0x28b>
  802234:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223c:	c1 e2 04             	shl    $0x4,%edx
  80223f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802245:	89 02                	mov    %eax,(%edx)
  802247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	c1 e0 04             	shl    $0x4,%eax
  802260:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	8d 50 ff             	lea    -0x1(%eax),%edx
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	c1 e0 04             	shl    $0x4,%eax
  802270:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802275:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802277:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227a:	83 ec 0c             	sub    $0xc,%esp
  80227d:	50                   	push   %eax
  80227e:	e8 f5 f9 ff ff       	call   801c78 <to_page_info>
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802289:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80228c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802290:	48                   	dec    %eax
  802291:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802294:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229b:	e9 26 01 00 00       	jmp    8023c6 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8022a0:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	c1 e0 04             	shl    $0x4,%eax
  8022a9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	0f 84 dc 00 00 00    	je     802394 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	c1 e0 04             	shl    $0x4,%eax
  8022be:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022cc:	75 17                	jne    8022e5 <alloc_block+0x329>
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	68 01 34 80 00       	push   $0x803401
  8022d6:	68 be 00 00 00       	push   $0xbe
  8022db:	68 43 33 80 00       	push   $0x803343
  8022e0:	e8 0d e0 ff ff       	call   8002f2 <_panic>
  8022e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 10                	je     8022fe <alloc_block+0x342>
  8022ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022f6:	8b 52 04             	mov    0x4(%edx),%edx
  8022f9:	89 50 04             	mov    %edx,0x4(%eax)
  8022fc:	eb 14                	jmp    802312 <alloc_block+0x356>
  8022fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	c1 e2 04             	shl    $0x4,%edx
  80230a:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802310:	89 02                	mov    %eax,(%edx)
  802312:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 0f                	je     80232b <alloc_block+0x36f>
  80231c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802325:	8b 12                	mov    (%edx),%edx
  802327:	89 10                	mov    %edx,(%eax)
  802329:	eb 13                	jmp    80233e <alloc_block+0x382>
  80232b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802333:	c1 e2 04             	shl    $0x4,%edx
  802336:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80233c:	89 02                	mov    %eax,(%edx)
  80233e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802341:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802347:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	c1 e0 04             	shl    $0x4,%eax
  802357:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	c1 e0 04             	shl    $0x4,%eax
  802367:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80236c:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80236e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802371:	83 ec 0c             	sub    $0xc,%esp
  802374:	50                   	push   %eax
  802375:	e8 fe f8 ff ff       	call   801c78 <to_page_info>
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802383:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802387:	48                   	dec    %eax
  802388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80238b:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80238f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802392:	eb 32                	jmp    8023c6 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802394:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802398:	77 15                	ja     8023af <alloc_block+0x3f3>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	c1 e0 04             	shl    $0x4,%eax
  8023a0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	0f 84 f1 fe ff ff    	je     8022a0 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 1f 34 80 00       	push   $0x80341f
  8023b7:	68 c8 00 00 00       	push   $0xc8
  8023bc:	68 43 33 80 00       	push   $0x803343
  8023c1:	e8 2c df ff ff       	call   8002f2 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023d6:	39 c2                	cmp    %eax,%edx
  8023d8:	72 0c                	jb     8023e6 <free_block+0x1e>
  8023da:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dd:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e2:	39 c2                	cmp    %eax,%edx
  8023e4:	72 19                	jb     8023ff <free_block+0x37>
  8023e6:	68 30 34 80 00       	push   $0x803430
  8023eb:	68 a6 33 80 00       	push   $0x8033a6
  8023f0:	68 d7 00 00 00       	push   $0xd7
  8023f5:	68 43 33 80 00       	push   $0x803343
  8023fa:	e8 f3 de ff ff       	call   8002f2 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	50                   	push   %eax
  80240c:	e8 67 f8 ff ff       	call   801c78 <to_page_info>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241a:	8b 40 08             	mov    0x8(%eax),%eax
  80241d:	0f b7 c0             	movzwl %ax,%eax
  802420:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80242a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802431:	eb 19                	jmp    80244c <free_block+0x84>
	    if ((1 << i) == blk_size)
  802433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802436:	ba 01 00 00 00       	mov    $0x1,%edx
  80243b:	88 c1                	mov    %al,%cl
  80243d:	d3 e2                	shl    %cl,%edx
  80243f:	89 d0                	mov    %edx,%eax
  802441:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802444:	74 0e                	je     802454 <free_block+0x8c>
	        break;
	    idx++;
  802446:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802449:	ff 45 f0             	incl   -0x10(%ebp)
  80244c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802450:	7e e1                	jle    802433 <free_block+0x6b>
  802452:	eb 01                	jmp    802455 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802454:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802458:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80245c:	40                   	inc    %eax
  80245d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802460:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802464:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802468:	75 17                	jne    802481 <free_block+0xb9>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 bc 33 80 00       	push   $0x8033bc
  802472:	68 ee 00 00 00       	push   $0xee
  802477:	68 43 33 80 00       	push   $0x803343
  80247c:	e8 71 de ff ff       	call   8002f2 <_panic>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	c1 e0 04             	shl    $0x4,%eax
  802487:	05 84 c0 81 00       	add    $0x81c084,%eax
  80248c:	8b 10                	mov    (%eax),%edx
  80248e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 14                	je     8024b2 <free_block+0xea>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	c1 e0 04             	shl    $0x4,%eax
  8024a4:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ae:	89 10                	mov    %edx,(%eax)
  8024b0:	eb 11                	jmp    8024c3 <free_block+0xfb>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	c1 e0 04             	shl    $0x4,%eax
  8024b8:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8024be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c1:	89 02                	mov    %eax,(%edx)
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	c1 e0 04             	shl    $0x4,%eax
  8024c9:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8024cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d2:	89 02                	mov    %eax,(%edx)
  8024d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	c1 e0 04             	shl    $0x4,%eax
  8024e3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8d 50 01             	lea    0x1(%eax),%edx
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	c1 e0 04             	shl    $0x4,%eax
  8024f3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024f8:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8024fa:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802504:	f7 75 e0             	divl   -0x20(%ebp)
  802507:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80250a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802511:	0f b7 c0             	movzwl %ax,%eax
  802514:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802517:	0f 85 70 01 00 00    	jne    80268d <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	ff 75 e4             	pushl  -0x1c(%ebp)
  802523:	e8 de f6 ff ff       	call   801c06 <to_page_va>
  802528:	83 c4 10             	add    $0x10,%esp
  80252b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80252e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802535:	e9 b7 00 00 00       	jmp    8025f1 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80253a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	01 d0                	add    %edx,%eax
  802542:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802545:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802549:	75 17                	jne    802562 <free_block+0x19a>
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	68 01 34 80 00       	push   $0x803401
  802553:	68 f8 00 00 00       	push   $0xf8
  802558:	68 43 33 80 00       	push   $0x803343
  80255d:	e8 90 dd ff ff       	call   8002f2 <_panic>
  802562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 10                	je     80257b <free_block+0x1b3>
  80256b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802573:	8b 52 04             	mov    0x4(%edx),%edx
  802576:	89 50 04             	mov    %edx,0x4(%eax)
  802579:	eb 14                	jmp    80258f <free_block+0x1c7>
  80257b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	c1 e2 04             	shl    $0x4,%edx
  802587:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80258d:	89 02                	mov    %eax,(%edx)
  80258f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 0f                	je     8025a8 <free_block+0x1e0>
  802599:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025a2:	8b 12                	mov    (%edx),%edx
  8025a4:	89 10                	mov    %edx,(%eax)
  8025a6:	eb 13                	jmp    8025bb <free_block+0x1f3>
  8025a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	c1 e2 04             	shl    $0x4,%edx
  8025b3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8025b9:	89 02                	mov    %eax,(%edx)
  8025bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	c1 e0 04             	shl    $0x4,%eax
  8025d4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c1 e0 04             	shl    $0x4,%eax
  8025e4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025e9:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ee:	01 45 ec             	add    %eax,-0x14(%ebp)
  8025f1:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8025f8:	0f 86 3c ff ff ff    	jbe    80253a <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802614:	75 17                	jne    80262d <free_block+0x265>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 bc 33 80 00       	push   $0x8033bc
  80261e:	68 fe 00 00 00       	push   $0xfe
  802623:	68 43 33 80 00       	push   $0x803343
  802628:	e8 c5 dc ff ff       	call   8002f2 <_panic>
  80262d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	89 50 04             	mov    %edx,0x4(%eax)
  802639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 0c                	je     80264f <free_block+0x287>
  802643:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802648:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264b:	89 10                	mov    %edx,(%eax)
  80264d:	eb 08                	jmp    802657 <free_block+0x28f>
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	a3 48 40 80 00       	mov    %eax,0x804048
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802668:	a1 54 40 80 00       	mov    0x804054,%eax
  80266d:	40                   	inc    %eax
  80266e:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 e4             	pushl  -0x1c(%ebp)
  802679:	e8 88 f5 ff ff       	call   801c06 <to_page_va>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	83 ec 0c             	sub    $0xc,%esp
  802684:	50                   	push   %eax
  802685:	e8 b8 ee ff ff       	call   801542 <return_page>
  80268a:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80268d:	90                   	nop
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802696:	83 ec 04             	sub    $0x4,%esp
  802699:	68 68 34 80 00       	push   $0x803468
  80269e:	68 11 01 00 00       	push   $0x111
  8026a3:	68 43 33 80 00       	push   $0x803343
  8026a8:	e8 45 dc ff ff       	call   8002f2 <_panic>

008026ad <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	89 d0                	mov    %edx,%eax
  8026b8:	c1 e0 02             	shl    $0x2,%eax
  8026bb:	01 d0                	add    %edx,%eax
  8026bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c4:	01 d0                	add    %edx,%eax
  8026c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026cd:	01 d0                	add    %edx,%eax
  8026cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	c1 e0 04             	shl    $0x4,%eax
  8026db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8026de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026e5:	0f 31                	rdtsc  
  8026e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026f6:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8026f9:	eb 46                	jmp    802741 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026fb:	0f 31                	rdtsc  
  8026fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802700:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802703:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802706:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802709:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80270c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80270f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	29 c2                	sub    %eax,%edx
  802717:	89 d0                	mov    %edx,%eax
  802719:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80271c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	89 d1                	mov    %edx,%ecx
  802724:	29 c1                	sub    %eax,%ecx
  802726:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272c:	39 c2                	cmp    %eax,%edx
  80272e:	0f 97 c0             	seta   %al
  802731:	0f b6 c0             	movzbl %al,%eax
  802734:	29 c1                	sub    %eax,%ecx
  802736:	89 c8                	mov    %ecx,%eax
  802738:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80273b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80273e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802747:	72 b2                	jb     8026fb <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802749:	90                   	nop
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802759:	eb 03                	jmp    80275e <busy_wait+0x12>
  80275b:	ff 45 fc             	incl   -0x4(%ebp)
  80275e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802761:	3b 45 08             	cmp    0x8(%ebp),%eax
  802764:	72 f5                	jb     80275b <busy_wait+0xf>
	return i;
  802766:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    
  80276b:	90                   	nop

0080276c <__udivdi3>:
  80276c:	55                   	push   %ebp
  80276d:	57                   	push   %edi
  80276e:	56                   	push   %esi
  80276f:	53                   	push   %ebx
  802770:	83 ec 1c             	sub    $0x1c,%esp
  802773:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802777:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80277b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802783:	89 ca                	mov    %ecx,%edx
  802785:	89 f8                	mov    %edi,%eax
  802787:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80278b:	85 f6                	test   %esi,%esi
  80278d:	75 2d                	jne    8027bc <__udivdi3+0x50>
  80278f:	39 cf                	cmp    %ecx,%edi
  802791:	77 65                	ja     8027f8 <__udivdi3+0x8c>
  802793:	89 fd                	mov    %edi,%ebp
  802795:	85 ff                	test   %edi,%edi
  802797:	75 0b                	jne    8027a4 <__udivdi3+0x38>
  802799:	b8 01 00 00 00       	mov    $0x1,%eax
  80279e:	31 d2                	xor    %edx,%edx
  8027a0:	f7 f7                	div    %edi
  8027a2:	89 c5                	mov    %eax,%ebp
  8027a4:	31 d2                	xor    %edx,%edx
  8027a6:	89 c8                	mov    %ecx,%eax
  8027a8:	f7 f5                	div    %ebp
  8027aa:	89 c1                	mov    %eax,%ecx
  8027ac:	89 d8                	mov    %ebx,%eax
  8027ae:	f7 f5                	div    %ebp
  8027b0:	89 cf                	mov    %ecx,%edi
  8027b2:	89 fa                	mov    %edi,%edx
  8027b4:	83 c4 1c             	add    $0x1c,%esp
  8027b7:	5b                   	pop    %ebx
  8027b8:	5e                   	pop    %esi
  8027b9:	5f                   	pop    %edi
  8027ba:	5d                   	pop    %ebp
  8027bb:	c3                   	ret    
  8027bc:	39 ce                	cmp    %ecx,%esi
  8027be:	77 28                	ja     8027e8 <__udivdi3+0x7c>
  8027c0:	0f bd fe             	bsr    %esi,%edi
  8027c3:	83 f7 1f             	xor    $0x1f,%edi
  8027c6:	75 40                	jne    802808 <__udivdi3+0x9c>
  8027c8:	39 ce                	cmp    %ecx,%esi
  8027ca:	72 0a                	jb     8027d6 <__udivdi3+0x6a>
  8027cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027d0:	0f 87 9e 00 00 00    	ja     802874 <__udivdi3+0x108>
  8027d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027db:	89 fa                	mov    %edi,%edx
  8027dd:	83 c4 1c             	add    $0x1c,%esp
  8027e0:	5b                   	pop    %ebx
  8027e1:	5e                   	pop    %esi
  8027e2:	5f                   	pop    %edi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    
  8027e5:	8d 76 00             	lea    0x0(%esi),%esi
  8027e8:	31 ff                	xor    %edi,%edi
  8027ea:	31 c0                	xor    %eax,%eax
  8027ec:	89 fa                	mov    %edi,%edx
  8027ee:	83 c4 1c             	add    $0x1c,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
  8027f6:	66 90                	xchg   %ax,%ax
  8027f8:	89 d8                	mov    %ebx,%eax
  8027fa:	f7 f7                	div    %edi
  8027fc:	31 ff                	xor    %edi,%edi
  8027fe:	89 fa                	mov    %edi,%edx
  802800:	83 c4 1c             	add    $0x1c,%esp
  802803:	5b                   	pop    %ebx
  802804:	5e                   	pop    %esi
  802805:	5f                   	pop    %edi
  802806:	5d                   	pop    %ebp
  802807:	c3                   	ret    
  802808:	bd 20 00 00 00       	mov    $0x20,%ebp
  80280d:	89 eb                	mov    %ebp,%ebx
  80280f:	29 fb                	sub    %edi,%ebx
  802811:	89 f9                	mov    %edi,%ecx
  802813:	d3 e6                	shl    %cl,%esi
  802815:	89 c5                	mov    %eax,%ebp
  802817:	88 d9                	mov    %bl,%cl
  802819:	d3 ed                	shr    %cl,%ebp
  80281b:	89 e9                	mov    %ebp,%ecx
  80281d:	09 f1                	or     %esi,%ecx
  80281f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802823:	89 f9                	mov    %edi,%ecx
  802825:	d3 e0                	shl    %cl,%eax
  802827:	89 c5                	mov    %eax,%ebp
  802829:	89 d6                	mov    %edx,%esi
  80282b:	88 d9                	mov    %bl,%cl
  80282d:	d3 ee                	shr    %cl,%esi
  80282f:	89 f9                	mov    %edi,%ecx
  802831:	d3 e2                	shl    %cl,%edx
  802833:	8b 44 24 08          	mov    0x8(%esp),%eax
  802837:	88 d9                	mov    %bl,%cl
  802839:	d3 e8                	shr    %cl,%eax
  80283b:	09 c2                	or     %eax,%edx
  80283d:	89 d0                	mov    %edx,%eax
  80283f:	89 f2                	mov    %esi,%edx
  802841:	f7 74 24 0c          	divl   0xc(%esp)
  802845:	89 d6                	mov    %edx,%esi
  802847:	89 c3                	mov    %eax,%ebx
  802849:	f7 e5                	mul    %ebp
  80284b:	39 d6                	cmp    %edx,%esi
  80284d:	72 19                	jb     802868 <__udivdi3+0xfc>
  80284f:	74 0b                	je     80285c <__udivdi3+0xf0>
  802851:	89 d8                	mov    %ebx,%eax
  802853:	31 ff                	xor    %edi,%edi
  802855:	e9 58 ff ff ff       	jmp    8027b2 <__udivdi3+0x46>
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802860:	89 f9                	mov    %edi,%ecx
  802862:	d3 e2                	shl    %cl,%edx
  802864:	39 c2                	cmp    %eax,%edx
  802866:	73 e9                	jae    802851 <__udivdi3+0xe5>
  802868:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80286b:	31 ff                	xor    %edi,%edi
  80286d:	e9 40 ff ff ff       	jmp    8027b2 <__udivdi3+0x46>
  802872:	66 90                	xchg   %ax,%ax
  802874:	31 c0                	xor    %eax,%eax
  802876:	e9 37 ff ff ff       	jmp    8027b2 <__udivdi3+0x46>
  80287b:	90                   	nop

0080287c <__umoddi3>:
  80287c:	55                   	push   %ebp
  80287d:	57                   	push   %edi
  80287e:	56                   	push   %esi
  80287f:	53                   	push   %ebx
  802880:	83 ec 1c             	sub    $0x1c,%esp
  802883:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802887:	8b 74 24 34          	mov    0x34(%esp),%esi
  80288b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80288f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80289b:	89 f3                	mov    %esi,%ebx
  80289d:	89 fa                	mov    %edi,%edx
  80289f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028a3:	89 34 24             	mov    %esi,(%esp)
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	75 1a                	jne    8028c4 <__umoddi3+0x48>
  8028aa:	39 f7                	cmp    %esi,%edi
  8028ac:	0f 86 a2 00 00 00    	jbe    802954 <__umoddi3+0xd8>
  8028b2:	89 c8                	mov    %ecx,%eax
  8028b4:	89 f2                	mov    %esi,%edx
  8028b6:	f7 f7                	div    %edi
  8028b8:	89 d0                	mov    %edx,%eax
  8028ba:	31 d2                	xor    %edx,%edx
  8028bc:	83 c4 1c             	add    $0x1c,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    
  8028c4:	39 f0                	cmp    %esi,%eax
  8028c6:	0f 87 ac 00 00 00    	ja     802978 <__umoddi3+0xfc>
  8028cc:	0f bd e8             	bsr    %eax,%ebp
  8028cf:	83 f5 1f             	xor    $0x1f,%ebp
  8028d2:	0f 84 ac 00 00 00    	je     802984 <__umoddi3+0x108>
  8028d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8028dd:	29 ef                	sub    %ebp,%edi
  8028df:	89 fe                	mov    %edi,%esi
  8028e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028e5:	89 e9                	mov    %ebp,%ecx
  8028e7:	d3 e0                	shl    %cl,%eax
  8028e9:	89 d7                	mov    %edx,%edi
  8028eb:	89 f1                	mov    %esi,%ecx
  8028ed:	d3 ef                	shr    %cl,%edi
  8028ef:	09 c7                	or     %eax,%edi
  8028f1:	89 e9                	mov    %ebp,%ecx
  8028f3:	d3 e2                	shl    %cl,%edx
  8028f5:	89 14 24             	mov    %edx,(%esp)
  8028f8:	89 d8                	mov    %ebx,%eax
  8028fa:	d3 e0                	shl    %cl,%eax
  8028fc:	89 c2                	mov    %eax,%edx
  8028fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  802902:	d3 e0                	shl    %cl,%eax
  802904:	89 44 24 04          	mov    %eax,0x4(%esp)
  802908:	8b 44 24 08          	mov    0x8(%esp),%eax
  80290c:	89 f1                	mov    %esi,%ecx
  80290e:	d3 e8                	shr    %cl,%eax
  802910:	09 d0                	or     %edx,%eax
  802912:	d3 eb                	shr    %cl,%ebx
  802914:	89 da                	mov    %ebx,%edx
  802916:	f7 f7                	div    %edi
  802918:	89 d3                	mov    %edx,%ebx
  80291a:	f7 24 24             	mull   (%esp)
  80291d:	89 c6                	mov    %eax,%esi
  80291f:	89 d1                	mov    %edx,%ecx
  802921:	39 d3                	cmp    %edx,%ebx
  802923:	0f 82 87 00 00 00    	jb     8029b0 <__umoddi3+0x134>
  802929:	0f 84 91 00 00 00    	je     8029c0 <__umoddi3+0x144>
  80292f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802933:	29 f2                	sub    %esi,%edx
  802935:	19 cb                	sbb    %ecx,%ebx
  802937:	89 d8                	mov    %ebx,%eax
  802939:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80293d:	d3 e0                	shl    %cl,%eax
  80293f:	89 e9                	mov    %ebp,%ecx
  802941:	d3 ea                	shr    %cl,%edx
  802943:	09 d0                	or     %edx,%eax
  802945:	89 e9                	mov    %ebp,%ecx
  802947:	d3 eb                	shr    %cl,%ebx
  802949:	89 da                	mov    %ebx,%edx
  80294b:	83 c4 1c             	add    $0x1c,%esp
  80294e:	5b                   	pop    %ebx
  80294f:	5e                   	pop    %esi
  802950:	5f                   	pop    %edi
  802951:	5d                   	pop    %ebp
  802952:	c3                   	ret    
  802953:	90                   	nop
  802954:	89 fd                	mov    %edi,%ebp
  802956:	85 ff                	test   %edi,%edi
  802958:	75 0b                	jne    802965 <__umoddi3+0xe9>
  80295a:	b8 01 00 00 00       	mov    $0x1,%eax
  80295f:	31 d2                	xor    %edx,%edx
  802961:	f7 f7                	div    %edi
  802963:	89 c5                	mov    %eax,%ebp
  802965:	89 f0                	mov    %esi,%eax
  802967:	31 d2                	xor    %edx,%edx
  802969:	f7 f5                	div    %ebp
  80296b:	89 c8                	mov    %ecx,%eax
  80296d:	f7 f5                	div    %ebp
  80296f:	89 d0                	mov    %edx,%eax
  802971:	e9 44 ff ff ff       	jmp    8028ba <__umoddi3+0x3e>
  802976:	66 90                	xchg   %ax,%ax
  802978:	89 c8                	mov    %ecx,%eax
  80297a:	89 f2                	mov    %esi,%edx
  80297c:	83 c4 1c             	add    $0x1c,%esp
  80297f:	5b                   	pop    %ebx
  802980:	5e                   	pop    %esi
  802981:	5f                   	pop    %edi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    
  802984:	3b 04 24             	cmp    (%esp),%eax
  802987:	72 06                	jb     80298f <__umoddi3+0x113>
  802989:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80298d:	77 0f                	ja     80299e <__umoddi3+0x122>
  80298f:	89 f2                	mov    %esi,%edx
  802991:	29 f9                	sub    %edi,%ecx
  802993:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802997:	89 14 24             	mov    %edx,(%esp)
  80299a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80299e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029a2:	8b 14 24             	mov    (%esp),%edx
  8029a5:	83 c4 1c             	add    $0x1c,%esp
  8029a8:	5b                   	pop    %ebx
  8029a9:	5e                   	pop    %esi
  8029aa:	5f                   	pop    %edi
  8029ab:	5d                   	pop    %ebp
  8029ac:	c3                   	ret    
  8029ad:	8d 76 00             	lea    0x0(%esi),%esi
  8029b0:	2b 04 24             	sub    (%esp),%eax
  8029b3:	19 fa                	sbb    %edi,%edx
  8029b5:	89 d1                	mov    %edx,%ecx
  8029b7:	89 c6                	mov    %eax,%esi
  8029b9:	e9 71 ff ff ff       	jmp    80292f <__umoddi3+0xb3>
  8029be:	66 90                	xchg   %ax,%ax
  8029c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029c4:	72 ea                	jb     8029b0 <__umoddi3+0x134>
  8029c6:	89 d9                	mov    %ebx,%ecx
  8029c8:	e9 62 ff ff ff       	jmp    80292f <__umoddi3+0xb3>
