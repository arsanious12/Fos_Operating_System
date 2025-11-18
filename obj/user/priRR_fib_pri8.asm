
obj/user/priRR_fib_pri8:     file format elf32-i386


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
  800031:	e8 c0 00 00 00       	call   8000f6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int fibonacci(int n);
extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	sys_env_set_priority(myEnv->env_id, 8);
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 40 10             	mov    0x10(%eax),%eax
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 08                	push   $0x8
  80004e:	50                   	push   %eax
  80004f:	e8 a7 19 00 00       	call   8019fb <sys_env_set_priority>
  800054:	83 c4 10             	add    $0x10,%esp

	int i1=0;
  800057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  80005e:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	ff 75 f4             	pushl  -0xc(%ebp)
  80006b:	e8 47 00 00 00       	call   8000b7 <fibonacci>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	ff 75 f0             	pushl  -0x10(%ebp)
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	68 80 1c 80 00       	push   $0x801c80
  800084:	e8 72 05 00 00       	call   8005fb <atomic_cprintf>
  800089:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  80008c:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  800093:	74 1a                	je     8000af <_main+0x77>
		panic("[envID %d] wrong result!", myEnv->env_id);
  800095:	a1 20 30 80 00       	mov    0x803020,%eax
  80009a:	8b 40 10             	mov    0x10(%eax),%eax
  80009d:	50                   	push   %eax
  80009e:	68 94 1c 80 00       	push   $0x801c94
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 ad 1c 80 00       	push   $0x801cad
  8000aa:	e8 0c 02 00 00       	call   8002bb <_panic>

	//To indicate that it's completed successfully
	inctst();
  8000af:	e8 e0 17 00 00       	call   801894 <inctst>

	return;
  8000b4:	90                   	nop
}
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <fibonacci>:


int fibonacci(int n)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000be:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c2:	7f 07                	jg     8000cb <fibonacci+0x14>
		return 1 ;
  8000c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c9:	eb 26                	jmp    8000f1 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ce:	48                   	dec    %eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 df ff ff ff       	call   8000b7 <fibonacci>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 c3                	mov    %eax,%ebx
  8000dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e0:	83 e8 02             	sub    $0x2,%eax
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	50                   	push   %eax
  8000e7:	e8 cb ff ff ff       	call   8000b7 <fibonacci>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	01 d8                	add    %ebx,%eax
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000ff:	e8 52 16 00 00       	call   801756 <sys_getenvindex>
  800104:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 06             	shl    $0x6,%eax
  80010f:	29 d0                	sub    %edx,%eax
  800111:	c1 e0 02             	shl    $0x2,%eax
  800114:	01 d0                	add    %edx,%eax
  800116:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80011d:	01 c8                	add    %ecx,%eax
  80011f:	c1 e0 03             	shl    $0x3,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80012b:	29 c2                	sub    %eax,%edx
  80012d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800134:	89 c2                	mov    %eax,%edx
  800136:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80013c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800141:	a1 20 30 80 00       	mov    0x803020,%eax
  800146:	8a 40 20             	mov    0x20(%eax),%al
  800149:	84 c0                	test   %al,%al
  80014b:	74 0d                	je     80015a <libmain+0x64>
		binaryname = myEnv->prog_name;
  80014d:	a1 20 30 80 00       	mov    0x803020,%eax
  800152:	83 c0 20             	add    $0x20,%eax
  800155:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80015e:	7e 0a                	jle    80016a <libmain+0x74>
		binaryname = argv[0];
  800160:	8b 45 0c             	mov    0xc(%ebp),%eax
  800163:	8b 00                	mov    (%eax),%eax
  800165:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 75 0c             	pushl  0xc(%ebp)
  800170:	ff 75 08             	pushl  0x8(%ebp)
  800173:	e8 c0 fe ff ff       	call   800038 <_main>
  800178:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80017b:	a1 00 30 80 00       	mov    0x803000,%eax
  800180:	85 c0                	test   %eax,%eax
  800182:	0f 84 01 01 00 00    	je     800289 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800188:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80018e:	bb bc 1d 80 00       	mov    $0x801dbc,%ebx
  800193:	ba 0e 00 00 00       	mov    $0xe,%edx
  800198:	89 c7                	mov    %eax,%edi
  80019a:	89 de                	mov    %ebx,%esi
  80019c:	89 d1                	mov    %edx,%ecx
  80019e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	50                   	push   %eax
  8001bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 c4 17 00 00       	call   80198c <sys_utilities>
  8001c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cb:	e8 0d 13 00 00       	call   8014dd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	68 dc 1c 80 00       	push   $0x801cdc
  8001d8:	e8 ac 03 00 00       	call   800589 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	74 18                	je     8001ff <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001e7:	e8 be 17 00 00       	call   8019aa <sys_get_optimal_num_faults>
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	50                   	push   %eax
  8001f0:	68 04 1d 80 00       	push   $0x801d04
  8001f5:	e8 8f 03 00 00       	call   800589 <cprintf>
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	eb 59                	jmp    800258 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800204:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80020a:	a1 20 30 80 00       	mov    0x803020,%eax
  80020f:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 28 1d 80 00       	push   $0x801d28
  80021f:	e8 65 03 00 00       	call   800589 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800232:	a1 20 30 80 00       	mov    0x803020,%eax
  800237:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800248:	51                   	push   %ecx
  800249:	52                   	push   %edx
  80024a:	50                   	push   %eax
  80024b:	68 50 1d 80 00       	push   $0x801d50
  800250:	e8 34 03 00 00       	call   800589 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	50                   	push   %eax
  800267:	68 a8 1d 80 00       	push   $0x801da8
  80026c:	e8 18 03 00 00       	call   800589 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 dc 1c 80 00       	push   $0x801cdc
  80027c:	e8 08 03 00 00       	call   800589 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800284:	e8 6e 12 00 00       	call   8014f7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800289:	e8 1f 00 00 00       	call   8002ad <exit>
}
  80028e:	90                   	nop
  80028f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5f                   	pop    %edi
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    

00800297 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 00                	push   $0x0
  8002a2:	e8 7b 14 00 00       	call   801722 <sys_destroy_env>
  8002a7:	83 c4 10             	add    $0x10,%esp
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <exit>:

void
exit(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b3:	e8 d0 14 00 00       	call   801788 <sys_exit_env>
}
  8002b8:	90                   	nop
  8002b9:	c9                   	leave  
  8002ba:	c3                   	ret    

008002bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c4:	83 c0 04             	add    $0x4,%eax
  8002c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ca:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	74 16                	je     8002e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d3:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	50                   	push   %eax
  8002dc:	68 20 1e 80 00       	push   $0x801e20
  8002e1:	e8 a3 02 00 00       	call   800589 <cprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	50                   	push   %eax
  8002f8:	68 28 1e 80 00       	push   $0x801e28
  8002fd:	6a 74                	push   $0x74
  8002ff:	e8 b2 02 00 00       	call   8005b6 <cprintf_colored>
  800304:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800307:	8b 45 10             	mov    0x10(%ebp),%eax
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	ff 75 f4             	pushl  -0xc(%ebp)
  800310:	50                   	push   %eax
  800311:	e8 04 02 00 00       	call   80051a <vcprintf>
  800316:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	6a 00                	push   $0x0
  80031e:	68 50 1e 80 00       	push   $0x801e50
  800323:	e8 f2 01 00 00       	call   80051a <vcprintf>
  800328:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80032b:	e8 7d ff ff ff       	call   8002ad <exit>

	// should not return here
	while (1) ;
  800330:	eb fe                	jmp    800330 <_panic+0x75>

00800332 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800338:	a1 20 30 80 00       	mov    0x803020,%eax
  80033d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	39 c2                	cmp    %eax,%edx
  800348:	74 14                	je     80035e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80034a:	83 ec 04             	sub    $0x4,%esp
  80034d:	68 54 1e 80 00       	push   $0x801e54
  800352:	6a 26                	push   $0x26
  800354:	68 a0 1e 80 00       	push   $0x801ea0
  800359:	e8 5d ff ff ff       	call   8002bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80035e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800365:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036c:	e9 c5 00 00 00       	jmp    800436 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	85 c0                	test   %eax,%eax
  800384:	75 08                	jne    80038e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800386:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800389:	e9 a5 00 00 00       	jmp    800433 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80038e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800395:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80039c:	eb 69                	jmp    800407 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80039e:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ac:	89 d0                	mov    %edx,%eax
  8003ae:	01 c0                	add    %eax,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	c1 e0 03             	shl    $0x3,%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8a 40 04             	mov    0x4(%eax),%al
  8003ba:	84 c0                	test   %al,%al
  8003bc:	75 46                	jne    800404 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003cc:	89 d0                	mov    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	c1 e0 03             	shl    $0x3,%eax
  8003d5:	01 c8                	add    %ecx,%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	01 c8                	add    %ecx,%eax
  8003f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f7:	39 c2                	cmp    %eax,%edx
  8003f9:	75 09                	jne    800404 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800402:	eb 15                	jmp    800419 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800404:	ff 45 e8             	incl   -0x18(%ebp)
  800407:	a1 20 30 80 00       	mov    0x803020,%eax
  80040c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800415:	39 c2                	cmp    %eax,%edx
  800417:	77 85                	ja     80039e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80041d:	75 14                	jne    800433 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80041f:	83 ec 04             	sub    $0x4,%esp
  800422:	68 ac 1e 80 00       	push   $0x801eac
  800427:	6a 3a                	push   $0x3a
  800429:	68 a0 1e 80 00       	push   $0x801ea0
  80042e:	e8 88 fe ff ff       	call   8002bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800433:	ff 45 f0             	incl   -0x10(%ebp)
  800436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800439:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043c:	0f 8c 2f ff ff ff    	jl     800371 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800442:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800449:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800450:	eb 26                	jmp    800478 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800452:	a1 20 30 80 00       	mov    0x803020,%eax
  800457:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80045d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800460:	89 d0                	mov    %edx,%eax
  800462:	01 c0                	add    %eax,%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	c1 e0 03             	shl    $0x3,%eax
  800469:	01 c8                	add    %ecx,%eax
  80046b:	8a 40 04             	mov    0x4(%eax),%al
  80046e:	3c 01                	cmp    $0x1,%al
  800470:	75 03                	jne    800475 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800472:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800475:	ff 45 e0             	incl   -0x20(%ebp)
  800478:	a1 20 30 80 00       	mov    0x803020,%eax
  80047d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800483:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800486:	39 c2                	cmp    %eax,%edx
  800488:	77 c8                	ja     800452 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800490:	74 14                	je     8004a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800492:	83 ec 04             	sub    $0x4,%esp
  800495:	68 00 1f 80 00       	push   $0x801f00
  80049a:	6a 44                	push   $0x44
  80049c:	68 a0 1e 80 00       	push   $0x801ea0
  8004a1:	e8 15 fe ff ff       	call   8002bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004a6:	90                   	nop
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	89 0a                	mov    %ecx,(%edx)
  8004bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c0:	88 d1                	mov    %dl,%cl
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d3:	75 30                	jne    800505 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004d5:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004db:	a0 44 30 80 00       	mov    0x803044,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004e6:	8b 09                	mov    (%ecx),%ecx
  8004e8:	89 cb                	mov    %ecx,%ebx
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	83 c1 08             	add    $0x8,%ecx
  8004f0:	52                   	push   %edx
  8004f1:	50                   	push   %eax
  8004f2:	53                   	push   %ebx
  8004f3:	51                   	push   %ecx
  8004f4:	e8 a0 0f 00 00       	call   801499 <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 a9 04 80 00       	push   $0x8004a9
  800549:	e8 5a 02 00 00       	call   8007a8 <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800551:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800557:	a0 44 30 80 00       	mov    0x803044,%al
  80055c:	0f b6 c0             	movzbl %al,%eax
  80055f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800565:	52                   	push   %edx
  800566:	50                   	push   %eax
  800567:	51                   	push   %ecx
  800568:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056e:	83 c0 08             	add    $0x8,%eax
  800571:	50                   	push   %eax
  800572:	e8 22 0f 00 00       	call   801499 <sys_cputs>
  800577:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80057a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800581:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800596:	8d 45 0c             	lea    0xc(%ebp),%eax
  800599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a5:	50                   	push   %eax
  8005a6:	e8 6f ff ff ff       	call   80051a <vcprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	c1 e0 08             	shl    $0x8,%eax
  8005c9:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d1:	83 c0 04             	add    $0x4,%eax
  8005d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e0:	50                   	push   %eax
  8005e1:	e8 34 ff ff ff       	call   80051a <vcprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005ec:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005f3:	07 00 00 

	return cnt;
  8005f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800601:	e8 d7 0e 00 00       	call   8014dd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800606:	8d 45 0c             	lea    0xc(%ebp),%eax
  800609:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 f4             	pushl  -0xc(%ebp)
  800615:	50                   	push   %eax
  800616:	e8 ff fe ff ff       	call   80051a <vcprintf>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800621:	e8 d1 0e 00 00       	call   8014f7 <sys_unlock_cons>
	return cnt;
  800626:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    

0080062b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	53                   	push   %ebx
  80062f:	83 ec 14             	sub    $0x14,%esp
  800632:	8b 45 10             	mov    0x10(%ebp),%eax
  800635:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063e:	8b 45 18             	mov    0x18(%ebp),%eax
  800641:	ba 00 00 00 00       	mov    $0x0,%edx
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	77 55                	ja     8006a0 <printnum+0x75>
  80064b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064e:	72 05                	jb     800655 <printnum+0x2a>
  800650:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800653:	77 4b                	ja     8006a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800655:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800658:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065b:	8b 45 18             	mov    0x18(%ebp),%eax
  80065e:	ba 00 00 00 00       	mov    $0x0,%edx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	ff 75 f4             	pushl  -0xc(%ebp)
  800668:	ff 75 f0             	pushl  -0x10(%ebp)
  80066b:	e8 a8 13 00 00       	call   801a18 <__udivdi3>
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	83 ec 04             	sub    $0x4,%esp
  800676:	ff 75 20             	pushl  0x20(%ebp)
  800679:	53                   	push   %ebx
  80067a:	ff 75 18             	pushl  0x18(%ebp)
  80067d:	52                   	push   %edx
  80067e:	50                   	push   %eax
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	ff 75 08             	pushl  0x8(%ebp)
  800685:	e8 a1 ff ff ff       	call   80062b <printnum>
  80068a:	83 c4 20             	add    $0x20,%esp
  80068d:	eb 1a                	jmp    8006a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	ff 75 20             	pushl  0x20(%ebp)
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	ff d0                	call   *%eax
  80069d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a7:	7f e6                	jg     80068f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b7:	53                   	push   %ebx
  8006b8:	51                   	push   %ecx
  8006b9:	52                   	push   %edx
  8006ba:	50                   	push   %eax
  8006bb:	e8 68 14 00 00       	call   801b28 <__umoddi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	05 74 21 80 00       	add    $0x802174,%eax
  8006c8:	8a 00                	mov    (%eax),%al
  8006ca:	0f be c0             	movsbl %al,%eax
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	50                   	push   %eax
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
}
  8006dc:	90                   	nop
  8006dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e9:	7e 1c                	jle    800707 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 08             	lea    0x8(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 08             	sub    $0x8,%eax
  800700:	8b 50 04             	mov    0x4(%eax),%edx
  800703:	8b 00                	mov    (%eax),%eax
  800705:	eb 40                	jmp    800747 <getuint+0x65>
	else if (lflag)
  800707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070b:	74 1e                	je     80072b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 04             	sub    $0x4,%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	eb 1c                	jmp    800747 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800747:	5d                   	pop    %ebp
  800748:	c3                   	ret    

00800749 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800750:	7e 1c                	jle    80076e <getint+0x25>
		return va_arg(*ap, long long);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 08             	lea    0x8(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 08             	sub    $0x8,%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	eb 38                	jmp    8007a6 <getint+0x5d>
	else if (lflag)
  80076e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800772:	74 1a                	je     80078e <getint+0x45>
		return va_arg(*ap, long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	99                   	cltd   
  80078c:	eb 18                	jmp    8007a6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	8d 50 04             	lea    0x4(%eax),%edx
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	89 10                	mov    %edx,(%eax)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	83 e8 04             	sub    $0x4,%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	99                   	cltd   
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	56                   	push   %esi
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b0:	eb 17                	jmp    8007c9 <vprintfmt+0x21>
			if (ch == '\0')
  8007b2:	85 db                	test   %ebx,%ebx
  8007b4:	0f 84 c1 03 00 00    	je     800b7b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	53                   	push   %ebx
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cc:	8d 50 01             	lea    0x1(%eax),%edx
  8007cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d2:	8a 00                	mov    (%eax),%al
  8007d4:	0f b6 d8             	movzbl %al,%ebx
  8007d7:	83 fb 25             	cmp    $0x25,%ebx
  8007da:	75 d6                	jne    8007b2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007dc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ff:	8d 50 01             	lea    0x1(%eax),%edx
  800802:	89 55 10             	mov    %edx,0x10(%ebp)
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f b6 d8             	movzbl %al,%ebx
  80080a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80080d:	83 f8 5b             	cmp    $0x5b,%eax
  800810:	0f 87 3d 03 00 00    	ja     800b53 <vprintfmt+0x3ab>
  800816:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  80081d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800823:	eb d7                	jmp    8007fc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800825:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800829:	eb d1                	jmp    8007fc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800832:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800835:	89 d0                	mov    %edx,%eax
  800837:	c1 e0 02             	shl    $0x2,%eax
  80083a:	01 d0                	add    %edx,%eax
  80083c:	01 c0                	add    %eax,%eax
  80083e:	01 d8                	add    %ebx,%eax
  800840:	83 e8 30             	sub    $0x30,%eax
  800843:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800846:	8b 45 10             	mov    0x10(%ebp),%eax
  800849:	8a 00                	mov    (%eax),%al
  80084b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80084e:	83 fb 2f             	cmp    $0x2f,%ebx
  800851:	7e 3e                	jle    800891 <vprintfmt+0xe9>
  800853:	83 fb 39             	cmp    $0x39,%ebx
  800856:	7f 39                	jg     800891 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800858:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085b:	eb d5                	jmp    800832 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	83 c0 04             	add    $0x4,%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	83 e8 04             	sub    $0x4,%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800871:	eb 1f                	jmp    800892 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800877:	79 83                	jns    8007fc <vprintfmt+0x54>
				width = 0;
  800879:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800880:	e9 77 ff ff ff       	jmp    8007fc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800885:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088c:	e9 6b ff ff ff       	jmp    8007fc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800891:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800892:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800896:	0f 89 60 ff ff ff    	jns    8007fc <vprintfmt+0x54>
				width = precision, precision = -1;
  80089c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a9:	e9 4e ff ff ff       	jmp    8007fc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b1:	e9 46 ff ff ff       	jmp    8007fc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 c0 04             	add    $0x4,%eax
  8008bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 e8 04             	sub    $0x4,%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	50                   	push   %eax
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	ff d0                	call   *%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
			break;
  8008d6:	e9 9b 02 00 00       	jmp    800b76 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 e8 04             	sub    $0x4,%eax
  8008ea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ec:	85 db                	test   %ebx,%ebx
  8008ee:	79 02                	jns    8008f2 <vprintfmt+0x14a>
				err = -err;
  8008f0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f2:	83 fb 64             	cmp    $0x64,%ebx
  8008f5:	7f 0b                	jg     800902 <vprintfmt+0x15a>
  8008f7:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008fe:	85 f6                	test   %esi,%esi
  800900:	75 19                	jne    80091b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800902:	53                   	push   %ebx
  800903:	68 85 21 80 00       	push   $0x802185
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	e8 70 02 00 00       	call   800b83 <printfmt>
  800913:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800916:	e9 5b 02 00 00       	jmp    800b76 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091b:	56                   	push   %esi
  80091c:	68 8e 21 80 00       	push   $0x80218e
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 57 02 00 00       	call   800b83 <printfmt>
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 42 02 00 00       	jmp    800b76 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 e8 04             	sub    $0x4,%eax
  800943:	8b 30                	mov    (%eax),%esi
  800945:	85 f6                	test   %esi,%esi
  800947:	75 05                	jne    80094e <vprintfmt+0x1a6>
				p = "(null)";
  800949:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  80094e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800952:	7e 6d                	jle    8009c1 <vprintfmt+0x219>
  800954:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800958:	74 67                	je     8009c1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	50                   	push   %eax
  800961:	56                   	push   %esi
  800962:	e8 1e 03 00 00       	call   800c85 <strnlen>
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80096d:	eb 16                	jmp    800985 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	50                   	push   %eax
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	ff d0                	call   *%eax
  80097f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800982:	ff 4d e4             	decl   -0x1c(%ebp)
  800985:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800989:	7f e4                	jg     80096f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098b:	eb 34                	jmp    8009c1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80098d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800991:	74 1c                	je     8009af <vprintfmt+0x207>
  800993:	83 fb 1f             	cmp    $0x1f,%ebx
  800996:	7e 05                	jle    80099d <vprintfmt+0x1f5>
  800998:	83 fb 7e             	cmp    $0x7e,%ebx
  80099b:	7e 12                	jle    8009af <vprintfmt+0x207>
					putch('?', putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	6a 3f                	push   $0x3f
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	ff d0                	call   *%eax
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	eb 0f                	jmp    8009be <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009be:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c1:	89 f0                	mov    %esi,%eax
  8009c3:	8d 70 01             	lea    0x1(%eax),%esi
  8009c6:	8a 00                	mov    (%eax),%al
  8009c8:	0f be d8             	movsbl %al,%ebx
  8009cb:	85 db                	test   %ebx,%ebx
  8009cd:	74 24                	je     8009f3 <vprintfmt+0x24b>
  8009cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d3:	78 b8                	js     80098d <vprintfmt+0x1e5>
  8009d5:	ff 4d e0             	decl   -0x20(%ebp)
  8009d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009dc:	79 af                	jns    80098d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009de:	eb 13                	jmp    8009f3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 20                	push   $0x20
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f7:	7f e7                	jg     8009e0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f9:	e9 78 01 00 00       	jmp    800b76 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 e8             	pushl  -0x18(%ebp)
  800a04:	8d 45 14             	lea    0x14(%ebp),%eax
  800a07:	50                   	push   %eax
  800a08:	e8 3c fd ff ff       	call   800749 <getint>
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1c:	85 d2                	test   %edx,%edx
  800a1e:	79 23                	jns    800a43 <vprintfmt+0x29b>
				putch('-', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 2d                	push   $0x2d
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a36:	f7 d8                	neg    %eax
  800a38:	83 d2 00             	adc    $0x0,%edx
  800a3b:	f7 da                	neg    %edx
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4a:	e9 bc 00 00 00       	jmp    800b0b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 e8             	pushl  -0x18(%ebp)
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	50                   	push   %eax
  800a59:	e8 84 fc ff ff       	call   8006e2 <getuint>
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6e:	e9 98 00 00 00       	jmp    800b0b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	6a 58                	push   $0x58
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 58                	push   $0x58
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	6a 58                	push   $0x58
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			break;
  800aa3:	e9 ce 00 00 00       	jmp    800b76 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 30                	push   $0x30
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 78                	push   $0x78
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	83 c0 04             	add    $0x4,%eax
  800ace:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aea:	eb 1f                	jmp    800b0b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 e8             	pushl  -0x18(%ebp)
  800af2:	8d 45 14             	lea    0x14(%ebp),%eax
  800af5:	50                   	push   %eax
  800af6:	e8 e7 fb ff ff       	call   8006e2 <getuint>
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b12:	83 ec 04             	sub    $0x4,%esp
  800b15:	52                   	push   %edx
  800b16:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b19:	50                   	push   %eax
  800b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 00 fb ff ff       	call   80062b <printnum>
  800b2b:	83 c4 20             	add    $0x20,%esp
			break;
  800b2e:	eb 46                	jmp    800b76 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	53                   	push   %ebx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	ff d0                	call   *%eax
  800b3c:	83 c4 10             	add    $0x10,%esp
			break;
  800b3f:	eb 35                	jmp    800b76 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b41:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b48:	eb 2c                	jmp    800b76 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b4a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b51:	eb 23                	jmp    800b76 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 25                	push   $0x25
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b63:	ff 4d 10             	decl   0x10(%ebp)
  800b66:	eb 03                	jmp    800b6b <vprintfmt+0x3c3>
  800b68:	ff 4d 10             	decl   0x10(%ebp)
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6e:	48                   	dec    %eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	3c 25                	cmp    $0x25,%al
  800b73:	75 f3                	jne    800b68 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b75:	90                   	nop
		}
	}
  800b76:	e9 35 fc ff ff       	jmp    8007b0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b7b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b89:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8c:	83 c0 04             	add    $0x4,%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	ff 75 08             	pushl  0x8(%ebp)
  800b9f:	e8 04 fc ff ff       	call   8007a8 <vprintfmt>
  800ba4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba7:	90                   	nop
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	8b 40 08             	mov    0x8(%eax),%eax
  800bb3:	8d 50 01             	lea    0x1(%eax),%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8b 10                	mov    (%eax),%edx
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	8b 40 04             	mov    0x4(%eax),%eax
  800bc7:	39 c2                	cmp    %eax,%edx
  800bc9:	73 12                	jae    800bdd <sprintputch+0x33>
		*b->buf++ = ch;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	89 0a                	mov    %ecx,(%edx)
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	88 10                	mov    %dl,(%eax)
}
  800bdd:	90                   	nop
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	01 d0                	add    %edx,%eax
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c05:	74 06                	je     800c0d <vsnprintf+0x2d>
  800c07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0b:	7f 07                	jg     800c14 <vsnprintf+0x34>
		return -E_INVAL;
  800c0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c12:	eb 20                	jmp    800c34 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c14:	ff 75 14             	pushl  0x14(%ebp)
  800c17:	ff 75 10             	pushl  0x10(%ebp)
  800c1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c1d:	50                   	push   %eax
  800c1e:	68 aa 0b 80 00       	push   $0x800baa
  800c23:	e8 80 fb ff ff       	call   8007a8 <vprintfmt>
  800c28:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3f:	83 c0 04             	add    $0x4,%eax
  800c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	ff 75 08             	pushl  0x8(%ebp)
  800c52:	e8 89 ff ff ff       	call   800be0 <vsnprintf>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6f:	eb 06                	jmp    800c77 <strlen+0x15>
		n++;
  800c71:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c74:	ff 45 08             	incl   0x8(%ebp)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	84 c0                	test   %al,%al
  800c7e:	75 f1                	jne    800c71 <strlen+0xf>
		n++;
	return n;
  800c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c92:	eb 09                	jmp    800c9d <strnlen+0x18>
		n++;
  800c94:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c97:	ff 45 08             	incl   0x8(%ebp)
  800c9a:	ff 4d 0c             	decl   0xc(%ebp)
  800c9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca1:	74 09                	je     800cac <strnlen+0x27>
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 e8                	jne    800c94 <strnlen+0xf>
		n++;
	return n;
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cbd:	90                   	nop
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	84 c0                	test   %al,%al
  800cd8:	75 e4                	jne    800cbe <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ceb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf2:	eb 1f                	jmp    800d13 <strncpy+0x34>
		*dst++ = *src;
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8d 50 01             	lea    0x1(%eax),%edx
  800cfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d00:	8a 12                	mov    (%edx),%dl
  800d02:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	84 c0                	test   %al,%al
  800d0b:	74 03                	je     800d10 <strncpy+0x31>
			src++;
  800d0d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d10:	ff 45 fc             	incl   -0x4(%ebp)
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d19:	72 d9                	jb     800cf4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d30:	74 30                	je     800d62 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d32:	eb 16                	jmp    800d4a <strlcpy+0x2a>
			*dst++ = *src++;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8d 50 01             	lea    0x1(%eax),%edx
  800d3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d46:	8a 12                	mov    (%edx),%dl
  800d48:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d4a:	ff 4d 10             	decl   0x10(%ebp)
  800d4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d51:	74 09                	je     800d5c <strlcpy+0x3c>
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 d8                	jne    800d34 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	29 c2                	sub    %eax,%edx
  800d6a:	89 d0                	mov    %edx,%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d71:	eb 06                	jmp    800d79 <strcmp+0xb>
		p++, q++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	74 0e                	je     800d90 <strcmp+0x22>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 10                	mov    (%eax),%dl
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	38 c2                	cmp    %al,%dl
  800d8e:	74 e3                	je     800d73 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	0f b6 d0             	movzbl %al,%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f b6 c0             	movzbl %al,%eax
  800da0:	29 c2                	sub    %eax,%edx
  800da2:	89 d0                	mov    %edx,%eax
}
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da9:	eb 09                	jmp    800db4 <strncmp+0xe>
		n--, p++, q++;
  800dab:	ff 4d 10             	decl   0x10(%ebp)
  800dae:	ff 45 08             	incl   0x8(%ebp)
  800db1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db8:	74 17                	je     800dd1 <strncmp+0x2b>
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	84 c0                	test   %al,%al
  800dc1:	74 0e                	je     800dd1 <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 10                	mov    (%eax),%dl
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	38 c2                	cmp    %al,%dl
  800dcf:	74 da                	je     800dab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd5:	75 07                	jne    800dde <strncmp+0x38>
		return 0;
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddc:	eb 14                	jmp    800df2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	0f b6 d0             	movzbl %al,%edx
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	0f b6 c0             	movzbl %al,%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 04             	sub    $0x4,%esp
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e00:	eb 12                	jmp    800e14 <strchr+0x20>
		if (*s == c)
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0a:	75 05                	jne    800e11 <strchr+0x1d>
			return (char *) s;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	eb 11                	jmp    800e22 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e11:	ff 45 08             	incl   0x8(%ebp)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 e5                	jne    800e02 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e30:	eb 0d                	jmp    800e3f <strfind+0x1b>
		if (*s == c)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3a:	74 0e                	je     800e4a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	84 c0                	test   %al,%al
  800e46:	75 ea                	jne    800e32 <strfind+0xe>
  800e48:	eb 01                	jmp    800e4b <strfind+0x27>
		if (*s == c)
			break;
  800e4a:	90                   	nop
	return (char *) s;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e5c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e60:	76 63                	jbe    800ec5 <memset+0x75>
		uint64 data_block = c;
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	99                   	cltd   
  800e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e69:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e72:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e76:	c1 e0 08             	shl    $0x8,%eax
  800e79:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e85:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e89:	c1 e0 10             	shl    $0x10,%eax
  800e8c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e98:	89 c2                	mov    %eax,%edx
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ea5:	eb 18                	jmp    800ebf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ea7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eaa:	8d 41 08             	lea    0x8(%ecx),%eax
  800ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	89 01                	mov    %eax,(%ecx)
  800eb8:	89 51 04             	mov    %edx,0x4(%ecx)
  800ebb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ebf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec3:	77 e2                	ja     800ea7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec9:	74 23                	je     800eee <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed1:	eb 0e                	jmp    800ee1 <memset+0x91>
			*p8++ = (uint8)c;
  800ed3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed6:	8d 50 01             	lea    0x1(%eax),%edx
  800ed9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edf:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	75 e5                	jne    800ed3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f05:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f09:	76 24                	jbe    800f2f <memcpy+0x3c>
		while(n >= 8){
  800f0b:	eb 1c                	jmp    800f29 <memcpy+0x36>
			*d64 = *s64;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	8b 50 04             	mov    0x4(%eax),%edx
  800f13:	8b 00                	mov    (%eax),%eax
  800f15:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f18:	89 01                	mov    %eax,(%ecx)
  800f1a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f1d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f21:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f25:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f29:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2d:	77 de                	ja     800f0d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 31                	je     800f66 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f41:	eb 16                	jmp    800f59 <memcpy+0x66>
			*d8++ = *s8++;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f46:	8d 50 01             	lea    0x1(%eax),%edx
  800f49:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f52:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f55:	8a 12                	mov    (%edx),%dl
  800f57:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	75 dd                	jne    800f43 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f83:	73 50                	jae    800fd5 <memmove+0x6a>
  800f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f90:	76 43                	jbe    800fd5 <memmove+0x6a>
		s += n;
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9e:	eb 10                	jmp    800fb0 <memmove+0x45>
			*--d = *--s;
  800fa0:	ff 4d f8             	decl   -0x8(%ebp)
  800fa3:	ff 4d fc             	decl   -0x4(%ebp)
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	8a 10                	mov    (%eax),%dl
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 e3                	jne    800fa0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fbd:	eb 23                	jmp    800fe2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd1:	8a 12                	mov    (%edx),%dl
  800fd3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	75 dd                	jne    800fbf <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff9:	eb 2a                	jmp    801025 <memcmp+0x3e>
		if (*s1 != *s2)
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8a 10                	mov    (%eax),%dl
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	38 c2                	cmp    %al,%dl
  801007:	74 16                	je     80101f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801009:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f b6 d0             	movzbl %al,%edx
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
  80101d:	eb 18                	jmp    801037 <memcmp+0x50>
		s1++, s2++;
  80101f:	ff 45 fc             	incl   -0x4(%ebp)
  801022:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 c9                	jne    800ffb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	01 d0                	add    %edx,%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80104a:	eb 15                	jmp    801061 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	0f b6 d0             	movzbl %al,%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	0f b6 c0             	movzbl %al,%eax
  80105a:	39 c2                	cmp    %eax,%edx
  80105c:	74 0d                	je     80106b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801067:	72 e3                	jb     80104c <memfind+0x13>
  801069:	eb 01                	jmp    80106c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80106b:	90                   	nop
	return (void *) s;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801085:	eb 03                	jmp    80108a <strtol+0x19>
		s++;
  801087:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 20                	cmp    $0x20,%al
  801091:	74 f4                	je     801087 <strtol+0x16>
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 09                	cmp    $0x9,%al
  80109a:	74 eb                	je     801087 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 2b                	cmp    $0x2b,%al
  8010a3:	75 05                	jne    8010aa <strtol+0x39>
		s++;
  8010a5:	ff 45 08             	incl   0x8(%ebp)
  8010a8:	eb 13                	jmp    8010bd <strtol+0x4c>
	else if (*s == '-')
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 2d                	cmp    $0x2d,%al
  8010b1:	75 0a                	jne    8010bd <strtol+0x4c>
		s++, neg = 1;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
  8010b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c1:	74 06                	je     8010c9 <strtol+0x58>
  8010c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c7:	75 20                	jne    8010e9 <strtol+0x78>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 30                	cmp    $0x30,%al
  8010d0:	75 17                	jne    8010e9 <strtol+0x78>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	40                   	inc    %eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 78                	cmp    $0x78,%al
  8010da:	75 0d                	jne    8010e9 <strtol+0x78>
		s += 2, base = 16;
  8010dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e7:	eb 28                	jmp    801111 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ed:	75 15                	jne    801104 <strtol+0x93>
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 30                	cmp    $0x30,%al
  8010f6:	75 0c                	jne    801104 <strtol+0x93>
		s++, base = 8;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801102:	eb 0d                	jmp    801111 <strtol+0xa0>
	else if (base == 0)
  801104:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801108:	75 07                	jne    801111 <strtol+0xa0>
		base = 10;
  80110a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 2f                	cmp    $0x2f,%al
  801118:	7e 19                	jle    801133 <strtol+0xc2>
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	3c 39                	cmp    $0x39,%al
  801121:	7f 10                	jg     801133 <strtol+0xc2>
			dig = *s - '0';
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	0f be c0             	movsbl %al,%eax
  80112b:	83 e8 30             	sub    $0x30,%eax
  80112e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801131:	eb 42                	jmp    801175 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 60                	cmp    $0x60,%al
  80113a:	7e 19                	jle    801155 <strtol+0xe4>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 7a                	cmp    $0x7a,%al
  801143:	7f 10                	jg     801155 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f be c0             	movsbl %al,%eax
  80114d:	83 e8 57             	sub    $0x57,%eax
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801153:	eb 20                	jmp    801175 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 40                	cmp    $0x40,%al
  80115c:	7e 39                	jle    801197 <strtol+0x126>
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 5a                	cmp    $0x5a,%al
  801165:	7f 30                	jg     801197 <strtol+0x126>
			dig = *s - 'A' + 10;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f be c0             	movsbl %al,%eax
  80116f:	83 e8 37             	sub    $0x37,%eax
  801172:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801178:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117b:	7d 19                	jge    801196 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	0f af 45 10          	imul   0x10(%ebp),%eax
  801187:	89 c2                	mov    %eax,%edx
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801191:	e9 7b ff ff ff       	jmp    801111 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801196:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119b:	74 08                	je     8011a5 <strtol+0x134>
		*endptr = (char *) s;
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a9:	74 07                	je     8011b2 <strtol+0x141>
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	f7 d8                	neg    %eax
  8011b0:	eb 03                	jmp    8011b5 <strtol+0x144>
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cf:	79 13                	jns    8011e4 <ltostr+0x2d>
	{
		neg = 1;
  8011d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ec:	99                   	cltd   
  8011ed:	f7 f9                	idiv   %ecx
  8011ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	01 d0                	add    %edx,%eax
  801202:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801205:	83 c2 30             	add    $0x30,%edx
  801208:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80120a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801212:	f7 e9                	imul   %ecx
  801214:	c1 fa 02             	sar    $0x2,%edx
  801217:	89 c8                	mov    %ecx,%eax
  801219:	c1 f8 1f             	sar    $0x1f,%eax
  80121c:	29 c2                	sub    %eax,%edx
  80121e:	89 d0                	mov    %edx,%eax
  801220:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801227:	75 bb                	jne    8011e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801230:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801233:	48                   	dec    %eax
  801234:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801237:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123b:	74 3d                	je     80127a <ltostr+0xc3>
		start = 1 ;
  80123d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801244:	eb 34                	jmp    80127a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	01 c2                	add    %eax,%edx
  80125b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 c8                	add    %ecx,%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80126a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126d:	01 c2                	add    %eax,%edx
  80126f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801272:	88 02                	mov    %al,(%edx)
		start++ ;
  801274:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801277:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80127a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c c4                	jl     801246 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801282:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801296:	ff 75 08             	pushl  0x8(%ebp)
  801299:	e8 c4 f9 ff ff       	call   800c62 <strlen>
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	e8 b6 f9 ff ff       	call   800c62 <strlen>
  8012ac:	83 c4 04             	add    $0x4,%esp
  8012af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c0:	eb 17                	jmp    8012d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 c2                	add    %eax,%edx
  8012ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	01 c8                	add    %ecx,%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d6:	ff 45 fc             	incl   -0x4(%ebp)
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012df:	7c e1                	jl     8012c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ef:	eb 1f                	jmp    801310 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	8d 50 01             	lea    0x1(%eax),%edx
  8012f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fa:	89 c2                	mov    %eax,%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80130d:	ff 45 f8             	incl   -0x8(%ebp)
  801310:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801313:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801316:	7c d9                	jl     8012f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	c6 00 00             	movb   $0x0,(%eax)
}
  801323:	90                   	nop
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801329:	8b 45 14             	mov    0x14(%ebp),%eax
  80132c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801332:	8b 45 14             	mov    0x14(%ebp),%eax
  801335:	8b 00                	mov    (%eax),%eax
  801337:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	01 d0                	add    %edx,%eax
  801343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801349:	eb 0c                	jmp    801357 <strsplit+0x31>
			*string++ = 0;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 08             	mov    %edx,0x8(%ebp)
  801354:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	74 18                	je     801378 <strsplit+0x52>
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	0f be c0             	movsbl %al,%eax
  801368:	50                   	push   %eax
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	e8 83 fa ff ff       	call   800df4 <strchr>
  801371:	83 c4 08             	add    $0x8,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	75 d3                	jne    80134b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	84 c0                	test   %al,%al
  80137f:	74 5a                	je     8013db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	83 f8 0f             	cmp    $0xf,%eax
  801389:	75 07                	jne    801392 <strsplit+0x6c>
		{
			return 0;
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	eb 66                	jmp    8013f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801392:	8b 45 14             	mov    0x14(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	8d 48 01             	lea    0x1(%eax),%ecx
  80139a:	8b 55 14             	mov    0x14(%ebp),%edx
  80139d:	89 0a                	mov    %ecx,(%edx)
  80139f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 c2                	add    %eax,%edx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b0:	eb 03                	jmp    8013b5 <strsplit+0x8f>
			string++;
  8013b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	84 c0                	test   %al,%al
  8013bc:	74 8b                	je     801349 <strsplit+0x23>
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f be c0             	movsbl %al,%eax
  8013c6:	50                   	push   %eax
  8013c7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ca:	e8 25 fa ff ff       	call   800df4 <strchr>
  8013cf:	83 c4 08             	add    $0x8,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	74 dc                	je     8013b2 <strsplit+0x8c>
			string++;
	}
  8013d6:	e9 6e ff ff ff       	jmp    801349 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140d:	eb 4a                	jmp    801459 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80140f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	01 c2                	add    %eax,%edx
  801417:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 c8                	add    %ecx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 40                	cmp    $0x40,%al
  80142f:	7e 25                	jle    801456 <str2lower+0x5c>
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 17                	jg     801456 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80143f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	01 d0                	add    %edx,%eax
  801447:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80144a:	8b 55 08             	mov    0x8(%ebp),%edx
  80144d:	01 ca                	add    %ecx,%edx
  80144f:	8a 12                	mov    (%edx),%dl
  801451:	83 c2 20             	add    $0x20,%edx
  801454:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801456:	ff 45 fc             	incl   -0x4(%ebp)
  801459:	ff 75 0c             	pushl  0xc(%ebp)
  80145c:	e8 01 f8 ff ff       	call   800c62 <strlen>
  801461:	83 c4 04             	add    $0x4,%esp
  801464:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801467:	7f a6                	jg     80140f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
  801474:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801480:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801483:	8b 7d 18             	mov    0x18(%ebp),%edi
  801486:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801489:	cd 30                	int    $0x30
  80148b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	5b                   	pop    %ebx
  801495:	5e                   	pop    %esi
  801496:	5f                   	pop    %edi
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    

00801499 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	51                   	push   %ecx
  8014b2:	52                   	push   %edx
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	e8 b0 ff ff ff       	call   80146e <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	90                   	nop
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 02                	push   $0x2
  8014d3:	e8 96 ff ff ff       	call   80146e <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 03                	push   $0x3
  8014ec:	e8 7d ff ff ff       	call   80146e <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	90                   	nop
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 04                	push   $0x4
  801506:	e8 63 ff ff ff       	call   80146e <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	90                   	nop
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	52                   	push   %edx
  801521:	50                   	push   %eax
  801522:	6a 08                	push   $0x8
  801524:	e8 45 ff ff ff       	call   80146e <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801533:	8b 75 18             	mov    0x18(%ebp),%esi
  801536:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801539:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
  801544:	51                   	push   %ecx
  801545:	52                   	push   %edx
  801546:	50                   	push   %eax
  801547:	6a 09                	push   $0x9
  801549:	e8 20 ff ff ff       	call   80146e <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	ff 75 08             	pushl  0x8(%ebp)
  801566:	6a 0a                	push   $0xa
  801568:	e8 01 ff ff ff       	call   80146e <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 0c             	pushl  0xc(%ebp)
  80157e:	ff 75 08             	pushl  0x8(%ebp)
  801581:	6a 0b                	push   $0xb
  801583:	e8 e6 fe ff ff       	call   80146e <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 0c                	push   $0xc
  80159c:	e8 cd fe ff ff       	call   80146e <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 0d                	push   $0xd
  8015b5:	e8 b4 fe ff ff       	call   80146e <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 0e                	push   $0xe
  8015ce:	e8 9b fe ff ff       	call   80146e <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 0f                	push   $0xf
  8015e7:	e8 82 fe ff ff       	call   80146e <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	6a 10                	push   $0x10
  801601:	e8 68 fe ff ff       	call   80146e <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 11                	push   $0x11
  80161a:	e8 4f fe ff ff       	call   80146e <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	90                   	nop
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_cputc>:

void
sys_cputc(const char c)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801631:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	50                   	push   %eax
  80163e:	6a 01                	push   $0x1
  801640:	e8 29 fe ff ff       	call   80146e <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 14                	push   $0x14
  80165a:	e8 0f fe ff ff       	call   80146e <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	90                   	nop
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	8b 45 10             	mov    0x10(%ebp),%eax
  80166e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801671:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801674:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	6a 00                	push   $0x0
  80167d:	51                   	push   %ecx
  80167e:	52                   	push   %edx
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	50                   	push   %eax
  801683:	6a 15                	push   $0x15
  801685:	e8 e4 fd ff ff       	call   80146e <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	52                   	push   %edx
  80169f:	50                   	push   %eax
  8016a0:	6a 16                	push   $0x16
  8016a2:	e8 c7 fd ff ff       	call   80146e <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	51                   	push   %ecx
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 17                	push   $0x17
  8016c1:	e8 a8 fd ff ff       	call   80146e <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	52                   	push   %edx
  8016db:	50                   	push   %eax
  8016dc:	6a 18                	push   $0x18
  8016de:	e8 8b fd ff ff       	call   80146e <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	6a 00                	push   $0x0
  8016f0:	ff 75 14             	pushl  0x14(%ebp)
  8016f3:	ff 75 10             	pushl  0x10(%ebp)
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	6a 19                	push   $0x19
  8016fc:	e8 6d fd ff ff       	call   80146e <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	50                   	push   %eax
  801715:	6a 1a                	push   $0x1a
  801717:	e8 52 fd ff ff       	call   80146e <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	50                   	push   %eax
  801731:	6a 1b                	push   $0x1b
  801733:	e8 36 fd ff ff       	call   80146e <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 05                	push   $0x5
  80174c:	e8 1d fd ff ff       	call   80146e <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 06                	push   $0x6
  801765:	e8 04 fd ff ff       	call   80146e <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 07                	push   $0x7
  80177e:	e8 eb fc ff ff       	call   80146e <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_exit_env>:


void sys_exit_env(void)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 1c                	push   $0x1c
  801797:	e8 d2 fc ff ff       	call   80146e <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	90                   	nop
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ab:	8d 50 04             	lea    0x4(%eax),%edx
  8017ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 1d                	push   $0x1d
  8017bb:	e8 ae fc ff ff       	call   80146e <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
	return result;
  8017c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cc:	89 01                	mov    %eax,(%ecx)
  8017ce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	c9                   	leave  
  8017d5:	c2 04 00             	ret    $0x4

008017d8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	ff 75 10             	pushl  0x10(%ebp)
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 13                	push   $0x13
  8017ea:	e8 7f fc ff ff       	call   80146e <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 1e                	push   $0x1e
  801804:	e8 65 fc ff ff       	call   80146e <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80181a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	50                   	push   %eax
  801827:	6a 1f                	push   $0x1f
  801829:	e8 40 fc ff ff       	call   80146e <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
	return ;
  801831:	90                   	nop
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <rsttst>:
void rsttst()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 21                	push   $0x21
  801843:	e8 26 fc ff ff       	call   80146e <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
	return ;
  80184b:	90                   	nop
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	8b 45 14             	mov    0x14(%ebp),%eax
  801857:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80185a:	8b 55 18             	mov    0x18(%ebp),%edx
  80185d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	ff 75 10             	pushl  0x10(%ebp)
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	6a 20                	push   $0x20
  80186e:	e8 fb fb ff ff       	call   80146e <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return ;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <chktst>:
void chktst(uint32 n)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 22                	push   $0x22
  801889:	e8 e0 fb ff ff       	call   80146e <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <inctst>:

void inctst()
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 23                	push   $0x23
  8018a3:	e8 c6 fb ff ff       	call   80146e <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <gettst>:
uint32 gettst()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 24                	push   $0x24
  8018bd:	e8 ac fb ff ff       	call   80146e <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 25                	push   $0x25
  8018d6:	e8 93 fb ff ff       	call   80146e <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
  8018de:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018e3:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 08             	pushl  0x8(%ebp)
  801900:	6a 26                	push   $0x26
  801902:	e8 67 fb ff ff       	call   80146e <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
	return ;
  80190a:	90                   	nop
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801911:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801914:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	53                   	push   %ebx
  801920:	51                   	push   %ecx
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 27                	push   $0x27
  801925:	e8 44 fb ff ff       	call   80146e <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	52                   	push   %edx
  801942:	50                   	push   %eax
  801943:	6a 28                	push   $0x28
  801945:	e8 24 fb ff ff       	call   80146e <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801952:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801955:	8b 55 0c             	mov    0xc(%ebp),%edx
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	6a 00                	push   $0x0
  80195d:	51                   	push   %ecx
  80195e:	ff 75 10             	pushl  0x10(%ebp)
  801961:	52                   	push   %edx
  801962:	50                   	push   %eax
  801963:	6a 29                	push   $0x29
  801965:	e8 04 fb ff ff       	call   80146e <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	ff 75 10             	pushl  0x10(%ebp)
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	6a 12                	push   $0x12
  801981:	e8 e8 fa ff ff       	call   80146e <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
	return ;
  801989:	90                   	nop
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 2a                	push   $0x2a
  80199f:	e8 ca fa ff ff       	call   80146e <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 2b                	push   $0x2b
  8019b9:	e8 b0 fa ff ff       	call   80146e <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 2d                	push   $0x2d
  8019d4:	e8 95 fa ff ff       	call   80146e <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 2c                	push   $0x2c
  8019f0:	e8 79 fa ff ff       	call   80146e <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	68 08 23 80 00       	push   $0x802308
  801a09:	68 25 01 00 00       	push   $0x125
  801a0e:	68 3b 23 80 00       	push   $0x80233b
  801a13:	e8 a3 e8 ff ff       	call   8002bb <_panic>

00801a18 <__udivdi3>:
  801a18:	55                   	push   %ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2f:	89 ca                	mov    %ecx,%edx
  801a31:	89 f8                	mov    %edi,%eax
  801a33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a37:	85 f6                	test   %esi,%esi
  801a39:	75 2d                	jne    801a68 <__udivdi3+0x50>
  801a3b:	39 cf                	cmp    %ecx,%edi
  801a3d:	77 65                	ja     801aa4 <__udivdi3+0x8c>
  801a3f:	89 fd                	mov    %edi,%ebp
  801a41:	85 ff                	test   %edi,%edi
  801a43:	75 0b                	jne    801a50 <__udivdi3+0x38>
  801a45:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4a:	31 d2                	xor    %edx,%edx
  801a4c:	f7 f7                	div    %edi
  801a4e:	89 c5                	mov    %eax,%ebp
  801a50:	31 d2                	xor    %edx,%edx
  801a52:	89 c8                	mov    %ecx,%eax
  801a54:	f7 f5                	div    %ebp
  801a56:	89 c1                	mov    %eax,%ecx
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	f7 f5                	div    %ebp
  801a5c:	89 cf                	mov    %ecx,%edi
  801a5e:	89 fa                	mov    %edi,%edx
  801a60:	83 c4 1c             	add    $0x1c,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	77 28                	ja     801a94 <__udivdi3+0x7c>
  801a6c:	0f bd fe             	bsr    %esi,%edi
  801a6f:	83 f7 1f             	xor    $0x1f,%edi
  801a72:	75 40                	jne    801ab4 <__udivdi3+0x9c>
  801a74:	39 ce                	cmp    %ecx,%esi
  801a76:	72 0a                	jb     801a82 <__udivdi3+0x6a>
  801a78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a7c:	0f 87 9e 00 00 00    	ja     801b20 <__udivdi3+0x108>
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
  801a87:	89 fa                	mov    %edi,%edx
  801a89:	83 c4 1c             	add    $0x1c,%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5f                   	pop    %edi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
  801a91:	8d 76 00             	lea    0x0(%esi),%esi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	31 c0                	xor    %eax,%eax
  801a98:	89 fa                	mov    %edi,%edx
  801a9a:	83 c4 1c             	add    $0x1c,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5f                   	pop    %edi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	f7 f7                	div    %edi
  801aa8:	31 ff                	xor    %edi,%edi
  801aaa:	89 fa                	mov    %edi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab9:	89 eb                	mov    %ebp,%ebx
  801abb:	29 fb                	sub    %edi,%ebx
  801abd:	89 f9                	mov    %edi,%ecx
  801abf:	d3 e6                	shl    %cl,%esi
  801ac1:	89 c5                	mov    %eax,%ebp
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ed                	shr    %cl,%ebp
  801ac7:	89 e9                	mov    %ebp,%ecx
  801ac9:	09 f1                	or     %esi,%ecx
  801acb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e0                	shl    %cl,%eax
  801ad3:	89 c5                	mov    %eax,%ebp
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 ee                	shr    %cl,%esi
  801adb:	89 f9                	mov    %edi,%ecx
  801add:	d3 e2                	shl    %cl,%edx
  801adf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 e8                	shr    %cl,%eax
  801ae7:	09 c2                	or     %eax,%edx
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	89 f2                	mov    %esi,%edx
  801aed:	f7 74 24 0c          	divl   0xc(%esp)
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	f7 e5                	mul    %ebp
  801af7:	39 d6                	cmp    %edx,%esi
  801af9:	72 19                	jb     801b14 <__udivdi3+0xfc>
  801afb:	74 0b                	je     801b08 <__udivdi3+0xf0>
  801afd:	89 d8                	mov    %ebx,%eax
  801aff:	31 ff                	xor    %edi,%edi
  801b01:	e9 58 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b0c:	89 f9                	mov    %edi,%ecx
  801b0e:	d3 e2                	shl    %cl,%edx
  801b10:	39 c2                	cmp    %eax,%edx
  801b12:	73 e9                	jae    801afd <__udivdi3+0xe5>
  801b14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b17:	31 ff                	xor    %edi,%edi
  801b19:	e9 40 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	31 c0                	xor    %eax,%eax
  801b22:	e9 37 ff ff ff       	jmp    801a5e <__udivdi3+0x46>
  801b27:	90                   	nop

00801b28 <__umoddi3>:
  801b28:	55                   	push   %ebp
  801b29:	57                   	push   %edi
  801b2a:	56                   	push   %esi
  801b2b:	53                   	push   %ebx
  801b2c:	83 ec 1c             	sub    $0x1c,%esp
  801b2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b47:	89 f3                	mov    %esi,%ebx
  801b49:	89 fa                	mov    %edi,%edx
  801b4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4f:	89 34 24             	mov    %esi,(%esp)
  801b52:	85 c0                	test   %eax,%eax
  801b54:	75 1a                	jne    801b70 <__umoddi3+0x48>
  801b56:	39 f7                	cmp    %esi,%edi
  801b58:	0f 86 a2 00 00 00    	jbe    801c00 <__umoddi3+0xd8>
  801b5e:	89 c8                	mov    %ecx,%eax
  801b60:	89 f2                	mov    %esi,%edx
  801b62:	f7 f7                	div    %edi
  801b64:	89 d0                	mov    %edx,%eax
  801b66:	31 d2                	xor    %edx,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	39 f0                	cmp    %esi,%eax
  801b72:	0f 87 ac 00 00 00    	ja     801c24 <__umoddi3+0xfc>
  801b78:	0f bd e8             	bsr    %eax,%ebp
  801b7b:	83 f5 1f             	xor    $0x1f,%ebp
  801b7e:	0f 84 ac 00 00 00    	je     801c30 <__umoddi3+0x108>
  801b84:	bf 20 00 00 00       	mov    $0x20,%edi
  801b89:	29 ef                	sub    %ebp,%edi
  801b8b:	89 fe                	mov    %edi,%esi
  801b8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e0                	shl    %cl,%eax
  801b95:	89 d7                	mov    %edx,%edi
  801b97:	89 f1                	mov    %esi,%ecx
  801b99:	d3 ef                	shr    %cl,%edi
  801b9b:	09 c7                	or     %eax,%edi
  801b9d:	89 e9                	mov    %ebp,%ecx
  801b9f:	d3 e2                	shl    %cl,%edx
  801ba1:	89 14 24             	mov    %edx,(%esp)
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	d3 e0                	shl    %cl,%eax
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb8:	89 f1                	mov    %esi,%ecx
  801bba:	d3 e8                	shr    %cl,%eax
  801bbc:	09 d0                	or     %edx,%eax
  801bbe:	d3 eb                	shr    %cl,%ebx
  801bc0:	89 da                	mov    %ebx,%edx
  801bc2:	f7 f7                	div    %edi
  801bc4:	89 d3                	mov    %edx,%ebx
  801bc6:	f7 24 24             	mull   (%esp)
  801bc9:	89 c6                	mov    %eax,%esi
  801bcb:	89 d1                	mov    %edx,%ecx
  801bcd:	39 d3                	cmp    %edx,%ebx
  801bcf:	0f 82 87 00 00 00    	jb     801c5c <__umoddi3+0x134>
  801bd5:	0f 84 91 00 00 00    	je     801c6c <__umoddi3+0x144>
  801bdb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bdf:	29 f2                	sub    %esi,%edx
  801be1:	19 cb                	sbb    %ecx,%ebx
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be9:	d3 e0                	shl    %cl,%eax
  801beb:	89 e9                	mov    %ebp,%ecx
  801bed:	d3 ea                	shr    %cl,%edx
  801bef:	09 d0                	or     %edx,%eax
  801bf1:	89 e9                	mov    %ebp,%ecx
  801bf3:	d3 eb                	shr    %cl,%ebx
  801bf5:	89 da                	mov    %ebx,%edx
  801bf7:	83 c4 1c             	add    $0x1c,%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    
  801bff:	90                   	nop
  801c00:	89 fd                	mov    %edi,%ebp
  801c02:	85 ff                	test   %edi,%edi
  801c04:	75 0b                	jne    801c11 <__umoddi3+0xe9>
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f7                	div    %edi
  801c0f:	89 c5                	mov    %eax,%ebp
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f5                	div    %ebp
  801c17:	89 c8                	mov    %ecx,%eax
  801c19:	f7 f5                	div    %ebp
  801c1b:	89 d0                	mov    %edx,%eax
  801c1d:	e9 44 ff ff ff       	jmp    801b66 <__umoddi3+0x3e>
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	89 c8                	mov    %ecx,%eax
  801c26:	89 f2                	mov    %esi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	3b 04 24             	cmp    (%esp),%eax
  801c33:	72 06                	jb     801c3b <__umoddi3+0x113>
  801c35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c39:	77 0f                	ja     801c4a <__umoddi3+0x122>
  801c3b:	89 f2                	mov    %esi,%edx
  801c3d:	29 f9                	sub    %edi,%ecx
  801c3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c43:	89 14 24             	mov    %edx,(%esp)
  801c46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c4e:	8b 14 24             	mov    (%esp),%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d 76 00             	lea    0x0(%esi),%esi
  801c5c:	2b 04 24             	sub    (%esp),%eax
  801c5f:	19 fa                	sbb    %edi,%edx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	89 c6                	mov    %eax,%esi
  801c65:	e9 71 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c70:	72 ea                	jb     801c5c <__umoddi3+0x134>
  801c72:	89 d9                	mov    %ebx,%ecx
  801c74:	e9 62 ff ff ff       	jmp    801bdb <__umoddi3+0xb3>
