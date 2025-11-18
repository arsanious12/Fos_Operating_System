
obj/user/priRR_fib_create:     file format elf32-i386


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
  800031:	e8 23 01 00 00       	call   800159 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int32 envIdFib1 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800054:	89 c1                	mov    %eax,%ecx
  800056:	a1 20 30 80 00       	mov    0x803020,%eax
  80005b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800061:	52                   	push   %edx
  800062:	51                   	push   %ecx
  800063:	50                   	push   %eax
  800064:	68 e0 1c 80 00       	push   $0x801ce0
  800069:	e8 dd 16 00 00       	call   80174b <sys_create_env>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (envIdFib1 == E_ENV_CREATION_ERROR)
  800074:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  800078:	75 14                	jne    80008e <_main+0x56>
		panic("Loading programs failed\n");
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	68 ea 1c 80 00       	push   $0x801cea
  800082:	6a 0b                	push   $0xb
  800084:	68 03 1d 80 00       	push   $0x801d03
  800089:	e8 90 02 00 00       	call   80031e <_panic>

	int32 envIdFib2 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80008e:	a1 20 30 80 00       	mov    0x803020,%eax
  800093:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000a4:	89 c1                	mov    %eax,%ecx
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b1:	52                   	push   %edx
  8000b2:	51                   	push   %ecx
  8000b3:	50                   	push   %eax
  8000b4:	68 e0 1c 80 00       	push   $0x801ce0
  8000b9:	e8 8d 16 00 00       	call   80174b <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (envIdFib2 == E_ENV_CREATION_ERROR)
  8000c4:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000c8:	75 14                	jne    8000de <_main+0xa6>
		panic("Loading programs failed\n");
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	68 ea 1c 80 00       	push   $0x801cea
  8000d2:	6a 0f                	push   $0xf
  8000d4:	68 03 1d 80 00       	push   $0x801d03
  8000d9:	e8 40 02 00 00       	call   80031e <_panic>

	sys_run_env(envIdFib1);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e4:	e8 80 16 00 00       	call   801769 <sys_run_env>
  8000e9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdFib2);
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f2:	e8 72 16 00 00       	call   801769 <sys_run_env>
  8000f7:	83 c4 10             	add    $0x10,%esp

	int priority = 2;
  8000fa:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib1, priority);
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	ff 75 f4             	pushl  -0xc(%ebp)
  80010a:	68 1c 1d 80 00       	push   $0x801d1c
  80010f:	e8 d8 04 00 00       	call   8005ec <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib1, priority);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	ff 75 ec             	pushl  -0x14(%ebp)
  80011d:	ff 75 f4             	pushl  -0xc(%ebp)
  800120:	e8 39 19 00 00       	call   801a5e <sys_env_set_priority>
  800125:	83 c4 10             	add    $0x10,%esp

	priority = 9;
  800128:	c7 45 ec 09 00 00 00 	movl   $0x9,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib2, priority);
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	ff 75 f0             	pushl  -0x10(%ebp)
  800138:	68 1c 1d 80 00       	push   $0x801d1c
  80013d:	e8 aa 04 00 00       	call   8005ec <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib2, priority);
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 ec             	pushl  -0x14(%ebp)
  80014b:	ff 75 f0             	pushl  -0x10(%ebp)
  80014e:	e8 0b 19 00 00       	call   801a5e <sys_env_set_priority>
  800153:	83 c4 10             	add    $0x10,%esp
return;
  800156:	90                   	nop
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	57                   	push   %edi
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800162:	e8 52 16 00 00       	call   8017b9 <sys_getenvindex>
  800167:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80016a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80016d:	89 d0                	mov    %edx,%eax
  80016f:	c1 e0 06             	shl    $0x6,%eax
  800172:	29 d0                	sub    %edx,%eax
  800174:	c1 e0 02             	shl    $0x2,%eax
  800177:	01 d0                	add    %edx,%eax
  800179:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800180:	01 c8                	add    %ecx,%eax
  800182:	c1 e0 03             	shl    $0x3,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	29 c2                	sub    %eax,%edx
  800190:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80019f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a9:	8a 40 20             	mov    0x20(%eax),%al
  8001ac:	84 c0                	test   %al,%al
  8001ae:	74 0d                	je     8001bd <libmain+0x64>
		binaryname = myEnv->prog_name;
  8001b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b5:	83 c0 20             	add    $0x20,%eax
  8001b8:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c1:	7e 0a                	jle    8001cd <libmain+0x74>
		binaryname = argv[0];
  8001c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c6:	8b 00                	mov    (%eax),%eax
  8001c8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	e8 5d fe ff ff       	call   800038 <_main>
  8001db:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001de:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	0f 84 01 01 00 00    	je     8002ec <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001eb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f1:	bb 4c 1e 80 00       	mov    $0x801e4c,%ebx
  8001f6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800203:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800206:	b9 56 00 00 00       	mov    $0x56,%ecx
  80020b:	b0 00                	mov    $0x0,%al
  80020d:	89 d7                	mov    %edx,%edi
  80020f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800211:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800218:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	50                   	push   %eax
  80021f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	e8 c4 17 00 00       	call   8019ef <sys_utilities>
  80022b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80022e:	e8 0d 13 00 00       	call   801540 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 6c 1d 80 00       	push   $0x801d6c
  80023b:	e8 ac 03 00 00       	call   8005ec <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800243:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800246:	85 c0                	test   %eax,%eax
  800248:	74 18                	je     800262 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80024a:	e8 be 17 00 00       	call   801a0d <sys_get_optimal_num_faults>
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 94 1d 80 00       	push   $0x801d94
  800258:	e8 8f 03 00 00       	call   8005ec <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	eb 59                	jmp    8002bb <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80026d:	a1 20 30 80 00       	mov    0x803020,%eax
  800272:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	52                   	push   %edx
  80027c:	50                   	push   %eax
  80027d:	68 b8 1d 80 00       	push   $0x801db8
  800282:	e8 65 03 00 00       	call   8005ec <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80028a:	a1 20 30 80 00       	mov    0x803020,%eax
  80028f:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002ab:	51                   	push   %ecx
  8002ac:	52                   	push   %edx
  8002ad:	50                   	push   %eax
  8002ae:	68 e0 1d 80 00       	push   $0x801de0
  8002b3:	e8 34 03 00 00       	call   8005ec <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	50                   	push   %eax
  8002ca:	68 38 1e 80 00       	push   $0x801e38
  8002cf:	e8 18 03 00 00       	call   8005ec <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 6c 1d 80 00       	push   $0x801d6c
  8002df:	e8 08 03 00 00       	call   8005ec <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002e7:	e8 6e 12 00 00       	call   80155a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ec:	e8 1f 00 00 00       	call   800310 <exit>
}
  8002f1:	90                   	nop
  8002f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f5:	5b                   	pop    %ebx
  8002f6:	5e                   	pop    %esi
  8002f7:	5f                   	pop    %edi
  8002f8:	5d                   	pop    %ebp
  8002f9:	c3                   	ret    

008002fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	6a 00                	push   $0x0
  800305:	e8 7b 14 00 00       	call   801785 <sys_destroy_env>
  80030a:	83 c4 10             	add    $0x10,%esp
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <exit>:

void
exit(void)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800316:	e8 d0 14 00 00       	call   8017eb <sys_exit_env>
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800324:	8d 45 10             	lea    0x10(%ebp),%eax
  800327:	83 c0 04             	add    $0x4,%eax
  80032a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80032d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800332:	85 c0                	test   %eax,%eax
  800334:	74 16                	je     80034c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800336:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	68 b0 1e 80 00       	push   $0x801eb0
  800344:	e8 a3 02 00 00       	call   8005ec <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80034c:	a1 04 30 80 00       	mov    0x803004,%eax
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	50                   	push   %eax
  80035b:	68 b8 1e 80 00       	push   $0x801eb8
  800360:	6a 74                	push   $0x74
  800362:	e8 b2 02 00 00       	call   800619 <cprintf_colored>
  800367:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	83 ec 08             	sub    $0x8,%esp
  800370:	ff 75 f4             	pushl  -0xc(%ebp)
  800373:	50                   	push   %eax
  800374:	e8 04 02 00 00       	call   80057d <vcprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	6a 00                	push   $0x0
  800381:	68 e0 1e 80 00       	push   $0x801ee0
  800386:	e8 f2 01 00 00       	call   80057d <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80038e:	e8 7d ff ff ff       	call   800310 <exit>

	// should not return here
	while (1) ;
  800393:	eb fe                	jmp    800393 <_panic+0x75>

00800395 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039b:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 e4 1e 80 00       	push   $0x801ee4
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 30 1f 80 00       	push   $0x801f30
  8003bc:	e8 5d ff ff ff       	call   80031e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c5 00 00 00       	jmp    800499 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a5 00 00 00       	jmp    800496 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 30 80 00       	mov    0x803020,%eax
  800406:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 30 80 00       	mov    0x803020,%eax
  800426:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 15                	jmp    80047c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 30 80 00       	mov    0x803020,%eax
  80046f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	77 85                	ja     800401 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80047c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800480:	75 14                	jne    800496 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800482:	83 ec 04             	sub    $0x4,%esp
  800485:	68 3c 1f 80 00       	push   $0x801f3c
  80048a:	6a 3a                	push   $0x3a
  80048c:	68 30 1f 80 00       	push   $0x801f30
  800491:	e8 88 fe ff ff       	call   80031e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800496:	ff 45 f0             	incl   -0x10(%ebp)
  800499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049f:	0f 8c 2f ff ff ff    	jl     8003d4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b3:	eb 26                	jmp    8004db <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ba:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	01 d0                	add    %edx,%eax
  8004c9:	c1 e0 03             	shl    $0x3,%eax
  8004cc:	01 c8                	add    %ecx,%eax
  8004ce:	8a 40 04             	mov    0x4(%eax),%al
  8004d1:	3c 01                	cmp    $0x1,%al
  8004d3:	75 03                	jne    8004d8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d8:	ff 45 e0             	incl   -0x20(%ebp)
  8004db:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e9:	39 c2                	cmp    %eax,%edx
  8004eb:	77 c8                	ja     8004b5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004f3:	74 14                	je     800509 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 90 1f 80 00       	push   $0x801f90
  8004fd:	6a 44                	push   $0x44
  8004ff:	68 30 1f 80 00       	push   $0x801f30
  800504:	e8 15 fe ff ff       	call   80031e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800509:	90                   	nop
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	53                   	push   %ebx
  800510:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	8d 48 01             	lea    0x1(%eax),%ecx
  80051b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051e:	89 0a                	mov    %ecx,(%edx)
  800520:	8b 55 08             	mov    0x8(%ebp),%edx
  800523:	88 d1                	mov    %dl,%cl
  800525:	8b 55 0c             	mov    0xc(%ebp),%edx
  800528:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	3d ff 00 00 00       	cmp    $0xff,%eax
  800536:	75 30                	jne    800568 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800538:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80053e:	a0 44 30 80 00       	mov    0x803044,%al
  800543:	0f b6 c0             	movzbl %al,%eax
  800546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800549:	8b 09                	mov    (%ecx),%ecx
  80054b:	89 cb                	mov    %ecx,%ebx
  80054d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800550:	83 c1 08             	add    $0x8,%ecx
  800553:	52                   	push   %edx
  800554:	50                   	push   %eax
  800555:	53                   	push   %ebx
  800556:	51                   	push   %ecx
  800557:	e8 a0 0f 00 00       	call   8014fc <sys_cputs>
  80055c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	8b 40 04             	mov    0x4(%eax),%eax
  80056e:	8d 50 01             	lea    0x1(%eax),%edx
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	89 50 04             	mov    %edx,0x4(%eax)
}
  800577:	90                   	nop
  800578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800586:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058d:	00 00 00 
	b.cnt = 0;
  800590:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800597:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059a:	ff 75 0c             	pushl  0xc(%ebp)
  80059d:	ff 75 08             	pushl  0x8(%ebp)
  8005a0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a6:	50                   	push   %eax
  8005a7:	68 0c 05 80 00       	push   $0x80050c
  8005ac:	e8 5a 02 00 00       	call   80080b <vprintfmt>
  8005b1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005b4:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005ba:	a0 44 30 80 00       	mov    0x803044,%al
  8005bf:	0f b6 c0             	movzbl %al,%eax
  8005c2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	51                   	push   %ecx
  8005cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d1:	83 c0 08             	add    $0x8,%eax
  8005d4:	50                   	push   %eax
  8005d5:	e8 22 0f 00 00       	call   8014fc <sys_cputs>
  8005da:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005dd:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 f4             	pushl  -0xc(%ebp)
  800608:	50                   	push   %eax
  800609:	e8 6f ff ff ff       	call   80057d <vcprintf>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	c1 e0 08             	shl    $0x8,%eax
  80062c:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800631:	8d 45 0c             	lea    0xc(%ebp),%eax
  800634:	83 c0 04             	add    $0x4,%eax
  800637:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 f4             	pushl  -0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	e8 34 ff ff ff       	call   80057d <vcprintf>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80064f:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800656:	07 00 00 

	return cnt;
  800659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800664:	e8 d7 0e 00 00       	call   801540 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800669:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 f4             	pushl  -0xc(%ebp)
  800678:	50                   	push   %eax
  800679:	e8 ff fe ff ff       	call   80057d <vcprintf>
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800684:	e8 d1 0e 00 00       	call   80155a <sys_unlock_cons>
	return cnt;
  800689:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	53                   	push   %ebx
  800692:	83 ec 14             	sub    $0x14,%esp
  800695:	8b 45 10             	mov    0x10(%ebp),%eax
  800698:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ac:	77 55                	ja     800703 <printnum+0x75>
  8006ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b1:	72 05                	jb     8006b8 <printnum+0x2a>
  8006b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b6:	77 4b                	ja     800703 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006be:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c6:	52                   	push   %edx
  8006c7:	50                   	push   %eax
  8006c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ce:	e8 a9 13 00 00       	call   801a7c <__udivdi3>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	ff 75 20             	pushl  0x20(%ebp)
  8006dc:	53                   	push   %ebx
  8006dd:	ff 75 18             	pushl  0x18(%ebp)
  8006e0:	52                   	push   %edx
  8006e1:	50                   	push   %eax
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 08             	pushl  0x8(%ebp)
  8006e8:	e8 a1 ff ff ff       	call   80068e <printnum>
  8006ed:	83 c4 20             	add    $0x20,%esp
  8006f0:	eb 1a                	jmp    80070c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 20             	pushl  0x20(%ebp)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800703:	ff 4d 1c             	decl   0x1c(%ebp)
  800706:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070a:	7f e6                	jg     8006f2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80070f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071a:	53                   	push   %ebx
  80071b:	51                   	push   %ecx
  80071c:	52                   	push   %edx
  80071d:	50                   	push   %eax
  80071e:	e8 69 14 00 00       	call   801b8c <__umoddi3>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	05 f4 21 80 00       	add    $0x8021f4,%eax
  80072b:	8a 00                	mov    (%eax),%al
  80072d:	0f be c0             	movsbl %al,%eax
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	50                   	push   %eax
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
}
  80073f:	90                   	nop
  800740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800743:	c9                   	leave  
  800744:	c3                   	ret    

00800745 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800748:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074c:	7e 1c                	jle    80076a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 50 08             	lea    0x8(%eax),%edx
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	89 10                	mov    %edx,(%eax)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	83 e8 08             	sub    $0x8,%eax
  800763:	8b 50 04             	mov    0x4(%eax),%edx
  800766:	8b 00                	mov    (%eax),%eax
  800768:	eb 40                	jmp    8007aa <getuint+0x65>
	else if (lflag)
  80076a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076e:	74 1e                	je     80078e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	8d 50 04             	lea    0x4(%eax),%edx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	89 10                	mov    %edx,(%eax)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
  80078c:	eb 1c                	jmp    8007aa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	8d 50 04             	lea    0x4(%eax),%edx
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	89 10                	mov    %edx,(%eax)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	83 e8 04             	sub    $0x4,%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b3:	7e 1c                	jle    8007d1 <getint+0x25>
		return va_arg(*ap, long long);
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	8d 50 08             	lea    0x8(%eax),%edx
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	89 10                	mov    %edx,(%eax)
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	83 e8 08             	sub    $0x8,%eax
  8007ca:	8b 50 04             	mov    0x4(%eax),%edx
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	eb 38                	jmp    800809 <getint+0x5d>
	else if (lflag)
  8007d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d5:	74 1a                	je     8007f1 <getint+0x45>
		return va_arg(*ap, long);
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	8d 50 04             	lea    0x4(%eax),%edx
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	89 10                	mov    %edx,(%eax)
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	83 e8 04             	sub    $0x4,%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	99                   	cltd   
  8007ef:	eb 18                	jmp    800809 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	8d 50 04             	lea    0x4(%eax),%edx
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	89 10                	mov    %edx,(%eax)
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	99                   	cltd   
}
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	56                   	push   %esi
  80080f:	53                   	push   %ebx
  800810:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800813:	eb 17                	jmp    80082c <vprintfmt+0x21>
			if (ch == '\0')
  800815:	85 db                	test   %ebx,%ebx
  800817:	0f 84 c1 03 00 00    	je     800bde <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	53                   	push   %ebx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082c:	8b 45 10             	mov    0x10(%ebp),%eax
  80082f:	8d 50 01             	lea    0x1(%eax),%edx
  800832:	89 55 10             	mov    %edx,0x10(%ebp)
  800835:	8a 00                	mov    (%eax),%al
  800837:	0f b6 d8             	movzbl %al,%ebx
  80083a:	83 fb 25             	cmp    $0x25,%ebx
  80083d:	75 d6                	jne    800815 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80083f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800843:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800851:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800858:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8d 50 01             	lea    0x1(%eax),%edx
  800865:	89 55 10             	mov    %edx,0x10(%ebp)
  800868:	8a 00                	mov    (%eax),%al
  80086a:	0f b6 d8             	movzbl %al,%ebx
  80086d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800870:	83 f8 5b             	cmp    $0x5b,%eax
  800873:	0f 87 3d 03 00 00    	ja     800bb6 <vprintfmt+0x3ab>
  800879:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  800880:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800882:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800886:	eb d7                	jmp    80085f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800888:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088c:	eb d1                	jmp    80085f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800895:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800898:	89 d0                	mov    %edx,%eax
  80089a:	c1 e0 02             	shl    $0x2,%eax
  80089d:	01 d0                	add    %edx,%eax
  80089f:	01 c0                	add    %eax,%eax
  8008a1:	01 d8                	add    %ebx,%eax
  8008a3:	83 e8 30             	sub    $0x30,%eax
  8008a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b4:	7e 3e                	jle    8008f4 <vprintfmt+0xe9>
  8008b6:	83 fb 39             	cmp    $0x39,%ebx
  8008b9:	7f 39                	jg     8008f4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008be:	eb d5                	jmp    800895 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	83 c0 04             	add    $0x4,%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	83 e8 04             	sub    $0x4,%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d4:	eb 1f                	jmp    8008f5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008da:	79 83                	jns    80085f <vprintfmt+0x54>
				width = 0;
  8008dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e3:	e9 77 ff ff ff       	jmp    80085f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ef:	e9 6b ff ff ff       	jmp    80085f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f9:	0f 89 60 ff ff ff    	jns    80085f <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800905:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090c:	e9 4e ff ff ff       	jmp    80085f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800911:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800914:	e9 46 ff ff ff       	jmp    80085f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	83 c0 04             	add    $0x4,%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	83 e8 04             	sub    $0x4,%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
			break;
  800939:	e9 9b 02 00 00       	jmp    800bd9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	83 c0 04             	add    $0x4,%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	83 e8 04             	sub    $0x4,%eax
  80094d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80094f:	85 db                	test   %ebx,%ebx
  800951:	79 02                	jns    800955 <vprintfmt+0x14a>
				err = -err;
  800953:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800955:	83 fb 64             	cmp    $0x64,%ebx
  800958:	7f 0b                	jg     800965 <vprintfmt+0x15a>
  80095a:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  800961:	85 f6                	test   %esi,%esi
  800963:	75 19                	jne    80097e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800965:	53                   	push   %ebx
  800966:	68 05 22 80 00       	push   $0x802205
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	ff 75 08             	pushl  0x8(%ebp)
  800971:	e8 70 02 00 00       	call   800be6 <printfmt>
  800976:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800979:	e9 5b 02 00 00       	jmp    800bd9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097e:	56                   	push   %esi
  80097f:	68 0e 22 80 00       	push   $0x80220e
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 57 02 00 00       	call   800be6 <printfmt>
  80098f:	83 c4 10             	add    $0x10,%esp
			break;
  800992:	e9 42 02 00 00       	jmp    800bd9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	83 c0 04             	add    $0x4,%eax
  80099d:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a3:	83 e8 04             	sub    $0x4,%eax
  8009a6:	8b 30                	mov    (%eax),%esi
  8009a8:	85 f6                	test   %esi,%esi
  8009aa:	75 05                	jne    8009b1 <vprintfmt+0x1a6>
				p = "(null)";
  8009ac:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8009b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b5:	7e 6d                	jle    800a24 <vprintfmt+0x219>
  8009b7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bb:	74 67                	je     800a24 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	50                   	push   %eax
  8009c4:	56                   	push   %esi
  8009c5:	e8 1e 03 00 00       	call   800ce8 <strnlen>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d0:	eb 16                	jmp    8009e8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ec:	7f e4                	jg     8009d2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ee:	eb 34                	jmp    800a24 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f4:	74 1c                	je     800a12 <vprintfmt+0x207>
  8009f6:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f9:	7e 05                	jle    800a00 <vprintfmt+0x1f5>
  8009fb:	83 fb 7e             	cmp    $0x7e,%ebx
  8009fe:	7e 12                	jle    800a12 <vprintfmt+0x207>
					putch('?', putdat);
  800a00:	83 ec 08             	sub    $0x8,%esp
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	6a 3f                	push   $0x3f
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	ff d0                	call   *%eax
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	eb 0f                	jmp    800a21 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	53                   	push   %ebx
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	ff d0                	call   *%eax
  800a1e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	ff 4d e4             	decl   -0x1c(%ebp)
  800a24:	89 f0                	mov    %esi,%eax
  800a26:	8d 70 01             	lea    0x1(%eax),%esi
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	0f be d8             	movsbl %al,%ebx
  800a2e:	85 db                	test   %ebx,%ebx
  800a30:	74 24                	je     800a56 <vprintfmt+0x24b>
  800a32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a36:	78 b8                	js     8009f0 <vprintfmt+0x1e5>
  800a38:	ff 4d e0             	decl   -0x20(%ebp)
  800a3b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3f:	79 af                	jns    8009f0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a41:	eb 13                	jmp    800a56 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 20                	push   $0x20
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a53:	ff 4d e4             	decl   -0x1c(%ebp)
  800a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5a:	7f e7                	jg     800a43 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5c:	e9 78 01 00 00       	jmp    800bd9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 e8             	pushl  -0x18(%ebp)
  800a67:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6a:	50                   	push   %eax
  800a6b:	e8 3c fd ff ff       	call   8007ac <getint>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7f:	85 d2                	test   %edx,%edx
  800a81:	79 23                	jns    800aa6 <vprintfmt+0x29b>
				putch('-', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 2d                	push   $0x2d
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a99:	f7 d8                	neg    %eax
  800a9b:	83 d2 00             	adc    $0x0,%edx
  800a9e:	f7 da                	neg    %edx
  800aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aad:	e9 bc 00 00 00       	jmp    800b6e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab8:	8d 45 14             	lea    0x14(%ebp),%eax
  800abb:	50                   	push   %eax
  800abc:	e8 84 fc ff ff       	call   800745 <getuint>
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad1:	e9 98 00 00 00       	jmp    800b6e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 ce 00 00 00       	jmp    800bd9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 30                	push   $0x30
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	6a 78                	push   $0x78
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	ff d0                	call   *%eax
  800b28:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 14             	mov    %eax,0x14(%ebp)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	83 e8 04             	sub    $0x4,%eax
  800b3a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4d:	eb 1f                	jmp    800b6e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 e8             	pushl  -0x18(%ebp)
  800b55:	8d 45 14             	lea    0x14(%ebp),%eax
  800b58:	50                   	push   %eax
  800b59:	e8 e7 fb ff ff       	call   800745 <getuint>
  800b5e:	83 c4 10             	add    $0x10,%esp
  800b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b75:	83 ec 04             	sub    $0x4,%esp
  800b78:	52                   	push   %edx
  800b79:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7c:	50                   	push   %eax
  800b7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b80:	ff 75 f0             	pushl  -0x10(%ebp)
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 00 fb ff ff       	call   80068e <printnum>
  800b8e:	83 c4 20             	add    $0x20,%esp
			break;
  800b91:	eb 46                	jmp    800bd9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	53                   	push   %ebx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			break;
  800ba2:	eb 35                	jmp    800bd9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ba4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800bab:	eb 2c                	jmp    800bd9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bad:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800bb4:	eb 23                	jmp    800bd9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	ff 75 0c             	pushl  0xc(%ebp)
  800bbc:	6a 25                	push   $0x25
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	ff d0                	call   *%eax
  800bc3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc6:	ff 4d 10             	decl   0x10(%ebp)
  800bc9:	eb 03                	jmp    800bce <vprintfmt+0x3c3>
  800bcb:	ff 4d 10             	decl   0x10(%ebp)
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	48                   	dec    %eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	3c 25                	cmp    $0x25,%al
  800bd6:	75 f3                	jne    800bcb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bd8:	90                   	nop
		}
	}
  800bd9:	e9 35 fc ff ff       	jmp    800813 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bde:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bec:	8d 45 10             	lea    0x10(%ebp),%eax
  800bef:	83 c0 04             	add    $0x4,%eax
  800bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	ff 75 08             	pushl  0x8(%ebp)
  800c02:	e8 04 fc ff ff       	call   80080b <vprintfmt>
  800c07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0a:	90                   	nop
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8b 40 08             	mov    0x8(%eax),%eax
  800c16:	8d 50 01             	lea    0x1(%eax),%edx
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	8b 10                	mov    (%eax),%edx
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8b 40 04             	mov    0x4(%eax),%eax
  800c2a:	39 c2                	cmp    %eax,%edx
  800c2c:	73 12                	jae    800c40 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	8d 48 01             	lea    0x1(%eax),%ecx
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	89 0a                	mov    %ecx,(%edx)
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	88 10                	mov    %dl,(%eax)
}
  800c40:	90                   	nop
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	01 d0                	add    %edx,%eax
  800c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c68:	74 06                	je     800c70 <vsnprintf+0x2d>
  800c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6e:	7f 07                	jg     800c77 <vsnprintf+0x34>
		return -E_INVAL;
  800c70:	b8 03 00 00 00       	mov    $0x3,%eax
  800c75:	eb 20                	jmp    800c97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c77:	ff 75 14             	pushl  0x14(%ebp)
  800c7a:	ff 75 10             	pushl  0x10(%ebp)
  800c7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c80:	50                   	push   %eax
  800c81:	68 0d 0c 80 00       	push   $0x800c0d
  800c86:	e8 80 fb ff ff       	call   80080b <vprintfmt>
  800c8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca2:	83 c0 04             	add    $0x4,%eax
  800ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	ff 75 f4             	pushl  -0xc(%ebp)
  800cae:	50                   	push   %eax
  800caf:	ff 75 0c             	pushl  0xc(%ebp)
  800cb2:	ff 75 08             	pushl  0x8(%ebp)
  800cb5:	e8 89 ff ff ff       	call   800c43 <vsnprintf>
  800cba:	83 c4 10             	add    $0x10,%esp
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd2:	eb 06                	jmp    800cda <strlen+0x15>
		n++;
  800cd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 f1                	jne    800cd4 <strlen+0xf>
		n++;
	return n;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf5:	eb 09                	jmp    800d00 <strnlen+0x18>
		n++;
  800cf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	ff 4d 0c             	decl   0xc(%ebp)
  800d00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d04:	74 09                	je     800d0f <strnlen+0x27>
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	84 c0                	test   %al,%al
  800d0d:	75 e8                	jne    800cf7 <strnlen+0xf>
		n++;
	return n;
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d20:	90                   	nop
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d33:	8a 12                	mov    (%edx),%dl
  800d35:	88 10                	mov    %dl,(%eax)
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 e4                	jne    800d21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d55:	eb 1f                	jmp    800d76 <strncpy+0x34>
		*dst++ = *src;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8d 50 01             	lea    0x1(%eax),%edx
  800d5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d63:	8a 12                	mov    (%edx),%dl
  800d65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	74 03                	je     800d73 <strncpy+0x31>
			src++;
  800d70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d73:	ff 45 fc             	incl   -0x4(%ebp)
  800d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7c:	72 d9                	jb     800d57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 30                	je     800dc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d95:	eb 16                	jmp    800dad <strlcpy+0x2a>
			*dst++ = *src++;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da9:	8a 12                	mov    (%edx),%dl
  800dab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dad:	ff 4d 10             	decl   0x10(%ebp)
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	74 09                	je     800dbf <strlcpy+0x3c>
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 d8                	jne    800d97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	29 c2                	sub    %eax,%edx
  800dcd:	89 d0                	mov    %edx,%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd4:	eb 06                	jmp    800ddc <strcmp+0xb>
		p++, q++;
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	84 c0                	test   %al,%al
  800de3:	74 0e                	je     800df3 <strcmp+0x22>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	38 c2                	cmp    %al,%dl
  800df1:	74 e3                	je     800dd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	0f b6 d0             	movzbl %al,%edx
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	0f b6 c0             	movzbl %al,%eax
  800e03:	29 c2                	sub    %eax,%edx
  800e05:	89 d0                	mov    %edx,%eax
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0c:	eb 09                	jmp    800e17 <strncmp+0xe>
		n--, p++, q++;
  800e0e:	ff 4d 10             	decl   0x10(%ebp)
  800e11:	ff 45 08             	incl   0x8(%ebp)
  800e14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1b:	74 17                	je     800e34 <strncmp+0x2b>
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	74 0e                	je     800e34 <strncmp+0x2b>
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	38 c2                	cmp    %al,%dl
  800e32:	74 da                	je     800e0e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e38:	75 07                	jne    800e41 <strncmp+0x38>
		return 0;
  800e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3f:	eb 14                	jmp    800e55 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	0f b6 d0             	movzbl %al,%edx
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	0f b6 c0             	movzbl %al,%eax
  800e51:	29 c2                	sub    %eax,%edx
  800e53:	89 d0                	mov    %edx,%eax
}
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 04             	sub    $0x4,%esp
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e63:	eb 12                	jmp    800e77 <strchr+0x20>
		if (*s == c)
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6d:	75 05                	jne    800e74 <strchr+0x1d>
			return (char *) s;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	eb 11                	jmp    800e85 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	75 e5                	jne    800e65 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 04             	sub    $0x4,%esp
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e93:	eb 0d                	jmp    800ea2 <strfind+0x1b>
		if (*s == c)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9d:	74 0e                	je     800ead <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	84 c0                	test   %al,%al
  800ea9:	75 ea                	jne    800e95 <strfind+0xe>
  800eab:	eb 01                	jmp    800eae <strfind+0x27>
		if (*s == c)
			break;
  800ead:	90                   	nop
	return (char *) s;
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ebf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec3:	76 63                	jbe    800f28 <memset+0x75>
		uint64 data_block = c;
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	99                   	cltd   
  800ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ed9:	c1 e0 08             	shl    $0x8,%eax
  800edc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edf:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eec:	c1 e0 10             	shl    $0x10,%eax
  800eef:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efb:	89 c2                	mov    %eax,%edx
  800efd:	b8 00 00 00 00       	mov    $0x0,%eax
  800f02:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f05:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f08:	eb 18                	jmp    800f22 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f0a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0d:	8d 41 08             	lea    0x8(%ecx),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f19:	89 01                	mov    %eax,(%ecx)
  800f1b:	89 51 04             	mov    %edx,0x4(%ecx)
  800f1e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f22:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f26:	77 e2                	ja     800f0a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2c:	74 23                	je     800f51 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f34:	eb 0e                	jmp    800f44 <memset+0x91>
			*p8++ = (uint8)c;
  800f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f42:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f44:	8b 45 10             	mov    0x10(%ebp),%eax
  800f47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	75 e5                	jne    800f36 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f68:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6c:	76 24                	jbe    800f92 <memcpy+0x3c>
		while(n >= 8){
  800f6e:	eb 1c                	jmp    800f8c <memcpy+0x36>
			*d64 = *s64;
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	8b 50 04             	mov    0x4(%eax),%edx
  800f76:	8b 00                	mov    (%eax),%eax
  800f78:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f7b:	89 01                	mov    %eax,(%ecx)
  800f7d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f80:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f84:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f88:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f8c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f90:	77 de                	ja     800f70 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f96:	74 31                	je     800fc9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fa4:	eb 16                	jmp    800fbc <memcpy+0x66>
			*d8++ = *s8++;
  800fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa9:	8d 50 01             	lea    0x1(%eax),%edx
  800fac:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fb8:	8a 12                	mov    (%edx),%dl
  800fba:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	75 dd                	jne    800fa6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe6:	73 50                	jae    801038 <memmove+0x6a>
  800fe8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff3:	76 43                	jbe    801038 <memmove+0x6a>
		s += n;
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801001:	eb 10                	jmp    801013 <memmove+0x45>
			*--d = *--s;
  801003:	ff 4d f8             	decl   -0x8(%ebp)
  801006:	ff 4d fc             	decl   -0x4(%ebp)
  801009:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100c:	8a 10                	mov    (%eax),%dl
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	8d 50 ff             	lea    -0x1(%eax),%edx
  801019:	89 55 10             	mov    %edx,0x10(%ebp)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	75 e3                	jne    801003 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801020:	eb 23                	jmp    801045 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	8d 50 01             	lea    0x1(%eax),%edx
  801028:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801031:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801034:	8a 12                	mov    (%edx),%dl
  801036:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103e:	89 55 10             	mov    %edx,0x10(%ebp)
  801041:	85 c0                	test   %eax,%eax
  801043:	75 dd                	jne    801022 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80105c:	eb 2a                	jmp    801088 <memcmp+0x3e>
		if (*s1 != *s2)
  80105e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801061:	8a 10                	mov    (%eax),%dl
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	38 c2                	cmp    %al,%dl
  80106a:	74 16                	je     801082 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80106c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f b6 d0             	movzbl %al,%edx
  801074:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f b6 c0             	movzbl %al,%eax
  80107c:	29 c2                	sub    %eax,%edx
  80107e:	89 d0                	mov    %edx,%eax
  801080:	eb 18                	jmp    80109a <memcmp+0x50>
		s1++, s2++;
  801082:	ff 45 fc             	incl   -0x4(%ebp)
  801085:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108e:	89 55 10             	mov    %edx,0x10(%ebp)
  801091:	85 c0                	test   %eax,%eax
  801093:	75 c9                	jne    80105e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801095:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	01 d0                	add    %edx,%eax
  8010aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010ad:	eb 15                	jmp    8010c4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	0f b6 d0             	movzbl %al,%edx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	0f b6 c0             	movzbl %al,%eax
  8010bd:	39 c2                	cmp    %eax,%edx
  8010bf:	74 0d                	je     8010ce <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c1:	ff 45 08             	incl   0x8(%ebp)
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ca:	72 e3                	jb     8010af <memfind+0x13>
  8010cc:	eb 01                	jmp    8010cf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010ce:	90                   	nop
	return (void *) s;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e8:	eb 03                	jmp    8010ed <strtol+0x19>
		s++;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 20                	cmp    $0x20,%al
  8010f4:	74 f4                	je     8010ea <strtol+0x16>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 09                	cmp    $0x9,%al
  8010fd:	74 eb                	je     8010ea <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 2b                	cmp    $0x2b,%al
  801106:	75 05                	jne    80110d <strtol+0x39>
		s++;
  801108:	ff 45 08             	incl   0x8(%ebp)
  80110b:	eb 13                	jmp    801120 <strtol+0x4c>
	else if (*s == '-')
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 2d                	cmp    $0x2d,%al
  801114:	75 0a                	jne    801120 <strtol+0x4c>
		s++, neg = 1;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	74 06                	je     80112c <strtol+0x58>
  801126:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80112a:	75 20                	jne    80114c <strtol+0x78>
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	3c 30                	cmp    $0x30,%al
  801133:	75 17                	jne    80114c <strtol+0x78>
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	40                   	inc    %eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 78                	cmp    $0x78,%al
  80113d:	75 0d                	jne    80114c <strtol+0x78>
		s += 2, base = 16;
  80113f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801143:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80114a:	eb 28                	jmp    801174 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80114c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801150:	75 15                	jne    801167 <strtol+0x93>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 30                	cmp    $0x30,%al
  801159:	75 0c                	jne    801167 <strtol+0x93>
		s++, base = 8;
  80115b:	ff 45 08             	incl   0x8(%ebp)
  80115e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801165:	eb 0d                	jmp    801174 <strtol+0xa0>
	else if (base == 0)
  801167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116b:	75 07                	jne    801174 <strtol+0xa0>
		base = 10;
  80116d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 2f                	cmp    $0x2f,%al
  80117b:	7e 19                	jle    801196 <strtol+0xc2>
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 39                	cmp    $0x39,%al
  801184:	7f 10                	jg     801196 <strtol+0xc2>
			dig = *s - '0';
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	0f be c0             	movsbl %al,%eax
  80118e:	83 e8 30             	sub    $0x30,%eax
  801191:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801194:	eb 42                	jmp    8011d8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 60                	cmp    $0x60,%al
  80119d:	7e 19                	jle    8011b8 <strtol+0xe4>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 7a                	cmp    $0x7a,%al
  8011a6:	7f 10                	jg     8011b8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	83 e8 57             	sub    $0x57,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b6:	eb 20                	jmp    8011d8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 40                	cmp    $0x40,%al
  8011bf:	7e 39                	jle    8011fa <strtol+0x126>
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 5a                	cmp    $0x5a,%al
  8011c8:	7f 30                	jg     8011fa <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	0f be c0             	movsbl %al,%eax
  8011d2:	83 e8 37             	sub    $0x37,%eax
  8011d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011de:	7d 19                	jge    8011f9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011e0:	ff 45 08             	incl   0x8(%ebp)
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f4:	e9 7b ff ff ff       	jmp    801174 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011f9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fe:	74 08                	je     801208 <strtol+0x134>
		*endptr = (char *) s;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801208:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120c:	74 07                	je     801215 <strtol+0x141>
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	f7 d8                	neg    %eax
  801213:	eb 03                	jmp    801218 <strtol+0x144>
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <ltostr>:

void
ltostr(long value, char *str)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801220:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801227:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80122e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801232:	79 13                	jns    801247 <ltostr+0x2d>
	{
		neg = 1;
  801234:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801241:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801244:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80124f:	99                   	cltd   
  801250:	f7 f9                	idiv   %ecx
  801252:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801255:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801258:	8d 50 01             	lea    0x1(%eax),%edx
  80125b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80125e:	89 c2                	mov    %eax,%edx
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801268:	83 c2 30             	add    $0x30,%edx
  80126b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80126d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801270:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801275:	f7 e9                	imul   %ecx
  801277:	c1 fa 02             	sar    $0x2,%edx
  80127a:	89 c8                	mov    %ecx,%eax
  80127c:	c1 f8 1f             	sar    $0x1f,%eax
  80127f:	29 c2                	sub    %eax,%edx
  801281:	89 d0                	mov    %edx,%eax
  801283:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128a:	75 bb                	jne    801247 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80128c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801296:	48                   	dec    %eax
  801297:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80129a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129e:	74 3d                	je     8012dd <ltostr+0xc3>
		start = 1 ;
  8012a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012a7:	eb 34                	jmp    8012dd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 d0                	add    %edx,%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	01 c2                	add    %eax,%edx
  8012be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 c8                	add    %ecx,%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	01 c2                	add    %eax,%edx
  8012d2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012d5:	88 02                	mov    %al,(%edx)
		start++ ;
  8012d7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012da:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e3:	7c c4                	jl     8012a9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	01 d0                	add    %edx,%eax
  8012ed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012f0:	90                   	nop
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012f9:	ff 75 08             	pushl  0x8(%ebp)
  8012fc:	e8 c4 f9 ff ff       	call   800cc5 <strlen>
  801301:	83 c4 04             	add    $0x4,%esp
  801304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	e8 b6 f9 ff ff       	call   800cc5 <strlen>
  80130f:	83 c4 04             	add    $0x4,%esp
  801312:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80131c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801323:	eb 17                	jmp    80133c <strcconcat+0x49>
		final[s] = str1[s] ;
  801325:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	01 c2                	add    %eax,%edx
  80132d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	01 c8                	add    %ecx,%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801339:	ff 45 fc             	incl   -0x4(%ebp)
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801342:	7c e1                	jl     801325 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801344:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80134b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801352:	eb 1f                	jmp    801373 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801354:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801357:	8d 50 01             	lea    0x1(%eax),%edx
  80135a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	01 c2                	add    %eax,%edx
  801364:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	01 c8                	add    %ecx,%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801370:	ff 45 f8             	incl   -0x8(%ebp)
  801373:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801379:	7c d9                	jl     801354 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80137b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c6 00 00             	movb   $0x0,(%eax)
}
  801386:	90                   	nop
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80138c:	8b 45 14             	mov    0x14(%ebp),%eax
  80138f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801395:	8b 45 14             	mov    0x14(%ebp),%eax
  801398:	8b 00                	mov    (%eax),%eax
  80139a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ac:	eb 0c                	jmp    8013ba <strsplit+0x31>
			*string++ = 0;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8d 50 01             	lea    0x1(%eax),%edx
  8013b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 18                	je     8013db <strsplit+0x52>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	0f be c0             	movsbl %al,%eax
  8013cb:	50                   	push   %eax
  8013cc:	ff 75 0c             	pushl  0xc(%ebp)
  8013cf:	e8 83 fa ff ff       	call   800e57 <strchr>
  8013d4:	83 c4 08             	add    $0x8,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	75 d3                	jne    8013ae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 5a                	je     80143e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	83 f8 0f             	cmp    $0xf,%eax
  8013ec:	75 07                	jne    8013f5 <strsplit+0x6c>
		{
			return 0;
  8013ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f3:	eb 66                	jmp    80145b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013fd:	8b 55 14             	mov    0x14(%ebp),%edx
  801400:	89 0a                	mov    %ecx,(%edx)
  801402:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	01 c2                	add    %eax,%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801413:	eb 03                	jmp    801418 <strsplit+0x8f>
			string++;
  801415:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	84 c0                	test   %al,%al
  80141f:	74 8b                	je     8013ac <strsplit+0x23>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	0f be c0             	movsbl %al,%eax
  801429:	50                   	push   %eax
  80142a:	ff 75 0c             	pushl  0xc(%ebp)
  80142d:	e8 25 fa ff ff       	call   800e57 <strchr>
  801432:	83 c4 08             	add    $0x8,%esp
  801435:	85 c0                	test   %eax,%eax
  801437:	74 dc                	je     801415 <strsplit+0x8c>
			string++;
	}
  801439:	e9 6e ff ff ff       	jmp    8013ac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80143e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80143f:	8b 45 14             	mov    0x14(%ebp),%eax
  801442:	8b 00                	mov    (%eax),%eax
  801444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80144b:	8b 45 10             	mov    0x10(%ebp),%eax
  80144e:	01 d0                	add    %edx,%eax
  801450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801456:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801470:	eb 4a                	jmp    8014bc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801472:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	01 c2                	add    %eax,%edx
  80147a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	01 c8                	add    %ecx,%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801486:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 40                	cmp    $0x40,%al
  801492:	7e 25                	jle    8014b9 <str2lower+0x5c>
  801494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	01 d0                	add    %edx,%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	3c 5a                	cmp    $0x5a,%al
  8014a0:	7f 17                	jg     8014b9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	01 d0                	add    %edx,%eax
  8014aa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b0:	01 ca                	add    %ecx,%edx
  8014b2:	8a 12                	mov    (%edx),%dl
  8014b4:	83 c2 20             	add    $0x20,%edx
  8014b7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014b9:	ff 45 fc             	incl   -0x4(%ebp)
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	e8 01 f8 ff ff       	call   800cc5 <strlen>
  8014c4:	83 c4 04             	add    $0x4,%esp
  8014c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ca:	7f a6                	jg     801472 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	57                   	push   %edi
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014e6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014e9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ec:	cd 30                	int    $0x30
  8014ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801508:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80150b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	6a 00                	push   $0x0
  801514:	51                   	push   %ecx
  801515:	52                   	push   %edx
  801516:	ff 75 0c             	pushl  0xc(%ebp)
  801519:	50                   	push   %eax
  80151a:	6a 00                	push   $0x0
  80151c:	e8 b0 ff ff ff       	call   8014d1 <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	90                   	nop
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <sys_cgetc>:

int
sys_cgetc(void)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 02                	push   $0x2
  801536:	e8 96 ff ff ff       	call   8014d1 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 03                	push   $0x3
  80154f:	e8 7d ff ff ff       	call   8014d1 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	90                   	nop
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 04                	push   $0x4
  801569:	e8 63 ff ff ff       	call   8014d1 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	90                   	nop
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	52                   	push   %edx
  801584:	50                   	push   %eax
  801585:	6a 08                	push   $0x8
  801587:	e8 45 ff ff ff       	call   8014d1 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801596:	8b 75 18             	mov    0x18(%ebp),%esi
  801599:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	56                   	push   %esi
  8015a6:	53                   	push   %ebx
  8015a7:	51                   	push   %ecx
  8015a8:	52                   	push   %edx
  8015a9:	50                   	push   %eax
  8015aa:	6a 09                	push   $0x9
  8015ac:	e8 20 ff ff ff       	call   8014d1 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    

008015bb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	6a 0a                	push   $0xa
  8015cb:	e8 01 ff ff ff       	call   8014d1 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	6a 0b                	push   $0xb
  8015e6:	e8 e6 fe ff ff       	call   8014d1 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 0c                	push   $0xc
  8015ff:	e8 cd fe ff ff       	call   8014d1 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 0d                	push   $0xd
  801618:	e8 b4 fe ff ff       	call   8014d1 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 0e                	push   $0xe
  801631:	e8 9b fe ff ff       	call   8014d1 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 0f                	push   $0xf
  80164a:	e8 82 fe ff ff       	call   8014d1 <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	6a 10                	push   $0x10
  801664:	e8 68 fe ff ff       	call   8014d1 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 11                	push   $0x11
  80167d:	e8 4f fe ff ff       	call   8014d1 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_cputc>:

void
sys_cputc(const char c)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801694:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	50                   	push   %eax
  8016a1:	6a 01                	push   $0x1
  8016a3:	e8 29 fe ff ff       	call   8014d1 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	90                   	nop
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 14                	push   $0x14
  8016bd:	e8 0f fe ff ff       	call   8014d1 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	90                   	nop
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	51                   	push   %ecx
  8016e1:	52                   	push   %edx
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	50                   	push   %eax
  8016e6:	6a 15                	push   $0x15
  8016e8:	e8 e4 fd ff ff       	call   8014d1 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 16                	push   $0x16
  801705:	e8 c7 fd ff ff       	call   8014d1 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801712:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	51                   	push   %ecx
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 17                	push   $0x17
  801724:	e8 a8 fd ff ff       	call   8014d1 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	52                   	push   %edx
  80173e:	50                   	push   %eax
  80173f:	6a 18                	push   $0x18
  801741:	e8 8b fd ff ff       	call   8014d1 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	ff 75 14             	pushl  0x14(%ebp)
  801756:	ff 75 10             	pushl  0x10(%ebp)
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	50                   	push   %eax
  80175d:	6a 19                	push   $0x19
  80175f:	e8 6d fd ff ff       	call   8014d1 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	50                   	push   %eax
  801778:	6a 1a                	push   $0x1a
  80177a:	e8 52 fd ff ff       	call   8014d1 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	90                   	nop
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	50                   	push   %eax
  801794:	6a 1b                	push   $0x1b
  801796:	e8 36 fd ff ff       	call   8014d1 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 05                	push   $0x5
  8017af:	e8 1d fd ff ff       	call   8014d1 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 06                	push   $0x6
  8017c8:	e8 04 fd ff ff       	call   8014d1 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 07                	push   $0x7
  8017e1:	e8 eb fc ff ff       	call   8014d1 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_exit_env>:


void sys_exit_env(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 1c                	push   $0x1c
  8017fa:	e8 d2 fc ff ff       	call   8014d1 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80180b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80180e:	8d 50 04             	lea    0x4(%eax),%edx
  801811:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	52                   	push   %edx
  80181b:	50                   	push   %eax
  80181c:	6a 1d                	push   $0x1d
  80181e:	e8 ae fc ff ff       	call   8014d1 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
	return result;
  801826:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801829:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182f:	89 01                	mov    %eax,(%ecx)
  801831:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	c9                   	leave  
  801838:	c2 04 00             	ret    $0x4

0080183b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 10             	pushl  0x10(%ebp)
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	6a 13                	push   $0x13
  80184d:	e8 7f fc ff ff       	call   8014d1 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
	return ;
  801855:	90                   	nop
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_rcr2>:
uint32 sys_rcr2()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 1e                	push   $0x1e
  801867:	e8 65 fc ff ff       	call   8014d1 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80187d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	50                   	push   %eax
  80188a:	6a 1f                	push   $0x1f
  80188c:	e8 40 fc ff ff       	call   8014d1 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <rsttst>:
void rsttst()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 21                	push   $0x21
  8018a6:	e8 26 fc ff ff       	call   8014d1 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018bd:	8b 55 18             	mov    0x18(%ebp),%edx
  8018c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c4:	52                   	push   %edx
  8018c5:	50                   	push   %eax
  8018c6:	ff 75 10             	pushl  0x10(%ebp)
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 20                	push   $0x20
  8018d1:	e8 fb fb ff ff       	call   8014d1 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <chktst>:
void chktst(uint32 n)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 22                	push   $0x22
  8018ec:	e8 e0 fb ff ff       	call   8014d1 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <inctst>:

void inctst()
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 23                	push   $0x23
  801906:	e8 c6 fb ff ff       	call   8014d1 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
	return ;
  80190e:	90                   	nop
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <gettst>:
uint32 gettst()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 24                	push   $0x24
  801920:	e8 ac fb ff ff       	call   8014d1 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 25                	push   $0x25
  801939:	e8 93 fb ff ff       	call   8014d1 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
  801941:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801946:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	6a 26                	push   $0x26
  801965:	e8 67 fb ff ff       	call   8014d1 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801974:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801977:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	53                   	push   %ebx
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 27                	push   $0x27
  801988:	e8 44 fb ff ff       	call   8014d1 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 28                	push   $0x28
  8019a8:	e8 24 fb ff ff       	call   8014d1 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019b5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	51                   	push   %ecx
  8019c1:	ff 75 10             	pushl  0x10(%ebp)
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	6a 29                	push   $0x29
  8019c8:	e8 04 fb ff ff       	call   8014d1 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 10             	pushl  0x10(%ebp)
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	6a 12                	push   $0x12
  8019e4:	e8 e8 fa ff ff       	call   8014d1 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ec:	90                   	nop
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 2a                	push   $0x2a
  801a02:	e8 ca fa ff ff       	call   8014d1 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	return;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 2b                	push   $0x2b
  801a1c:	e8 b0 fa ff ff       	call   8014d1 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 2d                	push   $0x2d
  801a37:	e8 95 fa ff ff       	call   8014d1 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 2c                	push   $0x2c
  801a53:	e8 79 fa ff ff       	call   8014d1 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	68 88 23 80 00       	push   $0x802388
  801a6c:	68 25 01 00 00       	push   $0x125
  801a71:	68 bb 23 80 00       	push   $0x8023bb
  801a76:	e8 a3 e8 ff ff       	call   80031e <_panic>
  801a7b:	90                   	nop

00801a7c <__udivdi3>:
  801a7c:	55                   	push   %ebp
  801a7d:	57                   	push   %edi
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a93:	89 ca                	mov    %ecx,%edx
  801a95:	89 f8                	mov    %edi,%eax
  801a97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a9b:	85 f6                	test   %esi,%esi
  801a9d:	75 2d                	jne    801acc <__udivdi3+0x50>
  801a9f:	39 cf                	cmp    %ecx,%edi
  801aa1:	77 65                	ja     801b08 <__udivdi3+0x8c>
  801aa3:	89 fd                	mov    %edi,%ebp
  801aa5:	85 ff                	test   %edi,%edi
  801aa7:	75 0b                	jne    801ab4 <__udivdi3+0x38>
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aae:	31 d2                	xor    %edx,%edx
  801ab0:	f7 f7                	div    %edi
  801ab2:	89 c5                	mov    %eax,%ebp
  801ab4:	31 d2                	xor    %edx,%edx
  801ab6:	89 c8                	mov    %ecx,%eax
  801ab8:	f7 f5                	div    %ebp
  801aba:	89 c1                	mov    %eax,%ecx
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	f7 f5                	div    %ebp
  801ac0:	89 cf                	mov    %ecx,%edi
  801ac2:	89 fa                	mov    %edi,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 ce                	cmp    %ecx,%esi
  801ace:	77 28                	ja     801af8 <__udivdi3+0x7c>
  801ad0:	0f bd fe             	bsr    %esi,%edi
  801ad3:	83 f7 1f             	xor    $0x1f,%edi
  801ad6:	75 40                	jne    801b18 <__udivdi3+0x9c>
  801ad8:	39 ce                	cmp    %ecx,%esi
  801ada:	72 0a                	jb     801ae6 <__udivdi3+0x6a>
  801adc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ae0:	0f 87 9e 00 00 00    	ja     801b84 <__udivdi3+0x108>
  801ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aeb:	89 fa                	mov    %edi,%edx
  801aed:	83 c4 1c             	add    $0x1c,%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    
  801af5:	8d 76 00             	lea    0x0(%esi),%esi
  801af8:	31 ff                	xor    %edi,%edi
  801afa:	31 c0                	xor    %eax,%eax
  801afc:	89 fa                	mov    %edi,%edx
  801afe:	83 c4 1c             	add    $0x1c,%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5f                   	pop    %edi
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	f7 f7                	div    %edi
  801b0c:	31 ff                	xor    %edi,%edi
  801b0e:	89 fa                	mov    %edi,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b1d:	89 eb                	mov    %ebp,%ebx
  801b1f:	29 fb                	sub    %edi,%ebx
  801b21:	89 f9                	mov    %edi,%ecx
  801b23:	d3 e6                	shl    %cl,%esi
  801b25:	89 c5                	mov    %eax,%ebp
  801b27:	88 d9                	mov    %bl,%cl
  801b29:	d3 ed                	shr    %cl,%ebp
  801b2b:	89 e9                	mov    %ebp,%ecx
  801b2d:	09 f1                	or     %esi,%ecx
  801b2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b33:	89 f9                	mov    %edi,%ecx
  801b35:	d3 e0                	shl    %cl,%eax
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	89 d6                	mov    %edx,%esi
  801b3b:	88 d9                	mov    %bl,%cl
  801b3d:	d3 ee                	shr    %cl,%esi
  801b3f:	89 f9                	mov    %edi,%ecx
  801b41:	d3 e2                	shl    %cl,%edx
  801b43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b47:	88 d9                	mov    %bl,%cl
  801b49:	d3 e8                	shr    %cl,%eax
  801b4b:	09 c2                	or     %eax,%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	89 f2                	mov    %esi,%edx
  801b51:	f7 74 24 0c          	divl   0xc(%esp)
  801b55:	89 d6                	mov    %edx,%esi
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	f7 e5                	mul    %ebp
  801b5b:	39 d6                	cmp    %edx,%esi
  801b5d:	72 19                	jb     801b78 <__udivdi3+0xfc>
  801b5f:	74 0b                	je     801b6c <__udivdi3+0xf0>
  801b61:	89 d8                	mov    %ebx,%eax
  801b63:	31 ff                	xor    %edi,%edi
  801b65:	e9 58 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b70:	89 f9                	mov    %edi,%ecx
  801b72:	d3 e2                	shl    %cl,%edx
  801b74:	39 c2                	cmp    %eax,%edx
  801b76:	73 e9                	jae    801b61 <__udivdi3+0xe5>
  801b78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b7b:	31 ff                	xor    %edi,%edi
  801b7d:	e9 40 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	31 c0                	xor    %eax,%eax
  801b86:	e9 37 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b8b:	90                   	nop

00801b8c <__umoddi3>:
  801b8c:	55                   	push   %ebp
  801b8d:	57                   	push   %edi
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 1c             	sub    $0x1c,%esp
  801b93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ba3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bab:	89 f3                	mov    %esi,%ebx
  801bad:	89 fa                	mov    %edi,%edx
  801baf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb3:	89 34 24             	mov    %esi,(%esp)
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	75 1a                	jne    801bd4 <__umoddi3+0x48>
  801bba:	39 f7                	cmp    %esi,%edi
  801bbc:	0f 86 a2 00 00 00    	jbe    801c64 <__umoddi3+0xd8>
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	89 f2                	mov    %esi,%edx
  801bc6:	f7 f7                	div    %edi
  801bc8:	89 d0                	mov    %edx,%eax
  801bca:	31 d2                	xor    %edx,%edx
  801bcc:	83 c4 1c             	add    $0x1c,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
  801bd4:	39 f0                	cmp    %esi,%eax
  801bd6:	0f 87 ac 00 00 00    	ja     801c88 <__umoddi3+0xfc>
  801bdc:	0f bd e8             	bsr    %eax,%ebp
  801bdf:	83 f5 1f             	xor    $0x1f,%ebp
  801be2:	0f 84 ac 00 00 00    	je     801c94 <__umoddi3+0x108>
  801be8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bed:	29 ef                	sub    %ebp,%edi
  801bef:	89 fe                	mov    %edi,%esi
  801bf1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 e0                	shl    %cl,%eax
  801bf9:	89 d7                	mov    %edx,%edi
  801bfb:	89 f1                	mov    %esi,%ecx
  801bfd:	d3 ef                	shr    %cl,%edi
  801bff:	09 c7                	or     %eax,%edi
  801c01:	89 e9                	mov    %ebp,%ecx
  801c03:	d3 e2                	shl    %cl,%edx
  801c05:	89 14 24             	mov    %edx,(%esp)
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	d3 e0                	shl    %cl,%eax
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c12:	d3 e0                	shl    %cl,%eax
  801c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1c:	89 f1                	mov    %esi,%ecx
  801c1e:	d3 e8                	shr    %cl,%eax
  801c20:	09 d0                	or     %edx,%eax
  801c22:	d3 eb                	shr    %cl,%ebx
  801c24:	89 da                	mov    %ebx,%edx
  801c26:	f7 f7                	div    %edi
  801c28:	89 d3                	mov    %edx,%ebx
  801c2a:	f7 24 24             	mull   (%esp)
  801c2d:	89 c6                	mov    %eax,%esi
  801c2f:	89 d1                	mov    %edx,%ecx
  801c31:	39 d3                	cmp    %edx,%ebx
  801c33:	0f 82 87 00 00 00    	jb     801cc0 <__umoddi3+0x134>
  801c39:	0f 84 91 00 00 00    	je     801cd0 <__umoddi3+0x144>
  801c3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c43:	29 f2                	sub    %esi,%edx
  801c45:	19 cb                	sbb    %ecx,%ebx
  801c47:	89 d8                	mov    %ebx,%eax
  801c49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c4d:	d3 e0                	shl    %cl,%eax
  801c4f:	89 e9                	mov    %ebp,%ecx
  801c51:	d3 ea                	shr    %cl,%edx
  801c53:	09 d0                	or     %edx,%eax
  801c55:	89 e9                	mov    %ebp,%ecx
  801c57:	d3 eb                	shr    %cl,%ebx
  801c59:	89 da                	mov    %ebx,%edx
  801c5b:	83 c4 1c             	add    $0x1c,%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5f                   	pop    %edi
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    
  801c63:	90                   	nop
  801c64:	89 fd                	mov    %edi,%ebp
  801c66:	85 ff                	test   %edi,%edi
  801c68:	75 0b                	jne    801c75 <__umoddi3+0xe9>
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	31 d2                	xor    %edx,%edx
  801c71:	f7 f7                	div    %edi
  801c73:	89 c5                	mov    %eax,%ebp
  801c75:	89 f0                	mov    %esi,%eax
  801c77:	31 d2                	xor    %edx,%edx
  801c79:	f7 f5                	div    %ebp
  801c7b:	89 c8                	mov    %ecx,%eax
  801c7d:	f7 f5                	div    %ebp
  801c7f:	89 d0                	mov    %edx,%eax
  801c81:	e9 44 ff ff ff       	jmp    801bca <__umoddi3+0x3e>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	89 c8                	mov    %ecx,%eax
  801c8a:	89 f2                	mov    %esi,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	3b 04 24             	cmp    (%esp),%eax
  801c97:	72 06                	jb     801c9f <__umoddi3+0x113>
  801c99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c9d:	77 0f                	ja     801cae <__umoddi3+0x122>
  801c9f:	89 f2                	mov    %esi,%edx
  801ca1:	29 f9                	sub    %edi,%ecx
  801ca3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ca7:	89 14 24             	mov    %edx,(%esp)
  801caa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cb2:	8b 14 24             	mov    (%esp),%edx
  801cb5:	83 c4 1c             	add    $0x1c,%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5f                   	pop    %edi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    
  801cbd:	8d 76 00             	lea    0x0(%esi),%esi
  801cc0:	2b 04 24             	sub    (%esp),%eax
  801cc3:	19 fa                	sbb    %edi,%edx
  801cc5:	89 d1                	mov    %edx,%ecx
  801cc7:	89 c6                	mov    %eax,%esi
  801cc9:	e9 71 ff ff ff       	jmp    801c3f <__umoddi3+0xb3>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cd4:	72 ea                	jb     801cc0 <__umoddi3+0x134>
  801cd6:	89 d9                	mov    %ebx,%ecx
  801cd8:	e9 62 ff ff ff       	jmp    801c3f <__umoddi3+0xb3>
