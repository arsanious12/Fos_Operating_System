
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_create_shared_object("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 40 1d 80 00       	push   $0x801d40
  80004e:	e8 4b 16 00 00       	call   80169e <sys_create_shared_object>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 40 1d 80 00       	push   $0x801d40
  800063:	50                   	push   %eax
  800064:	e8 e8 19 00 00       	call   801a51 <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 45 1d 80 00       	push   $0x801d45
  800079:	50                   	push   %eax
  80007a:	e8 d2 19 00 00       	call   801a51 <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 30 80 00       	mov    0x803020,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 4d 1d 80 00       	push   $0x801d4d
  8000ad:	e8 6f 16 00 00       	call   801721 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000bd:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c8:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 51 1d 80 00       	push   $0x801d51
  8000e3:	e8 39 16 00 00       	call   801721 <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 55 1d 80 00       	push   $0x801d55
  800102:	6a 11                	push   $0x11
  800104:	68 6a 1d 80 00       	push   $0x801d6a
  800109:	e8 e6 01 00 00       	call   8002f4 <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 25 16 00 00       	call   80173f <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 16 16 00 00       	call   80173f <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800138:	e8 52 16 00 00       	call   80178f <sys_getenvindex>
  80013d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800143:	89 d0                	mov    %edx,%eax
  800145:	c1 e0 06             	shl    $0x6,%eax
  800148:	29 d0                	sub    %edx,%eax
  80014a:	c1 e0 02             	shl    $0x2,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800156:	01 c8                	add    %ecx,%eax
  800158:	c1 e0 03             	shl    $0x3,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800164:	29 c2                	sub    %eax,%edx
  800166:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016d:	89 c2                	mov    %eax,%edx
  80016f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800175:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017a:	a1 20 30 80 00       	mov    0x803020,%eax
  80017f:	8a 40 20             	mov    0x20(%eax),%al
  800182:	84 c0                	test   %al,%al
  800184:	74 0d                	je     800193 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	83 c0 20             	add    $0x20,%eax
  80018e:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x74>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b4:	a1 00 30 80 00       	mov    0x803000,%eax
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	0f 84 01 01 00 00    	je     8002c2 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001c1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c7:	bb 7c 1e 80 00       	mov    $0x801e7c,%ebx
  8001cc:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001d1:	89 c7                	mov    %eax,%edi
  8001d3:	89 de                	mov    %ebx,%esi
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001dc:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001e1:	b0 00                	mov    $0x0,%al
  8001e3:	89 d7                	mov    %edx,%edi
  8001e5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	50                   	push   %eax
  8001f5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	e8 c4 17 00 00       	call   8019c5 <sys_utilities>
  800201:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800204:	e8 0d 13 00 00       	call   801516 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 9c 1d 80 00       	push   $0x801d9c
  800211:	e8 ac 03 00 00       	call   8005c2 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021c:	85 c0                	test   %eax,%eax
  80021e:	74 18                	je     800238 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800220:	e8 be 17 00 00       	call   8019e3 <sys_get_optimal_num_faults>
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 c4 1d 80 00       	push   $0x801dc4
  80022e:	e8 8f 03 00 00       	call   8005c2 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb 59                	jmp    800291 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800243:	a1 20 30 80 00       	mov    0x803020,%eax
  800248:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 e8 1d 80 00       	push   $0x801de8
  800258:	e8 65 03 00 00       	call   8005c2 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80026b:	a1 20 30 80 00       	mov    0x803020,%eax
  800270:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800276:	a1 20 30 80 00       	mov    0x803020,%eax
  80027b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800281:	51                   	push   %ecx
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	68 10 1e 80 00       	push   $0x801e10
  800289:	e8 34 03 00 00       	call   8005c2 <cprintf>
  80028e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800291:	a1 20 30 80 00       	mov    0x803020,%eax
  800296:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 68 1e 80 00       	push   $0x801e68
  8002a5:	e8 18 03 00 00       	call   8005c2 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 9c 1d 80 00       	push   $0x801d9c
  8002b5:	e8 08 03 00 00       	call   8005c2 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002bd:	e8 6e 12 00 00       	call   801530 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c2:	e8 1f 00 00 00       	call   8002e6 <exit>
}
  8002c7:	90                   	nop
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	6a 00                	push   $0x0
  8002db:	e8 7b 14 00 00       	call   80175b <sys_destroy_env>
  8002e0:	83 c4 10             	add    $0x10,%esp
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <exit>:

void
exit(void)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ec:	e8 d0 14 00 00       	call   8017c1 <sys_exit_env>
}
  8002f1:	90                   	nop
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fd:	83 c0 04             	add    $0x4,%eax
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800303:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	74 16                	je     800322 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80030c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	50                   	push   %eax
  800315:	68 e0 1e 80 00       	push   $0x801ee0
  80031a:	e8 a3 02 00 00       	call   8005c2 <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800322:	a1 04 30 80 00       	mov    0x803004,%eax
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	ff 75 0c             	pushl  0xc(%ebp)
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	50                   	push   %eax
  800331:	68 e8 1e 80 00       	push   $0x801ee8
  800336:	6a 74                	push   $0x74
  800338:	e8 b2 02 00 00       	call   8005ef <cprintf_colored>
  80033d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800340:	8b 45 10             	mov    0x10(%ebp),%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	ff 75 f4             	pushl  -0xc(%ebp)
  800349:	50                   	push   %eax
  80034a:	e8 04 02 00 00       	call   800553 <vcprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	6a 00                	push   $0x0
  800357:	68 10 1f 80 00       	push   $0x801f10
  80035c:	e8 f2 01 00 00       	call   800553 <vcprintf>
  800361:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800364:	e8 7d ff ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  800369:	eb fe                	jmp    800369 <_panic+0x75>

0080036b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800371:	a1 20 30 80 00       	mov    0x803020,%eax
  800376:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037f:	39 c2                	cmp    %eax,%edx
  800381:	74 14                	je     800397 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800383:	83 ec 04             	sub    $0x4,%esp
  800386:	68 14 1f 80 00       	push   $0x801f14
  80038b:	6a 26                	push   $0x26
  80038d:	68 60 1f 80 00       	push   $0x801f60
  800392:	e8 5d ff ff ff       	call   8002f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a5:	e9 c5 00 00 00       	jmp    80046f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	75 08                	jne    8003c7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c2:	e9 a5 00 00 00       	jmp    80046c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d5:	eb 69                	jmp    800440 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e5:	89 d0                	mov    %edx,%eax
  8003e7:	01 c0                	add    %eax,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	c1 e0 03             	shl    $0x3,%eax
  8003ee:	01 c8                	add    %ecx,%eax
  8003f0:	8a 40 04             	mov    0x4(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	75 46                	jne    80043d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800405:	89 d0                	mov    %edx,%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	c1 e0 03             	shl    $0x3,%eax
  80040e:	01 c8                	add    %ecx,%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800422:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	39 c2                	cmp    %eax,%edx
  800432:	75 09                	jne    80043d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800434:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043b:	eb 15                	jmp    800452 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	ff 45 e8             	incl   -0x18(%ebp)
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80044b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044e:	39 c2                	cmp    %eax,%edx
  800450:	77 85                	ja     8003d7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800452:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800456:	75 14                	jne    80046c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	68 6c 1f 80 00       	push   $0x801f6c
  800460:	6a 3a                	push   $0x3a
  800462:	68 60 1f 80 00       	push   $0x801f60
  800467:	e8 88 fe ff ff       	call   8002f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046c:	ff 45 f0             	incl   -0x10(%ebp)
  80046f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800472:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800475:	0f 8c 2f ff ff ff    	jl     8003aa <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800489:	eb 26                	jmp    8004b1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800496:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8a 40 04             	mov    0x4(%eax),%al
  8004a7:	3c 01                	cmp    $0x1,%al
  8004a9:	75 03                	jne    8004ae <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004ab:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ae:	ff 45 e0             	incl   -0x20(%ebp)
  8004b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bf:	39 c2                	cmp    %eax,%edx
  8004c1:	77 c8                	ja     80048b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c9:	74 14                	je     8004df <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 c0 1f 80 00       	push   $0x801fc0
  8004d3:	6a 44                	push   $0x44
  8004d5:	68 60 1f 80 00       	push   $0x801f60
  8004da:	e8 15 fe ff ff       	call   8002f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004df:	90                   	nop
  8004e0:	c9                   	leave  
  8004e1:	c3                   	ret    

008004e2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8004f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f4:	89 0a                	mov    %ecx,(%edx)
  8004f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f9:	88 d1                	mov    %dl,%cl
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	3d ff 00 00 00       	cmp    $0xff,%eax
  80050c:	75 30                	jne    80053e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80050e:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800514:	a0 44 30 80 00       	mov    0x803044,%al
  800519:	0f b6 c0             	movzbl %al,%eax
  80051c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051f:	8b 09                	mov    (%ecx),%ecx
  800521:	89 cb                	mov    %ecx,%ebx
  800523:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800526:	83 c1 08             	add    $0x8,%ecx
  800529:	52                   	push   %edx
  80052a:	50                   	push   %eax
  80052b:	53                   	push   %ebx
  80052c:	51                   	push   %ecx
  80052d:	e8 a0 0f 00 00       	call   8014d2 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800541:	8b 40 04             	mov    0x4(%eax),%eax
  800544:	8d 50 01             	lea    0x1(%eax),%edx
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054d:	90                   	nop
  80054e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800551:	c9                   	leave  
  800552:	c3                   	ret    

00800553 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800553:	55                   	push   %ebp
  800554:	89 e5                	mov    %esp,%ebp
  800556:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80055c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800563:	00 00 00 
	b.cnt = 0;
  800566:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800570:	ff 75 0c             	pushl  0xc(%ebp)
  800573:	ff 75 08             	pushl  0x8(%ebp)
  800576:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057c:	50                   	push   %eax
  80057d:	68 e2 04 80 00       	push   $0x8004e2
  800582:	e8 5a 02 00 00       	call   8007e1 <vprintfmt>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80058a:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800590:	a0 44 30 80 00       	mov    0x803044,%al
  800595:	0f b6 c0             	movzbl %al,%eax
  800598:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80059e:	52                   	push   %edx
  80059f:	50                   	push   %eax
  8005a0:	51                   	push   %ecx
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	83 c0 08             	add    $0x8,%eax
  8005aa:	50                   	push   %eax
  8005ab:	e8 22 0f 00 00       	call   8014d2 <sys_cputs>
  8005b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b3:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	50                   	push   %eax
  8005df:	e8 6f ff ff ff       	call   800553 <vcprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	c1 e0 08             	shl    $0x8,%eax
  800602:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800607:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060a:	83 c0 04             	add    $0x4,%eax
  80060d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800610:	8b 45 0c             	mov    0xc(%ebp),%eax
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 f4             	pushl  -0xc(%ebp)
  800619:	50                   	push   %eax
  80061a:	e8 34 ff ff ff       	call   800553 <vcprintf>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800625:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80062c:	07 00 00 

	return cnt;
  80062f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800632:	c9                   	leave  
  800633:	c3                   	ret    

00800634 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80063a:	e8 d7 0e 00 00       	call   801516 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 ff fe ff ff       	call   800553 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80065a:	e8 d1 0e 00 00       	call   801530 <sys_unlock_cons>
	return cnt;
  80065f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	53                   	push   %ebx
  800668:	83 ec 14             	sub    $0x14,%esp
  80066b:	8b 45 10             	mov    0x10(%ebp),%eax
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800677:	8b 45 18             	mov    0x18(%ebp),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800682:	77 55                	ja     8006d9 <printnum+0x75>
  800684:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800687:	72 05                	jb     80068e <printnum+0x2a>
  800689:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80068c:	77 4b                	ja     8006d9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800691:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800694:	8b 45 18             	mov    0x18(%ebp),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
  80069c:	52                   	push   %edx
  80069d:	50                   	push   %eax
  80069e:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a4:	e8 1b 14 00 00       	call   801ac4 <__udivdi3>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	ff 75 20             	pushl  0x20(%ebp)
  8006b2:	53                   	push   %ebx
  8006b3:	ff 75 18             	pushl  0x18(%ebp)
  8006b6:	52                   	push   %edx
  8006b7:	50                   	push   %eax
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 a1 ff ff ff       	call   800664 <printnum>
  8006c3:	83 c4 20             	add    $0x20,%esp
  8006c6:	eb 1a                	jmp    8006e2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	ff 75 20             	pushl  0x20(%ebp)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	ff d0                	call   *%eax
  8006d6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d9:	ff 4d 1c             	decl   0x1c(%ebp)
  8006dc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e0:	7f e6                	jg     8006c8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f0:	53                   	push   %ebx
  8006f1:	51                   	push   %ecx
  8006f2:	52                   	push   %edx
  8006f3:	50                   	push   %eax
  8006f4:	e8 db 14 00 00       	call   801bd4 <__umoddi3>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	05 34 22 80 00       	add    $0x802234,%eax
  800701:	8a 00                	mov    (%eax),%al
  800703:	0f be c0             	movsbl %al,%eax
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	50                   	push   %eax
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800722:	7e 1c                	jle    800740 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	8d 50 08             	lea    0x8(%eax),%edx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 10                	mov    %edx,(%eax)
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	83 e8 08             	sub    $0x8,%eax
  800739:	8b 50 04             	mov    0x4(%eax),%edx
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	eb 40                	jmp    800780 <getuint+0x65>
	else if (lflag)
  800740:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800744:	74 1e                	je     800764 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	eb 1c                	jmp    800780 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	8d 50 04             	lea    0x4(%eax),%edx
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	89 10                	mov    %edx,(%eax)
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	83 e8 04             	sub    $0x4,%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800780:	5d                   	pop    %ebp
  800781:	c3                   	ret    

00800782 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800785:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800789:	7e 1c                	jle    8007a7 <getint+0x25>
		return va_arg(*ap, long long);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	8d 50 08             	lea    0x8(%eax),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	89 10                	mov    %edx,(%eax)
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	83 e8 08             	sub    $0x8,%eax
  8007a0:	8b 50 04             	mov    0x4(%eax),%edx
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	eb 38                	jmp    8007df <getint+0x5d>
	else if (lflag)
  8007a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ab:	74 1a                	je     8007c7 <getint+0x45>
		return va_arg(*ap, long);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	8d 50 04             	lea    0x4(%eax),%edx
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	89 10                	mov    %edx,(%eax)
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	83 e8 04             	sub    $0x4,%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	99                   	cltd   
  8007c5:	eb 18                	jmp    8007df <getint+0x5d>
	else
		return va_arg(*ap, int);
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
}
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	56                   	push   %esi
  8007e5:	53                   	push   %ebx
  8007e6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e9:	eb 17                	jmp    800802 <vprintfmt+0x21>
			if (ch == '\0')
  8007eb:	85 db                	test   %ebx,%ebx
  8007ed:	0f 84 c1 03 00 00    	je     800bb4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	53                   	push   %ebx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	ff d0                	call   *%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800802:	8b 45 10             	mov    0x10(%ebp),%eax
  800805:	8d 50 01             	lea    0x1(%eax),%edx
  800808:	89 55 10             	mov    %edx,0x10(%ebp)
  80080b:	8a 00                	mov    (%eax),%al
  80080d:	0f b6 d8             	movzbl %al,%ebx
  800810:	83 fb 25             	cmp    $0x25,%ebx
  800813:	75 d6                	jne    8007eb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800815:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800819:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800820:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800827:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80082e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800835:	8b 45 10             	mov    0x10(%ebp),%eax
  800838:	8d 50 01             	lea    0x1(%eax),%edx
  80083b:	89 55 10             	mov    %edx,0x10(%ebp)
  80083e:	8a 00                	mov    (%eax),%al
  800840:	0f b6 d8             	movzbl %al,%ebx
  800843:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800846:	83 f8 5b             	cmp    $0x5b,%eax
  800849:	0f 87 3d 03 00 00    	ja     800b8c <vprintfmt+0x3ab>
  80084f:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  800856:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800858:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80085c:	eb d7                	jmp    800835 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80085e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800862:	eb d1                	jmp    800835 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80086b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086e:	89 d0                	mov    %edx,%eax
  800870:	c1 e0 02             	shl    $0x2,%eax
  800873:	01 d0                	add    %edx,%eax
  800875:	01 c0                	add    %eax,%eax
  800877:	01 d8                	add    %ebx,%eax
  800879:	83 e8 30             	sub    $0x30,%eax
  80087c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800887:	83 fb 2f             	cmp    $0x2f,%ebx
  80088a:	7e 3e                	jle    8008ca <vprintfmt+0xe9>
  80088c:	83 fb 39             	cmp    $0x39,%ebx
  80088f:	7f 39                	jg     8008ca <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800891:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800894:	eb d5                	jmp    80086b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	83 c0 04             	add    $0x4,%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	83 e8 04             	sub    $0x4,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008aa:	eb 1f                	jmp    8008cb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b0:	79 83                	jns    800835 <vprintfmt+0x54>
				width = 0;
  8008b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008b9:	e9 77 ff ff ff       	jmp    800835 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008be:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c5:	e9 6b ff ff ff       	jmp    800835 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ca:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cf:	0f 89 60 ff ff ff    	jns    800835 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e2:	e9 4e ff ff ff       	jmp    800835 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ea:	e9 46 ff ff ff       	jmp    800835 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	83 c0 04             	add    $0x4,%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	50                   	push   %eax
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			break;
  80090f:	e9 9b 02 00 00       	jmp    800baf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	83 c0 04             	add    $0x4,%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800925:	85 db                	test   %ebx,%ebx
  800927:	79 02                	jns    80092b <vprintfmt+0x14a>
				err = -err;
  800929:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80092b:	83 fb 64             	cmp    $0x64,%ebx
  80092e:	7f 0b                	jg     80093b <vprintfmt+0x15a>
  800930:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  800937:	85 f6                	test   %esi,%esi
  800939:	75 19                	jne    800954 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80093b:	53                   	push   %ebx
  80093c:	68 45 22 80 00       	push   $0x802245
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	e8 70 02 00 00       	call   800bbc <printfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80094f:	e9 5b 02 00 00       	jmp    800baf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800954:	56                   	push   %esi
  800955:	68 4e 22 80 00       	push   $0x80224e
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	ff 75 08             	pushl  0x8(%ebp)
  800960:	e8 57 02 00 00       	call   800bbc <printfmt>
  800965:	83 c4 10             	add    $0x10,%esp
			break;
  800968:	e9 42 02 00 00       	jmp    800baf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 30                	mov    (%eax),%esi
  80097e:	85 f6                	test   %esi,%esi
  800980:	75 05                	jne    800987 <vprintfmt+0x1a6>
				p = "(null)";
  800982:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  800987:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098b:	7e 6d                	jle    8009fa <vprintfmt+0x219>
  80098d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800991:	74 67                	je     8009fa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	50                   	push   %eax
  80099a:	56                   	push   %esi
  80099b:	e8 1e 03 00 00       	call   800cbe <strnlen>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a6:	eb 16                	jmp    8009be <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	ff d0                	call   *%eax
  8009b8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c2:	7f e4                	jg     8009a8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c4:	eb 34                	jmp    8009fa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ca:	74 1c                	je     8009e8 <vprintfmt+0x207>
  8009cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cf:	7e 05                	jle    8009d6 <vprintfmt+0x1f5>
  8009d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d4:	7e 12                	jle    8009e8 <vprintfmt+0x207>
					putch('?', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 3f                	push   $0x3f
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	eb 0f                	jmp    8009f7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fa:	89 f0                	mov    %esi,%eax
  8009fc:	8d 70 01             	lea    0x1(%eax),%esi
  8009ff:	8a 00                	mov    (%eax),%al
  800a01:	0f be d8             	movsbl %al,%ebx
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	74 24                	je     800a2c <vprintfmt+0x24b>
  800a08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0c:	78 b8                	js     8009c6 <vprintfmt+0x1e5>
  800a0e:	ff 4d e0             	decl   -0x20(%ebp)
  800a11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a15:	79 af                	jns    8009c6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a17:	eb 13                	jmp    800a2c <vprintfmt+0x24b>
				putch(' ', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 20                	push   $0x20
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a29:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a30:	7f e7                	jg     800a19 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a32:	e9 78 01 00 00       	jmp    800baf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a40:	50                   	push   %eax
  800a41:	e8 3c fd ff ff       	call   800782 <getint>
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a55:	85 d2                	test   %edx,%edx
  800a57:	79 23                	jns    800a7c <vprintfmt+0x29b>
				putch('-', putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	6a 2d                	push   $0x2d
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	ff d0                	call   *%eax
  800a66:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6f:	f7 d8                	neg    %eax
  800a71:	83 d2 00             	adc    $0x0,%edx
  800a74:	f7 da                	neg    %edx
  800a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a7c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a83:	e9 bc 00 00 00       	jmp    800b44 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 84 fc ff ff       	call   80071b <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa7:	e9 98 00 00 00       	jmp    800b44 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 58                	push   $0x58
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	6a 58                	push   $0x58
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	6a 58                	push   $0x58
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
			break;
  800adc:	e9 ce 00 00 00       	jmp    800baf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	6a 30                	push   $0x30
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 78                	push   $0x78
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b01:	8b 45 14             	mov    0x14(%ebp),%eax
  800b04:	83 c0 04             	add    $0x4,%eax
  800b07:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	83 e8 04             	sub    $0x4,%eax
  800b10:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b1c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b23:	eb 1f                	jmp    800b44 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2e:	50                   	push   %eax
  800b2f:	e8 e7 fb ff ff       	call   80071b <getuint>
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b3d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b44:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	52                   	push   %edx
  800b4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b52:	50                   	push   %eax
  800b53:	ff 75 f4             	pushl  -0xc(%ebp)
  800b56:	ff 75 f0             	pushl  -0x10(%ebp)
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	e8 00 fb ff ff       	call   800664 <printnum>
  800b64:	83 c4 20             	add    $0x20,%esp
			break;
  800b67:	eb 46                	jmp    800baf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	53                   	push   %ebx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			break;
  800b78:	eb 35                	jmp    800baf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b7a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b81:	eb 2c                	jmp    800baf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b83:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b8a:	eb 23                	jmp    800baf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 25                	push   $0x25
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9c:	ff 4d 10             	decl   0x10(%ebp)
  800b9f:	eb 03                	jmp    800ba4 <vprintfmt+0x3c3>
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	48                   	dec    %eax
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	3c 25                	cmp    $0x25,%al
  800bac:	75 f3                	jne    800ba1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bae:	90                   	nop
		}
	}
  800baf:	e9 35 fc ff ff       	jmp    8007e9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 04 fc ff ff       	call   8007e1 <vprintfmt>
  800bdd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be0:	90                   	nop
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8b 40 08             	mov    0x8(%eax),%eax
  800bec:	8d 50 01             	lea    0x1(%eax),%edx
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8b 10                	mov    (%eax),%edx
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 40 04             	mov    0x4(%eax),%eax
  800c00:	39 c2                	cmp    %eax,%edx
  800c02:	73 12                	jae    800c16 <sprintputch+0x33>
		*b->buf++ = ch;
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	8d 48 01             	lea    0x1(%eax),%ecx
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	89 0a                	mov    %ecx,(%edx)
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	88 10                	mov    %dl,(%eax)
}
  800c16:	90                   	nop
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	01 d0                	add    %edx,%eax
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3e:	74 06                	je     800c46 <vsnprintf+0x2d>
  800c40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c44:	7f 07                	jg     800c4d <vsnprintf+0x34>
		return -E_INVAL;
  800c46:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4b:	eb 20                	jmp    800c6d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4d:	ff 75 14             	pushl  0x14(%ebp)
  800c50:	ff 75 10             	pushl  0x10(%ebp)
  800c53:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c56:	50                   	push   %eax
  800c57:	68 e3 0b 80 00       	push   $0x800be3
  800c5c:	e8 80 fb ff ff       	call   8007e1 <vprintfmt>
  800c61:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c67:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c75:	8d 45 10             	lea    0x10(%ebp),%eax
  800c78:	83 c0 04             	add    $0x4,%eax
  800c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	ff 75 08             	pushl  0x8(%ebp)
  800c8b:	e8 89 ff ff ff       	call   800c19 <vsnprintf>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca8:	eb 06                	jmp    800cb0 <strlen+0x15>
		n++;
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 f1                	jne    800caa <strlen+0xf>
		n++;
	return n;
  800cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccb:	eb 09                	jmp    800cd6 <strnlen+0x18>
		n++;
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	ff 4d 0c             	decl   0xc(%ebp)
  800cd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cda:	74 09                	je     800ce5 <strnlen+0x27>
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 e8                	jne    800ccd <strnlen+0xf>
		n++;
	return n;
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf6:	90                   	nop
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8d 50 01             	lea    0x1(%eax),%edx
  800cfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d06:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	75 e4                	jne    800cf7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2b:	eb 1f                	jmp    800d4c <strncpy+0x34>
		*dst++ = *src;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8d 50 01             	lea    0x1(%eax),%edx
  800d33:	89 55 08             	mov    %edx,0x8(%ebp)
  800d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d39:	8a 12                	mov    (%edx),%dl
  800d3b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	74 03                	je     800d49 <strncpy+0x31>
			src++;
  800d46:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d49:	ff 45 fc             	incl   -0x4(%ebp)
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d52:	72 d9                	jb     800d2d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d54:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d69:	74 30                	je     800d9b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d6b:	eb 16                	jmp    800d83 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	89 55 08             	mov    %edx,0x8(%ebp)
  800d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7f:	8a 12                	mov    (%edx),%dl
  800d81:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d83:	ff 4d 10             	decl   0x10(%ebp)
  800d86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8a:	74 09                	je     800d95 <strlcpy+0x3c>
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	75 d8                	jne    800d6d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	29 c2                	sub    %eax,%edx
  800da3:	89 d0                	mov    %edx,%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daa:	eb 06                	jmp    800db2 <strcmp+0xb>
		p++, q++;
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	84 c0                	test   %al,%al
  800db9:	74 0e                	je     800dc9 <strcmp+0x22>
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 10                	mov    (%eax),%dl
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	38 c2                	cmp    %al,%dl
  800dc7:	74 e3                	je     800dac <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f b6 d0             	movzbl %al,%edx
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f b6 c0             	movzbl %al,%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de2:	eb 09                	jmp    800ded <strncmp+0xe>
		n--, p++, q++;
  800de4:	ff 4d 10             	decl   0x10(%ebp)
  800de7:	ff 45 08             	incl   0x8(%ebp)
  800dea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ded:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df1:	74 17                	je     800e0a <strncmp+0x2b>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	84 c0                	test   %al,%al
  800dfa:	74 0e                	je     800e0a <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 10                	mov    (%eax),%dl
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	38 c2                	cmp    %al,%dl
  800e08:	74 da                	je     800de4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	75 07                	jne    800e17 <strncmp+0x38>
		return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	eb 14                	jmp    800e2b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f b6 c0             	movzbl %al,%eax
  800e27:	29 c2                	sub    %eax,%edx
  800e29:	89 d0                	mov    %edx,%eax
}
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 12                	jmp    800e4d <strchr+0x20>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	75 05                	jne    800e4a <strchr+0x1d>
			return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	eb 11                	jmp    800e5b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e5                	jne    800e3b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 04             	sub    $0x4,%esp
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e69:	eb 0d                	jmp    800e78 <strfind+0x1b>
		if (*s == c)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e73:	74 0e                	je     800e83 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 ea                	jne    800e6b <strfind+0xe>
  800e81:	eb 01                	jmp    800e84 <strfind+0x27>
		if (*s == c)
			break;
  800e83:	90                   	nop
	return (char *) s;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e95:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e99:	76 63                	jbe    800efe <memset+0x75>
		uint64 data_block = c;
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	99                   	cltd   
  800e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eab:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eaf:	c1 e0 08             	shl    $0x8,%eax
  800eb2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ec2:	c1 e0 10             	shl    $0x10,%eax
  800ec5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed1:	89 c2                	mov    %eax,%edx
  800ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ede:	eb 18                	jmp    800ef8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ee0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee3:	8d 41 08             	lea    0x8(%ecx),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eef:	89 01                	mov    %eax,(%ecx)
  800ef1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efc:	77 e2                	ja     800ee0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800efe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f02:	74 23                	je     800f27 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f07:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f0a:	eb 0e                	jmp    800f1a <memset+0x91>
			*p8++ = (uint8)c;
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f18:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f20:	89 55 10             	mov    %edx,0x10(%ebp)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	75 e5                	jne    800f0c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f3e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f42:	76 24                	jbe    800f68 <memcpy+0x3c>
		while(n >= 8){
  800f44:	eb 1c                	jmp    800f62 <memcpy+0x36>
			*d64 = *s64;
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8b 50 04             	mov    0x4(%eax),%edx
  800f4c:	8b 00                	mov    (%eax),%eax
  800f4e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f51:	89 01                	mov    %eax,(%ecx)
  800f53:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f56:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f5a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f5e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f62:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f66:	77 de                	ja     800f46 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6c:	74 31                	je     800f9f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f7a:	eb 16                	jmp    800f92 <memcpy+0x66>
			*d8++ = *s8++;
  800f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f8e:	8a 12                	mov    (%edx),%dl
  800f90:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f98:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	75 dd                	jne    800f7c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbc:	73 50                	jae    80100e <memmove+0x6a>
  800fbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 d0                	add    %edx,%eax
  800fc6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc9:	76 43                	jbe    80100e <memmove+0x6a>
		s += n;
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd7:	eb 10                	jmp    800fe9 <memmove+0x45>
			*--d = *--s;
  800fd9:	ff 4d f8             	decl   -0x8(%ebp)
  800fdc:	ff 4d fc             	decl   -0x4(%ebp)
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8a 10                	mov    (%eax),%dl
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fef:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	75 e3                	jne    800fd9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff6:	eb 23                	jmp    80101b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	8d 50 01             	lea    0x1(%eax),%edx
  800ffe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801001:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801004:	8d 4a 01             	lea    0x1(%edx),%ecx
  801007:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100a:	8a 12                	mov    (%edx),%dl
  80100c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100e:	8b 45 10             	mov    0x10(%ebp),%eax
  801011:	8d 50 ff             	lea    -0x1(%eax),%edx
  801014:	89 55 10             	mov    %edx,0x10(%ebp)
  801017:	85 c0                	test   %eax,%eax
  801019:	75 dd                	jne    800ff8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801032:	eb 2a                	jmp    80105e <memcmp+0x3e>
		if (*s1 != *s2)
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	8a 10                	mov    (%eax),%dl
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	38 c2                	cmp    %al,%dl
  801040:	74 16                	je     801058 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801042:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f b6 d0             	movzbl %al,%edx
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	0f b6 c0             	movzbl %al,%eax
  801052:	29 c2                	sub    %eax,%edx
  801054:	89 d0                	mov    %edx,%eax
  801056:	eb 18                	jmp    801070 <memcmp+0x50>
		s1++, s2++;
  801058:	ff 45 fc             	incl   -0x4(%ebp)
  80105b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 c9                	jne    801034 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80106b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801083:	eb 15                	jmp    80109a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	0f b6 d0             	movzbl %al,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	0f b6 c0             	movzbl %al,%eax
  801093:	39 c2                	cmp    %eax,%edx
  801095:	74 0d                	je     8010a4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a0:	72 e3                	jb     801085 <memfind+0x13>
  8010a2:	eb 01                	jmp    8010a5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a4:	90                   	nop
	return (void *) s;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010be:	eb 03                	jmp    8010c3 <strtol+0x19>
		s++;
  8010c0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 20                	cmp    $0x20,%al
  8010ca:	74 f4                	je     8010c0 <strtol+0x16>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 09                	cmp    $0x9,%al
  8010d3:	74 eb                	je     8010c0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 2b                	cmp    $0x2b,%al
  8010dc:	75 05                	jne    8010e3 <strtol+0x39>
		s++;
  8010de:	ff 45 08             	incl   0x8(%ebp)
  8010e1:	eb 13                	jmp    8010f6 <strtol+0x4c>
	else if (*s == '-')
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 2d                	cmp    $0x2d,%al
  8010ea:	75 0a                	jne    8010f6 <strtol+0x4c>
		s++, neg = 1;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	74 06                	je     801102 <strtol+0x58>
  8010fc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801100:	75 20                	jne    801122 <strtol+0x78>
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3c 30                	cmp    $0x30,%al
  801109:	75 17                	jne    801122 <strtol+0x78>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	40                   	inc    %eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 78                	cmp    $0x78,%al
  801113:	75 0d                	jne    801122 <strtol+0x78>
		s += 2, base = 16;
  801115:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801119:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801120:	eb 28                	jmp    80114a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801126:	75 15                	jne    80113d <strtol+0x93>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 30                	cmp    $0x30,%al
  80112f:	75 0c                	jne    80113d <strtol+0x93>
		s++, base = 8;
  801131:	ff 45 08             	incl   0x8(%ebp)
  801134:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113b:	eb 0d                	jmp    80114a <strtol+0xa0>
	else if (base == 0)
  80113d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801141:	75 07                	jne    80114a <strtol+0xa0>
		base = 10;
  801143:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2f                	cmp    $0x2f,%al
  801151:	7e 19                	jle    80116c <strtol+0xc2>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 39                	cmp    $0x39,%al
  80115a:	7f 10                	jg     80116c <strtol+0xc2>
			dig = *s - '0';
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	0f be c0             	movsbl %al,%eax
  801164:	83 e8 30             	sub    $0x30,%eax
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116a:	eb 42                	jmp    8011ae <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 60                	cmp    $0x60,%al
  801173:	7e 19                	jle    80118e <strtol+0xe4>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 7a                	cmp    $0x7a,%al
  80117c:	7f 10                	jg     80118e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	0f be c0             	movsbl %al,%eax
  801186:	83 e8 57             	sub    $0x57,%eax
  801189:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118c:	eb 20                	jmp    8011ae <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 40                	cmp    $0x40,%al
  801195:	7e 39                	jle    8011d0 <strtol+0x126>
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 5a                	cmp    $0x5a,%al
  80119e:	7f 30                	jg     8011d0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	0f be c0             	movsbl %al,%eax
  8011a8:	83 e8 37             	sub    $0x37,%eax
  8011ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b4:	7d 19                	jge    8011cf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ca:	e9 7b ff ff ff       	jmp    80114a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d4:	74 08                	je     8011de <strtol+0x134>
		*endptr = (char *) s;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e2:	74 07                	je     8011eb <strtol+0x141>
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	f7 d8                	neg    %eax
  8011e9:	eb 03                	jmp    8011ee <strtol+0x144>
  8011eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801208:	79 13                	jns    80121d <ltostr+0x2d>
	{
		neg = 1;
  80120a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801217:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80121a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801225:	99                   	cltd   
  801226:	f7 f9                	idiv   %ecx
  801228:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80122b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801234:	89 c2                	mov    %eax,%edx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123e:	83 c2 30             	add    $0x30,%edx
  801241:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801243:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801246:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124b:	f7 e9                	imul   %ecx
  80124d:	c1 fa 02             	sar    $0x2,%edx
  801250:	89 c8                	mov    %ecx,%eax
  801252:	c1 f8 1f             	sar    $0x1f,%eax
  801255:	29 c2                	sub    %eax,%edx
  801257:	89 d0                	mov    %edx,%eax
  801259:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801260:	75 bb                	jne    80121d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	48                   	dec    %eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801270:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801274:	74 3d                	je     8012b3 <ltostr+0xc3>
		start = 1 ;
  801276:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127d:	eb 34                	jmp    8012b3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	01 c2                	add    %eax,%edx
  801294:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c8                	add    %ecx,%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012ab:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ad:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b9:	7c c4                	jl     80127f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	01 d0                	add    %edx,%eax
  8012c3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c6:	90                   	nop
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cf:	ff 75 08             	pushl  0x8(%ebp)
  8012d2:	e8 c4 f9 ff ff       	call   800c9b <strlen>
  8012d7:	83 c4 04             	add    $0x4,%esp
  8012da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	e8 b6 f9 ff ff       	call   800c9b <strlen>
  8012e5:	83 c4 04             	add    $0x4,%esp
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f9:	eb 17                	jmp    801312 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	01 c2                	add    %eax,%edx
  801303:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	01 c8                	add    %ecx,%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130f:	ff 45 fc             	incl   -0x4(%ebp)
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801318:	7c e1                	jl     8012fb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801328:	eb 1f                	jmp    801349 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132d:	8d 50 01             	lea    0x1(%eax),%edx
  801330:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801333:	89 c2                	mov    %eax,%edx
  801335:	8b 45 10             	mov    0x10(%ebp),%eax
  801338:	01 c2                	add    %eax,%edx
  80133a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801340:	01 c8                	add    %ecx,%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801346:	ff 45 f8             	incl   -0x8(%ebp)
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134f:	7c d9                	jl     80132a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801351:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	c6 00 00             	movb   $0x0,(%eax)
}
  80135c:	90                   	nop
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	8b 00                	mov    (%eax),%eax
  801370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801382:	eb 0c                	jmp    801390 <strsplit+0x31>
			*string++ = 0;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 08             	mov    %edx,0x8(%ebp)
  80138d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	84 c0                	test   %al,%al
  801397:	74 18                	je     8013b1 <strsplit+0x52>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	0f be c0             	movsbl %al,%eax
  8013a1:	50                   	push   %eax
  8013a2:	ff 75 0c             	pushl  0xc(%ebp)
  8013a5:	e8 83 fa ff ff       	call   800e2d <strchr>
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 d3                	jne    801384 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 5a                	je     801414 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	83 f8 0f             	cmp    $0xf,%eax
  8013c2:	75 07                	jne    8013cb <strsplit+0x6c>
		{
			return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c9:	eb 66                	jmp    801431 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ce:	8b 00                	mov    (%eax),%eax
  8013d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d6:	89 0a                	mov    %ecx,(%edx)
  8013d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e9:	eb 03                	jmp    8013ee <strsplit+0x8f>
			string++;
  8013eb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 8b                	je     801382 <strsplit+0x23>
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	0f be c0             	movsbl %al,%eax
  8013ff:	50                   	push   %eax
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	e8 25 fa ff ff       	call   800e2d <strchr>
  801408:	83 c4 08             	add    $0x8,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 dc                	je     8013eb <strsplit+0x8c>
			string++;
	}
  80140f:	e9 6e ff ff ff       	jmp    801382 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801414:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801415:	8b 45 14             	mov    0x14(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80143f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801446:	eb 4a                	jmp    801492 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801448:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	01 c2                	add    %eax,%edx
  801450:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 c8                	add    %ecx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80145c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	01 d0                	add    %edx,%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	3c 40                	cmp    $0x40,%al
  801468:	7e 25                	jle    80148f <str2lower+0x5c>
  80146a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	01 d0                	add    %edx,%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 5a                	cmp    $0x5a,%al
  801476:	7f 17                	jg     80148f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801478:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	01 d0                	add    %edx,%eax
  801480:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801483:	8b 55 08             	mov    0x8(%ebp),%edx
  801486:	01 ca                	add    %ecx,%edx
  801488:	8a 12                	mov    (%edx),%dl
  80148a:	83 c2 20             	add    $0x20,%edx
  80148d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80148f:	ff 45 fc             	incl   -0x4(%ebp)
  801492:	ff 75 0c             	pushl  0xc(%ebp)
  801495:	e8 01 f8 ff ff       	call   800c9b <strlen>
  80149a:	83 c4 04             	add    $0x4,%esp
  80149d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014a0:	7f a6                	jg     801448 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014c2:	cd 30                	int    $0x30
  8014c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5f                   	pop    %edi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	51                   	push   %ecx
  8014eb:	52                   	push   %edx
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	50                   	push   %eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	e8 b0 ff ff ff       	call   8014a7 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	90                   	nop
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 02                	push   $0x2
  80150c:	e8 96 ff ff ff       	call   8014a7 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 03                	push   $0x3
  801525:	e8 7d ff ff ff       	call   8014a7 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	90                   	nop
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 04                	push   $0x4
  80153f:	e8 63 ff ff ff       	call   8014a7 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	90                   	nop
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	6a 08                	push   $0x8
  80155d:	e8 45 ff ff ff       	call   8014a7 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80156c:	8b 75 18             	mov    0x18(%ebp),%esi
  80156f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801572:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	56                   	push   %esi
  80157c:	53                   	push   %ebx
  80157d:	51                   	push   %ecx
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	6a 09                	push   $0x9
  801582:	e8 20 ff ff ff       	call   8014a7 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5e                   	pop    %esi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    

00801591 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	6a 0a                	push   $0xa
  8015a1:	e8 01 ff ff ff       	call   8014a7 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 0c             	pushl  0xc(%ebp)
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	6a 0b                	push   $0xb
  8015bc:	e8 e6 fe ff ff       	call   8014a7 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 0c                	push   $0xc
  8015d5:	e8 cd fe ff ff       	call   8014a7 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 0d                	push   $0xd
  8015ee:	e8 b4 fe ff ff       	call   8014a7 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 0e                	push   $0xe
  801607:	e8 9b fe ff ff       	call   8014a7 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 0f                	push   $0xf
  801620:	e8 82 fe ff ff       	call   8014a7 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	6a 10                	push   $0x10
  80163a:	e8 68 fe ff ff       	call   8014a7 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 11                	push   $0x11
  801653:	e8 4f fe ff ff       	call   8014a7 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_cputc>:

void
sys_cputc(const char c)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80166a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	50                   	push   %eax
  801677:	6a 01                	push   $0x1
  801679:	e8 29 fe ff ff       	call   8014a7 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 14                	push   $0x14
  801693:	e8 0f fe ff ff       	call   8014a7 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	51                   	push   %ecx
  8016b7:	52                   	push   %edx
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	6a 15                	push   $0x15
  8016be:	e8 e4 fd ff ff       	call   8014a7 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	52                   	push   %edx
  8016d8:	50                   	push   %eax
  8016d9:	6a 16                	push   $0x16
  8016db:	e8 c7 fd ff ff       	call   8014a7 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	51                   	push   %ecx
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	6a 17                	push   $0x17
  8016fa:	e8 a8 fd ff ff       	call   8014a7 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	52                   	push   %edx
  801714:	50                   	push   %eax
  801715:	6a 18                	push   $0x18
  801717:	e8 8b fd ff ff       	call   8014a7 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	6a 00                	push   $0x0
  801729:	ff 75 14             	pushl  0x14(%ebp)
  80172c:	ff 75 10             	pushl  0x10(%ebp)
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	50                   	push   %eax
  801733:	6a 19                	push   $0x19
  801735:	e8 6d fd ff ff       	call   8014a7 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	50                   	push   %eax
  80174e:	6a 1a                	push   $0x1a
  801750:	e8 52 fd ff ff       	call   8014a7 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	90                   	nop
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	50                   	push   %eax
  80176a:	6a 1b                	push   $0x1b
  80176c:	e8 36 fd ff ff       	call   8014a7 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 05                	push   $0x5
  801785:	e8 1d fd ff ff       	call   8014a7 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 06                	push   $0x6
  80179e:	e8 04 fd ff ff       	call   8014a7 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 07                	push   $0x7
  8017b7:	e8 eb fc ff ff       	call   8014a7 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_exit_env>:


void sys_exit_env(void)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 1c                	push   $0x1c
  8017d0:	e8 d2 fc ff ff       	call   8014a7 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	90                   	nop
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e4:	8d 50 04             	lea    0x4(%eax),%edx
  8017e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 1d                	push   $0x1d
  8017f4:	e8 ae fc ff ff       	call   8014a7 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
	return result;
  8017fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801802:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801805:	89 01                	mov    %eax,(%ecx)
  801807:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	c9                   	leave  
  80180e:	c2 04 00             	ret    $0x4

00801811 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	ff 75 10             	pushl  0x10(%ebp)
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	6a 13                	push   $0x13
  801823:	e8 7f fc ff ff       	call   8014a7 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
	return ;
  80182b:	90                   	nop
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_rcr2>:
uint32 sys_rcr2()
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 1e                	push   $0x1e
  80183d:	e8 65 fc ff ff       	call   8014a7 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801853:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	50                   	push   %eax
  801860:	6a 1f                	push   $0x1f
  801862:	e8 40 fc ff ff       	call   8014a7 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
	return ;
  80186a:	90                   	nop
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <rsttst>:
void rsttst()
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 21                	push   $0x21
  80187c:	e8 26 fc ff ff       	call   8014a7 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return ;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	8b 45 14             	mov    0x14(%ebp),%eax
  801890:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801893:	8b 55 18             	mov    0x18(%ebp),%edx
  801896:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	ff 75 10             	pushl  0x10(%ebp)
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	6a 20                	push   $0x20
  8018a7:	e8 fb fb ff ff       	call   8014a7 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8018af:	90                   	nop
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <chktst>:
void chktst(uint32 n)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 22                	push   $0x22
  8018c2:	e8 e0 fb ff ff       	call   8014a7 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <inctst>:

void inctst()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 23                	push   $0x23
  8018dc:	e8 c6 fb ff ff       	call   8014a7 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e4:	90                   	nop
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <gettst>:
uint32 gettst()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 24                	push   $0x24
  8018f6:	e8 ac fb ff ff       	call   8014a7 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 25                	push   $0x25
  80190f:	e8 93 fb ff ff       	call   8014a7 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
  801917:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80191c:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 26                	push   $0x26
  80193b:	e8 67 fb ff ff       	call   8014a7 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80194a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	53                   	push   %ebx
  801959:	51                   	push   %ecx
  80195a:	52                   	push   %edx
  80195b:	50                   	push   %eax
  80195c:	6a 27                	push   $0x27
  80195e:	e8 44 fb ff ff       	call   8014a7 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 28                	push   $0x28
  80197e:	e8 24 fb ff ff       	call   8014a7 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80198b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	51                   	push   %ecx
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 29                	push   $0x29
  80199e:	e8 04 fb ff ff       	call   8014a7 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 12                	push   $0x12
  8019ba:	e8 e8 fa ff ff       	call   8014a7 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 2a                	push   $0x2a
  8019d8:	e8 ca fa ff ff       	call   8014a7 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 2b                	push   $0x2b
  8019f2:	e8 b0 fa ff ff       	call   8014a7 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	6a 2d                	push   $0x2d
  801a0d:	e8 95 fa ff ff       	call   8014a7 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	6a 2c                	push   $0x2c
  801a29:	e8 79 fa ff ff       	call   8014a7 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a31:	90                   	nop
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 c8 23 80 00       	push   $0x8023c8
  801a42:	68 25 01 00 00       	push   $0x125
  801a47:	68 fb 23 80 00       	push   $0x8023fb
  801a4c:	e8 a3 e8 ff ff       	call   8002f4 <_panic>

00801a51 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 0c 24 80 00       	push   $0x80240c
  801a5f:	6a 07                	push   $0x7
  801a61:	68 3b 24 80 00       	push   $0x80243b
  801a66:	e8 89 e8 ff ff       	call   8002f4 <_panic>

00801a6b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	68 4c 24 80 00       	push   $0x80244c
  801a79:	6a 0b                	push   $0xb
  801a7b:	68 3b 24 80 00       	push   $0x80243b
  801a80:	e8 6f e8 ff ff       	call   8002f4 <_panic>

00801a85 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	68 78 24 80 00       	push   $0x802478
  801a93:	6a 10                	push   $0x10
  801a95:	68 3b 24 80 00       	push   $0x80243b
  801a9a:	e8 55 e8 ff ff       	call   8002f4 <_panic>

00801a9f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	68 a8 24 80 00       	push   $0x8024a8
  801aad:	6a 15                	push   $0x15
  801aaf:	68 3b 24 80 00       	push   $0x80243b
  801ab4:	e8 3b e8 ff ff       	call   8002f4 <_panic>

00801ab9 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    

00801ac4 <__udivdi3>:
  801ac4:	55                   	push   %ebp
  801ac5:	57                   	push   %edi
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 1c             	sub    $0x1c,%esp
  801acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adb:	89 ca                	mov    %ecx,%edx
  801add:	89 f8                	mov    %edi,%eax
  801adf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ae3:	85 f6                	test   %esi,%esi
  801ae5:	75 2d                	jne    801b14 <__udivdi3+0x50>
  801ae7:	39 cf                	cmp    %ecx,%edi
  801ae9:	77 65                	ja     801b50 <__udivdi3+0x8c>
  801aeb:	89 fd                	mov    %edi,%ebp
  801aed:	85 ff                	test   %edi,%edi
  801aef:	75 0b                	jne    801afc <__udivdi3+0x38>
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	31 d2                	xor    %edx,%edx
  801af8:	f7 f7                	div    %edi
  801afa:	89 c5                	mov    %eax,%ebp
  801afc:	31 d2                	xor    %edx,%edx
  801afe:	89 c8                	mov    %ecx,%eax
  801b00:	f7 f5                	div    %ebp
  801b02:	89 c1                	mov    %eax,%ecx
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	f7 f5                	div    %ebp
  801b08:	89 cf                	mov    %ecx,%edi
  801b0a:	89 fa                	mov    %edi,%edx
  801b0c:	83 c4 1c             	add    $0x1c,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5f                   	pop    %edi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    
  801b14:	39 ce                	cmp    %ecx,%esi
  801b16:	77 28                	ja     801b40 <__udivdi3+0x7c>
  801b18:	0f bd fe             	bsr    %esi,%edi
  801b1b:	83 f7 1f             	xor    $0x1f,%edi
  801b1e:	75 40                	jne    801b60 <__udivdi3+0x9c>
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	72 0a                	jb     801b2e <__udivdi3+0x6a>
  801b24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b28:	0f 87 9e 00 00 00    	ja     801bcc <__udivdi3+0x108>
  801b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b33:	89 fa                	mov    %edi,%edx
  801b35:	83 c4 1c             	add    $0x1c,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    
  801b3d:	8d 76 00             	lea    0x0(%esi),%esi
  801b40:	31 ff                	xor    %edi,%edi
  801b42:	31 c0                	xor    %eax,%eax
  801b44:	89 fa                	mov    %edi,%edx
  801b46:	83 c4 1c             	add    $0x1c,%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	f7 f7                	div    %edi
  801b54:	31 ff                	xor    %edi,%edi
  801b56:	89 fa                	mov    %edi,%edx
  801b58:	83 c4 1c             	add    $0x1c,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
  801b60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b65:	89 eb                	mov    %ebp,%ebx
  801b67:	29 fb                	sub    %edi,%ebx
  801b69:	89 f9                	mov    %edi,%ecx
  801b6b:	d3 e6                	shl    %cl,%esi
  801b6d:	89 c5                	mov    %eax,%ebp
  801b6f:	88 d9                	mov    %bl,%cl
  801b71:	d3 ed                	shr    %cl,%ebp
  801b73:	89 e9                	mov    %ebp,%ecx
  801b75:	09 f1                	or     %esi,%ecx
  801b77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b7b:	89 f9                	mov    %edi,%ecx
  801b7d:	d3 e0                	shl    %cl,%eax
  801b7f:	89 c5                	mov    %eax,%ebp
  801b81:	89 d6                	mov    %edx,%esi
  801b83:	88 d9                	mov    %bl,%cl
  801b85:	d3 ee                	shr    %cl,%esi
  801b87:	89 f9                	mov    %edi,%ecx
  801b89:	d3 e2                	shl    %cl,%edx
  801b8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 e8                	shr    %cl,%eax
  801b93:	09 c2                	or     %eax,%edx
  801b95:	89 d0                	mov    %edx,%eax
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	f7 74 24 0c          	divl   0xc(%esp)
  801b9d:	89 d6                	mov    %edx,%esi
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	f7 e5                	mul    %ebp
  801ba3:	39 d6                	cmp    %edx,%esi
  801ba5:	72 19                	jb     801bc0 <__udivdi3+0xfc>
  801ba7:	74 0b                	je     801bb4 <__udivdi3+0xf0>
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	31 ff                	xor    %edi,%edi
  801bad:	e9 58 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bb8:	89 f9                	mov    %edi,%ecx
  801bba:	d3 e2                	shl    %cl,%edx
  801bbc:	39 c2                	cmp    %eax,%edx
  801bbe:	73 e9                	jae    801ba9 <__udivdi3+0xe5>
  801bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bc3:	31 ff                	xor    %edi,%edi
  801bc5:	e9 40 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	31 c0                	xor    %eax,%eax
  801bce:	e9 37 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bd3:	90                   	nop

00801bd4 <__umoddi3>:
  801bd4:	55                   	push   %ebp
  801bd5:	57                   	push   %edi
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 1c             	sub    $0x1c,%esp
  801bdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801beb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bf3:	89 f3                	mov    %esi,%ebx
  801bf5:	89 fa                	mov    %edi,%edx
  801bf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bfb:	89 34 24             	mov    %esi,(%esp)
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	75 1a                	jne    801c1c <__umoddi3+0x48>
  801c02:	39 f7                	cmp    %esi,%edi
  801c04:	0f 86 a2 00 00 00    	jbe    801cac <__umoddi3+0xd8>
  801c0a:	89 c8                	mov    %ecx,%eax
  801c0c:	89 f2                	mov    %esi,%edx
  801c0e:	f7 f7                	div    %edi
  801c10:	89 d0                	mov    %edx,%eax
  801c12:	31 d2                	xor    %edx,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	39 f0                	cmp    %esi,%eax
  801c1e:	0f 87 ac 00 00 00    	ja     801cd0 <__umoddi3+0xfc>
  801c24:	0f bd e8             	bsr    %eax,%ebp
  801c27:	83 f5 1f             	xor    $0x1f,%ebp
  801c2a:	0f 84 ac 00 00 00    	je     801cdc <__umoddi3+0x108>
  801c30:	bf 20 00 00 00       	mov    $0x20,%edi
  801c35:	29 ef                	sub    %ebp,%edi
  801c37:	89 fe                	mov    %edi,%esi
  801c39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c3d:	89 e9                	mov    %ebp,%ecx
  801c3f:	d3 e0                	shl    %cl,%eax
  801c41:	89 d7                	mov    %edx,%edi
  801c43:	89 f1                	mov    %esi,%ecx
  801c45:	d3 ef                	shr    %cl,%edi
  801c47:	09 c7                	or     %eax,%edi
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 e2                	shl    %cl,%edx
  801c4d:	89 14 24             	mov    %edx,(%esp)
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	d3 e0                	shl    %cl,%eax
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5a:	d3 e0                	shl    %cl,%eax
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c64:	89 f1                	mov    %esi,%ecx
  801c66:	d3 e8                	shr    %cl,%eax
  801c68:	09 d0                	or     %edx,%eax
  801c6a:	d3 eb                	shr    %cl,%ebx
  801c6c:	89 da                	mov    %ebx,%edx
  801c6e:	f7 f7                	div    %edi
  801c70:	89 d3                	mov    %edx,%ebx
  801c72:	f7 24 24             	mull   (%esp)
  801c75:	89 c6                	mov    %eax,%esi
  801c77:	89 d1                	mov    %edx,%ecx
  801c79:	39 d3                	cmp    %edx,%ebx
  801c7b:	0f 82 87 00 00 00    	jb     801d08 <__umoddi3+0x134>
  801c81:	0f 84 91 00 00 00    	je     801d18 <__umoddi3+0x144>
  801c87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c8b:	29 f2                	sub    %esi,%edx
  801c8d:	19 cb                	sbb    %ecx,%ebx
  801c8f:	89 d8                	mov    %ebx,%eax
  801c91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c95:	d3 e0                	shl    %cl,%eax
  801c97:	89 e9                	mov    %ebp,%ecx
  801c99:	d3 ea                	shr    %cl,%edx
  801c9b:	09 d0                	or     %edx,%eax
  801c9d:	89 e9                	mov    %ebp,%ecx
  801c9f:	d3 eb                	shr    %cl,%ebx
  801ca1:	89 da                	mov    %ebx,%edx
  801ca3:	83 c4 1c             	add    $0x1c,%esp
  801ca6:	5b                   	pop    %ebx
  801ca7:	5e                   	pop    %esi
  801ca8:	5f                   	pop    %edi
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    
  801cab:	90                   	nop
  801cac:	89 fd                	mov    %edi,%ebp
  801cae:	85 ff                	test   %edi,%edi
  801cb0:	75 0b                	jne    801cbd <__umoddi3+0xe9>
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	31 d2                	xor    %edx,%edx
  801cb9:	f7 f7                	div    %edi
  801cbb:	89 c5                	mov    %eax,%ebp
  801cbd:	89 f0                	mov    %esi,%eax
  801cbf:	31 d2                	xor    %edx,%edx
  801cc1:	f7 f5                	div    %ebp
  801cc3:	89 c8                	mov    %ecx,%eax
  801cc5:	f7 f5                	div    %ebp
  801cc7:	89 d0                	mov    %edx,%eax
  801cc9:	e9 44 ff ff ff       	jmp    801c12 <__umoddi3+0x3e>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	89 c8                	mov    %ecx,%eax
  801cd2:	89 f2                	mov    %esi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	3b 04 24             	cmp    (%esp),%eax
  801cdf:	72 06                	jb     801ce7 <__umoddi3+0x113>
  801ce1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ce5:	77 0f                	ja     801cf6 <__umoddi3+0x122>
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	29 f9                	sub    %edi,%ecx
  801ceb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cef:	89 14 24             	mov    %edx,(%esp)
  801cf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cfa:	8b 14 24             	mov    (%esp),%edx
  801cfd:	83 c4 1c             	add    $0x1c,%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5f                   	pop    %edi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    
  801d05:	8d 76 00             	lea    0x0(%esi),%esi
  801d08:	2b 04 24             	sub    (%esp),%eax
  801d0b:	19 fa                	sbb    %edi,%edx
  801d0d:	89 d1                	mov    %edx,%ecx
  801d0f:	89 c6                	mov    %eax,%esi
  801d11:	e9 71 ff ff ff       	jmp    801c87 <__umoddi3+0xb3>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d1c:	72 ea                	jb     801d08 <__umoddi3+0x134>
  801d1e:	89 d9                	mov    %ebx,%ecx
  801d20:	e9 62 ff ff ff       	jmp    801c87 <__umoddi3+0xb3>
