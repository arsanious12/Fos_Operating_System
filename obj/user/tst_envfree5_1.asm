
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it frees them
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 40 29 80 00       	push   $0x802940
  80004a:	e8 9b 15 00 00       	call   8015ea <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 38 17 00 00       	call   80179b <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 7b 17 00 00       	call   8017e6 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 50 29 80 00       	push   $0x802950
  800079:	e8 62 05 00 00       	call   8005e0 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 b8 0b 00 00       	push   $0xbb8
  800094:	68 83 29 80 00       	push   $0x802983
  800099:	e8 58 18 00 00       	call   8018f6 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 65 18 00 00       	call   801914 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 d9 16 00 00       	call   80179b <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 8c 29 80 00       	push   $0x80298c
  8000cb:	e8 10 05 00 00       	call   8005e0 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 52 18 00 00       	call   801930 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 b5 16 00 00       	call   80179b <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 f8 16 00 00       	call   8017e6 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 2e                	je     800127 <_main+0xef>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d\n",
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	50                   	push   %eax
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	68 c0 29 80 00       	push   $0x8029c0
  80010b:	e8 d0 04 00 00       	call   8005e0 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before);
		panic("env_free() does not work correctly... check it again.");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 20 2a 80 00       	push   $0x802a20
  80011b:	6a 1f                	push   $0x1f
  80011d:	68 56 2a 80 00       	push   $0x802a56
  800122:	e8 eb 01 00 00       	call   800312 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 6c 2a 80 00       	push   $0x802a6c
  800132:	e8 a9 04 00 00       	call   8005e0 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 cc 2a 80 00       	push   $0x802acc
  800142:	e8 99 04 00 00       	call   8005e0 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	return;
  80014a:	90                   	nop
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800156:	e8 09 18 00 00       	call   801964 <sys_getenvindex>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80015e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800161:	89 d0                	mov    %edx,%eax
  800163:	c1 e0 06             	shl    $0x6,%eax
  800166:	29 d0                	sub    %edx,%eax
  800168:	c1 e0 02             	shl    $0x2,%eax
  80016b:	01 d0                	add    %edx,%eax
  80016d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800174:	01 c8                	add    %ecx,%eax
  800176:	c1 e0 03             	shl    $0x3,%eax
  800179:	01 d0                	add    %edx,%eax
  80017b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800182:	29 c2                	sub    %eax,%edx
  800184:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80018b:	89 c2                	mov    %eax,%edx
  80018d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800193:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800198:	a1 20 40 80 00       	mov    0x804020,%eax
  80019d:	8a 40 20             	mov    0x20(%eax),%al
  8001a0:	84 c0                	test   %al,%al
  8001a2:	74 0d                	je     8001b1 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8001a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a9:	83 c0 20             	add    $0x20,%eax
  8001ac:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b5:	7e 0a                	jle    8001c1 <libmain+0x74>
		binaryname = argv[0];
  8001b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ba:	8b 00                	mov    (%eax),%eax
  8001bc:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	e8 69 fe ff ff       	call   800038 <_main>
  8001cf:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001d2:	a1 00 40 80 00       	mov    0x804000,%eax
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	0f 84 01 01 00 00    	je     8002e0 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001df:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e5:	bb 10 2c 80 00       	mov    $0x802c10,%ebx
  8001ea:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	89 de                	mov    %ebx,%esi
  8001f3:	89 d1                	mov    %edx,%ecx
  8001f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001fa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ff:	b0 00                	mov    $0x0,%al
  800201:	89 d7                	mov    %edx,%edi
  800203:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800205:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80020c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	50                   	push   %eax
  800213:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800219:	50                   	push   %eax
  80021a:	e8 7b 19 00 00       	call   801b9a <sys_utilities>
  80021f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800222:	e8 c4 14 00 00       	call   8016eb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 30 2b 80 00       	push   $0x802b30
  80022f:	e8 ac 03 00 00       	call   8005e0 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800237:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	74 18                	je     800256 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80023e:	e8 75 19 00 00       	call   801bb8 <sys_get_optimal_num_faults>
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	50                   	push   %eax
  800247:	68 58 2b 80 00       	push   $0x802b58
  80024c:	e8 8f 03 00 00       	call   8005e0 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	eb 59                	jmp    8002af <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800261:	a1 20 40 80 00       	mov    0x804020,%eax
  800266:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	52                   	push   %edx
  800270:	50                   	push   %eax
  800271:	68 7c 2b 80 00       	push   $0x802b7c
  800276:	e8 65 03 00 00       	call   8005e0 <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80027e:	a1 20 40 80 00       	mov    0x804020,%eax
  800283:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800289:	a1 20 40 80 00       	mov    0x804020,%eax
  80028e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800294:	a1 20 40 80 00       	mov    0x804020,%eax
  800299:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80029f:	51                   	push   %ecx
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	68 a4 2b 80 00       	push   $0x802ba4
  8002a7:	e8 34 03 00 00       	call   8005e0 <cprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002af:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b4:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	50                   	push   %eax
  8002be:	68 fc 2b 80 00       	push   $0x802bfc
  8002c3:	e8 18 03 00 00       	call   8005e0 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	68 30 2b 80 00       	push   $0x802b30
  8002d3:	e8 08 03 00 00       	call   8005e0 <cprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002db:	e8 25 14 00 00       	call   801705 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002e0:	e8 1f 00 00 00       	call   800304 <exit>
}
  8002e5:	90                   	nop
  8002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e9:	5b                   	pop    %ebx
  8002ea:	5e                   	pop    %esi
  8002eb:	5f                   	pop    %edi
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	6a 00                	push   $0x0
  8002f9:	e8 32 16 00 00       	call   801930 <sys_destroy_env>
  8002fe:	83 c4 10             	add    $0x10,%esp
}
  800301:	90                   	nop
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <exit>:

void
exit(void)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030a:	e8 87 16 00 00       	call   801996 <sys_exit_env>
}
  80030f:	90                   	nop
  800310:	c9                   	leave  
  800311:	c3                   	ret    

00800312 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800318:	8d 45 10             	lea    0x10(%ebp),%eax
  80031b:	83 c0 04             	add    $0x4,%eax
  80031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800321:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	74 16                	je     800340 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032a:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	50                   	push   %eax
  800333:	68 74 2c 80 00       	push   $0x802c74
  800338:	e8 a3 02 00 00       	call   8005e0 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800340:	a1 04 40 80 00       	mov    0x804004,%eax
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 7c 2c 80 00       	push   $0x802c7c
  800354:	6a 74                	push   $0x74
  800356:	e8 b2 02 00 00       	call   80060d <cprintf_colored>
  80035b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80035e:	8b 45 10             	mov    0x10(%ebp),%eax
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 f4             	pushl  -0xc(%ebp)
  800367:	50                   	push   %eax
  800368:	e8 04 02 00 00       	call   800571 <vcprintf>
  80036d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	6a 00                	push   $0x0
  800375:	68 a4 2c 80 00       	push   $0x802ca4
  80037a:	e8 f2 01 00 00       	call   800571 <vcprintf>
  80037f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800382:	e8 7d ff ff ff       	call   800304 <exit>

	// should not return here
	while (1) ;
  800387:	eb fe                	jmp    800387 <_panic+0x75>

00800389 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	74 14                	je     8003b5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	68 a8 2c 80 00       	push   $0x802ca8
  8003a9:	6a 26                	push   $0x26
  8003ab:	68 f4 2c 80 00       	push   $0x802cf4
  8003b0:	e8 5d ff ff ff       	call   800312 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c3:	e9 c5 00 00 00       	jmp    80048d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	85 c0                	test   %eax,%eax
  8003db:	75 08                	jne    8003e5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003dd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003e0:	e9 a5 00 00 00       	jmp    80048a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003f3:	eb 69                	jmp    80045e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fa:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800403:	89 d0                	mov    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	c1 e0 03             	shl    $0x3,%eax
  80040c:	01 c8                	add    %ecx,%eax
  80040e:	8a 40 04             	mov    0x4(%eax),%al
  800411:	84 c0                	test   %al,%al
  800413:	75 46                	jne    80045b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800420:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	c1 e0 03             	shl    $0x3,%eax
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800433:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80043b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80043d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800440:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	01 c8                	add    %ecx,%eax
  80044c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044e:	39 c2                	cmp    %eax,%edx
  800450:	75 09                	jne    80045b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800452:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800459:	eb 15                	jmp    800470 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045b:	ff 45 e8             	incl   -0x18(%ebp)
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046c:	39 c2                	cmp    %eax,%edx
  80046e:	77 85                	ja     8003f5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800474:	75 14                	jne    80048a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 00 2d 80 00       	push   $0x802d00
  80047e:	6a 3a                	push   $0x3a
  800480:	68 f4 2c 80 00       	push   $0x802cf4
  800485:	e8 88 fe ff ff       	call   800312 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80048a:	ff 45 f0             	incl   -0x10(%ebp)
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800493:	0f 8c 2f ff ff ff    	jl     8003c8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800499:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a7:	eb 26                	jmp    8004cf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ae:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b7:	89 d0                	mov    %edx,%eax
  8004b9:	01 c0                	add    %eax,%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	c1 e0 03             	shl    $0x3,%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8a 40 04             	mov    0x4(%eax),%al
  8004c5:	3c 01                	cmp    $0x1,%al
  8004c7:	75 03                	jne    8004cc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	ff 45 e0             	incl   -0x20(%ebp)
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dd:	39 c2                	cmp    %eax,%edx
  8004df:	77 c8                	ja     8004a9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e7:	74 14                	je     8004fd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 54 2d 80 00       	push   $0x802d54
  8004f1:	6a 44                	push   $0x44
  8004f3:	68 f4 2c 80 00       	push   $0x802cf4
  8004f8:	e8 15 fe ff ff       	call   800312 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fd:	90                   	nop
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	53                   	push   %ebx
  800504:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	8d 48 01             	lea    0x1(%eax),%ecx
  80050f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800512:	89 0a                	mov    %ecx,(%edx)
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  800517:	88 d1                	mov    %dl,%cl
  800519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052a:	75 30                	jne    80055c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80052c:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800532:	a0 44 40 80 00       	mov    0x804044,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053d:	8b 09                	mov    (%ecx),%ecx
  80053f:	89 cb                	mov    %ecx,%ebx
  800541:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800544:	83 c1 08             	add    $0x8,%ecx
  800547:	52                   	push   %edx
  800548:	50                   	push   %eax
  800549:	53                   	push   %ebx
  80054a:	51                   	push   %ecx
  80054b:	e8 57 11 00 00       	call   8016a7 <sys_cputs>
  800550:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055f:	8b 40 04             	mov    0x4(%eax),%eax
  800562:	8d 50 01             	lea    0x1(%eax),%edx
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
  800568:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056b:	90                   	nop
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800581:	00 00 00 
	b.cnt = 0;
  800584:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	ff 75 08             	pushl  0x8(%ebp)
  800594:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	68 00 05 80 00       	push   $0x800500
  8005a0:	e8 5a 02 00 00       	call   8007ff <vprintfmt>
  8005a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005a8:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8005ae:	a0 44 40 80 00       	mov    0x804044,%al
  8005b3:	0f b6 c0             	movzbl %al,%eax
  8005b6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005bc:	52                   	push   %edx
  8005bd:	50                   	push   %eax
  8005be:	51                   	push   %ecx
  8005bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c5:	83 c0 08             	add    $0x8,%eax
  8005c8:	50                   	push   %eax
  8005c9:	e8 d9 10 00 00       	call   8016a7 <sys_cputs>
  8005ce:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005d1:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8005d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e6:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8005ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fc:	50                   	push   %eax
  8005fd:	e8 6f ff ff ff       	call   800571 <vcprintf>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    

0080060d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800613:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	c1 e0 08             	shl    $0x8,%eax
  800620:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800625:	8d 45 0c             	lea    0xc(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	50                   	push   %eax
  800638:	e8 34 ff ff ff       	call   800571 <vcprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800643:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  80064a:	07 00 00 

	return cnt;
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800650:	c9                   	leave  
  800651:	c3                   	ret    

00800652 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800658:	e8 8e 10 00 00       	call   8016eb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80065d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	ff 75 f4             	pushl  -0xc(%ebp)
  80066c:	50                   	push   %eax
  80066d:	e8 ff fe ff ff       	call   800571 <vcprintf>
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800678:	e8 88 10 00 00       	call   801705 <sys_unlock_cons>
	return cnt;
  80067d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	53                   	push   %ebx
  800686:	83 ec 14             	sub    $0x14,%esp
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800695:	8b 45 18             	mov    0x18(%ebp),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a0:	77 55                	ja     8006f7 <printnum+0x75>
  8006a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a5:	72 05                	jb     8006ac <printnum+0x2a>
  8006a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006aa:	77 4b                	ja     8006f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8006c2:	e8 09 20 00 00       	call   8026d0 <__udivdi3>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	ff 75 20             	pushl  0x20(%ebp)
  8006d0:	53                   	push   %ebx
  8006d1:	ff 75 18             	pushl  0x18(%ebp)
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	ff 75 08             	pushl  0x8(%ebp)
  8006dc:	e8 a1 ff ff ff       	call   800682 <printnum>
  8006e1:	83 c4 20             	add    $0x20,%esp
  8006e4:	eb 1a                	jmp    800700 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fe:	7f e6                	jg     8006e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800700:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800703:	bb 00 00 00 00       	mov    $0x0,%ebx
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070e:	53                   	push   %ebx
  80070f:	51                   	push   %ecx
  800710:	52                   	push   %edx
  800711:	50                   	push   %eax
  800712:	e8 c9 20 00 00       	call   8027e0 <__umoddi3>
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	05 b4 2f 80 00       	add    $0x802fb4,%eax
  80071f:	8a 00                	mov    (%eax),%al
  800721:	0f be c0             	movsbl %al,%eax
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	50                   	push   %eax
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80073c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800740:	7e 1c                	jle    80075e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 08             	lea    0x8(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 08             	sub    $0x8,%eax
  800757:	8b 50 04             	mov    0x4(%eax),%edx
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	eb 40                	jmp    80079e <getuint+0x65>
	else if (lflag)
  80075e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800762:	74 1e                	je     800782 <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  800780:	eb 1c                	jmp    80079e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	89 10                	mov    %edx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	83 e8 04             	sub    $0x4,%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a7:	7e 1c                	jle    8007c5 <getint+0x25>
		return va_arg(*ap, long long);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 08             	lea    0x8(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 08             	sub    $0x8,%eax
  8007be:	8b 50 04             	mov    0x4(%eax),%edx
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	eb 38                	jmp    8007fd <getint+0x5d>
	else if (lflag)
  8007c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c9:	74 1a                	je     8007e5 <getint+0x45>
		return va_arg(*ap, long);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 04             	lea    0x4(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	99                   	cltd   
  8007e3:	eb 18                	jmp    8007fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	99                   	cltd   
}
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	56                   	push   %esi
  800803:	53                   	push   %ebx
  800804:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800807:	eb 17                	jmp    800820 <vprintfmt+0x21>
			if (ch == '\0')
  800809:	85 db                	test   %ebx,%ebx
  80080b:	0f 84 c1 03 00 00    	je     800bd2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	53                   	push   %ebx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8d 50 01             	lea    0x1(%eax),%edx
  800826:	89 55 10             	mov    %edx,0x10(%ebp)
  800829:	8a 00                	mov    (%eax),%al
  80082b:	0f b6 d8             	movzbl %al,%ebx
  80082e:	83 fb 25             	cmp    $0x25,%ebx
  800831:	75 d6                	jne    800809 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800833:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800837:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800845:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80084c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800853:	8b 45 10             	mov    0x10(%ebp),%eax
  800856:	8d 50 01             	lea    0x1(%eax),%edx
  800859:	89 55 10             	mov    %edx,0x10(%ebp)
  80085c:	8a 00                	mov    (%eax),%al
  80085e:	0f b6 d8             	movzbl %al,%ebx
  800861:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800864:	83 f8 5b             	cmp    $0x5b,%eax
  800867:	0f 87 3d 03 00 00    	ja     800baa <vprintfmt+0x3ab>
  80086d:	8b 04 85 d8 2f 80 00 	mov    0x802fd8(,%eax,4),%eax
  800874:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800876:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80087a:	eb d7                	jmp    800853 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80087c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800880:	eb d1                	jmp    800853 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800882:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80088c:	89 d0                	mov    %edx,%eax
  80088e:	c1 e0 02             	shl    $0x2,%eax
  800891:	01 d0                	add    %edx,%eax
  800893:	01 c0                	add    %eax,%eax
  800895:	01 d8                	add    %ebx,%eax
  800897:	83 e8 30             	sub    $0x30,%eax
  80089a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a8:	7e 3e                	jle    8008e8 <vprintfmt+0xe9>
  8008aa:	83 fb 39             	cmp    $0x39,%ebx
  8008ad:	7f 39                	jg     8008e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008b2:	eb d5                	jmp    800889 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	83 c0 04             	add    $0x4,%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c8:	eb 1f                	jmp    8008e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ce:	79 83                	jns    800853 <vprintfmt+0x54>
				width = 0;
  8008d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d7:	e9 77 ff ff ff       	jmp    800853 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e3:	e9 6b ff ff ff       	jmp    800853 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	0f 89 60 ff ff ff    	jns    800853 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800900:	e9 4e ff ff ff       	jmp    800853 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800905:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800908:	e9 46 ff ff ff       	jmp    800853 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	50                   	push   %eax
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	ff d0                	call   *%eax
  80092a:	83 c4 10             	add    $0x10,%esp
			break;
  80092d:	e9 9b 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 c0 04             	add    $0x4,%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800943:	85 db                	test   %ebx,%ebx
  800945:	79 02                	jns    800949 <vprintfmt+0x14a>
				err = -err;
  800947:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800949:	83 fb 64             	cmp    $0x64,%ebx
  80094c:	7f 0b                	jg     800959 <vprintfmt+0x15a>
  80094e:	8b 34 9d 20 2e 80 00 	mov    0x802e20(,%ebx,4),%esi
  800955:	85 f6                	test   %esi,%esi
  800957:	75 19                	jne    800972 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800959:	53                   	push   %ebx
  80095a:	68 c5 2f 80 00       	push   $0x802fc5
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 70 02 00 00       	call   800bda <printfmt>
  80096a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096d:	e9 5b 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800972:	56                   	push   %esi
  800973:	68 ce 2f 80 00       	push   $0x802fce
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	ff 75 08             	pushl  0x8(%ebp)
  80097e:	e8 57 02 00 00       	call   800bda <printfmt>
  800983:	83 c4 10             	add    $0x10,%esp
			break;
  800986:	e9 42 02 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 c0 04             	add    $0x4,%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 30                	mov    (%eax),%esi
  80099c:	85 f6                	test   %esi,%esi
  80099e:	75 05                	jne    8009a5 <vprintfmt+0x1a6>
				p = "(null)";
  8009a0:	be d1 2f 80 00       	mov    $0x802fd1,%esi
			if (width > 0 && padc != '-')
  8009a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a9:	7e 6d                	jle    800a18 <vprintfmt+0x219>
  8009ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009af:	74 67                	je     800a18 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	50                   	push   %eax
  8009b8:	56                   	push   %esi
  8009b9:	e8 1e 03 00 00       	call   800cdc <strnlen>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c4:	eb 16                	jmp    8009dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	50                   	push   %eax
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e0:	7f e4                	jg     8009c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e2:	eb 34                	jmp    800a18 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e8:	74 1c                	je     800a06 <vprintfmt+0x207>
  8009ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ed:	7e 05                	jle    8009f4 <vprintfmt+0x1f5>
  8009ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f2:	7e 12                	jle    800a06 <vprintfmt+0x207>
					putch('?', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 3f                	push   $0x3f
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	eb 0f                	jmp    800a15 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a15:	ff 4d e4             	decl   -0x1c(%ebp)
  800a18:	89 f0                	mov    %esi,%eax
  800a1a:	8d 70 01             	lea    0x1(%eax),%esi
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	0f be d8             	movsbl %al,%ebx
  800a22:	85 db                	test   %ebx,%ebx
  800a24:	74 24                	je     800a4a <vprintfmt+0x24b>
  800a26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2a:	78 b8                	js     8009e4 <vprintfmt+0x1e5>
  800a2c:	ff 4d e0             	decl   -0x20(%ebp)
  800a2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a33:	79 af                	jns    8009e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a35:	eb 13                	jmp    800a4a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 20                	push   $0x20
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a47:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4e:	7f e7                	jg     800a37 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a50:	e9 78 01 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5e:	50                   	push   %eax
  800a5f:	e8 3c fd ff ff       	call   8007a0 <getint>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a73:	85 d2                	test   %edx,%edx
  800a75:	79 23                	jns    800a9a <vprintfmt+0x29b>
				putch('-', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 2d                	push   $0x2d
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	f7 d8                	neg    %eax
  800a8f:	83 d2 00             	adc    $0x0,%edx
  800a92:	f7 da                	neg    %edx
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa1:	e9 bc 00 00 00       	jmp    800b62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 e8             	pushl  -0x18(%ebp)
  800aac:	8d 45 14             	lea    0x14(%ebp),%eax
  800aaf:	50                   	push   %eax
  800ab0:	e8 84 fc ff ff       	call   800739 <getuint>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac5:	e9 98 00 00 00       	jmp    800b62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 58                	push   $0x58
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 58                	push   $0x58
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 58                	push   $0x58
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			break;
  800afa:	e9 ce 00 00 00       	jmp    800bcd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 30                	push   $0x30
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 78                	push   $0x78
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 c0 04             	add    $0x4,%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b41:	eb 1f                	jmp    800b62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 e8             	pushl  -0x18(%ebp)
  800b49:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	e8 e7 fb ff ff       	call   800739 <getuint>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	52                   	push   %edx
  800b6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b70:	50                   	push   %eax
  800b71:	ff 75 f4             	pushl  -0xc(%ebp)
  800b74:	ff 75 f0             	pushl  -0x10(%ebp)
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	ff 75 08             	pushl  0x8(%ebp)
  800b7d:	e8 00 fb ff ff       	call   800682 <printnum>
  800b82:	83 c4 20             	add    $0x20,%esp
			break;
  800b85:	eb 46                	jmp    800bcd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			break;
  800b96:	eb 35                	jmp    800bcd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b98:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800b9f:	eb 2c                	jmp    800bcd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ba1:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ba8:	eb 23                	jmp    800bcd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	6a 25                	push   $0x25
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	ff d0                	call   *%eax
  800bb7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	eb 03                	jmp    800bc2 <vprintfmt+0x3c3>
  800bbf:	ff 4d 10             	decl   0x10(%ebp)
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	48                   	dec    %eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	3c 25                	cmp    $0x25,%al
  800bca:	75 f3                	jne    800bbf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bcc:	90                   	nop
		}
	}
  800bcd:	e9 35 fc ff ff       	jmp    800807 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800be0:	8d 45 10             	lea    0x10(%ebp),%eax
  800be3:	83 c0 04             	add    $0x4,%eax
  800be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	50                   	push   %eax
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	e8 04 fc ff ff       	call   8007ff <vprintfmt>
  800bfb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bfe:	90                   	nop
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8b 40 08             	mov    0x8(%eax),%eax
  800c0a:	8d 50 01             	lea    0x1(%eax),%edx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8b 40 04             	mov    0x4(%eax),%eax
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	73 12                	jae    800c34 <sprintputch+0x33>
		*b->buf++ = ch;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	8d 48 01             	lea    0x1(%eax),%ecx
  800c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2d:	89 0a                	mov    %ecx,(%edx)
  800c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c32:	88 10                	mov    %dl,(%eax)
}
  800c34:	90                   	nop
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	01 d0                	add    %edx,%eax
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c5c:	74 06                	je     800c64 <vsnprintf+0x2d>
  800c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c62:	7f 07                	jg     800c6b <vsnprintf+0x34>
		return -E_INVAL;
  800c64:	b8 03 00 00 00       	mov    $0x3,%eax
  800c69:	eb 20                	jmp    800c8b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c6b:	ff 75 14             	pushl  0x14(%ebp)
  800c6e:	ff 75 10             	pushl  0x10(%ebp)
  800c71:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	68 01 0c 80 00       	push   $0x800c01
  800c7a:	e8 80 fb ff ff       	call   8007ff <vprintfmt>
  800c7f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c93:	8d 45 10             	lea    0x10(%ebp),%eax
  800c96:	83 c0 04             	add    $0x4,%eax
  800c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca2:	50                   	push   %eax
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	e8 89 ff ff ff       	call   800c37 <vsnprintf>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc6:	eb 06                	jmp    800cce <strlen+0x15>
		n++;
  800cc8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccb:	ff 45 08             	incl   0x8(%ebp)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	75 f1                	jne    800cc8 <strlen+0xf>
		n++;
	return n;
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce9:	eb 09                	jmp    800cf4 <strnlen+0x18>
		n++;
  800ceb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cee:	ff 45 08             	incl   0x8(%ebp)
  800cf1:	ff 4d 0c             	decl   0xc(%ebp)
  800cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf8:	74 09                	je     800d03 <strnlen+0x27>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	75 e8                	jne    800ceb <strnlen+0xf>
		n++;
	return n;
  800d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d14:	90                   	nop
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8d 50 01             	lea    0x1(%eax),%edx
  800d1b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d24:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d27:	8a 12                	mov    (%edx),%dl
  800d29:	88 10                	mov    %dl,(%eax)
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	75 e4                	jne    800d15 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d49:	eb 1f                	jmp    800d6a <strncpy+0x34>
		*dst++ = *src;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8d 50 01             	lea    0x1(%eax),%edx
  800d51:	89 55 08             	mov    %edx,0x8(%ebp)
  800d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d57:	8a 12                	mov    (%edx),%dl
  800d59:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	74 03                	je     800d67 <strncpy+0x31>
			src++;
  800d64:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d67:	ff 45 fc             	incl   -0x4(%ebp)
  800d6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d70:	72 d9                	jb     800d4b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 30                	je     800db9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d89:	eb 16                	jmp    800da1 <strlcpy+0x2a>
			*dst++ = *src++;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8d 50 01             	lea    0x1(%eax),%edx
  800d91:	89 55 08             	mov    %edx,0x8(%ebp)
  800d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9d:	8a 12                	mov    (%edx),%dl
  800d9f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800da1:	ff 4d 10             	decl   0x10(%ebp)
  800da4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da8:	74 09                	je     800db3 <strlcpy+0x3c>
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	75 d8                	jne    800d8b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	29 c2                	sub    %eax,%edx
  800dc1:	89 d0                	mov    %edx,%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc8:	eb 06                	jmp    800dd0 <strcmp+0xb>
		p++, q++;
  800dca:	ff 45 08             	incl   0x8(%ebp)
  800dcd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	74 0e                	je     800de7 <strcmp+0x22>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 10                	mov    (%eax),%dl
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	38 c2                	cmp    %al,%dl
  800de5:	74 e3                	je     800dca <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e00:	eb 09                	jmp    800e0b <strncmp+0xe>
		n--, p++, q++;
  800e02:	ff 4d 10             	decl   0x10(%ebp)
  800e05:	ff 45 08             	incl   0x8(%ebp)
  800e08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	74 17                	je     800e28 <strncmp+0x2b>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	74 0e                	je     800e28 <strncmp+0x2b>
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 10                	mov    (%eax),%dl
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	38 c2                	cmp    %al,%dl
  800e26:	74 da                	je     800e02 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2c:	75 07                	jne    800e35 <strncmp+0x38>
		return 0;
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e33:	eb 14                	jmp    800e49 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	0f b6 d0             	movzbl %al,%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	0f b6 c0             	movzbl %al,%eax
  800e45:	29 c2                	sub    %eax,%edx
  800e47:	89 d0                	mov    %edx,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e57:	eb 12                	jmp    800e6b <strchr+0x20>
		if (*s == c)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e61:	75 05                	jne    800e68 <strchr+0x1d>
			return (char *) s;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	eb 11                	jmp    800e79 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e68:	ff 45 08             	incl   0x8(%ebp)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	84 c0                	test   %al,%al
  800e72:	75 e5                	jne    800e59 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e87:	eb 0d                	jmp    800e96 <strfind+0x1b>
		if (*s == c)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e91:	74 0e                	je     800ea1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	75 ea                	jne    800e89 <strfind+0xe>
  800e9f:	eb 01                	jmp    800ea2 <strfind+0x27>
		if (*s == c)
			break;
  800ea1:	90                   	nop
	return (char *) s;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea5:	c9                   	leave  
  800ea6:	c3                   	ret    

00800ea7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800eb3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb7:	76 63                	jbe    800f1c <memset+0x75>
		uint64 data_block = c;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	99                   	cltd   
  800ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ecd:	c1 e0 08             	shl    $0x8,%eax
  800ed0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ee0:	c1 e0 10             	shl    $0x10,%eax
  800ee3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800efc:	eb 18                	jmp    800f16 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800efe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f01:	8d 41 08             	lea    0x8(%ecx),%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0d:	89 01                	mov    %eax,(%ecx)
  800f0f:	89 51 04             	mov    %edx,0x4(%ecx)
  800f12:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f16:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f1a:	77 e2                	ja     800efe <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f20:	74 23                	je     800f45 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f28:	eb 0e                	jmp    800f38 <memset+0x91>
			*p8++ = (uint8)c;
  800f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f36:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	75 e5                	jne    800f2a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f5c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f60:	76 24                	jbe    800f86 <memcpy+0x3c>
		while(n >= 8){
  800f62:	eb 1c                	jmp    800f80 <memcpy+0x36>
			*d64 = *s64;
  800f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f67:	8b 50 04             	mov    0x4(%eax),%edx
  800f6a:	8b 00                	mov    (%eax),%eax
  800f6c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f6f:	89 01                	mov    %eax,(%ecx)
  800f71:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f74:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f78:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f7c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f80:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f84:	77 de                	ja     800f64 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8a:	74 31                	je     800fbd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f98:	eb 16                	jmp    800fb0 <memcpy+0x66>
			*d8++ = *s8++;
  800f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fac:	8a 12                	mov    (%edx),%dl
  800fae:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 dd                	jne    800f9a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fda:	73 50                	jae    80102c <memmove+0x6a>
  800fdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 d0                	add    %edx,%eax
  800fe4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fe7:	76 43                	jbe    80102c <memmove+0x6a>
		s += n;
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ff5:	eb 10                	jmp    801007 <memmove+0x45>
			*--d = *--s;
  800ff7:	ff 4d f8             	decl   -0x8(%ebp)
  800ffa:	ff 4d fc             	decl   -0x4(%ebp)
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 10                	mov    (%eax),%dl
  801002:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801005:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 e3                	jne    800ff7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801014:	eb 23                	jmp    801039 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	8d 50 01             	lea    0x1(%eax),%edx
  80101c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801022:	8d 4a 01             	lea    0x1(%edx),%ecx
  801025:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801028:	8a 12                	mov    (%edx),%dl
  80102a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	89 55 10             	mov    %edx,0x10(%ebp)
  801035:	85 c0                	test   %eax,%eax
  801037:	75 dd                	jne    801016 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801050:	eb 2a                	jmp    80107c <memcmp+0x3e>
		if (*s1 != *s2)
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801055:	8a 10                	mov    (%eax),%dl
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	38 c2                	cmp    %al,%dl
  80105e:	74 16                	je     801076 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	0f b6 d0             	movzbl %al,%edx
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	0f b6 c0             	movzbl %al,%eax
  801070:	29 c2                	sub    %eax,%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	eb 18                	jmp    80108e <memcmp+0x50>
		s1++, s2++;
  801076:	ff 45 fc             	incl   -0x4(%ebp)
  801079:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 c9                	jne    801052 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010a1:	eb 15                	jmp    8010b8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	0f b6 d0             	movzbl %al,%edx
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	0f b6 c0             	movzbl %al,%eax
  8010b1:	39 c2                	cmp    %eax,%edx
  8010b3:	74 0d                	je     8010c2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010b5:	ff 45 08             	incl   0x8(%ebp)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010be:	72 e3                	jb     8010a3 <memfind+0x13>
  8010c0:	eb 01                	jmp    8010c3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010c2:	90                   	nop
	return (void *) s;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010dc:	eb 03                	jmp    8010e1 <strtol+0x19>
		s++;
  8010de:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 20                	cmp    $0x20,%al
  8010e8:	74 f4                	je     8010de <strtol+0x16>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 09                	cmp    $0x9,%al
  8010f1:	74 eb                	je     8010de <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	3c 2b                	cmp    $0x2b,%al
  8010fa:	75 05                	jne    801101 <strtol+0x39>
		s++;
  8010fc:	ff 45 08             	incl   0x8(%ebp)
  8010ff:	eb 13                	jmp    801114 <strtol+0x4c>
	else if (*s == '-')
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 2d                	cmp    $0x2d,%al
  801108:	75 0a                	jne    801114 <strtol+0x4c>
		s++, neg = 1;
  80110a:	ff 45 08             	incl   0x8(%ebp)
  80110d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801114:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801118:	74 06                	je     801120 <strtol+0x58>
  80111a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80111e:	75 20                	jne    801140 <strtol+0x78>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 30                	cmp    $0x30,%al
  801127:	75 17                	jne    801140 <strtol+0x78>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	40                   	inc    %eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 78                	cmp    $0x78,%al
  801131:	75 0d                	jne    801140 <strtol+0x78>
		s += 2, base = 16;
  801133:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801137:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80113e:	eb 28                	jmp    801168 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801144:	75 15                	jne    80115b <strtol+0x93>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	3c 30                	cmp    $0x30,%al
  80114d:	75 0c                	jne    80115b <strtol+0x93>
		s++, base = 8;
  80114f:	ff 45 08             	incl   0x8(%ebp)
  801152:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801159:	eb 0d                	jmp    801168 <strtol+0xa0>
	else if (base == 0)
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	75 07                	jne    801168 <strtol+0xa0>
		base = 10;
  801161:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2f                	cmp    $0x2f,%al
  80116f:	7e 19                	jle    80118a <strtol+0xc2>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	3c 39                	cmp    $0x39,%al
  801178:	7f 10                	jg     80118a <strtol+0xc2>
			dig = *s - '0';
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f be c0             	movsbl %al,%eax
  801182:	83 e8 30             	sub    $0x30,%eax
  801185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801188:	eb 42                	jmp    8011cc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 60                	cmp    $0x60,%al
  801191:	7e 19                	jle    8011ac <strtol+0xe4>
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 7a                	cmp    $0x7a,%al
  80119a:	7f 10                	jg     8011ac <strtol+0xe4>
			dig = *s - 'a' + 10;
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	0f be c0             	movsbl %al,%eax
  8011a4:	83 e8 57             	sub    $0x57,%eax
  8011a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011aa:	eb 20                	jmp    8011cc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 40                	cmp    $0x40,%al
  8011b3:	7e 39                	jle    8011ee <strtol+0x126>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 5a                	cmp    $0x5a,%al
  8011bc:	7f 30                	jg     8011ee <strtol+0x126>
			dig = *s - 'A' + 10;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	0f be c0             	movsbl %al,%eax
  8011c6:	83 e8 37             	sub    $0x37,%eax
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d2:	7d 19                	jge    8011ed <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011d4:	ff 45 08             	incl   0x8(%ebp)
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011de:	89 c2                	mov    %eax,%edx
  8011e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e3:	01 d0                	add    %edx,%eax
  8011e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011e8:	e9 7b ff ff ff       	jmp    801168 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ed:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f2:	74 08                	je     8011fc <strtol+0x134>
		*endptr = (char *) s;
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801200:	74 07                	je     801209 <strtol+0x141>
  801202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801205:	f7 d8                	neg    %eax
  801207:	eb 03                	jmp    80120c <strtol+0x144>
  801209:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <ltostr>:

void
ltostr(long value, char *str)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80121b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801226:	79 13                	jns    80123b <ltostr+0x2d>
	{
		neg = 1;
  801228:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801235:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801238:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801243:	99                   	cltd   
  801244:	f7 f9                	idiv   %ecx
  801246:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	89 c2                	mov    %eax,%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125c:	83 c2 30             	add    $0x30,%edx
  80125f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801264:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801269:	f7 e9                	imul   %ecx
  80126b:	c1 fa 02             	sar    $0x2,%edx
  80126e:	89 c8                	mov    %ecx,%eax
  801270:	c1 f8 1f             	sar    $0x1f,%eax
  801273:	29 c2                	sub    %eax,%edx
  801275:	89 d0                	mov    %edx,%eax
  801277:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80127a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127e:	75 bb                	jne    80123b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801287:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128a:	48                   	dec    %eax
  80128b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80128e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801292:	74 3d                	je     8012d1 <ltostr+0xc3>
		start = 1 ;
  801294:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80129b:	eb 34                	jmp    8012d1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80129d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 c2                	add    %eax,%edx
  8012b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c8                	add    %ecx,%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012cb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ce:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d7:	7c c4                	jl     80129d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 d0                	add    %edx,%eax
  8012e1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ed:	ff 75 08             	pushl  0x8(%ebp)
  8012f0:	e8 c4 f9 ff ff       	call   800cb9 <strlen>
  8012f5:	83 c4 04             	add    $0x4,%esp
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	e8 b6 f9 ff ff       	call   800cb9 <strlen>
  801303:	83 c4 04             	add    $0x4,%esp
  801306:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801317:	eb 17                	jmp    801330 <strcconcat+0x49>
		final[s] = str1[s] ;
  801319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 c2                	add    %eax,%edx
  801321:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	01 c8                	add    %ecx,%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80132d:	ff 45 fc             	incl   -0x4(%ebp)
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801336:	7c e1                	jl     801319 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80133f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801346:	eb 1f                	jmp    801367 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134b:	8d 50 01             	lea    0x1(%eax),%edx
  80134e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 c2                	add    %eax,%edx
  801358:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c8                	add    %ecx,%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801364:	ff 45 f8             	incl   -0x8(%ebp)
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136d:	7c d9                	jl     801348 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	c6 00 00             	movb   $0x0,(%eax)
}
  80137a:	90                   	nop
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801389:	8b 45 14             	mov    0x14(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a0:	eb 0c                	jmp    8013ae <strsplit+0x31>
			*string++ = 0;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8d 50 01             	lea    0x1(%eax),%edx
  8013a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ab:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 18                	je     8013cf <strsplit+0x52>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	0f be c0             	movsbl %al,%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	e8 83 fa ff ff       	call   800e4b <strchr>
  8013c8:	83 c4 08             	add    $0x8,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 d3                	jne    8013a2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	74 5a                	je     801432 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	83 f8 0f             	cmp    $0xf,%eax
  8013e0:	75 07                	jne    8013e9 <strsplit+0x6c>
		{
			return 0;
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e7:	eb 66                	jmp    80144f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f4:	89 0a                	mov    %ecx,(%edx)
  8013f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801407:	eb 03                	jmp    80140c <strsplit+0x8f>
			string++;
  801409:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	84 c0                	test   %al,%al
  801413:	74 8b                	je     8013a0 <strsplit+0x23>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	50                   	push   %eax
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	e8 25 fa ff ff       	call   800e4b <strchr>
  801426:	83 c4 08             	add    $0x8,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 dc                	je     801409 <strsplit+0x8c>
			string++;
	}
  80142d:	e9 6e ff ff ff       	jmp    8013a0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801432:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143f:	8b 45 10             	mov    0x10(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80144a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801464:	eb 4a                	jmp    8014b0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	01 c2                	add    %eax,%edx
  80146e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 c8                	add    %ecx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80147a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 40                	cmp    $0x40,%al
  801486:	7e 25                	jle    8014ad <str2lower+0x5c>
  801488:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	3c 5a                	cmp    $0x5a,%al
  801494:	7f 17                	jg     8014ad <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	01 d0                	add    %edx,%eax
  80149e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a4:	01 ca                	add    %ecx,%edx
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	83 c2 20             	add    $0x20,%edx
  8014ab:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014ad:	ff 45 fc             	incl   -0x4(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 01 f8 ff ff       	call   800cb9 <strlen>
  8014b8:	83 c4 04             	add    $0x4,%esp
  8014bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014be:	7f a6                	jg     801466 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	74 42                	je     801516 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	68 00 00 00 82       	push   $0x82000000
  8014dc:	68 00 00 00 80       	push   $0x80000000
  8014e1:	e8 00 08 00 00       	call   801ce6 <initialize_dynamic_allocator>
  8014e6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014e9:	e8 e7 05 00 00       	call   801ad5 <sys_get_uheap_strategy>
  8014ee:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014f3:	a1 40 40 80 00       	mov    0x804040,%eax
  8014f8:	05 00 10 00 00       	add    $0x1000,%eax
  8014fd:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801502:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801507:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80150c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801513:	00 00 00 
	}
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	68 06 04 00 00       	push   $0x406
  801535:	50                   	push   %eax
  801536:	e8 e4 01 00 00       	call   80171f <__sys_allocate_page>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801545:	79 14                	jns    80155b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	68 48 31 80 00       	push   $0x803148
  80154f:	6a 1f                	push   $0x1f
  801551:	68 84 31 80 00       	push   $0x803184
  801556:	e8 b7 ed ff ff       	call   800312 <_panic>
	return 0;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801576:	83 ec 0c             	sub    $0xc,%esp
  801579:	50                   	push   %eax
  80157a:	e8 e7 01 00 00       	call   801766 <__sys_unmap_frame>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801589:	79 14                	jns    80159f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 90 31 80 00       	push   $0x803190
  801593:	6a 2a                	push   $0x2a
  801595:	68 84 31 80 00       	push   $0x803184
  80159a:	e8 73 ed ff ff       	call   800312 <_panic>
}
  80159f:	90                   	nop
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015a8:	e8 18 ff ff ff       	call   8014c5 <uheap_init>
	if (size == 0) return NULL ;
  8015ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b1:	75 07                	jne    8015ba <malloc+0x18>
  8015b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b8:	eb 14                	jmp    8015ce <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 d0 31 80 00       	push   $0x8031d0
  8015c2:	6a 3e                	push   $0x3e
  8015c4:	68 84 31 80 00       	push   $0x803184
  8015c9:	e8 44 ed ff ff       	call   800312 <_panic>
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	68 f8 31 80 00       	push   $0x8031f8
  8015de:	6a 49                	push   $0x49
  8015e0:	68 84 31 80 00       	push   $0x803184
  8015e5:	e8 28 ed ff ff       	call   800312 <_panic>

008015ea <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 18             	sub    $0x18,%esp
  8015f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015f6:	e8 ca fe ff ff       	call   8014c5 <uheap_init>
	if (size == 0) return NULL ;
  8015fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ff:	75 07                	jne    801608 <smalloc+0x1e>
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 14                	jmp    80161c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	68 1c 32 80 00       	push   $0x80321c
  801610:	6a 5a                	push   $0x5a
  801612:	68 84 31 80 00       	push   $0x803184
  801617:	e8 f6 ec ff ff       	call   800312 <_panic>
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801624:	e8 9c fe ff ff       	call   8014c5 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 44 32 80 00       	push   $0x803244
  801631:	6a 6a                	push   $0x6a
  801633:	68 84 31 80 00       	push   $0x803184
  801638:	e8 d5 ec ff ff       	call   800312 <_panic>

0080163d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801643:	e8 7d fe ff ff       	call   8014c5 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	68 68 32 80 00       	push   $0x803268
  801650:	68 88 00 00 00       	push   $0x88
  801655:	68 84 31 80 00       	push   $0x803184
  80165a:	e8 b3 ec ff ff       	call   800312 <_panic>

0080165f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 90 32 80 00       	push   $0x803290
  80166d:	68 9b 00 00 00       	push   $0x9b
  801672:	68 84 31 80 00       	push   $0x803184
  801677:	e8 96 ec ff ff       	call   800312 <_panic>

0080167c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801691:	8b 7d 18             	mov    0x18(%ebp),%edi
  801694:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801697:	cd 30                	int    $0x30
  801699:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5f                   	pop    %edi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	51                   	push   %ecx
  8016c0:	52                   	push   %edx
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	50                   	push   %eax
  8016c5:	6a 00                	push   $0x0
  8016c7:	e8 b0 ff ff ff       	call   80167c <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	90                   	nop
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 02                	push   $0x2
  8016e1:	e8 96 ff ff ff       	call   80167c <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 03                	push   $0x3
  8016fa:	e8 7d ff ff ff       	call   80167c <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 04                	push   $0x4
  801714:	e8 63 ff ff ff       	call   80167c <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	90                   	nop
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801722:	8b 55 0c             	mov    0xc(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 08                	push   $0x8
  801732:	e8 45 ff ff ff       	call   80167c <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801741:	8b 75 18             	mov    0x18(%ebp),%esi
  801744:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	51                   	push   %ecx
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 09                	push   $0x9
  801757:	e8 20 ff ff ff       	call   80167c <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	6a 0a                	push   $0xa
  801776:	e8 01 ff ff ff       	call   80167c <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 0b                	push   $0xb
  801791:	e8 e6 fe ff ff       	call   80167c <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 0c                	push   $0xc
  8017aa:	e8 cd fe ff ff       	call   80167c <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0d                	push   $0xd
  8017c3:	e8 b4 fe ff ff       	call   80167c <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0e                	push   $0xe
  8017dc:	e8 9b fe ff ff       	call   80167c <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 0f                	push   $0xf
  8017f5:	e8 82 fe ff ff       	call   80167c <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 10                	push   $0x10
  80180f:	e8 68 fe ff ff       	call   80167c <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 11                	push   $0x11
  801828:	e8 4f fe ff ff       	call   80167c <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_cputc>:

void
sys_cputc(const char c)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80183f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	50                   	push   %eax
  80184c:	6a 01                	push   $0x1
  80184e:	e8 29 fe ff ff       	call   80167c <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 14                	push   $0x14
  801868:	e8 0f fe ff ff       	call   80167c <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80187f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801882:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	6a 00                	push   $0x0
  80188b:	51                   	push   %ecx
  80188c:	52                   	push   %edx
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	50                   	push   %eax
  801891:	6a 15                	push   $0x15
  801893:	e8 e4 fd ff ff       	call   80167c <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	52                   	push   %edx
  8018ad:	50                   	push   %eax
  8018ae:	6a 16                	push   $0x16
  8018b0:	e8 c7 fd ff ff       	call   80167c <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	51                   	push   %ecx
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 17                	push   $0x17
  8018cf:	e8 a8 fd ff ff       	call   80167c <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 18                	push   $0x18
  8018ec:	e8 8b fd ff ff       	call   80167c <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 14             	pushl  0x14(%ebp)
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	50                   	push   %eax
  801908:	6a 19                	push   $0x19
  80190a:	e8 6d fd ff ff       	call   80167c <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	50                   	push   %eax
  801923:	6a 1a                	push   $0x1a
  801925:	e8 52 fd ff ff       	call   80167c <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	90                   	nop
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	50                   	push   %eax
  80193f:	6a 1b                	push   $0x1b
  801941:	e8 36 fd ff ff       	call   80167c <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 05                	push   $0x5
  80195a:	e8 1d fd ff ff       	call   80167c <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 06                	push   $0x6
  801973:	e8 04 fd ff ff       	call   80167c <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 07                	push   $0x7
  80198c:	e8 eb fc ff ff       	call   80167c <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_exit_env>:


void sys_exit_env(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 1c                	push   $0x1c
  8019a5:	e8 d2 fc ff ff       	call   80167c <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b9:	8d 50 04             	lea    0x4(%eax),%edx
  8019bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 1d                	push   $0x1d
  8019c9:	e8 ae fc ff ff       	call   80167c <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return result;
  8019d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019da:	89 01                	mov    %eax,(%ecx)
  8019dc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	c9                   	leave  
  8019e3:	c2 04 00             	ret    $0x4

008019e6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	ff 75 10             	pushl  0x10(%ebp)
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	6a 13                	push   $0x13
  8019f8:	e8 7f fc ff ff       	call   80167c <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801a00:	90                   	nop
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 1e                	push   $0x1e
  801a12:	e8 65 fc ff ff       	call   80167c <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a28:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	50                   	push   %eax
  801a35:	6a 1f                	push   $0x1f
  801a37:	e8 40 fc ff ff       	call   80167c <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <rsttst>:
void rsttst()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 21                	push   $0x21
  801a51:	e8 26 fc ff ff       	call   80167c <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
	return ;
  801a59:	90                   	nop
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 45 14             	mov    0x14(%ebp),%eax
  801a65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a68:	8b 55 18             	mov    0x18(%ebp),%edx
  801a6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6f:	52                   	push   %edx
  801a70:	50                   	push   %eax
  801a71:	ff 75 10             	pushl  0x10(%ebp)
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	ff 75 08             	pushl  0x8(%ebp)
  801a7a:	6a 20                	push   $0x20
  801a7c:	e8 fb fb ff ff       	call   80167c <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
	return ;
  801a84:	90                   	nop
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <chktst>:
void chktst(uint32 n)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 22                	push   $0x22
  801a97:	e8 e0 fb ff ff       	call   80167c <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <inctst>:

void inctst()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 23                	push   $0x23
  801ab1:	e8 c6 fb ff ff       	call   80167c <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <gettst>:
uint32 gettst()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 24                	push   $0x24
  801acb:	e8 ac fb ff ff       	call   80167c <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 25                	push   $0x25
  801ae4:	e8 93 fb ff ff       	call   80167c <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
  801aec:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801af1:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	6a 26                	push   $0x26
  801b10:	e8 67 fb ff ff       	call   80167c <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return ;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	53                   	push   %ebx
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 27                	push   $0x27
  801b33:	e8 44 fb ff ff       	call   80167c <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 28                	push   $0x28
  801b53:	e8 24 fb ff ff       	call   80167c <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b60:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	51                   	push   %ecx
  801b6c:	ff 75 10             	pushl  0x10(%ebp)
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 29                	push   $0x29
  801b73:	e8 04 fb ff ff       	call   80167c <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 10             	pushl  0x10(%ebp)
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	6a 12                	push   $0x12
  801b8f:	e8 e8 fa ff ff       	call   80167c <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 2a                	push   $0x2a
  801bad:	e8 ca fa ff ff       	call   80167c <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
	return;
  801bb5:	90                   	nop
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 2b                	push   $0x2b
  801bc7:	e8 b0 fa ff ff       	call   80167c <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	6a 2d                	push   $0x2d
  801be2:	e8 95 fa ff ff       	call   80167c <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
	return;
  801bea:	90                   	nop
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 2c                	push   $0x2c
  801bfe:	e8 79 fa ff ff       	call   80167c <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 b4 32 80 00       	push   $0x8032b4
  801c17:	68 25 01 00 00       	push   $0x125
  801c1c:	68 e7 32 80 00       	push   $0x8032e7
  801c21:	e8 ec e6 ff ff       	call   800312 <_panic>

00801c26 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801c2c:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801c33:	72 09                	jb     801c3e <to_page_va+0x18>
  801c35:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801c3c:	72 14                	jb     801c52 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	68 f8 32 80 00       	push   $0x8032f8
  801c46:	6a 15                	push   $0x15
  801c48:	68 23 33 80 00       	push   $0x803323
  801c4d:	e8 c0 e6 ff ff       	call   800312 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	ba 60 40 80 00       	mov    $0x804060,%edx
  801c5a:	29 d0                	sub    %edx,%eax
  801c5c:	c1 f8 02             	sar    $0x2,%eax
  801c5f:	89 c2                	mov    %eax,%edx
  801c61:	89 d0                	mov    %edx,%eax
  801c63:	c1 e0 02             	shl    $0x2,%eax
  801c66:	01 d0                	add    %edx,%eax
  801c68:	c1 e0 02             	shl    $0x2,%eax
  801c6b:	01 d0                	add    %edx,%eax
  801c6d:	c1 e0 02             	shl    $0x2,%eax
  801c70:	01 d0                	add    %edx,%eax
  801c72:	89 c1                	mov    %eax,%ecx
  801c74:	c1 e1 08             	shl    $0x8,%ecx
  801c77:	01 c8                	add    %ecx,%eax
  801c79:	89 c1                	mov    %eax,%ecx
  801c7b:	c1 e1 10             	shl    $0x10,%ecx
  801c7e:	01 c8                	add    %ecx,%eax
  801c80:	01 c0                	add    %eax,%eax
  801c82:	01 d0                	add    %edx,%eax
  801c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8a:	c1 e0 0c             	shl    $0xc,%eax
  801c8d:	89 c2                	mov    %eax,%edx
  801c8f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c94:	01 d0                	add    %edx,%eax
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801c9e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca6:	29 c2                	sub    %eax,%edx
  801ca8:	89 d0                	mov    %edx,%eax
  801caa:	c1 e8 0c             	shr    $0xc,%eax
  801cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cb4:	78 09                	js     801cbf <to_page_info+0x27>
  801cb6:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801cbd:	7e 14                	jle    801cd3 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801cbf:	83 ec 04             	sub    $0x4,%esp
  801cc2:	68 3c 33 80 00       	push   $0x80333c
  801cc7:	6a 22                	push   $0x22
  801cc9:	68 23 33 80 00       	push   $0x803323
  801cce:	e8 3f e6 ff ff       	call   800312 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd6:	89 d0                	mov    %edx,%eax
  801cd8:	01 c0                	add    %eax,%eax
  801cda:	01 d0                	add    %edx,%eax
  801cdc:	c1 e0 02             	shl    $0x2,%eax
  801cdf:	05 60 40 80 00       	add    $0x804060,%eax
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	05 00 00 00 02       	add    $0x2000000,%eax
  801cf4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cf7:	73 16                	jae    801d0f <initialize_dynamic_allocator+0x29>
  801cf9:	68 60 33 80 00       	push   $0x803360
  801cfe:	68 86 33 80 00       	push   $0x803386
  801d03:	6a 34                	push   $0x34
  801d05:	68 23 33 80 00       	push   $0x803323
  801d0a:	e8 03 e6 ff ff       	call   800312 <_panic>
		is_initialized = 1;
  801d0f:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801d16:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801d29:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801d30:	00 00 00 
  801d33:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801d3a:	00 00 00 
  801d3d:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801d44:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4a:	2b 45 08             	sub    0x8(%ebp),%eax
  801d4d:	c1 e8 0c             	shr    $0xc,%eax
  801d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d5a:	e9 c8 00 00 00       	jmp    801e27 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d62:	89 d0                	mov    %edx,%eax
  801d64:	01 c0                	add    %eax,%eax
  801d66:	01 d0                	add    %edx,%eax
  801d68:	c1 e0 02             	shl    $0x2,%eax
  801d6b:	05 68 40 80 00       	add    $0x804068,%eax
  801d70:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	89 d0                	mov    %edx,%eax
  801d7a:	01 c0                	add    %eax,%eax
  801d7c:	01 d0                	add    %edx,%eax
  801d7e:	c1 e0 02             	shl    $0x2,%eax
  801d81:	05 6a 40 80 00       	add    $0x80406a,%eax
  801d86:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801d8b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d91:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	01 c0                	add    %eax,%eax
  801d98:	01 c8                	add    %ecx,%eax
  801d9a:	c1 e0 02             	shl    $0x2,%eax
  801d9d:	05 64 40 80 00       	add    $0x804064,%eax
  801da2:	89 10                	mov    %edx,(%eax)
  801da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	01 c0                	add    %eax,%eax
  801dab:	01 d0                	add    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	05 64 40 80 00       	add    $0x804064,%eax
  801db5:	8b 00                	mov    (%eax),%eax
  801db7:	85 c0                	test   %eax,%eax
  801db9:	74 1b                	je     801dd6 <initialize_dynamic_allocator+0xf0>
  801dbb:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801dc1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801dc4:	89 c8                	mov    %ecx,%eax
  801dc6:	01 c0                	add    %eax,%eax
  801dc8:	01 c8                	add    %ecx,%eax
  801dca:	c1 e0 02             	shl    $0x2,%eax
  801dcd:	05 60 40 80 00       	add    $0x804060,%eax
  801dd2:	89 02                	mov    %eax,(%edx)
  801dd4:	eb 16                	jmp    801dec <initialize_dynamic_allocator+0x106>
  801dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	01 c0                	add    %eax,%eax
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	c1 e0 02             	shl    $0x2,%eax
  801de2:	05 60 40 80 00       	add    $0x804060,%eax
  801de7:	a3 48 40 80 00       	mov    %eax,0x804048
  801dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801def:	89 d0                	mov    %edx,%eax
  801df1:	01 c0                	add    %eax,%eax
  801df3:	01 d0                	add    %edx,%eax
  801df5:	c1 e0 02             	shl    $0x2,%eax
  801df8:	05 60 40 80 00       	add    $0x804060,%eax
  801dfd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e05:	89 d0                	mov    %edx,%eax
  801e07:	01 c0                	add    %eax,%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	c1 e0 02             	shl    $0x2,%eax
  801e0e:	05 60 40 80 00       	add    $0x804060,%eax
  801e13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e19:	a1 54 40 80 00       	mov    0x804054,%eax
  801e1e:	40                   	inc    %eax
  801e1f:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e24:	ff 45 f4             	incl   -0xc(%ebp)
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e2d:	0f 8c 2c ff ff ff    	jl     801d5f <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e3a:	eb 36                	jmp    801e72 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3f:	c1 e0 04             	shl    $0x4,%eax
  801e42:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e50:	c1 e0 04             	shl    $0x4,%eax
  801e53:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e61:	c1 e0 04             	shl    $0x4,%eax
  801e64:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e6f:	ff 45 f0             	incl   -0x10(%ebp)
  801e72:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801e76:	7e c4                	jle    801e3c <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801e78:	90                   	nop
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	50                   	push   %eax
  801e88:	e8 0b fe ff ff       	call   801c98 <to_page_info>
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 40 08             	mov    0x8(%eax),%eax
  801e99:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	e8 77 fd ff ff       	call   801c26 <to_page_va>
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801eb5:	b8 00 10 00 00       	mov    $0x1000,%eax
  801eba:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebf:	f7 75 08             	divl   0x8(%ebp)
  801ec2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	50                   	push   %eax
  801ecc:	e8 48 f6 ff ff       	call   801519 <get_page>
  801ed1:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801eef:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801ef6:	eb 19                	jmp    801f11 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	ba 01 00 00 00       	mov    $0x1,%edx
  801f00:	88 c1                	mov    %al,%cl
  801f02:	d3 e2                	shl    %cl,%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f09:	74 0e                	je     801f19 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801f0b:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f0e:	ff 45 f0             	incl   -0x10(%ebp)
  801f11:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f15:	7e e1                	jle    801ef8 <split_page_to_blocks+0x5a>
  801f17:	eb 01                	jmp    801f1a <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801f19:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f21:	e9 a7 00 00 00       	jmp    801fcd <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f29:	0f af 45 08          	imul   0x8(%ebp),%eax
  801f2d:	89 c2                	mov    %eax,%edx
  801f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f32:	01 d0                	add    %edx,%eax
  801f34:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801f37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f3b:	75 14                	jne    801f51 <split_page_to_blocks+0xb3>
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	68 9c 33 80 00       	push   $0x80339c
  801f45:	6a 7c                	push   $0x7c
  801f47:	68 23 33 80 00       	push   $0x803323
  801f4c:	e8 c1 e3 ff ff       	call   800312 <_panic>
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	c1 e0 04             	shl    $0x4,%eax
  801f57:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f5c:	8b 10                	mov    (%eax),%edx
  801f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f61:	89 50 04             	mov    %edx,0x4(%eax)
  801f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f67:	8b 40 04             	mov    0x4(%eax),%eax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	74 14                	je     801f82 <split_page_to_blocks+0xe4>
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	c1 e0 04             	shl    $0x4,%eax
  801f74:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7e:	89 10                	mov    %edx,(%eax)
  801f80:	eb 11                	jmp    801f93 <split_page_to_blocks+0xf5>
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	c1 e0 04             	shl    $0x4,%eax
  801f88:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f91:	89 02                	mov    %eax,(%edx)
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	c1 e0 04             	shl    $0x4,%eax
  801f99:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801f9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa2:	89 02                	mov    %eax,(%edx)
  801fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	c1 e0 04             	shl    $0x4,%eax
  801fb3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fb8:	8b 00                	mov    (%eax),%eax
  801fba:	8d 50 01             	lea    0x1(%eax),%edx
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	c1 e0 04             	shl    $0x4,%eax
  801fc3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fc8:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801fca:	ff 45 ec             	incl   -0x14(%ebp)
  801fcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801fd3:	0f 82 4d ff ff ff    	jb     801f26 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801fd9:	90                   	nop
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801fe2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801fe9:	76 19                	jbe    802004 <alloc_block+0x28>
  801feb:	68 c0 33 80 00       	push   $0x8033c0
  801ff0:	68 86 33 80 00       	push   $0x803386
  801ff5:	68 8a 00 00 00       	push   $0x8a
  801ffa:	68 23 33 80 00       	push   $0x803323
  801fff:	e8 0e e3 ff ff       	call   800312 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80200b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802012:	eb 19                	jmp    80202d <alloc_block+0x51>
		if((1 << i) >= size) break;
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	ba 01 00 00 00       	mov    $0x1,%edx
  80201c:	88 c1                	mov    %al,%cl
  80201e:	d3 e2                	shl    %cl,%edx
  802020:	89 d0                	mov    %edx,%eax
  802022:	3b 45 08             	cmp    0x8(%ebp),%eax
  802025:	73 0e                	jae    802035 <alloc_block+0x59>
		idx++;
  802027:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80202a:	ff 45 f0             	incl   -0x10(%ebp)
  80202d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802031:	7e e1                	jle    802014 <alloc_block+0x38>
  802033:	eb 01                	jmp    802036 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802035:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c1 e0 04             	shl    $0x4,%eax
  80203c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802041:	8b 00                	mov    (%eax),%eax
  802043:	85 c0                	test   %eax,%eax
  802045:	0f 84 df 00 00 00    	je     80212a <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	c1 e0 04             	shl    $0x4,%eax
  802051:	05 80 c0 81 00       	add    $0x81c080,%eax
  802056:	8b 00                	mov    (%eax),%eax
  802058:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80205b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80205f:	75 17                	jne    802078 <alloc_block+0x9c>
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	68 e1 33 80 00       	push   $0x8033e1
  802069:	68 9e 00 00 00       	push   $0x9e
  80206e:	68 23 33 80 00       	push   $0x803323
  802073:	e8 9a e2 ff ff       	call   800312 <_panic>
  802078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	74 10                	je     802091 <alloc_block+0xb5>
  802081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802089:	8b 52 04             	mov    0x4(%edx),%edx
  80208c:	89 50 04             	mov    %edx,0x4(%eax)
  80208f:	eb 14                	jmp    8020a5 <alloc_block+0xc9>
  802091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802094:	8b 40 04             	mov    0x4(%eax),%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8020a3:	89 02                	mov    %eax,(%edx)
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	8b 40 04             	mov    0x4(%eax),%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 0f                	je     8020be <alloc_block+0xe2>
  8020af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b2:	8b 40 04             	mov    0x4(%eax),%eax
  8020b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b8:	8b 12                	mov    (%edx),%edx
  8020ba:	89 10                	mov    %edx,(%eax)
  8020bc:	eb 13                	jmp    8020d1 <alloc_block+0xf5>
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c6:	c1 e2 04             	shl    $0x4,%edx
  8020c9:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8020cf:	89 02                	mov    %eax,(%edx)
  8020d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	c1 e0 04             	shl    $0x4,%eax
  8020ea:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	c1 e0 04             	shl    $0x4,%eax
  8020fa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020ff:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	50                   	push   %eax
  802108:	e8 8b fb ff ff       	call   801c98 <to_page_info>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802116:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80211a:	48                   	dec    %eax
  80211b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80211e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802125:	e9 bc 02 00 00       	jmp    8023e6 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80212a:	a1 54 40 80 00       	mov    0x804054,%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	0f 84 7d 02 00 00    	je     8023b4 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802137:	a1 48 40 80 00       	mov    0x804048,%eax
  80213c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80213f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802143:	75 17                	jne    80215c <alloc_block+0x180>
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	68 e1 33 80 00       	push   $0x8033e1
  80214d:	68 a9 00 00 00       	push   $0xa9
  802152:	68 23 33 80 00       	push   $0x803323
  802157:	e8 b6 e1 ff ff       	call   800312 <_panic>
  80215c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	74 10                	je     802175 <alloc_block+0x199>
  802165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80216d:	8b 52 04             	mov    0x4(%edx),%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 0b                	jmp    802180 <alloc_block+0x1a4>
  802175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802178:	8b 40 04             	mov    0x4(%eax),%eax
  80217b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0f                	je     802199 <alloc_block+0x1bd>
  80218a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218d:	8b 40 04             	mov    0x4(%eax),%eax
  802190:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802193:	8b 12                	mov    (%edx),%edx
  802195:	89 10                	mov    %edx,(%eax)
  802197:	eb 0a                	jmp    8021a3 <alloc_block+0x1c7>
  802199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	a3 48 40 80 00       	mov    %eax,0x804048
  8021a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b6:	a1 54 40 80 00       	mov    0x804054,%eax
  8021bb:	48                   	dec    %eax
  8021bc:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	83 c0 03             	add    $0x3,%eax
  8021c7:	ba 01 00 00 00       	mov    $0x1,%edx
  8021cc:	88 c1                	mov    %al,%cl
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	89 d0                	mov    %edx,%eax
  8021d2:	83 ec 08             	sub    $0x8,%esp
  8021d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021d8:	50                   	push   %eax
  8021d9:	e8 c0 fc ff ff       	call   801e9e <split_page_to_blocks>
  8021de:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	c1 e0 04             	shl    $0x4,%eax
  8021e7:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021f5:	75 17                	jne    80220e <alloc_block+0x232>
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	68 e1 33 80 00       	push   $0x8033e1
  8021ff:	68 b0 00 00 00       	push   $0xb0
  802204:	68 23 33 80 00       	push   $0x803323
  802209:	e8 04 e1 ff ff       	call   800312 <_panic>
  80220e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	74 10                	je     802227 <alloc_block+0x24b>
  802217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80221f:	8b 52 04             	mov    0x4(%edx),%edx
  802222:	89 50 04             	mov    %edx,0x4(%eax)
  802225:	eb 14                	jmp    80223b <alloc_block+0x25f>
  802227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222a:	8b 40 04             	mov    0x4(%eax),%eax
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	c1 e2 04             	shl    $0x4,%edx
  802233:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802239:	89 02                	mov    %eax,(%edx)
  80223b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80223e:	8b 40 04             	mov    0x4(%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 0f                	je     802254 <alloc_block+0x278>
  802245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80224e:	8b 12                	mov    (%edx),%edx
  802250:	89 10                	mov    %edx,(%eax)
  802252:	eb 13                	jmp    802267 <alloc_block+0x28b>
  802254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225c:	c1 e2 04             	shl    $0x4,%edx
  80225f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802265:	89 02                	mov    %eax,(%edx)
  802267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80226a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	c1 e0 04             	shl    $0x4,%eax
  802280:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	8d 50 ff             	lea    -0x1(%eax),%edx
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	c1 e0 04             	shl    $0x4,%eax
  802290:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802295:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802297:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229a:	83 ec 0c             	sub    $0xc,%esp
  80229d:	50                   	push   %eax
  80229e:	e8 f5 f9 ff ff       	call   801c98 <to_page_info>
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8022a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022ac:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022b0:	48                   	dec    %eax
  8022b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022b4:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8022b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022bb:	e9 26 01 00 00       	jmp    8023e6 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8022c0:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c1 e0 04             	shl    $0x4,%eax
  8022c9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022ce:	8b 00                	mov    (%eax),%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	0f 84 dc 00 00 00    	je     8023b4 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	c1 e0 04             	shl    $0x4,%eax
  8022de:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022e3:	8b 00                	mov    (%eax),%eax
  8022e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022ec:	75 17                	jne    802305 <alloc_block+0x329>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 e1 33 80 00       	push   $0x8033e1
  8022f6:	68 be 00 00 00       	push   $0xbe
  8022fb:	68 23 33 80 00       	push   $0x803323
  802300:	e8 0d e0 ff ff       	call   800312 <_panic>
  802305:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 10                	je     80231e <alloc_block+0x342>
  80230e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802316:	8b 52 04             	mov    0x4(%edx),%edx
  802319:	89 50 04             	mov    %edx,0x4(%eax)
  80231c:	eb 14                	jmp    802332 <alloc_block+0x356>
  80231e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802321:	8b 40 04             	mov    0x4(%eax),%eax
  802324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802327:	c1 e2 04             	shl    $0x4,%edx
  80232a:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802330:	89 02                	mov    %eax,(%edx)
  802332:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802335:	8b 40 04             	mov    0x4(%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 0f                	je     80234b <alloc_block+0x36f>
  80233c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802345:	8b 12                	mov    (%edx),%edx
  802347:	89 10                	mov    %edx,(%eax)
  802349:	eb 13                	jmp    80235e <alloc_block+0x382>
  80234b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802353:	c1 e2 04             	shl    $0x4,%edx
  802356:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80235c:	89 02                	mov    %eax,(%edx)
  80235e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802367:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80236a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	c1 e0 04             	shl    $0x4,%eax
  802377:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	c1 e0 04             	shl    $0x4,%eax
  802387:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80238c:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80238e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	50                   	push   %eax
  802395:	e8 fe f8 ff ff       	call   801c98 <to_page_info>
  80239a:	83 c4 10             	add    $0x10,%esp
  80239d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8023a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023a7:	48                   	dec    %eax
  8023a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023ab:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8023af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b2:	eb 32                	jmp    8023e6 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8023b4:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8023b8:	77 15                	ja     8023cf <alloc_block+0x3f3>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	c1 e0 04             	shl    $0x4,%eax
  8023c0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	0f 84 f1 fe ff ff    	je     8022c0 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	68 ff 33 80 00       	push   $0x8033ff
  8023d7:	68 c8 00 00 00       	push   $0xc8
  8023dc:	68 23 33 80 00       	push   $0x803323
  8023e1:	e8 2c df ff ff       	call   800312 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023f6:	39 c2                	cmp    %eax,%edx
  8023f8:	72 0c                	jb     802406 <free_block+0x1e>
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802402:	39 c2                	cmp    %eax,%edx
  802404:	72 19                	jb     80241f <free_block+0x37>
  802406:	68 10 34 80 00       	push   $0x803410
  80240b:	68 86 33 80 00       	push   $0x803386
  802410:	68 d7 00 00 00       	push   $0xd7
  802415:	68 23 33 80 00       	push   $0x803323
  80241a:	e8 f3 de ff ff       	call   800312 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	50                   	push   %eax
  80242c:	e8 67 f8 ff ff       	call   801c98 <to_page_info>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243a:	8b 40 08             	mov    0x8(%eax),%eax
  80243d:	0f b7 c0             	movzwl %ax,%eax
  802440:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80244a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802451:	eb 19                	jmp    80246c <free_block+0x84>
	    if ((1 << i) == blk_size)
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	ba 01 00 00 00       	mov    $0x1,%edx
  80245b:	88 c1                	mov    %al,%cl
  80245d:	d3 e2                	shl    %cl,%edx
  80245f:	89 d0                	mov    %edx,%eax
  802461:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802464:	74 0e                	je     802474 <free_block+0x8c>
	        break;
	    idx++;
  802466:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802469:	ff 45 f0             	incl   -0x10(%ebp)
  80246c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802470:	7e e1                	jle    802453 <free_block+0x6b>
  802472:	eb 01                	jmp    802475 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802474:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802478:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80247c:	40                   	inc    %eax
  80247d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802480:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802484:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802488:	75 17                	jne    8024a1 <free_block+0xb9>
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	68 9c 33 80 00       	push   $0x80339c
  802492:	68 ee 00 00 00       	push   $0xee
  802497:	68 23 33 80 00       	push   $0x803323
  80249c:	e8 71 de ff ff       	call   800312 <_panic>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	c1 e0 04             	shl    $0x4,%eax
  8024a7:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024ac:	8b 10                	mov    (%eax),%edx
  8024ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b1:	89 50 04             	mov    %edx,0x4(%eax)
  8024b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 14                	je     8024d2 <free_block+0xea>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	c1 e0 04             	shl    $0x4,%eax
  8024c4:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ce:	89 10                	mov    %edx,(%eax)
  8024d0:	eb 11                	jmp    8024e3 <free_block+0xfb>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	c1 e0 04             	shl    $0x4,%eax
  8024d8:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8024de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e1:	89 02                	mov    %eax,(%edx)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	c1 e0 04             	shl    $0x4,%eax
  8024e9:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8024ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f2:	89 02                	mov    %eax,(%edx)
  8024f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	c1 e0 04             	shl    $0x4,%eax
  802503:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 50 01             	lea    0x1(%eax),%edx
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c1 e0 04             	shl    $0x4,%eax
  802513:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802518:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80251a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80251f:	ba 00 00 00 00       	mov    $0x0,%edx
  802524:	f7 75 e0             	divl   -0x20(%ebp)
  802527:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80252a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802531:	0f b7 c0             	movzwl %ax,%eax
  802534:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802537:	0f 85 70 01 00 00    	jne    8026ad <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	ff 75 e4             	pushl  -0x1c(%ebp)
  802543:	e8 de f6 ff ff       	call   801c26 <to_page_va>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80254e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802555:	e9 b7 00 00 00       	jmp    802611 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80255a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	01 d0                	add    %edx,%eax
  802562:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802565:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802569:	75 17                	jne    802582 <free_block+0x19a>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 e1 33 80 00       	push   $0x8033e1
  802573:	68 f8 00 00 00       	push   $0xf8
  802578:	68 23 33 80 00       	push   $0x803323
  80257d:	e8 90 dd ff ff       	call   800312 <_panic>
  802582:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 10                	je     80259b <free_block+0x1b3>
  80258b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802593:	8b 52 04             	mov    0x4(%edx),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	eb 14                	jmp    8025af <free_block+0x1c7>
  80259b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a4:	c1 e2 04             	shl    $0x4,%edx
  8025a7:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8025ad:	89 02                	mov    %eax,(%edx)
  8025af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 0f                	je     8025c8 <free_block+0x1e0>
  8025b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025c2:	8b 12                	mov    (%edx),%edx
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	eb 13                	jmp    8025db <free_block+0x1f3>
  8025c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d0:	c1 e2 04             	shl    $0x4,%edx
  8025d3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8025d9:	89 02                	mov    %eax,(%edx)
  8025db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c1 e0 04             	shl    $0x4,%eax
  8025f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c1 e0 04             	shl    $0x4,%eax
  802604:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802609:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80260b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260e:	01 45 ec             	add    %eax,-0x14(%ebp)
  802611:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802618:	0f 86 3c ff ff ff    	jbe    80255a <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802621:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262a:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802630:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802634:	75 17                	jne    80264d <free_block+0x265>
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 9c 33 80 00       	push   $0x80339c
  80263e:	68 fe 00 00 00       	push   $0xfe
  802643:	68 23 33 80 00       	push   $0x803323
  802648:	e8 c5 dc ff ff       	call   800312 <_panic>
  80264d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	89 50 04             	mov    %edx,0x4(%eax)
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	74 0c                	je     80266f <free_block+0x287>
  802663:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802668:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266b:	89 10                	mov    %edx,(%eax)
  80266d:	eb 08                	jmp    802677 <free_block+0x28f>
  80266f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802672:	a3 48 40 80 00       	mov    %eax,0x804048
  802677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802688:	a1 54 40 80 00       	mov    0x804054,%eax
  80268d:	40                   	inc    %eax
  80268e:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802693:	83 ec 0c             	sub    $0xc,%esp
  802696:	ff 75 e4             	pushl  -0x1c(%ebp)
  802699:	e8 88 f5 ff ff       	call   801c26 <to_page_va>
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	50                   	push   %eax
  8026a5:	e8 b8 ee ff ff       	call   801562 <return_page>
  8026aa:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8026ad:	90                   	nop
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8026b6:	83 ec 04             	sub    $0x4,%esp
  8026b9:	68 48 34 80 00       	push   $0x803448
  8026be:	68 11 01 00 00       	push   $0x111
  8026c3:	68 23 33 80 00       	push   $0x803323
  8026c8:	e8 45 dc ff ff       	call   800312 <_panic>
  8026cd:	66 90                	xchg   %ax,%ax
  8026cf:	90                   	nop

008026d0 <__udivdi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 1c             	sub    $0x1c,%esp
  8026d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026e7:	89 ca                	mov    %ecx,%edx
  8026e9:	89 f8                	mov    %edi,%eax
  8026eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026ef:	85 f6                	test   %esi,%esi
  8026f1:	75 2d                	jne    802720 <__udivdi3+0x50>
  8026f3:	39 cf                	cmp    %ecx,%edi
  8026f5:	77 65                	ja     80275c <__udivdi3+0x8c>
  8026f7:	89 fd                	mov    %edi,%ebp
  8026f9:	85 ff                	test   %edi,%edi
  8026fb:	75 0b                	jne    802708 <__udivdi3+0x38>
  8026fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802702:	31 d2                	xor    %edx,%edx
  802704:	f7 f7                	div    %edi
  802706:	89 c5                	mov    %eax,%ebp
  802708:	31 d2                	xor    %edx,%edx
  80270a:	89 c8                	mov    %ecx,%eax
  80270c:	f7 f5                	div    %ebp
  80270e:	89 c1                	mov    %eax,%ecx
  802710:	89 d8                	mov    %ebx,%eax
  802712:	f7 f5                	div    %ebp
  802714:	89 cf                	mov    %ecx,%edi
  802716:	89 fa                	mov    %edi,%edx
  802718:	83 c4 1c             	add    $0x1c,%esp
  80271b:	5b                   	pop    %ebx
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    
  802720:	39 ce                	cmp    %ecx,%esi
  802722:	77 28                	ja     80274c <__udivdi3+0x7c>
  802724:	0f bd fe             	bsr    %esi,%edi
  802727:	83 f7 1f             	xor    $0x1f,%edi
  80272a:	75 40                	jne    80276c <__udivdi3+0x9c>
  80272c:	39 ce                	cmp    %ecx,%esi
  80272e:	72 0a                	jb     80273a <__udivdi3+0x6a>
  802730:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802734:	0f 87 9e 00 00 00    	ja     8027d8 <__udivdi3+0x108>
  80273a:	b8 01 00 00 00       	mov    $0x1,%eax
  80273f:	89 fa                	mov    %edi,%edx
  802741:	83 c4 1c             	add    $0x1c,%esp
  802744:	5b                   	pop    %ebx
  802745:	5e                   	pop    %esi
  802746:	5f                   	pop    %edi
  802747:	5d                   	pop    %ebp
  802748:	c3                   	ret    
  802749:	8d 76 00             	lea    0x0(%esi),%esi
  80274c:	31 ff                	xor    %edi,%edi
  80274e:	31 c0                	xor    %eax,%eax
  802750:	89 fa                	mov    %edi,%edx
  802752:	83 c4 1c             	add    $0x1c,%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	89 d8                	mov    %ebx,%eax
  80275e:	f7 f7                	div    %edi
  802760:	31 ff                	xor    %edi,%edi
  802762:	89 fa                	mov    %edi,%edx
  802764:	83 c4 1c             	add    $0x1c,%esp
  802767:	5b                   	pop    %ebx
  802768:	5e                   	pop    %esi
  802769:	5f                   	pop    %edi
  80276a:	5d                   	pop    %ebp
  80276b:	c3                   	ret    
  80276c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802771:	89 eb                	mov    %ebp,%ebx
  802773:	29 fb                	sub    %edi,%ebx
  802775:	89 f9                	mov    %edi,%ecx
  802777:	d3 e6                	shl    %cl,%esi
  802779:	89 c5                	mov    %eax,%ebp
  80277b:	88 d9                	mov    %bl,%cl
  80277d:	d3 ed                	shr    %cl,%ebp
  80277f:	89 e9                	mov    %ebp,%ecx
  802781:	09 f1                	or     %esi,%ecx
  802783:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802787:	89 f9                	mov    %edi,%ecx
  802789:	d3 e0                	shl    %cl,%eax
  80278b:	89 c5                	mov    %eax,%ebp
  80278d:	89 d6                	mov    %edx,%esi
  80278f:	88 d9                	mov    %bl,%cl
  802791:	d3 ee                	shr    %cl,%esi
  802793:	89 f9                	mov    %edi,%ecx
  802795:	d3 e2                	shl    %cl,%edx
  802797:	8b 44 24 08          	mov    0x8(%esp),%eax
  80279b:	88 d9                	mov    %bl,%cl
  80279d:	d3 e8                	shr    %cl,%eax
  80279f:	09 c2                	or     %eax,%edx
  8027a1:	89 d0                	mov    %edx,%eax
  8027a3:	89 f2                	mov    %esi,%edx
  8027a5:	f7 74 24 0c          	divl   0xc(%esp)
  8027a9:	89 d6                	mov    %edx,%esi
  8027ab:	89 c3                	mov    %eax,%ebx
  8027ad:	f7 e5                	mul    %ebp
  8027af:	39 d6                	cmp    %edx,%esi
  8027b1:	72 19                	jb     8027cc <__udivdi3+0xfc>
  8027b3:	74 0b                	je     8027c0 <__udivdi3+0xf0>
  8027b5:	89 d8                	mov    %ebx,%eax
  8027b7:	31 ff                	xor    %edi,%edi
  8027b9:	e9 58 ff ff ff       	jmp    802716 <__udivdi3+0x46>
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027c4:	89 f9                	mov    %edi,%ecx
  8027c6:	d3 e2                	shl    %cl,%edx
  8027c8:	39 c2                	cmp    %eax,%edx
  8027ca:	73 e9                	jae    8027b5 <__udivdi3+0xe5>
  8027cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027cf:	31 ff                	xor    %edi,%edi
  8027d1:	e9 40 ff ff ff       	jmp    802716 <__udivdi3+0x46>
  8027d6:	66 90                	xchg   %ax,%ax
  8027d8:	31 c0                	xor    %eax,%eax
  8027da:	e9 37 ff ff ff       	jmp    802716 <__udivdi3+0x46>
  8027df:	90                   	nop

008027e0 <__umoddi3>:
  8027e0:	55                   	push   %ebp
  8027e1:	57                   	push   %edi
  8027e2:	56                   	push   %esi
  8027e3:	53                   	push   %ebx
  8027e4:	83 ec 1c             	sub    $0x1c,%esp
  8027e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027ff:	89 f3                	mov    %esi,%ebx
  802801:	89 fa                	mov    %edi,%edx
  802803:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802807:	89 34 24             	mov    %esi,(%esp)
  80280a:	85 c0                	test   %eax,%eax
  80280c:	75 1a                	jne    802828 <__umoddi3+0x48>
  80280e:	39 f7                	cmp    %esi,%edi
  802810:	0f 86 a2 00 00 00    	jbe    8028b8 <__umoddi3+0xd8>
  802816:	89 c8                	mov    %ecx,%eax
  802818:	89 f2                	mov    %esi,%edx
  80281a:	f7 f7                	div    %edi
  80281c:	89 d0                	mov    %edx,%eax
  80281e:	31 d2                	xor    %edx,%edx
  802820:	83 c4 1c             	add    $0x1c,%esp
  802823:	5b                   	pop    %ebx
  802824:	5e                   	pop    %esi
  802825:	5f                   	pop    %edi
  802826:	5d                   	pop    %ebp
  802827:	c3                   	ret    
  802828:	39 f0                	cmp    %esi,%eax
  80282a:	0f 87 ac 00 00 00    	ja     8028dc <__umoddi3+0xfc>
  802830:	0f bd e8             	bsr    %eax,%ebp
  802833:	83 f5 1f             	xor    $0x1f,%ebp
  802836:	0f 84 ac 00 00 00    	je     8028e8 <__umoddi3+0x108>
  80283c:	bf 20 00 00 00       	mov    $0x20,%edi
  802841:	29 ef                	sub    %ebp,%edi
  802843:	89 fe                	mov    %edi,%esi
  802845:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802849:	89 e9                	mov    %ebp,%ecx
  80284b:	d3 e0                	shl    %cl,%eax
  80284d:	89 d7                	mov    %edx,%edi
  80284f:	89 f1                	mov    %esi,%ecx
  802851:	d3 ef                	shr    %cl,%edi
  802853:	09 c7                	or     %eax,%edi
  802855:	89 e9                	mov    %ebp,%ecx
  802857:	d3 e2                	shl    %cl,%edx
  802859:	89 14 24             	mov    %edx,(%esp)
  80285c:	89 d8                	mov    %ebx,%eax
  80285e:	d3 e0                	shl    %cl,%eax
  802860:	89 c2                	mov    %eax,%edx
  802862:	8b 44 24 08          	mov    0x8(%esp),%eax
  802866:	d3 e0                	shl    %cl,%eax
  802868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802870:	89 f1                	mov    %esi,%ecx
  802872:	d3 e8                	shr    %cl,%eax
  802874:	09 d0                	or     %edx,%eax
  802876:	d3 eb                	shr    %cl,%ebx
  802878:	89 da                	mov    %ebx,%edx
  80287a:	f7 f7                	div    %edi
  80287c:	89 d3                	mov    %edx,%ebx
  80287e:	f7 24 24             	mull   (%esp)
  802881:	89 c6                	mov    %eax,%esi
  802883:	89 d1                	mov    %edx,%ecx
  802885:	39 d3                	cmp    %edx,%ebx
  802887:	0f 82 87 00 00 00    	jb     802914 <__umoddi3+0x134>
  80288d:	0f 84 91 00 00 00    	je     802924 <__umoddi3+0x144>
  802893:	8b 54 24 04          	mov    0x4(%esp),%edx
  802897:	29 f2                	sub    %esi,%edx
  802899:	19 cb                	sbb    %ecx,%ebx
  80289b:	89 d8                	mov    %ebx,%eax
  80289d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028a1:	d3 e0                	shl    %cl,%eax
  8028a3:	89 e9                	mov    %ebp,%ecx
  8028a5:	d3 ea                	shr    %cl,%edx
  8028a7:	09 d0                	or     %edx,%eax
  8028a9:	89 e9                	mov    %ebp,%ecx
  8028ab:	d3 eb                	shr    %cl,%ebx
  8028ad:	89 da                	mov    %ebx,%edx
  8028af:	83 c4 1c             	add    $0x1c,%esp
  8028b2:	5b                   	pop    %ebx
  8028b3:	5e                   	pop    %esi
  8028b4:	5f                   	pop    %edi
  8028b5:	5d                   	pop    %ebp
  8028b6:	c3                   	ret    
  8028b7:	90                   	nop
  8028b8:	89 fd                	mov    %edi,%ebp
  8028ba:	85 ff                	test   %edi,%edi
  8028bc:	75 0b                	jne    8028c9 <__umoddi3+0xe9>
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f7                	div    %edi
  8028c7:	89 c5                	mov    %eax,%ebp
  8028c9:	89 f0                	mov    %esi,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	f7 f5                	div    %ebp
  8028cf:	89 c8                	mov    %ecx,%eax
  8028d1:	f7 f5                	div    %ebp
  8028d3:	89 d0                	mov    %edx,%eax
  8028d5:	e9 44 ff ff ff       	jmp    80281e <__umoddi3+0x3e>
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	89 c8                	mov    %ecx,%eax
  8028de:	89 f2                	mov    %esi,%edx
  8028e0:	83 c4 1c             	add    $0x1c,%esp
  8028e3:	5b                   	pop    %ebx
  8028e4:	5e                   	pop    %esi
  8028e5:	5f                   	pop    %edi
  8028e6:	5d                   	pop    %ebp
  8028e7:	c3                   	ret    
  8028e8:	3b 04 24             	cmp    (%esp),%eax
  8028eb:	72 06                	jb     8028f3 <__umoddi3+0x113>
  8028ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028f1:	77 0f                	ja     802902 <__umoddi3+0x122>
  8028f3:	89 f2                	mov    %esi,%edx
  8028f5:	29 f9                	sub    %edi,%ecx
  8028f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028fb:	89 14 24             	mov    %edx,(%esp)
  8028fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802902:	8b 44 24 04          	mov    0x4(%esp),%eax
  802906:	8b 14 24             	mov    (%esp),%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d 76 00             	lea    0x0(%esi),%esi
  802914:	2b 04 24             	sub    (%esp),%eax
  802917:	19 fa                	sbb    %edi,%edx
  802919:	89 d1                	mov    %edx,%ecx
  80291b:	89 c6                	mov    %eax,%esi
  80291d:	e9 71 ff ff ff       	jmp    802893 <__umoddi3+0xb3>
  802922:	66 90                	xchg   %ax,%ax
  802924:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802928:	72 ea                	jb     802914 <__umoddi3+0x134>
  80292a:	89 d9                	mov    %ebx,%ecx
  80292c:	e9 62 ff ff ff       	jmp    802893 <__umoddi3+0xb3>
