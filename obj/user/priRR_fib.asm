
obj/user/priRR_fib:     file format elf32-i386


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
  800031:	e8 aa 00 00 00       	call   8000e0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  800048:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 47 00 00 00       	call   8000a1 <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 80 1c 80 00       	push   $0x801c80
  80006e:	e8 72 05 00 00       	call   8005e5 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  800076:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  80007d:	74 1a                	je     800099 <_main+0x61>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 40 10             	mov    0x10(%eax),%eax
  800087:	50                   	push   %eax
  800088:	68 94 1c 80 00       	push   $0x801c94
  80008d:	6a 13                	push   $0x13
  80008f:	68 ad 1c 80 00       	push   $0x801cad
  800094:	e8 0c 02 00 00       	call   8002a5 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800099:	e8 e0 17 00 00       	call   80187e <inctst>

	return;
  80009e:	90                   	nop
}
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <fibonacci>:


int fibonacci(int n)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	53                   	push   %ebx
  8000a5:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <fibonacci+0x14>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 26                	jmp    8000db <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 df ff ff ff       	call   8000a1 <fibonacci>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ca:	83 e8 02             	sub    $0x2,%eax
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	e8 cb ff ff ff       	call   8000a1 <fibonacci>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	01 d8                	add    %ebx,%eax
}
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e9:	e8 52 16 00 00       	call   801740 <sys_getenvindex>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f4:	89 d0                	mov    %edx,%eax
  8000f6:	c1 e0 06             	shl    $0x6,%eax
  8000f9:	29 d0                	sub    %edx,%eax
  8000fb:	c1 e0 02             	shl    $0x2,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800107:	01 c8                	add    %ecx,%eax
  800109:	c1 e0 03             	shl    $0x3,%eax
  80010c:	01 d0                	add    %edx,%eax
  80010e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800115:	29 c2                	sub    %eax,%edx
  800117:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80011e:	89 c2                	mov    %eax,%edx
  800120:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800126:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012b:	a1 20 30 80 00       	mov    0x803020,%eax
  800130:	8a 40 20             	mov    0x20(%eax),%al
  800133:	84 c0                	test   %al,%al
  800135:	74 0d                	je     800144 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800137:	a1 20 30 80 00       	mov    0x803020,%eax
  80013c:	83 c0 20             	add    $0x20,%eax
  80013f:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800144:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800148:	7e 0a                	jle    800154 <libmain+0x74>
		binaryname = argv[0];
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 d6 fe ff ff       	call   800038 <_main>
  800162:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800165:	a1 00 30 80 00       	mov    0x803000,%eax
  80016a:	85 c0                	test   %eax,%eax
  80016c:	0f 84 01 01 00 00    	je     800273 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800172:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800178:	bb b8 1d 80 00       	mov    $0x801db8,%ebx
  80017d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800182:	89 c7                	mov    %eax,%edi
  800184:	89 de                	mov    %ebx,%esi
  800186:	89 d1                	mov    %edx,%ecx
  800188:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80018a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800192:	b0 00                	mov    $0x0,%al
  800194:	89 d7                	mov    %edx,%edi
  800196:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 c4 17 00 00       	call   801976 <sys_utilities>
  8001b2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b5:	e8 0d 13 00 00       	call   8014c7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 d8 1c 80 00       	push   $0x801cd8
  8001c2:	e8 ac 03 00 00       	call   800573 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	74 18                	je     8001e9 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001d1:	e8 be 17 00 00       	call   801994 <sys_get_optimal_num_faults>
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	50                   	push   %eax
  8001da:	68 00 1d 80 00       	push   $0x801d00
  8001df:	e8 8f 03 00 00       	call   800573 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	eb 59                	jmp    800242 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ee:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f9:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	52                   	push   %edx
  800203:	50                   	push   %eax
  800204:	68 24 1d 80 00       	push   $0x801d24
  800209:	e8 65 03 00 00       	call   800573 <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80021c:	a1 20 30 80 00       	mov    0x803020,%eax
  800221:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800232:	51                   	push   %ecx
  800233:	52                   	push   %edx
  800234:	50                   	push   %eax
  800235:	68 4c 1d 80 00       	push   $0x801d4c
  80023a:	e8 34 03 00 00       	call   800573 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800242:	a1 20 30 80 00       	mov    0x803020,%eax
  800247:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	50                   	push   %eax
  800251:	68 a4 1d 80 00       	push   $0x801da4
  800256:	e8 18 03 00 00       	call   800573 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	68 d8 1c 80 00       	push   $0x801cd8
  800266:	e8 08 03 00 00       	call   800573 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026e:	e8 6e 12 00 00       	call   8014e1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800273:	e8 1f 00 00 00       	call   800297 <exit>
}
  800278:	90                   	nop
  800279:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027c:	5b                   	pop    %ebx
  80027d:	5e                   	pop    %esi
  80027e:	5f                   	pop    %edi
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	6a 00                	push   $0x0
  80028c:	e8 7b 14 00 00       	call   80170c <sys_destroy_env>
  800291:	83 c4 10             	add    $0x10,%esp
}
  800294:	90                   	nop
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <exit>:

void
exit(void)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029d:	e8 d0 14 00 00       	call   801772 <sys_exit_env>
}
  8002a2:	90                   	nop
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ae:	83 c0 04             	add    $0x4,%eax
  8002b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b4:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	74 16                	je     8002d3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002bd:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 1c 1e 80 00       	push   $0x801e1c
  8002cb:	e8 a3 02 00 00       	call   800573 <cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	ff 75 0c             	pushl  0xc(%ebp)
  8002de:	ff 75 08             	pushl  0x8(%ebp)
  8002e1:	50                   	push   %eax
  8002e2:	68 24 1e 80 00       	push   $0x801e24
  8002e7:	6a 74                	push   $0x74
  8002e9:	e8 b2 02 00 00       	call   8005a0 <cprintf_colored>
  8002ee:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fa:	50                   	push   %eax
  8002fb:	e8 04 02 00 00       	call   800504 <vcprintf>
  800300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	6a 00                	push   $0x0
  800308:	68 4c 1e 80 00       	push   $0x801e4c
  80030d:	e8 f2 01 00 00       	call   800504 <vcprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800315:	e8 7d ff ff ff       	call   800297 <exit>

	// should not return here
	while (1) ;
  80031a:	eb fe                	jmp    80031a <_panic+0x75>

0080031c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800322:	a1 20 30 80 00       	mov    0x803020,%eax
  800327:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80032d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800330:	39 c2                	cmp    %eax,%edx
  800332:	74 14                	je     800348 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	68 50 1e 80 00       	push   $0x801e50
  80033c:	6a 26                	push   $0x26
  80033e:	68 9c 1e 80 00       	push   $0x801e9c
  800343:	e8 5d ff ff ff       	call   8002a5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80034f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800356:	e9 c5 00 00 00       	jmp    800420 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80035b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	75 08                	jne    800378 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800370:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800373:	e9 a5 00 00 00       	jmp    80041d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800378:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800386:	eb 69                	jmp    8003f1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800393:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800396:	89 d0                	mov    %edx,%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	01 d0                	add    %edx,%eax
  80039c:	c1 e0 03             	shl    $0x3,%eax
  80039f:	01 c8                	add    %ecx,%eax
  8003a1:	8a 40 04             	mov    0x4(%eax),%al
  8003a4:	84 c0                	test   %al,%al
  8003a6:	75 46                	jne    8003ee <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b6:	89 d0                	mov    %edx,%eax
  8003b8:	01 c0                	add    %eax,%eax
  8003ba:	01 d0                	add    %edx,%eax
  8003bc:	c1 e0 03             	shl    $0x3,%eax
  8003bf:	01 c8                	add    %ecx,%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ce:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	01 c8                	add    %ecx,%eax
  8003df:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e1:	39 c2                	cmp    %eax,%edx
  8003e3:	75 09                	jne    8003ee <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003e5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ec:	eb 15                	jmp    800403 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ee:	ff 45 e8             	incl   -0x18(%ebp)
  8003f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ff:	39 c2                	cmp    %eax,%edx
  800401:	77 85                	ja     800388 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800407:	75 14                	jne    80041d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	68 a8 1e 80 00       	push   $0x801ea8
  800411:	6a 3a                	push   $0x3a
  800413:	68 9c 1e 80 00       	push   $0x801e9c
  800418:	e8 88 fe ff ff       	call   8002a5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041d:	ff 45 f0             	incl   -0x10(%ebp)
  800420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800423:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800426:	0f 8c 2f ff ff ff    	jl     80035b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80042c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800433:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80043a:	eb 26                	jmp    800462 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	89 d0                	mov    %edx,%eax
  80044c:	01 c0                	add    %eax,%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	c1 e0 03             	shl    $0x3,%eax
  800453:	01 c8                	add    %ecx,%eax
  800455:	8a 40 04             	mov    0x4(%eax),%al
  800458:	3c 01                	cmp    $0x1,%al
  80045a:	75 03                	jne    80045f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80045c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045f:	ff 45 e0             	incl   -0x20(%ebp)
  800462:	a1 20 30 80 00       	mov    0x803020,%eax
  800467:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800470:	39 c2                	cmp    %eax,%edx
  800472:	77 c8                	ja     80043c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800477:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047a:	74 14                	je     800490 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 fc 1e 80 00       	push   $0x801efc
  800484:	6a 44                	push   $0x44
  800486:	68 9c 1e 80 00       	push   $0x801e9c
  80048b:	e8 15 fe ff ff       	call   8002a5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	53                   	push   %ebx
  800497:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	89 0a                	mov    %ecx,(%edx)
  8004a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004aa:	88 d1                	mov    %dl,%cl
  8004ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bd:	75 30                	jne    8004ef <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004bf:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004c5:	a0 44 30 80 00       	mov    0x803044,%al
  8004ca:	0f b6 c0             	movzbl %al,%eax
  8004cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d0:	8b 09                	mov    (%ecx),%ecx
  8004d2:	89 cb                	mov    %ecx,%ebx
  8004d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d7:	83 c1 08             	add    $0x8,%ecx
  8004da:	52                   	push   %edx
  8004db:	50                   	push   %eax
  8004dc:	53                   	push   %ebx
  8004dd:	51                   	push   %ecx
  8004de:	e8 a0 0f 00 00       	call   801483 <sys_cputs>
  8004e3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f2:	8b 40 04             	mov    0x4(%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fe:	90                   	nop
  8004ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800514:	00 00 00 
	b.cnt = 0;
  800517:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	ff 75 08             	pushl  0x8(%ebp)
  800527:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052d:	50                   	push   %eax
  80052e:	68 93 04 80 00       	push   $0x800493
  800533:	e8 5a 02 00 00       	call   800792 <vprintfmt>
  800538:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80053b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800541:	a0 44 30 80 00       	mov    0x803044,%al
  800546:	0f b6 c0             	movzbl %al,%eax
  800549:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80054f:	52                   	push   %edx
  800550:	50                   	push   %eax
  800551:	51                   	push   %ecx
  800552:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800558:	83 c0 08             	add    $0x8,%eax
  80055b:	50                   	push   %eax
  80055c:	e8 22 0f 00 00       	call   801483 <sys_cputs>
  800561:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800564:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80056b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800571:	c9                   	leave  
  800572:	c3                   	ret    

00800573 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800579:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800580:	8d 45 0c             	lea    0xc(%ebp),%eax
  800583:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 f4             	pushl  -0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	e8 6f ff ff ff       	call   800504 <vcprintf>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	c1 e0 08             	shl    $0x8,%eax
  8005b3:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ca:	50                   	push   %eax
  8005cb:	e8 34 ff ff ff       	call   800504 <vcprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005d6:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005dd:	07 00 00 

	return cnt;
  8005e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e3:	c9                   	leave  
  8005e4:	c3                   	ret    

008005e5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005e5:	55                   	push   %ebp
  8005e6:	89 e5                	mov    %esp,%ebp
  8005e8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005eb:	e8 d7 0e 00 00       	call   8014c7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 ff fe ff ff       	call   800504 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80060b:	e8 d1 0e 00 00       	call   8014e1 <sys_unlock_cons>
	return cnt;
  800610:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	53                   	push   %ebx
  800619:	83 ec 14             	sub    $0x14,%esp
  80061c:	8b 45 10             	mov    0x10(%ebp),%eax
  80061f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800628:	8b 45 18             	mov    0x18(%ebp),%eax
  80062b:	ba 00 00 00 00       	mov    $0x0,%edx
  800630:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800633:	77 55                	ja     80068a <printnum+0x75>
  800635:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800638:	72 05                	jb     80063f <printnum+0x2a>
  80063a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80063d:	77 4b                	ja     80068a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80063f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800642:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800645:	8b 45 18             	mov    0x18(%ebp),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	52                   	push   %edx
  80064e:	50                   	push   %eax
  80064f:	ff 75 f4             	pushl  -0xc(%ebp)
  800652:	ff 75 f0             	pushl  -0x10(%ebp)
  800655:	e8 aa 13 00 00       	call   801a04 <__udivdi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	ff 75 20             	pushl  0x20(%ebp)
  800663:	53                   	push   %ebx
  800664:	ff 75 18             	pushl  0x18(%ebp)
  800667:	52                   	push   %edx
  800668:	50                   	push   %eax
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	ff 75 08             	pushl  0x8(%ebp)
  80066f:	e8 a1 ff ff ff       	call   800615 <printnum>
  800674:	83 c4 20             	add    $0x20,%esp
  800677:	eb 1a                	jmp    800693 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	ff 75 20             	pushl  0x20(%ebp)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	ff d0                	call   *%eax
  800687:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068a:	ff 4d 1c             	decl   0x1c(%ebp)
  80068d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800691:	7f e6                	jg     800679 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800693:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800696:	bb 00 00 00 00       	mov    $0x0,%ebx
  80069b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a1:	53                   	push   %ebx
  8006a2:	51                   	push   %ecx
  8006a3:	52                   	push   %edx
  8006a4:	50                   	push   %eax
  8006a5:	e8 6a 14 00 00       	call   801b14 <__umoddi3>
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	05 74 21 80 00       	add    $0x802174,%eax
  8006b2:	8a 00                	mov    (%eax),%al
  8006b4:	0f be c0             	movsbl %al,%eax
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	50                   	push   %eax
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
}
  8006c6:	90                   	nop
  8006c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d3:	7e 1c                	jle    8006f1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	8d 50 08             	lea    0x8(%eax),%edx
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	89 10                	mov    %edx,(%eax)
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	83 e8 08             	sub    $0x8,%eax
  8006ea:	8b 50 04             	mov    0x4(%eax),%edx
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	eb 40                	jmp    800731 <getuint+0x65>
	else if (lflag)
  8006f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f5:	74 1e                	je     800715 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 04             	lea    0x4(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 04             	sub    $0x4,%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	ba 00 00 00 00       	mov    $0x0,%edx
  800713:	eb 1c                	jmp    800731 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800731:	5d                   	pop    %ebp
  800732:	c3                   	ret    

00800733 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800736:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073a:	7e 1c                	jle    800758 <getint+0x25>
		return va_arg(*ap, long long);
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	8d 50 08             	lea    0x8(%eax),%edx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	89 10                	mov    %edx,(%eax)
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	83 e8 08             	sub    $0x8,%eax
  800751:	8b 50 04             	mov    0x4(%eax),%edx
  800754:	8b 00                	mov    (%eax),%eax
  800756:	eb 38                	jmp    800790 <getint+0x5d>
	else if (lflag)
  800758:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075c:	74 1a                	je     800778 <getint+0x45>
		return va_arg(*ap, long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 04             	lea    0x4(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 04             	sub    $0x4,%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	99                   	cltd   
  800776:	eb 18                	jmp    800790 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 10                	mov    %edx,(%eax)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	83 e8 04             	sub    $0x4,%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	99                   	cltd   
}
  800790:	5d                   	pop    %ebp
  800791:	c3                   	ret    

00800792 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079a:	eb 17                	jmp    8007b3 <vprintfmt+0x21>
			if (ch == '\0')
  80079c:	85 db                	test   %ebx,%ebx
  80079e:	0f 84 c1 03 00 00    	je     800b65 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	53                   	push   %ebx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	83 fb 25             	cmp    $0x25,%ebx
  8007c4:	75 d6                	jne    80079c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e9:	8d 50 01             	lea    0x1(%eax),%edx
  8007ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ef:	8a 00                	mov    (%eax),%al
  8007f1:	0f b6 d8             	movzbl %al,%ebx
  8007f4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f7:	83 f8 5b             	cmp    $0x5b,%eax
  8007fa:	0f 87 3d 03 00 00    	ja     800b3d <vprintfmt+0x3ab>
  800800:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800807:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800809:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80080d:	eb d7                	jmp    8007e6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800813:	eb d1                	jmp    8007e6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800815:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80081c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80081f:	89 d0                	mov    %edx,%eax
  800821:	c1 e0 02             	shl    $0x2,%eax
  800824:	01 d0                	add    %edx,%eax
  800826:	01 c0                	add    %eax,%eax
  800828:	01 d8                	add    %ebx,%eax
  80082a:	83 e8 30             	sub    $0x30,%eax
  80082d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800830:	8b 45 10             	mov    0x10(%ebp),%eax
  800833:	8a 00                	mov    (%eax),%al
  800835:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800838:	83 fb 2f             	cmp    $0x2f,%ebx
  80083b:	7e 3e                	jle    80087b <vprintfmt+0xe9>
  80083d:	83 fb 39             	cmp    $0x39,%ebx
  800840:	7f 39                	jg     80087b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800842:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800845:	eb d5                	jmp    80081c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80085b:	eb 1f                	jmp    80087c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80085d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800861:	79 83                	jns    8007e6 <vprintfmt+0x54>
				width = 0;
  800863:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80086a:	e9 77 ff ff ff       	jmp    8007e6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80086f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800876:	e9 6b ff ff ff       	jmp    8007e6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80087b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80087c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800880:	0f 89 60 ff ff ff    	jns    8007e6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800893:	e9 4e ff ff ff       	jmp    8007e6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800898:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80089b:	e9 46 ff ff ff       	jmp    8007e6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 c0 04             	add    $0x4,%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	50                   	push   %eax
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
			break;
  8008c0:	e9 9b 02 00 00       	jmp    800b60 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 c0 04             	add    $0x4,%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 e8 04             	sub    $0x4,%eax
  8008d4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d6:	85 db                	test   %ebx,%ebx
  8008d8:	79 02                	jns    8008dc <vprintfmt+0x14a>
				err = -err;
  8008da:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008dc:	83 fb 64             	cmp    $0x64,%ebx
  8008df:	7f 0b                	jg     8008ec <vprintfmt+0x15a>
  8008e1:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 19                	jne    800905 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008ec:	53                   	push   %ebx
  8008ed:	68 85 21 80 00       	push   $0x802185
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	ff 75 08             	pushl  0x8(%ebp)
  8008f8:	e8 70 02 00 00       	call   800b6d <printfmt>
  8008fd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800900:	e9 5b 02 00 00       	jmp    800b60 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800905:	56                   	push   %esi
  800906:	68 8e 21 80 00       	push   $0x80218e
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 57 02 00 00       	call   800b6d <printfmt>
  800916:	83 c4 10             	add    $0x10,%esp
			break;
  800919:	e9 42 02 00 00       	jmp    800b60 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	83 c0 04             	add    $0x4,%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	83 e8 04             	sub    $0x4,%eax
  80092d:	8b 30                	mov    (%eax),%esi
  80092f:	85 f6                	test   %esi,%esi
  800931:	75 05                	jne    800938 <vprintfmt+0x1a6>
				p = "(null)";
  800933:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800938:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093c:	7e 6d                	jle    8009ab <vprintfmt+0x219>
  80093e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800942:	74 67                	je     8009ab <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	50                   	push   %eax
  80094b:	56                   	push   %esi
  80094c:	e8 1e 03 00 00       	call   800c6f <strnlen>
  800951:	83 c4 10             	add    $0x10,%esp
  800954:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800957:	eb 16                	jmp    80096f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800959:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	50                   	push   %eax
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80096c:	ff 4d e4             	decl   -0x1c(%ebp)
  80096f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800973:	7f e4                	jg     800959 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	eb 34                	jmp    8009ab <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800977:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80097b:	74 1c                	je     800999 <vprintfmt+0x207>
  80097d:	83 fb 1f             	cmp    $0x1f,%ebx
  800980:	7e 05                	jle    800987 <vprintfmt+0x1f5>
  800982:	83 fb 7e             	cmp    $0x7e,%ebx
  800985:	7e 12                	jle    800999 <vprintfmt+0x207>
					putch('?', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	6a 3f                	push   $0x3f
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	eb 0f                	jmp    8009a8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ab:	89 f0                	mov    %esi,%eax
  8009ad:	8d 70 01             	lea    0x1(%eax),%esi
  8009b0:	8a 00                	mov    (%eax),%al
  8009b2:	0f be d8             	movsbl %al,%ebx
  8009b5:	85 db                	test   %ebx,%ebx
  8009b7:	74 24                	je     8009dd <vprintfmt+0x24b>
  8009b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009bd:	78 b8                	js     800977 <vprintfmt+0x1e5>
  8009bf:	ff 4d e0             	decl   -0x20(%ebp)
  8009c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c6:	79 af                	jns    800977 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c8:	eb 13                	jmp    8009dd <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 20                	push   $0x20
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009da:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e1:	7f e7                	jg     8009ca <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009e3:	e9 78 01 00 00       	jmp    800b60 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f1:	50                   	push   %eax
  8009f2:	e8 3c fd ff ff       	call   800733 <getint>
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a06:	85 d2                	test   %edx,%edx
  800a08:	79 23                	jns    800a2d <vprintfmt+0x29b>
				putch('-', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 2d                	push   $0x2d
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a20:	f7 d8                	neg    %eax
  800a22:	83 d2 00             	adc    $0x0,%edx
  800a25:	f7 da                	neg    %edx
  800a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a2d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a34:	e9 bc 00 00 00       	jmp    800af5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a42:	50                   	push   %eax
  800a43:	e8 84 fc ff ff       	call   8006cc <getuint>
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a51:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a58:	e9 98 00 00 00       	jmp    800af5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	6a 58                	push   $0x58
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	ff d0                	call   *%eax
  800a6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 58                	push   $0x58
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 58                	push   $0x58
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			break;
  800a8d:	e9 ce 00 00 00       	jmp    800b60 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	6a 30                	push   $0x30
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 0c             	pushl  0xc(%ebp)
  800aa8:	6a 78                	push   $0x78
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	ff d0                	call   *%eax
  800aaf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 c0 04             	add    $0x4,%eax
  800ab8:	89 45 14             	mov    %eax,0x14(%ebp)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	83 e8 04             	sub    $0x4,%eax
  800ac1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800acd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad4:	eb 1f                	jmp    800af5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 e8             	pushl  -0x18(%ebp)
  800adc:	8d 45 14             	lea    0x14(%ebp),%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 e7 fb ff ff       	call   8006cc <getuint>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	52                   	push   %edx
  800b00:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b03:	50                   	push   %eax
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	ff 75 08             	pushl  0x8(%ebp)
  800b10:	e8 00 fb ff ff       	call   800615 <printnum>
  800b15:	83 c4 20             	add    $0x20,%esp
			break;
  800b18:	eb 46                	jmp    800b60 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	53                   	push   %ebx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
			break;
  800b29:	eb 35                	jmp    800b60 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b2b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b32:	eb 2c                	jmp    800b60 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b34:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b3b:	eb 23                	jmp    800b60 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	6a 25                	push   $0x25
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	ff d0                	call   *%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4d:	ff 4d 10             	decl   0x10(%ebp)
  800b50:	eb 03                	jmp    800b55 <vprintfmt+0x3c3>
  800b52:	ff 4d 10             	decl   0x10(%ebp)
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	48                   	dec    %eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	3c 25                	cmp    $0x25,%al
  800b5d:	75 f3                	jne    800b52 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b5f:	90                   	nop
		}
	}
  800b60:	e9 35 fc ff ff       	jmp    80079a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b65:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b69:	5b                   	pop    %ebx
  800b6a:	5e                   	pop    %esi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b73:	8d 45 10             	lea    0x10(%ebp),%eax
  800b76:	83 c0 04             	add    $0x4,%eax
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b82:	50                   	push   %eax
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 04 fc ff ff       	call   800792 <vprintfmt>
  800b8e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b91:	90                   	nop
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	8b 40 08             	mov    0x8(%eax),%eax
  800b9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	8b 10                	mov    (%eax),%edx
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	8b 40 04             	mov    0x4(%eax),%eax
  800bb1:	39 c2                	cmp    %eax,%edx
  800bb3:	73 12                	jae    800bc7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	89 0a                	mov    %ecx,(%edx)
  800bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc5:	88 10                	mov    %dl,(%eax)
}
  800bc7:	90                   	nop
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	01 d0                	add    %edx,%eax
  800be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800beb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bef:	74 06                	je     800bf7 <vsnprintf+0x2d>
  800bf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf5:	7f 07                	jg     800bfe <vsnprintf+0x34>
		return -E_INVAL;
  800bf7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfc:	eb 20                	jmp    800c1e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfe:	ff 75 14             	pushl  0x14(%ebp)
  800c01:	ff 75 10             	pushl  0x10(%ebp)
  800c04:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c07:	50                   	push   %eax
  800c08:	68 94 0b 80 00       	push   $0x800b94
  800c0d:	e8 80 fb ff ff       	call   800792 <vprintfmt>
  800c12:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c18:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c26:	8d 45 10             	lea    0x10(%ebp),%eax
  800c29:	83 c0 04             	add    $0x4,%eax
  800c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	ff 75 f4             	pushl  -0xc(%ebp)
  800c35:	50                   	push   %eax
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	e8 89 ff ff ff       	call   800bca <vsnprintf>
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c59:	eb 06                	jmp    800c61 <strlen+0x15>
		n++;
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5e:	ff 45 08             	incl   0x8(%ebp)
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	84 c0                	test   %al,%al
  800c68:	75 f1                	jne    800c5b <strlen+0xf>
		n++;
	return n;
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 09                	jmp    800c87 <strnlen+0x18>
		n++;
  800c7e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c81:	ff 45 08             	incl   0x8(%ebp)
  800c84:	ff 4d 0c             	decl   0xc(%ebp)
  800c87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8b:	74 09                	je     800c96 <strnlen+0x27>
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 e8                	jne    800c7e <strnlen+0xf>
		n++;
	return n;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca7:	90                   	nop
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8d 50 01             	lea    0x1(%eax),%edx
  800cae:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cba:	8a 12                	mov    (%edx),%dl
  800cbc:	88 10                	mov    %dl,(%eax)
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 e4                	jne    800ca8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdc:	eb 1f                	jmp    800cfd <strncpy+0x34>
		*dst++ = *src;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	8a 12                	mov    (%edx),%dl
  800cec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 03                	je     800cfa <strncpy+0x31>
			src++;
  800cf7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfa:	ff 45 fc             	incl   -0x4(%ebp)
  800cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d00:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d03:	72 d9                	jb     800cde <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	74 30                	je     800d4c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1c:	eb 16                	jmp    800d34 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8d 50 01             	lea    0x1(%eax),%edx
  800d24:	89 55 08             	mov    %edx,0x8(%ebp)
  800d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d30:	8a 12                	mov    (%edx),%dl
  800d32:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d34:	ff 4d 10             	decl   0x10(%ebp)
  800d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3b:	74 09                	je     800d46 <strlcpy+0x3c>
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	75 d8                	jne    800d1e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	c9                   	leave  
  800d57:	c3                   	ret    

00800d58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5b:	eb 06                	jmp    800d63 <strcmp+0xb>
		p++, q++;
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 0e                	je     800d7a <strcmp+0x22>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 10                	mov    (%eax),%dl
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	38 c2                	cmp    %al,%dl
  800d78:	74 e3                	je     800d5d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	0f b6 d0             	movzbl %al,%edx
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 c0             	movzbl %al,%eax
  800d8a:	29 c2                	sub    %eax,%edx
  800d8c:	89 d0                	mov    %edx,%eax
}
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d93:	eb 09                	jmp    800d9e <strncmp+0xe>
		n--, p++, q++;
  800d95:	ff 4d 10             	decl   0x10(%ebp)
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da2:	74 17                	je     800dbb <strncmp+0x2b>
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	84 c0                	test   %al,%al
  800dab:	74 0e                	je     800dbb <strncmp+0x2b>
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 10                	mov    (%eax),%dl
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	38 c2                	cmp    %al,%dl
  800db9:	74 da                	je     800d95 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	75 07                	jne    800dc8 <strncmp+0x38>
		return 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	eb 14                	jmp    800ddc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	0f b6 d0             	movzbl %al,%edx
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	0f b6 c0             	movzbl %al,%eax
  800dd8:	29 c2                	sub    %eax,%edx
  800dda:	89 d0                	mov    %edx,%eax
}
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 04             	sub    $0x4,%esp
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dea:	eb 12                	jmp    800dfe <strchr+0x20>
		if (*s == c)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df4:	75 05                	jne    800dfb <strchr+0x1d>
			return (char *) s;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	eb 11                	jmp    800e0c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	84 c0                	test   %al,%al
  800e05:	75 e5                	jne    800dec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 04             	sub    $0x4,%esp
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1a:	eb 0d                	jmp    800e29 <strfind+0x1b>
		if (*s == c)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e24:	74 0e                	je     800e34 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	84 c0                	test   %al,%al
  800e30:	75 ea                	jne    800e1c <strfind+0xe>
  800e32:	eb 01                	jmp    800e35 <strfind+0x27>
		if (*s == c)
			break;
  800e34:	90                   	nop
	return (char *) s;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e46:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e4a:	76 63                	jbe    800eaf <memset+0x75>
		uint64 data_block = c;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	99                   	cltd   
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e60:	c1 e0 08             	shl    $0x8,%eax
  800e63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e66:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e73:	c1 e0 10             	shl    $0x10,%eax
  800e76:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e79:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e8f:	eb 18                	jmp    800ea9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e94:	8d 41 08             	lea    0x8(%ecx),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	89 01                	mov    %eax,(%ecx)
  800ea2:	89 51 04             	mov    %edx,0x4(%ecx)
  800ea5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ea9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ead:	77 e2                	ja     800e91 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	74 23                	je     800ed8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ebb:	eb 0e                	jmp    800ecb <memset+0x91>
			*p8++ = (uint8)c;
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec0:	8d 50 01             	lea    0x1(%eax),%edx
  800ec3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 e5                	jne    800ebd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef3:	76 24                	jbe    800f19 <memcpy+0x3c>
		while(n >= 8){
  800ef5:	eb 1c                	jmp    800f13 <memcpy+0x36>
			*d64 = *s64;
  800ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efa:	8b 50 04             	mov    0x4(%eax),%edx
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f02:	89 01                	mov    %eax,(%ecx)
  800f04:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f07:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f0b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f0f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f13:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f17:	77 de                	ja     800ef7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 31                	je     800f50 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f2b:	eb 16                	jmp    800f43 <memcpy+0x66>
			*d8++ = *s8++;
  800f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f3c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f3f:	8a 12                	mov    (%edx),%dl
  800f41:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 dd                	jne    800f2d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6d:	73 50                	jae    800fbf <memmove+0x6a>
  800f6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	01 d0                	add    %edx,%eax
  800f77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7a:	76 43                	jbe    800fbf <memmove+0x6a>
		s += n;
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f88:	eb 10                	jmp    800f9a <memmove+0x45>
			*--d = *--s;
  800f8a:	ff 4d f8             	decl   -0x8(%ebp)
  800f8d:	ff 4d fc             	decl   -0x4(%ebp)
  800f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f93:	8a 10                	mov    (%eax),%dl
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	75 e3                	jne    800f8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa7:	eb 23                	jmp    800fcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fac:	8d 50 01             	lea    0x1(%eax),%edx
  800faf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fbb:	8a 12                	mov    (%edx),%dl
  800fbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 dd                	jne    800fa9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fe3:	eb 2a                	jmp    80100f <memcmp+0x3e>
		if (*s1 != *s2)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	8a 10                	mov    (%eax),%dl
  800fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	38 c2                	cmp    %al,%dl
  800ff1:	74 16                	je     801009 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 d0             	movzbl %al,%edx
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 c0             	movzbl %al,%eax
  801003:	29 c2                	sub    %eax,%edx
  801005:	89 d0                	mov    %edx,%eax
  801007:	eb 18                	jmp    801021 <memcmp+0x50>
		s1++, s2++;
  801009:	ff 45 fc             	incl   -0x4(%ebp)
  80100c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	8d 50 ff             	lea    -0x1(%eax),%edx
  801015:	89 55 10             	mov    %edx,0x10(%ebp)
  801018:	85 c0                	test   %eax,%eax
  80101a:	75 c9                	jne    800fe5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80101c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801021:	c9                   	leave  
  801022:	c3                   	ret    

00801023 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	01 d0                	add    %edx,%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801034:	eb 15                	jmp    80104b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	0f b6 c0             	movzbl %al,%eax
  801044:	39 c2                	cmp    %eax,%edx
  801046:	74 0d                	je     801055 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801051:	72 e3                	jb     801036 <memfind+0x13>
  801053:	eb 01                	jmp    801056 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801055:	90                   	nop
	return (void *) s;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106f:	eb 03                	jmp    801074 <strtol+0x19>
		s++;
  801071:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 20                	cmp    $0x20,%al
  80107b:	74 f4                	je     801071 <strtol+0x16>
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 09                	cmp    $0x9,%al
  801084:	74 eb                	je     801071 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 2b                	cmp    $0x2b,%al
  80108d:	75 05                	jne    801094 <strtol+0x39>
		s++;
  80108f:	ff 45 08             	incl   0x8(%ebp)
  801092:	eb 13                	jmp    8010a7 <strtol+0x4c>
	else if (*s == '-')
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 2d                	cmp    $0x2d,%al
  80109b:	75 0a                	jne    8010a7 <strtol+0x4c>
		s++, neg = 1;
  80109d:	ff 45 08             	incl   0x8(%ebp)
  8010a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	74 06                	je     8010b3 <strtol+0x58>
  8010ad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b1:	75 20                	jne    8010d3 <strtol+0x78>
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 30                	cmp    $0x30,%al
  8010ba:	75 17                	jne    8010d3 <strtol+0x78>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	40                   	inc    %eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 78                	cmp    $0x78,%al
  8010c4:	75 0d                	jne    8010d3 <strtol+0x78>
		s += 2, base = 16;
  8010c6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d1:	eb 28                	jmp    8010fb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 15                	jne    8010ee <strtol+0x93>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 30                	cmp    $0x30,%al
  8010e0:	75 0c                	jne    8010ee <strtol+0x93>
		s++, base = 8;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010ec:	eb 0d                	jmp    8010fb <strtol+0xa0>
	else if (base == 0)
  8010ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f2:	75 07                	jne    8010fb <strtol+0xa0>
		base = 10;
  8010f4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 2f                	cmp    $0x2f,%al
  801102:	7e 19                	jle    80111d <strtol+0xc2>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 39                	cmp    $0x39,%al
  80110b:	7f 10                	jg     80111d <strtol+0xc2>
			dig = *s - '0';
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f be c0             	movsbl %al,%eax
  801115:	83 e8 30             	sub    $0x30,%eax
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80111b:	eb 42                	jmp    80115f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 60                	cmp    $0x60,%al
  801124:	7e 19                	jle    80113f <strtol+0xe4>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 7a                	cmp    $0x7a,%al
  80112d:	7f 10                	jg     80113f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f be c0             	movsbl %al,%eax
  801137:	83 e8 57             	sub    $0x57,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113d:	eb 20                	jmp    80115f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 40                	cmp    $0x40,%al
  801146:	7e 39                	jle    801181 <strtol+0x126>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 5a                	cmp    $0x5a,%al
  80114f:	7f 30                	jg     801181 <strtol+0x126>
			dig = *s - 'A' + 10;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	83 e8 37             	sub    $0x37,%eax
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 10             	cmp    0x10(%ebp),%eax
  801165:	7d 19                	jge    801180 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801167:	ff 45 08             	incl   0x8(%ebp)
  80116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801171:	89 c2                	mov    %eax,%edx
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80117b:	e9 7b ff ff ff       	jmp    8010fb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801180:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801185:	74 08                	je     80118f <strtol+0x134>
		*endptr = (char *) s;
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	8b 55 08             	mov    0x8(%ebp),%edx
  80118d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80118f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801193:	74 07                	je     80119c <strtol+0x141>
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	f7 d8                	neg    %eax
  80119a:	eb 03                	jmp    80119f <strtol+0x144>
  80119c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b9:	79 13                	jns    8011ce <ltostr+0x2d>
	{
		neg = 1;
  8011bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011cb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d6:	99                   	cltd   
  8011d7:	f7 f9                	idiv   %ecx
  8011d9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	01 d0                	add    %edx,%eax
  8011ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ef:	83 c2 30             	add    $0x30,%edx
  8011f2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011fc:	f7 e9                	imul   %ecx
  8011fe:	c1 fa 02             	sar    $0x2,%edx
  801201:	89 c8                	mov    %ecx,%eax
  801203:	c1 f8 1f             	sar    $0x1f,%eax
  801206:	29 c2                	sub    %eax,%edx
  801208:	89 d0                	mov    %edx,%eax
  80120a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80120d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801211:	75 bb                	jne    8011ce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	48                   	dec    %eax
  80121e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801221:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801225:	74 3d                	je     801264 <ltostr+0xc3>
		start = 1 ;
  801227:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122e:	eb 34                	jmp    801264 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80123d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	01 c2                	add    %eax,%edx
  801245:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c8                	add    %ecx,%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 c2                	add    %eax,%edx
  801259:	8a 45 eb             	mov    -0x15(%ebp),%al
  80125c:	88 02                	mov    %al,(%edx)
		start++ ;
  80125e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801261:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801267:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126a:	7c c4                	jl     801230 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80126c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801277:	90                   	nop
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801280:	ff 75 08             	pushl  0x8(%ebp)
  801283:	e8 c4 f9 ff ff       	call   800c4c <strlen>
  801288:	83 c4 04             	add    $0x4,%esp
  80128b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	e8 b6 f9 ff ff       	call   800c4c <strlen>
  801296:	83 c4 04             	add    $0x4,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80129c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012aa:	eb 17                	jmp    8012c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 c2                	add    %eax,%edx
  8012b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	01 c8                	add    %ecx,%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c0:	ff 45 fc             	incl   -0x4(%ebp)
  8012c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c9:	7c e1                	jl     8012ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d9:	eb 1f                	jmp    8012fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012de:	8d 50 01             	lea    0x1(%eax),%edx
  8012e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e9:	01 c2                	add    %eax,%edx
  8012eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f1:	01 c8                	add    %ecx,%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f7:	ff 45 f8             	incl   -0x8(%ebp)
  8012fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801300:	7c d9                	jl     8012db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	c6 00 00             	movb   $0x0,(%eax)
}
  80130d:	90                   	nop
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801333:	eb 0c                	jmp    801341 <strsplit+0x31>
			*string++ = 0;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8d 50 01             	lea    0x1(%eax),%edx
  80133b:	89 55 08             	mov    %edx,0x8(%ebp)
  80133e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	84 c0                	test   %al,%al
  801348:	74 18                	je     801362 <strsplit+0x52>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	0f be c0             	movsbl %al,%eax
  801352:	50                   	push   %eax
  801353:	ff 75 0c             	pushl  0xc(%ebp)
  801356:	e8 83 fa ff ff       	call   800dde <strchr>
  80135b:	83 c4 08             	add    $0x8,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	75 d3                	jne    801335 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	84 c0                	test   %al,%al
  801369:	74 5a                	je     8013c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	8b 00                	mov    (%eax),%eax
  801370:	83 f8 0f             	cmp    $0xf,%eax
  801373:	75 07                	jne    80137c <strsplit+0x6c>
		{
			return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	eb 66                	jmp    8013e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80137c:	8b 45 14             	mov    0x14(%ebp),%eax
  80137f:	8b 00                	mov    (%eax),%eax
  801381:	8d 48 01             	lea    0x1(%eax),%ecx
  801384:	8b 55 14             	mov    0x14(%ebp),%edx
  801387:	89 0a                	mov    %ecx,(%edx)
  801389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801390:	8b 45 10             	mov    0x10(%ebp),%eax
  801393:	01 c2                	add    %eax,%edx
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139a:	eb 03                	jmp    80139f <strsplit+0x8f>
			string++;
  80139c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	84 c0                	test   %al,%al
  8013a6:	74 8b                	je     801333 <strsplit+0x23>
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	0f be c0             	movsbl %al,%eax
  8013b0:	50                   	push   %eax
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	e8 25 fa ff ff       	call   800dde <strchr>
  8013b9:	83 c4 08             	add    $0x8,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	74 dc                	je     80139c <strsplit+0x8c>
			string++;
	}
  8013c0:	e9 6e ff ff ff       	jmp    801333 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f7:	eb 4a                	jmp    801443 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	01 c2                	add    %eax,%edx
  801401:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 c8                	add    %ecx,%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80140d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3c 40                	cmp    $0x40,%al
  801419:	7e 25                	jle    801440 <str2lower+0x5c>
  80141b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 5a                	cmp    $0x5a,%al
  801427:	7f 17                	jg     801440 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801429:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801434:	8b 55 08             	mov    0x8(%ebp),%edx
  801437:	01 ca                	add    %ecx,%edx
  801439:	8a 12                	mov    (%edx),%dl
  80143b:	83 c2 20             	add    $0x20,%edx
  80143e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801440:	ff 45 fc             	incl   -0x4(%ebp)
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	e8 01 f8 ff ff       	call   800c4c <strlen>
  80144b:	83 c4 04             	add    $0x4,%esp
  80144e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801451:	7f a6                	jg     8013f9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801453:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80146d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801470:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801473:	cd 30                	int    $0x30
  801475:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5f                   	pop    %edi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80148f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801492:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	6a 00                	push   $0x0
  80149b:	51                   	push   %ecx
  80149c:	52                   	push   %edx
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	50                   	push   %eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	e8 b0 ff ff ff       	call   801458 <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 02                	push   $0x2
  8014bd:	e8 96 ff ff ff       	call   801458 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 03                	push   $0x3
  8014d6:	e8 7d ff ff ff       	call   801458 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	90                   	nop
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 04                	push   $0x4
  8014f0:	e8 63 ff ff ff       	call   801458 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
}
  8014f8:	90                   	nop
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	52                   	push   %edx
  80150b:	50                   	push   %eax
  80150c:	6a 08                	push   $0x8
  80150e:	e8 45 ff ff ff       	call   801458 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80151d:	8b 75 18             	mov    0x18(%ebp),%esi
  801520:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801523:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	51                   	push   %ecx
  80152f:	52                   	push   %edx
  801530:	50                   	push   %eax
  801531:	6a 09                	push   $0x9
  801533:	e8 20 ff ff ff       	call   801458 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153e:	5b                   	pop    %ebx
  80153f:	5e                   	pop    %esi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    

00801542 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	ff 75 08             	pushl  0x8(%ebp)
  801550:	6a 0a                	push   $0xa
  801552:	e8 01 ff ff ff       	call   801458 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	ff 75 08             	pushl  0x8(%ebp)
  80156b:	6a 0b                	push   $0xb
  80156d:	e8 e6 fe ff ff       	call   801458 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 0c                	push   $0xc
  801586:	e8 cd fe ff ff       	call   801458 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 0d                	push   $0xd
  80159f:	e8 b4 fe ff ff       	call   801458 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 0e                	push   $0xe
  8015b8:	e8 9b fe ff ff       	call   801458 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 0f                	push   $0xf
  8015d1:	e8 82 fe ff ff       	call   801458 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	6a 10                	push   $0x10
  8015eb:	e8 68 fe ff ff       	call   801458 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 11                	push   $0x11
  801604:	e8 4f fe ff ff       	call   801458 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	90                   	nop
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_cputc>:

void
sys_cputc(const char c)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80161b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	50                   	push   %eax
  801628:	6a 01                	push   $0x1
  80162a:	e8 29 fe ff ff       	call   801458 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	90                   	nop
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 14                	push   $0x14
  801644:	e8 0f fe ff ff       	call   801458 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	90                   	nop
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80165b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	6a 00                	push   $0x0
  801667:	51                   	push   %ecx
  801668:	52                   	push   %edx
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	50                   	push   %eax
  80166d:	6a 15                	push   $0x15
  80166f:	e8 e4 fd ff ff       	call   801458 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80167c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 16                	push   $0x16
  80168c:	e8 c7 fd ff ff       	call   801458 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801699:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	51                   	push   %ecx
  8016a7:	52                   	push   %edx
  8016a8:	50                   	push   %eax
  8016a9:	6a 17                	push   $0x17
  8016ab:	e8 a8 fd ff ff       	call   801458 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 18                	push   $0x18
  8016c8:	e8 8b fd ff ff       	call   801458 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 14             	pushl  0x14(%ebp)
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	50                   	push   %eax
  8016e4:	6a 19                	push   $0x19
  8016e6:	e8 6d fd ff ff       	call   801458 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	50                   	push   %eax
  8016ff:	6a 1a                	push   $0x1a
  801701:	e8 52 fd ff ff       	call   801458 <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	90                   	nop
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	50                   	push   %eax
  80171b:	6a 1b                	push   $0x1b
  80171d:	e8 36 fd ff ff       	call   801458 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 05                	push   $0x5
  801736:	e8 1d fd ff ff       	call   801458 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 06                	push   $0x6
  80174f:	e8 04 fd ff ff       	call   801458 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 07                	push   $0x7
  801768:	e8 eb fc ff ff       	call   801458 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_exit_env>:


void sys_exit_env(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 1c                	push   $0x1c
  801781:	e8 d2 fc ff ff       	call   801458 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801792:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801795:	8d 50 04             	lea    0x4(%eax),%edx
  801798:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 1d                	push   $0x1d
  8017a5:	e8 ae fc ff ff       	call   801458 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b6:	89 01                	mov    %eax,(%ecx)
  8017b8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	c9                   	leave  
  8017bf:	c2 04 00             	ret    $0x4

008017c2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	ff 75 10             	pushl  0x10(%ebp)
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	6a 13                	push   $0x13
  8017d4:	e8 7f fc ff ff       	call   801458 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dc:	90                   	nop
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_rcr2>:
uint32 sys_rcr2()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 1e                	push   $0x1e
  8017ee:	e8 65 fc ff ff       	call   801458 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801804:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	50                   	push   %eax
  801811:	6a 1f                	push   $0x1f
  801813:	e8 40 fc ff ff       	call   801458 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return ;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <rsttst>:
void rsttst()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 21                	push   $0x21
  80182d:	e8 26 fc ff ff       	call   801458 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
	return ;
  801835:	90                   	nop
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	8b 45 14             	mov    0x14(%ebp),%eax
  801841:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801844:	8b 55 18             	mov    0x18(%ebp),%edx
  801847:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	ff 75 10             	pushl  0x10(%ebp)
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	6a 20                	push   $0x20
  801858:	e8 fb fb ff ff       	call   801458 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return ;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <chktst>:
void chktst(uint32 n)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	6a 22                	push   $0x22
  801873:	e8 e0 fb ff ff       	call   801458 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
	return ;
  80187b:	90                   	nop
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <inctst>:

void inctst()
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 23                	push   $0x23
  80188d:	e8 c6 fb ff ff       	call   801458 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
	return ;
  801895:	90                   	nop
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <gettst>:
uint32 gettst()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 24                	push   $0x24
  8018a7:	e8 ac fb ff ff       	call   801458 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 25                	push   $0x25
  8018c0:	e8 93 fb ff ff       	call   801458 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
  8018c8:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018cd:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 26                	push   $0x26
  8018ec:	e8 67 fb ff ff       	call   801458 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	53                   	push   %ebx
  80190a:	51                   	push   %ecx
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 27                	push   $0x27
  80190f:	e8 44 fb ff ff       	call   801458 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 28                	push   $0x28
  80192f:	e8 24 fb ff ff       	call   801458 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80193c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	51                   	push   %ecx
  801948:	ff 75 10             	pushl  0x10(%ebp)
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	6a 29                	push   $0x29
  80194f:	e8 04 fb ff ff       	call   801458 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 10             	pushl  0x10(%ebp)
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 12                	push   $0x12
  80196b:	e8 e8 fa ff ff       	call   801458 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return ;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 2a                	push   $0x2a
  801989:	e8 ca fa ff ff       	call   801458 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 2b                	push   $0x2b
  8019a3:	e8 b0 fa ff ff       	call   801458 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 2d                	push   $0x2d
  8019be:	e8 95 fa ff ff       	call   801458 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 2c                	push   $0x2c
  8019da:	e8 79 fa ff ff       	call   801458 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 08 23 80 00       	push   $0x802308
  8019f3:	68 25 01 00 00       	push   $0x125
  8019f8:	68 3b 23 80 00       	push   $0x80233b
  8019fd:	e8 a3 e8 ff ff       	call   8002a5 <_panic>
  801a02:	66 90                	xchg   %ax,%ax

00801a04 <__udivdi3>:
  801a04:	55                   	push   %ebp
  801a05:	57                   	push   %edi
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 1c             	sub    $0x1c,%esp
  801a0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1b:	89 ca                	mov    %ecx,%edx
  801a1d:	89 f8                	mov    %edi,%eax
  801a1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a23:	85 f6                	test   %esi,%esi
  801a25:	75 2d                	jne    801a54 <__udivdi3+0x50>
  801a27:	39 cf                	cmp    %ecx,%edi
  801a29:	77 65                	ja     801a90 <__udivdi3+0x8c>
  801a2b:	89 fd                	mov    %edi,%ebp
  801a2d:	85 ff                	test   %edi,%edi
  801a2f:	75 0b                	jne    801a3c <__udivdi3+0x38>
  801a31:	b8 01 00 00 00       	mov    $0x1,%eax
  801a36:	31 d2                	xor    %edx,%edx
  801a38:	f7 f7                	div    %edi
  801a3a:	89 c5                	mov    %eax,%ebp
  801a3c:	31 d2                	xor    %edx,%edx
  801a3e:	89 c8                	mov    %ecx,%eax
  801a40:	f7 f5                	div    %ebp
  801a42:	89 c1                	mov    %eax,%ecx
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	f7 f5                	div    %ebp
  801a48:	89 cf                	mov    %ecx,%edi
  801a4a:	89 fa                	mov    %edi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	39 ce                	cmp    %ecx,%esi
  801a56:	77 28                	ja     801a80 <__udivdi3+0x7c>
  801a58:	0f bd fe             	bsr    %esi,%edi
  801a5b:	83 f7 1f             	xor    $0x1f,%edi
  801a5e:	75 40                	jne    801aa0 <__udivdi3+0x9c>
  801a60:	39 ce                	cmp    %ecx,%esi
  801a62:	72 0a                	jb     801a6e <__udivdi3+0x6a>
  801a64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a68:	0f 87 9e 00 00 00    	ja     801b0c <__udivdi3+0x108>
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	89 fa                	mov    %edi,%edx
  801a75:	83 c4 1c             	add    $0x1c,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5e                   	pop    %esi
  801a7a:	5f                   	pop    %edi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    
  801a7d:	8d 76 00             	lea    0x0(%esi),%esi
  801a80:	31 ff                	xor    %edi,%edi
  801a82:	31 c0                	xor    %eax,%eax
  801a84:	89 fa                	mov    %edi,%edx
  801a86:	83 c4 1c             	add    $0x1c,%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5f                   	pop    %edi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	89 d8                	mov    %ebx,%eax
  801a92:	f7 f7                	div    %edi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	89 fa                	mov    %edi,%edx
  801a98:	83 c4 1c             	add    $0x1c,%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5f                   	pop    %edi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    
  801aa0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa5:	89 eb                	mov    %ebp,%ebx
  801aa7:	29 fb                	sub    %edi,%ebx
  801aa9:	89 f9                	mov    %edi,%ecx
  801aab:	d3 e6                	shl    %cl,%esi
  801aad:	89 c5                	mov    %eax,%ebp
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 ed                	shr    %cl,%ebp
  801ab3:	89 e9                	mov    %ebp,%ecx
  801ab5:	09 f1                	or     %esi,%ecx
  801ab7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801abb:	89 f9                	mov    %edi,%ecx
  801abd:	d3 e0                	shl    %cl,%eax
  801abf:	89 c5                	mov    %eax,%ebp
  801ac1:	89 d6                	mov    %edx,%esi
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ee                	shr    %cl,%esi
  801ac7:	89 f9                	mov    %edi,%ecx
  801ac9:	d3 e2                	shl    %cl,%edx
  801acb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 e8                	shr    %cl,%eax
  801ad3:	09 c2                	or     %eax,%edx
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	89 f2                	mov    %esi,%edx
  801ad9:	f7 74 24 0c          	divl   0xc(%esp)
  801add:	89 d6                	mov    %edx,%esi
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	f7 e5                	mul    %ebp
  801ae3:	39 d6                	cmp    %edx,%esi
  801ae5:	72 19                	jb     801b00 <__udivdi3+0xfc>
  801ae7:	74 0b                	je     801af4 <__udivdi3+0xf0>
  801ae9:	89 d8                	mov    %ebx,%eax
  801aeb:	31 ff                	xor    %edi,%edi
  801aed:	e9 58 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af8:	89 f9                	mov    %edi,%ecx
  801afa:	d3 e2                	shl    %cl,%edx
  801afc:	39 c2                	cmp    %eax,%edx
  801afe:	73 e9                	jae    801ae9 <__udivdi3+0xe5>
  801b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b03:	31 ff                	xor    %edi,%edi
  801b05:	e9 40 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	31 c0                	xor    %eax,%eax
  801b0e:	e9 37 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b13:	90                   	nop

00801b14 <__umoddi3>:
  801b14:	55                   	push   %ebp
  801b15:	57                   	push   %edi
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	83 ec 1c             	sub    $0x1c,%esp
  801b1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b33:	89 f3                	mov    %esi,%ebx
  801b35:	89 fa                	mov    %edi,%edx
  801b37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3b:	89 34 24             	mov    %esi,(%esp)
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	75 1a                	jne    801b5c <__umoddi3+0x48>
  801b42:	39 f7                	cmp    %esi,%edi
  801b44:	0f 86 a2 00 00 00    	jbe    801bec <__umoddi3+0xd8>
  801b4a:	89 c8                	mov    %ecx,%eax
  801b4c:	89 f2                	mov    %esi,%edx
  801b4e:	f7 f7                	div    %edi
  801b50:	89 d0                	mov    %edx,%eax
  801b52:	31 d2                	xor    %edx,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	39 f0                	cmp    %esi,%eax
  801b5e:	0f 87 ac 00 00 00    	ja     801c10 <__umoddi3+0xfc>
  801b64:	0f bd e8             	bsr    %eax,%ebp
  801b67:	83 f5 1f             	xor    $0x1f,%ebp
  801b6a:	0f 84 ac 00 00 00    	je     801c1c <__umoddi3+0x108>
  801b70:	bf 20 00 00 00       	mov    $0x20,%edi
  801b75:	29 ef                	sub    %ebp,%edi
  801b77:	89 fe                	mov    %edi,%esi
  801b79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b7d:	89 e9                	mov    %ebp,%ecx
  801b7f:	d3 e0                	shl    %cl,%eax
  801b81:	89 d7                	mov    %edx,%edi
  801b83:	89 f1                	mov    %esi,%ecx
  801b85:	d3 ef                	shr    %cl,%edi
  801b87:	09 c7                	or     %eax,%edi
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 e2                	shl    %cl,%edx
  801b8d:	89 14 24             	mov    %edx,(%esp)
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 c2                	mov    %eax,%edx
  801b96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba4:	89 f1                	mov    %esi,%ecx
  801ba6:	d3 e8                	shr    %cl,%eax
  801ba8:	09 d0                	or     %edx,%eax
  801baa:	d3 eb                	shr    %cl,%ebx
  801bac:	89 da                	mov    %ebx,%edx
  801bae:	f7 f7                	div    %edi
  801bb0:	89 d3                	mov    %edx,%ebx
  801bb2:	f7 24 24             	mull   (%esp)
  801bb5:	89 c6                	mov    %eax,%esi
  801bb7:	89 d1                	mov    %edx,%ecx
  801bb9:	39 d3                	cmp    %edx,%ebx
  801bbb:	0f 82 87 00 00 00    	jb     801c48 <__umoddi3+0x134>
  801bc1:	0f 84 91 00 00 00    	je     801c58 <__umoddi3+0x144>
  801bc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bcb:	29 f2                	sub    %esi,%edx
  801bcd:	19 cb                	sbb    %ecx,%ebx
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd5:	d3 e0                	shl    %cl,%eax
  801bd7:	89 e9                	mov    %ebp,%ecx
  801bd9:	d3 ea                	shr    %cl,%edx
  801bdb:	09 d0                	or     %edx,%eax
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 eb                	shr    %cl,%ebx
  801be1:	89 da                	mov    %ebx,%edx
  801be3:	83 c4 1c             	add    $0x1c,%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5f                   	pop    %edi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    
  801beb:	90                   	nop
  801bec:	89 fd                	mov    %edi,%ebp
  801bee:	85 ff                	test   %edi,%edi
  801bf0:	75 0b                	jne    801bfd <__umoddi3+0xe9>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f7                	div    %edi
  801bfb:	89 c5                	mov    %eax,%ebp
  801bfd:	89 f0                	mov    %esi,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f5                	div    %ebp
  801c03:	89 c8                	mov    %ecx,%eax
  801c05:	f7 f5                	div    %ebp
  801c07:	89 d0                	mov    %edx,%eax
  801c09:	e9 44 ff ff ff       	jmp    801b52 <__umoddi3+0x3e>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	89 c8                	mov    %ecx,%eax
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	3b 04 24             	cmp    (%esp),%eax
  801c1f:	72 06                	jb     801c27 <__umoddi3+0x113>
  801c21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c25:	77 0f                	ja     801c36 <__umoddi3+0x122>
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	29 f9                	sub    %edi,%ecx
  801c2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c2f:	89 14 24             	mov    %edx,(%esp)
  801c32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3a:	8b 14 24             	mov    (%esp),%edx
  801c3d:	83 c4 1c             	add    $0x1c,%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    
  801c45:	8d 76 00             	lea    0x0(%esi),%esi
  801c48:	2b 04 24             	sub    (%esp),%eax
  801c4b:	19 fa                	sbb    %edi,%edx
  801c4d:	89 d1                	mov    %edx,%ecx
  801c4f:	89 c6                	mov    %eax,%esi
  801c51:	e9 71 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c5c:	72 ea                	jb     801c48 <__umoddi3+0x134>
  801c5e:	89 d9                	mov    %ebx,%ecx
  801c60:	e9 62 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>
