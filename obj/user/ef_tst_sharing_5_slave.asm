
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 26 00 00 00       	call   80005c <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	printStats = 0;
  80003e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800045:	00 00 00 
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	68 00 1c 80 00       	push   $0x801c00
  800050:	6a 11                	push   $0x11
  800052:	68 31 1c 80 00       	push   $0x801c31
  800057:	e8 c5 01 00 00       	call   800221 <_panic>

0080005c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	57                   	push   %edi
  800060:	56                   	push   %esi
  800061:	53                   	push   %ebx
  800062:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800065:	e8 52 16 00 00       	call   8016bc <sys_getenvindex>
  80006a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80006d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800070:	89 d0                	mov    %edx,%eax
  800072:	c1 e0 06             	shl    $0x6,%eax
  800075:	29 d0                	sub    %edx,%eax
  800077:	c1 e0 02             	shl    $0x2,%eax
  80007a:	01 d0                	add    %edx,%eax
  80007c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800083:	01 c8                	add    %ecx,%eax
  800085:	c1 e0 03             	shl    $0x3,%eax
  800088:	01 d0                	add    %edx,%eax
  80008a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800091:	29 c2                	sub    %eax,%edx
  800093:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80009a:	89 c2                	mov    %eax,%edx
  80009c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000a2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8a 40 20             	mov    0x20(%eax),%al
  8000af:	84 c0                	test   %al,%al
  8000b1:	74 0d                	je     8000c0 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b8:	83 c0 20             	add    $0x20,%eax
  8000bb:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c4:	7e 0a                	jle    8000d0 <libmain+0x74>
		binaryname = argv[0];
  8000c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c9:	8b 00                	mov    (%eax),%eax
  8000cb:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 75 0c             	pushl  0xc(%ebp)
  8000d6:	ff 75 08             	pushl  0x8(%ebp)
  8000d9:	e8 5a ff ff ff       	call   800038 <_main>
  8000de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	0f 84 01 01 00 00    	je     8001ef <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000ee:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000f4:	bb 48 1d 80 00       	mov    $0x801d48,%ebx
  8000f9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800106:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800109:	b9 56 00 00 00       	mov    $0x56,%ecx
  80010e:	b0 00                	mov    $0x0,%al
  800110:	89 d7                	mov    %edx,%edi
  800112:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800114:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80011b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	50                   	push   %eax
  800122:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800128:	50                   	push   %eax
  800129:	e8 c4 17 00 00       	call   8018f2 <sys_utilities>
  80012e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800131:	e8 0d 13 00 00       	call   801443 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 68 1c 80 00       	push   $0x801c68
  80013e:	e8 ac 03 00 00       	call   8004ef <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 18                	je     800165 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80014d:	e8 be 17 00 00       	call   801910 <sys_get_optimal_num_faults>
  800152:	83 ec 08             	sub    $0x8,%esp
  800155:	50                   	push   %eax
  800156:	68 90 1c 80 00       	push   $0x801c90
  80015b:	e8 8f 03 00 00       	call   8004ef <cprintf>
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb 59                	jmp    8001be <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800165:	a1 20 30 80 00       	mov    0x803020,%eax
  80016a:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	52                   	push   %edx
  80017f:	50                   	push   %eax
  800180:	68 b4 1c 80 00       	push   $0x801cb4
  800185:	e8 65 03 00 00       	call   8004ef <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a8:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001ae:	51                   	push   %ecx
  8001af:	52                   	push   %edx
  8001b0:	50                   	push   %eax
  8001b1:	68 dc 1c 80 00       	push   $0x801cdc
  8001b6:	e8 34 03 00 00       	call   8004ef <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	50                   	push   %eax
  8001cd:	68 34 1d 80 00       	push   $0x801d34
  8001d2:	e8 18 03 00 00       	call   8004ef <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 68 1c 80 00       	push   $0x801c68
  8001e2:	e8 08 03 00 00       	call   8004ef <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001ea:	e8 6e 12 00 00       	call   80145d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001ef:	e8 1f 00 00 00       	call   800213 <exit>
}
  8001f4:	90                   	nop
  8001f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f8:	5b                   	pop    %ebx
  8001f9:	5e                   	pop    %esi
  8001fa:	5f                   	pop    %edi
  8001fb:	5d                   	pop    %ebp
  8001fc:	c3                   	ret    

008001fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	6a 00                	push   $0x0
  800208:	e8 7b 14 00 00       	call   801688 <sys_destroy_env>
  80020d:	83 c4 10             	add    $0x10,%esp
}
  800210:	90                   	nop
  800211:	c9                   	leave  
  800212:	c3                   	ret    

00800213 <exit>:

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800219:	e8 d0 14 00 00       	call   8016ee <sys_exit_env>
}
  80021e:	90                   	nop
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800227:	8d 45 10             	lea    0x10(%ebp),%eax
  80022a:	83 c0 04             	add    $0x4,%eax
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800230:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800235:	85 c0                	test   %eax,%eax
  800237:	74 16                	je     80024f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800239:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 ac 1d 80 00       	push   $0x801dac
  800247:	e8 a3 02 00 00       	call   8004ef <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80024f:	a1 04 30 80 00       	mov    0x803004,%eax
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 75 0c             	pushl  0xc(%ebp)
  80025a:	ff 75 08             	pushl  0x8(%ebp)
  80025d:	50                   	push   %eax
  80025e:	68 b4 1d 80 00       	push   $0x801db4
  800263:	6a 74                	push   $0x74
  800265:	e8 b2 02 00 00       	call   80051c <cprintf_colored>
  80026a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	ff 75 f4             	pushl  -0xc(%ebp)
  800276:	50                   	push   %eax
  800277:	e8 04 02 00 00       	call   800480 <vcprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	6a 00                	push   $0x0
  800284:	68 dc 1d 80 00       	push   $0x801ddc
  800289:	e8 f2 01 00 00       	call   800480 <vcprintf>
  80028e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800291:	e8 7d ff ff ff       	call   800213 <exit>

	// should not return here
	while (1) ;
  800296:	eb fe                	jmp    800296 <_panic+0x75>

00800298 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80029e:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ac:	39 c2                	cmp    %eax,%edx
  8002ae:	74 14                	je     8002c4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	68 e0 1d 80 00       	push   $0x801de0
  8002b8:	6a 26                	push   $0x26
  8002ba:	68 2c 1e 80 00       	push   $0x801e2c
  8002bf:	e8 5d ff ff ff       	call   800221 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002d2:	e9 c5 00 00 00       	jmp    80039c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	75 08                	jne    8002f4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002ef:	e9 a5 00 00 00       	jmp    800399 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800302:	eb 69                	jmp    80036d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800304:	a1 20 30 80 00       	mov    0x803020,%eax
  800309:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80030f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800312:	89 d0                	mov    %edx,%eax
  800314:	01 c0                	add    %eax,%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	c1 e0 03             	shl    $0x3,%eax
  80031b:	01 c8                	add    %ecx,%eax
  80031d:	8a 40 04             	mov    0x4(%eax),%al
  800320:	84 c0                	test   %al,%al
  800322:	75 46                	jne    80036a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800324:	a1 20 30 80 00       	mov    0x803020,%eax
  800329:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80032f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800332:	89 d0                	mov    %edx,%eax
  800334:	01 c0                	add    %eax,%eax
  800336:	01 d0                	add    %edx,%eax
  800338:	c1 e0 03             	shl    $0x3,%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800342:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800345:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80034a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	01 c8                	add    %ecx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	75 09                	jne    80036a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800361:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800368:	eb 15                	jmp    80037f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036a:	ff 45 e8             	incl   -0x18(%ebp)
  80036d:	a1 20 30 80 00       	mov    0x803020,%eax
  800372:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037b:	39 c2                	cmp    %eax,%edx
  80037d:	77 85                	ja     800304 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80037f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800383:	75 14                	jne    800399 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	68 38 1e 80 00       	push   $0x801e38
  80038d:	6a 3a                	push   $0x3a
  80038f:	68 2c 1e 80 00       	push   $0x801e2c
  800394:	e8 88 fe ff ff       	call   800221 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800399:	ff 45 f0             	incl   -0x10(%ebp)
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a2:	0f 8c 2f ff ff ff    	jl     8002d7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003b6:	eb 26                	jmp    8003de <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bd:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8a 40 04             	mov    0x4(%eax),%al
  8003d4:	3c 01                	cmp    $0x1,%al
  8003d6:	75 03                	jne    8003db <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003db:	ff 45 e0             	incl   -0x20(%ebp)
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ec:	39 c2                	cmp    %eax,%edx
  8003ee:	77 c8                	ja     8003b8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003f6:	74 14                	je     80040c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	68 8c 1e 80 00       	push   $0x801e8c
  800400:	6a 44                	push   $0x44
  800402:	68 2c 1e 80 00       	push   $0x801e2c
  800407:	e8 15 fe ff ff       	call   800221 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80040c:	90                   	nop
  80040d:	c9                   	leave  
  80040e:	c3                   	ret    

0080040f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	53                   	push   %ebx
  800413:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	8d 48 01             	lea    0x1(%eax),%ecx
  80041e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800421:	89 0a                	mov    %ecx,(%edx)
  800423:	8b 55 08             	mov    0x8(%ebp),%edx
  800426:	88 d1                	mov    %dl,%cl
  800428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	3d ff 00 00 00       	cmp    $0xff,%eax
  800439:	75 30                	jne    80046b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80043b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800441:	a0 44 30 80 00       	mov    0x803044,%al
  800446:	0f b6 c0             	movzbl %al,%eax
  800449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044c:	8b 09                	mov    (%ecx),%ecx
  80044e:	89 cb                	mov    %ecx,%ebx
  800450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800453:	83 c1 08             	add    $0x8,%ecx
  800456:	52                   	push   %edx
  800457:	50                   	push   %eax
  800458:	53                   	push   %ebx
  800459:	51                   	push   %ecx
  80045a:	e8 a0 0f 00 00       	call   8013ff <sys_cputs>
  80045f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	8b 40 04             	mov    0x4(%eax),%eax
  800471:	8d 50 01             	lea    0x1(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	89 50 04             	mov    %edx,0x4(%eax)
}
  80047a:	90                   	nop
  80047b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800489:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800490:	00 00 00 
	b.cnt = 0;
  800493:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80049d:	ff 75 0c             	pushl  0xc(%ebp)
  8004a0:	ff 75 08             	pushl  0x8(%ebp)
  8004a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a9:	50                   	push   %eax
  8004aa:	68 0f 04 80 00       	push   $0x80040f
  8004af:	e8 5a 02 00 00       	call   80070e <vprintfmt>
  8004b4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004b7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004bd:	a0 44 30 80 00       	mov    0x803044,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004cb:	52                   	push   %edx
  8004cc:	50                   	push   %eax
  8004cd:	51                   	push   %ecx
  8004ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d4:	83 c0 08             	add    $0x8,%eax
  8004d7:	50                   	push   %eax
  8004d8:	e8 22 0f 00 00       	call   8013ff <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004e0:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 6f ff ff ff       	call   800480 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

0080051c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800522:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	c1 e0 08             	shl    $0x8,%eax
  80052f:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800534:	8d 45 0c             	lea    0xc(%ebp),%eax
  800537:	83 c0 04             	add    $0x4,%eax
  80053a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	ff 75 f4             	pushl  -0xc(%ebp)
  800546:	50                   	push   %eax
  800547:	e8 34 ff ff ff       	call   800480 <vcprintf>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800552:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800559:	07 00 00 

	return cnt;
  80055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800567:	e8 d7 0e 00 00       	call   801443 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80056c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 f4             	pushl  -0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	e8 ff fe ff ff       	call   800480 <vcprintf>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800587:	e8 d1 0e 00 00       	call   80145d <sys_unlock_cons>
	return cnt;
  80058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058f:	c9                   	leave  
  800590:	c3                   	ret    

00800591 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
  800594:	53                   	push   %ebx
  800595:	83 ec 14             	sub    $0x14,%esp
  800598:	8b 45 10             	mov    0x10(%ebp),%eax
  80059b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005af:	77 55                	ja     800606 <printnum+0x75>
  8005b1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b4:	72 05                	jb     8005bb <printnum+0x2a>
  8005b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b9:	77 4b                	ja     800606 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005be:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	52                   	push   %edx
  8005ca:	50                   	push   %eax
  8005cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d1:	e8 aa 13 00 00       	call   801980 <__udivdi3>
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	ff 75 20             	pushl  0x20(%ebp)
  8005df:	53                   	push   %ebx
  8005e0:	ff 75 18             	pushl  0x18(%ebp)
  8005e3:	52                   	push   %edx
  8005e4:	50                   	push   %eax
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	e8 a1 ff ff ff       	call   800591 <printnum>
  8005f0:	83 c4 20             	add    $0x20,%esp
  8005f3:	eb 1a                	jmp    80060f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 0c             	pushl  0xc(%ebp)
  8005fb:	ff 75 20             	pushl  0x20(%ebp)
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	ff d0                	call   *%eax
  800603:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800606:	ff 4d 1c             	decl   0x1c(%ebp)
  800609:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060d:	7f e6                	jg     8005f5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800612:	bb 00 00 00 00       	mov    $0x0,%ebx
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061d:	53                   	push   %ebx
  80061e:	51                   	push   %ecx
  80061f:	52                   	push   %edx
  800620:	50                   	push   %eax
  800621:	e8 6a 14 00 00       	call   801a90 <__umoddi3>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	05 f4 20 80 00       	add    $0x8020f4,%eax
  80062e:	8a 00                	mov    (%eax),%al
  800630:	0f be c0             	movsbl %al,%eax
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	50                   	push   %eax
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	ff d0                	call   *%eax
  80063f:	83 c4 10             	add    $0x10,%esp
}
  800642:	90                   	nop
  800643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800646:	c9                   	leave  
  800647:	c3                   	ret    

00800648 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064f:	7e 1c                	jle    80066d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	8d 50 08             	lea    0x8(%eax),%edx
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	89 10                	mov    %edx,(%eax)
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	83 e8 08             	sub    $0x8,%eax
  800666:	8b 50 04             	mov    0x4(%eax),%edx
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	eb 40                	jmp    8006ad <getuint+0x65>
	else if (lflag)
  80066d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800671:	74 1e                	je     800691 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	8d 50 04             	lea    0x4(%eax),%edx
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	89 10                	mov    %edx,(%eax)
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	83 e8 04             	sub    $0x4,%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	ba 00 00 00 00       	mov    $0x0,%edx
  80068f:	eb 1c                	jmp    8006ad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	8d 50 04             	lea    0x4(%eax),%edx
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	89 10                	mov    %edx,(%eax)
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	83 e8 04             	sub    $0x4,%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ad:	5d                   	pop    %ebp
  8006ae:	c3                   	ret    

008006af <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b6:	7e 1c                	jle    8006d4 <getint+0x25>
		return va_arg(*ap, long long);
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	8d 50 08             	lea    0x8(%eax),%edx
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	89 10                	mov    %edx,(%eax)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	83 e8 08             	sub    $0x8,%eax
  8006cd:	8b 50 04             	mov    0x4(%eax),%edx
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	eb 38                	jmp    80070c <getint+0x5d>
	else if (lflag)
  8006d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d8:	74 1a                	je     8006f4 <getint+0x45>
		return va_arg(*ap, long);
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	89 10                	mov    %edx,(%eax)
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	83 e8 04             	sub    $0x4,%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	99                   	cltd   
  8006f2:	eb 18                	jmp    80070c <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	8d 50 04             	lea    0x4(%eax),%edx
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	89 10                	mov    %edx,(%eax)
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	83 e8 04             	sub    $0x4,%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	99                   	cltd   
}
  80070c:	5d                   	pop    %ebp
  80070d:	c3                   	ret    

0080070e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	56                   	push   %esi
  800712:	53                   	push   %ebx
  800713:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800716:	eb 17                	jmp    80072f <vprintfmt+0x21>
			if (ch == '\0')
  800718:	85 db                	test   %ebx,%ebx
  80071a:	0f 84 c1 03 00 00    	je     800ae1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	53                   	push   %ebx
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072f:	8b 45 10             	mov    0x10(%ebp),%eax
  800732:	8d 50 01             	lea    0x1(%eax),%edx
  800735:	89 55 10             	mov    %edx,0x10(%ebp)
  800738:	8a 00                	mov    (%eax),%al
  80073a:	0f b6 d8             	movzbl %al,%ebx
  80073d:	83 fb 25             	cmp    $0x25,%ebx
  800740:	75 d6                	jne    800718 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800742:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800746:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800754:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800762:	8b 45 10             	mov    0x10(%ebp),%eax
  800765:	8d 50 01             	lea    0x1(%eax),%edx
  800768:	89 55 10             	mov    %edx,0x10(%ebp)
  80076b:	8a 00                	mov    (%eax),%al
  80076d:	0f b6 d8             	movzbl %al,%ebx
  800770:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800773:	83 f8 5b             	cmp    $0x5b,%eax
  800776:	0f 87 3d 03 00 00    	ja     800ab9 <vprintfmt+0x3ab>
  80077c:	8b 04 85 18 21 80 00 	mov    0x802118(,%eax,4),%eax
  800783:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800785:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800789:	eb d7                	jmp    800762 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078f:	eb d1                	jmp    800762 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800791:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800798:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079b:	89 d0                	mov    %edx,%eax
  80079d:	c1 e0 02             	shl    $0x2,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	01 c0                	add    %eax,%eax
  8007a4:	01 d8                	add    %ebx,%eax
  8007a6:	83 e8 30             	sub    $0x30,%eax
  8007a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8007af:	8a 00                	mov    (%eax),%al
  8007b1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b7:	7e 3e                	jle    8007f7 <vprintfmt+0xe9>
  8007b9:	83 fb 39             	cmp    $0x39,%ebx
  8007bc:	7f 39                	jg     8007f7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007be:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c1:	eb d5                	jmp    800798 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 c0 04             	add    $0x4,%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	83 e8 04             	sub    $0x4,%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d7:	eb 1f                	jmp    8007f8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dd:	79 83                	jns    800762 <vprintfmt+0x54>
				width = 0;
  8007df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e6:	e9 77 ff ff ff       	jmp    800762 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f2:	e9 6b ff ff ff       	jmp    800762 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	0f 89 60 ff ff ff    	jns    800762 <vprintfmt+0x54>
				width = precision, precision = -1;
  800802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800805:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800808:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080f:	e9 4e ff ff ff       	jmp    800762 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800814:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800817:	e9 46 ff ff ff       	jmp    800762 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	50                   	push   %eax
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			break;
  80083c:	e9 9b 02 00 00       	jmp    800adc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 c0 04             	add    $0x4,%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	83 e8 04             	sub    $0x4,%eax
  800850:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800852:	85 db                	test   %ebx,%ebx
  800854:	79 02                	jns    800858 <vprintfmt+0x14a>
				err = -err;
  800856:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800858:	83 fb 64             	cmp    $0x64,%ebx
  80085b:	7f 0b                	jg     800868 <vprintfmt+0x15a>
  80085d:	8b 34 9d 60 1f 80 00 	mov    0x801f60(,%ebx,4),%esi
  800864:	85 f6                	test   %esi,%esi
  800866:	75 19                	jne    800881 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800868:	53                   	push   %ebx
  800869:	68 05 21 80 00       	push   $0x802105
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	ff 75 08             	pushl  0x8(%ebp)
  800874:	e8 70 02 00 00       	call   800ae9 <printfmt>
  800879:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087c:	e9 5b 02 00 00       	jmp    800adc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800881:	56                   	push   %esi
  800882:	68 0e 21 80 00       	push   $0x80210e
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	ff 75 08             	pushl  0x8(%ebp)
  80088d:	e8 57 02 00 00       	call   800ae9 <printfmt>
  800892:	83 c4 10             	add    $0x10,%esp
			break;
  800895:	e9 42 02 00 00       	jmp    800adc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 c0 04             	add    $0x4,%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	83 e8 04             	sub    $0x4,%eax
  8008a9:	8b 30                	mov    (%eax),%esi
  8008ab:	85 f6                	test   %esi,%esi
  8008ad:	75 05                	jne    8008b4 <vprintfmt+0x1a6>
				p = "(null)";
  8008af:	be 11 21 80 00       	mov    $0x802111,%esi
			if (width > 0 && padc != '-')
  8008b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b8:	7e 6d                	jle    800927 <vprintfmt+0x219>
  8008ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008be:	74 67                	je     800927 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	50                   	push   %eax
  8008c7:	56                   	push   %esi
  8008c8:	e8 1e 03 00 00       	call   800beb <strnlen>
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d3:	eb 16                	jmp    8008eb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ef:	7f e4                	jg     8008d5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f1:	eb 34                	jmp    800927 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f7:	74 1c                	je     800915 <vprintfmt+0x207>
  8008f9:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fc:	7e 05                	jle    800903 <vprintfmt+0x1f5>
  8008fe:	83 fb 7e             	cmp    $0x7e,%ebx
  800901:	7e 12                	jle    800915 <vprintfmt+0x207>
					putch('?', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	6a 3f                	push   $0x3f
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	eb 0f                	jmp    800924 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	53                   	push   %ebx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800924:	ff 4d e4             	decl   -0x1c(%ebp)
  800927:	89 f0                	mov    %esi,%eax
  800929:	8d 70 01             	lea    0x1(%eax),%esi
  80092c:	8a 00                	mov    (%eax),%al
  80092e:	0f be d8             	movsbl %al,%ebx
  800931:	85 db                	test   %ebx,%ebx
  800933:	74 24                	je     800959 <vprintfmt+0x24b>
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	78 b8                	js     8008f3 <vprintfmt+0x1e5>
  80093b:	ff 4d e0             	decl   -0x20(%ebp)
  80093e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800942:	79 af                	jns    8008f3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800944:	eb 13                	jmp    800959 <vprintfmt+0x24b>
				putch(' ', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 20                	push   $0x20
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095d:	7f e7                	jg     800946 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095f:	e9 78 01 00 00       	jmp    800adc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 e8             	pushl  -0x18(%ebp)
  80096a:	8d 45 14             	lea    0x14(%ebp),%eax
  80096d:	50                   	push   %eax
  80096e:	e8 3c fd ff ff       	call   8006af <getint>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800979:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800982:	85 d2                	test   %edx,%edx
  800984:	79 23                	jns    8009a9 <vprintfmt+0x29b>
				putch('-', putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	6a 2d                	push   $0x2d
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	ff d0                	call   *%eax
  800993:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800999:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099c:	f7 d8                	neg    %eax
  80099e:	83 d2 00             	adc    $0x0,%edx
  8009a1:	f7 da                	neg    %edx
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b0:	e9 bc 00 00 00       	jmp    800a71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 84 fc ff ff       	call   800648 <getuint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d4:	e9 98 00 00 00       	jmp    800a71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 58                	push   $0x58
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 ce 00 00 00       	jmp    800adc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 30                	push   $0x30
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 78                	push   $0x78
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 e8 04             	sub    $0x4,%eax
  800a3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a50:	eb 1f                	jmp    800a71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 e7 fb ff ff       	call   800648 <getuint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a78:	83 ec 04             	sub    $0x4,%esp
  800a7b:	52                   	push   %edx
  800a7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7f:	50                   	push   %eax
  800a80:	ff 75 f4             	pushl  -0xc(%ebp)
  800a83:	ff 75 f0             	pushl  -0x10(%ebp)
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	ff 75 08             	pushl  0x8(%ebp)
  800a8c:	e8 00 fb ff ff       	call   800591 <printnum>
  800a91:	83 c4 20             	add    $0x20,%esp
			break;
  800a94:	eb 46                	jmp    800adc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			break;
  800aa5:	eb 35                	jmp    800adc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aae:	eb 2c                	jmp    800adc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ab7:	eb 23                	jmp    800adc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	6a 25                	push   $0x25
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac9:	ff 4d 10             	decl   0x10(%ebp)
  800acc:	eb 03                	jmp    800ad1 <vprintfmt+0x3c3>
  800ace:	ff 4d 10             	decl   0x10(%ebp)
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	48                   	dec    %eax
  800ad5:	8a 00                	mov    (%eax),%al
  800ad7:	3c 25                	cmp    $0x25,%al
  800ad9:	75 f3                	jne    800ace <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800adb:	90                   	nop
		}
	}
  800adc:	e9 35 fc ff ff       	jmp    800716 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aef:	8d 45 10             	lea    0x10(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af8:	8b 45 10             	mov    0x10(%ebp),%eax
  800afb:	ff 75 f4             	pushl  -0xc(%ebp)
  800afe:	50                   	push   %eax
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	ff 75 08             	pushl  0x8(%ebp)
  800b05:	e8 04 fc ff ff       	call   80070e <vprintfmt>
  800b0a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0d:	90                   	nop
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8b 40 08             	mov    0x8(%eax),%eax
  800b19:	8d 50 01             	lea    0x1(%eax),%edx
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 10                	mov    (%eax),%edx
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	8b 40 04             	mov    0x4(%eax),%eax
  800b2d:	39 c2                	cmp    %eax,%edx
  800b2f:	73 12                	jae    800b43 <sprintputch+0x33>
		*b->buf++ = ch;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	8d 48 01             	lea    0x1(%eax),%ecx
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	89 0a                	mov    %ecx,(%edx)
  800b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b41:	88 10                	mov    %dl,(%eax)
}
  800b43:	90                   	nop
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	01 d0                	add    %edx,%eax
  800b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6b:	74 06                	je     800b73 <vsnprintf+0x2d>
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	7f 07                	jg     800b7a <vsnprintf+0x34>
		return -E_INVAL;
  800b73:	b8 03 00 00 00       	mov    $0x3,%eax
  800b78:	eb 20                	jmp    800b9a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7a:	ff 75 14             	pushl  0x14(%ebp)
  800b7d:	ff 75 10             	pushl  0x10(%ebp)
  800b80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b83:	50                   	push   %eax
  800b84:	68 10 0b 80 00       	push   $0x800b10
  800b89:	e8 80 fb ff ff       	call   80070e <vprintfmt>
  800b8e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 89 ff ff ff       	call   800b46 <vsnprintf>
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd5:	eb 06                	jmp    800bdd <strlen+0x15>
		n++;
  800bd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bda:	ff 45 08             	incl   0x8(%ebp)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 f1                	jne    800bd7 <strlen+0xf>
		n++;
	return n;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf8:	eb 09                	jmp    800c03 <strnlen+0x18>
		n++;
  800bfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfd:	ff 45 08             	incl   0x8(%ebp)
  800c00:	ff 4d 0c             	decl   0xc(%ebp)
  800c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c07:	74 09                	je     800c12 <strnlen+0x27>
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	84 c0                	test   %al,%al
  800c10:	75 e8                	jne    800bfa <strnlen+0xf>
		n++;
	return n;
  800c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c23:	90                   	nop
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8d 50 01             	lea    0x1(%eax),%edx
  800c2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c36:	8a 12                	mov    (%edx),%dl
  800c38:	88 10                	mov    %dl,(%eax)
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	84 c0                	test   %al,%al
  800c3e:	75 e4                	jne    800c24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 1f                	jmp    800c79 <strncpy+0x34>
		*dst++ = *src;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8d 50 01             	lea    0x1(%eax),%edx
  800c60:	89 55 08             	mov    %edx,0x8(%ebp)
  800c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c66:	8a 12                	mov    (%edx),%dl
  800c68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	84 c0                	test   %al,%al
  800c71:	74 03                	je     800c76 <strncpy+0x31>
			src++;
  800c73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c76:	ff 45 fc             	incl   -0x4(%ebp)
  800c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7f:	72 d9                	jb     800c5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 30                	je     800cc8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c98:	eb 16                	jmp    800cb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ca0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cac:	8a 12                	mov    (%edx),%dl
  800cae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb0:	ff 4d 10             	decl   0x10(%ebp)
  800cb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb7:	74 09                	je     800cc2 <strlcpy+0x3c>
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 d8                	jne    800c9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cce:	29 c2                	sub    %eax,%edx
  800cd0:	89 d0                	mov    %edx,%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd7:	eb 06                	jmp    800cdf <strcmp+0xb>
		p++, q++;
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	74 0e                	je     800cf6 <strcmp+0x22>
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 e3                	je     800cd9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
}
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0f:	eb 09                	jmp    800d1a <strncmp+0xe>
		n--, p++, q++;
  800d11:	ff 4d 10             	decl   0x10(%ebp)
  800d14:	ff 45 08             	incl   0x8(%ebp)
  800d17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1e:	74 17                	je     800d37 <strncmp+0x2b>
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	84 c0                	test   %al,%al
  800d27:	74 0e                	je     800d37 <strncmp+0x2b>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 10                	mov    (%eax),%dl
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	38 c2                	cmp    %al,%dl
  800d35:	74 da                	je     800d11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3b:	75 07                	jne    800d44 <strncmp+0x38>
		return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d42:	eb 14                	jmp    800d58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	0f b6 d0             	movzbl %al,%edx
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	0f b6 c0             	movzbl %al,%eax
  800d54:	29 c2                	sub    %eax,%edx
  800d56:	89 d0                	mov    %edx,%eax
}
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 04             	sub    $0x4,%esp
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d66:	eb 12                	jmp    800d7a <strchr+0x20>
		if (*s == c)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d70:	75 05                	jne    800d77 <strchr+0x1d>
			return (char *) s;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	eb 11                	jmp    800d88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d77:	ff 45 08             	incl   0x8(%ebp)
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	84 c0                	test   %al,%al
  800d81:	75 e5                	jne    800d68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d96:	eb 0d                	jmp    800da5 <strfind+0x1b>
		if (*s == c)
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da0:	74 0e                	je     800db0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 ea                	jne    800d98 <strfind+0xe>
  800dae:	eb 01                	jmp    800db1 <strfind+0x27>
		if (*s == c)
			break;
  800db0:	90                   	nop
	return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dc2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dc6:	76 63                	jbe    800e2b <memset+0x75>
		uint64 data_block = c;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	99                   	cltd   
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ddc:	c1 e0 08             	shl    $0x8,%eax
  800ddf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800de2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800def:	c1 e0 10             	shl    $0x10,%eax
  800df2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfe:	89 c2                	mov    %eax,%edx
  800e00:	b8 00 00 00 00       	mov    $0x0,%eax
  800e05:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e08:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e0b:	eb 18                	jmp    800e25 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e0d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e10:	8d 41 08             	lea    0x8(%ecx),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1c:	89 01                	mov    %eax,(%ecx)
  800e1e:	89 51 04             	mov    %edx,0x4(%ecx)
  800e21:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e25:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e29:	77 e2                	ja     800e0d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2f:	74 23                	je     800e54 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e37:	eb 0e                	jmp    800e47 <memset+0x91>
			*p8++ = (uint8)c;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	75 e5                	jne    800e39 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e6b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6f:	76 24                	jbe    800e95 <memcpy+0x3c>
		while(n >= 8){
  800e71:	eb 1c                	jmp    800e8f <memcpy+0x36>
			*d64 = *s64;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	8b 50 04             	mov    0x4(%eax),%edx
  800e79:	8b 00                	mov    (%eax),%eax
  800e7b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e7e:	89 01                	mov    %eax,(%ecx)
  800e80:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e83:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e87:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e8b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e8f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e93:	77 de                	ja     800e73 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e99:	74 31                	je     800ecc <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ea7:	eb 16                	jmp    800ebf <memcpy+0x66>
			*d8++ = *s8++;
  800ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eac:	8d 50 01             	lea    0x1(%eax),%edx
  800eaf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ebb:	8a 12                	mov    (%edx),%dl
  800ebd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	75 dd                	jne    800ea9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee9:	73 50                	jae    800f3b <memmove+0x6a>
  800eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef1:	01 d0                	add    %edx,%eax
  800ef3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef6:	76 43                	jbe    800f3b <memmove+0x6a>
		s += n;
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f04:	eb 10                	jmp    800f16 <memmove+0x45>
			*--d = *--s;
  800f06:	ff 4d f8             	decl   -0x8(%ebp)
  800f09:	ff 4d fc             	decl   -0x4(%ebp)
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	8a 10                	mov    (%eax),%dl
  800f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f14:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f16:	8b 45 10             	mov    0x10(%ebp),%eax
  800f19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	75 e3                	jne    800f06 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f23:	eb 23                	jmp    800f48 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f28:	8d 50 01             	lea    0x1(%eax),%edx
  800f2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f37:	8a 12                	mov    (%edx),%dl
  800f39:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f41:	89 55 10             	mov    %edx,0x10(%ebp)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	75 dd                	jne    800f25 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f5f:	eb 2a                	jmp    800f8b <memcmp+0x3e>
		if (*s1 != *s2)
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f64:	8a 10                	mov    (%eax),%dl
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	38 c2                	cmp    %al,%dl
  800f6d:	74 16                	je     800f85 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	0f b6 d0             	movzbl %al,%edx
  800f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f b6 c0             	movzbl %al,%eax
  800f7f:	29 c2                	sub    %eax,%edx
  800f81:	89 d0                	mov    %edx,%eax
  800f83:	eb 18                	jmp    800f9d <memcmp+0x50>
		s1++, s2++;
  800f85:	ff 45 fc             	incl   -0x4(%ebp)
  800f88:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f91:	89 55 10             	mov    %edx,0x10(%ebp)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	75 c9                	jne    800f61 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fab:	01 d0                	add    %edx,%eax
  800fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fb0:	eb 15                	jmp    800fc7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f b6 d0             	movzbl %al,%edx
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	0f b6 c0             	movzbl %al,%eax
  800fc0:	39 c2                	cmp    %eax,%edx
  800fc2:	74 0d                	je     800fd1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fc4:	ff 45 08             	incl   0x8(%ebp)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fcd:	72 e3                	jb     800fb2 <memfind+0x13>
  800fcf:	eb 01                	jmp    800fd2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fd1:	90                   	nop
	return (void *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fe4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800feb:	eb 03                	jmp    800ff0 <strtol+0x19>
		s++;
  800fed:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 20                	cmp    $0x20,%al
  800ff7:	74 f4                	je     800fed <strtol+0x16>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 09                	cmp    $0x9,%al
  801000:	74 eb                	je     800fed <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 2b                	cmp    $0x2b,%al
  801009:	75 05                	jne    801010 <strtol+0x39>
		s++;
  80100b:	ff 45 08             	incl   0x8(%ebp)
  80100e:	eb 13                	jmp    801023 <strtol+0x4c>
	else if (*s == '-')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 2d                	cmp    $0x2d,%al
  801017:	75 0a                	jne    801023 <strtol+0x4c>
		s++, neg = 1;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	74 06                	je     80102f <strtol+0x58>
  801029:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102d:	75 20                	jne    80104f <strtol+0x78>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 30                	cmp    $0x30,%al
  801036:	75 17                	jne    80104f <strtol+0x78>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	40                   	inc    %eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 78                	cmp    $0x78,%al
  801040:	75 0d                	jne    80104f <strtol+0x78>
		s += 2, base = 16;
  801042:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801046:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80104d:	eb 28                	jmp    801077 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 15                	jne    80106a <strtol+0x93>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 30                	cmp    $0x30,%al
  80105c:	75 0c                	jne    80106a <strtol+0x93>
		s++, base = 8;
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801068:	eb 0d                	jmp    801077 <strtol+0xa0>
	else if (base == 0)
  80106a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106e:	75 07                	jne    801077 <strtol+0xa0>
		base = 10;
  801070:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	3c 2f                	cmp    $0x2f,%al
  80107e:	7e 19                	jle    801099 <strtol+0xc2>
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	3c 39                	cmp    $0x39,%al
  801087:	7f 10                	jg     801099 <strtol+0xc2>
			dig = *s - '0';
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	0f be c0             	movsbl %al,%eax
  801091:	83 e8 30             	sub    $0x30,%eax
  801094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801097:	eb 42                	jmp    8010db <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	3c 60                	cmp    $0x60,%al
  8010a0:	7e 19                	jle    8010bb <strtol+0xe4>
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 7a                	cmp    $0x7a,%al
  8010a9:	7f 10                	jg     8010bb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	0f be c0             	movsbl %al,%eax
  8010b3:	83 e8 57             	sub    $0x57,%eax
  8010b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b9:	eb 20                	jmp    8010db <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 40                	cmp    $0x40,%al
  8010c2:	7e 39                	jle    8010fd <strtol+0x126>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 5a                	cmp    $0x5a,%al
  8010cb:	7f 30                	jg     8010fd <strtol+0x126>
			dig = *s - 'A' + 10;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	0f be c0             	movsbl %al,%eax
  8010d5:	83 e8 37             	sub    $0x37,%eax
  8010d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010de:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e1:	7d 19                	jge    8010fc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f2:	01 d0                	add    %edx,%eax
  8010f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f7:	e9 7b ff ff ff       	jmp    801077 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010fc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801101:	74 08                	je     80110b <strtol+0x134>
		*endptr = (char *) s;
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 07                	je     801118 <strtol+0x141>
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	f7 d8                	neg    %eax
  801116:	eb 03                	jmp    80111b <strtol+0x144>
  801118:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <ltostr>:

void
ltostr(long value, char *str)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80112a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801135:	79 13                	jns    80114a <ltostr+0x2d>
	{
		neg = 1;
  801137:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801144:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801147:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801152:	99                   	cltd   
  801153:	f7 f9                	idiv   %ecx
  801155:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	8d 50 01             	lea    0x1(%eax),%edx
  80115e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801161:	89 c2                	mov    %eax,%edx
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80116b:	83 c2 30             	add    $0x30,%edx
  80116e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801173:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801178:	f7 e9                	imul   %ecx
  80117a:	c1 fa 02             	sar    $0x2,%edx
  80117d:	89 c8                	mov    %ecx,%eax
  80117f:	c1 f8 1f             	sar    $0x1f,%eax
  801182:	29 c2                	sub    %eax,%edx
  801184:	89 d0                	mov    %edx,%eax
  801186:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118d:	75 bb                	jne    80114a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801199:	48                   	dec    %eax
  80119a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80119d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a1:	74 3d                	je     8011e0 <ltostr+0xc3>
		start = 1 ;
  8011a3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011aa:	eb 34                	jmp    8011e0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	01 c2                	add    %eax,%edx
  8011c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	01 c8                	add    %ecx,%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d8:	88 02                	mov    %al,(%edx)
		start++ ;
  8011da:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011dd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e6:	7c c4                	jl     8011ac <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	01 d0                	add    %edx,%eax
  8011f0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f3:	90                   	nop
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011fc:	ff 75 08             	pushl  0x8(%ebp)
  8011ff:	e8 c4 f9 ff ff       	call   800bc8 <strlen>
  801204:	83 c4 04             	add    $0x4,%esp
  801207:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120a:	ff 75 0c             	pushl  0xc(%ebp)
  80120d:	e8 b6 f9 ff ff       	call   800bc8 <strlen>
  801212:	83 c4 04             	add    $0x4,%esp
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801226:	eb 17                	jmp    80123f <strcconcat+0x49>
		final[s] = str1[s] ;
  801228:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	01 c2                	add    %eax,%edx
  801230:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	01 c8                	add    %ecx,%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80123c:	ff 45 fc             	incl   -0x4(%ebp)
  80123f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801242:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801245:	7c e1                	jl     801228 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801247:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80124e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801255:	eb 1f                	jmp    801276 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801257:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125a:	8d 50 01             	lea    0x1(%eax),%edx
  80125d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801260:	89 c2                	mov    %eax,%edx
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	01 c2                	add    %eax,%edx
  801267:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126d:	01 c8                	add    %ecx,%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801273:	ff 45 f8             	incl   -0x8(%ebp)
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127c:	7c d9                	jl     801257 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	c6 00 00             	movb   $0x0,(%eax)
}
  801289:	90                   	nop
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128f:	8b 45 14             	mov    0x14(%ebp),%eax
  801292:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801298:	8b 45 14             	mov    0x14(%ebp),%eax
  80129b:	8b 00                	mov    (%eax),%eax
  80129d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	01 d0                	add    %edx,%eax
  8012a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012af:	eb 0c                	jmp    8012bd <strsplit+0x31>
			*string++ = 0;
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8d 50 01             	lea    0x1(%eax),%edx
  8012b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	84 c0                	test   %al,%al
  8012c4:	74 18                	je     8012de <strsplit+0x52>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	0f be c0             	movsbl %al,%eax
  8012ce:	50                   	push   %eax
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	e8 83 fa ff ff       	call   800d5a <strchr>
  8012d7:	83 c4 08             	add    $0x8,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	75 d3                	jne    8012b1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	84 c0                	test   %al,%al
  8012e5:	74 5a                	je     801341 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ea:	8b 00                	mov    (%eax),%eax
  8012ec:	83 f8 0f             	cmp    $0xf,%eax
  8012ef:	75 07                	jne    8012f8 <strsplit+0x6c>
		{
			return 0;
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f6:	eb 66                	jmp    80135e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fb:	8b 00                	mov    (%eax),%eax
  8012fd:	8d 48 01             	lea    0x1(%eax),%ecx
  801300:	8b 55 14             	mov    0x14(%ebp),%edx
  801303:	89 0a                	mov    %ecx,(%edx)
  801305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	01 c2                	add    %eax,%edx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801316:	eb 03                	jmp    80131b <strsplit+0x8f>
			string++;
  801318:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	84 c0                	test   %al,%al
  801322:	74 8b                	je     8012af <strsplit+0x23>
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f be c0             	movsbl %al,%eax
  80132c:	50                   	push   %eax
  80132d:	ff 75 0c             	pushl  0xc(%ebp)
  801330:	e8 25 fa ff ff       	call   800d5a <strchr>
  801335:	83 c4 08             	add    $0x8,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	74 dc                	je     801318 <strsplit+0x8c>
			string++;
	}
  80133c:	e9 6e ff ff ff       	jmp    8012af <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801341:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134e:	8b 45 10             	mov    0x10(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801359:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80136c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801373:	eb 4a                	jmp    8013bf <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801375:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	01 c2                	add    %eax,%edx
  80137d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 c8                	add    %ecx,%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801389:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	3c 40                	cmp    $0x40,%al
  801395:	7e 25                	jle    8013bc <str2lower+0x5c>
  801397:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 5a                	cmp    $0x5a,%al
  8013a3:	7f 17                	jg     8013bc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b3:	01 ca                	add    %ecx,%edx
  8013b5:	8a 12                	mov    (%edx),%dl
  8013b7:	83 c2 20             	add    $0x20,%edx
  8013ba:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013bc:	ff 45 fc             	incl   -0x4(%ebp)
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	e8 01 f8 ff ff       	call   800bc8 <strlen>
  8013c7:	83 c4 04             	add    $0x4,%esp
  8013ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013cd:	7f a6                	jg     801375 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	57                   	push   %edi
  8013d8:	56                   	push   %esi
  8013d9:	53                   	push   %ebx
  8013da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013ef:	cd 30                	int    $0x30
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80140b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	6a 00                	push   $0x0
  801417:	51                   	push   %ecx
  801418:	52                   	push   %edx
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	50                   	push   %eax
  80141d:	6a 00                	push   $0x0
  80141f:	e8 b0 ff ff ff       	call   8013d4 <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	90                   	nop
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_cgetc>:

int
sys_cgetc(void)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 02                	push   $0x2
  801439:	e8 96 ff ff ff       	call   8013d4 <syscall>
  80143e:	83 c4 18             	add    $0x18,%esp
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 03                	push   $0x3
  801452:	e8 7d ff ff ff       	call   8013d4 <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 04                	push   $0x4
  80146c:	e8 63 ff ff ff       	call   8013d4 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	90                   	nop
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80147a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	52                   	push   %edx
  801487:	50                   	push   %eax
  801488:	6a 08                	push   $0x8
  80148a:	e8 45 ff ff ff       	call   8013d4 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	56                   	push   %esi
  801498:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801499:	8b 75 18             	mov    0x18(%ebp),%esi
  80149c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
  8014aa:	51                   	push   %ecx
  8014ab:	52                   	push   %edx
  8014ac:	50                   	push   %eax
  8014ad:	6a 09                	push   $0x9
  8014af:	e8 20 ff ff ff       	call   8013d4 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ba:	5b                   	pop    %ebx
  8014bb:	5e                   	pop    %esi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	ff 75 08             	pushl  0x8(%ebp)
  8014cc:	6a 0a                	push   $0xa
  8014ce:	e8 01 ff ff ff       	call   8013d4 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	ff 75 08             	pushl  0x8(%ebp)
  8014e7:	6a 0b                	push   $0xb
  8014e9:	e8 e6 fe ff ff       	call   8013d4 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 0c                	push   $0xc
  801502:	e8 cd fe ff ff       	call   8013d4 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 0d                	push   $0xd
  80151b:	e8 b4 fe ff ff       	call   8013d4 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 0e                	push   $0xe
  801534:	e8 9b fe ff ff       	call   8013d4 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 0f                	push   $0xf
  80154d:	e8 82 fe ff ff       	call   8013d4 <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	ff 75 08             	pushl  0x8(%ebp)
  801565:	6a 10                	push   $0x10
  801567:	e8 68 fe ff ff       	call   8013d4 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 11                	push   $0x11
  801580:	e8 4f fe ff ff       	call   8013d4 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	90                   	nop
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_cputc>:

void
sys_cputc(const char c)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801597:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	50                   	push   %eax
  8015a4:	6a 01                	push   $0x1
  8015a6:	e8 29 fe ff ff       	call   8013d4 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	90                   	nop
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 14                	push   $0x14
  8015c0:	e8 0f fe ff ff       	call   8013d4 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	90                   	nop
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	51                   	push   %ecx
  8015e4:	52                   	push   %edx
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	50                   	push   %eax
  8015e9:	6a 15                	push   $0x15
  8015eb:	e8 e4 fd ff ff       	call   8013d4 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	52                   	push   %edx
  801605:	50                   	push   %eax
  801606:	6a 16                	push   $0x16
  801608:	e8 c7 fd ff ff       	call   8013d4 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801615:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	51                   	push   %ecx
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 17                	push   $0x17
  801627:	e8 a8 fd ff ff       	call   8013d4 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	6a 18                	push   $0x18
  801644:	e8 8b fd ff ff       	call   8013d4 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	ff 75 14             	pushl  0x14(%ebp)
  801659:	ff 75 10             	pushl  0x10(%ebp)
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	6a 19                	push   $0x19
  801662:	e8 6d fd ff ff       	call   8013d4 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	50                   	push   %eax
  80167b:	6a 1a                	push   $0x1a
  80167d:	e8 52 fd ff ff       	call   8013d4 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	50                   	push   %eax
  801697:	6a 1b                	push   $0x1b
  801699:	e8 36 fd ff ff       	call   8013d4 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 05                	push   $0x5
  8016b2:	e8 1d fd ff ff       	call   8013d4 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 06                	push   $0x6
  8016cb:	e8 04 fd ff ff       	call   8013d4 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 07                	push   $0x7
  8016e4:	e8 eb fc ff ff       	call   8013d4 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_exit_env>:


void sys_exit_env(void)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 1c                	push   $0x1c
  8016fd:	e8 d2 fc ff ff       	call   8013d4 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	90                   	nop
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80170e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801711:	8d 50 04             	lea    0x4(%eax),%edx
  801714:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	52                   	push   %edx
  80171e:	50                   	push   %eax
  80171f:	6a 1d                	push   $0x1d
  801721:	e8 ae fc ff ff       	call   8013d4 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
	return result;
  801729:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801732:	89 01                	mov    %eax,(%ecx)
  801734:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	c9                   	leave  
  80173b:	c2 04 00             	ret    $0x4

0080173e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	ff 75 10             	pushl  0x10(%ebp)
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	6a 13                	push   $0x13
  801750:	e8 7f fc ff ff       	call   8013d4 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
	return ;
  801758:	90                   	nop
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_rcr2>:
uint32 sys_rcr2()
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 1e                	push   $0x1e
  80176a:	e8 65 fc ff ff       	call   8013d4 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801780:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	50                   	push   %eax
  80178d:	6a 1f                	push   $0x1f
  80178f:	e8 40 fc ff ff       	call   8013d4 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <rsttst>:
void rsttst()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 21                	push   $0x21
  8017a9:	e8 26 fc ff ff       	call   8013d4 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8017c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	ff 75 10             	pushl  0x10(%ebp)
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	6a 20                	push   $0x20
  8017d4:	e8 fb fb ff ff       	call   8013d4 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dc:	90                   	nop
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <chktst>:
void chktst(uint32 n)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	6a 22                	push   $0x22
  8017ef:	e8 e0 fb ff ff       	call   8013d4 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f7:	90                   	nop
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <inctst>:

void inctst()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 23                	push   $0x23
  801809:	e8 c6 fb ff ff       	call   8013d4 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <gettst>:
uint32 gettst()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 24                	push   $0x24
  801823:	e8 ac fb ff ff       	call   8013d4 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 25                	push   $0x25
  80183c:	e8 93 fb ff ff       	call   8013d4 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
  801844:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801849:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	6a 26                	push   $0x26
  801868:	e8 67 fb ff ff       	call   8013d4 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
	return ;
  801870:	90                   	nop
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801877:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	53                   	push   %ebx
  801886:	51                   	push   %ecx
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 27                	push   $0x27
  80188b:	e8 44 fb ff ff       	call   8013d4 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	50                   	push   %eax
  8018a9:	6a 28                	push   $0x28
  8018ab:	e8 24 fb ff ff       	call   8013d4 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	51                   	push   %ecx
  8018c4:	ff 75 10             	pushl  0x10(%ebp)
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 29                	push   $0x29
  8018cb:	e8 04 fb ff ff       	call   8013d4 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 10             	pushl  0x10(%ebp)
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	6a 12                	push   $0x12
  8018e7:	e8 e8 fa ff ff       	call   8013d4 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ef:	90                   	nop
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 2a                	push   $0x2a
  801905:	e8 ca fa ff ff       	call   8013d4 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 2b                	push   $0x2b
  80191f:	e8 b0 fa ff ff       	call   8013d4 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 2d                	push   $0x2d
  80193a:	e8 95 fa ff ff       	call   8013d4 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
	return;
  801942:	90                   	nop
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	6a 2c                	push   $0x2c
  801956:	e8 79 fa ff ff       	call   8013d4 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	68 88 22 80 00       	push   $0x802288
  80196f:	68 25 01 00 00       	push   $0x125
  801974:	68 bb 22 80 00       	push   $0x8022bb
  801979:	e8 a3 e8 ff ff       	call   800221 <_panic>
  80197e:	66 90                	xchg   %ax,%ax

00801980 <__udivdi3>:
  801980:	55                   	push   %ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80198b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80198f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801997:	89 ca                	mov    %ecx,%edx
  801999:	89 f8                	mov    %edi,%eax
  80199b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80199f:	85 f6                	test   %esi,%esi
  8019a1:	75 2d                	jne    8019d0 <__udivdi3+0x50>
  8019a3:	39 cf                	cmp    %ecx,%edi
  8019a5:	77 65                	ja     801a0c <__udivdi3+0x8c>
  8019a7:	89 fd                	mov    %edi,%ebp
  8019a9:	85 ff                	test   %edi,%edi
  8019ab:	75 0b                	jne    8019b8 <__udivdi3+0x38>
  8019ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b2:	31 d2                	xor    %edx,%edx
  8019b4:	f7 f7                	div    %edi
  8019b6:	89 c5                	mov    %eax,%ebp
  8019b8:	31 d2                	xor    %edx,%edx
  8019ba:	89 c8                	mov    %ecx,%eax
  8019bc:	f7 f5                	div    %ebp
  8019be:	89 c1                	mov    %eax,%ecx
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	f7 f5                	div    %ebp
  8019c4:	89 cf                	mov    %ecx,%edi
  8019c6:	89 fa                	mov    %edi,%edx
  8019c8:	83 c4 1c             	add    $0x1c,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	77 28                	ja     8019fc <__udivdi3+0x7c>
  8019d4:	0f bd fe             	bsr    %esi,%edi
  8019d7:	83 f7 1f             	xor    $0x1f,%edi
  8019da:	75 40                	jne    801a1c <__udivdi3+0x9c>
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	72 0a                	jb     8019ea <__udivdi3+0x6a>
  8019e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019e4:	0f 87 9e 00 00 00    	ja     801a88 <__udivdi3+0x108>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	89 fa                	mov    %edi,%edx
  8019f1:	83 c4 1c             	add    $0x1c,%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
  8019f9:	8d 76 00             	lea    0x0(%esi),%esi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	31 c0                	xor    %eax,%eax
  801a00:	89 fa                	mov    %edi,%edx
  801a02:	83 c4 1c             	add    $0x1c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f7                	div    %edi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a21:	89 eb                	mov    %ebp,%ebx
  801a23:	29 fb                	sub    %edi,%ebx
  801a25:	89 f9                	mov    %edi,%ecx
  801a27:	d3 e6                	shl    %cl,%esi
  801a29:	89 c5                	mov    %eax,%ebp
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ed                	shr    %cl,%ebp
  801a2f:	89 e9                	mov    %ebp,%ecx
  801a31:	09 f1                	or     %esi,%ecx
  801a33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 c5                	mov    %eax,%ebp
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ee                	shr    %cl,%esi
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e2                	shl    %cl,%edx
  801a47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 e8                	shr    %cl,%eax
  801a4f:	09 c2                	or     %eax,%edx
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	89 f2                	mov    %esi,%edx
  801a55:	f7 74 24 0c          	divl   0xc(%esp)
  801a59:	89 d6                	mov    %edx,%esi
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	f7 e5                	mul    %ebp
  801a5f:	39 d6                	cmp    %edx,%esi
  801a61:	72 19                	jb     801a7c <__udivdi3+0xfc>
  801a63:	74 0b                	je     801a70 <__udivdi3+0xf0>
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	31 ff                	xor    %edi,%edi
  801a69:	e9 58 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a74:	89 f9                	mov    %edi,%ecx
  801a76:	d3 e2                	shl    %cl,%edx
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	73 e9                	jae    801a65 <__udivdi3+0xe5>
  801a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 40 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	31 c0                	xor    %eax,%eax
  801a8a:	e9 37 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a8f:	90                   	nop

00801a90 <__umoddi3>:
  801a90:	55                   	push   %ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aaf:	89 f3                	mov    %esi,%ebx
  801ab1:	89 fa                	mov    %edi,%edx
  801ab3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab7:	89 34 24             	mov    %esi,(%esp)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 1a                	jne    801ad8 <__umoddi3+0x48>
  801abe:	39 f7                	cmp    %esi,%edi
  801ac0:	0f 86 a2 00 00 00    	jbe    801b68 <__umoddi3+0xd8>
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	89 f2                	mov    %esi,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d0                	mov    %edx,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 f0                	cmp    %esi,%eax
  801ada:	0f 87 ac 00 00 00    	ja     801b8c <__umoddi3+0xfc>
  801ae0:	0f bd e8             	bsr    %eax,%ebp
  801ae3:	83 f5 1f             	xor    $0x1f,%ebp
  801ae6:	0f 84 ac 00 00 00    	je     801b98 <__umoddi3+0x108>
  801aec:	bf 20 00 00 00       	mov    $0x20,%edi
  801af1:	29 ef                	sub    %ebp,%edi
  801af3:	89 fe                	mov    %edi,%esi
  801af5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e0                	shl    %cl,%eax
  801afd:	89 d7                	mov    %edx,%edi
  801aff:	89 f1                	mov    %esi,%ecx
  801b01:	d3 ef                	shr    %cl,%edi
  801b03:	09 c7                	or     %eax,%edi
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e2                	shl    %cl,%edx
  801b09:	89 14 24             	mov    %edx,(%esp)
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b16:	d3 e0                	shl    %cl,%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b20:	89 f1                	mov    %esi,%ecx
  801b22:	d3 e8                	shr    %cl,%eax
  801b24:	09 d0                	or     %edx,%eax
  801b26:	d3 eb                	shr    %cl,%ebx
  801b28:	89 da                	mov    %ebx,%edx
  801b2a:	f7 f7                	div    %edi
  801b2c:	89 d3                	mov    %edx,%ebx
  801b2e:	f7 24 24             	mull   (%esp)
  801b31:	89 c6                	mov    %eax,%esi
  801b33:	89 d1                	mov    %edx,%ecx
  801b35:	39 d3                	cmp    %edx,%ebx
  801b37:	0f 82 87 00 00 00    	jb     801bc4 <__umoddi3+0x134>
  801b3d:	0f 84 91 00 00 00    	je     801bd4 <__umoddi3+0x144>
  801b43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b47:	29 f2                	sub    %esi,%edx
  801b49:	19 cb                	sbb    %ecx,%ebx
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b51:	d3 e0                	shl    %cl,%eax
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	d3 ea                	shr    %cl,%edx
  801b57:	09 d0                	or     %edx,%eax
  801b59:	89 e9                	mov    %ebp,%ecx
  801b5b:	d3 eb                	shr    %cl,%ebx
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	83 c4 1c             	add    $0x1c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
  801b67:	90                   	nop
  801b68:	89 fd                	mov    %edi,%ebp
  801b6a:	85 ff                	test   %edi,%edi
  801b6c:	75 0b                	jne    801b79 <__umoddi3+0xe9>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f7                	div    %edi
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 f0                	mov    %esi,%eax
  801b7b:	31 d2                	xor    %edx,%edx
  801b7d:	f7 f5                	div    %ebp
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	f7 f5                	div    %ebp
  801b83:	89 d0                	mov    %edx,%eax
  801b85:	e9 44 ff ff ff       	jmp    801ace <__umoddi3+0x3e>
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	89 f2                	mov    %esi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	3b 04 24             	cmp    (%esp),%eax
  801b9b:	72 06                	jb     801ba3 <__umoddi3+0x113>
  801b9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ba1:	77 0f                	ja     801bb2 <__umoddi3+0x122>
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	29 f9                	sub    %edi,%ecx
  801ba7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bab:	89 14 24             	mov    %edx,(%esp)
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bb6:	8b 14 24             	mov    (%esp),%edx
  801bb9:	83 c4 1c             	add    $0x1c,%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    
  801bc1:	8d 76 00             	lea    0x0(%esi),%esi
  801bc4:	2b 04 24             	sub    (%esp),%eax
  801bc7:	19 fa                	sbb    %edi,%edx
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	89 c6                	mov    %eax,%esi
  801bcd:	e9 71 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd8:	72 ea                	jb     801bc4 <__umoddi3+0x134>
  801bda:	89 d9                	mov    %ebx,%ecx
  801bdc:	e9 62 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
