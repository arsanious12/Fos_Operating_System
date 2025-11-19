
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
  800048:	68 80 1e 80 00       	push   $0x801e80
  80004d:	6a 03                	push   $0x3
  80004f:	e8 ae 04 00 00       	call   800502 <cprintf_colored>
  800054:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================\n");
  800057:	83 ec 08             	sub    $0x8,%esp
  80005a:	68 c8 1e 80 00       	push   $0x801ec8
  80005f:	6a 03                	push   $0x3
  800061:	e8 9c 04 00 00       	call   800502 <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800069:	e8 12 17 00 00       	call   801780 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800079:	a1 20 30 80 00       	mov    0x803020,%eax
  80007e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800084:	89 c1                	mov    %eax,%ecx
  800086:	a1 20 30 80 00       	mov    0x803020,%eax
  80008b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800091:	52                   	push   %edx
  800092:	51                   	push   %ecx
  800093:	50                   	push   %eax
  800094:	68 0d 1f 80 00       	push   $0x801f0d
  800099:	e8 96 15 00 00       	call   801634 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 a3 15 00 00       	call   801652 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c2:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000c8:	89 c1                	mov    %eax,%ecx
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d5:	52                   	push   %edx
  8000d6:	51                   	push   %ecx
  8000d7:	50                   	push   %eax
  8000d8:	68 18 1f 80 00       	push   $0x801f18
  8000dd:	e8 52 15 00 00       	call   801634 <sys_create_env>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 5f 15 00 00       	call   801652 <sys_run_env>
  8000f3:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800101:	a1 20 30 80 00       	mov    0x803020,%eax
  800106:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80010c:	89 c1                	mov    %eax,%ecx
  80010e:	a1 20 30 80 00       	mov    0x803020,%eax
  800113:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800119:	52                   	push   %edx
  80011a:	51                   	push   %ecx
  80011b:	50                   	push   %eax
  80011c:	68 23 1f 80 00       	push   $0x801f23
  800121:	e8 0e 15 00 00       	call   801634 <sys_create_env>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	ff 75 e8             	pushl  -0x18(%ebp)
  800132:	e8 1b 15 00 00       	call   801652 <sys_run_env>
  800137:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 98 3a 00 00       	push   $0x3a98
  800142:	e8 1d 18 00 00       	call   801964 <env_sleep>
  800147:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80014a:	e8 ab 16 00 00       	call   8017fa <gettst>
  80014f:	85 c0                	test   %eax,%eax
  800151:	74 14                	je     800167 <_main+0x12f>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART I... Failed.\n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 2e 1f 80 00       	push   $0x801f2e
  80015b:	6a 0c                	push   $0xc
  80015d:	e8 a0 03 00 00       	call   800502 <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	eb 16                	jmp    80017d <_main+0x145>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART I... completed successfully\n\n");
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 44 1f 80 00       	push   $0x801f44
  80016f:	6a 02                	push   $0x2
  800171:	e8 8c 03 00 00       	call   800502 <cprintf_colored>
  800176:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800179:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf_colored(TEXT_cyan, "%~PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	68 6c 1f 80 00       	push   $0x801f6c
  800185:	6a 03                	push   $0x3
  800187:	e8 76 03 00 00       	call   800502 <cprintf_colored>
  80018c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================================================\n");
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	68 d4 1f 80 00       	push   $0x801fd4
  800197:	6a 03                	push   $0x3
  800199:	e8 64 03 00 00       	call   800502 <cprintf_colored>
  80019e:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8001a1:	e8 da 15 00 00       	call   801780 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8001bc:	89 c1                	mov    %eax,%ecx
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001c9:	52                   	push   %edx
  8001ca:	51                   	push   %ecx
  8001cb:	50                   	push   %eax
  8001cc:	68 39 20 80 00       	push   $0x802039
  8001d1:	e8 5e 14 00 00       	call   801634 <sys_create_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	e8 6b 14 00 00       	call   801652 <sys_run_env>
  8001e7:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	68 98 3a 00 00       	push   $0x3a98
  8001f2:	e8 6d 17 00 00       	call   801964 <env_sleep>
  8001f7:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001fa:	e8 fb 15 00 00       	call   8017fa <gettst>
  8001ff:	85 c0                	test   %eax,%eax
  800201:	74 14                	je     800217 <_main+0x1df>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART II... Failed.\n");
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	68 44 20 80 00       	push   $0x802044
  80020b:	6a 0c                	push   $0xc
  80020d:	e8 f0 02 00 00       	call   800502 <cprintf_colored>
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	eb 16                	jmp    80022d <_main+0x1f5>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART II... completed successfully\n\n");
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	68 5c 20 80 00       	push   $0x80205c
  80021f:	6a 02                	push   $0x2
  800221:	e8 dc 02 00 00       	call   800502 <cprintf_colored>
  800226:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800229:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest invalid access completed. Eval = %d%\n\n", eval);
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	68 84 20 80 00       	push   $0x802084
  800238:	6a 0a                	push   $0xa
  80023a:	e8 c3 02 00 00       	call   800502 <cprintf_colored>
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
  80024e:	e8 4f 14 00 00       	call   8016a2 <sys_getenvindex>
  800253:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800256:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800259:	89 d0                	mov    %edx,%eax
  80025b:	c1 e0 02             	shl    $0x2,%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	c1 e0 03             	shl    $0x3,%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80026c:	01 d0                	add    %edx,%eax
  80026e:	c1 e0 02             	shl    $0x2,%eax
  800271:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800276:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027b:	a1 20 30 80 00       	mov    0x803020,%eax
  800280:	8a 40 20             	mov    0x20(%eax),%al
  800283:	84 c0                	test   %al,%al
  800285:	74 0d                	je     800294 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800287:	a1 20 30 80 00       	mov    0x803020,%eax
  80028c:	83 c0 20             	add    $0x20,%eax
  80028f:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800298:	7e 0a                	jle    8002a4 <libmain+0x5f>
		binaryname = argv[0];
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 86 fd ff ff       	call   800038 <_main>
  8002b2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002b5:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	0f 84 01 01 00 00    	je     8003c3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002c2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002c8:	bb ac 21 80 00       	mov    $0x8021ac,%ebx
  8002cd:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002d2:	89 c7                	mov    %eax,%edi
  8002d4:	89 de                	mov    %ebx,%esi
  8002d6:	89 d1                	mov    %edx,%ecx
  8002d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002da:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002dd:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002e2:	b0 00                	mov    $0x0,%al
  8002e4:	89 d7                	mov    %edx,%edi
  8002e6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	50                   	push   %eax
  8002f6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002fc:	50                   	push   %eax
  8002fd:	e8 d6 15 00 00       	call   8018d8 <sys_utilities>
  800302:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800305:	e8 1f 11 00 00       	call   801429 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 cc 20 80 00       	push   $0x8020cc
  800312:	e8 be 01 00 00       	call   8004d5 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	74 18                	je     800339 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800321:	e8 d0 15 00 00       	call   8018f6 <sys_get_optimal_num_faults>
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	50                   	push   %eax
  80032a:	68 f4 20 80 00       	push   $0x8020f4
  80032f:	e8 a1 01 00 00       	call   8004d5 <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	eb 59                	jmp    800392 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800344:	a1 20 30 80 00       	mov    0x803020,%eax
  800349:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	52                   	push   %edx
  800353:	50                   	push   %eax
  800354:	68 18 21 80 00       	push   $0x802118
  800359:	e8 77 01 00 00       	call   8004d5 <cprintf>
  80035e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800361:	a1 20 30 80 00       	mov    0x803020,%eax
  800366:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80036c:	a1 20 30 80 00       	mov    0x803020,%eax
  800371:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800382:	51                   	push   %ecx
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	68 40 21 80 00       	push   $0x802140
  80038a:	e8 46 01 00 00       	call   8004d5 <cprintf>
  80038f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800392:	a1 20 30 80 00       	mov    0x803020,%eax
  800397:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	50                   	push   %eax
  8003a1:	68 98 21 80 00       	push   $0x802198
  8003a6:	e8 2a 01 00 00       	call   8004d5 <cprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003ae:	83 ec 0c             	sub    $0xc,%esp
  8003b1:	68 cc 20 80 00       	push   $0x8020cc
  8003b6:	e8 1a 01 00 00       	call   8004d5 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003be:	e8 80 10 00 00       	call   801443 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003c3:	e8 1f 00 00 00       	call   8003e7 <exit>
}
  8003c8:	90                   	nop
  8003c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cc:	5b                   	pop    %ebx
  8003cd:	5e                   	pop    %esi
  8003ce:	5f                   	pop    %edi
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	e8 8d 12 00 00       	call   80166e <sys_destroy_env>
  8003e1:	83 c4 10             	add    $0x10,%esp
}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <exit>:

void
exit(void)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ed:	e8 e2 12 00 00       	call   8016d4 <sys_exit_env>
}
  8003f2:	90                   	nop
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	53                   	push   %ebx
  8003f9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	8d 48 01             	lea    0x1(%eax),%ecx
  800404:	8b 55 0c             	mov    0xc(%ebp),%edx
  800407:	89 0a                	mov    %ecx,(%edx)
  800409:	8b 55 08             	mov    0x8(%ebp),%edx
  80040c:	88 d1                	mov    %dl,%cl
  80040e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800411:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800415:	8b 45 0c             	mov    0xc(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041f:	75 30                	jne    800451 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800421:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800427:	a0 44 30 80 00       	mov    0x803044,%al
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800432:	8b 09                	mov    (%ecx),%ecx
  800434:	89 cb                	mov    %ecx,%ebx
  800436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800439:	83 c1 08             	add    $0x8,%ecx
  80043c:	52                   	push   %edx
  80043d:	50                   	push   %eax
  80043e:	53                   	push   %ebx
  80043f:	51                   	push   %ecx
  800440:	e8 a0 0f 00 00       	call   8013e5 <sys_cputs>
  800445:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	8b 40 04             	mov    0x4(%eax),%eax
  800457:	8d 50 01             	lea    0x1(%eax),%edx
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800460:	90                   	nop
  800461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80046f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800476:	00 00 00 
	b.cnt = 0;
  800479:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800480:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800483:	ff 75 0c             	pushl  0xc(%ebp)
  800486:	ff 75 08             	pushl  0x8(%ebp)
  800489:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048f:	50                   	push   %eax
  800490:	68 f5 03 80 00       	push   $0x8003f5
  800495:	e8 5a 02 00 00       	call   8006f4 <vprintfmt>
  80049a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80049d:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004a3:	a0 44 30 80 00       	mov    0x803044,%al
  8004a8:	0f b6 c0             	movzbl %al,%eax
  8004ab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	51                   	push   %ecx
  8004b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ba:	83 c0 08             	add    $0x8,%eax
  8004bd:	50                   	push   %eax
  8004be:	e8 22 0f 00 00       	call   8013e5 <sys_cputs>
  8004c3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004c6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004db:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	50                   	push   %eax
  8004f2:	e8 6f ff ff ff       	call   800466 <vcprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800500:	c9                   	leave  
  800501:	c3                   	ret    

00800502 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800508:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	c1 e0 08             	shl    $0x8,%eax
  800515:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80051a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051d:	83 c0 04             	add    $0x4,%eax
  800520:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800523:	8b 45 0c             	mov    0xc(%ebp),%eax
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 f4             	pushl  -0xc(%ebp)
  80052c:	50                   	push   %eax
  80052d:	e8 34 ff ff ff       	call   800466 <vcprintf>
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800538:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80053f:	07 00 00 

	return cnt;
  800542:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80054d:	e8 d7 0e 00 00       	call   801429 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800552:	8d 45 0c             	lea    0xc(%ebp),%eax
  800555:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	ff 75 f4             	pushl  -0xc(%ebp)
  800561:	50                   	push   %eax
  800562:	e8 ff fe ff ff       	call   800466 <vcprintf>
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80056d:	e8 d1 0e 00 00       	call   801443 <sys_unlock_cons>
	return cnt;
  800572:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	53                   	push   %ebx
  80057b:	83 ec 14             	sub    $0x14,%esp
  80057e:	8b 45 10             	mov    0x10(%ebp),%eax
  800581:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058a:	8b 45 18             	mov    0x18(%ebp),%eax
  80058d:	ba 00 00 00 00       	mov    $0x0,%edx
  800592:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800595:	77 55                	ja     8005ec <printnum+0x75>
  800597:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059a:	72 05                	jb     8005a1 <printnum+0x2a>
  80059c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059f:	77 4b                	ja     8005ec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	52                   	push   %edx
  8005b0:	50                   	push   %eax
  8005b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b7:	e8 54 16 00 00       	call   801c10 <__udivdi3>
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	83 ec 04             	sub    $0x4,%esp
  8005c2:	ff 75 20             	pushl  0x20(%ebp)
  8005c5:	53                   	push   %ebx
  8005c6:	ff 75 18             	pushl  0x18(%ebp)
  8005c9:	52                   	push   %edx
  8005ca:	50                   	push   %eax
  8005cb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ce:	ff 75 08             	pushl  0x8(%ebp)
  8005d1:	e8 a1 ff ff ff       	call   800577 <printnum>
  8005d6:	83 c4 20             	add    $0x20,%esp
  8005d9:	eb 1a                	jmp    8005f5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 20             	pushl  0x20(%ebp)
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	ff d0                	call   *%eax
  8005e9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ec:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f3:	7f e6                	jg     8005db <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800600:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800603:	53                   	push   %ebx
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	e8 14 17 00 00       	call   801d20 <__umoddi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	05 34 24 80 00       	add    $0x802434,%eax
  800614:	8a 00                	mov    (%eax),%al
  800616:	0f be c0             	movsbl %al,%eax
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	ff 75 0c             	pushl  0xc(%ebp)
  80061f:	50                   	push   %eax
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	ff d0                	call   *%eax
  800625:	83 c4 10             	add    $0x10,%esp
}
  800628:	90                   	nop
  800629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800631:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800635:	7e 1c                	jle    800653 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	8d 50 08             	lea    0x8(%eax),%edx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	89 10                	mov    %edx,(%eax)
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	83 e8 08             	sub    $0x8,%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	eb 40                	jmp    800693 <getuint+0x65>
	else if (lflag)
  800653:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800657:	74 1e                	je     800677 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	8d 50 04             	lea    0x4(%eax),%edx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	89 10                	mov    %edx,(%eax)
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	83 e8 04             	sub    $0x4,%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	ba 00 00 00 00       	mov    $0x0,%edx
  800675:	eb 1c                	jmp    800693 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	8d 50 04             	lea    0x4(%eax),%edx
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	89 10                	mov    %edx,(%eax)
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	83 e8 04             	sub    $0x4,%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800693:	5d                   	pop    %ebp
  800694:	c3                   	ret    

00800695 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800698:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069c:	7e 1c                	jle    8006ba <getint+0x25>
		return va_arg(*ap, long long);
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	8d 50 08             	lea    0x8(%eax),%edx
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	89 10                	mov    %edx,(%eax)
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	83 e8 08             	sub    $0x8,%eax
  8006b3:	8b 50 04             	mov    0x4(%eax),%edx
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	eb 38                	jmp    8006f2 <getint+0x5d>
	else if (lflag)
  8006ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006be:	74 1a                	je     8006da <getint+0x45>
		return va_arg(*ap, long);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	8d 50 04             	lea    0x4(%eax),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	89 10                	mov    %edx,(%eax)
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	99                   	cltd   
  8006d8:	eb 18                	jmp    8006f2 <getint+0x5d>
	else
		return va_arg(*ap, int);
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
}
  8006f2:	5d                   	pop    %ebp
  8006f3:	c3                   	ret    

008006f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	56                   	push   %esi
  8006f8:	53                   	push   %ebx
  8006f9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fc:	eb 17                	jmp    800715 <vprintfmt+0x21>
			if (ch == '\0')
  8006fe:	85 db                	test   %ebx,%ebx
  800700:	0f 84 c1 03 00 00    	je     800ac7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	53                   	push   %ebx
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	8b 45 10             	mov    0x10(%ebp),%eax
  800718:	8d 50 01             	lea    0x1(%eax),%edx
  80071b:	89 55 10             	mov    %edx,0x10(%ebp)
  80071e:	8a 00                	mov    (%eax),%al
  800720:	0f b6 d8             	movzbl %al,%ebx
  800723:	83 fb 25             	cmp    $0x25,%ebx
  800726:	75 d6                	jne    8006fe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800728:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80072c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800733:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800741:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800748:	8b 45 10             	mov    0x10(%ebp),%eax
  80074b:	8d 50 01             	lea    0x1(%eax),%edx
  80074e:	89 55 10             	mov    %edx,0x10(%ebp)
  800751:	8a 00                	mov    (%eax),%al
  800753:	0f b6 d8             	movzbl %al,%ebx
  800756:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800759:	83 f8 5b             	cmp    $0x5b,%eax
  80075c:	0f 87 3d 03 00 00    	ja     800a9f <vprintfmt+0x3ab>
  800762:	8b 04 85 58 24 80 00 	mov    0x802458(,%eax,4),%eax
  800769:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80076b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80076f:	eb d7                	jmp    800748 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800771:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800775:	eb d1                	jmp    800748 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800777:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80077e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800781:	89 d0                	mov    %edx,%eax
  800783:	c1 e0 02             	shl    $0x2,%eax
  800786:	01 d0                	add    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d8                	add    %ebx,%eax
  80078c:	83 e8 30             	sub    $0x30,%eax
  80078f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800792:	8b 45 10             	mov    0x10(%ebp),%eax
  800795:	8a 00                	mov    (%eax),%al
  800797:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079a:	83 fb 2f             	cmp    $0x2f,%ebx
  80079d:	7e 3e                	jle    8007dd <vprintfmt+0xe9>
  80079f:	83 fb 39             	cmp    $0x39,%ebx
  8007a2:	7f 39                	jg     8007dd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a7:	eb d5                	jmp    80077e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	83 c0 04             	add    $0x4,%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 e8 04             	sub    $0x4,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007bd:	eb 1f                	jmp    8007de <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c3:	79 83                	jns    800748 <vprintfmt+0x54>
				width = 0;
  8007c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007cc:	e9 77 ff ff ff       	jmp    800748 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007d8:	e9 6b ff ff ff       	jmp    800748 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007dd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	0f 89 60 ff ff ff    	jns    800748 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f5:	e9 4e ff ff ff       	jmp    800748 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007fd:	e9 46 ff ff ff       	jmp    800748 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 c0 04             	add    $0x4,%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			break;
  800822:	e9 9b 02 00 00       	jmp    800ac2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 e8 04             	sub    $0x4,%eax
  800836:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800838:	85 db                	test   %ebx,%ebx
  80083a:	79 02                	jns    80083e <vprintfmt+0x14a>
				err = -err;
  80083c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80083e:	83 fb 64             	cmp    $0x64,%ebx
  800841:	7f 0b                	jg     80084e <vprintfmt+0x15a>
  800843:	8b 34 9d a0 22 80 00 	mov    0x8022a0(,%ebx,4),%esi
  80084a:	85 f6                	test   %esi,%esi
  80084c:	75 19                	jne    800867 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80084e:	53                   	push   %ebx
  80084f:	68 45 24 80 00       	push   $0x802445
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 70 02 00 00       	call   800acf <printfmt>
  80085f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800862:	e9 5b 02 00 00       	jmp    800ac2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800867:	56                   	push   %esi
  800868:	68 4e 24 80 00       	push   $0x80244e
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 57 02 00 00       	call   800acf <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			break;
  80087b:	e9 42 02 00 00       	jmp    800ac2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 c0 04             	add    $0x4,%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 e8 04             	sub    $0x4,%eax
  80088f:	8b 30                	mov    (%eax),%esi
  800891:	85 f6                	test   %esi,%esi
  800893:	75 05                	jne    80089a <vprintfmt+0x1a6>
				p = "(null)";
  800895:	be 51 24 80 00       	mov    $0x802451,%esi
			if (width > 0 && padc != '-')
  80089a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089e:	7e 6d                	jle    80090d <vprintfmt+0x219>
  8008a0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a4:	74 67                	je     80090d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	50                   	push   %eax
  8008ad:	56                   	push   %esi
  8008ae:	e8 1e 03 00 00       	call   800bd1 <strnlen>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008b9:	eb 16                	jmp    8008d1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008bb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	50                   	push   %eax
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ce:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d5:	7f e4                	jg     8008bb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d7:	eb 34                	jmp    80090d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008dd:	74 1c                	je     8008fb <vprintfmt+0x207>
  8008df:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e2:	7e 05                	jle    8008e9 <vprintfmt+0x1f5>
  8008e4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e7:	7e 12                	jle    8008fb <vprintfmt+0x207>
					putch('?', putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	6a 3f                	push   $0x3f
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	ff d0                	call   *%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	eb 0f                	jmp    80090a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	53                   	push   %ebx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090a:	ff 4d e4             	decl   -0x1c(%ebp)
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	8d 70 01             	lea    0x1(%eax),%esi
  800912:	8a 00                	mov    (%eax),%al
  800914:	0f be d8             	movsbl %al,%ebx
  800917:	85 db                	test   %ebx,%ebx
  800919:	74 24                	je     80093f <vprintfmt+0x24b>
  80091b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091f:	78 b8                	js     8008d9 <vprintfmt+0x1e5>
  800921:	ff 4d e0             	decl   -0x20(%ebp)
  800924:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800928:	79 af                	jns    8008d9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092a:	eb 13                	jmp    80093f <vprintfmt+0x24b>
				putch(' ', putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	6a 20                	push   $0x20
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	ff d0                	call   *%eax
  800939:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093c:	ff 4d e4             	decl   -0x1c(%ebp)
  80093f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800943:	7f e7                	jg     80092c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800945:	e9 78 01 00 00       	jmp    800ac2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 e8             	pushl  -0x18(%ebp)
  800950:	8d 45 14             	lea    0x14(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	e8 3c fd ff ff       	call   800695 <getint>
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800968:	85 d2                	test   %edx,%edx
  80096a:	79 23                	jns    80098f <vprintfmt+0x29b>
				putch('-', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 2d                	push   $0x2d
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80097c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800982:	f7 d8                	neg    %eax
  800984:	83 d2 00             	adc    $0x0,%edx
  800987:	f7 da                	neg    %edx
  800989:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80098f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800996:	e9 bc 00 00 00       	jmp    800a57 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 84 fc ff ff       	call   80062e <getuint>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ba:	e9 98 00 00 00       	jmp    800a57 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	6a 58                	push   $0x58
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 58                	push   $0x58
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			break;
  8009ef:	e9 ce 00 00 00       	jmp    800ac2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 30                	push   $0x30
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 78                	push   $0x78
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 e8 04             	sub    $0x4,%eax
  800a23:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a2f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a36:	eb 1f                	jmp    800a57 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a41:	50                   	push   %eax
  800a42:	e8 e7 fb ff ff       	call   80062e <getuint>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a57:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a5e:	83 ec 04             	sub    $0x4,%esp
  800a61:	52                   	push   %edx
  800a62:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a65:	50                   	push   %eax
  800a66:	ff 75 f4             	pushl  -0xc(%ebp)
  800a69:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	e8 00 fb ff ff       	call   800577 <printnum>
  800a77:	83 c4 20             	add    $0x20,%esp
			break;
  800a7a:	eb 46                	jmp    800ac2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	ff d0                	call   *%eax
  800a88:	83 c4 10             	add    $0x10,%esp
			break;
  800a8b:	eb 35                	jmp    800ac2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a8d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a94:	eb 2c                	jmp    800ac2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a96:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800a9d:	eb 23                	jmp    800ac2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 25                	push   $0x25
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aaf:	ff 4d 10             	decl   0x10(%ebp)
  800ab2:	eb 03                	jmp    800ab7 <vprintfmt+0x3c3>
  800ab4:	ff 4d 10             	decl   0x10(%ebp)
  800ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aba:	48                   	dec    %eax
  800abb:	8a 00                	mov    (%eax),%al
  800abd:	3c 25                	cmp    $0x25,%al
  800abf:	75 f3                	jne    800ab4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ac1:	90                   	nop
		}
	}
  800ac2:	e9 35 fc ff ff       	jmp    8006fc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800acb:	5b                   	pop    %ebx
  800acc:	5e                   	pop    %esi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ade:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 04 fc ff ff       	call   8006f4 <vprintfmt>
  800af0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af3:	90                   	nop
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	8b 40 08             	mov    0x8(%eax),%eax
  800aff:	8d 50 01             	lea    0x1(%eax),%edx
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	8b 10                	mov    (%eax),%edx
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	8b 40 04             	mov    0x4(%eax),%eax
  800b13:	39 c2                	cmp    %eax,%edx
  800b15:	73 12                	jae    800b29 <sprintputch+0x33>
		*b->buf++ = ch;
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	89 0a                	mov    %ecx,(%edx)
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	88 10                	mov    %dl,(%eax)
}
  800b29:	90                   	nop
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	01 d0                	add    %edx,%eax
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b51:	74 06                	je     800b59 <vsnprintf+0x2d>
  800b53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b57:	7f 07                	jg     800b60 <vsnprintf+0x34>
		return -E_INVAL;
  800b59:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5e:	eb 20                	jmp    800b80 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b60:	ff 75 14             	pushl  0x14(%ebp)
  800b63:	ff 75 10             	pushl  0x10(%ebp)
  800b66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b69:	50                   	push   %eax
  800b6a:	68 f6 0a 80 00       	push   $0x800af6
  800b6f:	e8 80 fb ff ff       	call   8006f4 <vprintfmt>
  800b74:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b88:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8b:	83 c0 04             	add    $0x4,%eax
  800b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b91:	8b 45 10             	mov    0x10(%ebp),%eax
  800b94:	ff 75 f4             	pushl  -0xc(%ebp)
  800b97:	50                   	push   %eax
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	e8 89 ff ff ff       	call   800b2c <vsnprintf>
  800ba3:	83 c4 10             	add    $0x10,%esp
  800ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbb:	eb 06                	jmp    800bc3 <strlen+0x15>
		n++;
  800bbd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc0:	ff 45 08             	incl   0x8(%ebp)
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 f1                	jne    800bbd <strlen+0xf>
		n++;
	return n;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bde:	eb 09                	jmp    800be9 <strnlen+0x18>
		n++;
  800be0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be3:	ff 45 08             	incl   0x8(%ebp)
  800be6:	ff 4d 0c             	decl   0xc(%ebp)
  800be9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bed:	74 09                	je     800bf8 <strnlen+0x27>
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	84 c0                	test   %al,%al
  800bf6:	75 e8                	jne    800be0 <strnlen+0xf>
		n++;
	return n;
  800bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c09:	90                   	nop
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8d 50 01             	lea    0x1(%eax),%edx
  800c10:	89 55 08             	mov    %edx,0x8(%ebp)
  800c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c19:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1c:	8a 12                	mov    (%edx),%dl
  800c1e:	88 10                	mov    %dl,(%eax)
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	84 c0                	test   %al,%al
  800c24:	75 e4                	jne    800c0a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3e:	eb 1f                	jmp    800c5f <strncpy+0x34>
		*dst++ = *src;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 08             	mov    %edx,0x8(%ebp)
  800c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4c:	8a 12                	mov    (%edx),%dl
  800c4e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	84 c0                	test   %al,%al
  800c57:	74 03                	je     800c5c <strncpy+0x31>
			src++;
  800c59:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5c:	ff 45 fc             	incl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c65:	72 d9                	jb     800c40 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7c:	74 30                	je     800cae <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7e:	eb 16                	jmp    800c96 <strlcpy+0x2a>
			*dst++ = *src++;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	89 55 08             	mov    %edx,0x8(%ebp)
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c92:	8a 12                	mov    (%edx),%dl
  800c94:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c96:	ff 4d 10             	decl   0x10(%ebp)
  800c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9d:	74 09                	je     800ca8 <strlcpy+0x3c>
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 d8                	jne    800c80 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb4:	29 c2                	sub    %eax,%edx
  800cb6:	89 d0                	mov    %edx,%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbd:	eb 06                	jmp    800cc5 <strcmp+0xb>
		p++, q++;
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	84 c0                	test   %al,%al
  800ccc:	74 0e                	je     800cdc <strcmp+0x22>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 10                	mov    (%eax),%dl
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	38 c2                	cmp    %al,%dl
  800cda:	74 e3                	je     800cbf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	0f b6 d0             	movzbl %al,%edx
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	0f b6 c0             	movzbl %al,%eax
  800cec:	29 c2                	sub    %eax,%edx
  800cee:	89 d0                	mov    %edx,%eax
}
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf5:	eb 09                	jmp    800d00 <strncmp+0xe>
		n--, p++, q++;
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	74 17                	je     800d1d <strncmp+0x2b>
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	84 c0                	test   %al,%al
  800d0d:	74 0e                	je     800d1d <strncmp+0x2b>
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 10                	mov    (%eax),%dl
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	38 c2                	cmp    %al,%dl
  800d1b:	74 da                	je     800cf7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	75 07                	jne    800d2a <strncmp+0x38>
		return 0;
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
  800d28:	eb 14                	jmp    800d3e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d0             	movzbl %al,%edx
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 c0             	movzbl %al,%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4c:	eb 12                	jmp    800d60 <strchr+0x20>
		if (*s == c)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d56:	75 05                	jne    800d5d <strchr+0x1d>
			return (char *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	eb 11                	jmp    800d6e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	84 c0                	test   %al,%al
  800d67:	75 e5                	jne    800d4e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 04             	sub    $0x4,%esp
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7c:	eb 0d                	jmp    800d8b <strfind+0x1b>
		if (*s == c)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d86:	74 0e                	je     800d96 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	84 c0                	test   %al,%al
  800d92:	75 ea                	jne    800d7e <strfind+0xe>
  800d94:	eb 01                	jmp    800d97 <strfind+0x27>
		if (*s == c)
			break;
  800d96:	90                   	nop
	return (char *) s;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800da8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dac:	76 63                	jbe    800e11 <memset+0x75>
		uint64 data_block = c;
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	99                   	cltd   
  800db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db5:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbe:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dc2:	c1 e0 08             	shl    $0x8,%eax
  800dc5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dc8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dd5:	c1 e0 10             	shl    $0x10,%eax
  800dd8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ddb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de4:	89 c2                	mov    %eax,%edx
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dee:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800df1:	eb 18                	jmp    800e0b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800df3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800df6:	8d 41 08             	lea    0x8(%ecx),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e02:	89 01                	mov    %eax,(%ecx)
  800e04:	89 51 04             	mov    %edx,0x4(%ecx)
  800e07:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e0b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e0f:	77 e2                	ja     800df3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e15:	74 23                	je     800e3a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1d:	eb 0e                	jmp    800e2d <memset+0x91>
			*p8++ = (uint8)c;
  800e1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e22:	8d 50 01             	lea    0x1(%eax),%edx
  800e25:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e33:	89 55 10             	mov    %edx,0x10(%ebp)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	75 e5                	jne    800e1f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e51:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e55:	76 24                	jbe    800e7b <memcpy+0x3c>
		while(n >= 8){
  800e57:	eb 1c                	jmp    800e75 <memcpy+0x36>
			*d64 = *s64;
  800e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5c:	8b 50 04             	mov    0x4(%eax),%edx
  800e5f:	8b 00                	mov    (%eax),%eax
  800e61:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e64:	89 01                	mov    %eax,(%ecx)
  800e66:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e69:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e6d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e71:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e79:	77 de                	ja     800e59 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7f:	74 31                	je     800eb2 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e8d:	eb 16                	jmp    800ea5 <memcpy+0x66>
			*d8++ = *s8++;
  800e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e92:	8d 50 01             	lea    0x1(%eax),%edx
  800e95:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ea1:	8a 12                	mov    (%edx),%dl
  800ea3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 dd                	jne    800e8f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ecf:	73 50                	jae    800f21 <memmove+0x6a>
  800ed1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edc:	76 43                	jbe    800f21 <memmove+0x6a>
		s += n;
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eea:	eb 10                	jmp    800efc <memmove+0x45>
			*--d = *--s;
  800eec:	ff 4d f8             	decl   -0x8(%ebp)
  800eef:	ff 4d fc             	decl   -0x4(%ebp)
  800ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef5:	8a 10                	mov    (%eax),%dl
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 e3                	jne    800eec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f09:	eb 23                	jmp    800f2e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1d:	8a 12                	mov    (%edx),%dl
  800f1f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f27:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	75 dd                	jne    800f0b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f45:	eb 2a                	jmp    800f71 <memcmp+0x3e>
		if (*s1 != *s2)
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	8a 10                	mov    (%eax),%dl
  800f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	38 c2                	cmp    %al,%dl
  800f53:	74 16                	je     800f6b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f b6 d0             	movzbl %al,%edx
  800f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	0f b6 c0             	movzbl %al,%eax
  800f65:	29 c2                	sub    %eax,%edx
  800f67:	89 d0                	mov    %edx,%eax
  800f69:	eb 18                	jmp    800f83 <memcmp+0x50>
		s1++, s2++;
  800f6b:	ff 45 fc             	incl   -0x4(%ebp)
  800f6e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f77:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 c9                	jne    800f47 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f96:	eb 15                	jmp    800fad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	0f b6 c0             	movzbl %al,%eax
  800fa6:	39 c2                	cmp    %eax,%edx
  800fa8:	74 0d                	je     800fb7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800faa:	ff 45 08             	incl   0x8(%ebp)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb3:	72 e3                	jb     800f98 <memfind+0x13>
  800fb5:	eb 01                	jmp    800fb8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb7:	90                   	nop
	return (void *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd1:	eb 03                	jmp    800fd6 <strtol+0x19>
		s++;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 20                	cmp    $0x20,%al
  800fdd:	74 f4                	je     800fd3 <strtol+0x16>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 09                	cmp    $0x9,%al
  800fe6:	74 eb                	je     800fd3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2b                	cmp    $0x2b,%al
  800fef:	75 05                	jne    800ff6 <strtol+0x39>
		s++;
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	eb 13                	jmp    801009 <strtol+0x4c>
	else if (*s == '-')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2d                	cmp    $0x2d,%al
  800ffd:	75 0a                	jne    801009 <strtol+0x4c>
		s++, neg = 1;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	74 06                	je     801015 <strtol+0x58>
  80100f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801013:	75 20                	jne    801035 <strtol+0x78>
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 30                	cmp    $0x30,%al
  80101c:	75 17                	jne    801035 <strtol+0x78>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	40                   	inc    %eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 78                	cmp    $0x78,%al
  801026:	75 0d                	jne    801035 <strtol+0x78>
		s += 2, base = 16;
  801028:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801033:	eb 28                	jmp    80105d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801039:	75 15                	jne    801050 <strtol+0x93>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 30                	cmp    $0x30,%al
  801042:	75 0c                	jne    801050 <strtol+0x93>
		s++, base = 8;
  801044:	ff 45 08             	incl   0x8(%ebp)
  801047:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104e:	eb 0d                	jmp    80105d <strtol+0xa0>
	else if (base == 0)
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	75 07                	jne    80105d <strtol+0xa0>
		base = 10;
  801056:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 2f                	cmp    $0x2f,%al
  801064:	7e 19                	jle    80107f <strtol+0xc2>
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 39                	cmp    $0x39,%al
  80106d:	7f 10                	jg     80107f <strtol+0xc2>
			dig = *s - '0';
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	0f be c0             	movsbl %al,%eax
  801077:	83 e8 30             	sub    $0x30,%eax
  80107a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107d:	eb 42                	jmp    8010c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 60                	cmp    $0x60,%al
  801086:	7e 19                	jle    8010a1 <strtol+0xe4>
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 7a                	cmp    $0x7a,%al
  80108f:	7f 10                	jg     8010a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f be c0             	movsbl %al,%eax
  801099:	83 e8 57             	sub    $0x57,%eax
  80109c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109f:	eb 20                	jmp    8010c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 40                	cmp    $0x40,%al
  8010a8:	7e 39                	jle    8010e3 <strtol+0x126>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 5a                	cmp    $0x5a,%al
  8010b1:	7f 30                	jg     8010e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	0f be c0             	movsbl %al,%eax
  8010bb:	83 e8 37             	sub    $0x37,%eax
  8010be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c7:	7d 19                	jge    8010e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dd:	e9 7b ff ff ff       	jmp    80105d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e7:	74 08                	je     8010f1 <strtol+0x134>
		*endptr = (char *) s;
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f5:	74 07                	je     8010fe <strtol+0x141>
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	f7 d8                	neg    %eax
  8010fc:	eb 03                	jmp    801101 <strtol+0x144>
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <ltostr>:

void
ltostr(long value, char *str)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801110:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801117:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111b:	79 13                	jns    801130 <ltostr+0x2d>
	{
		neg = 1;
  80111d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80112a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801138:	99                   	cltd   
  801139:	f7 f9                	idiv   %ecx
  80113b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801147:	89 c2                	mov    %eax,%edx
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	01 d0                	add    %edx,%eax
  80114e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801151:	83 c2 30             	add    $0x30,%edx
  801154:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801156:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801159:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115e:	f7 e9                	imul   %ecx
  801160:	c1 fa 02             	sar    $0x2,%edx
  801163:	89 c8                	mov    %ecx,%eax
  801165:	c1 f8 1f             	sar    $0x1f,%eax
  801168:	29 c2                	sub    %eax,%edx
  80116a:	89 d0                	mov    %edx,%eax
  80116c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80116f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801173:	75 bb                	jne    801130 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	48                   	dec    %eax
  801180:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801183:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801187:	74 3d                	je     8011c6 <ltostr+0xc3>
		start = 1 ;
  801189:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801190:	eb 34                	jmp    8011c6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 c2                	add    %eax,%edx
  8011a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 c8                	add    %ecx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	01 c2                	add    %eax,%edx
  8011bb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011be:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cc:	7c c4                	jl     801192 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	01 d0                	add    %edx,%eax
  8011d6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011d9:	90                   	nop
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	e8 c4 f9 ff ff       	call   800bae <strlen>
  8011ea:	83 c4 04             	add    $0x4,%esp
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	e8 b6 f9 ff ff       	call   800bae <strlen>
  8011f8:	83 c4 04             	add    $0x4,%esp
  8011fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801205:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120c:	eb 17                	jmp    801225 <strcconcat+0x49>
		final[s] = str1[s] ;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801222:	ff 45 fc             	incl   -0x4(%ebp)
  801225:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801228:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80122b:	7c e1                	jl     80120e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80122d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801234:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80123b:	eb 1f                	jmp    80125c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80123d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801240:	8d 50 01             	lea    0x1(%eax),%edx
  801243:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801246:	89 c2                	mov    %eax,%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 c2                	add    %eax,%edx
  80124d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c8                	add    %ecx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801259:	ff 45 f8             	incl   -0x8(%ebp)
  80125c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801262:	7c d9                	jl     80123d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801264:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801267:	8b 45 10             	mov    0x10(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	c6 00 00             	movb   $0x0,(%eax)
}
  80126f:	90                   	nop
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801275:	8b 45 14             	mov    0x14(%ebp),%eax
  801278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	8b 00                	mov    (%eax),%eax
  801283:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801295:	eb 0c                	jmp    8012a3 <strsplit+0x31>
			*string++ = 0;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	74 18                	je     8012c4 <strsplit+0x52>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	0f be c0             	movsbl %al,%eax
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 0c             	pushl  0xc(%ebp)
  8012b8:	e8 83 fa ff ff       	call   800d40 <strchr>
  8012bd:	83 c4 08             	add    $0x8,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	75 d3                	jne    801297 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	84 c0                	test   %al,%al
  8012cb:	74 5a                	je     801327 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	83 f8 0f             	cmp    $0xf,%eax
  8012d5:	75 07                	jne    8012de <strsplit+0x6c>
		{
			return 0;
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	eb 66                	jmp    801344 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012de:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e1:	8b 00                	mov    (%eax),%eax
  8012e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e6:	8b 55 14             	mov    0x14(%ebp),%edx
  8012e9:	89 0a                	mov    %ecx,(%edx)
  8012eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fc:	eb 03                	jmp    801301 <strsplit+0x8f>
			string++;
  8012fe:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	84 c0                	test   %al,%al
  801308:	74 8b                	je     801295 <strsplit+0x23>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	50                   	push   %eax
  801313:	ff 75 0c             	pushl  0xc(%ebp)
  801316:	e8 25 fa ff ff       	call   800d40 <strchr>
  80131b:	83 c4 08             	add    $0x8,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	74 dc                	je     8012fe <strsplit+0x8c>
			string++;
	}
  801322:	e9 6e ff ff ff       	jmp    801295 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801327:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80133f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801359:	eb 4a                	jmp    8013a5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80135b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	01 c2                	add    %eax,%edx
  801363:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	01 c8                	add    %ecx,%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 40                	cmp    $0x40,%al
  80137b:	7e 25                	jle    8013a2 <str2lower+0x5c>
  80137d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 5a                	cmp    $0x5a,%al
  801389:	7f 17                	jg     8013a2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80138b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	01 d0                	add    %edx,%eax
  801393:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801396:	8b 55 08             	mov    0x8(%ebp),%edx
  801399:	01 ca                	add    %ecx,%edx
  80139b:	8a 12                	mov    (%edx),%dl
  80139d:	83 c2 20             	add    $0x20,%edx
  8013a0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013a2:	ff 45 fc             	incl   -0x4(%ebp)
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	e8 01 f8 ff ff       	call   800bae <strlen>
  8013ad:	83 c4 04             	add    $0x4,%esp
  8013b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013b3:	7f a6                	jg     80135b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013d5:	cd 30                	int    $0x30
  8013d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	6a 00                	push   $0x0
  8013fd:	51                   	push   %ecx
  8013fe:	52                   	push   %edx
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	50                   	push   %eax
  801403:	6a 00                	push   $0x0
  801405:	e8 b0 ff ff ff       	call   8013ba <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	90                   	nop
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_cgetc>:

int
sys_cgetc(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 02                	push   $0x2
  80141f:	e8 96 ff ff ff       	call   8013ba <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 03                	push   $0x3
  801438:	e8 7d ff ff ff       	call   8013ba <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 04                	push   $0x4
  801452:	e8 63 ff ff ff       	call   8013ba <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	52                   	push   %edx
  80146d:	50                   	push   %eax
  80146e:	6a 08                	push   $0x8
  801470:	e8 45 ff ff ff       	call   8013ba <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	56                   	push   %esi
  80147e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80147f:	8b 75 18             	mov    0x18(%ebp),%esi
  801482:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801485:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	56                   	push   %esi
  80148f:	53                   	push   %ebx
  801490:	51                   	push   %ecx
  801491:	52                   	push   %edx
  801492:	50                   	push   %eax
  801493:	6a 09                	push   $0x9
  801495:	e8 20 ff ff ff       	call   8013ba <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	ff 75 08             	pushl  0x8(%ebp)
  8014b2:	6a 0a                	push   $0xa
  8014b4:	e8 01 ff ff ff       	call   8013ba <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	6a 0b                	push   $0xb
  8014cf:	e8 e6 fe ff ff       	call   8013ba <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 0c                	push   $0xc
  8014e8:	e8 cd fe ff ff       	call   8013ba <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 0d                	push   $0xd
  801501:	e8 b4 fe ff ff       	call   8013ba <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 0e                	push   $0xe
  80151a:	e8 9b fe ff ff       	call   8013ba <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 0f                	push   $0xf
  801533:	e8 82 fe ff ff       	call   8013ba <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	6a 10                	push   $0x10
  80154d:	e8 68 fe ff ff       	call   8013ba <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 11                	push   $0x11
  801566:	e8 4f fe ff ff       	call   8013ba <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	90                   	nop
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_cputc>:

void
sys_cputc(const char c)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80157d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	50                   	push   %eax
  80158a:	6a 01                	push   $0x1
  80158c:	e8 29 fe ff ff       	call   8013ba <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 14                	push   $0x14
  8015a6:	e8 0f fe ff ff       	call   8013ba <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	90                   	nop
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	6a 00                	push   $0x0
  8015c9:	51                   	push   %ecx
  8015ca:	52                   	push   %edx
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	50                   	push   %eax
  8015cf:	6a 15                	push   $0x15
  8015d1:	e8 e4 fd ff ff       	call   8013ba <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	52                   	push   %edx
  8015eb:	50                   	push   %eax
  8015ec:	6a 16                	push   $0x16
  8015ee:	e8 c7 fd ff ff       	call   8013ba <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	51                   	push   %ecx
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 17                	push   $0x17
  80160d:	e8 a8 fd ff ff       	call   8013ba <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	52                   	push   %edx
  801627:	50                   	push   %eax
  801628:	6a 18                	push   $0x18
  80162a:	e8 8b fd ff ff       	call   8013ba <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	ff 75 14             	pushl  0x14(%ebp)
  80163f:	ff 75 10             	pushl  0x10(%ebp)
  801642:	ff 75 0c             	pushl  0xc(%ebp)
  801645:	50                   	push   %eax
  801646:	6a 19                	push   $0x19
  801648:	e8 6d fd ff ff       	call   8013ba <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	50                   	push   %eax
  801661:	6a 1a                	push   $0x1a
  801663:	e8 52 fd ff ff       	call   8013ba <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	90                   	nop
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	50                   	push   %eax
  80167d:	6a 1b                	push   $0x1b
  80167f:	e8 36 fd ff ff       	call   8013ba <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 05                	push   $0x5
  801698:	e8 1d fd ff ff       	call   8013ba <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 06                	push   $0x6
  8016b1:	e8 04 fd ff ff       	call   8013ba <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 07                	push   $0x7
  8016ca:	e8 eb fc ff ff       	call   8013ba <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_exit_env>:


void sys_exit_env(void)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 1c                	push   $0x1c
  8016e3:	e8 d2 fc ff ff       	call   8013ba <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	90                   	nop
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f7:	8d 50 04             	lea    0x4(%eax),%edx
  8016fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	52                   	push   %edx
  801704:	50                   	push   %eax
  801705:	6a 1d                	push   $0x1d
  801707:	e8 ae fc ff ff       	call   8013ba <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
	return result;
  80170f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801712:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801715:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801718:	89 01                	mov    %eax,(%ecx)
  80171a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	c9                   	leave  
  801721:	c2 04 00             	ret    $0x4

00801724 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	ff 75 10             	pushl  0x10(%ebp)
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	6a 13                	push   $0x13
  801736:	e8 7f fc ff ff       	call   8013ba <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
	return ;
  80173e:	90                   	nop
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_rcr2>:
uint32 sys_rcr2()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 1e                	push   $0x1e
  801750:	e8 65 fc ff ff       	call   8013ba <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801766:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	50                   	push   %eax
  801773:	6a 1f                	push   $0x1f
  801775:	e8 40 fc ff ff       	call   8013ba <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
	return ;
  80177d:	90                   	nop
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <rsttst>:
void rsttst()
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 21                	push   $0x21
  80178f:	e8 26 fc ff ff       	call   8013ba <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	ff 75 10             	pushl  0x10(%ebp)
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	ff 75 08             	pushl  0x8(%ebp)
  8017b8:	6a 20                	push   $0x20
  8017ba:	e8 fb fb ff ff       	call   8013ba <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c2:	90                   	nop
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <chktst>:
void chktst(uint32 n)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 22                	push   $0x22
  8017d5:	e8 e0 fb ff ff       	call   8013ba <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <inctst>:

void inctst()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 23                	push   $0x23
  8017ef:	e8 c6 fb ff ff       	call   8013ba <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f7:	90                   	nop
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <gettst>:
uint32 gettst()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 24                	push   $0x24
  801809:	e8 ac fb ff ff       	call   8013ba <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 25                	push   $0x25
  801822:	e8 93 fb ff ff       	call   8013ba <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
  80182a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80182f:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 26                	push   $0x26
  80184e:	e8 67 fb ff ff       	call   8013ba <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80185d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801860:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	53                   	push   %ebx
  80186c:	51                   	push   %ecx
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 27                	push   $0x27
  801871:	e8 44 fb ff ff       	call   8013ba <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 28                	push   $0x28
  801891:	e8 24 fb ff ff       	call   8013ba <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80189e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	51                   	push   %ecx
  8018aa:	ff 75 10             	pushl  0x10(%ebp)
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 29                	push   $0x29
  8018b1:	e8 04 fb ff ff       	call   8013ba <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 10             	pushl  0x10(%ebp)
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 12                	push   $0x12
  8018cd:	e8 e8 fa ff ff       	call   8013ba <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	6a 2a                	push   $0x2a
  8018eb:	e8 ca fa ff ff       	call   8013ba <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
	return;
  8018f3:	90                   	nop
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 2b                	push   $0x2b
  801905:	e8 b0 fa ff ff       	call   8013ba <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 2d                	push   $0x2d
  801920:	e8 95 fa ff ff       	call   8013ba <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
	return;
  801928:	90                   	nop
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 2c                	push   $0x2c
  80193c:	e8 79 fa ff ff       	call   8013ba <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return ;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	68 c8 25 80 00       	push   $0x8025c8
  801955:	68 25 01 00 00       	push   $0x125
  80195a:	68 fb 25 80 00       	push   $0x8025fb
  80195f:	e8 be 00 00 00       	call   801a22 <_panic>

00801964 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80196a:	8b 55 08             	mov    0x8(%ebp),%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	c1 e0 02             	shl    $0x2,%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197b:	01 d0                	add    %edx,%eax
  80197d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801984:	01 d0                	add    %edx,%eax
  801986:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c1 e0 04             	shl    $0x4,%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801995:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80199c:	0f 31                	rdtsc  
  80199e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ad:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8019b0:	eb 46                	jmp    8019f8 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019b2:	0f 31                	rdtsc  
  8019b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8019b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cc:	29 c2                	sub    %eax,%edx
  8019ce:	89 d0                	mov    %edx,%eax
  8019d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d9:	89 d1                	mov    %edx,%ecx
  8019db:	29 c1                	sub    %eax,%ecx
  8019dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e3:	39 c2                	cmp    %eax,%edx
  8019e5:	0f 97 c0             	seta   %al
  8019e8:	0f b6 c0             	movzbl %al,%eax
  8019eb:	29 c1                	sub    %eax,%ecx
  8019ed:	89 c8                	mov    %ecx,%eax
  8019ef:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8019f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019fe:	72 b2                	jb     8019b2 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a10:	eb 03                	jmp    801a15 <busy_wait+0x12>
  801a12:	ff 45 fc             	incl   -0x4(%ebp)
  801a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a18:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a1b:	72 f5                	jb     801a12 <busy_wait+0xf>
	return i;
  801a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a28:	8d 45 10             	lea    0x10(%ebp),%eax
  801a2b:	83 c0 04             	add    $0x4,%eax
  801a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a31:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a3a:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	50                   	push   %eax
  801a43:	68 0c 26 80 00       	push   $0x80260c
  801a48:	e8 88 ea ff ff       	call   8004d5 <cprintf>
  801a4d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a50:	a1 04 30 80 00       	mov    0x803004,%eax
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	50                   	push   %eax
  801a5f:	68 14 26 80 00       	push   $0x802614
  801a64:	6a 74                	push   $0x74
  801a66:	e8 97 ea ff ff       	call   800502 <cprintf_colored>
  801a6b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	ff 75 f4             	pushl  -0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	e8 e9 e9 ff ff       	call   800466 <vcprintf>
  801a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	6a 00                	push   $0x0
  801a85:	68 3c 26 80 00       	push   $0x80263c
  801a8a:	e8 d7 e9 ff ff       	call   800466 <vcprintf>
  801a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a92:	e8 50 e9 ff ff       	call   8003e7 <exit>

	// should not return here
	while (1) ;
  801a97:	eb fe                	jmp    801a97 <_panic+0x75>

00801a99 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a9f:	a1 20 30 80 00       	mov    0x803020,%eax
  801aa4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	39 c2                	cmp    %eax,%edx
  801aaf:	74 14                	je     801ac5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	68 40 26 80 00       	push   $0x802640
  801ab9:	6a 26                	push   $0x26
  801abb:	68 8c 26 80 00       	push   $0x80268c
  801ac0:	e8 5d ff ff ff       	call   801a22 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801acc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ad3:	e9 c5 00 00 00       	jmp    801b9d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	01 d0                	add    %edx,%eax
  801ae7:	8b 00                	mov    (%eax),%eax
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	75 08                	jne    801af5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801aed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801af0:	e9 a5 00 00 00       	jmp    801b9a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801af5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801afc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b03:	eb 69                	jmp    801b6e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b05:	a1 20 30 80 00       	mov    0x803020,%eax
  801b0a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b13:	89 d0                	mov    %edx,%eax
  801b15:	01 c0                	add    %eax,%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	c1 e0 03             	shl    $0x3,%eax
  801b1c:	01 c8                	add    %ecx,%eax
  801b1e:	8a 40 04             	mov    0x4(%eax),%al
  801b21:	84 c0                	test   %al,%al
  801b23:	75 46                	jne    801b6b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b25:	a1 20 30 80 00       	mov    0x803020,%eax
  801b2a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	01 c0                	add    %eax,%eax
  801b37:	01 d0                	add    %edx,%eax
  801b39:	c1 e0 03             	shl    $0x3,%eax
  801b3c:	01 c8                	add    %ecx,%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	01 c8                	add    %ecx,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b5e:	39 c2                	cmp    %eax,%edx
  801b60:	75 09                	jne    801b6b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b69:	eb 15                	jmp    801b80 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b6b:	ff 45 e8             	incl   -0x18(%ebp)
  801b6e:	a1 20 30 80 00       	mov    0x803020,%eax
  801b73:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b7c:	39 c2                	cmp    %eax,%edx
  801b7e:	77 85                	ja     801b05 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b84:	75 14                	jne    801b9a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	68 98 26 80 00       	push   $0x802698
  801b8e:	6a 3a                	push   $0x3a
  801b90:	68 8c 26 80 00       	push   $0x80268c
  801b95:	e8 88 fe ff ff       	call   801a22 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b9a:	ff 45 f0             	incl   -0x10(%ebp)
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ba3:	0f 8c 2f ff ff ff    	jl     801ad8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ba9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bb0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bb7:	eb 26                	jmp    801bdf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bb9:	a1 20 30 80 00       	mov    0x803020,%eax
  801bbe:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc7:	89 d0                	mov    %edx,%eax
  801bc9:	01 c0                	add    %eax,%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	c1 e0 03             	shl    $0x3,%eax
  801bd0:	01 c8                	add    %ecx,%eax
  801bd2:	8a 40 04             	mov    0x4(%eax),%al
  801bd5:	3c 01                	cmp    $0x1,%al
  801bd7:	75 03                	jne    801bdc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bd9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bdc:	ff 45 e0             	incl   -0x20(%ebp)
  801bdf:	a1 20 30 80 00       	mov    0x803020,%eax
  801be4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bed:	39 c2                	cmp    %eax,%edx
  801bef:	77 c8                	ja     801bb9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bf7:	74 14                	je     801c0d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 ec 26 80 00       	push   $0x8026ec
  801c01:	6a 44                	push   $0x44
  801c03:	68 8c 26 80 00       	push   $0x80268c
  801c08:	e8 15 fe ff ff       	call   801a22 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <__udivdi3>:
  801c10:	55                   	push   %ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 1c             	sub    $0x1c,%esp
  801c17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c27:	89 ca                	mov    %ecx,%edx
  801c29:	89 f8                	mov    %edi,%eax
  801c2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c2f:	85 f6                	test   %esi,%esi
  801c31:	75 2d                	jne    801c60 <__udivdi3+0x50>
  801c33:	39 cf                	cmp    %ecx,%edi
  801c35:	77 65                	ja     801c9c <__udivdi3+0x8c>
  801c37:	89 fd                	mov    %edi,%ebp
  801c39:	85 ff                	test   %edi,%edi
  801c3b:	75 0b                	jne    801c48 <__udivdi3+0x38>
  801c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c42:	31 d2                	xor    %edx,%edx
  801c44:	f7 f7                	div    %edi
  801c46:	89 c5                	mov    %eax,%ebp
  801c48:	31 d2                	xor    %edx,%edx
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	f7 f5                	div    %ebp
  801c4e:	89 c1                	mov    %eax,%ecx
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	f7 f5                	div    %ebp
  801c54:	89 cf                	mov    %ecx,%edi
  801c56:	89 fa                	mov    %edi,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	39 ce                	cmp    %ecx,%esi
  801c62:	77 28                	ja     801c8c <__udivdi3+0x7c>
  801c64:	0f bd fe             	bsr    %esi,%edi
  801c67:	83 f7 1f             	xor    $0x1f,%edi
  801c6a:	75 40                	jne    801cac <__udivdi3+0x9c>
  801c6c:	39 ce                	cmp    %ecx,%esi
  801c6e:	72 0a                	jb     801c7a <__udivdi3+0x6a>
  801c70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c74:	0f 87 9e 00 00 00    	ja     801d18 <__udivdi3+0x108>
  801c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7f:	89 fa                	mov    %edi,%edx
  801c81:	83 c4 1c             	add    $0x1c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	8d 76 00             	lea    0x0(%esi),%esi
  801c8c:	31 ff                	xor    %edi,%edi
  801c8e:	31 c0                	xor    %eax,%eax
  801c90:	89 fa                	mov    %edi,%edx
  801c92:	83 c4 1c             	add    $0x1c,%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f7                	div    %edi
  801ca0:	31 ff                	xor    %edi,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb1:	89 eb                	mov    %ebp,%ebx
  801cb3:	29 fb                	sub    %edi,%ebx
  801cb5:	89 f9                	mov    %edi,%ecx
  801cb7:	d3 e6                	shl    %cl,%esi
  801cb9:	89 c5                	mov    %eax,%ebp
  801cbb:	88 d9                	mov    %bl,%cl
  801cbd:	d3 ed                	shr    %cl,%ebp
  801cbf:	89 e9                	mov    %ebp,%ecx
  801cc1:	09 f1                	or     %esi,%ecx
  801cc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cc7:	89 f9                	mov    %edi,%ecx
  801cc9:	d3 e0                	shl    %cl,%eax
  801ccb:	89 c5                	mov    %eax,%ebp
  801ccd:	89 d6                	mov    %edx,%esi
  801ccf:	88 d9                	mov    %bl,%cl
  801cd1:	d3 ee                	shr    %cl,%esi
  801cd3:	89 f9                	mov    %edi,%ecx
  801cd5:	d3 e2                	shl    %cl,%edx
  801cd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 e8                	shr    %cl,%eax
  801cdf:	09 c2                	or     %eax,%edx
  801ce1:	89 d0                	mov    %edx,%eax
  801ce3:	89 f2                	mov    %esi,%edx
  801ce5:	f7 74 24 0c          	divl   0xc(%esp)
  801ce9:	89 d6                	mov    %edx,%esi
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	f7 e5                	mul    %ebp
  801cef:	39 d6                	cmp    %edx,%esi
  801cf1:	72 19                	jb     801d0c <__udivdi3+0xfc>
  801cf3:	74 0b                	je     801d00 <__udivdi3+0xf0>
  801cf5:	89 d8                	mov    %ebx,%eax
  801cf7:	31 ff                	xor    %edi,%edi
  801cf9:	e9 58 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d04:	89 f9                	mov    %edi,%ecx
  801d06:	d3 e2                	shl    %cl,%edx
  801d08:	39 c2                	cmp    %eax,%edx
  801d0a:	73 e9                	jae    801cf5 <__udivdi3+0xe5>
  801d0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d0f:	31 ff                	xor    %edi,%edi
  801d11:	e9 40 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	31 c0                	xor    %eax,%eax
  801d1a:	e9 37 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801d1f:	90                   	nop

00801d20 <__umoddi3>:
  801d20:	55                   	push   %ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3f:	89 f3                	mov    %esi,%ebx
  801d41:	89 fa                	mov    %edi,%edx
  801d43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d47:	89 34 24             	mov    %esi,(%esp)
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	75 1a                	jne    801d68 <__umoddi3+0x48>
  801d4e:	39 f7                	cmp    %esi,%edi
  801d50:	0f 86 a2 00 00 00    	jbe    801df8 <__umoddi3+0xd8>
  801d56:	89 c8                	mov    %ecx,%eax
  801d58:	89 f2                	mov    %esi,%edx
  801d5a:	f7 f7                	div    %edi
  801d5c:	89 d0                	mov    %edx,%eax
  801d5e:	31 d2                	xor    %edx,%edx
  801d60:	83 c4 1c             	add    $0x1c,%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    
  801d68:	39 f0                	cmp    %esi,%eax
  801d6a:	0f 87 ac 00 00 00    	ja     801e1c <__umoddi3+0xfc>
  801d70:	0f bd e8             	bsr    %eax,%ebp
  801d73:	83 f5 1f             	xor    $0x1f,%ebp
  801d76:	0f 84 ac 00 00 00    	je     801e28 <__umoddi3+0x108>
  801d7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d81:	29 ef                	sub    %ebp,%edi
  801d83:	89 fe                	mov    %edi,%esi
  801d85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	d3 e0                	shl    %cl,%eax
  801d8d:	89 d7                	mov    %edx,%edi
  801d8f:	89 f1                	mov    %esi,%ecx
  801d91:	d3 ef                	shr    %cl,%edi
  801d93:	09 c7                	or     %eax,%edi
  801d95:	89 e9                	mov    %ebp,%ecx
  801d97:	d3 e2                	shl    %cl,%edx
  801d99:	89 14 24             	mov    %edx,(%esp)
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	d3 e0                	shl    %cl,%eax
  801da0:	89 c2                	mov    %eax,%edx
  801da2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da6:	d3 e0                	shl    %cl,%eax
  801da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db0:	89 f1                	mov    %esi,%ecx
  801db2:	d3 e8                	shr    %cl,%eax
  801db4:	09 d0                	or     %edx,%eax
  801db6:	d3 eb                	shr    %cl,%ebx
  801db8:	89 da                	mov    %ebx,%edx
  801dba:	f7 f7                	div    %edi
  801dbc:	89 d3                	mov    %edx,%ebx
  801dbe:	f7 24 24             	mull   (%esp)
  801dc1:	89 c6                	mov    %eax,%esi
  801dc3:	89 d1                	mov    %edx,%ecx
  801dc5:	39 d3                	cmp    %edx,%ebx
  801dc7:	0f 82 87 00 00 00    	jb     801e54 <__umoddi3+0x134>
  801dcd:	0f 84 91 00 00 00    	je     801e64 <__umoddi3+0x144>
  801dd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd7:	29 f2                	sub    %esi,%edx
  801dd9:	19 cb                	sbb    %ecx,%ebx
  801ddb:	89 d8                	mov    %ebx,%eax
  801ddd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de1:	d3 e0                	shl    %cl,%eax
  801de3:	89 e9                	mov    %ebp,%ecx
  801de5:	d3 ea                	shr    %cl,%edx
  801de7:	09 d0                	or     %edx,%eax
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	d3 eb                	shr    %cl,%ebx
  801ded:	89 da                	mov    %ebx,%edx
  801def:	83 c4 1c             	add    $0x1c,%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5f                   	pop    %edi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    
  801df7:	90                   	nop
  801df8:	89 fd                	mov    %edi,%ebp
  801dfa:	85 ff                	test   %edi,%edi
  801dfc:	75 0b                	jne    801e09 <__umoddi3+0xe9>
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	31 d2                	xor    %edx,%edx
  801e05:	f7 f7                	div    %edi
  801e07:	89 c5                	mov    %eax,%ebp
  801e09:	89 f0                	mov    %esi,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	f7 f5                	div    %ebp
  801e0f:	89 c8                	mov    %ecx,%eax
  801e11:	f7 f5                	div    %ebp
  801e13:	89 d0                	mov    %edx,%eax
  801e15:	e9 44 ff ff ff       	jmp    801d5e <__umoddi3+0x3e>
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	89 c8                	mov    %ecx,%eax
  801e1e:	89 f2                	mov    %esi,%edx
  801e20:	83 c4 1c             	add    $0x1c,%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	3b 04 24             	cmp    (%esp),%eax
  801e2b:	72 06                	jb     801e33 <__umoddi3+0x113>
  801e2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e31:	77 0f                	ja     801e42 <__umoddi3+0x122>
  801e33:	89 f2                	mov    %esi,%edx
  801e35:	29 f9                	sub    %edi,%ecx
  801e37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e3b:	89 14 24             	mov    %edx,(%esp)
  801e3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e46:	8b 14 24             	mov    (%esp),%edx
  801e49:	83 c4 1c             	add    $0x1c,%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5f                   	pop    %edi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    
  801e51:	8d 76 00             	lea    0x0(%esi),%esi
  801e54:	2b 04 24             	sub    (%esp),%eax
  801e57:	19 fa                	sbb    %edi,%edx
  801e59:	89 d1                	mov    %edx,%ecx
  801e5b:	89 c6                	mov    %eax,%esi
  801e5d:	e9 71 ff ff ff       	jmp    801dd3 <__umoddi3+0xb3>
  801e62:	66 90                	xchg   %ax,%ax
  801e64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e68:	72 ea                	jb     801e54 <__umoddi3+0x134>
  801e6a:	89 d9                	mov    %ebx,%ecx
  801e6c:	e9 62 ff ff ff       	jmp    801dd3 <__umoddi3+0xb3>
