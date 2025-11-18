
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 0f 02 00 00       	call   800245 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int eval = 0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	cprintf_colored(TEXT_cyan, "%~PART I: Test the Pointer Validation inside fault_handler(): [70%]\n");
  800045:	83 ec 08             	sub    $0x8,%esp
  800048:	68 a0 1e 80 00       	push   $0x801ea0
  80004d:	6a 03                	push   $0x3
  80004f:	e8 c3 04 00 00       	call   800517 <cprintf_colored>
  800054:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================\n");
  800057:	83 ec 08             	sub    $0x8,%esp
  80005a:	68 e8 1e 80 00       	push   $0x801ee8
  80005f:	6a 03                	push   $0x3
  800061:	e8 b1 04 00 00       	call   800517 <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800069:	e8 27 17 00 00       	call   801795 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800079:	a1 20 30 80 00       	mov    0x803020,%eax
  80007e:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800084:	89 c1                	mov    %eax,%ecx
  800086:	a1 20 30 80 00       	mov    0x803020,%eax
  80008b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800091:	52                   	push   %edx
  800092:	51                   	push   %ecx
  800093:	50                   	push   %eax
  800094:	68 2d 1f 80 00       	push   $0x801f2d
  800099:	e8 ab 15 00 00       	call   801649 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 b8 15 00 00       	call   801667 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c2:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000c8:	89 c1                	mov    %eax,%ecx
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d5:	52                   	push   %edx
  8000d6:	51                   	push   %ecx
  8000d7:	50                   	push   %eax
  8000d8:	68 38 1f 80 00       	push   $0x801f38
  8000dd:	e8 67 15 00 00       	call   801649 <sys_create_env>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 74 15 00 00       	call   801667 <sys_run_env>
  8000f3:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800101:	a1 20 30 80 00       	mov    0x803020,%eax
  800106:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80010c:	89 c1                	mov    %eax,%ecx
  80010e:	a1 20 30 80 00       	mov    0x803020,%eax
  800113:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800119:	52                   	push   %edx
  80011a:	51                   	push   %ecx
  80011b:	50                   	push   %eax
  80011c:	68 43 1f 80 00       	push   $0x801f43
  800121:	e8 23 15 00 00       	call   801649 <sys_create_env>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	ff 75 e8             	pushl  -0x18(%ebp)
  800132:	e8 30 15 00 00       	call   801667 <sys_run_env>
  800137:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 98 3a 00 00       	push   $0x3a98
  800142:	e8 32 18 00 00       	call   801979 <env_sleep>
  800147:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80014a:	e8 c0 16 00 00       	call   80180f <gettst>
  80014f:	85 c0                	test   %eax,%eax
  800151:	74 14                	je     800167 <_main+0x12f>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART I... Failed.\n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 4e 1f 80 00       	push   $0x801f4e
  80015b:	6a 0c                	push   $0xc
  80015d:	e8 b5 03 00 00       	call   800517 <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	eb 16                	jmp    80017d <_main+0x145>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART I... completed successfully\n\n");
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 64 1f 80 00       	push   $0x801f64
  80016f:	6a 02                	push   $0x2
  800171:	e8 a1 03 00 00       	call   800517 <cprintf_colored>
  800176:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800179:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf_colored(TEXT_cyan, "%~PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	68 8c 1f 80 00       	push   $0x801f8c
  800185:	6a 03                	push   $0x3
  800187:	e8 8b 03 00 00       	call   800517 <cprintf_colored>
  80018c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================================================\n");
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	68 f4 1f 80 00       	push   $0x801ff4
  800197:	6a 03                	push   $0x3
  800199:	e8 79 03 00 00       	call   800517 <cprintf_colored>
  80019e:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8001a1:	e8 ef 15 00 00       	call   801795 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8001bc:	89 c1                	mov    %eax,%ecx
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001c9:	52                   	push   %edx
  8001ca:	51                   	push   %ecx
  8001cb:	50                   	push   %eax
  8001cc:	68 59 20 80 00       	push   $0x802059
  8001d1:	e8 73 14 00 00       	call   801649 <sys_create_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	e8 80 14 00 00       	call   801667 <sys_run_env>
  8001e7:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	68 98 3a 00 00       	push   $0x3a98
  8001f2:	e8 82 17 00 00       	call   801979 <env_sleep>
  8001f7:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001fa:	e8 10 16 00 00       	call   80180f <gettst>
  8001ff:	85 c0                	test   %eax,%eax
  800201:	74 14                	je     800217 <_main+0x1df>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART II... Failed.\n");
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	68 64 20 80 00       	push   $0x802064
  80020b:	6a 0c                	push   $0xc
  80020d:	e8 05 03 00 00       	call   800517 <cprintf_colored>
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	eb 16                	jmp    80022d <_main+0x1f5>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART II... completed successfully\n\n");
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	68 7c 20 80 00       	push   $0x80207c
  80021f:	6a 02                	push   $0x2
  800221:	e8 f1 02 00 00       	call   800517 <cprintf_colored>
  800226:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800229:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest invalid access completed. Eval = %d%\n\n", eval);
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	68 a4 20 80 00       	push   $0x8020a4
  800238:	6a 0a                	push   $0xa
  80023a:	e8 d8 02 00 00       	call   800517 <cprintf_colored>
  80023f:	83 c4 10             	add    $0x10,%esp

}
  800242:	90                   	nop
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	57                   	push   %edi
  800249:	56                   	push   %esi
  80024a:	53                   	push   %ebx
  80024b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80024e:	e8 64 14 00 00       	call   8016b7 <sys_getenvindex>
  800253:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800256:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800259:	89 d0                	mov    %edx,%eax
  80025b:	c1 e0 06             	shl    $0x6,%eax
  80025e:	29 d0                	sub    %edx,%eax
  800260:	c1 e0 02             	shl    $0x2,%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80026c:	01 c8                	add    %ecx,%eax
  80026e:	c1 e0 03             	shl    $0x3,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80027a:	29 c2                	sub    %eax,%edx
  80027c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800283:	89 c2                	mov    %eax,%edx
  800285:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80028b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800290:	a1 20 30 80 00       	mov    0x803020,%eax
  800295:	8a 40 20             	mov    0x20(%eax),%al
  800298:	84 c0                	test   %al,%al
  80029a:	74 0d                	je     8002a9 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80029c:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a1:	83 c0 20             	add    $0x20,%eax
  8002a4:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ad:	7e 0a                	jle    8002b9 <libmain+0x74>
		binaryname = argv[0];
  8002af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b2:	8b 00                	mov    (%eax),%eax
  8002b4:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 71 fd ff ff       	call   800038 <_main>
  8002c7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002ca:	a1 00 30 80 00       	mov    0x803000,%eax
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	0f 84 01 01 00 00    	je     8003d8 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002d7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002dd:	bb cc 21 80 00       	mov    $0x8021cc,%ebx
  8002e2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002ef:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002f2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002f7:	b0 00                	mov    $0x0,%al
  8002f9:	89 d7                	mov    %edx,%edi
  8002fb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800304:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	50                   	push   %eax
  80030b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800311:	50                   	push   %eax
  800312:	e8 d6 15 00 00       	call   8018ed <sys_utilities>
  800317:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80031a:	e8 1f 11 00 00       	call   80143e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 ec 20 80 00       	push   $0x8020ec
  800327:	e8 be 01 00 00       	call   8004ea <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80032f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800332:	85 c0                	test   %eax,%eax
  800334:	74 18                	je     80034e <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800336:	e8 d0 15 00 00       	call   80190b <sys_get_optimal_num_faults>
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	68 14 21 80 00       	push   $0x802114
  800344:	e8 a1 01 00 00       	call   8004ea <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	eb 59                	jmp    8003a7 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80034e:	a1 20 30 80 00       	mov    0x803020,%eax
  800353:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800359:	a1 20 30 80 00       	mov    0x803020,%eax
  80035e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	52                   	push   %edx
  800368:	50                   	push   %eax
  800369:	68 38 21 80 00       	push   $0x802138
  80036e:	e8 77 01 00 00       	call   8004ea <cprintf>
  800373:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800376:	a1 20 30 80 00       	mov    0x803020,%eax
  80037b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800381:	a1 20 30 80 00       	mov    0x803020,%eax
  800386:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800397:	51                   	push   %ecx
  800398:	52                   	push   %edx
  800399:	50                   	push   %eax
  80039a:	68 60 21 80 00       	push   $0x802160
  80039f:	e8 46 01 00 00       	call   8004ea <cprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ac:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	50                   	push   %eax
  8003b6:	68 b8 21 80 00       	push   $0x8021b8
  8003bb:	e8 2a 01 00 00       	call   8004ea <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003c3:	83 ec 0c             	sub    $0xc,%esp
  8003c6:	68 ec 20 80 00       	push   $0x8020ec
  8003cb:	e8 1a 01 00 00       	call   8004ea <cprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003d3:	e8 80 10 00 00       	call   801458 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003d8:	e8 1f 00 00 00       	call   8003fc <exit>
}
  8003dd:	90                   	nop
  8003de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	6a 00                	push   $0x0
  8003f1:	e8 8d 12 00 00       	call   801683 <sys_destroy_env>
  8003f6:	83 c4 10             	add    $0x10,%esp
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <exit>:

void
exit(void)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800402:	e8 e2 12 00 00       	call   8016e9 <sys_exit_env>
}
  800407:	90                   	nop
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	53                   	push   %ebx
  80040e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800411:	8b 45 0c             	mov    0xc(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	8d 48 01             	lea    0x1(%eax),%ecx
  800419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041c:	89 0a                	mov    %ecx,(%edx)
  80041e:	8b 55 08             	mov    0x8(%ebp),%edx
  800421:	88 d1                	mov    %dl,%cl
  800423:	8b 55 0c             	mov    0xc(%ebp),%edx
  800426:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800434:	75 30                	jne    800466 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800436:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80043c:	a0 44 30 80 00       	mov    0x803044,%al
  800441:	0f b6 c0             	movzbl %al,%eax
  800444:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800447:	8b 09                	mov    (%ecx),%ecx
  800449:	89 cb                	mov    %ecx,%ebx
  80044b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044e:	83 c1 08             	add    $0x8,%ecx
  800451:	52                   	push   %edx
  800452:	50                   	push   %eax
  800453:	53                   	push   %ebx
  800454:	51                   	push   %ecx
  800455:	e8 a0 0f 00 00       	call   8013fa <sys_cputs>
  80045a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800466:	8b 45 0c             	mov    0xc(%ebp),%eax
  800469:	8b 40 04             	mov    0x4(%eax),%eax
  80046c:	8d 50 01             	lea    0x1(%eax),%edx
  80046f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800472:	89 50 04             	mov    %edx,0x4(%eax)
}
  800475:	90                   	nop
  800476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800479:	c9                   	leave  
  80047a:	c3                   	ret    

0080047b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800484:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80048b:	00 00 00 
	b.cnt = 0;
  80048e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800495:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a4:	50                   	push   %eax
  8004a5:	68 0a 04 80 00       	push   $0x80040a
  8004aa:	e8 5a 02 00 00       	call   800709 <vprintfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004b2:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004b8:	a0 44 30 80 00       	mov    0x803044,%al
  8004bd:	0f b6 c0             	movzbl %al,%eax
  8004c0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004c6:	52                   	push   %edx
  8004c7:	50                   	push   %eax
  8004c8:	51                   	push   %ecx
  8004c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cf:	83 c0 08             	add    $0x8,%eax
  8004d2:	50                   	push   %eax
  8004d3:	e8 22 0f 00 00       	call   8013fa <sys_cputs>
  8004d8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004db:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	50                   	push   %eax
  800507:	e8 6f ff ff ff       	call   80047b <vcprintf>
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800512:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80051d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	c1 e0 08             	shl    $0x8,%eax
  80052a:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80052f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800532:	83 c0 04             	add    $0x4,%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 34 ff ff ff       	call   80047b <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80054d:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800554:	07 00 00 

	return cnt;
  800557:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055a:	c9                   	leave  
  80055b:	c3                   	ret    

0080055c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800562:	e8 d7 0e 00 00       	call   80143e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800567:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 f4             	pushl  -0xc(%ebp)
  800576:	50                   	push   %eax
  800577:	e8 ff fe ff ff       	call   80047b <vcprintf>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800582:	e8 d1 0e 00 00       	call   801458 <sys_unlock_cons>
	return cnt;
  800587:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	53                   	push   %ebx
  800590:	83 ec 14             	sub    $0x14,%esp
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059f:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005aa:	77 55                	ja     800601 <printnum+0x75>
  8005ac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005af:	72 05                	jb     8005b6 <printnum+0x2a>
  8005b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b4:	77 4b                	ja     800601 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c4:	52                   	push   %edx
  8005c5:	50                   	push   %eax
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005cc:	e8 57 16 00 00       	call   801c28 <__udivdi3>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	83 ec 04             	sub    $0x4,%esp
  8005d7:	ff 75 20             	pushl  0x20(%ebp)
  8005da:	53                   	push   %ebx
  8005db:	ff 75 18             	pushl  0x18(%ebp)
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	ff 75 08             	pushl  0x8(%ebp)
  8005e6:	e8 a1 ff ff ff       	call   80058c <printnum>
  8005eb:	83 c4 20             	add    $0x20,%esp
  8005ee:	eb 1a                	jmp    80060a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 20             	pushl  0x20(%ebp)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	ff d0                	call   *%eax
  8005fe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800601:	ff 4d 1c             	decl   0x1c(%ebp)
  800604:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800608:	7f e6                	jg     8005f0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800618:	53                   	push   %ebx
  800619:	51                   	push   %ecx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	e8 17 17 00 00       	call   801d38 <__umoddi3>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	05 54 24 80 00       	add    $0x802454,%eax
  800629:	8a 00                	mov    (%eax),%al
  80062b:	0f be c0             	movsbl %al,%eax
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	50                   	push   %eax
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	ff d0                	call   *%eax
  80063a:	83 c4 10             	add    $0x10,%esp
}
  80063d:	90                   	nop
  80063e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800641:	c9                   	leave  
  800642:	c3                   	ret    

00800643 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800646:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064a:	7e 1c                	jle    800668 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	8d 50 08             	lea    0x8(%eax),%edx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	89 10                	mov    %edx,(%eax)
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	83 e8 08             	sub    $0x8,%eax
  800661:	8b 50 04             	mov    0x4(%eax),%edx
  800664:	8b 00                	mov    (%eax),%eax
  800666:	eb 40                	jmp    8006a8 <getuint+0x65>
	else if (lflag)
  800668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066c:	74 1e                	je     80068c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	89 10                	mov    %edx,(%eax)
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	83 e8 04             	sub    $0x4,%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	eb 1c                	jmp    8006a8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	8d 50 04             	lea    0x4(%eax),%edx
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	89 10                	mov    %edx,(%eax)
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	83 e8 04             	sub    $0x4,%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a8:	5d                   	pop    %ebp
  8006a9:	c3                   	ret    

008006aa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b1:	7e 1c                	jle    8006cf <getint+0x25>
		return va_arg(*ap, long long);
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	8d 50 08             	lea    0x8(%eax),%edx
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	89 10                	mov    %edx,(%eax)
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	83 e8 08             	sub    $0x8,%eax
  8006c8:	8b 50 04             	mov    0x4(%eax),%edx
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	eb 38                	jmp    800707 <getint+0x5d>
	else if (lflag)
  8006cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d3:	74 1a                	je     8006ef <getint+0x45>
		return va_arg(*ap, long);
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	89 10                	mov    %edx,(%eax)
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	99                   	cltd   
  8006ed:	eb 18                	jmp    800707 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	8d 50 04             	lea    0x4(%eax),%edx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	89 10                	mov    %edx,(%eax)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	99                   	cltd   
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	56                   	push   %esi
  80070d:	53                   	push   %ebx
  80070e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800711:	eb 17                	jmp    80072a <vprintfmt+0x21>
			if (ch == '\0')
  800713:	85 db                	test   %ebx,%ebx
  800715:	0f 84 c1 03 00 00    	je     800adc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	53                   	push   %ebx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072a:	8b 45 10             	mov    0x10(%ebp),%eax
  80072d:	8d 50 01             	lea    0x1(%eax),%edx
  800730:	89 55 10             	mov    %edx,0x10(%ebp)
  800733:	8a 00                	mov    (%eax),%al
  800735:	0f b6 d8             	movzbl %al,%ebx
  800738:	83 fb 25             	cmp    $0x25,%ebx
  80073b:	75 d6                	jne    800713 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800741:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800748:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800756:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075d:	8b 45 10             	mov    0x10(%ebp),%eax
  800760:	8d 50 01             	lea    0x1(%eax),%edx
  800763:	89 55 10             	mov    %edx,0x10(%ebp)
  800766:	8a 00                	mov    (%eax),%al
  800768:	0f b6 d8             	movzbl %al,%ebx
  80076b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076e:	83 f8 5b             	cmp    $0x5b,%eax
  800771:	0f 87 3d 03 00 00    	ja     800ab4 <vprintfmt+0x3ab>
  800777:	8b 04 85 78 24 80 00 	mov    0x802478(,%eax,4),%eax
  80077e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800780:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800784:	eb d7                	jmp    80075d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800786:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078a:	eb d1                	jmp    80075d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800793:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800796:	89 d0                	mov    %edx,%eax
  800798:	c1 e0 02             	shl    $0x2,%eax
  80079b:	01 d0                	add    %edx,%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	01 d8                	add    %ebx,%eax
  8007a1:	83 e8 30             	sub    $0x30,%eax
  8007a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007af:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b2:	7e 3e                	jle    8007f2 <vprintfmt+0xe9>
  8007b4:	83 fb 39             	cmp    $0x39,%ebx
  8007b7:	7f 39                	jg     8007f2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007bc:	eb d5                	jmp    800793 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	83 c0 04             	add    $0x4,%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	83 e8 04             	sub    $0x4,%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d2:	eb 1f                	jmp    8007f3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d8:	79 83                	jns    80075d <vprintfmt+0x54>
				width = 0;
  8007da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e1:	e9 77 ff ff ff       	jmp    80075d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007ed:	e9 6b ff ff ff       	jmp    80075d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f7:	0f 89 60 ff ff ff    	jns    80075d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800803:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080a:	e9 4e ff ff ff       	jmp    80075d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800812:	e9 46 ff ff ff       	jmp    80075d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	83 c0 04             	add    $0x4,%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	50                   	push   %eax
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
			break;
  800837:	e9 9b 02 00 00       	jmp    800ad7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	83 c0 04             	add    $0x4,%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	83 e8 04             	sub    $0x4,%eax
  80084b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084d:	85 db                	test   %ebx,%ebx
  80084f:	79 02                	jns    800853 <vprintfmt+0x14a>
				err = -err;
  800851:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800853:	83 fb 64             	cmp    $0x64,%ebx
  800856:	7f 0b                	jg     800863 <vprintfmt+0x15a>
  800858:	8b 34 9d c0 22 80 00 	mov    0x8022c0(,%ebx,4),%esi
  80085f:	85 f6                	test   %esi,%esi
  800861:	75 19                	jne    80087c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800863:	53                   	push   %ebx
  800864:	68 65 24 80 00       	push   $0x802465
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	ff 75 08             	pushl  0x8(%ebp)
  80086f:	e8 70 02 00 00       	call   800ae4 <printfmt>
  800874:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800877:	e9 5b 02 00 00       	jmp    800ad7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087c:	56                   	push   %esi
  80087d:	68 6e 24 80 00       	push   $0x80246e
  800882:	ff 75 0c             	pushl  0xc(%ebp)
  800885:	ff 75 08             	pushl  0x8(%ebp)
  800888:	e8 57 02 00 00       	call   800ae4 <printfmt>
  80088d:	83 c4 10             	add    $0x10,%esp
			break;
  800890:	e9 42 02 00 00       	jmp    800ad7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	83 c0 04             	add    $0x4,%eax
  80089b:	89 45 14             	mov    %eax,0x14(%ebp)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	83 e8 04             	sub    $0x4,%eax
  8008a4:	8b 30                	mov    (%eax),%esi
  8008a6:	85 f6                	test   %esi,%esi
  8008a8:	75 05                	jne    8008af <vprintfmt+0x1a6>
				p = "(null)";
  8008aa:	be 71 24 80 00       	mov    $0x802471,%esi
			if (width > 0 && padc != '-')
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	7e 6d                	jle    800922 <vprintfmt+0x219>
  8008b5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b9:	74 67                	je     800922 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	50                   	push   %eax
  8008c2:	56                   	push   %esi
  8008c3:	e8 1e 03 00 00       	call   800be6 <strnlen>
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ce:	eb 16                	jmp    8008e6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
  8008e0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7f e4                	jg     8008d0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ec:	eb 34                	jmp    800922 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f2:	74 1c                	je     800910 <vprintfmt+0x207>
  8008f4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f7:	7e 05                	jle    8008fe <vprintfmt+0x1f5>
  8008f9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fc:	7e 12                	jle    800910 <vprintfmt+0x207>
					putch('?', putdat);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	6a 3f                	push   $0x3f
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	ff d0                	call   *%eax
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	eb 0f                	jmp    80091f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	53                   	push   %ebx
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091f:	ff 4d e4             	decl   -0x1c(%ebp)
  800922:	89 f0                	mov    %esi,%eax
  800924:	8d 70 01             	lea    0x1(%eax),%esi
  800927:	8a 00                	mov    (%eax),%al
  800929:	0f be d8             	movsbl %al,%ebx
  80092c:	85 db                	test   %ebx,%ebx
  80092e:	74 24                	je     800954 <vprintfmt+0x24b>
  800930:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800934:	78 b8                	js     8008ee <vprintfmt+0x1e5>
  800936:	ff 4d e0             	decl   -0x20(%ebp)
  800939:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093d:	79 af                	jns    8008ee <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093f:	eb 13                	jmp    800954 <vprintfmt+0x24b>
				putch(' ', putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	6a 20                	push   $0x20
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e7                	jg     800941 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095a:	e9 78 01 00 00       	jmp    800ad7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	ff 75 e8             	pushl  -0x18(%ebp)
  800965:	8d 45 14             	lea    0x14(%ebp),%eax
  800968:	50                   	push   %eax
  800969:	e8 3c fd ff ff       	call   8006aa <getint>
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800974:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097d:	85 d2                	test   %edx,%edx
  80097f:	79 23                	jns    8009a4 <vprintfmt+0x29b>
				putch('-', putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	6a 2d                	push   $0x2d
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	ff d0                	call   *%eax
  80098e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800997:	f7 d8                	neg    %eax
  800999:	83 d2 00             	adc    $0x0,%edx
  80099c:	f7 da                	neg    %edx
  80099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ab:	e9 bc 00 00 00       	jmp    800a6c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	e8 84 fc ff ff       	call   800643 <getuint>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cf:	e9 98 00 00 00       	jmp    800a6c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
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
			break;
  800a04:	e9 ce 00 00 00       	jmp    800ad7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 30                	push   $0x30
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 78                	push   $0x78
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a44:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4b:	eb 1f                	jmp    800a6c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 e8             	pushl  -0x18(%ebp)
  800a53:	8d 45 14             	lea    0x14(%ebp),%eax
  800a56:	50                   	push   %eax
  800a57:	e8 e7 fb ff ff       	call   800643 <getuint>
  800a5c:	83 c4 10             	add    $0x10,%esp
  800a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a65:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a73:	83 ec 04             	sub    $0x4,%esp
  800a76:	52                   	push   %edx
  800a77:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7a:	50                   	push   %eax
  800a7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	ff 75 08             	pushl  0x8(%ebp)
  800a87:	e8 00 fb ff ff       	call   80058c <printnum>
  800a8c:	83 c4 20             	add    $0x20,%esp
			break;
  800a8f:	eb 46                	jmp    800ad7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			break;
  800aa0:	eb 35                	jmp    800ad7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aa9:	eb 2c                	jmp    800ad7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aab:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ab2:	eb 23                	jmp    800ad7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 25                	push   $0x25
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac4:	ff 4d 10             	decl   0x10(%ebp)
  800ac7:	eb 03                	jmp    800acc <vprintfmt+0x3c3>
  800ac9:	ff 4d 10             	decl   0x10(%ebp)
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	48                   	dec    %eax
  800ad0:	8a 00                	mov    (%eax),%al
  800ad2:	3c 25                	cmp    $0x25,%al
  800ad4:	75 f3                	jne    800ac9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad6:	90                   	nop
		}
	}
  800ad7:	e9 35 fc ff ff       	jmp    800711 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800add:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aea:	8d 45 10             	lea    0x10(%ebp),%eax
  800aed:	83 c0 04             	add    $0x4,%eax
  800af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af3:	8b 45 10             	mov    0x10(%ebp),%eax
  800af6:	ff 75 f4             	pushl  -0xc(%ebp)
  800af9:	50                   	push   %eax
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	ff 75 08             	pushl  0x8(%ebp)
  800b00:	e8 04 fc ff ff       	call   800709 <vprintfmt>
  800b05:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b08:	90                   	nop
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 08             	mov    0x8(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	8b 10                	mov    (%eax),%edx
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 04             	mov    0x4(%eax),%eax
  800b28:	39 c2                	cmp    %eax,%edx
  800b2a:	73 12                	jae    800b3e <sprintputch+0x33>
		*b->buf++ = ch;
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	8d 48 01             	lea    0x1(%eax),%ecx
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 0a                	mov    %ecx,(%edx)
  800b39:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3c:	88 10                	mov    %dl,(%eax)
}
  800b3e:	90                   	nop
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	01 d0                	add    %edx,%eax
  800b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b66:	74 06                	je     800b6e <vsnprintf+0x2d>
  800b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6c:	7f 07                	jg     800b75 <vsnprintf+0x34>
		return -E_INVAL;
  800b6e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b73:	eb 20                	jmp    800b95 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b75:	ff 75 14             	pushl  0x14(%ebp)
  800b78:	ff 75 10             	pushl  0x10(%ebp)
  800b7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 0b 0b 80 00       	push   $0x800b0b
  800b84:	e8 80 fb ff ff       	call   800709 <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9d:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba0:	83 c0 04             	add    $0x4,%eax
  800ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bac:	50                   	push   %eax
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	ff 75 08             	pushl  0x8(%ebp)
  800bb3:	e8 89 ff ff ff       	call   800b41 <vsnprintf>
  800bb8:	83 c4 10             	add    $0x10,%esp
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd0:	eb 06                	jmp    800bd8 <strlen+0x15>
		n++;
  800bd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd5:	ff 45 08             	incl   0x8(%ebp)
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	84 c0                	test   %al,%al
  800bdf:	75 f1                	jne    800bd2 <strlen+0xf>
		n++;
	return n;
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf3:	eb 09                	jmp    800bfe <strnlen+0x18>
		n++;
  800bf5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf8:	ff 45 08             	incl   0x8(%ebp)
  800bfb:	ff 4d 0c             	decl   0xc(%ebp)
  800bfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c02:	74 09                	je     800c0d <strnlen+0x27>
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	84 c0                	test   %al,%al
  800c0b:	75 e8                	jne    800bf5 <strnlen+0xf>
		n++;
	return n;
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1e:	90                   	nop
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8d 50 01             	lea    0x1(%eax),%edx
  800c25:	89 55 08             	mov    %edx,0x8(%ebp)
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c31:	8a 12                	mov    (%edx),%dl
  800c33:	88 10                	mov    %dl,(%eax)
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	75 e4                	jne    800c1f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c53:	eb 1f                	jmp    800c74 <strncpy+0x34>
		*dst++ = *src;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8d 50 01             	lea    0x1(%eax),%edx
  800c5b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	84 c0                	test   %al,%al
  800c6c:	74 03                	je     800c71 <strncpy+0x31>
			src++;
  800c6e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c71:	ff 45 fc             	incl   -0x4(%ebp)
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c77:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7a:	72 d9                	jb     800c55 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c91:	74 30                	je     800cc3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c93:	eb 16                	jmp    800cab <strlcpy+0x2a>
			*dst++ = *src++;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8d 50 01             	lea    0x1(%eax),%edx
  800c9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca7:	8a 12                	mov    (%edx),%dl
  800ca9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cab:	ff 4d 10             	decl   0x10(%ebp)
  800cae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb2:	74 09                	je     800cbd <strlcpy+0x3c>
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	75 d8                	jne    800c95 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc9:	29 c2                	sub    %eax,%edx
  800ccb:	89 d0                	mov    %edx,%eax
}
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd2:	eb 06                	jmp    800cda <strcmp+0xb>
		p++, q++;
  800cd4:	ff 45 08             	incl   0x8(%ebp)
  800cd7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0e                	je     800cf1 <strcmp+0x22>
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 10                	mov    (%eax),%dl
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	38 c2                	cmp    %al,%dl
  800cef:	74 e3                	je     800cd4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	0f b6 d0             	movzbl %al,%edx
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 c0             	movzbl %al,%eax
  800d01:	29 c2                	sub    %eax,%edx
  800d03:	89 d0                	mov    %edx,%eax
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0a:	eb 09                	jmp    800d15 <strncmp+0xe>
		n--, p++, q++;
  800d0c:	ff 4d 10             	decl   0x10(%ebp)
  800d0f:	ff 45 08             	incl   0x8(%ebp)
  800d12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 17                	je     800d32 <strncmp+0x2b>
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strncmp+0x2b>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 da                	je     800d0c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d36:	75 07                	jne    800d3f <strncmp+0x38>
		return 0;
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	eb 14                	jmp    800d53 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f b6 d0             	movzbl %al,%edx
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f b6 c0             	movzbl %al,%eax
  800d4f:	29 c2                	sub    %eax,%edx
  800d51:	89 d0                	mov    %edx,%eax
}
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 04             	sub    $0x4,%esp
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d61:	eb 12                	jmp    800d75 <strchr+0x20>
		if (*s == c)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6b:	75 05                	jne    800d72 <strchr+0x1d>
			return (char *) s;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	eb 11                	jmp    800d83 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	75 e5                	jne    800d63 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d83:	c9                   	leave  
  800d84:	c3                   	ret    

00800d85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 0d                	jmp    800da0 <strfind+0x1b>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	74 0e                	je     800dab <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9d:	ff 45 08             	incl   0x8(%ebp)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	75 ea                	jne    800d93 <strfind+0xe>
  800da9:	eb 01                	jmp    800dac <strfind+0x27>
		if (*s == c)
			break;
  800dab:	90                   	nop
	return (char *) s;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dbd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dc1:	76 63                	jbe    800e26 <memset+0x75>
		uint64 data_block = c;
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	99                   	cltd   
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dca:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dd7:	c1 e0 08             	shl    $0x8,%eax
  800dda:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ddd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dea:	c1 e0 10             	shl    $0x10,%eax
  800ded:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df9:	89 c2                	mov    %eax,%edx
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e03:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e06:	eb 18                	jmp    800e20 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e08:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e0b:	8d 41 08             	lea    0x8(%ecx),%eax
  800e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e17:	89 01                	mov    %eax,(%ecx)
  800e19:	89 51 04             	mov    %edx,0x4(%ecx)
  800e1c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e24:	77 e2                	ja     800e08 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	74 23                	je     800e4f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e32:	eb 0e                	jmp    800e42 <memset+0x91>
			*p8++ = (uint8)c;
  800e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e37:	8d 50 01             	lea    0x1(%eax),%edx
  800e3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e40:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e48:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	75 e5                	jne    800e34 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e66:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6a:	76 24                	jbe    800e90 <memcpy+0x3c>
		while(n >= 8){
  800e6c:	eb 1c                	jmp    800e8a <memcpy+0x36>
			*d64 = *s64;
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e71:	8b 50 04             	mov    0x4(%eax),%edx
  800e74:	8b 00                	mov    (%eax),%eax
  800e76:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e79:	89 01                	mov    %eax,(%ecx)
  800e7b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e7e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e82:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e86:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e8a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8e:	77 de                	ja     800e6e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e94:	74 31                	je     800ec7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ea2:	eb 16                	jmp    800eba <memcpy+0x66>
			*d8++ = *s8++;
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea7:	8d 50 01             	lea    0x1(%eax),%edx
  800eaa:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	75 dd                	jne    800ea4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee4:	73 50                	jae    800f36 <memmove+0x6a>
  800ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef1:	76 43                	jbe    800f36 <memmove+0x6a>
		s += n;
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eff:	eb 10                	jmp    800f11 <memmove+0x45>
			*--d = *--s;
  800f01:	ff 4d f8             	decl   -0x8(%ebp)
  800f04:	ff 4d fc             	decl   -0x4(%ebp)
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8a 10                	mov    (%eax),%dl
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f11:	8b 45 10             	mov    0x10(%ebp),%eax
  800f14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f17:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	75 e3                	jne    800f01 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1e:	eb 23                	jmp    800f43 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f32:	8a 12                	mov    (%edx),%dl
  800f34:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f36:	8b 45 10             	mov    0x10(%ebp),%eax
  800f39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	75 dd                	jne    800f20 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f5a:	eb 2a                	jmp    800f86 <memcmp+0x3e>
		if (*s1 != *s2)
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	8a 10                	mov    (%eax),%dl
  800f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	38 c2                	cmp    %al,%dl
  800f68:	74 16                	je     800f80 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d0             	movzbl %al,%edx
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f b6 c0             	movzbl %al,%eax
  800f7a:	29 c2                	sub    %eax,%edx
  800f7c:	89 d0                	mov    %edx,%eax
  800f7e:	eb 18                	jmp    800f98 <memcmp+0x50>
		s1++, s2++;
  800f80:	ff 45 fc             	incl   -0x4(%ebp)
  800f83:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 c9                	jne    800f5c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 d0                	add    %edx,%eax
  800fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fab:	eb 15                	jmp    800fc2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 d0             	movzbl %al,%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	0f b6 c0             	movzbl %al,%eax
  800fbb:	39 c2                	cmp    %eax,%edx
  800fbd:	74 0d                	je     800fcc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc8:	72 e3                	jb     800fad <memfind+0x13>
  800fca:	eb 01                	jmp    800fcd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fcc:	90                   	nop
	return (void *) s;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fdf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe6:	eb 03                	jmp    800feb <strtol+0x19>
		s++;
  800fe8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 20                	cmp    $0x20,%al
  800ff2:	74 f4                	je     800fe8 <strtol+0x16>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 09                	cmp    $0x9,%al
  800ffb:	74 eb                	je     800fe8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 2b                	cmp    $0x2b,%al
  801004:	75 05                	jne    80100b <strtol+0x39>
		s++;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	eb 13                	jmp    80101e <strtol+0x4c>
	else if (*s == '-')
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 2d                	cmp    $0x2d,%al
  801012:	75 0a                	jne    80101e <strtol+0x4c>
		s++, neg = 1;
  801014:	ff 45 08             	incl   0x8(%ebp)
  801017:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801022:	74 06                	je     80102a <strtol+0x58>
  801024:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801028:	75 20                	jne    80104a <strtol+0x78>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	3c 30                	cmp    $0x30,%al
  801031:	75 17                	jne    80104a <strtol+0x78>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	40                   	inc    %eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	3c 78                	cmp    $0x78,%al
  80103b:	75 0d                	jne    80104a <strtol+0x78>
		s += 2, base = 16;
  80103d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801041:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801048:	eb 28                	jmp    801072 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80104a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104e:	75 15                	jne    801065 <strtol+0x93>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 30                	cmp    $0x30,%al
  801057:	75 0c                	jne    801065 <strtol+0x93>
		s++, base = 8;
  801059:	ff 45 08             	incl   0x8(%ebp)
  80105c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801063:	eb 0d                	jmp    801072 <strtol+0xa0>
	else if (base == 0)
  801065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801069:	75 07                	jne    801072 <strtol+0xa0>
		base = 10;
  80106b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	3c 2f                	cmp    $0x2f,%al
  801079:	7e 19                	jle    801094 <strtol+0xc2>
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	3c 39                	cmp    $0x39,%al
  801082:	7f 10                	jg     801094 <strtol+0xc2>
			dig = *s - '0';
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f be c0             	movsbl %al,%eax
  80108c:	83 e8 30             	sub    $0x30,%eax
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801092:	eb 42                	jmp    8010d6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 60                	cmp    $0x60,%al
  80109b:	7e 19                	jle    8010b6 <strtol+0xe4>
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 7a                	cmp    $0x7a,%al
  8010a4:	7f 10                	jg     8010b6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	0f be c0             	movsbl %al,%eax
  8010ae:	83 e8 57             	sub    $0x57,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b4:	eb 20                	jmp    8010d6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 40                	cmp    $0x40,%al
  8010bd:	7e 39                	jle    8010f8 <strtol+0x126>
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	3c 5a                	cmp    $0x5a,%al
  8010c6:	7f 30                	jg     8010f8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f be c0             	movsbl %al,%eax
  8010d0:	83 e8 37             	sub    $0x37,%eax
  8010d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010dc:	7d 19                	jge    8010f7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010de:	ff 45 08             	incl   0x8(%ebp)
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ed:	01 d0                	add    %edx,%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f2:	e9 7b ff ff ff       	jmp    801072 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fc:	74 08                	je     801106 <strtol+0x134>
		*endptr = (char *) s;
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801106:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110a:	74 07                	je     801113 <strtol+0x141>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	f7 d8                	neg    %eax
  801111:	eb 03                	jmp    801116 <strtol+0x144>
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <ltostr>:

void
ltostr(long value, char *str)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80111e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801125:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80112c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801130:	79 13                	jns    801145 <ltostr+0x2d>
	{
		neg = 1;
  801132:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80113f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801142:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80114d:	99                   	cltd   
  80114e:	f7 f9                	idiv   %ecx
  801150:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801156:	8d 50 01             	lea    0x1(%eax),%edx
  801159:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801166:	83 c2 30             	add    $0x30,%edx
  801169:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80116b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801173:	f7 e9                	imul   %ecx
  801175:	c1 fa 02             	sar    $0x2,%edx
  801178:	89 c8                	mov    %ecx,%eax
  80117a:	c1 f8 1f             	sar    $0x1f,%eax
  80117d:	29 c2                	sub    %eax,%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801188:	75 bb                	jne    801145 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	48                   	dec    %eax
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 3d                	je     8011db <ltostr+0xc3>
		start = 1 ;
  80119e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a5:	eb 34                	jmp    8011db <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c2                	add    %eax,%edx
  8011d0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d3:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e1:	7c c4                	jl     8011a7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 d0                	add    %edx,%eax
  8011eb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 c4 f9 ff ff       	call   800bc3 <strlen>
  8011ff:	83 c4 04             	add    $0x4,%esp
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	e8 b6 f9 ff ff       	call   800bc3 <strlen>
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801221:	eb 17                	jmp    80123a <strcconcat+0x49>
		final[s] = str1[s] ;
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	01 c8                	add    %ecx,%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801237:	ff 45 fc             	incl   -0x4(%ebp)
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801240:	7c e1                	jl     801223 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801242:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801249:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801250:	eb 1f                	jmp    801271 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	8d 50 01             	lea    0x1(%eax),%edx
  801258:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126e:	ff 45 f8             	incl   -0x8(%ebp)
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801277:	7c d9                	jl     801252 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	c6 00 00             	movb   $0x0,(%eax)
}
  801284:	90                   	nop
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012aa:	eb 0c                	jmp    8012b8 <strsplit+0x31>
			*string++ = 0;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8d 50 01             	lea    0x1(%eax),%edx
  8012b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 18                	je     8012d9 <strsplit+0x52>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	e8 83 fa ff ff       	call   800d55 <strchr>
  8012d2:	83 c4 08             	add    $0x8,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 d3                	jne    8012ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 5a                	je     80133c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	83 f8 0f             	cmp    $0xf,%eax
  8012ea:	75 07                	jne    8012f3 <strsplit+0x6c>
		{
			return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 66                	jmp    801359 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f6:	8b 00                	mov    (%eax),%eax
  8012f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8012fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fe:	89 0a                	mov    %ecx,(%edx)
  801300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801311:	eb 03                	jmp    801316 <strsplit+0x8f>
			string++;
  801313:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	74 8b                	je     8012aa <strsplit+0x23>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be c0             	movsbl %al,%eax
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 25 fa ff ff       	call   800d55 <strchr>
  801330:	83 c4 08             	add    $0x8,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	74 dc                	je     801313 <strsplit+0x8c>
			string++;
	}
  801337:	e9 6e ff ff ff       	jmp    8012aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80133c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801354:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136e:	eb 4a                	jmp    8013ba <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801370:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	01 c2                	add    %eax,%edx
  801378:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	01 c8                	add    %ecx,%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801384:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	01 d0                	add    %edx,%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	3c 40                	cmp    $0x40,%al
  801390:	7e 25                	jle    8013b7 <str2lower+0x5c>
  801392:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	3c 5a                	cmp    $0x5a,%al
  80139e:	7f 17                	jg     8013b7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	01 d0                	add    %edx,%eax
  8013a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ae:	01 ca                	add    %ecx,%edx
  8013b0:	8a 12                	mov    (%edx),%dl
  8013b2:	83 c2 20             	add    $0x20,%edx
  8013b5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013b7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ba:	ff 75 0c             	pushl  0xc(%ebp)
  8013bd:	e8 01 f8 ff ff       	call   800bc3 <strlen>
  8013c2:	83 c4 04             	add    $0x4,%esp
  8013c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013c8:	7f a6                	jg     801370 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	57                   	push   %edi
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013e4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013e7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013ea:	cd 30                	int    $0x30
  8013ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801406:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801409:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	6a 00                	push   $0x0
  801412:	51                   	push   %ecx
  801413:	52                   	push   %edx
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	50                   	push   %eax
  801418:	6a 00                	push   $0x0
  80141a:	e8 b0 ff ff ff       	call   8013cf <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_cgetc>:

int
sys_cgetc(void)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 02                	push   $0x2
  801434:	e8 96 ff ff ff       	call   8013cf <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 03                	push   $0x3
  80144d:	e8 7d ff ff ff       	call   8013cf <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 04                	push   $0x4
  801467:	e8 63 ff ff ff       	call   8013cf <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	90                   	nop
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801475:	8b 55 0c             	mov    0xc(%ebp),%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	52                   	push   %edx
  801482:	50                   	push   %eax
  801483:	6a 08                	push   $0x8
  801485:	e8 45 ff ff ff       	call   8013cf <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	56                   	push   %esi
  801493:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801494:	8b 75 18             	mov    0x18(%ebp),%esi
  801497:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	51                   	push   %ecx
  8014a6:	52                   	push   %edx
  8014a7:	50                   	push   %eax
  8014a8:	6a 09                	push   $0x9
  8014aa:	e8 20 ff ff ff       	call   8013cf <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	ff 75 08             	pushl  0x8(%ebp)
  8014c7:	6a 0a                	push   $0xa
  8014c9:	e8 01 ff ff ff       	call   8013cf <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	6a 0b                	push   $0xb
  8014e4:	e8 e6 fe ff ff       	call   8013cf <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 0c                	push   $0xc
  8014fd:	e8 cd fe ff ff       	call   8013cf <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 0d                	push   $0xd
  801516:	e8 b4 fe ff ff       	call   8013cf <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 0e                	push   $0xe
  80152f:	e8 9b fe ff ff       	call   8013cf <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 0f                	push   $0xf
  801548:	e8 82 fe ff ff       	call   8013cf <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	ff 75 08             	pushl  0x8(%ebp)
  801560:	6a 10                	push   $0x10
  801562:	e8 68 fe ff ff       	call   8013cf <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 11                	push   $0x11
  80157b:	e8 4f fe ff ff       	call   8013cf <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_cputc>:

void
sys_cputc(const char c)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801592:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	50                   	push   %eax
  80159f:	6a 01                	push   $0x1
  8015a1:	e8 29 fe ff ff       	call   8013cf <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 14                	push   $0x14
  8015bb:	e8 0f fe ff ff       	call   8013cf <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	90                   	nop
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	6a 00                	push   $0x0
  8015de:	51                   	push   %ecx
  8015df:	52                   	push   %edx
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	50                   	push   %eax
  8015e4:	6a 15                	push   $0x15
  8015e6:	e8 e4 fd ff ff       	call   8013cf <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	52                   	push   %edx
  801600:	50                   	push   %eax
  801601:	6a 16                	push   $0x16
  801603:	e8 c7 fd ff ff       	call   8013cf <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801610:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	51                   	push   %ecx
  80161e:	52                   	push   %edx
  80161f:	50                   	push   %eax
  801620:	6a 17                	push   $0x17
  801622:	e8 a8 fd ff ff       	call   8013cf <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80162f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	52                   	push   %edx
  80163c:	50                   	push   %eax
  80163d:	6a 18                	push   $0x18
  80163f:	e8 8b fd ff ff       	call   8013cf <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	6a 00                	push   $0x0
  801651:	ff 75 14             	pushl  0x14(%ebp)
  801654:	ff 75 10             	pushl  0x10(%ebp)
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	6a 19                	push   $0x19
  80165d:	e8 6d fd ff ff       	call   8013cf <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	50                   	push   %eax
  801676:	6a 1a                	push   $0x1a
  801678:	e8 52 fd ff ff       	call   8013cf <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	90                   	nop
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	50                   	push   %eax
  801692:	6a 1b                	push   $0x1b
  801694:	e8 36 fd ff ff       	call   8013cf <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 05                	push   $0x5
  8016ad:	e8 1d fd ff ff       	call   8013cf <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 06                	push   $0x6
  8016c6:	e8 04 fd ff ff       	call   8013cf <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 07                	push   $0x7
  8016df:	e8 eb fc ff ff       	call   8013cf <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_exit_env>:


void sys_exit_env(void)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 1c                	push   $0x1c
  8016f8:	e8 d2 fc ff ff       	call   8013cf <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801709:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80170c:	8d 50 04             	lea    0x4(%eax),%edx
  80170f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	52                   	push   %edx
  801719:	50                   	push   %eax
  80171a:	6a 1d                	push   $0x1d
  80171c:	e8 ae fc ff ff       	call   8013cf <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
	return result;
  801724:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172d:	89 01                	mov    %eax,(%ecx)
  80172f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	c9                   	leave  
  801736:	c2 04 00             	ret    $0x4

00801739 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	ff 75 10             	pushl  0x10(%ebp)
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 13                	push   $0x13
  80174b:	e8 7f fc ff ff       	call   8013cf <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return ;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_rcr2>:
uint32 sys_rcr2()
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 1e                	push   $0x1e
  801765:	e8 65 fc ff ff       	call   8013cf <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80177b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	50                   	push   %eax
  801788:	6a 1f                	push   $0x1f
  80178a:	e8 40 fc ff ff       	call   8013cf <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
	return ;
  801792:	90                   	nop
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <rsttst>:
void rsttst()
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 21                	push   $0x21
  8017a4:	e8 26 fc ff ff       	call   8013cf <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ac:	90                   	nop
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017bb:	8b 55 18             	mov    0x18(%ebp),%edx
  8017be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c2:	52                   	push   %edx
  8017c3:	50                   	push   %eax
  8017c4:	ff 75 10             	pushl  0x10(%ebp)
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	6a 20                	push   $0x20
  8017cf:	e8 fb fb ff ff       	call   8013cf <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d7:	90                   	nop
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <chktst>:
void chktst(uint32 n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 22                	push   $0x22
  8017ea:	e8 e0 fb ff ff       	call   8013cf <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <inctst>:

void inctst()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 23                	push   $0x23
  801804:	e8 c6 fb ff ff       	call   8013cf <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
	return ;
  80180c:	90                   	nop
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <gettst>:
uint32 gettst()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 24                	push   $0x24
  80181e:	e8 ac fb ff ff       	call   8013cf <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 25                	push   $0x25
  801837:	e8 93 fb ff ff       	call   8013cf <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
  80183f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801844:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	6a 26                	push   $0x26
  801863:	e8 67 fb ff ff       	call   8013cf <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
	return ;
  80186b:	90                   	nop
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801872:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801875:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	53                   	push   %ebx
  801881:	51                   	push   %ecx
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 27                	push   $0x27
  801886:	e8 44 fb ff ff       	call   8013cf <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 28                	push   $0x28
  8018a6:	e8 24 fb ff ff       	call   8013cf <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	51                   	push   %ecx
  8018bf:	ff 75 10             	pushl  0x10(%ebp)
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 29                	push   $0x29
  8018c6:	e8 04 fb ff ff       	call   8013cf <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	6a 12                	push   $0x12
  8018e2:	e8 e8 fa ff ff       	call   8013cf <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 2a                	push   $0x2a
  801900:	e8 ca fa ff ff       	call   8013cf <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
	return;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 2b                	push   $0x2b
  80191a:	e8 b0 fa ff ff       	call   8013cf <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	6a 2d                	push   $0x2d
  801935:	e8 95 fa ff ff       	call   8013cf <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
	return;
  80193d:	90                   	nop
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 2c                	push   $0x2c
  801951:	e8 79 fa ff ff       	call   8013cf <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 e8 25 80 00       	push   $0x8025e8
  80196a:	68 25 01 00 00       	push   $0x125
  80196f:	68 1b 26 80 00       	push   $0x80261b
  801974:	e8 be 00 00 00       	call   801a37 <_panic>

00801979 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80197f:	8b 55 08             	mov    0x8(%ebp),%edx
  801982:	89 d0                	mov    %edx,%eax
  801984:	c1 e0 02             	shl    $0x2,%eax
  801987:	01 d0                	add    %edx,%eax
  801989:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801990:	01 d0                	add    %edx,%eax
  801992:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801999:	01 d0                	add    %edx,%eax
  80199b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a2:	01 d0                	add    %edx,%eax
  8019a4:	c1 e0 04             	shl    $0x4,%eax
  8019a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8019aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019b1:	0f 31                	rdtsc  
  8019b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8019c5:	eb 46                	jmp    801a0d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019c7:	0f 31                	rdtsc  
  8019c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8019cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e1:	29 c2                	sub    %eax,%edx
  8019e3:	89 d0                	mov    %edx,%eax
  8019e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	89 d1                	mov    %edx,%ecx
  8019f0:	29 c1                	sub    %eax,%ecx
  8019f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f8:	39 c2                	cmp    %eax,%edx
  8019fa:	0f 97 c0             	seta   %al
  8019fd:	0f b6 c0             	movzbl %al,%eax
  801a00:	29 c1                	sub    %eax,%ecx
  801a02:	89 c8                	mov    %ecx,%eax
  801a04:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a07:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a13:	72 b2                	jb     8019c7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a25:	eb 03                	jmp    801a2a <busy_wait+0x12>
  801a27:	ff 45 fc             	incl   -0x4(%ebp)
  801a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a30:	72 f5                	jb     801a27 <busy_wait+0xf>
	return i;
  801a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a3d:	8d 45 10             	lea    0x10(%ebp),%eax
  801a40:	83 c0 04             	add    $0x4,%eax
  801a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a46:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	74 16                	je     801a65 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a4f:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	50                   	push   %eax
  801a58:	68 2c 26 80 00       	push   $0x80262c
  801a5d:	e8 88 ea ff ff       	call   8004ea <cprintf>
  801a62:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a65:	a1 04 30 80 00       	mov    0x803004,%eax
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	50                   	push   %eax
  801a74:	68 34 26 80 00       	push   $0x802634
  801a79:	6a 74                	push   $0x74
  801a7b:	e8 97 ea ff ff       	call   800517 <cprintf_colored>
  801a80:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801a83:	8b 45 10             	mov    0x10(%ebp),%eax
  801a86:	83 ec 08             	sub    $0x8,%esp
  801a89:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	e8 e9 e9 ff ff       	call   80047b <vcprintf>
  801a92:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	6a 00                	push   $0x0
  801a9a:	68 5c 26 80 00       	push   $0x80265c
  801a9f:	e8 d7 e9 ff ff       	call   80047b <vcprintf>
  801aa4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801aa7:	e8 50 e9 ff ff       	call   8003fc <exit>

	// should not return here
	while (1) ;
  801aac:	eb fe                	jmp    801aac <_panic+0x75>

00801aae <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ab4:	a1 20 30 80 00       	mov    0x803020,%eax
  801ab9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac2:	39 c2                	cmp    %eax,%edx
  801ac4:	74 14                	je     801ada <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	68 60 26 80 00       	push   $0x802660
  801ace:	6a 26                	push   $0x26
  801ad0:	68 ac 26 80 00       	push   $0x8026ac
  801ad5:	e8 5d ff ff ff       	call   801a37 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801ae1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ae8:	e9 c5 00 00 00       	jmp    801bb2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	8b 00                	mov    (%eax),%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	75 08                	jne    801b0a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b02:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b05:	e9 a5 00 00 00       	jmp    801baf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b18:	eb 69                	jmp    801b83 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b1a:	a1 20 30 80 00       	mov    0x803020,%eax
  801b1f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	01 c0                	add    %eax,%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	c1 e0 03             	shl    $0x3,%eax
  801b31:	01 c8                	add    %ecx,%eax
  801b33:	8a 40 04             	mov    0x4(%eax),%al
  801b36:	84 c0                	test   %al,%al
  801b38:	75 46                	jne    801b80 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b3a:	a1 20 30 80 00       	mov    0x803020,%eax
  801b3f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	01 c0                	add    %eax,%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	c1 e0 03             	shl    $0x3,%eax
  801b51:	01 c8                	add    %ecx,%eax
  801b53:	8b 00                	mov    (%eax),%eax
  801b55:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b60:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b65:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	01 c8                	add    %ecx,%eax
  801b71:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b73:	39 c2                	cmp    %eax,%edx
  801b75:	75 09                	jne    801b80 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b77:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b7e:	eb 15                	jmp    801b95 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b80:	ff 45 e8             	incl   -0x18(%ebp)
  801b83:	a1 20 30 80 00       	mov    0x803020,%eax
  801b88:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b91:	39 c2                	cmp    %eax,%edx
  801b93:	77 85                	ja     801b1a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b99:	75 14                	jne    801baf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	68 b8 26 80 00       	push   $0x8026b8
  801ba3:	6a 3a                	push   $0x3a
  801ba5:	68 ac 26 80 00       	push   $0x8026ac
  801baa:	e8 88 fe ff ff       	call   801a37 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801baf:	ff 45 f0             	incl   -0x10(%ebp)
  801bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bb8:	0f 8c 2f ff ff ff    	jl     801aed <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bbe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bc5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bcc:	eb 26                	jmp    801bf4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bce:	a1 20 30 80 00       	mov    0x803020,%eax
  801bd3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801bd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bdc:	89 d0                	mov    %edx,%eax
  801bde:	01 c0                	add    %eax,%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	c1 e0 03             	shl    $0x3,%eax
  801be5:	01 c8                	add    %ecx,%eax
  801be7:	8a 40 04             	mov    0x4(%eax),%al
  801bea:	3c 01                	cmp    $0x1,%al
  801bec:	75 03                	jne    801bf1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bf1:	ff 45 e0             	incl   -0x20(%ebp)
  801bf4:	a1 20 30 80 00       	mov    0x803020,%eax
  801bf9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c02:	39 c2                	cmp    %eax,%edx
  801c04:	77 c8                	ja     801bce <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c09:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c0c:	74 14                	je     801c22 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	68 0c 27 80 00       	push   $0x80270c
  801c16:	6a 44                	push   $0x44
  801c18:	68 ac 26 80 00       	push   $0x8026ac
  801c1d:	e8 15 fe ff ff       	call   801a37 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c22:	90                   	nop
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    
  801c25:	66 90                	xchg   %ax,%ax
  801c27:	90                   	nop

00801c28 <__udivdi3>:
  801c28:	55                   	push   %ebp
  801c29:	57                   	push   %edi
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 1c             	sub    $0x1c,%esp
  801c2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3f:	89 ca                	mov    %ecx,%edx
  801c41:	89 f8                	mov    %edi,%eax
  801c43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c47:	85 f6                	test   %esi,%esi
  801c49:	75 2d                	jne    801c78 <__udivdi3+0x50>
  801c4b:	39 cf                	cmp    %ecx,%edi
  801c4d:	77 65                	ja     801cb4 <__udivdi3+0x8c>
  801c4f:	89 fd                	mov    %edi,%ebp
  801c51:	85 ff                	test   %edi,%edi
  801c53:	75 0b                	jne    801c60 <__udivdi3+0x38>
  801c55:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5a:	31 d2                	xor    %edx,%edx
  801c5c:	f7 f7                	div    %edi
  801c5e:	89 c5                	mov    %eax,%ebp
  801c60:	31 d2                	xor    %edx,%edx
  801c62:	89 c8                	mov    %ecx,%eax
  801c64:	f7 f5                	div    %ebp
  801c66:	89 c1                	mov    %eax,%ecx
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	f7 f5                	div    %ebp
  801c6c:	89 cf                	mov    %ecx,%edi
  801c6e:	89 fa                	mov    %edi,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	39 ce                	cmp    %ecx,%esi
  801c7a:	77 28                	ja     801ca4 <__udivdi3+0x7c>
  801c7c:	0f bd fe             	bsr    %esi,%edi
  801c7f:	83 f7 1f             	xor    $0x1f,%edi
  801c82:	75 40                	jne    801cc4 <__udivdi3+0x9c>
  801c84:	39 ce                	cmp    %ecx,%esi
  801c86:	72 0a                	jb     801c92 <__udivdi3+0x6a>
  801c88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c8c:	0f 87 9e 00 00 00    	ja     801d30 <__udivdi3+0x108>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	89 fa                	mov    %edi,%edx
  801c99:	83 c4 1c             	add    $0x1c,%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
  801ca1:	8d 76 00             	lea    0x0(%esi),%esi
  801ca4:	31 ff                	xor    %edi,%edi
  801ca6:	31 c0                	xor    %eax,%eax
  801ca8:	89 fa                	mov    %edi,%edx
  801caa:	83 c4 1c             	add    $0x1c,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5f                   	pop    %edi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	89 d8                	mov    %ebx,%eax
  801cb6:	f7 f7                	div    %edi
  801cb8:	31 ff                	xor    %edi,%edi
  801cba:	89 fa                	mov    %edi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cc9:	89 eb                	mov    %ebp,%ebx
  801ccb:	29 fb                	sub    %edi,%ebx
  801ccd:	89 f9                	mov    %edi,%ecx
  801ccf:	d3 e6                	shl    %cl,%esi
  801cd1:	89 c5                	mov    %eax,%ebp
  801cd3:	88 d9                	mov    %bl,%cl
  801cd5:	d3 ed                	shr    %cl,%ebp
  801cd7:	89 e9                	mov    %ebp,%ecx
  801cd9:	09 f1                	or     %esi,%ecx
  801cdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cdf:	89 f9                	mov    %edi,%ecx
  801ce1:	d3 e0                	shl    %cl,%eax
  801ce3:	89 c5                	mov    %eax,%ebp
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	88 d9                	mov    %bl,%cl
  801ce9:	d3 ee                	shr    %cl,%esi
  801ceb:	89 f9                	mov    %edi,%ecx
  801ced:	d3 e2                	shl    %cl,%edx
  801cef:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf3:	88 d9                	mov    %bl,%cl
  801cf5:	d3 e8                	shr    %cl,%eax
  801cf7:	09 c2                	or     %eax,%edx
  801cf9:	89 d0                	mov    %edx,%eax
  801cfb:	89 f2                	mov    %esi,%edx
  801cfd:	f7 74 24 0c          	divl   0xc(%esp)
  801d01:	89 d6                	mov    %edx,%esi
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	f7 e5                	mul    %ebp
  801d07:	39 d6                	cmp    %edx,%esi
  801d09:	72 19                	jb     801d24 <__udivdi3+0xfc>
  801d0b:	74 0b                	je     801d18 <__udivdi3+0xf0>
  801d0d:	89 d8                	mov    %ebx,%eax
  801d0f:	31 ff                	xor    %edi,%edi
  801d11:	e9 58 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d1c:	89 f9                	mov    %edi,%ecx
  801d1e:	d3 e2                	shl    %cl,%edx
  801d20:	39 c2                	cmp    %eax,%edx
  801d22:	73 e9                	jae    801d0d <__udivdi3+0xe5>
  801d24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d27:	31 ff                	xor    %edi,%edi
  801d29:	e9 40 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	31 c0                	xor    %eax,%eax
  801d32:	e9 37 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d37:	90                   	nop

00801d38 <__umoddi3>:
  801d38:	55                   	push   %ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 1c             	sub    $0x1c,%esp
  801d3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d57:	89 f3                	mov    %esi,%ebx
  801d59:	89 fa                	mov    %edi,%edx
  801d5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d5f:	89 34 24             	mov    %esi,(%esp)
  801d62:	85 c0                	test   %eax,%eax
  801d64:	75 1a                	jne    801d80 <__umoddi3+0x48>
  801d66:	39 f7                	cmp    %esi,%edi
  801d68:	0f 86 a2 00 00 00    	jbe    801e10 <__umoddi3+0xd8>
  801d6e:	89 c8                	mov    %ecx,%eax
  801d70:	89 f2                	mov    %esi,%edx
  801d72:	f7 f7                	div    %edi
  801d74:	89 d0                	mov    %edx,%eax
  801d76:	31 d2                	xor    %edx,%edx
  801d78:	83 c4 1c             	add    $0x1c,%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    
  801d80:	39 f0                	cmp    %esi,%eax
  801d82:	0f 87 ac 00 00 00    	ja     801e34 <__umoddi3+0xfc>
  801d88:	0f bd e8             	bsr    %eax,%ebp
  801d8b:	83 f5 1f             	xor    $0x1f,%ebp
  801d8e:	0f 84 ac 00 00 00    	je     801e40 <__umoddi3+0x108>
  801d94:	bf 20 00 00 00       	mov    $0x20,%edi
  801d99:	29 ef                	sub    %ebp,%edi
  801d9b:	89 fe                	mov    %edi,%esi
  801d9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 e0                	shl    %cl,%eax
  801da5:	89 d7                	mov    %edx,%edi
  801da7:	89 f1                	mov    %esi,%ecx
  801da9:	d3 ef                	shr    %cl,%edi
  801dab:	09 c7                	or     %eax,%edi
  801dad:	89 e9                	mov    %ebp,%ecx
  801daf:	d3 e2                	shl    %cl,%edx
  801db1:	89 14 24             	mov    %edx,(%esp)
  801db4:	89 d8                	mov    %ebx,%eax
  801db6:	d3 e0                	shl    %cl,%eax
  801db8:	89 c2                	mov    %eax,%edx
  801dba:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dbe:	d3 e0                	shl    %cl,%eax
  801dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc8:	89 f1                	mov    %esi,%ecx
  801dca:	d3 e8                	shr    %cl,%eax
  801dcc:	09 d0                	or     %edx,%eax
  801dce:	d3 eb                	shr    %cl,%ebx
  801dd0:	89 da                	mov    %ebx,%edx
  801dd2:	f7 f7                	div    %edi
  801dd4:	89 d3                	mov    %edx,%ebx
  801dd6:	f7 24 24             	mull   (%esp)
  801dd9:	89 c6                	mov    %eax,%esi
  801ddb:	89 d1                	mov    %edx,%ecx
  801ddd:	39 d3                	cmp    %edx,%ebx
  801ddf:	0f 82 87 00 00 00    	jb     801e6c <__umoddi3+0x134>
  801de5:	0f 84 91 00 00 00    	je     801e7c <__umoddi3+0x144>
  801deb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801def:	29 f2                	sub    %esi,%edx
  801df1:	19 cb                	sbb    %ecx,%ebx
  801df3:	89 d8                	mov    %ebx,%eax
  801df5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801df9:	d3 e0                	shl    %cl,%eax
  801dfb:	89 e9                	mov    %ebp,%ecx
  801dfd:	d3 ea                	shr    %cl,%edx
  801dff:	09 d0                	or     %edx,%eax
  801e01:	89 e9                	mov    %ebp,%ecx
  801e03:	d3 eb                	shr    %cl,%ebx
  801e05:	89 da                	mov    %ebx,%edx
  801e07:	83 c4 1c             	add    $0x1c,%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5f                   	pop    %edi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    
  801e0f:	90                   	nop
  801e10:	89 fd                	mov    %edi,%ebp
  801e12:	85 ff                	test   %edi,%edi
  801e14:	75 0b                	jne    801e21 <__umoddi3+0xe9>
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	31 d2                	xor    %edx,%edx
  801e1d:	f7 f7                	div    %edi
  801e1f:	89 c5                	mov    %eax,%ebp
  801e21:	89 f0                	mov    %esi,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f5                	div    %ebp
  801e27:	89 c8                	mov    %ecx,%eax
  801e29:	f7 f5                	div    %ebp
  801e2b:	89 d0                	mov    %edx,%eax
  801e2d:	e9 44 ff ff ff       	jmp    801d76 <__umoddi3+0x3e>
  801e32:	66 90                	xchg   %ax,%ax
  801e34:	89 c8                	mov    %ecx,%eax
  801e36:	89 f2                	mov    %esi,%edx
  801e38:	83 c4 1c             	add    $0x1c,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    
  801e40:	3b 04 24             	cmp    (%esp),%eax
  801e43:	72 06                	jb     801e4b <__umoddi3+0x113>
  801e45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e49:	77 0f                	ja     801e5a <__umoddi3+0x122>
  801e4b:	89 f2                	mov    %esi,%edx
  801e4d:	29 f9                	sub    %edi,%ecx
  801e4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e53:	89 14 24             	mov    %edx,(%esp)
  801e56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e5e:	8b 14 24             	mov    (%esp),%edx
  801e61:	83 c4 1c             	add    $0x1c,%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5e                   	pop    %esi
  801e66:	5f                   	pop    %edi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    
  801e69:	8d 76 00             	lea    0x0(%esi),%esi
  801e6c:	2b 04 24             	sub    (%esp),%eax
  801e6f:	19 fa                	sbb    %edi,%edx
  801e71:	89 d1                	mov    %edx,%ecx
  801e73:	89 c6                	mov    %eax,%esi
  801e75:	e9 71 ff ff ff       	jmp    801deb <__umoddi3+0xb3>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e80:	72 ea                	jb     801e6c <__umoddi3+0x134>
  801e82:	89 d9                	mov    %ebx,%ecx
  801e84:	e9 62 ff ff ff       	jmp    801deb <__umoddi3+0xb3>
