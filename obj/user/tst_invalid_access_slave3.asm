
obj/user/tst_invalid_access_slave3:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] Non=reserved User Heap
	uint32 *ptr = (uint32*)(USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE);
  80003e:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 b2 17 00 00       	call   801805 <inctst>
	panic("tst invalid access failed: Attempt to access a non-reserved (unmarked) user heap page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 00 1c 80 00       	push   $0x801c00
  80005b:	6a 0e                	push   $0xe
  80005d:	68 8c 1c 80 00       	push   $0x801c8c
  800062:	e8 c5 01 00 00       	call   80022c <_panic>

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 52 16 00 00       	call   8016c7 <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 06             	shl    $0x6,%eax
  800080:	29 d0                	sub    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008e:	01 c8                	add    %ecx,%eax
  800090:	c1 e0 03             	shl    $0x3,%eax
  800093:	01 d0                	add    %edx,%eax
  800095:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80009c:	29 c2                	sub    %eax,%edx
  80009e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a5:	89 c2                	mov    %eax,%edx
  8000a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8a 40 20             	mov    0x20(%eax),%al
  8000ba:	84 c0                	test   %al,%al
  8000bc:	74 0d                	je     8000cb <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	83 c0 20             	add    $0x20,%eax
  8000c6:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cf:	7e 0a                	jle    8000db <libmain+0x74>
		binaryname = argv[0];
  8000d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d4:	8b 00                	mov    (%eax),%eax
  8000d6:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000db:	83 ec 08             	sub    $0x8,%esp
  8000de:	ff 75 0c             	pushl  0xc(%ebp)
  8000e1:	ff 75 08             	pushl  0x8(%ebp)
  8000e4:	e8 4f ff ff ff       	call   800038 <_main>
  8000e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	0f 84 01 01 00 00    	je     8001fa <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ff:	bb a8 1d 80 00       	mov    $0x801da8,%ebx
  800104:	ba 0e 00 00 00       	mov    $0xe,%edx
  800109:	89 c7                	mov    %eax,%edi
  80010b:	89 de                	mov    %ebx,%esi
  80010d:	89 d1                	mov    %edx,%ecx
  80010f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800111:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800114:	b9 56 00 00 00       	mov    $0x56,%ecx
  800119:	b0 00                	mov    $0x0,%al
  80011b:	89 d7                	mov    %edx,%edi
  80011d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80011f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800126:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	50                   	push   %eax
  80012d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 c4 17 00 00       	call   8018fd <sys_utilities>
  800139:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80013c:	e8 0d 13 00 00       	call   80144e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 c8 1c 80 00       	push   $0x801cc8
  800149:	e8 ac 03 00 00       	call   8004fa <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800154:	85 c0                	test   %eax,%eax
  800156:	74 18                	je     800170 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800158:	e8 be 17 00 00       	call   80191b <sys_get_optimal_num_faults>
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	50                   	push   %eax
  800161:	68 f0 1c 80 00       	push   $0x801cf0
  800166:	e8 8f 03 00 00       	call   8004fa <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	eb 59                	jmp    8001c9 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	52                   	push   %edx
  80018a:	50                   	push   %eax
  80018b:	68 14 1d 80 00       	push   $0x801d14
  800190:	e8 65 03 00 00       	call   8004fa <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a8:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b3:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	68 3c 1d 80 00       	push   $0x801d3c
  8001c1:	e8 34 03 00 00       	call   8004fa <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ce:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	50                   	push   %eax
  8001d8:	68 94 1d 80 00       	push   $0x801d94
  8001dd:	e8 18 03 00 00       	call   8004fa <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 c8 1c 80 00       	push   $0x801cc8
  8001ed:	e8 08 03 00 00       	call   8004fa <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001f5:	e8 6e 12 00 00       	call   801468 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001fa:	e8 1f 00 00 00       	call   80021e <exit>
}
  8001ff:	90                   	nop
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	6a 00                	push   $0x0
  800213:	e8 7b 14 00 00       	call   801693 <sys_destroy_env>
  800218:	83 c4 10             	add    $0x10,%esp
}
  80021b:	90                   	nop
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <exit>:

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800224:	e8 d0 14 00 00       	call   8016f9 <sys_exit_env>
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800232:	8d 45 10             	lea    0x10(%ebp),%eax
  800235:	83 c0 04             	add    $0x4,%eax
  800238:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80023b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800240:	85 c0                	test   %eax,%eax
  800242:	74 16                	je     80025a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800244:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	50                   	push   %eax
  80024d:	68 0c 1e 80 00       	push   $0x801e0c
  800252:	e8 a3 02 00 00       	call   8004fa <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80025a:	a1 04 30 80 00       	mov    0x803004,%eax
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	ff 75 08             	pushl  0x8(%ebp)
  800268:	50                   	push   %eax
  800269:	68 14 1e 80 00       	push   $0x801e14
  80026e:	6a 74                	push   $0x74
  800270:	e8 b2 02 00 00       	call   800527 <cprintf_colored>
  800275:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800278:	8b 45 10             	mov    0x10(%ebp),%eax
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	ff 75 f4             	pushl  -0xc(%ebp)
  800281:	50                   	push   %eax
  800282:	e8 04 02 00 00       	call   80048b <vcprintf>
  800287:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	68 3c 1e 80 00       	push   $0x801e3c
  800294:	e8 f2 01 00 00       	call   80048b <vcprintf>
  800299:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80029c:	e8 7d ff ff ff       	call   80021e <exit>

	// should not return here
	while (1) ;
  8002a1:	eb fe                	jmp    8002a1 <_panic+0x75>

008002a3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	39 c2                	cmp    %eax,%edx
  8002b9:	74 14                	je     8002cf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	68 40 1e 80 00       	push   $0x801e40
  8002c3:	6a 26                	push   $0x26
  8002c5:	68 8c 1e 80 00       	push   $0x801e8c
  8002ca:	e8 5d ff ff ff       	call   80022c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002dd:	e9 c5 00 00 00       	jmp    8003a7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	8b 00                	mov    (%eax),%eax
  8002f3:	85 c0                	test   %eax,%eax
  8002f5:	75 08                	jne    8002ff <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002f7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002fa:	e9 a5 00 00 00       	jmp    8003a4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800306:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80030d:	eb 69                	jmp    800378 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80030f:	a1 20 30 80 00       	mov    0x803020,%eax
  800314:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80031a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031d:	89 d0                	mov    %edx,%eax
  80031f:	01 c0                	add    %eax,%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	c1 e0 03             	shl    $0x3,%eax
  800326:	01 c8                	add    %ecx,%eax
  800328:	8a 40 04             	mov    0x4(%eax),%al
  80032b:	84 c0                	test   %al,%al
  80032d:	75 46                	jne    800375 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80032f:	a1 20 30 80 00       	mov    0x803020,%eax
  800334:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80033a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	01 c0                	add    %eax,%eax
  800341:	01 d0                	add    %edx,%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80034d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800355:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c8                	add    %ecx,%eax
  800366:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	75 09                	jne    800375 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80036c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800373:	eb 15                	jmp    80038a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800375:	ff 45 e8             	incl   -0x18(%ebp)
  800378:	a1 20 30 80 00       	mov    0x803020,%eax
  80037d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800386:	39 c2                	cmp    %eax,%edx
  800388:	77 85                	ja     80030f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80038a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80038e:	75 14                	jne    8003a4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	68 98 1e 80 00       	push   $0x801e98
  800398:	6a 3a                	push   $0x3a
  80039a:	68 8c 1e 80 00       	push   $0x801e8c
  80039f:	e8 88 fe ff ff       	call   80022c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003a4:	ff 45 f0             	incl   -0x10(%ebp)
  8003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ad:	0f 8c 2f ff ff ff    	jl     8002e2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c1:	eb 26                	jmp    8003e9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	c1 e0 03             	shl    $0x3,%eax
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	8a 40 04             	mov    0x4(%eax),%al
  8003df:	3c 01                	cmp    $0x1,%al
  8003e1:	75 03                	jne    8003e6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003e3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e6:	ff 45 e0             	incl   -0x20(%ebp)
  8003e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f7:	39 c2                	cmp    %eax,%edx
  8003f9:	77 c8                	ja     8003c3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800401:	74 14                	je     800417 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	68 ec 1e 80 00       	push   $0x801eec
  80040b:	6a 44                	push   $0x44
  80040d:	68 8c 1e 80 00       	push   $0x801e8c
  800412:	e8 15 fe ff ff       	call   80022c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800417:	90                   	nop
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	53                   	push   %ebx
  80041e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800421:	8b 45 0c             	mov    0xc(%ebp),%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	8d 48 01             	lea    0x1(%eax),%ecx
  800429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042c:	89 0a                	mov    %ecx,(%edx)
  80042e:	8b 55 08             	mov    0x8(%ebp),%edx
  800431:	88 d1                	mov    %dl,%cl
  800433:	8b 55 0c             	mov    0xc(%ebp),%edx
  800436:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800444:	75 30                	jne    800476 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800446:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80044c:	a0 44 30 80 00       	mov    0x803044,%al
  800451:	0f b6 c0             	movzbl %al,%eax
  800454:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800457:	8b 09                	mov    (%ecx),%ecx
  800459:	89 cb                	mov    %ecx,%ebx
  80045b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80045e:	83 c1 08             	add    $0x8,%ecx
  800461:	52                   	push   %edx
  800462:	50                   	push   %eax
  800463:	53                   	push   %ebx
  800464:	51                   	push   %ecx
  800465:	e8 a0 0f 00 00       	call   80140a <sys_cputs>
  80046a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 40 04             	mov    0x4(%eax),%eax
  80047c:	8d 50 01             	lea    0x1(%eax),%edx
  80047f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800482:	89 50 04             	mov    %edx,0x4(%eax)
}
  800485:	90                   	nop
  800486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800494:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049b:	00 00 00 
	b.cnt = 0;
  80049e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004a8:	ff 75 0c             	pushl  0xc(%ebp)
  8004ab:	ff 75 08             	pushl  0x8(%ebp)
  8004ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b4:	50                   	push   %eax
  8004b5:	68 1a 04 80 00       	push   $0x80041a
  8004ba:	e8 5a 02 00 00       	call   800719 <vprintfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004c2:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004c8:	a0 44 30 80 00       	mov    0x803044,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004d6:	52                   	push   %edx
  8004d7:	50                   	push   %eax
  8004d8:	51                   	push   %ecx
  8004d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004df:	83 c0 08             	add    $0x8,%eax
  8004e2:	50                   	push   %eax
  8004e3:	e8 22 0f 00 00       	call   80140a <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004eb:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800500:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800507:	8d 45 0c             	lea    0xc(%ebp),%eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 f4             	pushl  -0xc(%ebp)
  800516:	50                   	push   %eax
  800517:	e8 6f ff ff ff       	call   80048b <vcprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800522:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	c1 e0 08             	shl    $0x8,%eax
  80053a:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80053f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800542:	83 c0 04             	add    $0x4,%eax
  800545:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 f4             	pushl  -0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	e8 34 ff ff ff       	call   80048b <vcprintf>
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80055d:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800564:	07 00 00 

	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800572:	e8 d7 0e 00 00       	call   80144e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 ff fe ff ff       	call   80048b <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800592:	e8 d1 0e 00 00       	call   801468 <sys_unlock_cons>
	return cnt;
  800597:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	53                   	push   %ebx
  8005a0:	83 ec 14             	sub    $0x14,%esp
  8005a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005af:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ba:	77 55                	ja     800611 <printnum+0x75>
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	72 05                	jb     8005c6 <printnum+0x2a>
  8005c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c4:	77 4b                	ja     800611 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005dc:	e8 ab 13 00 00       	call   80198c <__udivdi3>
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	ff 75 20             	pushl  0x20(%ebp)
  8005ea:	53                   	push   %ebx
  8005eb:	ff 75 18             	pushl  0x18(%ebp)
  8005ee:	52                   	push   %edx
  8005ef:	50                   	push   %eax
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	ff 75 08             	pushl  0x8(%ebp)
  8005f6:	e8 a1 ff ff ff       	call   80059c <printnum>
  8005fb:	83 c4 20             	add    $0x20,%esp
  8005fe:	eb 1a                	jmp    80061a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 20             	pushl  0x20(%ebp)
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	ff d0                	call   *%eax
  80060e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800611:	ff 4d 1c             	decl   0x1c(%ebp)
  800614:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800618:	7f e6                	jg     800600 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80061d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800628:	53                   	push   %ebx
  800629:	51                   	push   %ecx
  80062a:	52                   	push   %edx
  80062b:	50                   	push   %eax
  80062c:	e8 6b 14 00 00       	call   801a9c <__umoddi3>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	05 54 21 80 00       	add    $0x802154,%eax
  800639:	8a 00                	mov    (%eax),%al
  80063b:	0f be c0             	movsbl %al,%eax
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	50                   	push   %eax
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	ff d0                	call   *%eax
  80064a:	83 c4 10             	add    $0x10,%esp
}
  80064d:	90                   	nop
  80064e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800656:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065a:	7e 1c                	jle    800678 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	8d 50 08             	lea    0x8(%eax),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	89 10                	mov    %edx,(%eax)
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	83 e8 08             	sub    $0x8,%eax
  800671:	8b 50 04             	mov    0x4(%eax),%edx
  800674:	8b 00                	mov    (%eax),%eax
  800676:	eb 40                	jmp    8006b8 <getuint+0x65>
	else if (lflag)
  800678:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80067c:	74 1e                	je     80069c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 50 04             	lea    0x4(%eax),%edx
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	89 10                	mov    %edx,(%eax)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 e8 04             	sub    $0x4,%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	eb 1c                	jmp    8006b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 10                	mov    %edx,(%eax)
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	83 e8 04             	sub    $0x4,%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b8:	5d                   	pop    %ebp
  8006b9:	c3                   	ret    

008006ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c1:	7e 1c                	jle    8006df <getint+0x25>
		return va_arg(*ap, long long);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 08             	sub    $0x8,%eax
  8006d8:	8b 50 04             	mov    0x4(%eax),%edx
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	eb 38                	jmp    800717 <getint+0x5d>
	else if (lflag)
  8006df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e3:	74 1a                	je     8006ff <getint+0x45>
		return va_arg(*ap, long);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
  8006fd:	eb 18                	jmp    800717 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	89 10                	mov    %edx,(%eax)
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	99                   	cltd   
}
  800717:	5d                   	pop    %ebp
  800718:	c3                   	ret    

00800719 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	56                   	push   %esi
  80071d:	53                   	push   %ebx
  80071e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800721:	eb 17                	jmp    80073a <vprintfmt+0x21>
			if (ch == '\0')
  800723:	85 db                	test   %ebx,%ebx
  800725:	0f 84 c1 03 00 00    	je     800aec <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	53                   	push   %ebx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	8d 50 01             	lea    0x1(%eax),%edx
  800740:	89 55 10             	mov    %edx,0x10(%ebp)
  800743:	8a 00                	mov    (%eax),%al
  800745:	0f b6 d8             	movzbl %al,%ebx
  800748:	83 fb 25             	cmp    $0x25,%ebx
  80074b:	75 d6                	jne    800723 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80074d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800751:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800758:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800766:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	8d 50 01             	lea    0x1(%eax),%edx
  800773:	89 55 10             	mov    %edx,0x10(%ebp)
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f b6 d8             	movzbl %al,%ebx
  80077b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80077e:	83 f8 5b             	cmp    $0x5b,%eax
  800781:	0f 87 3d 03 00 00    	ja     800ac4 <vprintfmt+0x3ab>
  800787:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  80078e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800790:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800794:	eb d7                	jmp    80076d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800796:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079a:	eb d1                	jmp    80076d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a6:	89 d0                	mov    %edx,%eax
  8007a8:	c1 e0 02             	shl    $0x2,%eax
  8007ab:	01 d0                	add    %edx,%eax
  8007ad:	01 c0                	add    %eax,%eax
  8007af:	01 d8                	add    %ebx,%eax
  8007b1:	83 e8 30             	sub    $0x30,%eax
  8007b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	8a 00                	mov    (%eax),%al
  8007bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c2:	7e 3e                	jle    800802 <vprintfmt+0xe9>
  8007c4:	83 fb 39             	cmp    $0x39,%ebx
  8007c7:	7f 39                	jg     800802 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007cc:	eb d5                	jmp    8007a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 c0 04             	add    $0x4,%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e2:	eb 1f                	jmp    800803 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e8:	79 83                	jns    80076d <vprintfmt+0x54>
				width = 0;
  8007ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f1:	e9 77 ff ff ff       	jmp    80076d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007fd:	e9 6b ff ff ff       	jmp    80076d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800802:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	0f 89 60 ff ff ff    	jns    80076d <vprintfmt+0x54>
				width = precision, precision = -1;
  80080d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800813:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081a:	e9 4e ff ff ff       	jmp    80076d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800822:	e9 46 ff ff ff       	jmp    80076d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 e8 04             	sub    $0x4,%eax
  800836:	8b 00                	mov    (%eax),%eax
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	50                   	push   %eax
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			break;
  800847:	e9 9b 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 c0 04             	add    $0x4,%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	79 02                	jns    800863 <vprintfmt+0x14a>
				err = -err;
  800861:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800863:	83 fb 64             	cmp    $0x64,%ebx
  800866:	7f 0b                	jg     800873 <vprintfmt+0x15a>
  800868:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  80086f:	85 f6                	test   %esi,%esi
  800871:	75 19                	jne    80088c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800873:	53                   	push   %ebx
  800874:	68 65 21 80 00       	push   $0x802165
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	ff 75 08             	pushl  0x8(%ebp)
  80087f:	e8 70 02 00 00       	call   800af4 <printfmt>
  800884:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800887:	e9 5b 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80088c:	56                   	push   %esi
  80088d:	68 6e 21 80 00       	push   $0x80216e
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	e8 57 02 00 00       	call   800af4 <printfmt>
  80089d:	83 c4 10             	add    $0x10,%esp
			break;
  8008a0:	e9 42 02 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 30                	mov    (%eax),%esi
  8008b6:	85 f6                	test   %esi,%esi
  8008b8:	75 05                	jne    8008bf <vprintfmt+0x1a6>
				p = "(null)";
  8008ba:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	7e 6d                	jle    800932 <vprintfmt+0x219>
  8008c5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c9:	74 67                	je     800932 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	50                   	push   %eax
  8008d2:	56                   	push   %esi
  8008d3:	e8 1e 03 00 00       	call   800bf6 <strnlen>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008de:	eb 16                	jmp    8008f6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	7f e4                	jg     8008e0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fc:	eb 34                	jmp    800932 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800902:	74 1c                	je     800920 <vprintfmt+0x207>
  800904:	83 fb 1f             	cmp    $0x1f,%ebx
  800907:	7e 05                	jle    80090e <vprintfmt+0x1f5>
  800909:	83 fb 7e             	cmp    $0x7e,%ebx
  80090c:	7e 12                	jle    800920 <vprintfmt+0x207>
					putch('?', putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	6a 3f                	push   $0x3f
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	eb 0f                	jmp    80092f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	53                   	push   %ebx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092f:	ff 4d e4             	decl   -0x1c(%ebp)
  800932:	89 f0                	mov    %esi,%eax
  800934:	8d 70 01             	lea    0x1(%eax),%esi
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f be d8             	movsbl %al,%ebx
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	74 24                	je     800964 <vprintfmt+0x24b>
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	78 b8                	js     8008fe <vprintfmt+0x1e5>
  800946:	ff 4d e0             	decl   -0x20(%ebp)
  800949:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094d:	79 af                	jns    8008fe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094f:	eb 13                	jmp    800964 <vprintfmt+0x24b>
				putch(' ', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 20                	push   $0x20
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800968:	7f e7                	jg     800951 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096a:	e9 78 01 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 e8             	pushl  -0x18(%ebp)
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	50                   	push   %eax
  800979:	e8 3c fd ff ff       	call   8006ba <getint>
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800984:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	85 d2                	test   %edx,%edx
  80098f:	79 23                	jns    8009b4 <vprintfmt+0x29b>
				putch('-', putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	6a 2d                	push   $0x2d
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a7:	f7 d8                	neg    %eax
  8009a9:	83 d2 00             	adc    $0x0,%edx
  8009ac:	f7 da                	neg    %edx
  8009ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bb:	e9 bc 00 00 00       	jmp    800a7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c9:	50                   	push   %eax
  8009ca:	e8 84 fc ff ff       	call   800653 <getuint>
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009df:	e9 98 00 00 00       	jmp    800a7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 58                	push   $0x58
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 58                	push   $0x58
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 58                	push   $0x58
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			break;
  800a14:	e9 ce 00 00 00       	jmp    800ae7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 30                	push   $0x30
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	6a 78                	push   $0x78
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5b:	eb 1f                	jmp    800a7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 e8             	pushl  -0x18(%ebp)
  800a63:	8d 45 14             	lea    0x14(%ebp),%eax
  800a66:	50                   	push   %eax
  800a67:	e8 e7 fb ff ff       	call   800653 <getuint>
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a83:	83 ec 04             	sub    $0x4,%esp
  800a86:	52                   	push   %edx
  800a87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 00 fb ff ff       	call   80059c <printnum>
  800a9c:	83 c4 20             	add    $0x20,%esp
			break;
  800a9f:	eb 46                	jmp    800ae7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	53                   	push   %ebx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			break;
  800ab0:	eb 35                	jmp    800ae7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ab2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ab9:	eb 2c                	jmp    800ae7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800abb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ac2:	eb 23                	jmp    800ae7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 25                	push   $0x25
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad4:	ff 4d 10             	decl   0x10(%ebp)
  800ad7:	eb 03                	jmp    800adc <vprintfmt+0x3c3>
  800ad9:	ff 4d 10             	decl   0x10(%ebp)
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	48                   	dec    %eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	3c 25                	cmp    $0x25,%al
  800ae4:	75 f3                	jne    800ad9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ae6:	90                   	nop
		}
	}
  800ae7:	e9 35 fc ff ff       	jmp    800721 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afa:	8d 45 10             	lea    0x10(%ebp),%eax
  800afd:	83 c0 04             	add    $0x4,%eax
  800b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b03:	8b 45 10             	mov    0x10(%ebp),%eax
  800b06:	ff 75 f4             	pushl  -0xc(%ebp)
  800b09:	50                   	push   %eax
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	ff 75 08             	pushl  0x8(%ebp)
  800b10:	e8 04 fc ff ff       	call   800719 <vprintfmt>
  800b15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b18:	90                   	nop
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 40 08             	mov    0x8(%eax),%eax
  800b24:	8d 50 01             	lea    0x1(%eax),%edx
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	8b 10                	mov    (%eax),%edx
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	8b 40 04             	mov    0x4(%eax),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	73 12                	jae    800b4e <sprintputch+0x33>
		*b->buf++ = ch;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	8d 48 01             	lea    0x1(%eax),%ecx
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	89 0a                	mov    %ecx,(%edx)
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	88 10                	mov    %dl,(%eax)
}
  800b4e:	90                   	nop
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
  800b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b76:	74 06                	je     800b7e <vsnprintf+0x2d>
  800b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7c:	7f 07                	jg     800b85 <vsnprintf+0x34>
		return -E_INVAL;
  800b7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b83:	eb 20                	jmp    800ba5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b85:	ff 75 14             	pushl  0x14(%ebp)
  800b88:	ff 75 10             	pushl  0x10(%ebp)
  800b8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b8e:	50                   	push   %eax
  800b8f:	68 1b 0b 80 00       	push   $0x800b1b
  800b94:	e8 80 fb ff ff       	call   800719 <vprintfmt>
  800b99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bad:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	e8 89 ff ff ff       	call   800b51 <vsnprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be0:	eb 06                	jmp    800be8 <strlen+0x15>
		n++;
  800be2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be5:	ff 45 08             	incl   0x8(%ebp)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 f1                	jne    800be2 <strlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c03:	eb 09                	jmp    800c0e <strnlen+0x18>
		n++;
  800c05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c08:	ff 45 08             	incl   0x8(%ebp)
  800c0b:	ff 4d 0c             	decl   0xc(%ebp)
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	74 09                	je     800c1d <strnlen+0x27>
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 e8                	jne    800c05 <strnlen+0xf>
		n++;
	return n;
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c2e:	90                   	nop
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 08             	mov    %edx,0x8(%ebp)
  800c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	84 c0                	test   %al,%al
  800c49:	75 e4                	jne    800c2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c63:	eb 1f                	jmp    800c84 <strncpy+0x34>
		*dst++ = *src;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8d 50 01             	lea    0x1(%eax),%edx
  800c6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c71:	8a 12                	mov    (%edx),%dl
  800c73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	74 03                	je     800c81 <strncpy+0x31>
			src++;
  800c7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c81:	ff 45 fc             	incl   -0x4(%ebp)
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8a:	72 d9                	jb     800c65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca1:	74 30                	je     800cd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca3:	eb 16                	jmp    800cbb <strlcpy+0x2a>
			*dst++ = *src++;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8d 50 01             	lea    0x1(%eax),%edx
  800cab:	89 55 08             	mov    %edx,0x8(%ebp)
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb7:	8a 12                	mov    (%edx),%dl
  800cb9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbb:	ff 4d 10             	decl   0x10(%ebp)
  800cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc2:	74 09                	je     800ccd <strlcpy+0x3c>
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 d8                	jne    800ca5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd9:	29 c2                	sub    %eax,%edx
  800cdb:	89 d0                	mov    %edx,%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce2:	eb 06                	jmp    800cea <strcmp+0xb>
		p++, q++;
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	74 0e                	je     800d01 <strcmp+0x22>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 10                	mov    (%eax),%dl
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	38 c2                	cmp    %al,%dl
  800cff:	74 e3                	je     800ce4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	0f b6 d0             	movzbl %al,%edx
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	0f b6 c0             	movzbl %al,%eax
  800d11:	29 c2                	sub    %eax,%edx
  800d13:	89 d0                	mov    %edx,%eax
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1a:	eb 09                	jmp    800d25 <strncmp+0xe>
		n--, p++, q++;
  800d1c:	ff 4d 10             	decl   0x10(%ebp)
  800d1f:	ff 45 08             	incl   0x8(%ebp)
  800d22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d29:	74 17                	je     800d42 <strncmp+0x2b>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	74 0e                	je     800d42 <strncmp+0x2b>
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 10                	mov    (%eax),%dl
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	38 c2                	cmp    %al,%dl
  800d40:	74 da                	je     800d1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d46:	75 07                	jne    800d4f <strncmp+0x38>
		return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb 14                	jmp    800d63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f b6 d0             	movzbl %al,%edx
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	0f b6 c0             	movzbl %al,%eax
  800d5f:	29 c2                	sub    %eax,%edx
  800d61:	89 d0                	mov    %edx,%eax
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d71:	eb 12                	jmp    800d85 <strchr+0x20>
		if (*s == c)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7b:	75 05                	jne    800d82 <strchr+0x1d>
			return (char *) s;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	eb 11                	jmp    800d93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d82:	ff 45 08             	incl   0x8(%ebp)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	84 c0                	test   %al,%al
  800d8c:	75 e5                	jne    800d73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 04             	sub    $0x4,%esp
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da1:	eb 0d                	jmp    800db0 <strfind+0x1b>
		if (*s == c)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dab:	74 0e                	je     800dbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	75 ea                	jne    800da3 <strfind+0xe>
  800db9:	eb 01                	jmp    800dbc <strfind+0x27>
		if (*s == c)
			break;
  800dbb:	90                   	nop
	return (char *) s;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dcd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dd1:	76 63                	jbe    800e36 <memset+0x75>
		uint64 data_block = c;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	99                   	cltd   
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800de7:	c1 e0 08             	shl    $0x8,%eax
  800dea:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ded:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dfa:	c1 e0 10             	shl    $0x10,%eax
  800dfd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e00:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e09:	89 c2                	mov    %eax,%edx
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e10:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e13:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e16:	eb 18                	jmp    800e30 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e18:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e1b:	8d 41 08             	lea    0x8(%ecx),%eax
  800e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e27:	89 01                	mov    %eax,(%ecx)
  800e29:	89 51 04             	mov    %edx,0x4(%ecx)
  800e2c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e34:	77 e2                	ja     800e18 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3a:	74 23                	je     800e5f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 0e                	jmp    800e52 <memset+0x91>
			*p8++ = (uint8)c;
  800e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e47:	8d 50 01             	lea    0x1(%eax),%edx
  800e4a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e50:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e58:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	75 e5                	jne    800e44 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e76:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e7a:	76 24                	jbe    800ea0 <memcpy+0x3c>
		while(n >= 8){
  800e7c:	eb 1c                	jmp    800e9a <memcpy+0x36>
			*d64 = *s64;
  800e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e81:	8b 50 04             	mov    0x4(%eax),%edx
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e89:	89 01                	mov    %eax,(%ecx)
  800e8b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e8e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e92:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e96:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e9a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e9e:	77 de                	ja     800e7e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea4:	74 31                	je     800ed7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800eb2:	eb 16                	jmp    800eca <memcpy+0x66>
			*d8++ = *s8++;
  800eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb7:	8d 50 01             	lea    0x1(%eax),%edx
  800eba:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	75 dd                	jne    800eb4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef4:	73 50                	jae    800f46 <memmove+0x6a>
  800ef6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 d0                	add    %edx,%eax
  800efe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f01:	76 43                	jbe    800f46 <memmove+0x6a>
		s += n;
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f0f:	eb 10                	jmp    800f21 <memmove+0x45>
			*--d = *--s;
  800f11:	ff 4d f8             	decl   -0x8(%ebp)
  800f14:	ff 4d fc             	decl   -0x4(%ebp)
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 10                	mov    (%eax),%dl
  800f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f27:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	75 e3                	jne    800f11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f2e:	eb 23                	jmp    800f53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f33:	8d 50 01             	lea    0x1(%eax),%edx
  800f36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f42:	8a 12                	mov    (%edx),%dl
  800f44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	75 dd                	jne    800f30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f6a:	eb 2a                	jmp    800f96 <memcmp+0x3e>
		if (*s1 != *s2)
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	8a 10                	mov    (%eax),%dl
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	38 c2                	cmp    %al,%dl
  800f78:	74 16                	je     800f90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	0f b6 d0             	movzbl %al,%edx
  800f82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	0f b6 c0             	movzbl %al,%eax
  800f8a:	29 c2                	sub    %eax,%edx
  800f8c:	89 d0                	mov    %edx,%eax
  800f8e:	eb 18                	jmp    800fa8 <memcmp+0x50>
		s1++, s2++;
  800f90:	ff 45 fc             	incl   -0x4(%ebp)
  800f93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	75 c9                	jne    800f6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 d0                	add    %edx,%eax
  800fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fbb:	eb 15                	jmp    800fd2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	0f b6 d0             	movzbl %al,%edx
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	0f b6 c0             	movzbl %al,%eax
  800fcb:	39 c2                	cmp    %eax,%edx
  800fcd:	74 0d                	je     800fdc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fd8:	72 e3                	jb     800fbd <memfind+0x13>
  800fda:	eb 01                	jmp    800fdd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fdc:	90                   	nop
	return (void *) s;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff6:	eb 03                	jmp    800ffb <strtol+0x19>
		s++;
  800ff8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 20                	cmp    $0x20,%al
  801002:	74 f4                	je     800ff8 <strtol+0x16>
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 09                	cmp    $0x9,%al
  80100b:	74 eb                	je     800ff8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 2b                	cmp    $0x2b,%al
  801014:	75 05                	jne    80101b <strtol+0x39>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	eb 13                	jmp    80102e <strtol+0x4c>
	else if (*s == '-')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 2d                	cmp    $0x2d,%al
  801022:	75 0a                	jne    80102e <strtol+0x4c>
		s++, neg = 1;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80102e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801032:	74 06                	je     80103a <strtol+0x58>
  801034:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801038:	75 20                	jne    80105a <strtol+0x78>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 17                	jne    80105a <strtol+0x78>
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	40                   	inc    %eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 78                	cmp    $0x78,%al
  80104b:	75 0d                	jne    80105a <strtol+0x78>
		s += 2, base = 16;
  80104d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801051:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801058:	eb 28                	jmp    801082 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80105a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105e:	75 15                	jne    801075 <strtol+0x93>
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	3c 30                	cmp    $0x30,%al
  801067:	75 0c                	jne    801075 <strtol+0x93>
		s++, base = 8;
  801069:	ff 45 08             	incl   0x8(%ebp)
  80106c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801073:	eb 0d                	jmp    801082 <strtol+0xa0>
	else if (base == 0)
  801075:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801079:	75 07                	jne    801082 <strtol+0xa0>
		base = 10;
  80107b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 2f                	cmp    $0x2f,%al
  801089:	7e 19                	jle    8010a4 <strtol+0xc2>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 39                	cmp    $0x39,%al
  801092:	7f 10                	jg     8010a4 <strtol+0xc2>
			dig = *s - '0';
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	0f be c0             	movsbl %al,%eax
  80109c:	83 e8 30             	sub    $0x30,%eax
  80109f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a2:	eb 42                	jmp    8010e6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 60                	cmp    $0x60,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xe4>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 7a                	cmp    $0x7a,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 57             	sub    $0x57,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 20                	jmp    8010e6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 40                	cmp    $0x40,%al
  8010cd:	7e 39                	jle    801108 <strtol+0x126>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 5a                	cmp    $0x5a,%al
  8010d6:	7f 30                	jg     801108 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 37             	sub    $0x37,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ec:	7d 19                	jge    801107 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010ee:	ff 45 08             	incl   0x8(%ebp)
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010f8:	89 c2                	mov    %eax,%edx
  8010fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801102:	e9 7b ff ff ff       	jmp    801082 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801107:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110c:	74 08                	je     801116 <strtol+0x134>
		*endptr = (char *) s;
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
  801114:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801116:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80111a:	74 07                	je     801123 <strtol+0x141>
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	f7 d8                	neg    %eax
  801121:	eb 03                	jmp    801126 <strtol+0x144>
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <ltostr>:

void
ltostr(long value, char *str)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80113c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801140:	79 13                	jns    801155 <ltostr+0x2d>
	{
		neg = 1;
  801142:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80114f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801152:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80115d:	99                   	cltd   
  80115e:	f7 f9                	idiv   %ecx
  801160:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116c:	89 c2                	mov    %eax,%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	01 d0                	add    %edx,%eax
  801173:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801176:	83 c2 30             	add    $0x30,%edx
  801179:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80117b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801183:	f7 e9                	imul   %ecx
  801185:	c1 fa 02             	sar    $0x2,%edx
  801188:	89 c8                	mov    %ecx,%eax
  80118a:	c1 f8 1f             	sar    $0x1f,%eax
  80118d:	29 c2                	sub    %eax,%edx
  80118f:	89 d0                	mov    %edx,%eax
  801191:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801198:	75 bb                	jne    801155 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80119a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	48                   	dec    %eax
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ac:	74 3d                	je     8011eb <ltostr+0xc3>
		start = 1 ;
  8011ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011b5:	eb 34                	jmp    8011eb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c2                	add    %eax,%edx
  8011cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c8                	add    %ecx,%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	01 c2                	add    %eax,%edx
  8011e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8011e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f1:	7c c4                	jl     8011b7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	01 d0                	add    %edx,%eax
  8011fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011fe:	90                   	nop
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801207:	ff 75 08             	pushl  0x8(%ebp)
  80120a:	e8 c4 f9 ff ff       	call   800bd3 <strlen>
  80120f:	83 c4 04             	add    $0x4,%esp
  801212:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801215:	ff 75 0c             	pushl  0xc(%ebp)
  801218:	e8 b6 f9 ff ff       	call   800bd3 <strlen>
  80121d:	83 c4 04             	add    $0x4,%esp
  801220:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801231:	eb 17                	jmp    80124a <strcconcat+0x49>
		final[s] = str1[s] ;
  801233:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	01 c8                	add    %ecx,%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801247:	ff 45 fc             	incl   -0x4(%ebp)
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801250:	7c e1                	jl     801233 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801259:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801260:	eb 1f                	jmp    801281 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801265:	8d 50 01             	lea    0x1(%eax),%edx
  801268:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	01 c2                	add    %eax,%edx
  801272:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	01 c8                	add    %ecx,%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80127e:	ff 45 f8             	incl   -0x8(%ebp)
  801281:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801284:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801287:	7c d9                	jl     801262 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801289:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)
}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80129a:	8b 45 14             	mov    0x14(%ebp),%eax
  80129d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a6:	8b 00                	mov    (%eax),%eax
  8012a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 d0                	add    %edx,%eax
  8012b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ba:	eb 0c                	jmp    8012c8 <strsplit+0x31>
			*string++ = 0;
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8d 50 01             	lea    0x1(%eax),%edx
  8012c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 18                	je     8012e9 <strsplit+0x52>
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	0f be c0             	movsbl %al,%eax
  8012d9:	50                   	push   %eax
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	e8 83 fa ff ff       	call   800d65 <strchr>
  8012e2:	83 c4 08             	add    $0x8,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 d3                	jne    8012bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	84 c0                	test   %al,%al
  8012f0:	74 5a                	je     80134c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	8b 00                	mov    (%eax),%eax
  8012f7:	83 f8 0f             	cmp    $0xf,%eax
  8012fa:	75 07                	jne    801303 <strsplit+0x6c>
		{
			return 0;
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801301:	eb 66                	jmp    801369 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801303:	8b 45 14             	mov    0x14(%ebp),%eax
  801306:	8b 00                	mov    (%eax),%eax
  801308:	8d 48 01             	lea    0x1(%eax),%ecx
  80130b:	8b 55 14             	mov    0x14(%ebp),%edx
  80130e:	89 0a                	mov    %ecx,(%edx)
  801310:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801317:	8b 45 10             	mov    0x10(%ebp),%eax
  80131a:	01 c2                	add    %eax,%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801321:	eb 03                	jmp    801326 <strsplit+0x8f>
			string++;
  801323:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 8b                	je     8012ba <strsplit+0x23>
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	0f be c0             	movsbl %al,%eax
  801337:	50                   	push   %eax
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	e8 25 fa ff ff       	call   800d65 <strchr>
  801340:	83 c4 08             	add    $0x8,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	74 dc                	je     801323 <strsplit+0x8c>
			string++;
	}
  801347:	e9 6e ff ff ff       	jmp    8012ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80134c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80134d:	8b 45 14             	mov    0x14(%ebp),%eax
  801350:	8b 00                	mov    (%eax),%eax
  801352:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801359:	8b 45 10             	mov    0x10(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801364:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801377:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137e:	eb 4a                	jmp    8013ca <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801380:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	01 c2                	add    %eax,%edx
  801388:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	01 c8                	add    %ecx,%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801394:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 40                	cmp    $0x40,%al
  8013a0:	7e 25                	jle    8013c7 <str2lower+0x5c>
  8013a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	3c 5a                	cmp    $0x5a,%al
  8013ae:	7f 17                	jg     8013c7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013be:	01 ca                	add    %ecx,%edx
  8013c0:	8a 12                	mov    (%edx),%dl
  8013c2:	83 c2 20             	add    $0x20,%edx
  8013c5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013c7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	e8 01 f8 ff ff       	call   800bd3 <strlen>
  8013d2:	83 c4 04             	add    $0x4,%esp
  8013d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013d8:	7f a6                	jg     801380 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	57                   	push   %edi
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013fa:	cd 30                	int    $0x30
  8013fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5f                   	pop    %edi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	8b 45 10             	mov    0x10(%ebp),%eax
  801413:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801416:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801419:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	6a 00                	push   $0x0
  801422:	51                   	push   %ecx
  801423:	52                   	push   %edx
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	50                   	push   %eax
  801428:	6a 00                	push   $0x0
  80142a:	e8 b0 ff ff ff       	call   8013df <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	90                   	nop
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_cgetc>:

int
sys_cgetc(void)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 02                	push   $0x2
  801444:	e8 96 ff ff ff       	call   8013df <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 03                	push   $0x3
  80145d:	e8 7d ff ff ff       	call   8013df <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 04                	push   $0x4
  801477:	e8 63 ff ff ff       	call   8013df <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	52                   	push   %edx
  801492:	50                   	push   %eax
  801493:	6a 08                	push   $0x8
  801495:	e8 45 ff ff ff       	call   8013df <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8014a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
  8014b5:	51                   	push   %ecx
  8014b6:	52                   	push   %edx
  8014b7:	50                   	push   %eax
  8014b8:	6a 09                	push   $0x9
  8014ba:	e8 20 ff ff ff       	call   8013df <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	ff 75 08             	pushl  0x8(%ebp)
  8014d7:	6a 0a                	push   $0xa
  8014d9:	e8 01 ff ff ff       	call   8013df <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	ff 75 08             	pushl  0x8(%ebp)
  8014f2:	6a 0b                	push   $0xb
  8014f4:	e8 e6 fe ff ff       	call   8013df <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 0c                	push   $0xc
  80150d:	e8 cd fe ff ff       	call   8013df <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 0d                	push   $0xd
  801526:	e8 b4 fe ff ff       	call   8013df <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 0e                	push   $0xe
  80153f:	e8 9b fe ff ff       	call   8013df <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 0f                	push   $0xf
  801558:	e8 82 fe ff ff       	call   8013df <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	6a 10                	push   $0x10
  801572:	e8 68 fe ff ff       	call   8013df <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 11                	push   $0x11
  80158b:	e8 4f fe ff ff       	call   8013df <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	90                   	nop
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_cputc>:

void
sys_cputc(const char c)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	50                   	push   %eax
  8015af:	6a 01                	push   $0x1
  8015b1:	e8 29 fe ff ff       	call   8013df <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	90                   	nop
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 14                	push   $0x14
  8015cb:	e8 0f fe ff ff       	call   8013df <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	51                   	push   %ecx
  8015ef:	52                   	push   %edx
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	50                   	push   %eax
  8015f4:	6a 15                	push   $0x15
  8015f6:	e8 e4 fd ff ff       	call   8013df <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801603:	8b 55 0c             	mov    0xc(%ebp),%edx
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	52                   	push   %edx
  801610:	50                   	push   %eax
  801611:	6a 16                	push   $0x16
  801613:	e8 c7 fd ff ff       	call   8013df <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	51                   	push   %ecx
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 17                	push   $0x17
  801632:	e8 a8 fd ff ff       	call   8013df <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 18                	push   $0x18
  80164f:	e8 8b fd ff ff       	call   8013df <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	ff 75 14             	pushl  0x14(%ebp)
  801664:	ff 75 10             	pushl  0x10(%ebp)
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	50                   	push   %eax
  80166b:	6a 19                	push   $0x19
  80166d:	e8 6d fd ff ff       	call   8013df <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	50                   	push   %eax
  801686:	6a 1a                	push   $0x1a
  801688:	e8 52 fd ff ff       	call   8013df <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	50                   	push   %eax
  8016a2:	6a 1b                	push   $0x1b
  8016a4:	e8 36 fd ff ff       	call   8013df <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 05                	push   $0x5
  8016bd:	e8 1d fd ff ff       	call   8013df <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 06                	push   $0x6
  8016d6:	e8 04 fd ff ff       	call   8013df <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 07                	push   $0x7
  8016ef:	e8 eb fc ff ff       	call   8013df <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 1c                	push   $0x1c
  801708:	e8 d2 fc ff ff       	call   8013df <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801719:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80171c:	8d 50 04             	lea    0x4(%eax),%edx
  80171f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	52                   	push   %edx
  801729:	50                   	push   %eax
  80172a:	6a 1d                	push   $0x1d
  80172c:	e8 ae fc ff ff       	call   8013df <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
	return result;
  801734:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801737:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173d:	89 01                	mov    %eax,(%ecx)
  80173f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	c9                   	leave  
  801746:	c2 04 00             	ret    $0x4

00801749 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	ff 75 10             	pushl  0x10(%ebp)
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	ff 75 08             	pushl  0x8(%ebp)
  801759:	6a 13                	push   $0x13
  80175b:	e8 7f fc ff ff       	call   8013df <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
	return ;
  801763:	90                   	nop
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_rcr2>:
uint32 sys_rcr2()
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 1e                	push   $0x1e
  801775:	e8 65 fc ff ff       	call   8013df <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80178b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	50                   	push   %eax
  801798:	6a 1f                	push   $0x1f
  80179a:	e8 40 fc ff ff       	call   8013df <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a2:	90                   	nop
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <rsttst>:
void rsttst()
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 21                	push   $0x21
  8017b4:	e8 26 fc ff ff       	call   8013df <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bc:	90                   	nop
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8017ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d2:	52                   	push   %edx
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 10             	pushl  0x10(%ebp)
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	6a 20                	push   $0x20
  8017df:	e8 fb fb ff ff       	call   8013df <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e7:	90                   	nop
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <chktst>:
void chktst(uint32 n)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 22                	push   $0x22
  8017fa:	e8 e0 fb ff ff       	call   8013df <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <inctst>:

void inctst()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 23                	push   $0x23
  801814:	e8 c6 fb ff ff       	call   8013df <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
	return ;
  80181c:	90                   	nop
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <gettst>:
uint32 gettst()
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 24                	push   $0x24
  80182e:	e8 ac fb ff ff       	call   8013df <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 25                	push   $0x25
  801847:	e8 93 fb ff ff       	call   8013df <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
  80184f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801854:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	6a 26                	push   $0x26
  801873:	e8 67 fb ff ff       	call   8013df <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
	return ;
  80187b:	90                   	nop
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801882:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	53                   	push   %ebx
  801891:	51                   	push   %ecx
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 27                	push   $0x27
  801896:	e8 44 fb ff ff       	call   8013df <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 28                	push   $0x28
  8018b6:	e8 24 fb ff ff       	call   8013df <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	51                   	push   %ecx
  8018cf:	ff 75 10             	pushl  0x10(%ebp)
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 29                	push   $0x29
  8018d6:	e8 04 fb ff ff       	call   8013df <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 12                	push   $0x12
  8018f2:	e8 e8 fa ff ff       	call   8013df <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fa:	90                   	nop
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 2a                	push   $0x2a
  801910:	e8 ca fa ff ff       	call   8013df <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
	return;
  801918:	90                   	nop
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 2b                	push   $0x2b
  80192a:	e8 b0 fa ff ff       	call   8013df <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 2d                	push   $0x2d
  801945:	e8 95 fa ff ff       	call   8013df <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
	return;
  80194d:	90                   	nop
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	6a 2c                	push   $0x2c
  801961:	e8 79 fa ff ff       	call   8013df <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return ;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 e8 22 80 00       	push   $0x8022e8
  80197a:	68 25 01 00 00       	push   $0x125
  80197f:	68 1b 23 80 00       	push   $0x80231b
  801984:	e8 a3 e8 ff ff       	call   80022c <_panic>
  801989:	66 90                	xchg   %ax,%ax
  80198b:	90                   	nop

0080198c <__udivdi3>:
  80198c:	55                   	push   %ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
  801993:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801997:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80199b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80199f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019a3:	89 ca                	mov    %ecx,%edx
  8019a5:	89 f8                	mov    %edi,%eax
  8019a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019ab:	85 f6                	test   %esi,%esi
  8019ad:	75 2d                	jne    8019dc <__udivdi3+0x50>
  8019af:	39 cf                	cmp    %ecx,%edi
  8019b1:	77 65                	ja     801a18 <__udivdi3+0x8c>
  8019b3:	89 fd                	mov    %edi,%ebp
  8019b5:	85 ff                	test   %edi,%edi
  8019b7:	75 0b                	jne    8019c4 <__udivdi3+0x38>
  8019b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019be:	31 d2                	xor    %edx,%edx
  8019c0:	f7 f7                	div    %edi
  8019c2:	89 c5                	mov    %eax,%ebp
  8019c4:	31 d2                	xor    %edx,%edx
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	f7 f5                	div    %ebp
  8019ca:	89 c1                	mov    %eax,%ecx
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	f7 f5                	div    %ebp
  8019d0:	89 cf                	mov    %ecx,%edi
  8019d2:	89 fa                	mov    %edi,%edx
  8019d4:	83 c4 1c             	add    $0x1c,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	77 28                	ja     801a08 <__udivdi3+0x7c>
  8019e0:	0f bd fe             	bsr    %esi,%edi
  8019e3:	83 f7 1f             	xor    $0x1f,%edi
  8019e6:	75 40                	jne    801a28 <__udivdi3+0x9c>
  8019e8:	39 ce                	cmp    %ecx,%esi
  8019ea:	72 0a                	jb     8019f6 <__udivdi3+0x6a>
  8019ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f0:	0f 87 9e 00 00 00    	ja     801a94 <__udivdi3+0x108>
  8019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fb:	89 fa                	mov    %edi,%edx
  8019fd:	83 c4 1c             	add    $0x1c,%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5f                   	pop    %edi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    
  801a05:	8d 76 00             	lea    0x0(%esi),%esi
  801a08:	31 ff                	xor    %edi,%edi
  801a0a:	31 c0                	xor    %eax,%eax
  801a0c:	89 fa                	mov    %edi,%edx
  801a0e:	83 c4 1c             	add    $0x1c,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5f                   	pop    %edi
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    
  801a16:	66 90                	xchg   %ax,%ax
  801a18:	89 d8                	mov    %ebx,%eax
  801a1a:	f7 f7                	div    %edi
  801a1c:	31 ff                	xor    %edi,%edi
  801a1e:	89 fa                	mov    %edi,%edx
  801a20:	83 c4 1c             	add    $0x1c,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    
  801a28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a2d:	89 eb                	mov    %ebp,%ebx
  801a2f:	29 fb                	sub    %edi,%ebx
  801a31:	89 f9                	mov    %edi,%ecx
  801a33:	d3 e6                	shl    %cl,%esi
  801a35:	89 c5                	mov    %eax,%ebp
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 ed                	shr    %cl,%ebp
  801a3b:	89 e9                	mov    %ebp,%ecx
  801a3d:	09 f1                	or     %esi,%ecx
  801a3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e0                	shl    %cl,%eax
  801a47:	89 c5                	mov    %eax,%ebp
  801a49:	89 d6                	mov    %edx,%esi
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 ee                	shr    %cl,%esi
  801a4f:	89 f9                	mov    %edi,%ecx
  801a51:	d3 e2                	shl    %cl,%edx
  801a53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a57:	88 d9                	mov    %bl,%cl
  801a59:	d3 e8                	shr    %cl,%eax
  801a5b:	09 c2                	or     %eax,%edx
  801a5d:	89 d0                	mov    %edx,%eax
  801a5f:	89 f2                	mov    %esi,%edx
  801a61:	f7 74 24 0c          	divl   0xc(%esp)
  801a65:	89 d6                	mov    %edx,%esi
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	f7 e5                	mul    %ebp
  801a6b:	39 d6                	cmp    %edx,%esi
  801a6d:	72 19                	jb     801a88 <__udivdi3+0xfc>
  801a6f:	74 0b                	je     801a7c <__udivdi3+0xf0>
  801a71:	89 d8                	mov    %ebx,%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 58 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a80:	89 f9                	mov    %edi,%ecx
  801a82:	d3 e2                	shl    %cl,%edx
  801a84:	39 c2                	cmp    %eax,%edx
  801a86:	73 e9                	jae    801a71 <__udivdi3+0xe5>
  801a88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a8b:	31 ff                	xor    %edi,%edi
  801a8d:	e9 40 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	31 c0                	xor    %eax,%eax
  801a96:	e9 37 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a9b:	90                   	nop

00801a9c <__umoddi3>:
  801a9c:	55                   	push   %ebp
  801a9d:	57                   	push   %edi
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 1c             	sub    $0x1c,%esp
  801aa3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aa7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ab3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abb:	89 f3                	mov    %esi,%ebx
  801abd:	89 fa                	mov    %edi,%edx
  801abf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac3:	89 34 24             	mov    %esi,(%esp)
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	75 1a                	jne    801ae4 <__umoddi3+0x48>
  801aca:	39 f7                	cmp    %esi,%edi
  801acc:	0f 86 a2 00 00 00    	jbe    801b74 <__umoddi3+0xd8>
  801ad2:	89 c8                	mov    %ecx,%eax
  801ad4:	89 f2                	mov    %esi,%edx
  801ad6:	f7 f7                	div    %edi
  801ad8:	89 d0                	mov    %edx,%eax
  801ada:	31 d2                	xor    %edx,%edx
  801adc:	83 c4 1c             	add    $0x1c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
  801ae4:	39 f0                	cmp    %esi,%eax
  801ae6:	0f 87 ac 00 00 00    	ja     801b98 <__umoddi3+0xfc>
  801aec:	0f bd e8             	bsr    %eax,%ebp
  801aef:	83 f5 1f             	xor    $0x1f,%ebp
  801af2:	0f 84 ac 00 00 00    	je     801ba4 <__umoddi3+0x108>
  801af8:	bf 20 00 00 00       	mov    $0x20,%edi
  801afd:	29 ef                	sub    %ebp,%edi
  801aff:	89 fe                	mov    %edi,%esi
  801b01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e0                	shl    %cl,%eax
  801b09:	89 d7                	mov    %edx,%edi
  801b0b:	89 f1                	mov    %esi,%ecx
  801b0d:	d3 ef                	shr    %cl,%edi
  801b0f:	09 c7                	or     %eax,%edi
  801b11:	89 e9                	mov    %ebp,%ecx
  801b13:	d3 e2                	shl    %cl,%edx
  801b15:	89 14 24             	mov    %edx,(%esp)
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	d3 e0                	shl    %cl,%eax
  801b1c:	89 c2                	mov    %eax,%edx
  801b1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b22:	d3 e0                	shl    %cl,%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2c:	89 f1                	mov    %esi,%ecx
  801b2e:	d3 e8                	shr    %cl,%eax
  801b30:	09 d0                	or     %edx,%eax
  801b32:	d3 eb                	shr    %cl,%ebx
  801b34:	89 da                	mov    %ebx,%edx
  801b36:	f7 f7                	div    %edi
  801b38:	89 d3                	mov    %edx,%ebx
  801b3a:	f7 24 24             	mull   (%esp)
  801b3d:	89 c6                	mov    %eax,%esi
  801b3f:	89 d1                	mov    %edx,%ecx
  801b41:	39 d3                	cmp    %edx,%ebx
  801b43:	0f 82 87 00 00 00    	jb     801bd0 <__umoddi3+0x134>
  801b49:	0f 84 91 00 00 00    	je     801be0 <__umoddi3+0x144>
  801b4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b53:	29 f2                	sub    %esi,%edx
  801b55:	19 cb                	sbb    %ecx,%ebx
  801b57:	89 d8                	mov    %ebx,%eax
  801b59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b5d:	d3 e0                	shl    %cl,%eax
  801b5f:	89 e9                	mov    %ebp,%ecx
  801b61:	d3 ea                	shr    %cl,%edx
  801b63:	09 d0                	or     %edx,%eax
  801b65:	89 e9                	mov    %ebp,%ecx
  801b67:	d3 eb                	shr    %cl,%ebx
  801b69:	89 da                	mov    %ebx,%edx
  801b6b:	83 c4 1c             	add    $0x1c,%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5e                   	pop    %esi
  801b70:	5f                   	pop    %edi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    
  801b73:	90                   	nop
  801b74:	89 fd                	mov    %edi,%ebp
  801b76:	85 ff                	test   %edi,%edi
  801b78:	75 0b                	jne    801b85 <__umoddi3+0xe9>
  801b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7f:	31 d2                	xor    %edx,%edx
  801b81:	f7 f7                	div    %edi
  801b83:	89 c5                	mov    %eax,%ebp
  801b85:	89 f0                	mov    %esi,%eax
  801b87:	31 d2                	xor    %edx,%edx
  801b89:	f7 f5                	div    %ebp
  801b8b:	89 c8                	mov    %ecx,%eax
  801b8d:	f7 f5                	div    %ebp
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	e9 44 ff ff ff       	jmp    801ada <__umoddi3+0x3e>
  801b96:	66 90                	xchg   %ax,%ax
  801b98:	89 c8                	mov    %ecx,%eax
  801b9a:	89 f2                	mov    %esi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	3b 04 24             	cmp    (%esp),%eax
  801ba7:	72 06                	jb     801baf <__umoddi3+0x113>
  801ba9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bad:	77 0f                	ja     801bbe <__umoddi3+0x122>
  801baf:	89 f2                	mov    %esi,%edx
  801bb1:	29 f9                	sub    %edi,%ecx
  801bb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bb7:	89 14 24             	mov    %edx,(%esp)
  801bba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bc2:	8b 14 24             	mov    (%esp),%edx
  801bc5:	83 c4 1c             	add    $0x1c,%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
  801bcd:	8d 76 00             	lea    0x0(%esi),%esi
  801bd0:	2b 04 24             	sub    (%esp),%eax
  801bd3:	19 fa                	sbb    %edi,%edx
  801bd5:	89 d1                	mov    %edx,%ecx
  801bd7:	89 c6                	mov    %eax,%esi
  801bd9:	e9 71 ff ff ff       	jmp    801b4f <__umoddi3+0xb3>
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801be4:	72 ea                	jb     801bd0 <__umoddi3+0x134>
  801be6:	89 d9                	mov    %ebx,%ecx
  801be8:	e9 62 ff ff ff       	jmp    801b4f <__umoddi3+0xb3>
