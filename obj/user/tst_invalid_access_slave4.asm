
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 b2 17 00 00       	call   801830 <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 20 1c 80 00       	push   $0x801c20
  800086:	6a 18                	push   $0x18
  800088:	68 bc 1c 80 00       	push   $0x801cbc
  80008d:	e8 c5 01 00 00       	call   800257 <_panic>

00800092 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80009b:	e8 52 16 00 00       	call   8016f2 <sys_getenvindex>
  8000a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	c1 e0 06             	shl    $0x6,%eax
  8000ab:	29 d0                	sub    %edx,%eax
  8000ad:	c1 e0 02             	shl    $0x2,%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000b9:	01 c8                	add    %ecx,%eax
  8000bb:	c1 e0 03             	shl    $0x3,%eax
  8000be:	01 d0                	add    %edx,%eax
  8000c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000d0:	89 c2                	mov    %eax,%edx
  8000d2:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000d8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8a 40 20             	mov    0x20(%eax),%al
  8000e5:	84 c0                	test   %al,%al
  8000e7:	74 0d                	je     8000f6 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ee:	83 c0 20             	add    $0x20,%eax
  8000f1:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000fa:	7e 0a                	jle    800106 <libmain+0x74>
		binaryname = argv[0];
  8000fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ff:	8b 00                	mov    (%eax),%eax
  800101:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800106:	83 ec 08             	sub    $0x8,%esp
  800109:	ff 75 0c             	pushl  0xc(%ebp)
  80010c:	ff 75 08             	pushl  0x8(%ebp)
  80010f:	e8 24 ff ff ff       	call   800038 <_main>
  800114:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800117:	a1 00 30 80 00       	mov    0x803000,%eax
  80011c:	85 c0                	test   %eax,%eax
  80011e:	0f 84 01 01 00 00    	je     800225 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800124:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80012a:	bb d8 1d 80 00       	mov    $0x801dd8,%ebx
  80012f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800134:	89 c7                	mov    %eax,%edi
  800136:	89 de                	mov    %ebx,%esi
  800138:	89 d1                	mov    %edx,%ecx
  80013a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80013c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80013f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800144:	b0 00                	mov    $0x0,%al
  800146:	89 d7                	mov    %edx,%edi
  800148:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80014a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800151:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015e:	50                   	push   %eax
  80015f:	e8 c4 17 00 00       	call   801928 <sys_utilities>
  800164:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800167:	e8 0d 13 00 00       	call   801479 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 f8 1c 80 00       	push   $0x801cf8
  800174:	e8 ac 03 00 00       	call   800525 <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80017c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017f:	85 c0                	test   %eax,%eax
  800181:	74 18                	je     80019b <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800183:	e8 be 17 00 00       	call   801946 <sys_get_optimal_num_faults>
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	50                   	push   %eax
  80018c:	68 20 1d 80 00       	push   $0x801d20
  800191:	e8 8f 03 00 00       	call   800525 <cprintf>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	eb 59                	jmp    8001f4 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80019b:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a0:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	52                   	push   %edx
  8001b5:	50                   	push   %eax
  8001b6:	68 44 1d 80 00       	push   $0x801d44
  8001bb:	e8 65 03 00 00       	call   800525 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c8:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d3:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001de:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001e4:	51                   	push   %ecx
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 6c 1d 80 00       	push   $0x801d6c
  8001ec:	e8 34 03 00 00       	call   800525 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f9:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	50                   	push   %eax
  800203:	68 c4 1d 80 00       	push   $0x801dc4
  800208:	e8 18 03 00 00       	call   800525 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 f8 1c 80 00       	push   $0x801cf8
  800218:	e8 08 03 00 00       	call   800525 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800220:	e8 6e 12 00 00       	call   801493 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800225:	e8 1f 00 00 00       	call   800249 <exit>
}
  80022a:	90                   	nop
  80022b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5f                   	pop    %edi
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	6a 00                	push   $0x0
  80023e:	e8 7b 14 00 00       	call   8016be <sys_destroy_env>
  800243:	83 c4 10             	add    $0x10,%esp
}
  800246:	90                   	nop
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <exit>:

void
exit(void)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80024f:	e8 d0 14 00 00       	call   801724 <sys_exit_env>
}
  800254:	90                   	nop
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80025d:	8d 45 10             	lea    0x10(%ebp),%eax
  800260:	83 c0 04             	add    $0x4,%eax
  800263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800266:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80026b:	85 c0                	test   %eax,%eax
  80026d:	74 16                	je     800285 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80026f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	50                   	push   %eax
  800278:	68 3c 1e 80 00       	push   $0x801e3c
  80027d:	e8 a3 02 00 00       	call   800525 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800285:	a1 04 30 80 00       	mov    0x803004,%eax
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	50                   	push   %eax
  800294:	68 44 1e 80 00       	push   $0x801e44
  800299:	6a 74                	push   $0x74
  80029b:	e8 b2 02 00 00       	call   800552 <cprintf_colored>
  8002a0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ac:	50                   	push   %eax
  8002ad:	e8 04 02 00 00       	call   8004b6 <vcprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	6a 00                	push   $0x0
  8002ba:	68 6c 1e 80 00       	push   $0x801e6c
  8002bf:	e8 f2 01 00 00       	call   8004b6 <vcprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c7:	e8 7d ff ff ff       	call   800249 <exit>

	// should not return here
	while (1) ;
  8002cc:	eb fe                	jmp    8002cc <_panic+0x75>

008002ce <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e2:	39 c2                	cmp    %eax,%edx
  8002e4:	74 14                	je     8002fa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	68 70 1e 80 00       	push   $0x801e70
  8002ee:	6a 26                	push   $0x26
  8002f0:	68 bc 1e 80 00       	push   $0x801ebc
  8002f5:	e8 5d ff ff ff       	call   800257 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800301:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800308:	e9 c5 00 00 00       	jmp    8003d2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80030d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800310:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800317:	8b 45 08             	mov    0x8(%ebp),%eax
  80031a:	01 d0                	add    %edx,%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	75 08                	jne    80032a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800322:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800325:	e9 a5 00 00 00       	jmp    8003cf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80032a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800331:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800338:	eb 69                	jmp    8003a3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80033a:	a1 20 30 80 00       	mov    0x803020,%eax
  80033f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800345:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800348:	89 d0                	mov    %edx,%eax
  80034a:	01 c0                	add    %eax,%eax
  80034c:	01 d0                	add    %edx,%eax
  80034e:	c1 e0 03             	shl    $0x3,%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8a 40 04             	mov    0x4(%eax),%al
  800356:	84 c0                	test   %al,%al
  800358:	75 46                	jne    8003a0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80035a:	a1 20 30 80 00       	mov    0x803020,%eax
  80035f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800378:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800380:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800385:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c8                	add    %ecx,%eax
  800391:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800393:	39 c2                	cmp    %eax,%edx
  800395:	75 09                	jne    8003a0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800397:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039e:	eb 15                	jmp    8003b5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	ff 45 e8             	incl   -0x18(%ebp)
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b1:	39 c2                	cmp    %eax,%edx
  8003b3:	77 85                	ja     80033a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b9:	75 14                	jne    8003cf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 c8 1e 80 00       	push   $0x801ec8
  8003c3:	6a 3a                	push   $0x3a
  8003c5:	68 bc 1e 80 00       	push   $0x801ebc
  8003ca:	e8 88 fe ff ff       	call   800257 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003cf:	ff 45 f0             	incl   -0x10(%ebp)
  8003d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d8:	0f 8c 2f ff ff ff    	jl     80030d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ec:	eb 26                	jmp    800414 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	01 c0                	add    %eax,%eax
  800400:	01 d0                	add    %edx,%eax
  800402:	c1 e0 03             	shl    $0x3,%eax
  800405:	01 c8                	add    %ecx,%eax
  800407:	8a 40 04             	mov    0x4(%eax),%al
  80040a:	3c 01                	cmp    $0x1,%al
  80040c:	75 03                	jne    800411 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80040e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800411:	ff 45 e0             	incl   -0x20(%ebp)
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80041f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800422:	39 c2                	cmp    %eax,%edx
  800424:	77 c8                	ja     8003ee <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800429:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80042c:	74 14                	je     800442 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 1c 1f 80 00       	push   $0x801f1c
  800436:	6a 44                	push   $0x44
  800438:	68 bc 1e 80 00       	push   $0x801ebc
  80043d:	e8 15 fe ff ff       	call   800257 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800442:	90                   	nop
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	53                   	push   %ebx
  800449:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 48 01             	lea    0x1(%eax),%ecx
  800454:	8b 55 0c             	mov    0xc(%ebp),%edx
  800457:	89 0a                	mov    %ecx,(%edx)
  800459:	8b 55 08             	mov    0x8(%ebp),%edx
  80045c:	88 d1                	mov    %dl,%cl
  80045e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800461:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046f:	75 30                	jne    8004a1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800471:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800477:	a0 44 30 80 00       	mov    0x803044,%al
  80047c:	0f b6 c0             	movzbl %al,%eax
  80047f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800482:	8b 09                	mov    (%ecx),%ecx
  800484:	89 cb                	mov    %ecx,%ebx
  800486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800489:	83 c1 08             	add    $0x8,%ecx
  80048c:	52                   	push   %edx
  80048d:	50                   	push   %eax
  80048e:	53                   	push   %ebx
  80048f:	51                   	push   %ecx
  800490:	e8 a0 0f 00 00       	call   801435 <sys_cputs>
  800495:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a4:	8b 40 04             	mov    0x4(%eax),%eax
  8004a7:	8d 50 01             	lea    0x1(%eax),%edx
  8004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b0:	90                   	nop
  8004b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c6:	00 00 00 
	b.cnt = 0;
  8004c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004df:	50                   	push   %eax
  8004e0:	68 45 04 80 00       	push   $0x800445
  8004e5:	e8 5a 02 00 00       	call   800744 <vprintfmt>
  8004ea:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004ed:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004f3:	a0 44 30 80 00       	mov    0x803044,%al
  8004f8:	0f b6 c0             	movzbl %al,%eax
  8004fb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800501:	52                   	push   %edx
  800502:	50                   	push   %eax
  800503:	51                   	push   %ecx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 22 0f 00 00       	call   801435 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 6f ff ff ff       	call   8004b6 <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800558:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	c1 e0 08             	shl    $0x8,%eax
  800565:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80056a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056d:	83 c0 04             	add    $0x4,%eax
  800570:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800573:	8b 45 0c             	mov    0xc(%ebp),%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 f4             	pushl  -0xc(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 34 ff ff ff       	call   8004b6 <vcprintf>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800588:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80058f:	07 00 00 

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059d:	e8 d7 0e 00 00       	call   801479 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 ff fe ff ff       	call   8004b6 <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bd:	e8 d1 0e 00 00       	call   801493 <sys_unlock_cons>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 a8 13 00 00       	call   8019b4 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 68 14 00 00       	call   801ac4 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 94 21 80 00       	add    $0x802194,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 c1 03 00 00    	je     800b17 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 5b             	cmp    $0x5b,%eax
  8007ac:	0f 87 3d 03 00 00    	ja     800aef <vprintfmt+0x3ab>
  8007b2:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 9b 02 00 00       	jmp    800b12 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 a5 21 80 00       	push   $0x8021a5
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 70 02 00 00       	call   800b1f <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 5b 02 00 00       	jmp    800b12 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 ae 21 80 00       	push   $0x8021ae
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 57 02 00 00       	call   800b1f <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 42 02 00 00       	jmp    800b12 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 1e 03 00 00       	call   800c21 <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 78 01 00 00       	jmp    800b12 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 ce 00 00 00       	jmp    800b12 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 46                	jmp    800b12 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 35                	jmp    800b12 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800add:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ae4:	eb 2c                	jmp    800b12 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aed:	eb 23                	jmp    800b12 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 25                	push   $0x25
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aff:	ff 4d 10             	decl   0x10(%ebp)
  800b02:	eb 03                	jmp    800b07 <vprintfmt+0x3c3>
  800b04:	ff 4d 10             	decl   0x10(%ebp)
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	48                   	dec    %eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	3c 25                	cmp    $0x25,%al
  800b0f:	75 f3                	jne    800b04 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b11:	90                   	nop
		}
	}
  800b12:	e9 35 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b17:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b25:	8d 45 10             	lea    0x10(%ebp),%eax
  800b28:	83 c0 04             	add    $0x4,%eax
  800b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b31:	ff 75 f4             	pushl  -0xc(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	ff 75 08             	pushl  0x8(%ebp)
  800b3b:	e8 04 fc ff ff       	call   800744 <vprintfmt>
  800b40:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b43:	90                   	nop
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8b 40 08             	mov    0x8(%eax),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8b 10                	mov    (%eax),%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8b 40 04             	mov    0x4(%eax),%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	73 12                	jae    800b79 <sprintputch+0x33>
		*b->buf++ = ch;
  800b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 0a                	mov    %ecx,(%edx)
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	88 10                	mov    %dl,(%eax)
}
  800b79:	90                   	nop
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	01 d0                	add    %edx,%eax
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba1:	74 06                	je     800ba9 <vsnprintf+0x2d>
  800ba3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba7:	7f 07                	jg     800bb0 <vsnprintf+0x34>
		return -E_INVAL;
  800ba9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bae:	eb 20                	jmp    800bd0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb0:	ff 75 14             	pushl  0x14(%ebp)
  800bb3:	ff 75 10             	pushl  0x10(%ebp)
  800bb6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb9:	50                   	push   %eax
  800bba:	68 46 0b 80 00       	push   $0x800b46
  800bbf:	e8 80 fb ff ff       	call   800744 <vprintfmt>
  800bc4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bdb:	83 c0 04             	add    $0x4,%eax
  800bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be1:	8b 45 10             	mov    0x10(%ebp),%eax
  800be4:	ff 75 f4             	pushl  -0xc(%ebp)
  800be7:	50                   	push   %eax
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	ff 75 08             	pushl  0x8(%ebp)
  800bee:	e8 89 ff ff ff       	call   800b7c <vsnprintf>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfc:	c9                   	leave  
  800bfd:	c3                   	ret    

00800bfe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0b:	eb 06                	jmp    800c13 <strlen+0x15>
		n++;
  800c0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	75 f1                	jne    800c0d <strlen+0xf>
		n++;
	return n;
  800c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2e:	eb 09                	jmp    800c39 <strnlen+0x18>
		n++;
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c33:	ff 45 08             	incl   0x8(%ebp)
  800c36:	ff 4d 0c             	decl   0xc(%ebp)
  800c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3d:	74 09                	je     800c48 <strnlen+0x27>
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	84 c0                	test   %al,%al
  800c46:	75 e8                	jne    800c30 <strnlen+0xf>
		n++;
	return n;
  800c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c59:	90                   	nop
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8d 50 01             	lea    0x1(%eax),%edx
  800c60:	89 55 08             	mov    %edx,0x8(%ebp)
  800c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	75 e4                	jne    800c5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8e:	eb 1f                	jmp    800caf <strncpy+0x34>
		*dst++ = *src;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 08             	mov    %edx,0x8(%ebp)
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	74 03                	je     800cac <strncpy+0x31>
			src++;
  800ca9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cac:	ff 45 fc             	incl   -0x4(%ebp)
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb5:	72 d9                	jb     800c90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	74 30                	je     800cfe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cce:	eb 16                	jmp    800ce6 <strlcpy+0x2a>
			*dst++ = *src++;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8d 50 01             	lea    0x1(%eax),%edx
  800cd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce2:	8a 12                	mov    (%edx),%dl
  800ce4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce6:	ff 4d 10             	decl   0x10(%ebp)
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 09                	je     800cf8 <strlcpy+0x3c>
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	75 d8                	jne    800cd0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0d:	eb 06                	jmp    800d15 <strcmp+0xb>
		p++, q++;
  800d0f:	ff 45 08             	incl   0x8(%ebp)
  800d12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	74 0e                	je     800d2c <strcmp+0x22>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 10                	mov    (%eax),%dl
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	38 c2                	cmp    %al,%dl
  800d2a:	74 e3                	je     800d0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d0             	movzbl %al,%edx
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	29 c2                	sub    %eax,%edx
  800d3e:	89 d0                	mov    %edx,%eax
}
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d45:	eb 09                	jmp    800d50 <strncmp+0xe>
		n--, p++, q++;
  800d47:	ff 4d 10             	decl   0x10(%ebp)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	74 17                	je     800d6d <strncmp+0x2b>
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 0e                	je     800d6d <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 10                	mov    (%eax),%dl
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	38 c2                	cmp    %al,%dl
  800d6b:	74 da                	je     800d47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d71:	75 07                	jne    800d7a <strncmp+0x38>
		return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
  800d78:	eb 14                	jmp    800d8e <strncmp+0x4c>
	else
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

00800d90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9c:	eb 12                	jmp    800db0 <strchr+0x20>
		if (*s == c)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da6:	75 05                	jne    800dad <strchr+0x1d>
			return (char *) s;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	eb 11                	jmp    800dbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	75 e5                	jne    800d9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 04             	sub    $0x4,%esp
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcc:	eb 0d                	jmp    800ddb <strfind+0x1b>
		if (*s == c)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd6:	74 0e                	je     800de6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd8:	ff 45 08             	incl   0x8(%ebp)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	84 c0                	test   %al,%al
  800de2:	75 ea                	jne    800dce <strfind+0xe>
  800de4:	eb 01                	jmp    800de7 <strfind+0x27>
		if (*s == c)
			break;
  800de6:	90                   	nop
	return (char *) s;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfc:	76 63                	jbe    800e61 <memset+0x75>
		uint64 data_block = c;
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	99                   	cltd   
  800e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e05:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e12:	c1 e0 08             	shl    $0x8,%eax
  800e15:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e18:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e21:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e25:	c1 e0 10             	shl    $0x10,%eax
  800e28:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e34:	89 c2                	mov    %eax,%edx
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e41:	eb 18                	jmp    800e5b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e43:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e46:	8d 41 08             	lea    0x8(%ecx),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	89 01                	mov    %eax,(%ecx)
  800e54:	89 51 04             	mov    %edx,0x4(%ecx)
  800e57:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e5b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5f:	77 e2                	ja     800e43 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e65:	74 23                	je     800e8a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6d:	eb 0e                	jmp    800e7d <memset+0x91>
			*p8++ = (uint8)c;
  800e6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e83:	89 55 10             	mov    %edx,0x10(%ebp)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	75 e5                	jne    800e6f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ea1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea5:	76 24                	jbe    800ecb <memcpy+0x3c>
		while(n >= 8){
  800ea7:	eb 1c                	jmp    800ec5 <memcpy+0x36>
			*d64 = *s64;
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eac:	8b 50 04             	mov    0x4(%eax),%edx
  800eaf:	8b 00                	mov    (%eax),%eax
  800eb1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb4:	89 01                	mov    %eax,(%ecx)
  800eb6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebd:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ec1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec9:	77 de                	ja     800ea9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecf:	74 31                	je     800f02 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edd:	eb 16                	jmp    800ef5 <memcpy+0x66>
			*d8++ = *s8++;
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eeb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eee:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ef1:	8a 12                	mov    (%edx),%dl
  800ef3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efb:	89 55 10             	mov    %edx,0x10(%ebp)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	75 dd                	jne    800edf <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	73 50                	jae    800f71 <memmove+0x6a>
  800f21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2c:	76 43                	jbe    800f71 <memmove+0x6a>
		s += n;
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f3a:	eb 10                	jmp    800f4c <memmove+0x45>
			*--d = *--s;
  800f3c:	ff 4d f8             	decl   -0x8(%ebp)
  800f3f:	ff 4d fc             	decl   -0x4(%ebp)
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8a 10                	mov    (%eax),%dl
  800f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f52:	89 55 10             	mov    %edx,0x10(%ebp)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	75 e3                	jne    800f3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f59:	eb 23                	jmp    800f7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	8d 50 01             	lea    0x1(%eax),%edx
  800f61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6d:	8a 12                	mov    (%edx),%dl
  800f6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f77:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 dd                	jne    800f5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f95:	eb 2a                	jmp    800fc1 <memcmp+0x3e>
		if (*s1 != *s2)
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	8a 10                	mov    (%eax),%dl
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	38 c2                	cmp    %al,%dl
  800fa3:	74 16                	je     800fbb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 d0             	movzbl %al,%edx
  800fad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 c0             	movzbl %al,%eax
  800fb5:	29 c2                	sub    %eax,%edx
  800fb7:	89 d0                	mov    %edx,%eax
  800fb9:	eb 18                	jmp    800fd3 <memcmp+0x50>
		s1++, s2++;
  800fbb:	ff 45 fc             	incl   -0x4(%ebp)
  800fbe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	75 c9                	jne    800f97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	01 d0                	add    %edx,%eax
  800fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe6:	eb 15                	jmp    800ffd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	0f b6 d0             	movzbl %al,%edx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	0f b6 c0             	movzbl %al,%eax
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	74 0d                	je     801007 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801003:	72 e3                	jb     800fe8 <memfind+0x13>
  801005:	eb 01                	jmp    801008 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801007:	90                   	nop
	return (void *) s;
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80101a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801021:	eb 03                	jmp    801026 <strtol+0x19>
		s++;
  801023:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 20                	cmp    $0x20,%al
  80102d:	74 f4                	je     801023 <strtol+0x16>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 09                	cmp    $0x9,%al
  801036:	74 eb                	je     801023 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3c 2b                	cmp    $0x2b,%al
  80103f:	75 05                	jne    801046 <strtol+0x39>
		s++;
  801041:	ff 45 08             	incl   0x8(%ebp)
  801044:	eb 13                	jmp    801059 <strtol+0x4c>
	else if (*s == '-')
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	3c 2d                	cmp    $0x2d,%al
  80104d:	75 0a                	jne    801059 <strtol+0x4c>
		s++, neg = 1;
  80104f:	ff 45 08             	incl   0x8(%ebp)
  801052:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801059:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105d:	74 06                	je     801065 <strtol+0x58>
  80105f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801063:	75 20                	jne    801085 <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 30                	cmp    $0x30,%al
  80106c:	75 17                	jne    801085 <strtol+0x78>
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	40                   	inc    %eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 78                	cmp    $0x78,%al
  801076:	75 0d                	jne    801085 <strtol+0x78>
		s += 2, base = 16;
  801078:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801083:	eb 28                	jmp    8010ad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801085:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801089:	75 15                	jne    8010a0 <strtol+0x93>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 0c                	jne    8010a0 <strtol+0x93>
		s++, base = 8;
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109e:	eb 0d                	jmp    8010ad <strtol+0xa0>
	else if (base == 0)
  8010a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a4:	75 07                	jne    8010ad <strtol+0xa0>
		base = 10;
  8010a6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 2f                	cmp    $0x2f,%al
  8010b4:	7e 19                	jle    8010cf <strtol+0xc2>
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 39                	cmp    $0x39,%al
  8010bd:	7f 10                	jg     8010cf <strtol+0xc2>
			dig = *s - '0';
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f be c0             	movsbl %al,%eax
  8010c7:	83 e8 30             	sub    $0x30,%eax
  8010ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cd:	eb 42                	jmp    801111 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 60                	cmp    $0x60,%al
  8010d6:	7e 19                	jle    8010f1 <strtol+0xe4>
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 7a                	cmp    $0x7a,%al
  8010df:	7f 10                	jg     8010f1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	0f be c0             	movsbl %al,%eax
  8010e9:	83 e8 57             	sub    $0x57,%eax
  8010ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ef:	eb 20                	jmp    801111 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 40                	cmp    $0x40,%al
  8010f8:	7e 39                	jle    801133 <strtol+0x126>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 5a                	cmp    $0x5a,%al
  801101:	7f 30                	jg     801133 <strtol+0x126>
			dig = *s - 'A' + 10;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	0f be c0             	movsbl %al,%eax
  80110b:	83 e8 37             	sub    $0x37,%eax
  80110e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801114:	3b 45 10             	cmp    0x10(%ebp),%eax
  801117:	7d 19                	jge    801132 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801123:	89 c2                	mov    %eax,%edx
  801125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801128:	01 d0                	add    %edx,%eax
  80112a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112d:	e9 7b ff ff ff       	jmp    8010ad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801132:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801133:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801137:	74 08                	je     801141 <strtol+0x134>
		*endptr = (char *) s;
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801141:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801145:	74 07                	je     80114e <strtol+0x141>
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	f7 d8                	neg    %eax
  80114c:	eb 03                	jmp    801151 <strtol+0x144>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <ltostr>:

void
ltostr(long value, char *str)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801160:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116b:	79 13                	jns    801180 <ltostr+0x2d>
	{
		neg = 1;
  80116d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80117a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801188:	99                   	cltd   
  801189:	f7 f9                	idiv   %ecx
  80118b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801191:	8d 50 01             	lea    0x1(%eax),%edx
  801194:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801197:	89 c2                	mov    %eax,%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a1:	83 c2 30             	add    $0x30,%edx
  8011a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ae:	f7 e9                	imul   %ecx
  8011b0:	c1 fa 02             	sar    $0x2,%edx
  8011b3:	89 c8                	mov    %ecx,%eax
  8011b5:	c1 f8 1f             	sar    $0x1f,%eax
  8011b8:	29 c2                	sub    %eax,%edx
  8011ba:	89 d0                	mov    %edx,%eax
  8011bc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	75 bb                	jne    801180 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	48                   	dec    %eax
  8011d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d7:	74 3d                	je     801216 <ltostr+0xc3>
		start = 1 ;
  8011d9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011e0:	eb 34                	jmp    801216 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801203:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	01 c2                	add    %eax,%edx
  80120b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120e:	88 02                	mov    %al,(%edx)
		start++ ;
  801210:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801213:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801219:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121c:	7c c4                	jl     8011e2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801229:	90                   	nop
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801232:	ff 75 08             	pushl  0x8(%ebp)
  801235:	e8 c4 f9 ff ff       	call   800bfe <strlen>
  80123a:	83 c4 04             	add    $0x4,%esp
  80123d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	e8 b6 f9 ff ff       	call   800bfe <strlen>
  801248:	83 c4 04             	add    $0x4,%esp
  80124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125c:	eb 17                	jmp    801275 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	01 c8                	add    %ecx,%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801272:	ff 45 fc             	incl   -0x4(%ebp)
  801275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801278:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80127b:	7c e1                	jl     80125e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801284:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80128b:	eb 1f                	jmp    8012ac <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801290:	8d 50 01             	lea    0x1(%eax),%edx
  801293:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801296:	89 c2                	mov    %eax,%edx
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 c8                	add    %ecx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a9:	ff 45 f8             	incl   -0x8(%ebp)
  8012ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b2:	7c d9                	jl     80128d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bf:	90                   	nop
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d1:	8b 00                	mov    (%eax),%eax
  8012d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	01 d0                	add    %edx,%eax
  8012df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e5:	eb 0c                	jmp    8012f3 <strsplit+0x31>
			*string++ = 0;
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8d 50 01             	lea    0x1(%eax),%edx
  8012ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	84 c0                	test   %al,%al
  8012fa:	74 18                	je     801314 <strsplit+0x52>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	0f be c0             	movsbl %al,%eax
  801304:	50                   	push   %eax
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	e8 83 fa ff ff       	call   800d90 <strchr>
  80130d:	83 c4 08             	add    $0x8,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	75 d3                	jne    8012e7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	84 c0                	test   %al,%al
  80131b:	74 5a                	je     801377 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131d:	8b 45 14             	mov    0x14(%ebp),%eax
  801320:	8b 00                	mov    (%eax),%eax
  801322:	83 f8 0f             	cmp    $0xf,%eax
  801325:	75 07                	jne    80132e <strsplit+0x6c>
		{
			return 0;
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
  80132c:	eb 66                	jmp    801394 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132e:	8b 45 14             	mov    0x14(%ebp),%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	8d 48 01             	lea    0x1(%eax),%ecx
  801336:	8b 55 14             	mov    0x14(%ebp),%edx
  801339:	89 0a                	mov    %ecx,(%edx)
  80133b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801342:	8b 45 10             	mov    0x10(%ebp),%eax
  801345:	01 c2                	add    %eax,%edx
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134c:	eb 03                	jmp    801351 <strsplit+0x8f>
			string++;
  80134e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	84 c0                	test   %al,%al
  801358:	74 8b                	je     8012e5 <strsplit+0x23>
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	0f be c0             	movsbl %al,%eax
  801362:	50                   	push   %eax
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	e8 25 fa ff ff       	call   800d90 <strchr>
  80136b:	83 c4 08             	add    $0x8,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	74 dc                	je     80134e <strsplit+0x8c>
			string++;
	}
  801372:	e9 6e ff ff ff       	jmp    8012e5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801377:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801378:	8b 45 14             	mov    0x14(%ebp),%eax
  80137b:	8b 00                	mov    (%eax),%eax
  80137d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a9:	eb 4a                	jmp    8013f5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	01 c2                	add    %eax,%edx
  8013b3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 c8                	add    %ecx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	3c 40                	cmp    $0x40,%al
  8013cb:	7e 25                	jle    8013f2 <str2lower+0x5c>
  8013cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 d0                	add    %edx,%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	3c 5a                	cmp    $0x5a,%al
  8013d9:	7f 17                	jg     8013f2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e9:	01 ca                	add    %ecx,%edx
  8013eb:	8a 12                	mov    (%edx),%dl
  8013ed:	83 c2 20             	add    $0x20,%edx
  8013f0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f2:	ff 45 fc             	incl   -0x4(%ebp)
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	e8 01 f8 ff ff       	call   800bfe <strlen>
  8013fd:	83 c4 04             	add    $0x4,%esp
  801400:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801403:	7f a6                	jg     8013ab <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801405:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	57                   	push   %edi
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
  801410:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8b 55 0c             	mov    0xc(%ebp),%edx
  801419:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80141f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801422:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801425:	cd 30                	int    $0x30
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 04             	sub    $0x4,%esp
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801441:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801444:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	51                   	push   %ecx
  80144e:	52                   	push   %edx
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	6a 00                	push   $0x0
  801455:	e8 b0 ff ff ff       	call   80140a <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	90                   	nop
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <sys_cgetc>:

int
sys_cgetc(void)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 02                	push   $0x2
  80146f:	e8 96 ff ff ff       	call   80140a <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 03                	push   $0x3
  801488:	e8 7d ff ff ff       	call   80140a <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 04                	push   $0x4
  8014a2:	e8 63 ff ff ff       	call   80140a <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
}
  8014aa:	90                   	nop
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	52                   	push   %edx
  8014bd:	50                   	push   %eax
  8014be:	6a 08                	push   $0x8
  8014c0:	e8 45 ff ff ff       	call   80140a <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8014d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	56                   	push   %esi
  8014df:	53                   	push   %ebx
  8014e0:	51                   	push   %ecx
  8014e1:	52                   	push   %edx
  8014e2:	50                   	push   %eax
  8014e3:	6a 09                	push   $0x9
  8014e5:	e8 20 ff ff ff       	call   80140a <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f0:	5b                   	pop    %ebx
  8014f1:	5e                   	pop    %esi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	ff 75 08             	pushl  0x8(%ebp)
  801502:	6a 0a                	push   $0xa
  801504:	e8 01 ff ff ff       	call   80140a <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	6a 0b                	push   $0xb
  80151f:	e8 e6 fe ff ff       	call   80140a <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 0c                	push   $0xc
  801538:	e8 cd fe ff ff       	call   80140a <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 0d                	push   $0xd
  801551:	e8 b4 fe ff ff       	call   80140a <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 0e                	push   $0xe
  80156a:	e8 9b fe ff ff       	call   80140a <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 0f                	push   $0xf
  801583:	e8 82 fe ff ff       	call   80140a <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	6a 10                	push   $0x10
  80159d:	e8 68 fe ff ff       	call   80140a <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 11                	push   $0x11
  8015b6:	e8 4f fe ff ff       	call   80140a <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	90                   	nop
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	50                   	push   %eax
  8015da:	6a 01                	push   $0x1
  8015dc:	e8 29 fe ff ff       	call   80140a <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	90                   	nop
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 14                	push   $0x14
  8015f6:	e8 0f fe ff ff       	call   80140a <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	90                   	nop
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	8b 45 10             	mov    0x10(%ebp),%eax
  80160a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80160d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801610:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	6a 00                	push   $0x0
  801619:	51                   	push   %ecx
  80161a:	52                   	push   %edx
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	50                   	push   %eax
  80161f:	6a 15                	push   $0x15
  801621:	e8 e4 fd ff ff       	call   80140a <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80162e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	52                   	push   %edx
  80163b:	50                   	push   %eax
  80163c:	6a 16                	push   $0x16
  80163e:	e8 c7 fd ff ff       	call   80140a <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80164b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	51                   	push   %ecx
  801659:	52                   	push   %edx
  80165a:	50                   	push   %eax
  80165b:	6a 17                	push   $0x17
  80165d:	e8 a8 fd ff ff       	call   80140a <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	52                   	push   %edx
  801677:	50                   	push   %eax
  801678:	6a 18                	push   $0x18
  80167a:	e8 8b fd ff ff       	call   80140a <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 14             	pushl  0x14(%ebp)
  80168f:	ff 75 10             	pushl  0x10(%ebp)
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	6a 19                	push   $0x19
  801698:	e8 6d fd ff ff       	call   80140a <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	50                   	push   %eax
  8016b1:	6a 1a                	push   $0x1a
  8016b3:	e8 52 fd ff ff       	call   80140a <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	90                   	nop
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	50                   	push   %eax
  8016cd:	6a 1b                	push   $0x1b
  8016cf:	e8 36 fd ff ff       	call   80140a <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 05                	push   $0x5
  8016e8:	e8 1d fd ff ff       	call   80140a <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 06                	push   $0x6
  801701:	e8 04 fd ff ff       	call   80140a <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 07                	push   $0x7
  80171a:	e8 eb fc ff ff       	call   80140a <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_exit_env>:


void sys_exit_env(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 1c                	push   $0x1c
  801733:	e8 d2 fc ff ff       	call   80140a <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801744:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801747:	8d 50 04             	lea    0x4(%eax),%edx
  80174a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 1d                	push   $0x1d
  801757:	e8 ae fc ff ff       	call   80140a <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
	return result;
  80175f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801762:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801765:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801768:	89 01                	mov    %eax,(%ecx)
  80176a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	c9                   	leave  
  801771:	c2 04 00             	ret    $0x4

00801774 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 13                	push   $0x13
  801786:	e8 7f fc ff ff       	call   80140a <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_rcr2>:
uint32 sys_rcr2()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 1e                	push   $0x1e
  8017a0:	e8 65 fc ff ff       	call   80140a <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	50                   	push   %eax
  8017c3:	6a 1f                	push   $0x1f
  8017c5:	e8 40 fc ff ff       	call   80140a <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <rsttst>:
void rsttst()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 21                	push   $0x21
  8017df:	e8 26 fc ff ff       	call   80140a <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e7:	90                   	nop
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 10             	pushl  0x10(%ebp)
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 20                	push   $0x20
  80180a:	e8 fb fb ff ff       	call   80140a <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <chktst>:
void chktst(uint32 n)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 22                	push   $0x22
  801825:	e8 e0 fb ff ff       	call   80140a <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <inctst>:

void inctst()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 23                	push   $0x23
  80183f:	e8 c6 fb ff ff       	call   80140a <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return ;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <gettst>:
uint32 gettst()
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 24                	push   $0x24
  801859:	e8 ac fb ff ff       	call   80140a <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 25                	push   $0x25
  801872:	e8 93 fb ff ff       	call   80140a <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
  80187a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80187f:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	6a 26                	push   $0x26
  80189e:	e8 67 fb ff ff       	call   80140a <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	53                   	push   %ebx
  8018bc:	51                   	push   %ecx
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 27                	push   $0x27
  8018c1:	e8 44 fb ff ff       	call   80140a <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 28                	push   $0x28
  8018e1:	e8 24 fb ff ff       	call   80140a <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	51                   	push   %ecx
  8018fa:	ff 75 10             	pushl  0x10(%ebp)
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	6a 29                	push   $0x29
  801901:	e8 04 fb ff ff       	call   80140a <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	ff 75 10             	pushl  0x10(%ebp)
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 12                	push   $0x12
  80191d:	e8 e8 fa ff ff       	call   80140a <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
	return ;
  801925:	90                   	nop
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	52                   	push   %edx
  801938:	50                   	push   %eax
  801939:	6a 2a                	push   $0x2a
  80193b:	e8 ca fa ff ff       	call   80140a <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 2b                	push   $0x2b
  801955:	e8 b0 fa ff ff       	call   80140a <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 2d                	push   $0x2d
  801970:	e8 95 fa ff ff       	call   80140a <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 2c                	push   $0x2c
  80198c:	e8 79 fa ff ff       	call   80140a <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	68 28 23 80 00       	push   $0x802328
  8019a5:	68 25 01 00 00       	push   $0x125
  8019aa:	68 5b 23 80 00       	push   $0x80235b
  8019af:	e8 a3 e8 ff ff       	call   800257 <_panic>

008019b4 <__udivdi3>:
  8019b4:	55                   	push   %ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 1c             	sub    $0x1c,%esp
  8019bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cb:	89 ca                	mov    %ecx,%edx
  8019cd:	89 f8                	mov    %edi,%eax
  8019cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019d3:	85 f6                	test   %esi,%esi
  8019d5:	75 2d                	jne    801a04 <__udivdi3+0x50>
  8019d7:	39 cf                	cmp    %ecx,%edi
  8019d9:	77 65                	ja     801a40 <__udivdi3+0x8c>
  8019db:	89 fd                	mov    %edi,%ebp
  8019dd:	85 ff                	test   %edi,%edi
  8019df:	75 0b                	jne    8019ec <__udivdi3+0x38>
  8019e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e6:	31 d2                	xor    %edx,%edx
  8019e8:	f7 f7                	div    %edi
  8019ea:	89 c5                	mov    %eax,%ebp
  8019ec:	31 d2                	xor    %edx,%edx
  8019ee:	89 c8                	mov    %ecx,%eax
  8019f0:	f7 f5                	div    %ebp
  8019f2:	89 c1                	mov    %eax,%ecx
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	f7 f5                	div    %ebp
  8019f8:	89 cf                	mov    %ecx,%edi
  8019fa:	89 fa                	mov    %edi,%edx
  8019fc:	83 c4 1c             	add    $0x1c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    
  801a04:	39 ce                	cmp    %ecx,%esi
  801a06:	77 28                	ja     801a30 <__udivdi3+0x7c>
  801a08:	0f bd fe             	bsr    %esi,%edi
  801a0b:	83 f7 1f             	xor    $0x1f,%edi
  801a0e:	75 40                	jne    801a50 <__udivdi3+0x9c>
  801a10:	39 ce                	cmp    %ecx,%esi
  801a12:	72 0a                	jb     801a1e <__udivdi3+0x6a>
  801a14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a18:	0f 87 9e 00 00 00    	ja     801abc <__udivdi3+0x108>
  801a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a23:	89 fa                	mov    %edi,%edx
  801a25:	83 c4 1c             	add    $0x1c,%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
  801a2d:	8d 76 00             	lea    0x0(%esi),%esi
  801a30:	31 ff                	xor    %edi,%edi
  801a32:	31 c0                	xor    %eax,%eax
  801a34:	89 fa                	mov    %edi,%edx
  801a36:	83 c4 1c             	add    $0x1c,%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5f                   	pop    %edi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    
  801a3e:	66 90                	xchg   %ax,%ax
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	f7 f7                	div    %edi
  801a44:	31 ff                	xor    %edi,%edi
  801a46:	89 fa                	mov    %edi,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a55:	89 eb                	mov    %ebp,%ebx
  801a57:	29 fb                	sub    %edi,%ebx
  801a59:	89 f9                	mov    %edi,%ecx
  801a5b:	d3 e6                	shl    %cl,%esi
  801a5d:	89 c5                	mov    %eax,%ebp
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 ed                	shr    %cl,%ebp
  801a63:	89 e9                	mov    %ebp,%ecx
  801a65:	09 f1                	or     %esi,%ecx
  801a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a6b:	89 f9                	mov    %edi,%ecx
  801a6d:	d3 e0                	shl    %cl,%eax
  801a6f:	89 c5                	mov    %eax,%ebp
  801a71:	89 d6                	mov    %edx,%esi
  801a73:	88 d9                	mov    %bl,%cl
  801a75:	d3 ee                	shr    %cl,%esi
  801a77:	89 f9                	mov    %edi,%ecx
  801a79:	d3 e2                	shl    %cl,%edx
  801a7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a7f:	88 d9                	mov    %bl,%cl
  801a81:	d3 e8                	shr    %cl,%eax
  801a83:	09 c2                	or     %eax,%edx
  801a85:	89 d0                	mov    %edx,%eax
  801a87:	89 f2                	mov    %esi,%edx
  801a89:	f7 74 24 0c          	divl   0xc(%esp)
  801a8d:	89 d6                	mov    %edx,%esi
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	f7 e5                	mul    %ebp
  801a93:	39 d6                	cmp    %edx,%esi
  801a95:	72 19                	jb     801ab0 <__udivdi3+0xfc>
  801a97:	74 0b                	je     801aa4 <__udivdi3+0xf0>
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	31 ff                	xor    %edi,%edi
  801a9d:	e9 58 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aa8:	89 f9                	mov    %edi,%ecx
  801aaa:	d3 e2                	shl    %cl,%edx
  801aac:	39 c2                	cmp    %eax,%edx
  801aae:	73 e9                	jae    801a99 <__udivdi3+0xe5>
  801ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ab3:	31 ff                	xor    %edi,%edi
  801ab5:	e9 40 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	31 c0                	xor    %eax,%eax
  801abe:	e9 37 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801ac3:	90                   	nop

00801ac4 <__umoddi3>:
  801ac4:	55                   	push   %ebp
  801ac5:	57                   	push   %edi
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 1c             	sub    $0x1c,%esp
  801acb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801adf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ae3:	89 f3                	mov    %esi,%ebx
  801ae5:	89 fa                	mov    %edi,%edx
  801ae7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aeb:	89 34 24             	mov    %esi,(%esp)
  801aee:	85 c0                	test   %eax,%eax
  801af0:	75 1a                	jne    801b0c <__umoddi3+0x48>
  801af2:	39 f7                	cmp    %esi,%edi
  801af4:	0f 86 a2 00 00 00    	jbe    801b9c <__umoddi3+0xd8>
  801afa:	89 c8                	mov    %ecx,%eax
  801afc:	89 f2                	mov    %esi,%edx
  801afe:	f7 f7                	div    %edi
  801b00:	89 d0                	mov    %edx,%eax
  801b02:	31 d2                	xor    %edx,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	39 f0                	cmp    %esi,%eax
  801b0e:	0f 87 ac 00 00 00    	ja     801bc0 <__umoddi3+0xfc>
  801b14:	0f bd e8             	bsr    %eax,%ebp
  801b17:	83 f5 1f             	xor    $0x1f,%ebp
  801b1a:	0f 84 ac 00 00 00    	je     801bcc <__umoddi3+0x108>
  801b20:	bf 20 00 00 00       	mov    $0x20,%edi
  801b25:	29 ef                	sub    %ebp,%edi
  801b27:	89 fe                	mov    %edi,%esi
  801b29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b2d:	89 e9                	mov    %ebp,%ecx
  801b2f:	d3 e0                	shl    %cl,%eax
  801b31:	89 d7                	mov    %edx,%edi
  801b33:	89 f1                	mov    %esi,%ecx
  801b35:	d3 ef                	shr    %cl,%edi
  801b37:	09 c7                	or     %eax,%edi
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 e2                	shl    %cl,%edx
  801b3d:	89 14 24             	mov    %edx,(%esp)
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	d3 e0                	shl    %cl,%eax
  801b44:	89 c2                	mov    %eax,%edx
  801b46:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4a:	d3 e0                	shl    %cl,%eax
  801b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b50:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b54:	89 f1                	mov    %esi,%ecx
  801b56:	d3 e8                	shr    %cl,%eax
  801b58:	09 d0                	or     %edx,%eax
  801b5a:	d3 eb                	shr    %cl,%ebx
  801b5c:	89 da                	mov    %ebx,%edx
  801b5e:	f7 f7                	div    %edi
  801b60:	89 d3                	mov    %edx,%ebx
  801b62:	f7 24 24             	mull   (%esp)
  801b65:	89 c6                	mov    %eax,%esi
  801b67:	89 d1                	mov    %edx,%ecx
  801b69:	39 d3                	cmp    %edx,%ebx
  801b6b:	0f 82 87 00 00 00    	jb     801bf8 <__umoddi3+0x134>
  801b71:	0f 84 91 00 00 00    	je     801c08 <__umoddi3+0x144>
  801b77:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b7b:	29 f2                	sub    %esi,%edx
  801b7d:	19 cb                	sbb    %ecx,%ebx
  801b7f:	89 d8                	mov    %ebx,%eax
  801b81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b85:	d3 e0                	shl    %cl,%eax
  801b87:	89 e9                	mov    %ebp,%ecx
  801b89:	d3 ea                	shr    %cl,%edx
  801b8b:	09 d0                	or     %edx,%eax
  801b8d:	89 e9                	mov    %ebp,%ecx
  801b8f:	d3 eb                	shr    %cl,%ebx
  801b91:	89 da                	mov    %ebx,%edx
  801b93:	83 c4 1c             	add    $0x1c,%esp
  801b96:	5b                   	pop    %ebx
  801b97:	5e                   	pop    %esi
  801b98:	5f                   	pop    %edi
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    
  801b9b:	90                   	nop
  801b9c:	89 fd                	mov    %edi,%ebp
  801b9e:	85 ff                	test   %edi,%edi
  801ba0:	75 0b                	jne    801bad <__umoddi3+0xe9>
  801ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba7:	31 d2                	xor    %edx,%edx
  801ba9:	f7 f7                	div    %edi
  801bab:	89 c5                	mov    %eax,%ebp
  801bad:	89 f0                	mov    %esi,%eax
  801baf:	31 d2                	xor    %edx,%edx
  801bb1:	f7 f5                	div    %ebp
  801bb3:	89 c8                	mov    %ecx,%eax
  801bb5:	f7 f5                	div    %ebp
  801bb7:	89 d0                	mov    %edx,%eax
  801bb9:	e9 44 ff ff ff       	jmp    801b02 <__umoddi3+0x3e>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	89 c8                	mov    %ecx,%eax
  801bc2:	89 f2                	mov    %esi,%edx
  801bc4:	83 c4 1c             	add    $0x1c,%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
  801bcc:	3b 04 24             	cmp    (%esp),%eax
  801bcf:	72 06                	jb     801bd7 <__umoddi3+0x113>
  801bd1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd5:	77 0f                	ja     801be6 <__umoddi3+0x122>
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	29 f9                	sub    %edi,%ecx
  801bdb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bdf:	89 14 24             	mov    %edx,(%esp)
  801be2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bea:	8b 14 24             	mov    (%esp),%edx
  801bed:	83 c4 1c             	add    $0x1c,%esp
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5f                   	pop    %edi
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    
  801bf5:	8d 76 00             	lea    0x0(%esi),%esi
  801bf8:	2b 04 24             	sub    (%esp),%eax
  801bfb:	19 fa                	sbb    %edi,%edx
  801bfd:	89 d1                	mov    %edx,%ecx
  801bff:	89 c6                	mov    %eax,%esi
  801c01:	e9 71 ff ff ff       	jmp    801b77 <__umoddi3+0xb3>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c0c:	72 ea                	jb     801bf8 <__umoddi3+0x134>
  801c0e:	89 d9                	mov    %ebx,%ecx
  801c10:	e9 62 ff ff ff       	jmp    801b77 <__umoddi3+0xb3>
