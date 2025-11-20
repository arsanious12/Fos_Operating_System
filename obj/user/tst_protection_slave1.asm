
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 1f 00 00 00       	call   800055 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 4e 00 00    	sub    $0x4e48,%esp
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
  800041:	83 ec 04             	sub    $0x4,%esp
  800044:	68 e0 1b 80 00       	push   $0x801be0
  800049:	6a 15                	push   $0x15
  80004b:	68 11 1c 80 00       	push   $0x801c11
  800050:	e8 c5 01 00 00       	call   80021a <_panic>

00800055 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	57                   	push   %edi
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005e:	e8 52 16 00 00       	call   8016b5 <sys_getenvindex>
  800063:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800069:	89 d0                	mov    %edx,%eax
  80006b:	c1 e0 06             	shl    $0x6,%eax
  80006e:	29 d0                	sub    %edx,%eax
  800070:	c1 e0 02             	shl    $0x2,%eax
  800073:	01 d0                	add    %edx,%eax
  800075:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80007c:	01 c8                	add    %ecx,%eax
  80007e:	c1 e0 03             	shl    $0x3,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80008a:	29 c2                	sub    %eax,%edx
  80008c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800093:	89 c2                	mov    %eax,%edx
  800095:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80009b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a5:	8a 40 20             	mov    0x20(%eax),%al
  8000a8:	84 c0                	test   %al,%al
  8000aa:	74 0d                	je     8000b9 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	83 c0 20             	add    $0x20,%eax
  8000b4:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bd:	7e 0a                	jle    8000c9 <libmain+0x74>
		binaryname = argv[0];
  8000bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	ff 75 0c             	pushl  0xc(%ebp)
  8000cf:	ff 75 08             	pushl  0x8(%ebp)
  8000d2:	e8 61 ff ff ff       	call   800038 <_main>
  8000d7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000da:	a1 00 30 80 00       	mov    0x803000,%eax
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	0f 84 01 01 00 00    	je     8001e8 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ed:	bb 28 1d 80 00       	mov    $0x801d28,%ebx
  8000f2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f7:	89 c7                	mov    %eax,%edi
  8000f9:	89 de                	mov    %ebx,%esi
  8000fb:	89 d1                	mov    %edx,%ecx
  8000fd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ff:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800102:	b9 56 00 00 00       	mov    $0x56,%ecx
  800107:	b0 00                	mov    $0x0,%al
  800109:	89 d7                	mov    %edx,%edi
  80010b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80010d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800114:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	50                   	push   %eax
  80011b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800121:	50                   	push   %eax
  800122:	e8 c4 17 00 00       	call   8018eb <sys_utilities>
  800127:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80012a:	e8 0d 13 00 00       	call   80143c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 48 1c 80 00       	push   $0x801c48
  800137:	e8 ac 03 00 00       	call   8004e8 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800142:	85 c0                	test   %eax,%eax
  800144:	74 18                	je     80015e <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800146:	e8 be 17 00 00       	call   801909 <sys_get_optimal_num_faults>
  80014b:	83 ec 08             	sub    $0x8,%esp
  80014e:	50                   	push   %eax
  80014f:	68 70 1c 80 00       	push   $0x801c70
  800154:	e8 8f 03 00 00       	call   8004e8 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	eb 59                	jmp    8001b7 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015e:	a1 20 30 80 00       	mov    0x803020,%eax
  800163:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800169:	a1 20 30 80 00       	mov    0x803020,%eax
  80016e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	52                   	push   %edx
  800178:	50                   	push   %eax
  800179:	68 94 1c 80 00       	push   $0x801c94
  80017e:	e8 65 03 00 00       	call   8004e8 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800191:	a1 20 30 80 00       	mov    0x803020,%eax
  800196:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80019c:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a1:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001a7:	51                   	push   %ecx
  8001a8:	52                   	push   %edx
  8001a9:	50                   	push   %eax
  8001aa:	68 bc 1c 80 00       	push   $0x801cbc
  8001af:	e8 34 03 00 00       	call   8004e8 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	50                   	push   %eax
  8001c6:	68 14 1d 80 00       	push   $0x801d14
  8001cb:	e8 18 03 00 00       	call   8004e8 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 48 1c 80 00       	push   $0x801c48
  8001db:	e8 08 03 00 00       	call   8004e8 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e3:	e8 6e 12 00 00       	call   801456 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e8:	e8 1f 00 00 00       	call   80020c <exit>
}
  8001ed:	90                   	nop
  8001ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f1:	5b                   	pop    %ebx
  8001f2:	5e                   	pop    %esi
  8001f3:	5f                   	pop    %edi
  8001f4:	5d                   	pop    %ebp
  8001f5:	c3                   	ret    

008001f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	e8 7b 14 00 00       	call   801681 <sys_destroy_env>
  800206:	83 c4 10             	add    $0x10,%esp
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <exit>:

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800212:	e8 d0 14 00 00       	call   8016e7 <sys_exit_env>
}
  800217:	90                   	nop
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800220:	8d 45 10             	lea    0x10(%ebp),%eax
  800223:	83 c0 04             	add    $0x4,%eax
  800226:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800229:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80022e:	85 c0                	test   %eax,%eax
  800230:	74 16                	je     800248 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800232:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	50                   	push   %eax
  80023b:	68 8c 1d 80 00       	push   $0x801d8c
  800240:	e8 a3 02 00 00       	call   8004e8 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800248:	a1 04 30 80 00       	mov    0x803004,%eax
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	50                   	push   %eax
  800257:	68 94 1d 80 00       	push   $0x801d94
  80025c:	6a 74                	push   $0x74
  80025e:	e8 b2 02 00 00       	call   800515 <cprintf_colored>
  800263:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	ff 75 f4             	pushl  -0xc(%ebp)
  80026f:	50                   	push   %eax
  800270:	e8 04 02 00 00       	call   800479 <vcprintf>
  800275:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	6a 00                	push   $0x0
  80027d:	68 bc 1d 80 00       	push   $0x801dbc
  800282:	e8 f2 01 00 00       	call   800479 <vcprintf>
  800287:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80028a:	e8 7d ff ff ff       	call   80020c <exit>

	// should not return here
	while (1) ;
  80028f:	eb fe                	jmp    80028f <_panic+0x75>

00800291 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	74 14                	je     8002bd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	68 c0 1d 80 00       	push   $0x801dc0
  8002b1:	6a 26                	push   $0x26
  8002b3:	68 0c 1e 80 00       	push   $0x801e0c
  8002b8:	e8 5d ff ff ff       	call   80021a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002cb:	e9 c5 00 00 00       	jmp    800395 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002da:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dd:	01 d0                	add    %edx,%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	85 c0                	test   %eax,%eax
  8002e3:	75 08                	jne    8002ed <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002e5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002e8:	e9 a5 00 00 00       	jmp    800392 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002fb:	eb 69                	jmp    800366 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800302:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	c1 e0 03             	shl    $0x3,%eax
  800314:	01 c8                	add    %ecx,%eax
  800316:	8a 40 04             	mov    0x4(%eax),%al
  800319:	84 c0                	test   %al,%al
  80031b:	75 46                	jne    800363 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80031d:	a1 20 30 80 00       	mov    0x803020,%eax
  800322:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800328:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80032b:	89 d0                	mov    %edx,%eax
  80032d:	01 c0                	add    %eax,%eax
  80032f:	01 d0                	add    %edx,%eax
  800331:	c1 e0 03             	shl    $0x3,%eax
  800334:	01 c8                	add    %ecx,%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80033b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80033e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800343:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800348:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	01 c8                	add    %ecx,%eax
  800354:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	39 c2                	cmp    %eax,%edx
  800358:	75 09                	jne    800363 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80035a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800361:	eb 15                	jmp    800378 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800363:	ff 45 e8             	incl   -0x18(%ebp)
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800374:	39 c2                	cmp    %eax,%edx
  800376:	77 85                	ja     8002fd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80037c:	75 14                	jne    800392 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	68 18 1e 80 00       	push   $0x801e18
  800386:	6a 3a                	push   $0x3a
  800388:	68 0c 1e 80 00       	push   $0x801e0c
  80038d:	e8 88 fe ff ff       	call   80021a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800392:	ff 45 f0             	incl   -0x10(%ebp)
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039b:	0f 8c 2f ff ff ff    	jl     8002d0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003af:	eb 26                	jmp    8003d7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8a 40 04             	mov    0x4(%eax),%al
  8003cd:	3c 01                	cmp    $0x1,%al
  8003cf:	75 03                	jne    8003d4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003d1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d4:	ff 45 e0             	incl   -0x20(%ebp)
  8003d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e5:	39 c2                	cmp    %eax,%edx
  8003e7:	77 c8                	ja     8003b1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003ef:	74 14                	je     800405 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 6c 1e 80 00       	push   $0x801e6c
  8003f9:	6a 44                	push   $0x44
  8003fb:	68 0c 1e 80 00       	push   $0x801e0c
  800400:	e8 15 fe ff ff       	call   80021a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800405:	90                   	nop
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	53                   	push   %ebx
  80040c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80040f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 48 01             	lea    0x1(%eax),%ecx
  800417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041a:	89 0a                	mov    %ecx,(%edx)
  80041c:	8b 55 08             	mov    0x8(%ebp),%edx
  80041f:	88 d1                	mov    %dl,%cl
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800432:	75 30                	jne    800464 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800434:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80043a:	a0 44 30 80 00       	mov    0x803044,%al
  80043f:	0f b6 c0             	movzbl %al,%eax
  800442:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800445:	8b 09                	mov    (%ecx),%ecx
  800447:	89 cb                	mov    %ecx,%ebx
  800449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044c:	83 c1 08             	add    $0x8,%ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	53                   	push   %ebx
  800452:	51                   	push   %ecx
  800453:	e8 a0 0f 00 00       	call   8013f8 <sys_cputs>
  800458:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80045b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 40 04             	mov    0x4(%eax),%eax
  80046a:	8d 50 01             	lea    0x1(%eax),%edx
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	89 50 04             	mov    %edx,0x4(%eax)
}
  800473:	90                   	nop
  800474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800482:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800489:	00 00 00 
	b.cnt = 0;
  80048c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800493:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800496:	ff 75 0c             	pushl  0xc(%ebp)
  800499:	ff 75 08             	pushl  0x8(%ebp)
  80049c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a2:	50                   	push   %eax
  8004a3:	68 08 04 80 00       	push   $0x800408
  8004a8:	e8 5a 02 00 00       	call   800707 <vprintfmt>
  8004ad:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004b0:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004b6:	a0 44 30 80 00       	mov    0x803044,%al
  8004bb:	0f b6 c0             	movzbl %al,%eax
  8004be:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004c4:	52                   	push   %edx
  8004c5:	50                   	push   %eax
  8004c6:	51                   	push   %ecx
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	83 c0 08             	add    $0x8,%eax
  8004d0:	50                   	push   %eax
  8004d1:	e8 22 0f 00 00       	call   8013f8 <sys_cputs>
  8004d6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004d9:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004ee:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 f4             	pushl  -0xc(%ebp)
  800504:	50                   	push   %eax
  800505:	e8 6f ff ff ff       	call   800479 <vcprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800510:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80051b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	c1 e0 08             	shl    $0x8,%eax
  800528:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80052d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800530:	83 c0 04             	add    $0x4,%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 34 ff ff ff       	call   800479 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80054b:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800552:	07 00 00 

	return cnt;
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800558:	c9                   	leave  
  800559:	c3                   	ret    

0080055a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800560:	e8 d7 0e 00 00       	call   80143c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800565:	8d 45 0c             	lea    0xc(%ebp),%eax
  800568:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 f4             	pushl  -0xc(%ebp)
  800574:	50                   	push   %eax
  800575:	e8 ff fe ff ff       	call   800479 <vcprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800580:	e8 d1 0e 00 00       	call   801456 <sys_unlock_cons>
	return cnt;
  800585:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	53                   	push   %ebx
  80058e:	83 ec 14             	sub    $0x14,%esp
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059d:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a8:	77 55                	ja     8005ff <printnum+0x75>
  8005aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ad:	72 05                	jb     8005b4 <printnum+0x2a>
  8005af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b2:	77 4b                	ja     8005ff <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c2:	52                   	push   %edx
  8005c3:	50                   	push   %eax
  8005c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ca:	e8 a9 13 00 00       	call   801978 <__udivdi3>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	ff 75 20             	pushl  0x20(%ebp)
  8005d8:	53                   	push   %ebx
  8005d9:	ff 75 18             	pushl  0x18(%ebp)
  8005dc:	52                   	push   %edx
  8005dd:	50                   	push   %eax
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 08             	pushl  0x8(%ebp)
  8005e4:	e8 a1 ff ff ff       	call   80058a <printnum>
  8005e9:	83 c4 20             	add    $0x20,%esp
  8005ec:	eb 1a                	jmp    800608 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 20             	pushl  0x20(%ebp)
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	ff d0                	call   *%eax
  8005fc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ff:	ff 4d 1c             	decl   0x1c(%ebp)
  800602:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800606:	7f e6                	jg     8005ee <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800608:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800616:	53                   	push   %ebx
  800617:	51                   	push   %ecx
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	e8 69 14 00 00       	call   801a88 <__umoddi3>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	05 d4 20 80 00       	add    $0x8020d4,%eax
  800627:	8a 00                	mov    (%eax),%al
  800629:	0f be c0             	movsbl %al,%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	50                   	push   %eax
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
}
  80063b:	90                   	nop
  80063c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800644:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800648:	7e 1c                	jle    800666 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 50 08             	lea    0x8(%eax),%edx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 10                	mov    %edx,(%eax)
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	83 e8 08             	sub    $0x8,%eax
  80065f:	8b 50 04             	mov    0x4(%eax),%edx
  800662:	8b 00                	mov    (%eax),%eax
  800664:	eb 40                	jmp    8006a6 <getuint+0x65>
	else if (lflag)
  800666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066a:	74 1e                	je     80068a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	eb 1c                	jmp    8006a6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	8d 50 04             	lea    0x4(%eax),%edx
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	89 10                	mov    %edx,(%eax)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	83 e8 04             	sub    $0x4,%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    

008006a8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006af:	7e 1c                	jle    8006cd <getint+0x25>
		return va_arg(*ap, long long);
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	8d 50 08             	lea    0x8(%eax),%edx
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	89 10                	mov    %edx,(%eax)
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	83 e8 08             	sub    $0x8,%eax
  8006c6:	8b 50 04             	mov    0x4(%eax),%edx
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	eb 38                	jmp    800705 <getint+0x5d>
	else if (lflag)
  8006cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d1:	74 1a                	je     8006ed <getint+0x45>
		return va_arg(*ap, long);
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	8d 50 04             	lea    0x4(%eax),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	89 10                	mov    %edx,(%eax)
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	83 e8 04             	sub    $0x4,%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	99                   	cltd   
  8006eb:	eb 18                	jmp    800705 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 04             	sub    $0x4,%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	99                   	cltd   
}
  800705:	5d                   	pop    %ebp
  800706:	c3                   	ret    

00800707 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	56                   	push   %esi
  80070b:	53                   	push   %ebx
  80070c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070f:	eb 17                	jmp    800728 <vprintfmt+0x21>
			if (ch == '\0')
  800711:	85 db                	test   %ebx,%ebx
  800713:	0f 84 c1 03 00 00    	je     800ada <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	53                   	push   %ebx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	ff d0                	call   *%eax
  800725:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	8d 50 01             	lea    0x1(%eax),%edx
  80072e:	89 55 10             	mov    %edx,0x10(%ebp)
  800731:	8a 00                	mov    (%eax),%al
  800733:	0f b6 d8             	movzbl %al,%ebx
  800736:	83 fb 25             	cmp    $0x25,%ebx
  800739:	75 d6                	jne    800711 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800746:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800754:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8b 45 10             	mov    0x10(%ebp),%eax
  80075e:	8d 50 01             	lea    0x1(%eax),%edx
  800761:	89 55 10             	mov    %edx,0x10(%ebp)
  800764:	8a 00                	mov    (%eax),%al
  800766:	0f b6 d8             	movzbl %al,%ebx
  800769:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076c:	83 f8 5b             	cmp    $0x5b,%eax
  80076f:	0f 87 3d 03 00 00    	ja     800ab2 <vprintfmt+0x3ab>
  800775:	8b 04 85 f8 20 80 00 	mov    0x8020f8(,%eax,4),%eax
  80077c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800782:	eb d7                	jmp    80075b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800784:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800788:	eb d1                	jmp    80075b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800791:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800794:	89 d0                	mov    %edx,%eax
  800796:	c1 e0 02             	shl    $0x2,%eax
  800799:	01 d0                	add    %edx,%eax
  80079b:	01 c0                	add    %eax,%eax
  80079d:	01 d8                	add    %ebx,%eax
  80079f:	83 e8 30             	sub    $0x30,%eax
  8007a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ad:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b0:	7e 3e                	jle    8007f0 <vprintfmt+0xe9>
  8007b2:	83 fb 39             	cmp    $0x39,%ebx
  8007b5:	7f 39                	jg     8007f0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ba:	eb d5                	jmp    800791 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 c0 04             	add    $0x4,%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d0:	eb 1f                	jmp    8007f1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d6:	79 83                	jns    80075b <vprintfmt+0x54>
				width = 0;
  8007d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007df:	e9 77 ff ff ff       	jmp    80075b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007eb:	e9 6b ff ff ff       	jmp    80075b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f5:	0f 89 60 ff ff ff    	jns    80075b <vprintfmt+0x54>
				width = precision, precision = -1;
  8007fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800808:	e9 4e ff ff ff       	jmp    80075b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800810:	e9 46 ff ff ff       	jmp    80075b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 c0 04             	add    $0x4,%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 e8 04             	sub    $0x4,%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	50                   	push   %eax
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			break;
  800835:	e9 9b 02 00 00       	jmp    800ad5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	83 c0 04             	add    $0x4,%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 e8 04             	sub    $0x4,%eax
  800849:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084b:	85 db                	test   %ebx,%ebx
  80084d:	79 02                	jns    800851 <vprintfmt+0x14a>
				err = -err;
  80084f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800851:	83 fb 64             	cmp    $0x64,%ebx
  800854:	7f 0b                	jg     800861 <vprintfmt+0x15a>
  800856:	8b 34 9d 40 1f 80 00 	mov    0x801f40(,%ebx,4),%esi
  80085d:	85 f6                	test   %esi,%esi
  80085f:	75 19                	jne    80087a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800861:	53                   	push   %ebx
  800862:	68 e5 20 80 00       	push   $0x8020e5
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 70 02 00 00       	call   800ae2 <printfmt>
  800872:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800875:	e9 5b 02 00 00       	jmp    800ad5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087a:	56                   	push   %esi
  80087b:	68 ee 20 80 00       	push   $0x8020ee
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	ff 75 08             	pushl  0x8(%ebp)
  800886:	e8 57 02 00 00       	call   800ae2 <printfmt>
  80088b:	83 c4 10             	add    $0x10,%esp
			break;
  80088e:	e9 42 02 00 00       	jmp    800ad5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 c0 04             	add    $0x4,%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 e8 04             	sub    $0x4,%eax
  8008a2:	8b 30                	mov    (%eax),%esi
  8008a4:	85 f6                	test   %esi,%esi
  8008a6:	75 05                	jne    8008ad <vprintfmt+0x1a6>
				p = "(null)";
  8008a8:	be f1 20 80 00       	mov    $0x8020f1,%esi
			if (width > 0 && padc != '-')
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	7e 6d                	jle    800920 <vprintfmt+0x219>
  8008b3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b7:	74 67                	je     800920 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	50                   	push   %eax
  8008c0:	56                   	push   %esi
  8008c1:	e8 1e 03 00 00       	call   800be4 <strnlen>
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008cc:	eb 16                	jmp    8008e4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ce:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	ff d0                	call   *%eax
  8008de:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e8:	7f e4                	jg     8008ce <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ea:	eb 34                	jmp    800920 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f0:	74 1c                	je     80090e <vprintfmt+0x207>
  8008f2:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f5:	7e 05                	jle    8008fc <vprintfmt+0x1f5>
  8008f7:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fa:	7e 12                	jle    80090e <vprintfmt+0x207>
					putch('?', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	ff 75 0c             	pushl  0xc(%ebp)
  800902:	6a 3f                	push   $0x3f
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	eb 0f                	jmp    80091d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	89 f0                	mov    %esi,%eax
  800922:	8d 70 01             	lea    0x1(%eax),%esi
  800925:	8a 00                	mov    (%eax),%al
  800927:	0f be d8             	movsbl %al,%ebx
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	74 24                	je     800952 <vprintfmt+0x24b>
  80092e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800932:	78 b8                	js     8008ec <vprintfmt+0x1e5>
  800934:	ff 4d e0             	decl   -0x20(%ebp)
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	79 af                	jns    8008ec <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093d:	eb 13                	jmp    800952 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 20                	push   $0x20
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094f:	ff 4d e4             	decl   -0x1c(%ebp)
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800956:	7f e7                	jg     80093f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800958:	e9 78 01 00 00       	jmp    800ad5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 e8             	pushl  -0x18(%ebp)
  800963:	8d 45 14             	lea    0x14(%ebp),%eax
  800966:	50                   	push   %eax
  800967:	e8 3c fd ff ff       	call   8006a8 <getint>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800972:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097b:	85 d2                	test   %edx,%edx
  80097d:	79 23                	jns    8009a2 <vprintfmt+0x29b>
				putch('-', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	6a 2d                	push   $0x2d
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800995:	f7 d8                	neg    %eax
  800997:	83 d2 00             	adc    $0x0,%edx
  80099a:	f7 da                	neg    %edx
  80099c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a9:	e9 bc 00 00 00       	jmp    800a6a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	e8 84 fc ff ff       	call   800641 <getuint>
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cd:	e9 98 00 00 00       	jmp    800a6a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	6a 58                	push   $0x58
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	6a 58                	push   $0x58
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	6a 58                	push   $0x58
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
			break;
  800a02:	e9 ce 00 00 00       	jmp    800ad5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	6a 30                	push   $0x30
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	6a 78                	push   $0x78
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	ff d0                	call   *%eax
  800a24:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 e8 04             	sub    $0x4,%eax
  800a36:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a42:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	e8 e7 fb ff ff       	call   800641 <getuint>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a71:	83 ec 04             	sub    $0x4,%esp
  800a74:	52                   	push   %edx
  800a75:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a78:	50                   	push   %eax
  800a79:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	ff 75 08             	pushl  0x8(%ebp)
  800a85:	e8 00 fb ff ff       	call   80058a <printnum>
  800a8a:	83 c4 20             	add    $0x20,%esp
			break;
  800a8d:	eb 46                	jmp    800ad5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	eb 35                	jmp    800ad5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa0:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aa7:	eb 2c                	jmp    800ad5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ab0:	eb 23                	jmp    800ad5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	6a 25                	push   $0x25
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac2:	ff 4d 10             	decl   0x10(%ebp)
  800ac5:	eb 03                	jmp    800aca <vprintfmt+0x3c3>
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	8b 45 10             	mov    0x10(%ebp),%eax
  800acd:	48                   	dec    %eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	3c 25                	cmp    $0x25,%al
  800ad2:	75 f3                	jne    800ac7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad4:	90                   	nop
		}
	}
  800ad5:	e9 35 fc ff ff       	jmp    80070f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ada:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae8:	8d 45 10             	lea    0x10(%ebp),%eax
  800aeb:	83 c0 04             	add    $0x4,%eax
  800aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	ff 75 f4             	pushl  -0xc(%ebp)
  800af7:	50                   	push   %eax
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 04 fc ff ff       	call   800707 <vprintfmt>
  800b03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b06:	90                   	nop
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 08             	mov    0x8(%eax),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8b 10                	mov    (%eax),%edx
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 40 04             	mov    0x4(%eax),%eax
  800b26:	39 c2                	cmp    %eax,%edx
  800b28:	73 12                	jae    800b3c <sprintputch+0x33>
		*b->buf++ = ch;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	89 0a                	mov    %ecx,(%edx)
  800b37:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3a:	88 10                	mov    %dl,(%eax)
}
  800b3c:	90                   	nop
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	01 d0                	add    %edx,%eax
  800b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b64:	74 06                	je     800b6c <vsnprintf+0x2d>
  800b66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6a:	7f 07                	jg     800b73 <vsnprintf+0x34>
		return -E_INVAL;
  800b6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b71:	eb 20                	jmp    800b93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b73:	ff 75 14             	pushl  0x14(%ebp)
  800b76:	ff 75 10             	pushl  0x10(%ebp)
  800b79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7c:	50                   	push   %eax
  800b7d:	68 09 0b 80 00       	push   $0x800b09
  800b82:	e8 80 fb ff ff       	call   800707 <vprintfmt>
  800b87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9e:	83 c0 04             	add    $0x4,%eax
  800ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  800baa:	50                   	push   %eax
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 89 ff ff ff       	call   800b3f <vsnprintf>
  800bb6:	83 c4 10             	add    $0x10,%esp
  800bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bce:	eb 06                	jmp    800bd6 <strlen+0x15>
		n++;
  800bd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd3:	ff 45 08             	incl   0x8(%ebp)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	84 c0                	test   %al,%al
  800bdd:	75 f1                	jne    800bd0 <strlen+0xf>
		n++;
	return n;
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf1:	eb 09                	jmp    800bfc <strnlen+0x18>
		n++;
  800bf3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf6:	ff 45 08             	incl   0x8(%ebp)
  800bf9:	ff 4d 0c             	decl   0xc(%ebp)
  800bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c00:	74 09                	je     800c0b <strnlen+0x27>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	84 c0                	test   %al,%al
  800c09:	75 e8                	jne    800bf3 <strnlen+0xf>
		n++;
	return n;
  800c0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1c:	90                   	nop
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8d 50 01             	lea    0x1(%eax),%edx
  800c23:	89 55 08             	mov    %edx,0x8(%ebp)
  800c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	84 c0                	test   %al,%al
  800c37:	75 e4                	jne    800c1d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3c:	c9                   	leave  
  800c3d:	c3                   	ret    

00800c3e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c51:	eb 1f                	jmp    800c72 <strncpy+0x34>
		*dst++ = *src;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5f:	8a 12                	mov    (%edx),%dl
  800c61:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	84 c0                	test   %al,%al
  800c6a:	74 03                	je     800c6f <strncpy+0x31>
			src++;
  800c6c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6f:	ff 45 fc             	incl   -0x4(%ebp)
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c78:	72 d9                	jb     800c53 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8f:	74 30                	je     800cc1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c91:	eb 16                	jmp    800ca9 <strlcpy+0x2a>
			*dst++ = *src++;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8d 50 01             	lea    0x1(%eax),%edx
  800c99:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca9:	ff 4d 10             	decl   0x10(%ebp)
  800cac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb0:	74 09                	je     800cbb <strlcpy+0x3c>
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	75 d8                	jne    800c93 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc7:	29 c2                	sub    %eax,%edx
  800cc9:	89 d0                	mov    %edx,%eax
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd0:	eb 06                	jmp    800cd8 <strcmp+0xb>
		p++, q++;
  800cd2:	ff 45 08             	incl   0x8(%ebp)
  800cd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	84 c0                	test   %al,%al
  800cdf:	74 0e                	je     800cef <strcmp+0x22>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 10                	mov    (%eax),%dl
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	38 c2                	cmp    %al,%dl
  800ced:	74 e3                	je     800cd2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	0f b6 d0             	movzbl %al,%edx
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 c0             	movzbl %al,%eax
  800cff:	29 c2                	sub    %eax,%edx
  800d01:	89 d0                	mov    %edx,%eax
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d08:	eb 09                	jmp    800d13 <strncmp+0xe>
		n--, p++, q++;
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d17:	74 17                	je     800d30 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	84 c0                	test   %al,%al
  800d20:	74 0e                	je     800d30 <strncmp+0x2b>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 10                	mov    (%eax),%dl
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	38 c2                	cmp    %al,%dl
  800d2e:	74 da                	je     800d0a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d34:	75 07                	jne    800d3d <strncmp+0x38>
		return 0;
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	eb 14                	jmp    800d51 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 d0             	movzbl %al,%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	0f b6 c0             	movzbl %al,%eax
  800d4d:	29 c2                	sub    %eax,%edx
  800d4f:	89 d0                	mov    %edx,%eax
}
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 12                	jmp    800d73 <strchr+0x20>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	75 05                	jne    800d70 <strchr+0x1d>
			return (char *) s;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	eb 11                	jmp    800d81 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d70:	ff 45 08             	incl   0x8(%ebp)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e5                	jne    800d61 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8f:	eb 0d                	jmp    800d9e <strfind+0x1b>
		if (*s == c)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d99:	74 0e                	je     800da9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 ea                	jne    800d91 <strfind+0xe>
  800da7:	eb 01                	jmp    800daa <strfind+0x27>
		if (*s == c)
			break;
  800da9:	90                   	nop
	return (char *) s;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dbb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dbf:	76 63                	jbe    800e24 <memset+0x75>
		uint64 data_block = c;
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	99                   	cltd   
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dd5:	c1 e0 08             	shl    $0x8,%eax
  800dd8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ddb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800de8:	c1 e0 10             	shl    $0x10,%eax
  800deb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dee:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df7:	89 c2                	mov    %eax,%edx
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfe:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e01:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e04:	eb 18                	jmp    800e1e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e06:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e09:	8d 41 08             	lea    0x8(%ecx),%eax
  800e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e15:	89 01                	mov    %eax,(%ecx)
  800e17:	89 51 04             	mov    %edx,0x4(%ecx)
  800e1a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e22:	77 e2                	ja     800e06 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e28:	74 23                	je     800e4d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e30:	eb 0e                	jmp    800e40 <memset+0x91>
			*p8++ = (uint8)c;
  800e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e35:	8d 50 01             	lea    0x1(%eax),%edx
  800e38:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e46:	89 55 10             	mov    %edx,0x10(%ebp)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 e5                	jne    800e32 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e64:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e68:	76 24                	jbe    800e8e <memcpy+0x3c>
		while(n >= 8){
  800e6a:	eb 1c                	jmp    800e88 <memcpy+0x36>
			*d64 = *s64;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8b 50 04             	mov    0x4(%eax),%edx
  800e72:	8b 00                	mov    (%eax),%eax
  800e74:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e77:	89 01                	mov    %eax,(%ecx)
  800e79:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e7c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e80:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e84:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e88:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8c:	77 de                	ja     800e6c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e92:	74 31                	je     800ec5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ea0:	eb 16                	jmp    800eb8 <memcpy+0x66>
			*d8++ = *s8++;
  800ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eb4:	8a 12                	mov    (%edx),%dl
  800eb6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebe:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	75 dd                	jne    800ea2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee2:	73 50                	jae    800f34 <memmove+0x6a>
  800ee4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eea:	01 d0                	add    %edx,%eax
  800eec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eef:	76 43                	jbe    800f34 <memmove+0x6a>
		s += n;
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efd:	eb 10                	jmp    800f0f <memmove+0x45>
			*--d = *--s;
  800eff:	ff 4d f8             	decl   -0x8(%ebp)
  800f02:	ff 4d fc             	decl   -0x4(%ebp)
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f08:	8a 10                	mov    (%eax),%dl
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 e3                	jne    800eff <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1c:	eb 23                	jmp    800f41 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f30:	8a 12                	mov    (%edx),%dl
  800f32:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	75 dd                	jne    800f1e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f58:	eb 2a                	jmp    800f84 <memcmp+0x3e>
		if (*s1 != *s2)
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	8a 10                	mov    (%eax),%dl
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	38 c2                	cmp    %al,%dl
  800f66:	74 16                	je     800f7e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f b6 d0             	movzbl %al,%edx
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 c0             	movzbl %al,%eax
  800f78:	29 c2                	sub    %eax,%edx
  800f7a:	89 d0                	mov    %edx,%eax
  800f7c:	eb 18                	jmp    800f96 <memcmp+0x50>
		s1++, s2++;
  800f7e:	ff 45 fc             	incl   -0x4(%ebp)
  800f81:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	75 c9                	jne    800f5a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa9:	eb 15                	jmp    800fc0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 d0             	movzbl %al,%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	0f b6 c0             	movzbl %al,%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	74 0d                	je     800fca <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fbd:	ff 45 08             	incl   0x8(%ebp)
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc6:	72 e3                	jb     800fab <memfind+0x13>
  800fc8:	eb 01                	jmp    800fcb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fca:	90                   	nop
	return (void *) s;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fdd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	eb 03                	jmp    800fe9 <strtol+0x19>
		s++;
  800fe6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 20                	cmp    $0x20,%al
  800ff0:	74 f4                	je     800fe6 <strtol+0x16>
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	3c 09                	cmp    $0x9,%al
  800ff9:	74 eb                	je     800fe6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 2b                	cmp    $0x2b,%al
  801002:	75 05                	jne    801009 <strtol+0x39>
		s++;
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	eb 13                	jmp    80101c <strtol+0x4c>
	else if (*s == '-')
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 2d                	cmp    $0x2d,%al
  801010:	75 0a                	jne    80101c <strtol+0x4c>
		s++, neg = 1;
  801012:	ff 45 08             	incl   0x8(%ebp)
  801015:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801020:	74 06                	je     801028 <strtol+0x58>
  801022:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801026:	75 20                	jne    801048 <strtol+0x78>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 30                	cmp    $0x30,%al
  80102f:	75 17                	jne    801048 <strtol+0x78>
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	40                   	inc    %eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 78                	cmp    $0x78,%al
  801039:	75 0d                	jne    801048 <strtol+0x78>
		s += 2, base = 16;
  80103b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801046:	eb 28                	jmp    801070 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104c:	75 15                	jne    801063 <strtol+0x93>
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3c 30                	cmp    $0x30,%al
  801055:	75 0c                	jne    801063 <strtol+0x93>
		s++, base = 8;
  801057:	ff 45 08             	incl   0x8(%ebp)
  80105a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801061:	eb 0d                	jmp    801070 <strtol+0xa0>
	else if (base == 0)
  801063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801067:	75 07                	jne    801070 <strtol+0xa0>
		base = 10;
  801069:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 2f                	cmp    $0x2f,%al
  801077:	7e 19                	jle    801092 <strtol+0xc2>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 39                	cmp    $0x39,%al
  801080:	7f 10                	jg     801092 <strtol+0xc2>
			dig = *s - '0';
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f be c0             	movsbl %al,%eax
  80108a:	83 e8 30             	sub    $0x30,%eax
  80108d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801090:	eb 42                	jmp    8010d4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 60                	cmp    $0x60,%al
  801099:	7e 19                	jle    8010b4 <strtol+0xe4>
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 7a                	cmp    $0x7a,%al
  8010a2:	7f 10                	jg     8010b4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	0f be c0             	movsbl %al,%eax
  8010ac:	83 e8 57             	sub    $0x57,%eax
  8010af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b2:	eb 20                	jmp    8010d4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 40                	cmp    $0x40,%al
  8010bb:	7e 39                	jle    8010f6 <strtol+0x126>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 5a                	cmp    $0x5a,%al
  8010c4:	7f 30                	jg     8010f6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 37             	sub    $0x37,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010da:	7d 19                	jge    8010f5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e6:	89 c2                	mov    %eax,%edx
  8010e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f0:	e9 7b ff ff ff       	jmp    801070 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fa:	74 08                	je     801104 <strtol+0x134>
		*endptr = (char *) s;
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801102:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801104:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801108:	74 07                	je     801111 <strtol+0x141>
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	f7 d8                	neg    %eax
  80110f:	eb 03                	jmp    801114 <strtol+0x144>
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <ltostr>:

void
ltostr(long value, char *str)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80111c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801123:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80112a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80112e:	79 13                	jns    801143 <ltostr+0x2d>
	{
		neg = 1;
  801130:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80113d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801140:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80114b:	99                   	cltd   
  80114c:	f7 f9                	idiv   %ecx
  80114e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	8d 50 01             	lea    0x1(%eax),%edx
  801157:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801164:	83 c2 30             	add    $0x30,%edx
  801167:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801171:	f7 e9                	imul   %ecx
  801173:	c1 fa 02             	sar    $0x2,%edx
  801176:	89 c8                	mov    %ecx,%eax
  801178:	c1 f8 1f             	sar    $0x1f,%eax
  80117b:	29 c2                	sub    %eax,%edx
  80117d:	89 d0                	mov    %edx,%eax
  80117f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801186:	75 bb                	jne    801143 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	48                   	dec    %eax
  801193:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801196:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119a:	74 3d                	je     8011d9 <ltostr+0xc3>
		start = 1 ;
  80119c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a3:	eb 34                	jmp    8011d9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	01 c2                	add    %eax,%edx
  8011ba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	01 c8                	add    %ecx,%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	01 c2                	add    %eax,%edx
  8011ce:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d1:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011df:	7c c4                	jl     8011a5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ec:	90                   	nop
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f5:	ff 75 08             	pushl  0x8(%ebp)
  8011f8:	e8 c4 f9 ff ff       	call   800bc1 <strlen>
  8011fd:	83 c4 04             	add    $0x4,%esp
  801200:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	e8 b6 f9 ff ff       	call   800bc1 <strlen>
  80120b:	83 c4 04             	add    $0x4,%esp
  80120e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121f:	eb 17                	jmp    801238 <strcconcat+0x49>
		final[s] = str1[s] ;
  801221:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	01 c2                	add    %eax,%edx
  801229:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	01 c8                	add    %ecx,%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801235:	ff 45 fc             	incl   -0x4(%ebp)
  801238:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80123e:	7c e1                	jl     801221 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801240:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801247:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80124e:	eb 1f                	jmp    80126f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801253:	8d 50 01             	lea    0x1(%eax),%edx
  801256:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801259:	89 c2                	mov    %eax,%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	01 c8                	add    %ecx,%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126c:	ff 45 f8             	incl   -0x8(%ebp)
  80126f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801272:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801275:	7c d9                	jl     801250 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801277:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c6 00 00             	movb   $0x0,(%eax)
}
  801282:	90                   	nop
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a8:	eb 0c                	jmp    8012b6 <strsplit+0x31>
			*string++ = 0;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8d 50 01             	lea    0x1(%eax),%edx
  8012b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 18                	je     8012d7 <strsplit+0x52>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 83 fa ff ff       	call   800d53 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	75 d3                	jne    8012aa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	84 c0                	test   %al,%al
  8012de:	74 5a                	je     80133a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 f8 0f             	cmp    $0xf,%eax
  8012e8:	75 07                	jne    8012f1 <strsplit+0x6c>
		{
			return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ef:	eb 66                	jmp    801357 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fc:	89 0a                	mov    %ecx,(%edx)
  8012fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130f:	eb 03                	jmp    801314 <strsplit+0x8f>
			string++;
  801311:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	84 c0                	test   %al,%al
  80131b:	74 8b                	je     8012a8 <strsplit+0x23>
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	50                   	push   %eax
  801326:	ff 75 0c             	pushl  0xc(%ebp)
  801329:	e8 25 fa ff ff       	call   800d53 <strchr>
  80132e:	83 c4 08             	add    $0x8,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	74 dc                	je     801311 <strsplit+0x8c>
			string++;
	}
  801335:	e9 6e ff ff ff       	jmp    8012a8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80133a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80133b:	8b 45 14             	mov    0x14(%ebp),%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801352:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136c:	eb 4a                	jmp    8013b8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80136e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	01 c2                	add    %eax,%edx
  801376:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	01 c8                	add    %ecx,%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801382:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 40                	cmp    $0x40,%al
  80138e:	7e 25                	jle    8013b5 <str2lower+0x5c>
  801390:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	01 d0                	add    %edx,%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	3c 5a                	cmp    $0x5a,%al
  80139c:	7f 17                	jg     8013b5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80139e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ac:	01 ca                	add    %ecx,%edx
  8013ae:	8a 12                	mov    (%edx),%dl
  8013b0:	83 c2 20             	add    $0x20,%edx
  8013b3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013b5:	ff 45 fc             	incl   -0x4(%ebp)
  8013b8:	ff 75 0c             	pushl  0xc(%ebp)
  8013bb:	e8 01 f8 ff ff       	call   800bc1 <strlen>
  8013c0:	83 c4 04             	add    $0x4,%esp
  8013c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013c6:	7f a6                	jg     80136e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013e2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013e5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013e8:	cd 30                	int    $0x30
  8013ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	5b                   	pop    %ebx
  8013f4:	5e                   	pop    %esi
  8013f5:	5f                   	pop    %edi
  8013f6:	5d                   	pop    %ebp
  8013f7:	c3                   	ret    

008013f8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801401:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801404:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801407:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	6a 00                	push   $0x0
  801410:	51                   	push   %ecx
  801411:	52                   	push   %edx
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	50                   	push   %eax
  801416:	6a 00                	push   $0x0
  801418:	e8 b0 ff ff ff       	call   8013cd <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	90                   	nop
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_cgetc>:

int
sys_cgetc(void)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 02                	push   $0x2
  801432:	e8 96 ff ff ff       	call   8013cd <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 03                	push   $0x3
  80144b:	e8 7d ff ff ff       	call   8013cd <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	90                   	nop
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 04                	push   $0x4
  801465:	e8 63 ff ff ff       	call   8013cd <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	52                   	push   %edx
  801480:	50                   	push   %eax
  801481:	6a 08                	push   $0x8
  801483:	e8 45 ff ff ff       	call   8013cd <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801492:	8b 75 18             	mov    0x18(%ebp),%esi
  801495:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801498:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
  8014a3:	51                   	push   %ecx
  8014a4:	52                   	push   %edx
  8014a5:	50                   	push   %eax
  8014a6:	6a 09                	push   $0x9
  8014a8:	e8 20 ff ff ff       	call   8013cd <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b3:	5b                   	pop    %ebx
  8014b4:	5e                   	pop    %esi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	ff 75 08             	pushl  0x8(%ebp)
  8014c5:	6a 0a                	push   $0xa
  8014c7:	e8 01 ff ff ff       	call   8013cd <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	6a 0b                	push   $0xb
  8014e2:	e8 e6 fe ff ff       	call   8013cd <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 0c                	push   $0xc
  8014fb:	e8 cd fe ff ff       	call   8013cd <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 0d                	push   $0xd
  801514:	e8 b4 fe ff ff       	call   8013cd <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 0e                	push   $0xe
  80152d:	e8 9b fe ff ff       	call   8013cd <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 0f                	push   $0xf
  801546:	e8 82 fe ff ff       	call   8013cd <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	6a 10                	push   $0x10
  801560:	e8 68 fe ff ff       	call   8013cd <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 11                	push   $0x11
  801579:	e8 4f fe ff ff       	call   8013cd <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	90                   	nop
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_cputc>:

void
sys_cputc(const char c)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801590:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	50                   	push   %eax
  80159d:	6a 01                	push   $0x1
  80159f:	e8 29 fe ff ff       	call   8013cd <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 14                	push   $0x14
  8015b9:	e8 0f fe ff ff       	call   8013cd <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	90                   	nop
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	6a 00                	push   $0x0
  8015dc:	51                   	push   %ecx
  8015dd:	52                   	push   %edx
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	6a 15                	push   $0x15
  8015e4:	e8 e4 fd ff ff       	call   8013cd <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	6a 16                	push   $0x16
  801601:	e8 c7 fd ff ff       	call   8013cd <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	51                   	push   %ecx
  80161c:	52                   	push   %edx
  80161d:	50                   	push   %eax
  80161e:	6a 17                	push   $0x17
  801620:	e8 a8 fd ff ff       	call   8013cd <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80162d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	6a 18                	push   $0x18
  80163d:	e8 8b fd ff ff       	call   8013cd <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 14             	pushl  0x14(%ebp)
  801652:	ff 75 10             	pushl  0x10(%ebp)
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	50                   	push   %eax
  801659:	6a 19                	push   $0x19
  80165b:	e8 6d fd ff ff       	call   8013cd <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	50                   	push   %eax
  801674:	6a 1a                	push   $0x1a
  801676:	e8 52 fd ff ff       	call   8013cd <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	90                   	nop
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	50                   	push   %eax
  801690:	6a 1b                	push   $0x1b
  801692:	e8 36 fd ff ff       	call   8013cd <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 05                	push   $0x5
  8016ab:	e8 1d fd ff ff       	call   8013cd <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 06                	push   $0x6
  8016c4:	e8 04 fd ff ff       	call   8013cd <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 07                	push   $0x7
  8016dd:	e8 eb fc ff ff       	call   8013cd <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 1c                	push   $0x1c
  8016f6:	e8 d2 fc ff ff       	call   8013cd <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801707:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80170a:	8d 50 04             	lea    0x4(%eax),%edx
  80170d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	52                   	push   %edx
  801717:	50                   	push   %eax
  801718:	6a 1d                	push   $0x1d
  80171a:	e8 ae fc ff ff       	call   8013cd <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
	return result;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801728:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172b:	89 01                	mov    %eax,(%ecx)
  80172d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	c9                   	leave  
  801734:	c2 04 00             	ret    $0x4

00801737 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	ff 75 10             	pushl  0x10(%ebp)
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	6a 13                	push   $0x13
  801749:	e8 7f fc ff ff       	call   8013cd <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return ;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_rcr2>:
uint32 sys_rcr2()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 1e                	push   $0x1e
  801763:	e8 65 fc ff ff       	call   8013cd <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801779:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	50                   	push   %eax
  801786:	6a 1f                	push   $0x1f
  801788:	e8 40 fc ff ff       	call   8013cd <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
	return ;
  801790:	90                   	nop
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <rsttst>:
void rsttst()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 21                	push   $0x21
  8017a2:	e8 26 fc ff ff       	call   8013cd <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8017bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	ff 75 10             	pushl  0x10(%ebp)
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	ff 75 08             	pushl  0x8(%ebp)
  8017cb:	6a 20                	push   $0x20
  8017cd:	e8 fb fb ff ff       	call   8013cd <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d5:	90                   	nop
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <chktst>:
void chktst(uint32 n)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	6a 22                	push   $0x22
  8017e8:	e8 e0 fb ff ff       	call   8013cd <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f0:	90                   	nop
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <inctst>:

void inctst()
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 23                	push   $0x23
  801802:	e8 c6 fb ff ff       	call   8013cd <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
	return ;
  80180a:	90                   	nop
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <gettst>:
uint32 gettst()
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 24                	push   $0x24
  80181c:	e8 ac fb ff ff       	call   8013cd <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 25                	push   $0x25
  801835:	e8 93 fb ff ff       	call   8013cd <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
  80183d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801842:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	6a 26                	push   $0x26
  801861:	e8 67 fb ff ff       	call   8013cd <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
	return ;
  801869:	90                   	nop
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801870:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801873:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	53                   	push   %ebx
  80187f:	51                   	push   %ecx
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 27                	push   $0x27
  801884:	e8 44 fb ff ff       	call   8013cd <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 28                	push   $0x28
  8018a4:	e8 24 fb ff ff       	call   8013cd <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	51                   	push   %ecx
  8018bd:	ff 75 10             	pushl  0x10(%ebp)
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 29                	push   $0x29
  8018c4:	e8 04 fb ff ff       	call   8013cd <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 10             	pushl  0x10(%ebp)
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	6a 12                	push   $0x12
  8018e0:	e8 e8 fa ff ff       	call   8013cd <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e8:	90                   	nop
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 2a                	push   $0x2a
  8018fe:	e8 ca fa ff ff       	call   8013cd <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 2b                	push   $0x2b
  801918:	e8 b0 fa ff ff       	call   8013cd <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	6a 2d                	push   $0x2d
  801933:	e8 95 fa ff ff       	call   8013cd <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
	return;
  80193b:	90                   	nop
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	6a 2c                	push   $0x2c
  80194f:	e8 79 fa ff ff       	call   8013cd <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return ;
  801957:	90                   	nop
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 68 22 80 00       	push   $0x802268
  801968:	68 25 01 00 00       	push   $0x125
  80196d:	68 9b 22 80 00       	push   $0x80229b
  801972:	e8 a3 e8 ff ff       	call   80021a <_panic>
  801977:	90                   	nop

00801978 <__udivdi3>:
  801978:	55                   	push   %ebp
  801979:	57                   	push   %edi
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801983:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198f:	89 ca                	mov    %ecx,%edx
  801991:	89 f8                	mov    %edi,%eax
  801993:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801997:	85 f6                	test   %esi,%esi
  801999:	75 2d                	jne    8019c8 <__udivdi3+0x50>
  80199b:	39 cf                	cmp    %ecx,%edi
  80199d:	77 65                	ja     801a04 <__udivdi3+0x8c>
  80199f:	89 fd                	mov    %edi,%ebp
  8019a1:	85 ff                	test   %edi,%edi
  8019a3:	75 0b                	jne    8019b0 <__udivdi3+0x38>
  8019a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019aa:	31 d2                	xor    %edx,%edx
  8019ac:	f7 f7                	div    %edi
  8019ae:	89 c5                	mov    %eax,%ebp
  8019b0:	31 d2                	xor    %edx,%edx
  8019b2:	89 c8                	mov    %ecx,%eax
  8019b4:	f7 f5                	div    %ebp
  8019b6:	89 c1                	mov    %eax,%ecx
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	f7 f5                	div    %ebp
  8019bc:	89 cf                	mov    %ecx,%edi
  8019be:	89 fa                	mov    %edi,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	77 28                	ja     8019f4 <__udivdi3+0x7c>
  8019cc:	0f bd fe             	bsr    %esi,%edi
  8019cf:	83 f7 1f             	xor    $0x1f,%edi
  8019d2:	75 40                	jne    801a14 <__udivdi3+0x9c>
  8019d4:	39 ce                	cmp    %ecx,%esi
  8019d6:	72 0a                	jb     8019e2 <__udivdi3+0x6a>
  8019d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019dc:	0f 87 9e 00 00 00    	ja     801a80 <__udivdi3+0x108>
  8019e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e7:	89 fa                	mov    %edi,%edx
  8019e9:	83 c4 1c             	add    $0x1c,%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5f                   	pop    %edi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    
  8019f1:	8d 76 00             	lea    0x0(%esi),%esi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	31 c0                	xor    %eax,%eax
  8019f8:	89 fa                	mov    %edi,%edx
  8019fa:	83 c4 1c             	add    $0x1c,%esp
  8019fd:	5b                   	pop    %ebx
  8019fe:	5e                   	pop    %esi
  8019ff:	5f                   	pop    %edi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	89 d8                	mov    %ebx,%eax
  801a06:	f7 f7                	div    %edi
  801a08:	31 ff                	xor    %edi,%edi
  801a0a:	89 fa                	mov    %edi,%edx
  801a0c:	83 c4 1c             	add    $0x1c,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
  801a14:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a19:	89 eb                	mov    %ebp,%ebx
  801a1b:	29 fb                	sub    %edi,%ebx
  801a1d:	89 f9                	mov    %edi,%ecx
  801a1f:	d3 e6                	shl    %cl,%esi
  801a21:	89 c5                	mov    %eax,%ebp
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ed                	shr    %cl,%ebp
  801a27:	89 e9                	mov    %ebp,%ecx
  801a29:	09 f1                	or     %esi,%ecx
  801a2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e0                	shl    %cl,%eax
  801a33:	89 c5                	mov    %eax,%ebp
  801a35:	89 d6                	mov    %edx,%esi
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 ee                	shr    %cl,%esi
  801a3b:	89 f9                	mov    %edi,%ecx
  801a3d:	d3 e2                	shl    %cl,%edx
  801a3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a43:	88 d9                	mov    %bl,%cl
  801a45:	d3 e8                	shr    %cl,%eax
  801a47:	09 c2                	or     %eax,%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	f7 74 24 0c          	divl   0xc(%esp)
  801a51:	89 d6                	mov    %edx,%esi
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	f7 e5                	mul    %ebp
  801a57:	39 d6                	cmp    %edx,%esi
  801a59:	72 19                	jb     801a74 <__udivdi3+0xfc>
  801a5b:	74 0b                	je     801a68 <__udivdi3+0xf0>
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 58 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a6c:	89 f9                	mov    %edi,%ecx
  801a6e:	d3 e2                	shl    %cl,%edx
  801a70:	39 c2                	cmp    %eax,%edx
  801a72:	73 e9                	jae    801a5d <__udivdi3+0xe5>
  801a74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a77:	31 ff                	xor    %edi,%edi
  801a79:	e9 40 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	31 c0                	xor    %eax,%eax
  801a82:	e9 37 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a87:	90                   	nop

00801a88 <__umoddi3>:
  801a88:	55                   	push   %ebp
  801a89:	57                   	push   %edi
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa7:	89 f3                	mov    %esi,%ebx
  801aa9:	89 fa                	mov    %edi,%edx
  801aab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aaf:	89 34 24             	mov    %esi,(%esp)
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	75 1a                	jne    801ad0 <__umoddi3+0x48>
  801ab6:	39 f7                	cmp    %esi,%edi
  801ab8:	0f 86 a2 00 00 00    	jbe    801b60 <__umoddi3+0xd8>
  801abe:	89 c8                	mov    %ecx,%eax
  801ac0:	89 f2                	mov    %esi,%edx
  801ac2:	f7 f7                	div    %edi
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	31 d2                	xor    %edx,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	39 f0                	cmp    %esi,%eax
  801ad2:	0f 87 ac 00 00 00    	ja     801b84 <__umoddi3+0xfc>
  801ad8:	0f bd e8             	bsr    %eax,%ebp
  801adb:	83 f5 1f             	xor    $0x1f,%ebp
  801ade:	0f 84 ac 00 00 00    	je     801b90 <__umoddi3+0x108>
  801ae4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae9:	29 ef                	sub    %ebp,%edi
  801aeb:	89 fe                	mov    %edi,%esi
  801aed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e0                	shl    %cl,%eax
  801af5:	89 d7                	mov    %edx,%edi
  801af7:	89 f1                	mov    %esi,%ecx
  801af9:	d3 ef                	shr    %cl,%edi
  801afb:	09 c7                	or     %eax,%edi
  801afd:	89 e9                	mov    %ebp,%ecx
  801aff:	d3 e2                	shl    %cl,%edx
  801b01:	89 14 24             	mov    %edx,(%esp)
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	d3 e0                	shl    %cl,%eax
  801b08:	89 c2                	mov    %eax,%edx
  801b0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b18:	89 f1                	mov    %esi,%ecx
  801b1a:	d3 e8                	shr    %cl,%eax
  801b1c:	09 d0                	or     %edx,%eax
  801b1e:	d3 eb                	shr    %cl,%ebx
  801b20:	89 da                	mov    %ebx,%edx
  801b22:	f7 f7                	div    %edi
  801b24:	89 d3                	mov    %edx,%ebx
  801b26:	f7 24 24             	mull   (%esp)
  801b29:	89 c6                	mov    %eax,%esi
  801b2b:	89 d1                	mov    %edx,%ecx
  801b2d:	39 d3                	cmp    %edx,%ebx
  801b2f:	0f 82 87 00 00 00    	jb     801bbc <__umoddi3+0x134>
  801b35:	0f 84 91 00 00 00    	je     801bcc <__umoddi3+0x144>
  801b3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3f:	29 f2                	sub    %esi,%edx
  801b41:	19 cb                	sbb    %ecx,%ebx
  801b43:	89 d8                	mov    %ebx,%eax
  801b45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b49:	d3 e0                	shl    %cl,%eax
  801b4b:	89 e9                	mov    %ebp,%ecx
  801b4d:	d3 ea                	shr    %cl,%edx
  801b4f:	09 d0                	or     %edx,%eax
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 eb                	shr    %cl,%ebx
  801b55:	89 da                	mov    %ebx,%edx
  801b57:	83 c4 1c             	add    $0x1c,%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    
  801b5f:	90                   	nop
  801b60:	89 fd                	mov    %edi,%ebp
  801b62:	85 ff                	test   %edi,%edi
  801b64:	75 0b                	jne    801b71 <__umoddi3+0xe9>
  801b66:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6b:	31 d2                	xor    %edx,%edx
  801b6d:	f7 f7                	div    %edi
  801b6f:	89 c5                	mov    %eax,%ebp
  801b71:	89 f0                	mov    %esi,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f5                	div    %ebp
  801b77:	89 c8                	mov    %ecx,%eax
  801b79:	f7 f5                	div    %ebp
  801b7b:	89 d0                	mov    %edx,%eax
  801b7d:	e9 44 ff ff ff       	jmp    801ac6 <__umoddi3+0x3e>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 c8                	mov    %ecx,%eax
  801b86:	89 f2                	mov    %esi,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	3b 04 24             	cmp    (%esp),%eax
  801b93:	72 06                	jb     801b9b <__umoddi3+0x113>
  801b95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b99:	77 0f                	ja     801baa <__umoddi3+0x122>
  801b9b:	89 f2                	mov    %esi,%edx
  801b9d:	29 f9                	sub    %edi,%ecx
  801b9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ba3:	89 14 24             	mov    %edx,(%esp)
  801ba6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801baa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bae:	8b 14 24             	mov    (%esp),%edx
  801bb1:	83 c4 1c             	add    $0x1c,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5f                   	pop    %edi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
  801bb9:	8d 76 00             	lea    0x0(%esi),%esi
  801bbc:	2b 04 24             	sub    (%esp),%eax
  801bbf:	19 fa                	sbb    %edi,%edx
  801bc1:	89 d1                	mov    %edx,%ecx
  801bc3:	89 c6                	mov    %eax,%esi
  801bc5:	e9 71 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd0:	72 ea                	jb     801bbc <__umoddi3+0x134>
  801bd2:	89 d9                	mov    %ebx,%ecx
  801bd4:	e9 62 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
