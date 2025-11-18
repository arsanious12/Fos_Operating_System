
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 a4 00 00 00       	call   8000da <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 60 1c 80 00       	push   $0x801c60
  80005a:	e8 0e 05 00 00       	call   80056d <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 90 1c 80 00       	push   $0x801c90
  8000aa:	e8 be 04 00 00       	call   80056d <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 08             	sub    $0x8,%esp
	panic("update is required!!");
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 c9 1c 80 00       	push   $0x801cc9
  8000ce:	6a 18                	push   $0x18
  8000d0:	68 de 1c 80 00       	push   $0x801cde
  8000d5:	e8 c5 01 00 00       	call   80029f <_panic>

008000da <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
  8000e0:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e3:	e8 52 16 00 00       	call   80173a <sys_getenvindex>
  8000e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ee:	89 d0                	mov    %edx,%eax
  8000f0:	c1 e0 06             	shl    $0x6,%eax
  8000f3:	29 d0                	sub    %edx,%eax
  8000f5:	c1 e0 02             	shl    $0x2,%eax
  8000f8:	01 d0                	add    %edx,%eax
  8000fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800101:	01 c8                	add    %ecx,%eax
  800103:	c1 e0 03             	shl    $0x3,%eax
  800106:	01 d0                	add    %edx,%eax
  800108:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80010f:	29 c2                	sub    %eax,%edx
  800111:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800118:	89 c2                	mov    %eax,%edx
  80011a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800120:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800125:	a1 40 30 80 00       	mov    0x803040,%eax
  80012a:	8a 40 20             	mov    0x20(%eax),%al
  80012d:	84 c0                	test   %al,%al
  80012f:	74 0d                	je     80013e <libmain+0x64>
		binaryname = myEnv->prog_name;
  800131:	a1 40 30 80 00       	mov    0x803040,%eax
  800136:	83 c0 20             	add    $0x20,%eax
  800139:	a3 20 30 80 00       	mov    %eax,0x803020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800142:	7e 0a                	jle    80014e <libmain+0x74>
		binaryname = argv[0];
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	a3 20 30 80 00       	mov    %eax,0x803020

	// call user main routine
	_main(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 64 ff ff ff       	call   8000c0 <_main>
  80015c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80015f:	a1 1c 30 80 00       	mov    0x80301c,%eax
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 84 01 01 00 00    	je     80026d <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800172:	bb e8 1d 80 00       	mov    $0x801de8,%ebx
  800177:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017c:	89 c7                	mov    %eax,%edi
  80017e:	89 de                	mov    %ebx,%esi
  800180:	89 d1                	mov    %edx,%ecx
  800182:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800184:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800187:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018c:	b0 00                	mov    $0x0,%al
  80018e:	89 d7                	mov    %edx,%edi
  800190:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800192:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800199:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	50                   	push   %eax
  8001a0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a6:	50                   	push   %eax
  8001a7:	e8 c4 17 00 00       	call   801970 <sys_utilities>
  8001ac:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001af:	e8 0d 13 00 00       	call   8014c1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	68 08 1d 80 00       	push   $0x801d08
  8001bc:	e8 ac 03 00 00       	call   80056d <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	74 18                	je     8001e3 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001cb:	e8 be 17 00 00       	call   80198e <sys_get_optimal_num_faults>
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	50                   	push   %eax
  8001d4:	68 30 1d 80 00       	push   $0x801d30
  8001d9:	e8 8f 03 00 00       	call   80056d <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	eb 59                	jmp    80023c <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e3:	a1 40 30 80 00       	mov    0x803040,%eax
  8001e8:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001ee:	a1 40 30 80 00       	mov    0x803040,%eax
  8001f3:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	68 54 1d 80 00       	push   $0x801d54
  800203:	e8 65 03 00 00       	call   80056d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020b:	a1 40 30 80 00       	mov    0x803040,%eax
  800210:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800216:	a1 40 30 80 00       	mov    0x803040,%eax
  80021b:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800221:	a1 40 30 80 00       	mov    0x803040,%eax
  800226:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80022c:	51                   	push   %ecx
  80022d:	52                   	push   %edx
  80022e:	50                   	push   %eax
  80022f:	68 7c 1d 80 00       	push   $0x801d7c
  800234:	e8 34 03 00 00       	call   80056d <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023c:	a1 40 30 80 00       	mov    0x803040,%eax
  800241:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	50                   	push   %eax
  80024b:	68 d4 1d 80 00       	push   $0x801dd4
  800250:	e8 18 03 00 00       	call   80056d <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 08 1d 80 00       	push   $0x801d08
  800260:	e8 08 03 00 00       	call   80056d <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800268:	e8 6e 12 00 00       	call   8014db <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80026d:	e8 1f 00 00 00       	call   800291 <exit>
}
  800272:	90                   	nop
  800273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5f                   	pop    %edi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	6a 00                	push   $0x0
  800286:	e8 7b 14 00 00       	call   801706 <sys_destroy_env>
  80028b:	83 c4 10             	add    $0x10,%esp
}
  80028e:	90                   	nop
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <exit>:

void
exit(void)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800297:	e8 d0 14 00 00       	call   80176c <sys_exit_env>
}
  80029c:	90                   	nop
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a5:	8d 45 10             	lea    0x10(%ebp),%eax
  8002a8:	83 c0 04             	add    $0x4,%eax
  8002ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ae:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002b3:	85 c0                	test   %eax,%eax
  8002b5:	74 16                	je     8002cd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b7:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	50                   	push   %eax
  8002c0:	68 4c 1e 80 00       	push   $0x801e4c
  8002c5:	e8 a3 02 00 00       	call   80056d <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	ff 75 0c             	pushl  0xc(%ebp)
  8002d8:	ff 75 08             	pushl  0x8(%ebp)
  8002db:	50                   	push   %eax
  8002dc:	68 54 1e 80 00       	push   $0x801e54
  8002e1:	6a 74                	push   $0x74
  8002e3:	e8 b2 02 00 00       	call   80059a <cprintf_colored>
  8002e8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f4:	50                   	push   %eax
  8002f5:	e8 04 02 00 00       	call   8004fe <vcprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	6a 00                	push   $0x0
  800302:	68 7c 1e 80 00       	push   $0x801e7c
  800307:	e8 f2 01 00 00       	call   8004fe <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80030f:	e8 7d ff ff ff       	call   800291 <exit>

	// should not return here
	while (1) ;
  800314:	eb fe                	jmp    800314 <_panic+0x75>

00800316 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80031c:	a1 40 30 80 00       	mov    0x803040,%eax
  800321:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	39 c2                	cmp    %eax,%edx
  80032c:	74 14                	je     800342 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	68 80 1e 80 00       	push   $0x801e80
  800336:	6a 26                	push   $0x26
  800338:	68 cc 1e 80 00       	push   $0x801ecc
  80033d:	e8 5d ff ff ff       	call   80029f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800349:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800350:	e9 c5 00 00 00       	jmp    80041a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800358:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	01 d0                	add    %edx,%eax
  800364:	8b 00                	mov    (%eax),%eax
  800366:	85 c0                	test   %eax,%eax
  800368:	75 08                	jne    800372 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80036a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80036d:	e9 a5 00 00 00       	jmp    800417 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800372:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800379:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800380:	eb 69                	jmp    8003eb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800382:	a1 40 30 80 00       	mov    0x803040,%eax
  800387:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80038d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	01 c0                	add    %eax,%eax
  800394:	01 d0                	add    %edx,%eax
  800396:	c1 e0 03             	shl    $0x3,%eax
  800399:	01 c8                	add    %ecx,%eax
  80039b:	8a 40 04             	mov    0x4(%eax),%al
  80039e:	84 c0                	test   %al,%al
  8003a0:	75 46                	jne    8003e8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a2:	a1 40 30 80 00       	mov    0x803040,%eax
  8003a7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b0:	89 d0                	mov    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	c1 e0 03             	shl    $0x3,%eax
  8003b9:	01 c8                	add    %ecx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	01 c8                	add    %ecx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	75 09                	jne    8003e8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e6:	eb 15                	jmp    8003fd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	ff 45 e8             	incl   -0x18(%ebp)
  8003eb:	a1 40 30 80 00       	mov    0x803040,%eax
  8003f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f9:	39 c2                	cmp    %eax,%edx
  8003fb:	77 85                	ja     800382 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800401:	75 14                	jne    800417 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	68 d8 1e 80 00       	push   $0x801ed8
  80040b:	6a 3a                	push   $0x3a
  80040d:	68 cc 1e 80 00       	push   $0x801ecc
  800412:	e8 88 fe ff ff       	call   80029f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800417:	ff 45 f0             	incl   -0x10(%ebp)
  80041a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800420:	0f 8c 2f ff ff ff    	jl     800355 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800434:	eb 26                	jmp    80045c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800436:	a1 40 30 80 00       	mov    0x803040,%eax
  80043b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800444:	89 d0                	mov    %edx,%eax
  800446:	01 c0                	add    %eax,%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	c1 e0 03             	shl    $0x3,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	8a 40 04             	mov    0x4(%eax),%al
  800452:	3c 01                	cmp    $0x1,%al
  800454:	75 03                	jne    800459 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800459:	ff 45 e0             	incl   -0x20(%ebp)
  80045c:	a1 40 30 80 00       	mov    0x803040,%eax
  800461:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046a:	39 c2                	cmp    %eax,%edx
  80046c:	77 c8                	ja     800436 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800474:	74 14                	je     80048a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 2c 1f 80 00       	push   $0x801f2c
  80047e:	6a 44                	push   $0x44
  800480:	68 cc 1e 80 00       	push   $0x801ecc
  800485:	e8 15 fe ff ff       	call   80029f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80048a:	90                   	nop
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	53                   	push   %ebx
  800491:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800494:	8b 45 0c             	mov    0xc(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	8d 48 01             	lea    0x1(%eax),%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	89 0a                	mov    %ecx,(%edx)
  8004a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a4:	88 d1                	mov    %dl,%cl
  8004a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b7:	75 30                	jne    8004e9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004b9:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  8004bf:	a0 64 30 80 00       	mov    0x803064,%al
  8004c4:	0f b6 c0             	movzbl %al,%eax
  8004c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ca:	8b 09                	mov    (%ecx),%ecx
  8004cc:	89 cb                	mov    %ecx,%ebx
  8004ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d1:	83 c1 08             	add    $0x8,%ecx
  8004d4:	52                   	push   %edx
  8004d5:	50                   	push   %eax
  8004d6:	53                   	push   %ebx
  8004d7:	51                   	push   %ecx
  8004d8:	e8 a0 0f 00 00       	call   80147d <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800507:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050e:	00 00 00 
	b.cnt = 0;
  800511:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800518:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	68 8d 04 80 00       	push   $0x80048d
  80052d:	e8 5a 02 00 00       	call   80078c <vprintfmt>
  800532:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800535:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  80053b:	a0 64 30 80 00       	mov    0x803064,%al
  800540:	0f b6 c0             	movzbl %al,%eax
  800543:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	51                   	push   %ecx
  80054c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800552:	83 c0 08             	add    $0x8,%eax
  800555:	50                   	push   %eax
  800556:	e8 22 0f 00 00       	call   80147d <sys_cputs>
  80055b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055e:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  800565:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056b:	c9                   	leave  
  80056c:	c3                   	ret    

0080056d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800573:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  80057a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 f4             	pushl  -0xc(%ebp)
  800589:	50                   	push   %eax
  80058a:	e8 6f ff ff ff       	call   8004fe <vcprintf>
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800595:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
  80059d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a0:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	c1 e0 08             	shl    $0x8,%eax
  8005ad:	a3 3c f3 81 00       	mov    %eax,0x81f33c
	va_start(ap, fmt);
  8005b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b5:	83 c0 04             	add    $0x4,%eax
  8005b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c4:	50                   	push   %eax
  8005c5:	e8 34 ff ff ff       	call   8004fe <vcprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005d0:	c7 05 3c f3 81 00 00 	movl   $0x700,0x81f33c
  8005d7:	07 00 00 

	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005e5:	e8 d7 0e 00 00       	call   8014c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 ff fe ff ff       	call   8004fe <vcprintf>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800605:	e8 d1 0e 00 00       	call   8014db <sys_unlock_cons>
	return cnt;
  80060a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060d:	c9                   	leave  
  80060e:	c3                   	ret    

0080060f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	53                   	push   %ebx
  800613:	83 ec 14             	sub    $0x14,%esp
  800616:	8b 45 10             	mov    0x10(%ebp),%eax
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800622:	8b 45 18             	mov    0x18(%ebp),%eax
  800625:	ba 00 00 00 00       	mov    $0x0,%edx
  80062a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062d:	77 55                	ja     800684 <printnum+0x75>
  80062f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800632:	72 05                	jb     800639 <printnum+0x2a>
  800634:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800637:	77 4b                	ja     800684 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800639:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80063c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80063f:	8b 45 18             	mov    0x18(%ebp),%eax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	ff 75 f4             	pushl  -0xc(%ebp)
  80064c:	ff 75 f0             	pushl  -0x10(%ebp)
  80064f:	e8 a8 13 00 00       	call   8019fc <__udivdi3>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	83 ec 04             	sub    $0x4,%esp
  80065a:	ff 75 20             	pushl  0x20(%ebp)
  80065d:	53                   	push   %ebx
  80065e:	ff 75 18             	pushl  0x18(%ebp)
  800661:	52                   	push   %edx
  800662:	50                   	push   %eax
  800663:	ff 75 0c             	pushl  0xc(%ebp)
  800666:	ff 75 08             	pushl  0x8(%ebp)
  800669:	e8 a1 ff ff ff       	call   80060f <printnum>
  80066e:	83 c4 20             	add    $0x20,%esp
  800671:	eb 1a                	jmp    80068d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	ff 75 20             	pushl  0x20(%ebp)
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800684:	ff 4d 1c             	decl   0x1c(%ebp)
  800687:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80068b:	7f e6                	jg     800673 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800690:	bb 00 00 00 00       	mov    $0x0,%ebx
  800695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800698:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80069b:	53                   	push   %ebx
  80069c:	51                   	push   %ecx
  80069d:	52                   	push   %edx
  80069e:	50                   	push   %eax
  80069f:	e8 68 14 00 00       	call   801b0c <__umoddi3>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	05 94 21 80 00       	add    $0x802194,%eax
  8006ac:	8a 00                	mov    (%eax),%al
  8006ae:	0f be c0             	movsbl %al,%eax
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	50                   	push   %eax
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
}
  8006c0:	90                   	nop
  8006c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c4:	c9                   	leave  
  8006c5:	c3                   	ret    

008006c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cd:	7e 1c                	jle    8006eb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 08             	lea    0x8(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 08             	sub    $0x8,%eax
  8006e4:	8b 50 04             	mov    0x4(%eax),%edx
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	eb 40                	jmp    80072b <getuint+0x65>
	else if (lflag)
  8006eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ef:	74 1e                	je     80070f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	8d 50 04             	lea    0x4(%eax),%edx
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	89 10                	mov    %edx,(%eax)
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	ba 00 00 00 00       	mov    $0x0,%edx
  80070d:	eb 1c                	jmp    80072b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80072b:	5d                   	pop    %ebp
  80072c:	c3                   	ret    

0080072d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800730:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800734:	7e 1c                	jle    800752 <getint+0x25>
		return va_arg(*ap, long long);
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 50 08             	lea    0x8(%eax),%edx
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 10                	mov    %edx,(%eax)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	83 e8 08             	sub    $0x8,%eax
  80074b:	8b 50 04             	mov    0x4(%eax),%edx
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	eb 38                	jmp    80078a <getint+0x5d>
	else if (lflag)
  800752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800756:	74 1a                	je     800772 <getint+0x45>
		return va_arg(*ap, long);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	99                   	cltd   
  800770:	eb 18                	jmp    80078a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	89 10                	mov    %edx,(%eax)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 e8 04             	sub    $0x4,%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	99                   	cltd   
}
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	56                   	push   %esi
  800790:	53                   	push   %ebx
  800791:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800794:	eb 17                	jmp    8007ad <vprintfmt+0x21>
			if (ch == '\0')
  800796:	85 db                	test   %ebx,%ebx
  800798:	0f 84 c1 03 00 00    	je     800b5f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	53                   	push   %ebx
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b0:	8d 50 01             	lea    0x1(%eax),%edx
  8007b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b6:	8a 00                	mov    (%eax),%al
  8007b8:	0f b6 d8             	movzbl %al,%ebx
  8007bb:	83 fb 25             	cmp    $0x25,%ebx
  8007be:	75 d6                	jne    800796 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007cb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8d 50 01             	lea    0x1(%eax),%edx
  8007e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e9:	8a 00                	mov    (%eax),%al
  8007eb:	0f b6 d8             	movzbl %al,%ebx
  8007ee:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f1:	83 f8 5b             	cmp    $0x5b,%eax
  8007f4:	0f 87 3d 03 00 00    	ja     800b37 <vprintfmt+0x3ab>
  8007fa:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  800801:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800803:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800807:	eb d7                	jmp    8007e0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800809:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80080d:	eb d1                	jmp    8007e0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800816:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800819:	89 d0                	mov    %edx,%eax
  80081b:	c1 e0 02             	shl    $0x2,%eax
  80081e:	01 d0                	add    %edx,%eax
  800820:	01 c0                	add    %eax,%eax
  800822:	01 d8                	add    %ebx,%eax
  800824:	83 e8 30             	sub    $0x30,%eax
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80082a:	8b 45 10             	mov    0x10(%ebp),%eax
  80082d:	8a 00                	mov    (%eax),%al
  80082f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800832:	83 fb 2f             	cmp    $0x2f,%ebx
  800835:	7e 3e                	jle    800875 <vprintfmt+0xe9>
  800837:	83 fb 39             	cmp    $0x39,%ebx
  80083a:	7f 39                	jg     800875 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80083f:	eb d5                	jmp    800816 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 c0 04             	add    $0x4,%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	83 e8 04             	sub    $0x4,%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800855:	eb 1f                	jmp    800876 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085b:	79 83                	jns    8007e0 <vprintfmt+0x54>
				width = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800864:	e9 77 ff ff ff       	jmp    8007e0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800869:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800870:	e9 6b ff ff ff       	jmp    8007e0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800875:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087a:	0f 89 60 ff ff ff    	jns    8007e0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800886:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80088d:	e9 4e ff ff ff       	jmp    8007e0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800892:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800895:	e9 46 ff ff ff       	jmp    8007e0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 c0 04             	add    $0x4,%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	83 e8 04             	sub    $0x4,%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	50                   	push   %eax
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	ff d0                	call   *%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ba:	e9 9b 02 00 00       	jmp    800b5a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 c0 04             	add    $0x4,%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d0:	85 db                	test   %ebx,%ebx
  8008d2:	79 02                	jns    8008d6 <vprintfmt+0x14a>
				err = -err;
  8008d4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d6:	83 fb 64             	cmp    $0x64,%ebx
  8008d9:	7f 0b                	jg     8008e6 <vprintfmt+0x15a>
  8008db:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  8008e2:	85 f6                	test   %esi,%esi
  8008e4:	75 19                	jne    8008ff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e6:	53                   	push   %ebx
  8008e7:	68 a5 21 80 00       	push   $0x8021a5
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 08             	pushl  0x8(%ebp)
  8008f2:	e8 70 02 00 00       	call   800b67 <printfmt>
  8008f7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008fa:	e9 5b 02 00 00       	jmp    800b5a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ff:	56                   	push   %esi
  800900:	68 ae 21 80 00       	push   $0x8021ae
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 57 02 00 00       	call   800b67 <printfmt>
  800910:	83 c4 10             	add    $0x10,%esp
			break;
  800913:	e9 42 02 00 00       	jmp    800b5a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	83 c0 04             	add    $0x4,%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 30                	mov    (%eax),%esi
  800929:	85 f6                	test   %esi,%esi
  80092b:	75 05                	jne    800932 <vprintfmt+0x1a6>
				p = "(null)";
  80092d:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  800932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800936:	7e 6d                	jle    8009a5 <vprintfmt+0x219>
  800938:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80093c:	74 67                	je     8009a5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	50                   	push   %eax
  800945:	56                   	push   %esi
  800946:	e8 1e 03 00 00       	call   800c69 <strnlen>
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800951:	eb 16                	jmp    800969 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800953:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	50                   	push   %eax
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e4                	jg     800953 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096f:	eb 34                	jmp    8009a5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800971:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800975:	74 1c                	je     800993 <vprintfmt+0x207>
  800977:	83 fb 1f             	cmp    $0x1f,%ebx
  80097a:	7e 05                	jle    800981 <vprintfmt+0x1f5>
  80097c:	83 fb 7e             	cmp    $0x7e,%ebx
  80097f:	7e 12                	jle    800993 <vprintfmt+0x207>
					putch('?', putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	6a 3f                	push   $0x3f
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	ff d0                	call   *%eax
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	eb 0f                	jmp    8009a2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	53                   	push   %ebx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a5:	89 f0                	mov    %esi,%eax
  8009a7:	8d 70 01             	lea    0x1(%eax),%esi
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f be d8             	movsbl %al,%ebx
  8009af:	85 db                	test   %ebx,%ebx
  8009b1:	74 24                	je     8009d7 <vprintfmt+0x24b>
  8009b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b7:	78 b8                	js     800971 <vprintfmt+0x1e5>
  8009b9:	ff 4d e0             	decl   -0x20(%ebp)
  8009bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c0:	79 af                	jns    800971 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c2:	eb 13                	jmp    8009d7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 20                	push   $0x20
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009db:	7f e7                	jg     8009c4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009dd:	e9 78 01 00 00       	jmp    800b5a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009eb:	50                   	push   %eax
  8009ec:	e8 3c fd ff ff       	call   80072d <getint>
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a00:	85 d2                	test   %edx,%edx
  800a02:	79 23                	jns    800a27 <vprintfmt+0x29b>
				putch('-', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 2d                	push   $0x2d
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1a:	f7 d8                	neg    %eax
  800a1c:	83 d2 00             	adc    $0x0,%edx
  800a1f:	f7 da                	neg    %edx
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2e:	e9 bc 00 00 00       	jmp    800aef <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 e8             	pushl  -0x18(%ebp)
  800a39:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3c:	50                   	push   %eax
  800a3d:	e8 84 fc ff ff       	call   8006c6 <getuint>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a52:	e9 98 00 00 00       	jmp    800aef <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	6a 58                	push   $0x58
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	6a 58                	push   $0x58
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 58                	push   $0x58
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			break;
  800a87:	e9 ce 00 00 00       	jmp    800b5a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	6a 30                	push   $0x30
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 78                	push   $0x78
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 c0 04             	add    $0x4,%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ac7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ace:	eb 1f                	jmp    800aef <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	e8 e7 fb ff ff       	call   8006c6 <getuint>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ae8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af6:	83 ec 04             	sub    $0x4,%esp
  800af9:	52                   	push   %edx
  800afa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800afd:	50                   	push   %eax
  800afe:	ff 75 f4             	pushl  -0xc(%ebp)
  800b01:	ff 75 f0             	pushl  -0x10(%ebp)
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 00 fb ff ff       	call   80060f <printnum>
  800b0f:	83 c4 20             	add    $0x20,%esp
			break;
  800b12:	eb 46                	jmp    800b5a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	53                   	push   %ebx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
			break;
  800b23:	eb 35                	jmp    800b5a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b25:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
			break;
  800b2c:	eb 2c                	jmp    800b5a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b2e:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
			break;
  800b35:	eb 23                	jmp    800b5a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	6a 25                	push   $0x25
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	eb 03                	jmp    800b4f <vprintfmt+0x3c3>
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	48                   	dec    %eax
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	3c 25                	cmp    $0x25,%al
  800b57:	75 f3                	jne    800b4c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b59:	90                   	nop
		}
	}
  800b5a:	e9 35 fc ff ff       	jmp    800794 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b5f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b6d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b70:	83 c0 04             	add    $0x4,%eax
  800b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b76:	8b 45 10             	mov    0x10(%ebp),%eax
  800b79:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7c:	50                   	push   %eax
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	ff 75 08             	pushl  0x8(%ebp)
  800b83:	e8 04 fc ff ff       	call   80078c <vprintfmt>
  800b88:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b8b:	90                   	nop
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 40 08             	mov    0x8(%eax),%eax
  800b97:	8d 50 01             	lea    0x1(%eax),%edx
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	8b 10                	mov    (%eax),%edx
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 40 04             	mov    0x4(%eax),%eax
  800bab:	39 c2                	cmp    %eax,%edx
  800bad:	73 12                	jae    800bc1 <sprintputch+0x33>
		*b->buf++ = ch;
  800baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	89 0a                	mov    %ecx,(%edx)
  800bbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbf:	88 10                	mov    %dl,(%eax)
}
  800bc1:	90                   	nop
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	01 d0                	add    %edx,%eax
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800be9:	74 06                	je     800bf1 <vsnprintf+0x2d>
  800beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bef:	7f 07                	jg     800bf8 <vsnprintf+0x34>
		return -E_INVAL;
  800bf1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf6:	eb 20                	jmp    800c18 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bf8:	ff 75 14             	pushl  0x14(%ebp)
  800bfb:	ff 75 10             	pushl  0x10(%ebp)
  800bfe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c01:	50                   	push   %eax
  800c02:	68 8e 0b 80 00       	push   $0x800b8e
  800c07:	e8 80 fb ff ff       	call   80078c <vprintfmt>
  800c0c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c12:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c20:	8d 45 10             	lea    0x10(%ebp),%eax
  800c23:	83 c0 04             	add    $0x4,%eax
  800c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c29:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2f:	50                   	push   %eax
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	ff 75 08             	pushl  0x8(%ebp)
  800c36:	e8 89 ff ff ff       	call   800bc4 <vsnprintf>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c53:	eb 06                	jmp    800c5b <strlen+0x15>
		n++;
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c58:	ff 45 08             	incl   0x8(%ebp)
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 f1                	jne    800c55 <strlen+0xf>
		n++;
	return n;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c76:	eb 09                	jmp    800c81 <strnlen+0x18>
		n++;
  800c78:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	ff 4d 0c             	decl   0xc(%ebp)
  800c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c85:	74 09                	je     800c90 <strnlen+0x27>
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8a 00                	mov    (%eax),%al
  800c8c:	84 c0                	test   %al,%al
  800c8e:	75 e8                	jne    800c78 <strnlen+0xf>
		n++;
	return n;
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca1:	90                   	nop
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8d 50 01             	lea    0x1(%eax),%edx
  800ca8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb4:	8a 12                	mov    (%edx),%dl
  800cb6:	88 10                	mov    %dl,(%eax)
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 e4                	jne    800ca2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ccf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd6:	eb 1f                	jmp    800cf7 <strncpy+0x34>
		*dst++ = *src;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8d 50 01             	lea    0x1(%eax),%edx
  800cde:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce4:	8a 12                	mov    (%edx),%dl
  800ce6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	74 03                	je     800cf4 <strncpy+0x31>
			src++;
  800cf1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf4:	ff 45 fc             	incl   -0x4(%ebp)
  800cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfa:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cfd:	72 d9                	jb     800cd8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d14:	74 30                	je     800d46 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d16:	eb 16                	jmp    800d2e <strlcpy+0x2a>
			*dst++ = *src++;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8d 50 01             	lea    0x1(%eax),%edx
  800d1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2a:	8a 12                	mov    (%edx),%dl
  800d2c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d35:	74 09                	je     800d40 <strlcpy+0x3c>
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	84 c0                	test   %al,%al
  800d3e:	75 d8                	jne    800d18 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4c:	29 c2                	sub    %eax,%edx
  800d4e:	89 d0                	mov    %edx,%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d55:	eb 06                	jmp    800d5d <strcmp+0xb>
		p++, q++;
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	84 c0                	test   %al,%al
  800d64:	74 0e                	je     800d74 <strcmp+0x22>
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 10                	mov    (%eax),%dl
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	38 c2                	cmp    %al,%dl
  800d72:	74 e3                	je     800d57 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	0f b6 d0             	movzbl %al,%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	0f b6 c0             	movzbl %al,%eax
  800d84:	29 c2                	sub    %eax,%edx
  800d86:	89 d0                	mov    %edx,%eax
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d8d:	eb 09                	jmp    800d98 <strncmp+0xe>
		n--, p++, q++;
  800d8f:	ff 4d 10             	decl   0x10(%ebp)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9c:	74 17                	je     800db5 <strncmp+0x2b>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	74 0e                	je     800db5 <strncmp+0x2b>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 10                	mov    (%eax),%dl
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	38 c2                	cmp    %al,%dl
  800db3:	74 da                	je     800d8f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db9:	75 07                	jne    800dc2 <strncmp+0x38>
		return 0;
  800dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc0:	eb 14                	jmp    800dd6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	0f b6 d0             	movzbl %al,%edx
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	0f b6 c0             	movzbl %al,%eax
  800dd2:	29 c2                	sub    %eax,%edx
  800dd4:	89 d0                	mov    %edx,%eax
}
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 04             	sub    $0x4,%esp
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de4:	eb 12                	jmp    800df8 <strchr+0x20>
		if (*s == c)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dee:	75 05                	jne    800df5 <strchr+0x1d>
			return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	eb 11                	jmp    800e06 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800df5:	ff 45 08             	incl   0x8(%ebp)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 e5                	jne    800de6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 04             	sub    $0x4,%esp
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e14:	eb 0d                	jmp    800e23 <strfind+0x1b>
		if (*s == c)
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e1e:	74 0e                	je     800e2e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e20:	ff 45 08             	incl   0x8(%ebp)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 ea                	jne    800e16 <strfind+0xe>
  800e2c:	eb 01                	jmp    800e2f <strfind+0x27>
		if (*s == c)
			break;
  800e2e:	90                   	nop
	return (char *) s;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e40:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e44:	76 63                	jbe    800ea9 <memset+0x75>
		uint64 data_block = c;
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	99                   	cltd   
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e56:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e5a:	c1 e0 08             	shl    $0x8,%eax
  800e5d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e60:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e69:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e6d:	c1 e0 10             	shl    $0x10,%eax
  800e70:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e73:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e83:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e86:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e89:	eb 18                	jmp    800ea3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e8b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e8e:	8d 41 08             	lea    0x8(%ecx),%eax
  800e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9a:	89 01                	mov    %eax,(%ecx)
  800e9c:	89 51 04             	mov    %edx,0x4(%ecx)
  800e9f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ea3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea7:	77 e2                	ja     800e8b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ead:	74 23                	je     800ed2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb5:	eb 0e                	jmp    800ec5 <memset+0x91>
			*p8++ = (uint8)c;
  800eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	75 e5                	jne    800eb7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ee9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eed:	76 24                	jbe    800f13 <memcpy+0x3c>
		while(n >= 8){
  800eef:	eb 1c                	jmp    800f0d <memcpy+0x36>
			*d64 = *s64;
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8b 50 04             	mov    0x4(%eax),%edx
  800ef7:	8b 00                	mov    (%eax),%eax
  800ef9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800efc:	89 01                	mov    %eax,(%ecx)
  800efe:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f01:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f05:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f09:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f0d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f11:	77 de                	ja     800ef1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 31                	je     800f4a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f25:	eb 16                	jmp    800f3d <memcpy+0x66>
			*d8++ = *s8++;
  800f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f36:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f39:	8a 12                	mov    (%edx),%dl
  800f3b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f43:	89 55 10             	mov    %edx,0x10(%ebp)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	75 dd                	jne    800f27 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f67:	73 50                	jae    800fb9 <memmove+0x6a>
  800f69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f74:	76 43                	jbe    800fb9 <memmove+0x6a>
		s += n;
  800f76:	8b 45 10             	mov    0x10(%ebp),%eax
  800f79:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f82:	eb 10                	jmp    800f94 <memmove+0x45>
			*--d = *--s;
  800f84:	ff 4d f8             	decl   -0x8(%ebp)
  800f87:	ff 4d fc             	decl   -0x4(%ebp)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f94:	8b 45 10             	mov    0x10(%ebp),%eax
  800f97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	75 e3                	jne    800f84 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa1:	eb 23                	jmp    800fc6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8d 50 01             	lea    0x1(%eax),%edx
  800fa9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800faf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb5:	8a 12                	mov    (%edx),%dl
  800fb7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	75 dd                	jne    800fa3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fdd:	eb 2a                	jmp    801009 <memcmp+0x3e>
		if (*s1 != *s2)
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8a 10                	mov    (%eax),%dl
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	38 c2                	cmp    %al,%dl
  800feb:	74 16                	je     801003 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	0f b6 d0             	movzbl %al,%edx
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	29 c2                	sub    %eax,%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	eb 18                	jmp    80101b <memcmp+0x50>
		s1++, s2++;
  801003:	ff 45 fc             	incl   -0x4(%ebp)
  801006:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801009:	8b 45 10             	mov    0x10(%ebp),%eax
  80100c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100f:	89 55 10             	mov    %edx,0x10(%ebp)
  801012:	85 c0                	test   %eax,%eax
  801014:	75 c9                	jne    800fdf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801016:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80102e:	eb 15                	jmp    801045 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f b6 d0             	movzbl %al,%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	39 c2                	cmp    %eax,%edx
  801040:	74 0d                	je     80104f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80104b:	72 e3                	jb     801030 <memfind+0x13>
  80104d:	eb 01                	jmp    801050 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80104f:	90                   	nop
	return (void *) s;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80105b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801062:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801069:	eb 03                	jmp    80106e <strtol+0x19>
		s++;
  80106b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 20                	cmp    $0x20,%al
  801075:	74 f4                	je     80106b <strtol+0x16>
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	3c 09                	cmp    $0x9,%al
  80107e:	74 eb                	je     80106b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	3c 2b                	cmp    $0x2b,%al
  801087:	75 05                	jne    80108e <strtol+0x39>
		s++;
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	eb 13                	jmp    8010a1 <strtol+0x4c>
	else if (*s == '-')
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	3c 2d                	cmp    $0x2d,%al
  801095:	75 0a                	jne    8010a1 <strtol+0x4c>
		s++, neg = 1;
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a5:	74 06                	je     8010ad <strtol+0x58>
  8010a7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ab:	75 20                	jne    8010cd <strtol+0x78>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 30                	cmp    $0x30,%al
  8010b4:	75 17                	jne    8010cd <strtol+0x78>
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	40                   	inc    %eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 78                	cmp    $0x78,%al
  8010be:	75 0d                	jne    8010cd <strtol+0x78>
		s += 2, base = 16;
  8010c0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010c4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010cb:	eb 28                	jmp    8010f5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d1:	75 15                	jne    8010e8 <strtol+0x93>
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 30                	cmp    $0x30,%al
  8010da:	75 0c                	jne    8010e8 <strtol+0x93>
		s++, base = 8;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010e6:	eb 0d                	jmp    8010f5 <strtol+0xa0>
	else if (base == 0)
  8010e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ec:	75 07                	jne    8010f5 <strtol+0xa0>
		base = 10;
  8010ee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 2f                	cmp    $0x2f,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xc2>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 39                	cmp    $0x39,%al
  801105:	7f 10                	jg     801117 <strtol+0xc2>
			dig = *s - '0';
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 30             	sub    $0x30,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 42                	jmp    801159 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 60                	cmp    $0x60,%al
  80111e:	7e 19                	jle    801139 <strtol+0xe4>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 7a                	cmp    $0x7a,%al
  801127:	7f 10                	jg     801139 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 57             	sub    $0x57,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801137:	eb 20                	jmp    801159 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 40                	cmp    $0x40,%al
  801140:	7e 39                	jle    80117b <strtol+0x126>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 5a                	cmp    $0x5a,%al
  801149:	7f 30                	jg     80117b <strtol+0x126>
			dig = *s - 'A' + 10;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f be c0             	movsbl %al,%eax
  801153:	83 e8 37             	sub    $0x37,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80115f:	7d 19                	jge    80117a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801167:	0f af 45 10          	imul   0x10(%ebp),%eax
  80116b:	89 c2                	mov    %eax,%edx
  80116d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801170:	01 d0                	add    %edx,%eax
  801172:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801175:	e9 7b ff ff ff       	jmp    8010f5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80117a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80117b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117f:	74 08                	je     801189 <strtol+0x134>
		*endptr = (char *) s;
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	8b 55 08             	mov    0x8(%ebp),%edx
  801187:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801189:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80118d:	74 07                	je     801196 <strtol+0x141>
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	f7 d8                	neg    %eax
  801194:	eb 03                	jmp    801199 <strtol+0x144>
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <ltostr>:

void
ltostr(long value, char *str)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b3:	79 13                	jns    8011c8 <ltostr+0x2d>
	{
		neg = 1;
  8011b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d0:	99                   	cltd   
  8011d1:	f7 f9                	idiv   %ecx
  8011d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011e9:	83 c2 30             	add    $0x30,%edx
  8011ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f6:	f7 e9                	imul   %ecx
  8011f8:	c1 fa 02             	sar    $0x2,%edx
  8011fb:	89 c8                	mov    %ecx,%eax
  8011fd:	c1 f8 1f             	sar    $0x1f,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801207:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120b:	75 bb                	jne    8011c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801217:	48                   	dec    %eax
  801218:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80121b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121f:	74 3d                	je     80125e <ltostr+0xc3>
		start = 1 ;
  801221:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801228:	eb 34                	jmp    80125e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	01 c2                	add    %eax,%edx
  80123f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	01 c8                	add    %ecx,%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80124b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 c2                	add    %eax,%edx
  801253:	8a 45 eb             	mov    -0x15(%ebp),%al
  801256:	88 02                	mov    %al,(%edx)
		start++ ;
  801258:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80125b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801264:	7c c4                	jl     80122a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801266:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801271:	90                   	nop
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80127a:	ff 75 08             	pushl  0x8(%ebp)
  80127d:	e8 c4 f9 ff ff       	call   800c46 <strlen>
  801282:	83 c4 04             	add    $0x4,%esp
  801285:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	e8 b6 f9 ff ff       	call   800c46 <strlen>
  801290:	83 c4 04             	add    $0x4,%esp
  801293:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a4:	eb 17                	jmp    8012bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ac:	01 c2                	add    %eax,%edx
  8012ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	01 c8                	add    %ecx,%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ba:	ff 45 fc             	incl   -0x4(%ebp)
  8012bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c3:	7c e1                	jl     8012a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d3:	eb 1f                	jmp    8012f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012de:	89 c2                	mov    %eax,%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 c2                	add    %eax,%edx
  8012e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	01 c8                	add    %ecx,%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f1:	ff 45 f8             	incl   -0x8(%ebp)
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012fa:	7c d9                	jl     8012d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	c6 00 00             	movb   $0x0,(%eax)
}
  801307:	90                   	nop
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130d:	8b 45 14             	mov    0x14(%ebp),%eax
  801310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801316:	8b 45 14             	mov    0x14(%ebp),%eax
  801319:	8b 00                	mov    (%eax),%eax
  80131b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132d:	eb 0c                	jmp    80133b <strsplit+0x31>
			*string++ = 0;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	89 55 08             	mov    %edx,0x8(%ebp)
  801338:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	84 c0                	test   %al,%al
  801342:	74 18                	je     80135c <strsplit+0x52>
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	8a 00                	mov    (%eax),%al
  801349:	0f be c0             	movsbl %al,%eax
  80134c:	50                   	push   %eax
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	e8 83 fa ff ff       	call   800dd8 <strchr>
  801355:	83 c4 08             	add    $0x8,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	75 d3                	jne    80132f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	84 c0                	test   %al,%al
  801363:	74 5a                	je     8013bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801365:	8b 45 14             	mov    0x14(%ebp),%eax
  801368:	8b 00                	mov    (%eax),%eax
  80136a:	83 f8 0f             	cmp    $0xf,%eax
  80136d:	75 07                	jne    801376 <strsplit+0x6c>
		{
			return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	eb 66                	jmp    8013dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 48 01             	lea    0x1(%eax),%ecx
  80137e:	8b 55 14             	mov    0x14(%ebp),%edx
  801381:	89 0a                	mov    %ecx,(%edx)
  801383:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
  80138d:	01 c2                	add    %eax,%edx
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801394:	eb 03                	jmp    801399 <strsplit+0x8f>
			string++;
  801396:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 8b                	je     80132d <strsplit+0x23>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f be c0             	movsbl %al,%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	e8 25 fa ff ff       	call   800dd8 <strchr>
  8013b3:	83 c4 08             	add    $0x8,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	74 dc                	je     801396 <strsplit+0x8c>
			string++;
	}
  8013ba:	e9 6e ff ff ff       	jmp    80132d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f1:	eb 4a                	jmp    80143d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	01 c2                	add    %eax,%edx
  8013fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	01 c8                	add    %ecx,%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801407:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 40                	cmp    $0x40,%al
  801413:	7e 25                	jle    80143a <str2lower+0x5c>
  801415:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 5a                	cmp    $0x5a,%al
  801421:	7f 17                	jg     80143a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142e:	8b 55 08             	mov    0x8(%ebp),%edx
  801431:	01 ca                	add    %ecx,%edx
  801433:	8a 12                	mov    (%edx),%dl
  801435:	83 c2 20             	add    $0x20,%edx
  801438:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80143a:	ff 45 fc             	incl   -0x4(%ebp)
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	e8 01 f8 ff ff       	call   800c46 <strlen>
  801445:	83 c4 04             	add    $0x4,%esp
  801448:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80144b:	7f a6                	jg     8013f3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80144d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	57                   	push   %edi
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801461:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801464:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801467:	8b 7d 18             	mov    0x18(%ebp),%edi
  80146a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80146d:	cd 30                	int    $0x30
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801472:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	5b                   	pop    %ebx
  801479:	5e                   	pop    %esi
  80147a:	5f                   	pop    %edi
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    

0080147d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801489:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	51                   	push   %ecx
  801496:	52                   	push   %edx
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	50                   	push   %eax
  80149b:	6a 00                	push   $0x0
  80149d:	e8 b0 ff ff ff       	call   801452 <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
}
  8014a5:	90                   	nop
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 02                	push   $0x2
  8014b7:	e8 96 ff ff ff       	call   801452 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 03                	push   $0x3
  8014d0:	e8 7d ff ff ff       	call   801452 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 04                	push   $0x4
  8014ea:	e8 63 ff ff ff       	call   801452 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	52                   	push   %edx
  801505:	50                   	push   %eax
  801506:	6a 08                	push   $0x8
  801508:	e8 45 ff ff ff       	call   801452 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801517:	8b 75 18             	mov    0x18(%ebp),%esi
  80151a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80151d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801520:	8b 55 0c             	mov    0xc(%ebp),%edx
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
  801528:	51                   	push   %ecx
  801529:	52                   	push   %edx
  80152a:	50                   	push   %eax
  80152b:	6a 09                	push   $0x9
  80152d:	e8 20 ff ff ff       	call   801452 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	6a 0a                	push   $0xa
  80154c:	e8 01 ff ff ff       	call   801452 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	ff 75 08             	pushl  0x8(%ebp)
  801565:	6a 0b                	push   $0xb
  801567:	e8 e6 fe ff ff       	call   801452 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 0c                	push   $0xc
  801580:	e8 cd fe ff ff       	call   801452 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 0d                	push   $0xd
  801599:	e8 b4 fe ff ff       	call   801452 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 0e                	push   $0xe
  8015b2:	e8 9b fe ff ff       	call   801452 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 0f                	push   $0xf
  8015cb:	e8 82 fe ff ff       	call   801452 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	6a 10                	push   $0x10
  8015e5:	e8 68 fe ff ff       	call   801452 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 11                	push   $0x11
  8015fe:	e8 4f fe ff ff       	call   801452 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_cputc>:

void
sys_cputc(const char c)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801615:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	50                   	push   %eax
  801622:	6a 01                	push   $0x1
  801624:	e8 29 fe ff ff       	call   801452 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 14                	push   $0x14
  80163e:	e8 0f fe ff ff       	call   801452 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801655:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801658:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	51                   	push   %ecx
  801662:	52                   	push   %edx
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	50                   	push   %eax
  801667:	6a 15                	push   $0x15
  801669:	e8 e4 fd ff ff       	call   801452 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 16                	push   $0x16
  801686:	e8 c7 fd ff ff       	call   801452 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801693:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	51                   	push   %ecx
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 17                	push   $0x17
  8016a5:	e8 a8 fd ff ff       	call   801452 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	6a 18                	push   $0x18
  8016c2:	e8 8b fd ff ff       	call   801452 <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 14             	pushl  0x14(%ebp)
  8016d7:	ff 75 10             	pushl  0x10(%ebp)
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	50                   	push   %eax
  8016de:	6a 19                	push   $0x19
  8016e0:	e8 6d fd ff ff       	call   801452 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	50                   	push   %eax
  8016f9:	6a 1a                	push   $0x1a
  8016fb:	e8 52 fd ff ff       	call   801452 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	50                   	push   %eax
  801715:	6a 1b                	push   $0x1b
  801717:	e8 36 fd ff ff       	call   801452 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 05                	push   $0x5
  801730:	e8 1d fd ff ff       	call   801452 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 06                	push   $0x6
  801749:	e8 04 fd ff ff       	call   801452 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 07                	push   $0x7
  801762:	e8 eb fc ff ff       	call   801452 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_exit_env>:


void sys_exit_env(void)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 1c                	push   $0x1c
  80177b:	e8 d2 fc ff ff       	call   801452 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80178c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80178f:	8d 50 04             	lea    0x4(%eax),%edx
  801792:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 1d                	push   $0x1d
  80179f:	e8 ae fc ff ff       	call   801452 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
	return result;
  8017a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b0:	89 01                	mov    %eax,(%ecx)
  8017b2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	c9                   	leave  
  8017b9:	c2 04 00             	ret    $0x4

008017bc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	ff 75 10             	pushl  0x10(%ebp)
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	6a 13                	push   $0x13
  8017ce:	e8 7f fc ff ff       	call   801452 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d6:	90                   	nop
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 1e                	push   $0x1e
  8017e8:	e8 65 fc ff ff       	call   801452 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017fe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	50                   	push   %eax
  80180b:	6a 1f                	push   $0x1f
  80180d:	e8 40 fc ff ff       	call   801452 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
	return ;
  801815:	90                   	nop
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <rsttst>:
void rsttst()
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 21                	push   $0x21
  801827:	e8 26 fc ff ff       	call   801452 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
	return ;
  80182f:	90                   	nop
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	8b 45 14             	mov    0x14(%ebp),%eax
  80183b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80183e:	8b 55 18             	mov    0x18(%ebp),%edx
  801841:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801845:	52                   	push   %edx
  801846:	50                   	push   %eax
  801847:	ff 75 10             	pushl  0x10(%ebp)
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	6a 20                	push   $0x20
  801852:	e8 fb fb ff ff       	call   801452 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return ;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <chktst>:
void chktst(uint32 n)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	6a 22                	push   $0x22
  80186d:	e8 e0 fb ff ff       	call   801452 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
	return ;
  801875:	90                   	nop
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <inctst>:

void inctst()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 23                	push   $0x23
  801887:	e8 c6 fb ff ff       	call   801452 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return ;
  80188f:	90                   	nop
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <gettst>:
uint32 gettst()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 24                	push   $0x24
  8018a1:	e8 ac fb ff ff       	call   801452 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 25                	push   $0x25
  8018ba:	e8 93 fb ff ff       	call   801452 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
  8018c2:	a3 80 f2 81 00       	mov    %eax,0x81f280
	return uheapPlaceStrategy ;
  8018c7:	a1 80 f2 81 00       	mov    0x81f280,%eax
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	a3 80 f2 81 00       	mov    %eax,0x81f280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	6a 26                	push   $0x26
  8018e6:	e8 67 fb ff ff       	call   801452 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	53                   	push   %ebx
  801904:	51                   	push   %ecx
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	6a 27                	push   $0x27
  801909:	e8 44 fb ff ff       	call   801452 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	6a 28                	push   $0x28
  801929:	e8 24 fb ff ff       	call   801452 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801936:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	51                   	push   %ecx
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 29                	push   $0x29
  801949:	e8 04 fb ff ff       	call   801452 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 10             	pushl  0x10(%ebp)
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	6a 12                	push   $0x12
  801965:	e8 e8 fa ff ff       	call   801452 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 2a                	push   $0x2a
  801983:	e8 ca fa ff ff       	call   801452 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 2b                	push   $0x2b
  80199d:	e8 b0 fa ff ff       	call   801452 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	e8 95 fa ff ff       	call   801452 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 2c                	push   $0x2c
  8019d4:	e8 79 fa ff ff       	call   801452 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 28 23 80 00       	push   $0x802328
  8019ed:	68 25 01 00 00       	push   $0x125
  8019f2:	68 5b 23 80 00       	push   $0x80235b
  8019f7:	e8 a3 e8 ff ff       	call   80029f <_panic>

008019fc <__udivdi3>:
  8019fc:	55                   	push   %ebp
  8019fd:	57                   	push   %edi
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 1c             	sub    $0x1c,%esp
  801a03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a13:	89 ca                	mov    %ecx,%edx
  801a15:	89 f8                	mov    %edi,%eax
  801a17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a1b:	85 f6                	test   %esi,%esi
  801a1d:	75 2d                	jne    801a4c <__udivdi3+0x50>
  801a1f:	39 cf                	cmp    %ecx,%edi
  801a21:	77 65                	ja     801a88 <__udivdi3+0x8c>
  801a23:	89 fd                	mov    %edi,%ebp
  801a25:	85 ff                	test   %edi,%edi
  801a27:	75 0b                	jne    801a34 <__udivdi3+0x38>
  801a29:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2e:	31 d2                	xor    %edx,%edx
  801a30:	f7 f7                	div    %edi
  801a32:	89 c5                	mov    %eax,%ebp
  801a34:	31 d2                	xor    %edx,%edx
  801a36:	89 c8                	mov    %ecx,%eax
  801a38:	f7 f5                	div    %ebp
  801a3a:	89 c1                	mov    %eax,%ecx
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	f7 f5                	div    %ebp
  801a40:	89 cf                	mov    %ecx,%edi
  801a42:	89 fa                	mov    %edi,%edx
  801a44:	83 c4 1c             	add    $0x1c,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    
  801a4c:	39 ce                	cmp    %ecx,%esi
  801a4e:	77 28                	ja     801a78 <__udivdi3+0x7c>
  801a50:	0f bd fe             	bsr    %esi,%edi
  801a53:	83 f7 1f             	xor    $0x1f,%edi
  801a56:	75 40                	jne    801a98 <__udivdi3+0x9c>
  801a58:	39 ce                	cmp    %ecx,%esi
  801a5a:	72 0a                	jb     801a66 <__udivdi3+0x6a>
  801a5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a60:	0f 87 9e 00 00 00    	ja     801b04 <__udivdi3+0x108>
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6b:	89 fa                	mov    %edi,%edx
  801a6d:	83 c4 1c             	add    $0x1c,%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    
  801a75:	8d 76 00             	lea    0x0(%esi),%esi
  801a78:	31 ff                	xor    %edi,%edi
  801a7a:	31 c0                	xor    %eax,%eax
  801a7c:	89 fa                	mov    %edi,%edx
  801a7e:	83 c4 1c             	add    $0x1c,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5f                   	pop    %edi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	f7 f7                	div    %edi
  801a8c:	31 ff                	xor    %edi,%edi
  801a8e:	89 fa                	mov    %edi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a9d:	89 eb                	mov    %ebp,%ebx
  801a9f:	29 fb                	sub    %edi,%ebx
  801aa1:	89 f9                	mov    %edi,%ecx
  801aa3:	d3 e6                	shl    %cl,%esi
  801aa5:	89 c5                	mov    %eax,%ebp
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 ed                	shr    %cl,%ebp
  801aab:	89 e9                	mov    %ebp,%ecx
  801aad:	09 f1                	or     %esi,%ecx
  801aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ab3:	89 f9                	mov    %edi,%ecx
  801ab5:	d3 e0                	shl    %cl,%eax
  801ab7:	89 c5                	mov    %eax,%ebp
  801ab9:	89 d6                	mov    %edx,%esi
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 ee                	shr    %cl,%esi
  801abf:	89 f9                	mov    %edi,%ecx
  801ac1:	d3 e2                	shl    %cl,%edx
  801ac3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 e8                	shr    %cl,%eax
  801acb:	09 c2                	or     %eax,%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	89 f2                	mov    %esi,%edx
  801ad1:	f7 74 24 0c          	divl   0xc(%esp)
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	f7 e5                	mul    %ebp
  801adb:	39 d6                	cmp    %edx,%esi
  801add:	72 19                	jb     801af8 <__udivdi3+0xfc>
  801adf:	74 0b                	je     801aec <__udivdi3+0xf0>
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	31 ff                	xor    %edi,%edi
  801ae5:	e9 58 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af0:	89 f9                	mov    %edi,%ecx
  801af2:	d3 e2                	shl    %cl,%edx
  801af4:	39 c2                	cmp    %eax,%edx
  801af6:	73 e9                	jae    801ae1 <__udivdi3+0xe5>
  801af8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801afb:	31 ff                	xor    %edi,%edi
  801afd:	e9 40 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	31 c0                	xor    %eax,%eax
  801b06:	e9 37 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b0b:	90                   	nop

00801b0c <__umoddi3>:
  801b0c:	55                   	push   %ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b17:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b2b:	89 f3                	mov    %esi,%ebx
  801b2d:	89 fa                	mov    %edi,%edx
  801b2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b33:	89 34 24             	mov    %esi,(%esp)
  801b36:	85 c0                	test   %eax,%eax
  801b38:	75 1a                	jne    801b54 <__umoddi3+0x48>
  801b3a:	39 f7                	cmp    %esi,%edi
  801b3c:	0f 86 a2 00 00 00    	jbe    801be4 <__umoddi3+0xd8>
  801b42:	89 c8                	mov    %ecx,%eax
  801b44:	89 f2                	mov    %esi,%edx
  801b46:	f7 f7                	div    %edi
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	31 d2                	xor    %edx,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 f0                	cmp    %esi,%eax
  801b56:	0f 87 ac 00 00 00    	ja     801c08 <__umoddi3+0xfc>
  801b5c:	0f bd e8             	bsr    %eax,%ebp
  801b5f:	83 f5 1f             	xor    $0x1f,%ebp
  801b62:	0f 84 ac 00 00 00    	je     801c14 <__umoddi3+0x108>
  801b68:	bf 20 00 00 00       	mov    $0x20,%edi
  801b6d:	29 ef                	sub    %ebp,%edi
  801b6f:	89 fe                	mov    %edi,%esi
  801b71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 e0                	shl    %cl,%eax
  801b79:	89 d7                	mov    %edx,%edi
  801b7b:	89 f1                	mov    %esi,%ecx
  801b7d:	d3 ef                	shr    %cl,%edi
  801b7f:	09 c7                	or     %eax,%edi
  801b81:	89 e9                	mov    %ebp,%ecx
  801b83:	d3 e2                	shl    %cl,%edx
  801b85:	89 14 24             	mov    %edx,(%esp)
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	d3 e0                	shl    %cl,%eax
  801b8c:	89 c2                	mov    %eax,%edx
  801b8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b98:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9c:	89 f1                	mov    %esi,%ecx
  801b9e:	d3 e8                	shr    %cl,%eax
  801ba0:	09 d0                	or     %edx,%eax
  801ba2:	d3 eb                	shr    %cl,%ebx
  801ba4:	89 da                	mov    %ebx,%edx
  801ba6:	f7 f7                	div    %edi
  801ba8:	89 d3                	mov    %edx,%ebx
  801baa:	f7 24 24             	mull   (%esp)
  801bad:	89 c6                	mov    %eax,%esi
  801baf:	89 d1                	mov    %edx,%ecx
  801bb1:	39 d3                	cmp    %edx,%ebx
  801bb3:	0f 82 87 00 00 00    	jb     801c40 <__umoddi3+0x134>
  801bb9:	0f 84 91 00 00 00    	je     801c50 <__umoddi3+0x144>
  801bbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bc3:	29 f2                	sub    %esi,%edx
  801bc5:	19 cb                	sbb    %ecx,%ebx
  801bc7:	89 d8                	mov    %ebx,%eax
  801bc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bcd:	d3 e0                	shl    %cl,%eax
  801bcf:	89 e9                	mov    %ebp,%ecx
  801bd1:	d3 ea                	shr    %cl,%edx
  801bd3:	09 d0                	or     %edx,%eax
  801bd5:	89 e9                	mov    %ebp,%ecx
  801bd7:	d3 eb                	shr    %cl,%ebx
  801bd9:	89 da                	mov    %ebx,%edx
  801bdb:	83 c4 1c             	add    $0x1c,%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5f                   	pop    %edi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
  801be3:	90                   	nop
  801be4:	89 fd                	mov    %edi,%ebp
  801be6:	85 ff                	test   %edi,%edi
  801be8:	75 0b                	jne    801bf5 <__umoddi3+0xe9>
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	31 d2                	xor    %edx,%edx
  801bf1:	f7 f7                	div    %edi
  801bf3:	89 c5                	mov    %eax,%ebp
  801bf5:	89 f0                	mov    %esi,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f5                	div    %ebp
  801bfb:	89 c8                	mov    %ecx,%eax
  801bfd:	f7 f5                	div    %ebp
  801bff:	89 d0                	mov    %edx,%eax
  801c01:	e9 44 ff ff ff       	jmp    801b4a <__umoddi3+0x3e>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	89 c8                	mov    %ecx,%eax
  801c0a:	89 f2                	mov    %esi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	3b 04 24             	cmp    (%esp),%eax
  801c17:	72 06                	jb     801c1f <__umoddi3+0x113>
  801c19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c1d:	77 0f                	ja     801c2e <__umoddi3+0x122>
  801c1f:	89 f2                	mov    %esi,%edx
  801c21:	29 f9                	sub    %edi,%ecx
  801c23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c27:	89 14 24             	mov    %edx,(%esp)
  801c2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c32:	8b 14 24             	mov    (%esp),%edx
  801c35:	83 c4 1c             	add    $0x1c,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
  801c3d:	8d 76 00             	lea    0x0(%esi),%esi
  801c40:	2b 04 24             	sub    (%esp),%eax
  801c43:	19 fa                	sbb    %edi,%edx
  801c45:	89 d1                	mov    %edx,%ecx
  801c47:	89 c6                	mov    %eax,%esi
  801c49:	e9 71 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c54:	72 ea                	jb     801c40 <__umoddi3+0x134>
  801c56:	89 d9                	mov    %ebx,%ecx
  801c58:	e9 62 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
