
obj/user/ef_tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 66 17 00 00       	call   8017a9 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 45 17 00 00       	call   801790 <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("%d: before the critical section\n", id);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	68 00 1e 80 00       	push   $0x801e00
  800059:	e8 65 05 00 00       	call   8005c3 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  800061:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 21 1e 80 00       	push   $0x801e21
  80006c:	ff 75 f4             	pushl  -0xc(%ebp)
  80006f:	50                   	push   %eax
  800070:	e8 f7 19 00 00       	call   801a6c <get_semaphore>
  800075:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	68 25 1e 80 00       	push   $0x801e25
  800083:	ff 75 f4             	pushl  -0xc(%ebp)
  800086:	50                   	push   %eax
  800087:	e8 e0 19 00 00       	call   801a6c <get_semaphore>
  80008c:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 ec 19 00 00       	call   801a86 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 30 1e 80 00       	push   $0x801e30
  8000a8:	e8 16 05 00 00       	call   8005c3 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 51 1e 80 00       	push   $0x801e51
  8000bb:	e8 03 05 00 00       	call   8005c3 <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 ec 19 00 00       	call   801aba <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 60 1e 80 00       	push   $0x801e60
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 b8 1e 80 00       	push   $0x801eb8
  8000e9:	e8 07 02 00 00       	call   8002f5 <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 ca 19 00 00       	call   801ac5 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 97 19 00 00       	call   801aa0 <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp

	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 d8 1e 80 00       	push   $0x801ed8
  800117:	e8 a7 04 00 00       	call   8005c3 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 76 19 00 00       	call   801aa0 <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800139:	e8 52 16 00 00       	call   801790 <sys_getenvindex>
  80013e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800144:	89 d0                	mov    %edx,%eax
  800146:	c1 e0 06             	shl    $0x6,%eax
  800149:	29 d0                	sub    %edx,%eax
  80014b:	c1 e0 02             	shl    $0x2,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800157:	01 c8                	add    %ecx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800165:	29 c2                	sub    %eax,%edx
  800167:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016e:	89 c2                	mov    %eax,%edx
  800170:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800176:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8a 40 20             	mov    0x20(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0d                	je     800194 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800187:	a1 20 30 80 00       	mov    0x803020,%eax
  80018c:	83 c0 20             	add    $0x20,%eax
  80018f:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800198:	7e 0a                	jle    8001a4 <libmain+0x74>
		binaryname = argv[0];
  80019a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 0c             	pushl  0xc(%ebp)
  8001aa:	ff 75 08             	pushl  0x8(%ebp)
  8001ad:	e8 86 fe ff ff       	call   800038 <_main>
  8001b2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b5:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	0f 84 01 01 00 00    	je     8002c3 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001c2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c8:	bb f0 1f 80 00       	mov    $0x801ff0,%ebx
  8001cd:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 de                	mov    %ebx,%esi
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001da:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001dd:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001e2:	b0 00                	mov    $0x0,%al
  8001e4:	89 d7                	mov    %edx,%edi
  8001e6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	50                   	push   %eax
  8001f6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	e8 c4 17 00 00       	call   8019c6 <sys_utilities>
  800202:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800205:	e8 0d 13 00 00       	call   801517 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 10 1f 80 00       	push   $0x801f10
  800212:	e8 ac 03 00 00       	call   8005c3 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80021a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021d:	85 c0                	test   %eax,%eax
  80021f:	74 18                	je     800239 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800221:	e8 be 17 00 00       	call   8019e4 <sys_get_optimal_num_faults>
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	50                   	push   %eax
  80022a:	68 38 1f 80 00       	push   $0x801f38
  80022f:	e8 8f 03 00 00       	call   8005c3 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	eb 59                	jmp    800292 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800244:	a1 20 30 80 00       	mov    0x803020,%eax
  800249:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80024f:	83 ec 04             	sub    $0x4,%esp
  800252:	52                   	push   %edx
  800253:	50                   	push   %eax
  800254:	68 5c 1f 80 00       	push   $0x801f5c
  800259:	e8 65 03 00 00       	call   8005c3 <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800261:	a1 20 30 80 00       	mov    0x803020,%eax
  800266:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800277:	a1 20 30 80 00       	mov    0x803020,%eax
  80027c:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800282:	51                   	push   %ecx
  800283:	52                   	push   %edx
  800284:	50                   	push   %eax
  800285:	68 84 1f 80 00       	push   $0x801f84
  80028a:	e8 34 03 00 00       	call   8005c3 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800292:	a1 20 30 80 00       	mov    0x803020,%eax
  800297:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	50                   	push   %eax
  8002a1:	68 dc 1f 80 00       	push   $0x801fdc
  8002a6:	e8 18 03 00 00       	call   8005c3 <cprintf>
  8002ab:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	68 10 1f 80 00       	push   $0x801f10
  8002b6:	e8 08 03 00 00       	call   8005c3 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002be:	e8 6e 12 00 00       	call   801531 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c3:	e8 1f 00 00 00       	call   8002e7 <exit>
}
  8002c8:	90                   	nop
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    

008002d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	e8 7b 14 00 00       	call   80175c <sys_destroy_env>
  8002e1:	83 c4 10             	add    $0x10,%esp
}
  8002e4:	90                   	nop
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <exit>:

void
exit(void)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ed:	e8 d0 14 00 00       	call   8017c2 <sys_exit_env>
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fe:	83 c0 04             	add    $0x4,%eax
  800301:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800304:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	74 16                	je     800323 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80030d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	50                   	push   %eax
  800316:	68 54 20 80 00       	push   $0x802054
  80031b:	e8 a3 02 00 00       	call   8005c3 <cprintf>
  800320:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800323:	a1 04 30 80 00       	mov    0x803004,%eax
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	ff 75 0c             	pushl  0xc(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	50                   	push   %eax
  800332:	68 5c 20 80 00       	push   $0x80205c
  800337:	6a 74                	push   $0x74
  800339:	e8 b2 02 00 00       	call   8005f0 <cprintf_colored>
  80033e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800341:	8b 45 10             	mov    0x10(%ebp),%eax
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	ff 75 f4             	pushl  -0xc(%ebp)
  80034a:	50                   	push   %eax
  80034b:	e8 04 02 00 00       	call   800554 <vcprintf>
  800350:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	6a 00                	push   $0x0
  800358:	68 84 20 80 00       	push   $0x802084
  80035d:	e8 f2 01 00 00       	call   800554 <vcprintf>
  800362:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800365:	e8 7d ff ff ff       	call   8002e7 <exit>

	// should not return here
	while (1) ;
  80036a:	eb fe                	jmp    80036a <_panic+0x75>

0080036c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800372:	a1 20 30 80 00       	mov    0x803020,%eax
  800377:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800380:	39 c2                	cmp    %eax,%edx
  800382:	74 14                	je     800398 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 88 20 80 00       	push   $0x802088
  80038c:	6a 26                	push   $0x26
  80038e:	68 d4 20 80 00       	push   $0x8020d4
  800393:	e8 5d ff ff ff       	call   8002f5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a6:	e9 c5 00 00 00       	jmp    800470 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	01 d0                	add    %edx,%eax
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	75 08                	jne    8003c8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003c0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c3:	e9 a5 00 00 00       	jmp    80046d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d6:	eb 69                	jmp    800441 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dd:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e6:	89 d0                	mov    %edx,%eax
  8003e8:	01 c0                	add    %eax,%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	c1 e0 03             	shl    $0x3,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	8a 40 04             	mov    0x4(%eax),%al
  8003f4:	84 c0                	test   %al,%al
  8003f6:	75 46                	jne    80043e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fd:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800403:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800406:	89 d0                	mov    %edx,%eax
  800408:	01 c0                	add    %eax,%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	c1 e0 03             	shl    $0x3,%eax
  80040f:	01 c8                	add    %ecx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800416:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800419:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800423:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	01 c8                	add    %ecx,%eax
  80042f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800431:	39 c2                	cmp    %eax,%edx
  800433:	75 09                	jne    80043e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800435:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043c:	eb 15                	jmp    800453 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043e:	ff 45 e8             	incl   -0x18(%ebp)
  800441:	a1 20 30 80 00       	mov    0x803020,%eax
  800446:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	39 c2                	cmp    %eax,%edx
  800451:	77 85                	ja     8003d8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800457:	75 14                	jne    80046d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 e0 20 80 00       	push   $0x8020e0
  800461:	6a 3a                	push   $0x3a
  800463:	68 d4 20 80 00       	push   $0x8020d4
  800468:	e8 88 fe ff ff       	call   8002f5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046d:	ff 45 f0             	incl   -0x10(%ebp)
  800470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800473:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800476:	0f 8c 2f ff ff ff    	jl     8003ab <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800483:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048a:	eb 26                	jmp    8004b2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	c1 e0 03             	shl    $0x3,%eax
  8004a3:	01 c8                	add    %ecx,%eax
  8004a5:	8a 40 04             	mov    0x4(%eax),%al
  8004a8:	3c 01                	cmp    $0x1,%al
  8004aa:	75 03                	jne    8004af <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004ac:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004af:	ff 45 e0             	incl   -0x20(%ebp)
  8004b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	39 c2                	cmp    %eax,%edx
  8004c2:	77 c8                	ja     80048c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ca:	74 14                	je     8004e0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	68 34 21 80 00       	push   $0x802134
  8004d4:	6a 44                	push   $0x44
  8004d6:	68 d4 20 80 00       	push   $0x8020d4
  8004db:	e8 15 fe ff ff       	call   8002f5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	53                   	push   %ebx
  8004e7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8004f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f5:	89 0a                	mov    %ecx,(%edx)
  8004f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fa:	88 d1                	mov    %dl,%cl
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	3d ff 00 00 00       	cmp    $0xff,%eax
  80050d:	75 30                	jne    80053f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80050f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800515:	a0 44 30 80 00       	mov    0x803044,%al
  80051a:	0f b6 c0             	movzbl %al,%eax
  80051d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800520:	8b 09                	mov    (%ecx),%ecx
  800522:	89 cb                	mov    %ecx,%ebx
  800524:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800527:	83 c1 08             	add    $0x8,%ecx
  80052a:	52                   	push   %edx
  80052b:	50                   	push   %eax
  80052c:	53                   	push   %ebx
  80052d:	51                   	push   %ecx
  80052e:	e8 a0 0f 00 00       	call   8014d3 <sys_cputs>
  800533:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800542:	8b 40 04             	mov    0x4(%eax),%eax
  800545:	8d 50 01             	lea    0x1(%eax),%edx
  800548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054e:	90                   	nop
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80055d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800564:	00 00 00 
	b.cnt = 0;
  800567:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	ff 75 08             	pushl  0x8(%ebp)
  800577:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057d:	50                   	push   %eax
  80057e:	68 e3 04 80 00       	push   $0x8004e3
  800583:	e8 5a 02 00 00       	call   8007e2 <vprintfmt>
  800588:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80058b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800591:	a0 44 30 80 00       	mov    0x803044,%al
  800596:	0f b6 c0             	movzbl %al,%eax
  800599:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80059f:	52                   	push   %edx
  8005a0:	50                   	push   %eax
  8005a1:	51                   	push   %ecx
  8005a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a8:	83 c0 08             	add    $0x8,%eax
  8005ab:	50                   	push   %eax
  8005ac:	e8 22 0f 00 00       	call   8014d3 <sys_cputs>
  8005b1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005df:	50                   	push   %eax
  8005e0:	e8 6f ff ff ff       	call   800554 <vcprintf>
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

008005f0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
  8005f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	c1 e0 08             	shl    $0x8,%eax
  800603:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800608:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060b:	83 c0 04             	add    $0x4,%eax
  80060e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800611:	8b 45 0c             	mov    0xc(%ebp),%eax
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	ff 75 f4             	pushl  -0xc(%ebp)
  80061a:	50                   	push   %eax
  80061b:	e8 34 ff ff ff       	call   800554 <vcprintf>
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800626:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80062d:	07 00 00 

	return cnt;
  800630:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80063b:	e8 d7 0e 00 00       	call   801517 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800640:	8d 45 0c             	lea    0xc(%ebp),%eax
  800643:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 f4             	pushl  -0xc(%ebp)
  80064f:	50                   	push   %eax
  800650:	e8 ff fe ff ff       	call   800554 <vcprintf>
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80065b:	e8 d1 0e 00 00       	call   801531 <sys_unlock_cons>
	return cnt;
  800660:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800663:	c9                   	leave  
  800664:	c3                   	ret    

00800665 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800665:	55                   	push   %ebp
  800666:	89 e5                	mov    %esp,%ebp
  800668:	53                   	push   %ebx
  800669:	83 ec 14             	sub    $0x14,%esp
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800678:	8b 45 18             	mov    0x18(%ebp),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800683:	77 55                	ja     8006da <printnum+0x75>
  800685:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800688:	72 05                	jb     80068f <printnum+0x2a>
  80068a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80068d:	77 4b                	ja     8006da <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800692:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800695:	8b 45 18             	mov    0x18(%ebp),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	52                   	push   %edx
  80069e:	50                   	push   %eax
  80069f:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a5:	e8 da 14 00 00       	call   801b84 <__udivdi3>
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	53                   	push   %ebx
  8006b4:	ff 75 18             	pushl  0x18(%ebp)
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	e8 a1 ff ff ff       	call   800665 <printnum>
  8006c4:	83 c4 20             	add    $0x20,%esp
  8006c7:	eb 1a                	jmp    8006e3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 20             	pushl  0x20(%ebp)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	ff d0                	call   *%eax
  8006d7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006da:	ff 4d 1c             	decl   0x1c(%ebp)
  8006dd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e1:	7f e6                	jg     8006c9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f1:	53                   	push   %ebx
  8006f2:	51                   	push   %ecx
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	e8 9a 15 00 00       	call   801c94 <__umoddi3>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	05 94 23 80 00       	add    $0x802394,%eax
  800702:	8a 00                	mov    (%eax),%al
  800704:	0f be c0             	movsbl %al,%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	50                   	push   %eax
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
}
  800716:	90                   	nop
  800717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800723:	7e 1c                	jle    800741 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	8d 50 08             	lea    0x8(%eax),%edx
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	89 10                	mov    %edx,(%eax)
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	83 e8 08             	sub    $0x8,%eax
  80073a:	8b 50 04             	mov    0x4(%eax),%edx
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	eb 40                	jmp    800781 <getuint+0x65>
	else if (lflag)
  800741:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800745:	74 1e                	je     800765 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	8d 50 04             	lea    0x4(%eax),%edx
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	89 10                	mov    %edx,(%eax)
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	83 e8 04             	sub    $0x4,%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	eb 1c                	jmp    800781 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	89 10                	mov    %edx,(%eax)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	83 e8 04             	sub    $0x4,%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800786:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80078a:	7e 1c                	jle    8007a8 <getint+0x25>
		return va_arg(*ap, long long);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	8d 50 08             	lea    0x8(%eax),%edx
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	89 10                	mov    %edx,(%eax)
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	83 e8 08             	sub    $0x8,%eax
  8007a1:	8b 50 04             	mov    0x4(%eax),%edx
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	eb 38                	jmp    8007e0 <getint+0x5d>
	else if (lflag)
  8007a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ac:	74 1a                	je     8007c8 <getint+0x45>
		return va_arg(*ap, long);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	99                   	cltd   
  8007c6:	eb 18                	jmp    8007e0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ea:	eb 17                	jmp    800803 <vprintfmt+0x21>
			if (ch == '\0')
  8007ec:	85 db                	test   %ebx,%ebx
  8007ee:	0f 84 c1 03 00 00    	je     800bb5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	53                   	push   %ebx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	ff d0                	call   *%eax
  800800:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	8d 50 01             	lea    0x1(%eax),%edx
  800809:	89 55 10             	mov    %edx,0x10(%ebp)
  80080c:	8a 00                	mov    (%eax),%al
  80080e:	0f b6 d8             	movzbl %al,%ebx
  800811:	83 fb 25             	cmp    $0x25,%ebx
  800814:	75 d6                	jne    8007ec <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800816:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80081a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800821:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800828:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80082f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800836:	8b 45 10             	mov    0x10(%ebp),%eax
  800839:	8d 50 01             	lea    0x1(%eax),%edx
  80083c:	89 55 10             	mov    %edx,0x10(%ebp)
  80083f:	8a 00                	mov    (%eax),%al
  800841:	0f b6 d8             	movzbl %al,%ebx
  800844:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800847:	83 f8 5b             	cmp    $0x5b,%eax
  80084a:	0f 87 3d 03 00 00    	ja     800b8d <vprintfmt+0x3ab>
  800850:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  800857:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800859:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80085d:	eb d7                	jmp    800836 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80085f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800863:	eb d1                	jmp    800836 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800865:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80086c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086f:	89 d0                	mov    %edx,%eax
  800871:	c1 e0 02             	shl    $0x2,%eax
  800874:	01 d0                	add    %edx,%eax
  800876:	01 c0                	add    %eax,%eax
  800878:	01 d8                	add    %ebx,%eax
  80087a:	83 e8 30             	sub    $0x30,%eax
  80087d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800880:	8b 45 10             	mov    0x10(%ebp),%eax
  800883:	8a 00                	mov    (%eax),%al
  800885:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800888:	83 fb 2f             	cmp    $0x2f,%ebx
  80088b:	7e 3e                	jle    8008cb <vprintfmt+0xe9>
  80088d:	83 fb 39             	cmp    $0x39,%ebx
  800890:	7f 39                	jg     8008cb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800892:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800895:	eb d5                	jmp    80086c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008ab:	eb 1f                	jmp    8008cc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	79 83                	jns    800836 <vprintfmt+0x54>
				width = 0;
  8008b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ba:	e9 77 ff ff ff       	jmp    800836 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008bf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c6:	e9 6b ff ff ff       	jmp    800836 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008cb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d0:	0f 89 60 ff ff ff    	jns    800836 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e3:	e9 4e ff ff ff       	jmp    800836 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008eb:	e9 46 ff ff ff       	jmp    800836 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 c0 04             	add    $0x4,%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	83 e8 04             	sub    $0x4,%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	50                   	push   %eax
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			break;
  800910:	e9 9b 02 00 00       	jmp    800bb0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 c0 04             	add    $0x4,%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	83 e8 04             	sub    $0x4,%eax
  800924:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800926:	85 db                	test   %ebx,%ebx
  800928:	79 02                	jns    80092c <vprintfmt+0x14a>
				err = -err;
  80092a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80092c:	83 fb 64             	cmp    $0x64,%ebx
  80092f:	7f 0b                	jg     80093c <vprintfmt+0x15a>
  800931:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  800938:	85 f6                	test   %esi,%esi
  80093a:	75 19                	jne    800955 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80093c:	53                   	push   %ebx
  80093d:	68 a5 23 80 00       	push   $0x8023a5
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 70 02 00 00       	call   800bbd <printfmt>
  80094d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800950:	e9 5b 02 00 00       	jmp    800bb0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800955:	56                   	push   %esi
  800956:	68 ae 23 80 00       	push   $0x8023ae
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 57 02 00 00       	call   800bbd <printfmt>
  800966:	83 c4 10             	add    $0x10,%esp
			break;
  800969:	e9 42 02 00 00       	jmp    800bb0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 c0 04             	add    $0x4,%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 30                	mov    (%eax),%esi
  80097f:	85 f6                	test   %esi,%esi
  800981:	75 05                	jne    800988 <vprintfmt+0x1a6>
				p = "(null)";
  800983:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  800988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098c:	7e 6d                	jle    8009fb <vprintfmt+0x219>
  80098e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800992:	74 67                	je     8009fb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800994:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	50                   	push   %eax
  80099b:	56                   	push   %esi
  80099c:	e8 1e 03 00 00       	call   800cbf <strnlen>
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a7:	eb 16                	jmp    8009bf <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c3:	7f e4                	jg     8009a9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c5:	eb 34                	jmp    8009fb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009cb:	74 1c                	je     8009e9 <vprintfmt+0x207>
  8009cd:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d0:	7e 05                	jle    8009d7 <vprintfmt+0x1f5>
  8009d2:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d5:	7e 12                	jle    8009e9 <vprintfmt+0x207>
					putch('?', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 3f                	push   $0x3f
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
  8009e7:	eb 0f                	jmp    8009f8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	53                   	push   %ebx
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	89 f0                	mov    %esi,%eax
  8009fd:	8d 70 01             	lea    0x1(%eax),%esi
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	0f be d8             	movsbl %al,%ebx
  800a05:	85 db                	test   %ebx,%ebx
  800a07:	74 24                	je     800a2d <vprintfmt+0x24b>
  800a09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0d:	78 b8                	js     8009c7 <vprintfmt+0x1e5>
  800a0f:	ff 4d e0             	decl   -0x20(%ebp)
  800a12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a16:	79 af                	jns    8009c7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a18:	eb 13                	jmp    800a2d <vprintfmt+0x24b>
				putch(' ', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 20                	push   $0x20
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a31:	7f e7                	jg     800a1a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a33:	e9 78 01 00 00       	jmp    800bb0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a41:	50                   	push   %eax
  800a42:	e8 3c fd ff ff       	call   800783 <getint>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a56:	85 d2                	test   %edx,%edx
  800a58:	79 23                	jns    800a7d <vprintfmt+0x29b>
				putch('-', putdat);
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	6a 2d                	push   $0x2d
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	ff d0                	call   *%eax
  800a67:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	f7 d8                	neg    %eax
  800a72:	83 d2 00             	adc    $0x0,%edx
  800a75:	f7 da                	neg    %edx
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a84:	e9 bc 00 00 00       	jmp    800b45 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a92:	50                   	push   %eax
  800a93:	e8 84 fc ff ff       	call   80071c <getuint>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa8:	e9 98 00 00 00       	jmp    800b45 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	6a 58                	push   $0x58
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	6a 58                	push   $0x58
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	ff d0                	call   *%eax
  800aca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	6a 58                	push   $0x58
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
			break;
  800add:	e9 ce 00 00 00       	jmp    800bb0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	6a 30                	push   $0x30
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	6a 78                	push   $0x78
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	ff d0                	call   *%eax
  800aff:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b24:	eb 1f                	jmp    800b45 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 e7 fb ff ff       	call   80071c <getuint>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4c:	83 ec 04             	sub    $0x4,%esp
  800b4f:	52                   	push   %edx
  800b50:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b53:	50                   	push   %eax
  800b54:	ff 75 f4             	pushl  -0xc(%ebp)
  800b57:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	ff 75 08             	pushl  0x8(%ebp)
  800b60:	e8 00 fb ff ff       	call   800665 <printnum>
  800b65:	83 c4 20             	add    $0x20,%esp
			break;
  800b68:	eb 46                	jmp    800bb0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	53                   	push   %ebx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			break;
  800b79:	eb 35                	jmp    800bb0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b7b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b82:	eb 2c                	jmp    800bb0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b84:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b8b:	eb 23                	jmp    800bb0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	6a 25                	push   $0x25
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9d:	ff 4d 10             	decl   0x10(%ebp)
  800ba0:	eb 03                	jmp    800ba5 <vprintfmt+0x3c3>
  800ba2:	ff 4d 10             	decl   0x10(%ebp)
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	48                   	dec    %eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	3c 25                	cmp    $0x25,%al
  800bad:	75 f3                	jne    800ba2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800baf:	90                   	nop
		}
	}
  800bb0:	e9 35 fc ff ff       	jmp    8007ea <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc6:	83 c0 04             	add    $0x4,%eax
  800bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	ff 75 08             	pushl  0x8(%ebp)
  800bd9:	e8 04 fc ff ff       	call   8007e2 <vprintfmt>
  800bde:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be1:	90                   	nop
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	8b 40 08             	mov    0x8(%eax),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	8b 10                	mov    (%eax),%edx
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	8b 40 04             	mov    0x4(%eax),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	73 12                	jae    800c17 <sprintputch+0x33>
		*b->buf++ = ch;
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 48 01             	lea    0x1(%eax),%ecx
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	89 0a                	mov    %ecx,(%edx)
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	88 10                	mov    %dl,(%eax)
}
  800c17:	90                   	nop
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	01 d0                	add    %edx,%eax
  800c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3f:	74 06                	je     800c47 <vsnprintf+0x2d>
  800c41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c45:	7f 07                	jg     800c4e <vsnprintf+0x34>
		return -E_INVAL;
  800c47:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4c:	eb 20                	jmp    800c6e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4e:	ff 75 14             	pushl  0x14(%ebp)
  800c51:	ff 75 10             	pushl  0x10(%ebp)
  800c54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c57:	50                   	push   %eax
  800c58:	68 e4 0b 80 00       	push   $0x800be4
  800c5d:	e8 80 fb ff ff       	call   8007e2 <vprintfmt>
  800c62:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c76:	8d 45 10             	lea    0x10(%ebp),%eax
  800c79:	83 c0 04             	add    $0x4,%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	ff 75 f4             	pushl  -0xc(%ebp)
  800c85:	50                   	push   %eax
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	ff 75 08             	pushl  0x8(%ebp)
  800c8c:	e8 89 ff ff ff       	call   800c1a <vsnprintf>
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca9:	eb 06                	jmp    800cb1 <strlen+0x15>
		n++;
  800cab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 f1                	jne    800cab <strlen+0xf>
		n++;
	return n;
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccc:	eb 09                	jmp    800cd7 <strnlen+0x18>
		n++;
  800cce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	ff 4d 0c             	decl   0xc(%ebp)
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	74 09                	je     800ce6 <strnlen+0x27>
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 e8                	jne    800cce <strnlen+0xf>
		n++;
	return n;
  800ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf7:	90                   	nop
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0a:	8a 12                	mov    (%edx),%dl
  800d0c:	88 10                	mov    %dl,(%eax)
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	75 e4                	jne    800cf8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2c:	eb 1f                	jmp    800d4d <strncpy+0x34>
		*dst++ = *src;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8a 12                	mov    (%edx),%dl
  800d3c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	74 03                	je     800d4a <strncpy+0x31>
			src++;
  800d47:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4a:	ff 45 fc             	incl   -0x4(%ebp)
  800d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d50:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d53:	72 d9                	jb     800d2e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6a:	74 30                	je     800d9c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d6c:	eb 16                	jmp    800d84 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	89 55 08             	mov    %edx,0x8(%ebp)
  800d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d80:	8a 12                	mov    (%edx),%dl
  800d82:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d84:	ff 4d 10             	decl   0x10(%ebp)
  800d87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8b:	74 09                	je     800d96 <strlcpy+0x3c>
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	84 c0                	test   %al,%al
  800d94:	75 d8                	jne    800d6e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da2:	29 c2                	sub    %eax,%edx
  800da4:	89 d0                	mov    %edx,%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dab:	eb 06                	jmp    800db3 <strcmp+0xb>
		p++, q++;
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	84 c0                	test   %al,%al
  800dba:	74 0e                	je     800dca <strcmp+0x22>
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 10                	mov    (%eax),%dl
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	38 c2                	cmp    %al,%dl
  800dc8:	74 e3                	je     800dad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	0f b6 d0             	movzbl %al,%edx
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 c0             	movzbl %al,%eax
  800dda:	29 c2                	sub    %eax,%edx
  800ddc:	89 d0                	mov    %edx,%eax
}
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de3:	eb 09                	jmp    800dee <strncmp+0xe>
		n--, p++, q++;
  800de5:	ff 4d 10             	decl   0x10(%ebp)
  800de8:	ff 45 08             	incl   0x8(%ebp)
  800deb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df2:	74 17                	je     800e0b <strncmp+0x2b>
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	84 c0                	test   %al,%al
  800dfb:	74 0e                	je     800e0b <strncmp+0x2b>
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 10                	mov    (%eax),%dl
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	38 c2                	cmp    %al,%dl
  800e09:	74 da                	je     800de5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	75 07                	jne    800e18 <strncmp+0x38>
		return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	eb 14                	jmp    800e2c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f b6 d0             	movzbl %al,%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 c0             	movzbl %al,%eax
  800e28:	29 c2                	sub    %eax,%edx
  800e2a:	89 d0                	mov    %edx,%eax
}
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 04             	sub    $0x4,%esp
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3a:	eb 12                	jmp    800e4e <strchr+0x20>
		if (*s == c)
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e44:	75 05                	jne    800e4b <strchr+0x1d>
			return (char *) s;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	eb 11                	jmp    800e5c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	75 e5                	jne    800e3c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 04             	sub    $0x4,%esp
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6a:	eb 0d                	jmp    800e79 <strfind+0x1b>
		if (*s == c)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e74:	74 0e                	je     800e84 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	84 c0                	test   %al,%al
  800e80:	75 ea                	jne    800e6c <strfind+0xe>
  800e82:	eb 01                	jmp    800e85 <strfind+0x27>
		if (*s == c)
			break;
  800e84:	90                   	nop
	return (char *) s;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e96:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e9a:	76 63                	jbe    800eff <memset+0x75>
		uint64 data_block = c;
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	99                   	cltd   
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eac:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eb0:	c1 e0 08             	shl    $0x8,%eax
  800eb3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebf:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ec3:	c1 e0 10             	shl    $0x10,%eax
  800ec6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed2:	89 c2                	mov    %eax,%edx
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800edf:	eb 18                	jmp    800ef9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ee1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee4:	8d 41 08             	lea    0x8(%ecx),%eax
  800ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef0:	89 01                	mov    %eax,(%ecx)
  800ef2:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efd:	77 e2                	ja     800ee1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f03:	74 23                	je     800f28 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f08:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f0b:	eb 0e                	jmp    800f1b <memset+0x91>
			*p8++ = (uint8)c;
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f10:	8d 50 01             	lea    0x1(%eax),%edx
  800f13:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 e5                	jne    800f0d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f3f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f43:	76 24                	jbe    800f69 <memcpy+0x3c>
		while(n >= 8){
  800f45:	eb 1c                	jmp    800f63 <memcpy+0x36>
			*d64 = *s64;
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	8b 50 04             	mov    0x4(%eax),%edx
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f52:	89 01                	mov    %eax,(%ecx)
  800f54:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f57:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f5b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f5f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f63:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f67:	77 de                	ja     800f47 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	74 31                	je     800fa0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f7b:	eb 16                	jmp    800f93 <memcpy+0x66>
			*d8++ = *s8++;
  800f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f80:	8d 50 01             	lea    0x1(%eax),%edx
  800f83:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f8f:	8a 12                	mov    (%edx),%dl
  800f91:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f99:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	75 dd                	jne    800f7d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbd:	73 50                	jae    80100f <memmove+0x6a>
  800fbf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	01 d0                	add    %edx,%eax
  800fc7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fca:	76 43                	jbe    80100f <memmove+0x6a>
		s += n;
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd8:	eb 10                	jmp    800fea <memmove+0x45>
			*--d = *--s;
  800fda:	ff 4d f8             	decl   -0x8(%ebp)
  800fdd:	ff 4d fc             	decl   -0x4(%ebp)
  800fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe3:	8a 10                	mov    (%eax),%dl
  800fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	75 e3                	jne    800fda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff7:	eb 23                	jmp    80101c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffc:	8d 50 01             	lea    0x1(%eax),%edx
  800fff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801002:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801005:	8d 4a 01             	lea    0x1(%edx),%ecx
  801008:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100b:	8a 12                	mov    (%edx),%dl
  80100d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	8d 50 ff             	lea    -0x1(%eax),%edx
  801015:	89 55 10             	mov    %edx,0x10(%ebp)
  801018:	85 c0                	test   %eax,%eax
  80101a:	75 dd                	jne    800ff9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801033:	eb 2a                	jmp    80105f <memcmp+0x3e>
		if (*s1 != *s2)
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801038:	8a 10                	mov    (%eax),%dl
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	38 c2                	cmp    %al,%dl
  801041:	74 16                	je     801059 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	0f b6 d0             	movzbl %al,%edx
  80104b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 c0             	movzbl %al,%eax
  801053:	29 c2                	sub    %eax,%edx
  801055:	89 d0                	mov    %edx,%eax
  801057:	eb 18                	jmp    801071 <memcmp+0x50>
		s1++, s2++;
  801059:	ff 45 fc             	incl   -0x4(%ebp)
  80105c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105f:	8b 45 10             	mov    0x10(%ebp),%eax
  801062:	8d 50 ff             	lea    -0x1(%eax),%edx
  801065:	89 55 10             	mov    %edx,0x10(%ebp)
  801068:	85 c0                	test   %eax,%eax
  80106a:	75 c9                	jne    801035 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801084:	eb 15                	jmp    80109b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	0f b6 d0             	movzbl %al,%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	0f b6 c0             	movzbl %al,%eax
  801094:	39 c2                	cmp    %eax,%edx
  801096:	74 0d                	je     8010a5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a1:	72 e3                	jb     801086 <memfind+0x13>
  8010a3:	eb 01                	jmp    8010a6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a5:	90                   	nop
	return (void *) s;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bf:	eb 03                	jmp    8010c4 <strtol+0x19>
		s++;
  8010c1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 20                	cmp    $0x20,%al
  8010cb:	74 f4                	je     8010c1 <strtol+0x16>
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 09                	cmp    $0x9,%al
  8010d4:	74 eb                	je     8010c1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 2b                	cmp    $0x2b,%al
  8010dd:	75 05                	jne    8010e4 <strtol+0x39>
		s++;
  8010df:	ff 45 08             	incl   0x8(%ebp)
  8010e2:	eb 13                	jmp    8010f7 <strtol+0x4c>
	else if (*s == '-')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 2d                	cmp    $0x2d,%al
  8010eb:	75 0a                	jne    8010f7 <strtol+0x4c>
		s++, neg = 1;
  8010ed:	ff 45 08             	incl   0x8(%ebp)
  8010f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fb:	74 06                	je     801103 <strtol+0x58>
  8010fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801101:	75 20                	jne    801123 <strtol+0x78>
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3c 30                	cmp    $0x30,%al
  80110a:	75 17                	jne    801123 <strtol+0x78>
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	40                   	inc    %eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 78                	cmp    $0x78,%al
  801114:	75 0d                	jne    801123 <strtol+0x78>
		s += 2, base = 16;
  801116:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80111a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801121:	eb 28                	jmp    80114b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	75 15                	jne    80113e <strtol+0x93>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	3c 30                	cmp    $0x30,%al
  801130:	75 0c                	jne    80113e <strtol+0x93>
		s++, base = 8;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113c:	eb 0d                	jmp    80114b <strtol+0xa0>
	else if (base == 0)
  80113e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801142:	75 07                	jne    80114b <strtol+0xa0>
		base = 10;
  801144:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	3c 2f                	cmp    $0x2f,%al
  801152:	7e 19                	jle    80116d <strtol+0xc2>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 39                	cmp    $0x39,%al
  80115b:	7f 10                	jg     80116d <strtol+0xc2>
			dig = *s - '0';
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f be c0             	movsbl %al,%eax
  801165:	83 e8 30             	sub    $0x30,%eax
  801168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116b:	eb 42                	jmp    8011af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 60                	cmp    $0x60,%al
  801174:	7e 19                	jle    80118f <strtol+0xe4>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 7a                	cmp    $0x7a,%al
  80117d:	7f 10                	jg     80118f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f be c0             	movsbl %al,%eax
  801187:	83 e8 57             	sub    $0x57,%eax
  80118a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118d:	eb 20                	jmp    8011af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 40                	cmp    $0x40,%al
  801196:	7e 39                	jle    8011d1 <strtol+0x126>
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 5a                	cmp    $0x5a,%al
  80119f:	7f 30                	jg     8011d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f be c0             	movsbl %al,%eax
  8011a9:	83 e8 37             	sub    $0x37,%eax
  8011ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b5:	7d 19                	jge    8011d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b7:	ff 45 08             	incl   0x8(%ebp)
  8011ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c1:	89 c2                	mov    %eax,%edx
  8011c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c6:	01 d0                	add    %edx,%eax
  8011c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011cb:	e9 7b ff ff ff       	jmp    80114b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d5:	74 08                	je     8011df <strtol+0x134>
		*endptr = (char *) s;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e3:	74 07                	je     8011ec <strtol+0x141>
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	f7 d8                	neg    %eax
  8011ea:	eb 03                	jmp    8011ef <strtol+0x144>
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801209:	79 13                	jns    80121e <ltostr+0x2d>
	{
		neg = 1;
  80120b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
  801215:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801218:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80121b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801226:	99                   	cltd   
  801227:	f7 f9                	idiv   %ecx
  801229:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80122c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122f:	8d 50 01             	lea    0x1(%eax),%edx
  801232:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123f:	83 c2 30             	add    $0x30,%edx
  801242:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801261:	75 bb                	jne    80121e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80126a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126d:	48                   	dec    %eax
  80126e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 3d                	je     8012b4 <ltostr+0xc3>
		start = 1 ;
  801277:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127e:	eb 34                	jmp    8012b4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 d0                	add    %edx,%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	01 c2                	add    %eax,%edx
  801295:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c8                	add    %ecx,%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	01 c2                	add    %eax,%edx
  8012a9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012ac:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ae:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ba:	7c c4                	jl     801280 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 c4 f9 ff ff       	call   800c9c <strlen>
  8012d8:	83 c4 04             	add    $0x4,%esp
  8012db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	e8 b6 f9 ff ff       	call   800c9c <strlen>
  8012e6:	83 c4 04             	add    $0x4,%esp
  8012e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fa:	eb 17                	jmp    801313 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	01 c8                	add    %ecx,%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801319:	7c e1                	jl     8012fc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801322:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801329:	eb 1f                	jmp    80134a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132e:	8d 50 01             	lea    0x1(%eax),%edx
  801331:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801334:	89 c2                	mov    %eax,%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 c2                	add    %eax,%edx
  80133b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	01 c8                	add    %ecx,%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801347:	ff 45 f8             	incl   -0x8(%ebp)
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801350:	7c d9                	jl     80132b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801352:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801355:	8b 45 10             	mov    0x10(%ebp),%eax
  801358:	01 d0                	add    %edx,%eax
  80135a:	c6 00 00             	movb   $0x0,(%eax)
}
  80135d:	90                   	nop
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801363:	8b 45 14             	mov    0x14(%ebp),%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801378:	8b 45 10             	mov    0x10(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801383:	eb 0c                	jmp    801391 <strsplit+0x31>
			*string++ = 0;
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8d 50 01             	lea    0x1(%eax),%edx
  80138b:	89 55 08             	mov    %edx,0x8(%ebp)
  80138e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 18                	je     8013b2 <strsplit+0x52>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	0f be c0             	movsbl %al,%eax
  8013a2:	50                   	push   %eax
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 83 fa ff ff       	call   800e2e <strchr>
  8013ab:	83 c4 08             	add    $0x8,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	75 d3                	jne    801385 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	84 c0                	test   %al,%al
  8013b9:	74 5a                	je     801415 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	83 f8 0f             	cmp    $0xf,%eax
  8013c3:	75 07                	jne    8013cc <strsplit+0x6c>
		{
			return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ca:	eb 66                	jmp    801432 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	8b 00                	mov    (%eax),%eax
  8013d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d4:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d7:	89 0a                	mov    %ecx,(%edx)
  8013d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e3:	01 c2                	add    %eax,%edx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ea:	eb 03                	jmp    8013ef <strsplit+0x8f>
			string++;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	84 c0                	test   %al,%al
  8013f6:	74 8b                	je     801383 <strsplit+0x23>
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	0f be c0             	movsbl %al,%eax
  801400:	50                   	push   %eax
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	e8 25 fa ff ff       	call   800e2e <strchr>
  801409:	83 c4 08             	add    $0x8,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	74 dc                	je     8013ec <strsplit+0x8c>
			string++;
	}
  801410:	e9 6e ff ff ff       	jmp    801383 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801415:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801422:	8b 45 10             	mov    0x10(%ebp),%eax
  801425:	01 d0                	add    %edx,%eax
  801427:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801447:	eb 4a                	jmp    801493 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801449:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	01 c2                	add    %eax,%edx
  801451:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	01 c8                	add    %ecx,%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80145d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 40                	cmp    $0x40,%al
  801469:	7e 25                	jle    801490 <str2lower+0x5c>
  80146b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 5a                	cmp    $0x5a,%al
  801477:	7f 17                	jg     801490 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801479:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	01 d0                	add    %edx,%eax
  801481:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801484:	8b 55 08             	mov    0x8(%ebp),%edx
  801487:	01 ca                	add    %ecx,%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	83 c2 20             	add    $0x20,%edx
  80148e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801490:	ff 45 fc             	incl   -0x4(%ebp)
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	e8 01 f8 ff ff       	call   800c9c <strlen>
  80149b:	83 c4 04             	add    $0x4,%esp
  80149e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014a1:	7f a6                	jg     801449 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014c3:	cd 30                	int    $0x30
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	5b                   	pop    %ebx
  8014cf:	5e                   	pop    %esi
  8014d0:	5f                   	pop    %edi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	6a 00                	push   $0x0
  8014eb:	51                   	push   %ecx
  8014ec:	52                   	push   %edx
  8014ed:	ff 75 0c             	pushl  0xc(%ebp)
  8014f0:	50                   	push   %eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	e8 b0 ff ff ff       	call   8014a8 <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 02                	push   $0x2
  80150d:	e8 96 ff ff ff       	call   8014a8 <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 03                	push   $0x3
  801526:	e8 7d ff ff ff       	call   8014a8 <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	90                   	nop
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 04                	push   $0x4
  801540:	e8 63 ff ff ff       	call   8014a8 <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	90                   	nop
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	6a 08                	push   $0x8
  80155e:	e8 45 ff ff ff       	call   8014a8 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	56                   	push   %esi
  80156c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80156d:	8b 75 18             	mov    0x18(%ebp),%esi
  801570:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801573:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801576:	8b 55 0c             	mov    0xc(%ebp),%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
  80157e:	51                   	push   %ecx
  80157f:	52                   	push   %edx
  801580:	50                   	push   %eax
  801581:	6a 09                	push   $0x9
  801583:	e8 20 ff ff ff       	call   8014a8 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	ff 75 08             	pushl  0x8(%ebp)
  8015a0:	6a 0a                	push   $0xa
  8015a2:	e8 01 ff ff ff       	call   8014a8 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	ff 75 0c             	pushl  0xc(%ebp)
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	6a 0b                	push   $0xb
  8015bd:	e8 e6 fe ff ff       	call   8014a8 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 0c                	push   $0xc
  8015d6:	e8 cd fe ff ff       	call   8014a8 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 0d                	push   $0xd
  8015ef:	e8 b4 fe ff ff       	call   8014a8 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 0e                	push   $0xe
  801608:	e8 9b fe ff ff       	call   8014a8 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 0f                	push   $0xf
  801621:	e8 82 fe ff ff       	call   8014a8 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	6a 10                	push   $0x10
  80163b:	e8 68 fe ff ff       	call   8014a8 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 11                	push   $0x11
  801654:	e8 4f fe ff ff       	call   8014a8 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	90                   	nop
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_cputc>:

void
sys_cputc(const char c)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80166b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	50                   	push   %eax
  801678:	6a 01                	push   $0x1
  80167a:	e8 29 fe ff ff       	call   8014a8 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	90                   	nop
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 14                	push   $0x14
  801694:	e8 0f fe ff ff       	call   8014a8 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	90                   	nop
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	51                   	push   %ecx
  8016b8:	52                   	push   %edx
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	50                   	push   %eax
  8016bd:	6a 15                	push   $0x15
  8016bf:	e8 e4 fd ff ff       	call   8014a8 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	6a 16                	push   $0x16
  8016dc:	e8 c7 fd ff ff       	call   8014a8 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	51                   	push   %ecx
  8016f7:	52                   	push   %edx
  8016f8:	50                   	push   %eax
  8016f9:	6a 17                	push   $0x17
  8016fb:	e8 a8 fd ff ff       	call   8014a8 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	52                   	push   %edx
  801715:	50                   	push   %eax
  801716:	6a 18                	push   $0x18
  801718:	e8 8b fd ff ff       	call   8014a8 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 14             	pushl  0x14(%ebp)
  80172d:	ff 75 10             	pushl  0x10(%ebp)
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	50                   	push   %eax
  801734:	6a 19                	push   $0x19
  801736:	e8 6d fd ff ff       	call   8014a8 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	50                   	push   %eax
  80174f:	6a 1a                	push   $0x1a
  801751:	e8 52 fd ff ff       	call   8014a8 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	90                   	nop
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	50                   	push   %eax
  80176b:	6a 1b                	push   $0x1b
  80176d:	e8 36 fd ff ff       	call   8014a8 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 05                	push   $0x5
  801786:	e8 1d fd ff ff       	call   8014a8 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 06                	push   $0x6
  80179f:	e8 04 fd ff ff       	call   8014a8 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 07                	push   $0x7
  8017b8:	e8 eb fc ff ff       	call   8014a8 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_exit_env>:


void sys_exit_env(void)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 1c                	push   $0x1c
  8017d1:	e8 d2 fc ff ff       	call   8014a8 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e5:	8d 50 04             	lea    0x4(%eax),%edx
  8017e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 1d                	push   $0x1d
  8017f5:	e8 ae fc ff ff       	call   8014a8 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
	return result;
  8017fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801800:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801803:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801806:	89 01                	mov    %eax,(%ecx)
  801808:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	c9                   	leave  
  80180f:	c2 04 00             	ret    $0x4

00801812 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	ff 75 10             	pushl  0x10(%ebp)
  80181c:	ff 75 0c             	pushl  0xc(%ebp)
  80181f:	ff 75 08             	pushl  0x8(%ebp)
  801822:	6a 13                	push   $0x13
  801824:	e8 7f fc ff ff       	call   8014a8 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
	return ;
  80182c:	90                   	nop
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_rcr2>:
uint32 sys_rcr2()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 1e                	push   $0x1e
  80183e:	e8 65 fc ff ff       	call   8014a8 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801854:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	50                   	push   %eax
  801861:	6a 1f                	push   $0x1f
  801863:	e8 40 fc ff ff       	call   8014a8 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
	return ;
  80186b:	90                   	nop
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <rsttst>:
void rsttst()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 21                	push   $0x21
  80187d:	e8 26 fc ff ff       	call   8014a8 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
	return ;
  801885:	90                   	nop
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	8b 45 14             	mov    0x14(%ebp),%eax
  801891:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801894:	8b 55 18             	mov    0x18(%ebp),%edx
  801897:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	ff 75 10             	pushl  0x10(%ebp)
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	6a 20                	push   $0x20
  8018a8:	e8 fb fb ff ff       	call   8014a8 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b0:	90                   	nop
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <chktst>:
void chktst(uint32 n)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	6a 22                	push   $0x22
  8018c3:	e8 e0 fb ff ff       	call   8014a8 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cb:	90                   	nop
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <inctst>:

void inctst()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 23                	push   $0x23
  8018dd:	e8 c6 fb ff ff       	call   8014a8 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e5:	90                   	nop
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <gettst>:
uint32 gettst()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 24                	push   $0x24
  8018f7:	e8 ac fb ff ff       	call   8014a8 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 25                	push   $0x25
  801910:	e8 93 fb ff ff       	call   8014a8 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
  801918:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80191d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 26                	push   $0x26
  80193c:	e8 67 fb ff ff       	call   8014a8 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return ;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80194b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	53                   	push   %ebx
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	6a 27                	push   $0x27
  80195f:	e8 44 fb ff ff       	call   8014a8 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 28                	push   $0x28
  80197f:	e8 24 fb ff ff       	call   8014a8 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80198c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	51                   	push   %ecx
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 29                	push   $0x29
  80199f:	e8 04 fb ff ff       	call   8014a8 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 10             	pushl  0x10(%ebp)
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	6a 12                	push   $0x12
  8019bb:	e8 e8 fa ff ff       	call   8014a8 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c3:	90                   	nop
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	52                   	push   %edx
  8019d6:	50                   	push   %eax
  8019d7:	6a 2a                	push   $0x2a
  8019d9:	e8 ca fa ff ff       	call   8014a8 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
	return;
  8019e1:	90                   	nop
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 2b                	push   $0x2b
  8019f3:	e8 b0 fa ff ff       	call   8014a8 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	6a 2d                	push   $0x2d
  801a0e:	e8 95 fa ff ff       	call   8014a8 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	6a 2c                	push   $0x2c
  801a2a:	e8 79 fa ff ff       	call   8014a8 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a32:	90                   	nop
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 28 25 80 00       	push   $0x802528
  801a43:	68 25 01 00 00       	push   $0x125
  801a48:	68 5b 25 80 00       	push   $0x80255b
  801a4d:	e8 a3 e8 ff ff       	call   8002f5 <_panic>

00801a52 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	68 6c 25 80 00       	push   $0x80256c
  801a60:	6a 07                	push   $0x7
  801a62:	68 9b 25 80 00       	push   $0x80259b
  801a67:	e8 89 e8 ff ff       	call   8002f5 <_panic>

00801a6c <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	68 ac 25 80 00       	push   $0x8025ac
  801a7a:	6a 0b                	push   $0xb
  801a7c:	68 9b 25 80 00       	push   $0x80259b
  801a81:	e8 6f e8 ff ff       	call   8002f5 <_panic>

00801a86 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 d8 25 80 00       	push   $0x8025d8
  801a94:	6a 10                	push   $0x10
  801a96:	68 9b 25 80 00       	push   $0x80259b
  801a9b:	e8 55 e8 ff ff       	call   8002f5 <_panic>

00801aa0 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 08 26 80 00       	push   $0x802608
  801aae:	6a 15                	push   $0x15
  801ab0:	68 9b 25 80 00       	push   $0x80259b
  801ab5:	e8 3b e8 ff ff       	call   8002f5 <_panic>

00801aba <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    

00801ac5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801acb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ace:	89 d0                	mov    %edx,%eax
  801ad0:	c1 e0 02             	shl    $0x2,%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801adc:	01 d0                	add    %edx,%eax
  801ade:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae5:	01 d0                	add    %edx,%eax
  801ae7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aee:	01 d0                	add    %edx,%eax
  801af0:	c1 e0 04             	shl    $0x4,%eax
  801af3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801afd:	0f 31                	rdtsc  
  801aff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b02:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b0e:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b11:	eb 46                	jmp    801b59 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b13:	0f 31                	rdtsc  
  801b15:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b18:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b24:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2d:	29 c2                	sub    %eax,%edx
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	89 d1                	mov    %edx,%ecx
  801b3c:	29 c1                	sub    %eax,%ecx
  801b3e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b44:	39 c2                	cmp    %eax,%edx
  801b46:	0f 97 c0             	seta   %al
  801b49:	0f b6 c0             	movzbl %al,%eax
  801b4c:	29 c1                	sub    %eax,%ecx
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b5f:	72 b2                	jb     801b13 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b71:	eb 03                	jmp    801b76 <busy_wait+0x12>
  801b73:	ff 45 fc             	incl   -0x4(%ebp)
  801b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b79:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b7c:	72 f5                	jb     801b73 <busy_wait+0xf>
	return i;
  801b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    
  801b83:	90                   	nop

00801b84 <__udivdi3>:
  801b84:	55                   	push   %ebp
  801b85:	57                   	push   %edi
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 1c             	sub    $0x1c,%esp
  801b8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9b:	89 ca                	mov    %ecx,%edx
  801b9d:	89 f8                	mov    %edi,%eax
  801b9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba3:	85 f6                	test   %esi,%esi
  801ba5:	75 2d                	jne    801bd4 <__udivdi3+0x50>
  801ba7:	39 cf                	cmp    %ecx,%edi
  801ba9:	77 65                	ja     801c10 <__udivdi3+0x8c>
  801bab:	89 fd                	mov    %edi,%ebp
  801bad:	85 ff                	test   %edi,%edi
  801baf:	75 0b                	jne    801bbc <__udivdi3+0x38>
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	31 d2                	xor    %edx,%edx
  801bb8:	f7 f7                	div    %edi
  801bba:	89 c5                	mov    %eax,%ebp
  801bbc:	31 d2                	xor    %edx,%edx
  801bbe:	89 c8                	mov    %ecx,%eax
  801bc0:	f7 f5                	div    %ebp
  801bc2:	89 c1                	mov    %eax,%ecx
  801bc4:	89 d8                	mov    %ebx,%eax
  801bc6:	f7 f5                	div    %ebp
  801bc8:	89 cf                	mov    %ecx,%edi
  801bca:	89 fa                	mov    %edi,%edx
  801bcc:	83 c4 1c             	add    $0x1c,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
  801bd4:	39 ce                	cmp    %ecx,%esi
  801bd6:	77 28                	ja     801c00 <__udivdi3+0x7c>
  801bd8:	0f bd fe             	bsr    %esi,%edi
  801bdb:	83 f7 1f             	xor    $0x1f,%edi
  801bde:	75 40                	jne    801c20 <__udivdi3+0x9c>
  801be0:	39 ce                	cmp    %ecx,%esi
  801be2:	72 0a                	jb     801bee <__udivdi3+0x6a>
  801be4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801be8:	0f 87 9e 00 00 00    	ja     801c8c <__udivdi3+0x108>
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	89 fa                	mov    %edi,%edx
  801bf5:	83 c4 1c             	add    $0x1c,%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    
  801bfd:	8d 76 00             	lea    0x0(%esi),%esi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	31 c0                	xor    %eax,%eax
  801c04:	89 fa                	mov    %edi,%edx
  801c06:	83 c4 1c             	add    $0x1c,%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5f                   	pop    %edi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	f7 f7                	div    %edi
  801c14:	31 ff                	xor    %edi,%edi
  801c16:	89 fa                	mov    %edi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c25:	89 eb                	mov    %ebp,%ebx
  801c27:	29 fb                	sub    %edi,%ebx
  801c29:	89 f9                	mov    %edi,%ecx
  801c2b:	d3 e6                	shl    %cl,%esi
  801c2d:	89 c5                	mov    %eax,%ebp
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ed                	shr    %cl,%ebp
  801c33:	89 e9                	mov    %ebp,%ecx
  801c35:	09 f1                	or     %esi,%ecx
  801c37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3b:	89 f9                	mov    %edi,%ecx
  801c3d:	d3 e0                	shl    %cl,%eax
  801c3f:	89 c5                	mov    %eax,%ebp
  801c41:	89 d6                	mov    %edx,%esi
  801c43:	88 d9                	mov    %bl,%cl
  801c45:	d3 ee                	shr    %cl,%esi
  801c47:	89 f9                	mov    %edi,%ecx
  801c49:	d3 e2                	shl    %cl,%edx
  801c4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4f:	88 d9                	mov    %bl,%cl
  801c51:	d3 e8                	shr    %cl,%eax
  801c53:	09 c2                	or     %eax,%edx
  801c55:	89 d0                	mov    %edx,%eax
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	f7 74 24 0c          	divl   0xc(%esp)
  801c5d:	89 d6                	mov    %edx,%esi
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	f7 e5                	mul    %ebp
  801c63:	39 d6                	cmp    %edx,%esi
  801c65:	72 19                	jb     801c80 <__udivdi3+0xfc>
  801c67:	74 0b                	je     801c74 <__udivdi3+0xf0>
  801c69:	89 d8                	mov    %ebx,%eax
  801c6b:	31 ff                	xor    %edi,%edi
  801c6d:	e9 58 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c78:	89 f9                	mov    %edi,%ecx
  801c7a:	d3 e2                	shl    %cl,%edx
  801c7c:	39 c2                	cmp    %eax,%edx
  801c7e:	73 e9                	jae    801c69 <__udivdi3+0xe5>
  801c80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c83:	31 ff                	xor    %edi,%edi
  801c85:	e9 40 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	31 c0                	xor    %eax,%eax
  801c8e:	e9 37 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c93:	90                   	nop

00801c94 <__umoddi3>:
  801c94:	55                   	push   %ebp
  801c95:	57                   	push   %edi
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 1c             	sub    $0x1c,%esp
  801c9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ca7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801caf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb3:	89 f3                	mov    %esi,%ebx
  801cb5:	89 fa                	mov    %edi,%edx
  801cb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbb:	89 34 24             	mov    %esi,(%esp)
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	75 1a                	jne    801cdc <__umoddi3+0x48>
  801cc2:	39 f7                	cmp    %esi,%edi
  801cc4:	0f 86 a2 00 00 00    	jbe    801d6c <__umoddi3+0xd8>
  801cca:	89 c8                	mov    %ecx,%eax
  801ccc:	89 f2                	mov    %esi,%edx
  801cce:	f7 f7                	div    %edi
  801cd0:	89 d0                	mov    %edx,%eax
  801cd2:	31 d2                	xor    %edx,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	39 f0                	cmp    %esi,%eax
  801cde:	0f 87 ac 00 00 00    	ja     801d90 <__umoddi3+0xfc>
  801ce4:	0f bd e8             	bsr    %eax,%ebp
  801ce7:	83 f5 1f             	xor    $0x1f,%ebp
  801cea:	0f 84 ac 00 00 00    	je     801d9c <__umoddi3+0x108>
  801cf0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf5:	29 ef                	sub    %ebp,%edi
  801cf7:	89 fe                	mov    %edi,%esi
  801cf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 e0                	shl    %cl,%eax
  801d01:	89 d7                	mov    %edx,%edi
  801d03:	89 f1                	mov    %esi,%ecx
  801d05:	d3 ef                	shr    %cl,%edi
  801d07:	09 c7                	or     %eax,%edi
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 e2                	shl    %cl,%edx
  801d0d:	89 14 24             	mov    %edx,(%esp)
  801d10:	89 d8                	mov    %ebx,%eax
  801d12:	d3 e0                	shl    %cl,%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1a:	d3 e0                	shl    %cl,%eax
  801d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d20:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d24:	89 f1                	mov    %esi,%ecx
  801d26:	d3 e8                	shr    %cl,%eax
  801d28:	09 d0                	or     %edx,%eax
  801d2a:	d3 eb                	shr    %cl,%ebx
  801d2c:	89 da                	mov    %ebx,%edx
  801d2e:	f7 f7                	div    %edi
  801d30:	89 d3                	mov    %edx,%ebx
  801d32:	f7 24 24             	mull   (%esp)
  801d35:	89 c6                	mov    %eax,%esi
  801d37:	89 d1                	mov    %edx,%ecx
  801d39:	39 d3                	cmp    %edx,%ebx
  801d3b:	0f 82 87 00 00 00    	jb     801dc8 <__umoddi3+0x134>
  801d41:	0f 84 91 00 00 00    	je     801dd8 <__umoddi3+0x144>
  801d47:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4b:	29 f2                	sub    %esi,%edx
  801d4d:	19 cb                	sbb    %ecx,%ebx
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d55:	d3 e0                	shl    %cl,%eax
  801d57:	89 e9                	mov    %ebp,%ecx
  801d59:	d3 ea                	shr    %cl,%edx
  801d5b:	09 d0                	or     %edx,%eax
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 eb                	shr    %cl,%ebx
  801d61:	89 da                	mov    %ebx,%edx
  801d63:	83 c4 1c             	add    $0x1c,%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    
  801d6b:	90                   	nop
  801d6c:	89 fd                	mov    %edi,%ebp
  801d6e:	85 ff                	test   %edi,%edi
  801d70:	75 0b                	jne    801d7d <__umoddi3+0xe9>
  801d72:	b8 01 00 00 00       	mov    $0x1,%eax
  801d77:	31 d2                	xor    %edx,%edx
  801d79:	f7 f7                	div    %edi
  801d7b:	89 c5                	mov    %eax,%ebp
  801d7d:	89 f0                	mov    %esi,%eax
  801d7f:	31 d2                	xor    %edx,%edx
  801d81:	f7 f5                	div    %ebp
  801d83:	89 c8                	mov    %ecx,%eax
  801d85:	f7 f5                	div    %ebp
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	e9 44 ff ff ff       	jmp    801cd2 <__umoddi3+0x3e>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	89 f2                	mov    %esi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	3b 04 24             	cmp    (%esp),%eax
  801d9f:	72 06                	jb     801da7 <__umoddi3+0x113>
  801da1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da5:	77 0f                	ja     801db6 <__umoddi3+0x122>
  801da7:	89 f2                	mov    %esi,%edx
  801da9:	29 f9                	sub    %edi,%ecx
  801dab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801daf:	89 14 24             	mov    %edx,(%esp)
  801db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801db6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dba:	8b 14 24             	mov    (%esp),%edx
  801dbd:	83 c4 1c             	add    $0x1c,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5f                   	pop    %edi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    
  801dc5:	8d 76 00             	lea    0x0(%esi),%esi
  801dc8:	2b 04 24             	sub    (%esp),%eax
  801dcb:	19 fa                	sbb    %edi,%edx
  801dcd:	89 d1                	mov    %edx,%ecx
  801dcf:	89 c6                	mov    %eax,%esi
  801dd1:	e9 71 ff ff ff       	jmp    801d47 <__umoddi3+0xb3>
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ddc:	72 ea                	jb     801dc8 <__umoddi3+0x134>
  801dde:	89 d9                	mov    %ebx,%ecx
  801de0:	e9 62 ff ff ff       	jmp    801d47 <__umoddi3+0xb3>
