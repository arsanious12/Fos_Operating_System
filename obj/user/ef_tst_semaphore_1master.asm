
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 eb 01 00 00       	call   800221 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int envID = sys_getenvid();
  80003e:	e8 25 18 00 00       	call   801868 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 20 1e 80 00       	push   $0x801e20
  800053:	50                   	push   %eax
  800054:	e8 ea 1a 00 00       	call   801b43 <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 24 1e 80 00       	push   $0x801e24
  800069:	50                   	push   %eax
  80006a:	e8 d4 1a 00 00       	call   801b43 <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80007d:	89 c2                	mov    %eax,%edx
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008a:	6a 32                	push   $0x32
  80008c:	52                   	push   %edx
  80008d:	50                   	push   %eax
  80008e:	68 2c 1e 80 00       	push   $0x801e2c
  800093:	e8 7b 17 00 00       	call   801813 <sys_create_env>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000a9:	89 c2                	mov    %eax,%edx
  8000ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b6:	6a 32                	push   $0x32
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 2c 1e 80 00       	push   $0x801e2c
  8000bf:	e8 4f 17 00 00       	call   801813 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000d5:	89 c2                	mov    %eax,%edx
  8000d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e2:	6a 32                	push   $0x32
  8000e4:	52                   	push   %edx
  8000e5:	50                   	push   %eax
  8000e6:	68 2c 1e 80 00       	push   $0x801e2c
  8000eb:	e8 23 17 00 00       	call   801813 <sys_create_env>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000f6:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000fa:	74 0c                	je     800108 <_main+0xd0>
  8000fc:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  800100:	74 06                	je     800108 <_main+0xd0>
  800102:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  800106:	75 14                	jne    80011c <_main+0xe4>
		panic("NO AVAILABLE ENVs...");
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	68 39 1e 80 00       	push   $0x801e39
  800110:	6a 12                	push   $0x12
  800112:	68 50 1e 80 00       	push   $0x801e50
  800117:	e8 ca 02 00 00       	call   8003e6 <_panic>

	sys_run_env(id1);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	e8 0a 17 00 00       	call   801831 <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	ff 75 ec             	pushl  -0x14(%ebp)
  800130:	e8 fc 16 00 00       	call   801831 <sys_run_env>
  800135:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 e8             	pushl  -0x18(%ebp)
  80013e:	e8 ee 16 00 00       	call   801831 <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1) ;
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d4             	pushl  -0x2c(%ebp)
  80014c:	e8 26 1a 00 00       	call   801b77 <wait_semaphore>
  800151:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 18 1a 00 00       	call   801b77 <wait_semaphore>
  80015f:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	ff 75 d4             	pushl  -0x2c(%ebp)
  800168:	e8 0a 1a 00 00       	call   801b77 <wait_semaphore>
  80016d:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	ff 75 d8             	pushl  -0x28(%ebp)
  800176:	e8 30 1a 00 00       	call   801bab <semaphore_count>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 1f 1a 00 00       	call   801bab <semaphore_count>
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800192:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800196:	75 18                	jne    8001b0 <_main+0x178>
  800198:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80019c:	75 12                	jne    8001b0 <_main+0x178>
		cprintf("Test of Semaphores is finished!!\n\n\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 70 1e 80 00       	push   $0x801e70
  8001a6:	e8 09 05 00 00       	call   8006b4 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb 10                	jmp    8001c0 <_main+0x188>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 94 1e 80 00       	push   $0x801e94
  8001b8:	e8 f7 04 00 00       	call   8006b4 <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c0:	e8 d5 16 00 00       	call   80189a <sys_getparentenvid>
  8001c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cc:	7e 50                	jle    80021e <_main+0x1e6>
	{
		sys_destroy_env(id1);
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001d4:	e8 74 16 00 00       	call   80184d <sys_destroy_env>
  8001d9:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e2:	e8 66 16 00 00       	call   80184d <sys_destroy_env>
  8001e7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f0:	e8 58 16 00 00       	call   80184d <sys_destroy_env>
  8001f5:	83 c4 10             	add    $0x10,%esp
		struct semaphore depend0 = get_semaphore(parentenvID, "depend0");
  8001f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	68 df 1e 80 00       	push   $0x801edf
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	50                   	push   %eax
  800207:	e8 51 19 00 00       	call   801b5d <get_semaphore>
  80020c:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(depend0);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 d0             	pushl  -0x30(%ebp)
  800215:	e8 77 19 00 00       	call   801b91 <signal_semaphore>
  80021a:	83 c4 10             	add    $0x10,%esp
//		int *finishedCount = NULL;
//		finishedCount = sget(parentenvID, "finishedCount") ;
//		(*finishedCount)++ ;
	}

	return;
  80021d:	90                   	nop
  80021e:	90                   	nop
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80022a:	e8 52 16 00 00       	call   801881 <sys_getenvindex>
  80022f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	c1 e0 06             	shl    $0x6,%eax
  80023a:	29 d0                	sub    %edx,%eax
  80023c:	c1 e0 02             	shl    $0x2,%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800248:	01 c8                	add    %ecx,%eax
  80024a:	c1 e0 03             	shl    $0x3,%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800256:	29 c2                	sub    %eax,%edx
  800258:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80025f:	89 c2                	mov    %eax,%edx
  800261:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800267:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8a 40 20             	mov    0x20(%eax),%al
  800274:	84 c0                	test   %al,%al
  800276:	74 0d                	je     800285 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	83 c0 20             	add    $0x20,%eax
  800280:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800289:	7e 0a                	jle    800295 <libmain+0x74>
		binaryname = argv[0];
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	8b 00                	mov    (%eax),%eax
  800290:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 08             	pushl  0x8(%ebp)
  80029e:	e8 95 fd ff ff       	call   800038 <_main>
  8002a3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ab:	85 c0                	test   %eax,%eax
  8002ad:	0f 84 01 01 00 00    	je     8003b4 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002b3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002b9:	bb e0 1f 80 00       	mov    $0x801fe0,%ebx
  8002be:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002c3:	89 c7                	mov    %eax,%edi
  8002c5:	89 de                	mov    %ebx,%esi
  8002c7:	89 d1                	mov    %edx,%ecx
  8002c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002cb:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002ce:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002d3:	b0 00                	mov    $0x0,%al
  8002d5:	89 d7                	mov    %edx,%edi
  8002d7:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ed:	50                   	push   %eax
  8002ee:	e8 c4 17 00 00       	call   801ab7 <sys_utilities>
  8002f3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002f6:	e8 0d 13 00 00       	call   801608 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 00 1f 80 00       	push   $0x801f00
  800303:	e8 ac 03 00 00       	call   8006b4 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80030b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030e:	85 c0                	test   %eax,%eax
  800310:	74 18                	je     80032a <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800312:	e8 be 17 00 00       	call   801ad5 <sys_get_optimal_num_faults>
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	50                   	push   %eax
  80031b:	68 28 1f 80 00       	push   $0x801f28
  800320:	e8 8f 03 00 00       	call   8006b4 <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	eb 59                	jmp    800383 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80032a:	a1 20 30 80 00       	mov    0x803020,%eax
  80032f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800335:	a1 20 30 80 00       	mov    0x803020,%eax
  80033a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800340:	83 ec 04             	sub    $0x4,%esp
  800343:	52                   	push   %edx
  800344:	50                   	push   %eax
  800345:	68 4c 1f 80 00       	push   $0x801f4c
  80034a:	e8 65 03 00 00       	call   8006b4 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80035d:	a1 20 30 80 00       	mov    0x803020,%eax
  800362:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800368:	a1 20 30 80 00       	mov    0x803020,%eax
  80036d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800373:	51                   	push   %ecx
  800374:	52                   	push   %edx
  800375:	50                   	push   %eax
  800376:	68 74 1f 80 00       	push   $0x801f74
  80037b:	e8 34 03 00 00       	call   8006b4 <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800383:	a1 20 30 80 00       	mov    0x803020,%eax
  800388:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	50                   	push   %eax
  800392:	68 cc 1f 80 00       	push   $0x801fcc
  800397:	e8 18 03 00 00       	call   8006b4 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	68 00 1f 80 00       	push   $0x801f00
  8003a7:	e8 08 03 00 00       	call   8006b4 <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003af:	e8 6e 12 00 00       	call   801622 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003b4:	e8 1f 00 00 00       	call   8003d8 <exit>
}
  8003b9:	90                   	nop
  8003ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bd:	5b                   	pop    %ebx
  8003be:	5e                   	pop    %esi
  8003bf:	5f                   	pop    %edi
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003c8:	83 ec 0c             	sub    $0xc,%esp
  8003cb:	6a 00                	push   $0x0
  8003cd:	e8 7b 14 00 00       	call   80184d <sys_destroy_env>
  8003d2:	83 c4 10             	add    $0x10,%esp
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <exit>:

void
exit(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003de:	e8 d0 14 00 00       	call   8018b3 <sys_exit_env>
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003ec:	8d 45 10             	lea    0x10(%ebp),%eax
  8003ef:	83 c0 04             	add    $0x4,%eax
  8003f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003f5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003fa:	85 c0                	test   %eax,%eax
  8003fc:	74 16                	je     800414 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003fe:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	50                   	push   %eax
  800407:	68 44 20 80 00       	push   $0x802044
  80040c:	e8 a3 02 00 00       	call   8006b4 <cprintf>
  800411:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800414:	a1 04 30 80 00       	mov    0x803004,%eax
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	ff 75 0c             	pushl  0xc(%ebp)
  80041f:	ff 75 08             	pushl  0x8(%ebp)
  800422:	50                   	push   %eax
  800423:	68 4c 20 80 00       	push   $0x80204c
  800428:	6a 74                	push   $0x74
  80042a:	e8 b2 02 00 00       	call   8006e1 <cprintf_colored>
  80042f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800432:	8b 45 10             	mov    0x10(%ebp),%eax
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	ff 75 f4             	pushl  -0xc(%ebp)
  80043b:	50                   	push   %eax
  80043c:	e8 04 02 00 00       	call   800645 <vcprintf>
  800441:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	6a 00                	push   $0x0
  800449:	68 74 20 80 00       	push   $0x802074
  80044e:	e8 f2 01 00 00       	call   800645 <vcprintf>
  800453:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800456:	e8 7d ff ff ff       	call   8003d8 <exit>

	// should not return here
	while (1) ;
  80045b:	eb fe                	jmp    80045b <_panic+0x75>

0080045d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800471:	39 c2                	cmp    %eax,%edx
  800473:	74 14                	je     800489 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 78 20 80 00       	push   $0x802078
  80047d:	6a 26                	push   $0x26
  80047f:	68 c4 20 80 00       	push   $0x8020c4
  800484:	e8 5d ff ff ff       	call   8003e6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800497:	e9 c5 00 00 00       	jmp    800561 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	75 08                	jne    8004b9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004b1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004b4:	e9 a5 00 00 00       	jmp    80055e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004c7:	eb 69                	jmp    800532 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ce:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004d7:	89 d0                	mov    %edx,%eax
  8004d9:	01 c0                	add    %eax,%eax
  8004db:	01 d0                	add    %edx,%eax
  8004dd:	c1 e0 03             	shl    $0x3,%eax
  8004e0:	01 c8                	add    %ecx,%eax
  8004e2:	8a 40 04             	mov    0x4(%eax),%al
  8004e5:	84 c0                	test   %al,%al
  8004e7:	75 46                	jne    80052f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ee:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f7:	89 d0                	mov    %edx,%eax
  8004f9:	01 c0                	add    %eax,%eax
  8004fb:	01 d0                	add    %edx,%eax
  8004fd:	c1 e0 03             	shl    $0x3,%eax
  800500:	01 c8                	add    %ecx,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800507:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80050f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800514:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	01 c8                	add    %ecx,%eax
  800520:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800522:	39 c2                	cmp    %eax,%edx
  800524:	75 09                	jne    80052f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800526:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80052d:	eb 15                	jmp    800544 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052f:	ff 45 e8             	incl   -0x18(%ebp)
  800532:	a1 20 30 80 00       	mov    0x803020,%eax
  800537:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80053d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800540:	39 c2                	cmp    %eax,%edx
  800542:	77 85                	ja     8004c9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800544:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800548:	75 14                	jne    80055e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 d0 20 80 00       	push   $0x8020d0
  800552:	6a 3a                	push   $0x3a
  800554:	68 c4 20 80 00       	push   $0x8020c4
  800559:	e8 88 fe ff ff       	call   8003e6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80055e:	ff 45 f0             	incl   -0x10(%ebp)
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800564:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800567:	0f 8c 2f ff ff ff    	jl     80049c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80056d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800574:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057b:	eb 26                	jmp    8005a3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80057d:	a1 20 30 80 00       	mov    0x803020,%eax
  800582:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058b:	89 d0                	mov    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	c1 e0 03             	shl    $0x3,%eax
  800594:	01 c8                	add    %ecx,%eax
  800596:	8a 40 04             	mov    0x4(%eax),%al
  800599:	3c 01                	cmp    $0x1,%al
  80059b:	75 03                	jne    8005a0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80059d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a0:	ff 45 e0             	incl   -0x20(%ebp)
  8005a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 c8                	ja     80057d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 24 21 80 00       	push   $0x802124
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 c4 20 80 00       	push   $0x8020c4
  8005cc:	e8 15 fe ff ff       	call   8003e6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	53                   	push   %ebx
  8005d8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e6:	89 0a                	mov    %ecx,(%edx)
  8005e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8005eb:	88 d1                	mov    %dl,%cl
  8005ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fe:	75 30                	jne    800630 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800600:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800606:	a0 44 30 80 00       	mov    0x803044,%al
  80060b:	0f b6 c0             	movzbl %al,%eax
  80060e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800611:	8b 09                	mov    (%ecx),%ecx
  800613:	89 cb                	mov    %ecx,%ebx
  800615:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800618:	83 c1 08             	add    $0x8,%ecx
  80061b:	52                   	push   %edx
  80061c:	50                   	push   %eax
  80061d:	53                   	push   %ebx
  80061e:	51                   	push   %ecx
  80061f:	e8 a0 0f 00 00       	call   8015c4 <sys_cputs>
  800624:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	8b 40 04             	mov    0x4(%eax),%eax
  800636:	8d 50 01             	lea    0x1(%eax),%edx
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063f:	90                   	nop
  800640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 d4 05 80 00       	push   $0x8005d4
  800674:	e8 5a 02 00 00       	call   8008d3 <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80067c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800682:	a0 44 30 80 00       	mov    0x803044,%al
  800687:	0f b6 c0             	movzbl %al,%eax
  80068a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	51                   	push   %ecx
  800693:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800699:	83 c0 08             	add    $0x8,%eax
  80069c:	50                   	push   %eax
  80069d:	e8 22 0f 00 00       	call   8015c4 <sys_cputs>
  8006a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a5:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ba:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	e8 6f ff ff ff       	call   800645 <vcprintf>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006e7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	c1 e0 08             	shl    $0x8,%eax
  8006f4:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8006f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006fc:	83 c0 04             	add    $0x4,%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 f4             	pushl  -0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	e8 34 ff ff ff       	call   800645 <vcprintf>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800717:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80071e:	07 00 00 

	return cnt;
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80072c:	e8 d7 0e 00 00       	call   801608 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800731:	8d 45 0c             	lea    0xc(%ebp),%eax
  800734:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 f4             	pushl  -0xc(%ebp)
  800740:	50                   	push   %eax
  800741:	e8 ff fe ff ff       	call   800645 <vcprintf>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80074c:	e8 d1 0e 00 00       	call   801622 <sys_unlock_cons>
	return cnt;
  800751:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800754:	c9                   	leave  
  800755:	c3                   	ret    

00800756 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	53                   	push   %ebx
  80075a:	83 ec 14             	sub    $0x14,%esp
  80075d:	8b 45 10             	mov    0x10(%ebp),%eax
  800760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800769:	8b 45 18             	mov    0x18(%ebp),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800774:	77 55                	ja     8007cb <printnum+0x75>
  800776:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800779:	72 05                	jb     800780 <printnum+0x2a>
  80077b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80077e:	77 4b                	ja     8007cb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800780:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800783:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800786:	8b 45 18             	mov    0x18(%ebp),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	ff 75 f4             	pushl  -0xc(%ebp)
  800793:	ff 75 f0             	pushl  -0x10(%ebp)
  800796:	e8 1d 14 00 00       	call   801bb8 <__udivdi3>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	ff 75 20             	pushl  0x20(%ebp)
  8007a4:	53                   	push   %ebx
  8007a5:	ff 75 18             	pushl  0x18(%ebp)
  8007a8:	52                   	push   %edx
  8007a9:	50                   	push   %eax
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	ff 75 08             	pushl  0x8(%ebp)
  8007b0:	e8 a1 ff ff ff       	call   800756 <printnum>
  8007b5:	83 c4 20             	add    $0x20,%esp
  8007b8:	eb 1a                	jmp    8007d4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	ff 75 20             	pushl  0x20(%ebp)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	ff d0                	call   *%eax
  8007c8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007cb:	ff 4d 1c             	decl   0x1c(%ebp)
  8007ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007d2:	7f e6                	jg     8007ba <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e2:	53                   	push   %ebx
  8007e3:	51                   	push   %ecx
  8007e4:	52                   	push   %edx
  8007e5:	50                   	push   %eax
  8007e6:	e8 dd 14 00 00       	call   801cc8 <__umoddi3>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	05 94 23 80 00       	add    $0x802394,%eax
  8007f3:	8a 00                	mov    (%eax),%al
  8007f5:	0f be c0             	movsbl %al,%eax
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	50                   	push   %eax
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
}
  800807:	90                   	nop
  800808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800810:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800814:	7e 1c                	jle    800832 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	8d 50 08             	lea    0x8(%eax),%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	89 10                	mov    %edx,(%eax)
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	83 e8 08             	sub    $0x8,%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	eb 40                	jmp    800872 <getuint+0x65>
	else if (lflag)
  800832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800836:	74 1e                	je     800856 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	8d 50 04             	lea    0x4(%eax),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	89 10                	mov    %edx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	ba 00 00 00 00       	mov    $0x0,%edx
  800854:	eb 1c                	jmp    800872 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800877:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80087b:	7e 1c                	jle    800899 <getint+0x25>
		return va_arg(*ap, long long);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 08             	lea    0x8(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 08             	sub    $0x8,%eax
  800892:	8b 50 04             	mov    0x4(%eax),%edx
  800895:	8b 00                	mov    (%eax),%eax
  800897:	eb 38                	jmp    8008d1 <getint+0x5d>
	else if (lflag)
  800899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089d:	74 1a                	je     8008b9 <getint+0x45>
		return va_arg(*ap, long);
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 50 04             	lea    0x4(%eax),%edx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 10                	mov    %edx,(%eax)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	99                   	cltd   
  8008b7:	eb 18                	jmp    8008d1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 04             	lea    0x4(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	99                   	cltd   
}
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	56                   	push   %esi
  8008d7:	53                   	push   %ebx
  8008d8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008db:	eb 17                	jmp    8008f4 <vprintfmt+0x21>
			if (ch == '\0')
  8008dd:	85 db                	test   %ebx,%ebx
  8008df:	0f 84 c1 03 00 00    	je     800ca6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	53                   	push   %ebx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	ff d0                	call   *%eax
  8008f1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f7:	8d 50 01             	lea    0x1(%eax),%edx
  8008fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8008fd:	8a 00                	mov    (%eax),%al
  8008ff:	0f b6 d8             	movzbl %al,%ebx
  800902:	83 fb 25             	cmp    $0x25,%ebx
  800905:	75 d6                	jne    8008dd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800907:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80090b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800912:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800919:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800920:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800927:	8b 45 10             	mov    0x10(%ebp),%eax
  80092a:	8d 50 01             	lea    0x1(%eax),%edx
  80092d:	89 55 10             	mov    %edx,0x10(%ebp)
  800930:	8a 00                	mov    (%eax),%al
  800932:	0f b6 d8             	movzbl %al,%ebx
  800935:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800938:	83 f8 5b             	cmp    $0x5b,%eax
  80093b:	0f 87 3d 03 00 00    	ja     800c7e <vprintfmt+0x3ab>
  800941:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  800948:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80094a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80094e:	eb d7                	jmp    800927 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800950:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800954:	eb d1                	jmp    800927 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800956:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80095d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800960:	89 d0                	mov    %edx,%eax
  800962:	c1 e0 02             	shl    $0x2,%eax
  800965:	01 d0                	add    %edx,%eax
  800967:	01 c0                	add    %eax,%eax
  800969:	01 d8                	add    %ebx,%eax
  80096b:	83 e8 30             	sub    $0x30,%eax
  80096e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800971:	8b 45 10             	mov    0x10(%ebp),%eax
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800979:	83 fb 2f             	cmp    $0x2f,%ebx
  80097c:	7e 3e                	jle    8009bc <vprintfmt+0xe9>
  80097e:	83 fb 39             	cmp    $0x39,%ebx
  800981:	7f 39                	jg     8009bc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800983:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800986:	eb d5                	jmp    80095d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80099c:	eb 1f                	jmp    8009bd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	79 83                	jns    800927 <vprintfmt+0x54>
				width = 0;
  8009a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ab:	e9 77 ff ff ff       	jmp    800927 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009b0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009b7:	e9 6b ff ff ff       	jmp    800927 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009bc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c1:	0f 89 60 ff ff ff    	jns    800927 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009d4:	e9 4e ff ff ff       	jmp    800927 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009d9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009dc:	e9 46 ff ff ff       	jmp    800927 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	83 c0 04             	add    $0x4,%eax
  8009e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 e8 04             	sub    $0x4,%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	50                   	push   %eax
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
			break;
  800a01:	e9 9b 02 00 00       	jmp    800ca1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	83 c0 04             	add    $0x4,%eax
  800a0c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	83 e8 04             	sub    $0x4,%eax
  800a15:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a17:	85 db                	test   %ebx,%ebx
  800a19:	79 02                	jns    800a1d <vprintfmt+0x14a>
				err = -err;
  800a1b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a1d:	83 fb 64             	cmp    $0x64,%ebx
  800a20:	7f 0b                	jg     800a2d <vprintfmt+0x15a>
  800a22:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  800a29:	85 f6                	test   %esi,%esi
  800a2b:	75 19                	jne    800a46 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a2d:	53                   	push   %ebx
  800a2e:	68 a5 23 80 00       	push   $0x8023a5
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	ff 75 08             	pushl  0x8(%ebp)
  800a39:	e8 70 02 00 00       	call   800cae <printfmt>
  800a3e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a41:	e9 5b 02 00 00       	jmp    800ca1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a46:	56                   	push   %esi
  800a47:	68 ae 23 80 00       	push   $0x8023ae
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	ff 75 08             	pushl  0x8(%ebp)
  800a52:	e8 57 02 00 00       	call   800cae <printfmt>
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 42 02 00 00       	jmp    800ca1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	83 c0 04             	add    $0x4,%eax
  800a65:	89 45 14             	mov    %eax,0x14(%ebp)
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 e8 04             	sub    $0x4,%eax
  800a6e:	8b 30                	mov    (%eax),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 05                	jne    800a79 <vprintfmt+0x1a6>
				p = "(null)";
  800a74:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  800a79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7d:	7e 6d                	jle    800aec <vprintfmt+0x219>
  800a7f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a83:	74 67                	je     800aec <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	50                   	push   %eax
  800a8c:	56                   	push   %esi
  800a8d:	e8 1e 03 00 00       	call   800db0 <strnlen>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a98:	eb 16                	jmp    800ab0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a9a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	50                   	push   %eax
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aad:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab4:	7f e4                	jg     800a9a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab6:	eb 34                	jmp    800aec <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ab8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800abc:	74 1c                	je     800ada <vprintfmt+0x207>
  800abe:	83 fb 1f             	cmp    $0x1f,%ebx
  800ac1:	7e 05                	jle    800ac8 <vprintfmt+0x1f5>
  800ac3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ac6:	7e 12                	jle    800ada <vprintfmt+0x207>
					putch('?', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 3f                	push   $0x3f
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	eb 0f                	jmp    800ae9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	53                   	push   %ebx
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae9:	ff 4d e4             	decl   -0x1c(%ebp)
  800aec:	89 f0                	mov    %esi,%eax
  800aee:	8d 70 01             	lea    0x1(%eax),%esi
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	0f be d8             	movsbl %al,%ebx
  800af6:	85 db                	test   %ebx,%ebx
  800af8:	74 24                	je     800b1e <vprintfmt+0x24b>
  800afa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800afe:	78 b8                	js     800ab8 <vprintfmt+0x1e5>
  800b00:	ff 4d e0             	decl   -0x20(%ebp)
  800b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b07:	79 af                	jns    800ab8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b09:	eb 13                	jmp    800b1e <vprintfmt+0x24b>
				putch(' ', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 20                	push   $0x20
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b22:	7f e7                	jg     800b0b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b24:	e9 78 01 00 00       	jmp    800ca1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 3c fd ff ff       	call   800874 <getint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b47:	85 d2                	test   %edx,%edx
  800b49:	79 23                	jns    800b6e <vprintfmt+0x29b>
				putch('-', putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	6a 2d                	push   $0x2d
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	ff d0                	call   *%eax
  800b58:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b61:	f7 d8                	neg    %eax
  800b63:	83 d2 00             	adc    $0x0,%edx
  800b66:	f7 da                	neg    %edx
  800b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b75:	e9 bc 00 00 00       	jmp    800c36 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b80:	8d 45 14             	lea    0x14(%ebp),%eax
  800b83:	50                   	push   %eax
  800b84:	e8 84 fc ff ff       	call   80080d <getuint>
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b92:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b99:	e9 98 00 00 00       	jmp    800c36 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 58                	push   $0x58
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 58                	push   $0x58
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	6a 58                	push   $0x58
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	ff d0                	call   *%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
			break;
  800bce:	e9 ce 00 00 00       	jmp    800ca1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 30                	push   $0x30
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	6a 78                	push   $0x78
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	ff d0                	call   *%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bf3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf6:	83 c0 04             	add    $0x4,%eax
  800bf9:	89 45 14             	mov    %eax,0x14(%ebp)
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	83 e8 04             	sub    $0x4,%eax
  800c02:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c0e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c15:	eb 1f                	jmp    800c36 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c20:	50                   	push   %eax
  800c21:	e8 e7 fb ff ff       	call   80080d <getuint>
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c2f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c36:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c3d:	83 ec 04             	sub    $0x4,%esp
  800c40:	52                   	push   %edx
  800c41:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c44:	50                   	push   %eax
  800c45:	ff 75 f4             	pushl  -0xc(%ebp)
  800c48:	ff 75 f0             	pushl  -0x10(%ebp)
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	ff 75 08             	pushl  0x8(%ebp)
  800c51:	e8 00 fb ff ff       	call   800756 <printnum>
  800c56:	83 c4 20             	add    $0x20,%esp
			break;
  800c59:	eb 46                	jmp    800ca1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	53                   	push   %ebx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			break;
  800c6a:	eb 35                	jmp    800ca1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c6c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c73:	eb 2c                	jmp    800ca1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c75:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c7c:	eb 23                	jmp    800ca1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 25                	push   $0x25
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c8e:	ff 4d 10             	decl   0x10(%ebp)
  800c91:	eb 03                	jmp    800c96 <vprintfmt+0x3c3>
  800c93:	ff 4d 10             	decl   0x10(%ebp)
  800c96:	8b 45 10             	mov    0x10(%ebp),%eax
  800c99:	48                   	dec    %eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3c 25                	cmp    $0x25,%al
  800c9e:	75 f3                	jne    800c93 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ca0:	90                   	nop
		}
	}
  800ca1:	e9 35 fc ff ff       	jmp    8008db <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ca6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ca7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cb4:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb7:	83 c0 04             	add    $0x4,%eax
  800cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc3:	50                   	push   %eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	e8 04 fc ff ff       	call   8008d3 <vprintfmt>
  800ccf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cd2:	90                   	nop
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	8b 40 08             	mov    0x8(%eax),%eax
  800cde:	8d 50 01             	lea    0x1(%eax),%edx
  800ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8b 10                	mov    (%eax),%edx
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	39 c2                	cmp    %eax,%edx
  800cf4:	73 12                	jae    800d08 <sprintputch+0x33>
		*b->buf++ = ch;
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8b 00                	mov    (%eax),%eax
  800cfb:	8d 48 01             	lea    0x1(%eax),%ecx
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d01:	89 0a                	mov    %ecx,(%edx)
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	88 10                	mov    %dl,(%eax)
}
  800d08:	90                   	nop
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	01 d0                	add    %edx,%eax
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d30:	74 06                	je     800d38 <vsnprintf+0x2d>
  800d32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d36:	7f 07                	jg     800d3f <vsnprintf+0x34>
		return -E_INVAL;
  800d38:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3d:	eb 20                	jmp    800d5f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d3f:	ff 75 14             	pushl  0x14(%ebp)
  800d42:	ff 75 10             	pushl  0x10(%ebp)
  800d45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d48:	50                   	push   %eax
  800d49:	68 d5 0c 80 00       	push   $0x800cd5
  800d4e:	e8 80 fb ff ff       	call   8008d3 <vprintfmt>
  800d53:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d67:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6a:	83 c0 04             	add    $0x4,%eax
  800d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	ff 75 f4             	pushl  -0xc(%ebp)
  800d76:	50                   	push   %eax
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	ff 75 08             	pushl  0x8(%ebp)
  800d7d:	e8 89 ff ff ff       	call   800d0b <vsnprintf>
  800d82:	83 c4 10             	add    $0x10,%esp
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d9a:	eb 06                	jmp    800da2 <strlen+0x15>
		n++;
  800d9c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	84 c0                	test   %al,%al
  800da9:	75 f1                	jne    800d9c <strlen+0xf>
		n++;
	return n;
  800dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbd:	eb 09                	jmp    800dc8 <strnlen+0x18>
		n++;
  800dbf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	ff 4d 0c             	decl   0xc(%ebp)
  800dc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcc:	74 09                	je     800dd7 <strnlen+0x27>
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	84 c0                	test   %al,%al
  800dd5:	75 e8                	jne    800dbf <strnlen+0xf>
		n++;
	return n;
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800de8:	90                   	nop
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8d 50 01             	lea    0x1(%eax),%edx
  800def:	89 55 08             	mov    %edx,0x8(%ebp)
  800df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dfb:	8a 12                	mov    (%edx),%dl
  800dfd:	88 10                	mov    %dl,(%eax)
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 e4                	jne    800de9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e1d:	eb 1f                	jmp    800e3e <strncpy+0x34>
		*dst++ = *src;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8d 50 01             	lea    0x1(%eax),%edx
  800e25:	89 55 08             	mov    %edx,0x8(%ebp)
  800e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2b:	8a 12                	mov    (%edx),%dl
  800e2d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	84 c0                	test   %al,%al
  800e36:	74 03                	je     800e3b <strncpy+0x31>
			src++;
  800e38:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e3b:	ff 45 fc             	incl   -0x4(%ebp)
  800e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e41:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e44:	72 d9                	jb     800e1f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 30                	je     800e8d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e5d:	eb 16                	jmp    800e75 <strlcpy+0x2a>
			*dst++ = *src++;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8d 50 01             	lea    0x1(%eax),%edx
  800e65:	89 55 08             	mov    %edx,0x8(%ebp)
  800e68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e71:	8a 12                	mov    (%edx),%dl
  800e73:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e75:	ff 4d 10             	decl   0x10(%ebp)
  800e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7c:	74 09                	je     800e87 <strlcpy+0x3c>
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	75 d8                	jne    800e5f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e93:	29 c2                	sub    %eax,%edx
  800e95:	89 d0                	mov    %edx,%eax
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e9c:	eb 06                	jmp    800ea4 <strcmp+0xb>
		p++, q++;
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	84 c0                	test   %al,%al
  800eab:	74 0e                	je     800ebb <strcmp+0x22>
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 10                	mov    (%eax),%dl
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	38 c2                	cmp    %al,%dl
  800eb9:	74 e3                	je     800e9e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	0f b6 d0             	movzbl %al,%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 c0             	movzbl %al,%eax
  800ecb:	29 c2                	sub    %eax,%edx
  800ecd:	89 d0                	mov    %edx,%eax
}
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ed4:	eb 09                	jmp    800edf <strncmp+0xe>
		n--, p++, q++;
  800ed6:	ff 4d 10             	decl   0x10(%ebp)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	74 17                	je     800efc <strncmp+0x2b>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	74 0e                	je     800efc <strncmp+0x2b>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 da                	je     800ed6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	75 07                	jne    800f09 <strncmp+0x38>
		return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
  800f07:	eb 14                	jmp    800f1d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	0f b6 d0             	movzbl %al,%edx
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f b6 c0             	movzbl %al,%eax
  800f19:	29 c2                	sub    %eax,%edx
  800f1b:	89 d0                	mov    %edx,%eax
}
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 04             	sub    $0x4,%esp
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f2b:	eb 12                	jmp    800f3f <strchr+0x20>
		if (*s == c)
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f35:	75 05                	jne    800f3c <strchr+0x1d>
			return (char *) s;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	eb 11                	jmp    800f4d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f3c:	ff 45 08             	incl   0x8(%ebp)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	75 e5                	jne    800f2d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 04             	sub    $0x4,%esp
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5b:	eb 0d                	jmp    800f6a <strfind+0x1b>
		if (*s == c)
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f65:	74 0e                	je     800f75 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	84 c0                	test   %al,%al
  800f71:	75 ea                	jne    800f5d <strfind+0xe>
  800f73:	eb 01                	jmp    800f76 <strfind+0x27>
		if (*s == c)
			break;
  800f75:	90                   	nop
	return (char *) s;
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f87:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8b:	76 63                	jbe    800ff0 <memset+0x75>
		uint64 data_block = c;
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	99                   	cltd   
  800f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f94:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fa1:	c1 e0 08             	shl    $0x8,%eax
  800fa4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fa7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fb4:	c1 e0 10             	shl    $0x10,%eax
  800fb7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fba:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc3:	89 c2                	mov    %eax,%edx
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fca:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fcd:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fd0:	eb 18                	jmp    800fea <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fd2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd5:	8d 41 08             	lea    0x8(%ecx),%eax
  800fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	89 01                	mov    %eax,(%ecx)
  800fe3:	89 51 04             	mov    %edx,0x4(%ecx)
  800fe6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fea:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fee:	77 e2                	ja     800fd2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ff0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff4:	74 23                	je     801019 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ffc:	eb 0e                	jmp    80100c <memset+0x91>
			*p8++ = (uint8)c;
  800ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801001:	8d 50 01             	lea    0x1(%eax),%edx
  801004:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 e5                	jne    800ffe <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801030:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801034:	76 24                	jbe    80105a <memcpy+0x3c>
		while(n >= 8){
  801036:	eb 1c                	jmp    801054 <memcpy+0x36>
			*d64 = *s64;
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	8b 50 04             	mov    0x4(%eax),%edx
  80103e:	8b 00                	mov    (%eax),%eax
  801040:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801043:	89 01                	mov    %eax,(%ecx)
  801045:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801048:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80104c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801050:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801054:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801058:	77 de                	ja     801038 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80105a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105e:	74 31                	je     801091 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801063:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80106c:	eb 16                	jmp    801084 <memcpy+0x66>
			*d8++ = *s8++;
  80106e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801080:	8a 12                	mov    (%edx),%dl
  801082:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108a:	89 55 10             	mov    %edx,0x10(%ebp)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	75 dd                	jne    80106e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ae:	73 50                	jae    801100 <memmove+0x6a>
  8010b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	01 d0                	add    %edx,%eax
  8010b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010bb:	76 43                	jbe    801100 <memmove+0x6a>
		s += n;
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010c9:	eb 10                	jmp    8010db <memmove+0x45>
			*--d = *--s;
  8010cb:	ff 4d f8             	decl   -0x8(%ebp)
  8010ce:	ff 4d fc             	decl   -0x4(%ebp)
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	8a 10                	mov    (%eax),%dl
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	75 e3                	jne    8010cb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010e8:	eb 23                	jmp    80110d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	8d 50 ff             	lea    -0x1(%eax),%edx
  801106:	89 55 10             	mov    %edx,0x10(%ebp)
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 dd                	jne    8010ea <memmove+0x54>
			*d++ = *s++;

	return dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801124:	eb 2a                	jmp    801150 <memcmp+0x3e>
		if (*s1 != *s2)
  801126:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801129:	8a 10                	mov    (%eax),%dl
  80112b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	38 c2                	cmp    %al,%dl
  801132:	74 16                	je     80114a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f b6 d0             	movzbl %al,%edx
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 c0             	movzbl %al,%eax
  801144:	29 c2                	sub    %eax,%edx
  801146:	89 d0                	mov    %edx,%eax
  801148:	eb 18                	jmp    801162 <memcmp+0x50>
		s1++, s2++;
  80114a:	ff 45 fc             	incl   -0x4(%ebp)
  80114d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	8d 50 ff             	lea    -0x1(%eax),%edx
  801156:	89 55 10             	mov    %edx,0x10(%ebp)
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 c9                	jne    801126 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80116a:	8b 55 08             	mov    0x8(%ebp),%edx
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	01 d0                	add    %edx,%eax
  801172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801175:	eb 15                	jmp    80118c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 d0             	movzbl %al,%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	0f b6 c0             	movzbl %al,%eax
  801185:	39 c2                	cmp    %eax,%edx
  801187:	74 0d                	je     801196 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801189:	ff 45 08             	incl   0x8(%ebp)
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801192:	72 e3                	jb     801177 <memfind+0x13>
  801194:	eb 01                	jmp    801197 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801196:	90                   	nop
	return (void *) s;
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b0:	eb 03                	jmp    8011b5 <strtol+0x19>
		s++;
  8011b2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 20                	cmp    $0x20,%al
  8011bc:	74 f4                	je     8011b2 <strtol+0x16>
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 09                	cmp    $0x9,%al
  8011c5:	74 eb                	je     8011b2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 2b                	cmp    $0x2b,%al
  8011ce:	75 05                	jne    8011d5 <strtol+0x39>
		s++;
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	eb 13                	jmp    8011e8 <strtol+0x4c>
	else if (*s == '-')
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 2d                	cmp    $0x2d,%al
  8011dc:	75 0a                	jne    8011e8 <strtol+0x4c>
		s++, neg = 1;
  8011de:	ff 45 08             	incl   0x8(%ebp)
  8011e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ec:	74 06                	je     8011f4 <strtol+0x58>
  8011ee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011f2:	75 20                	jne    801214 <strtol+0x78>
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 30                	cmp    $0x30,%al
  8011fb:	75 17                	jne    801214 <strtol+0x78>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	40                   	inc    %eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3c 78                	cmp    $0x78,%al
  801205:	75 0d                	jne    801214 <strtol+0x78>
		s += 2, base = 16;
  801207:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80120b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801212:	eb 28                	jmp    80123c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801214:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801218:	75 15                	jne    80122f <strtol+0x93>
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	3c 30                	cmp    $0x30,%al
  801221:	75 0c                	jne    80122f <strtol+0x93>
		s++, base = 8;
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80122d:	eb 0d                	jmp    80123c <strtol+0xa0>
	else if (base == 0)
  80122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801233:	75 07                	jne    80123c <strtol+0xa0>
		base = 10;
  801235:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	3c 2f                	cmp    $0x2f,%al
  801243:	7e 19                	jle    80125e <strtol+0xc2>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 39                	cmp    $0x39,%al
  80124c:	7f 10                	jg     80125e <strtol+0xc2>
			dig = *s - '0';
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	83 e8 30             	sub    $0x30,%eax
  801259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80125c:	eb 42                	jmp    8012a0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 60                	cmp    $0x60,%al
  801265:	7e 19                	jle    801280 <strtol+0xe4>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 7a                	cmp    $0x7a,%al
  80126e:	7f 10                	jg     801280 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	0f be c0             	movsbl %al,%eax
  801278:	83 e8 57             	sub    $0x57,%eax
  80127b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127e:	eb 20                	jmp    8012a0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 40                	cmp    $0x40,%al
  801287:	7e 39                	jle    8012c2 <strtol+0x126>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 5a                	cmp    $0x5a,%al
  801290:	7f 30                	jg     8012c2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 37             	sub    $0x37,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a6:	7d 19                	jge    8012c1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012bc:	e9 7b ff ff ff       	jmp    80123c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012c1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c6:	74 08                	je     8012d0 <strtol+0x134>
		*endptr = (char *) s;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d4:	74 07                	je     8012dd <strtol+0x141>
  8012d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d9:	f7 d8                	neg    %eax
  8012db:	eb 03                	jmp    8012e0 <strtol+0x144>
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fa:	79 13                	jns    80130f <ltostr+0x2d>
	{
		neg = 1;
  8012fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801309:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80130c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801317:	99                   	cltd   
  801318:	f7 f9                	idiv   %ecx
  80131a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80131d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801320:	8d 50 01             	lea    0x1(%eax),%edx
  801323:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801326:	89 c2                	mov    %eax,%edx
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801330:	83 c2 30             	add    $0x30,%edx
  801333:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801335:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801338:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80133d:	f7 e9                	imul   %ecx
  80133f:	c1 fa 02             	sar    $0x2,%edx
  801342:	89 c8                	mov    %ecx,%eax
  801344:	c1 f8 1f             	sar    $0x1f,%eax
  801347:	29 c2                	sub    %eax,%edx
  801349:	89 d0                	mov    %edx,%eax
  80134b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80134e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801352:	75 bb                	jne    80130f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135e:	48                   	dec    %eax
  80135f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801362:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801366:	74 3d                	je     8013a5 <ltostr+0xc3>
		start = 1 ;
  801368:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80136f:	eb 34                	jmp    8013a5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801371:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	8a 00                	mov    (%eax),%al
  80137b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	01 c2                	add    %eax,%edx
  801386:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	01 c8                	add    %ecx,%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801392:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 c2                	add    %eax,%edx
  80139a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80139d:	88 02                	mov    %al,(%edx)
		start++ ;
  80139f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ab:	7c c4                	jl     801371 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013b8:	90                   	nop
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	e8 c4 f9 ff ff       	call   800d8d <strlen>
  8013c9:	83 c4 04             	add    $0x4,%esp
  8013cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013cf:	ff 75 0c             	pushl  0xc(%ebp)
  8013d2:	e8 b6 f9 ff ff       	call   800d8d <strlen>
  8013d7:	83 c4 04             	add    $0x4,%esp
  8013da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013eb:	eb 17                	jmp    801404 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f3:	01 c2                	add    %eax,%edx
  8013f5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	01 c8                	add    %ecx,%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801401:	ff 45 fc             	incl   -0x4(%ebp)
  801404:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801407:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140a:	7c e1                	jl     8013ed <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80140c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801413:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80141a:	eb 1f                	jmp    80143b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141f:	8d 50 01             	lea    0x1(%eax),%edx
  801422:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801425:	89 c2                	mov    %eax,%edx
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	01 c2                	add    %eax,%edx
  80142c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	01 c8                	add    %ecx,%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801438:	ff 45 f8             	incl   -0x8(%ebp)
  80143b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801441:	7c d9                	jl     80141c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801443:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	c6 00 00             	movb   $0x0,(%eax)
}
  80144e:	90                   	nop
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801454:	8b 45 14             	mov    0x14(%ebp),%eax
  801457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80145d:	8b 45 14             	mov    0x14(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801474:	eb 0c                	jmp    801482 <strsplit+0x31>
			*string++ = 0;
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8d 50 01             	lea    0x1(%eax),%edx
  80147c:	89 55 08             	mov    %edx,0x8(%ebp)
  80147f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 18                	je     8014a3 <strsplit+0x52>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 83 fa ff ff       	call   800f1f <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	75 d3                	jne    801476 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	74 5a                	je     801506 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	83 f8 0f             	cmp    $0xf,%eax
  8014b4:	75 07                	jne    8014bd <strsplit+0x6c>
		{
			return 0;
  8014b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bb:	eb 66                	jmp    801523 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	8d 48 01             	lea    0x1(%eax),%ecx
  8014c5:	8b 55 14             	mov    0x14(%ebp),%edx
  8014c8:	89 0a                	mov    %ecx,(%edx)
  8014ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 c2                	add    %eax,%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014db:	eb 03                	jmp    8014e0 <strsplit+0x8f>
			string++;
  8014dd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	74 8b                	je     801474 <strsplit+0x23>
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	50                   	push   %eax
  8014f2:	ff 75 0c             	pushl  0xc(%ebp)
  8014f5:	e8 25 fa ff ff       	call   800f1f <strchr>
  8014fa:	83 c4 08             	add    $0x8,%esp
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	74 dc                	je     8014dd <strsplit+0x8c>
			string++;
	}
  801501:	e9 6e ff ff ff       	jmp    801474 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801506:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80151e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801538:	eb 4a                	jmp    801584 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80153a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	01 c2                	add    %eax,%edx
  801542:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	01 c8                	add    %ecx,%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80154e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	01 d0                	add    %edx,%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	3c 40                	cmp    $0x40,%al
  80155a:	7e 25                	jle    801581 <str2lower+0x5c>
  80155c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801562:	01 d0                	add    %edx,%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	3c 5a                	cmp    $0x5a,%al
  801568:	7f 17                	jg     801581 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80156a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801575:	8b 55 08             	mov    0x8(%ebp),%edx
  801578:	01 ca                	add    %ecx,%edx
  80157a:	8a 12                	mov    (%edx),%dl
  80157c:	83 c2 20             	add    $0x20,%edx
  80157f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801581:	ff 45 fc             	incl   -0x4(%ebp)
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	e8 01 f8 ff ff       	call   800d8d <strlen>
  80158c:	83 c4 04             	add    $0x4,%esp
  80158f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801592:	7f a6                	jg     80153a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801594:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	57                   	push   %edi
  80159d:	56                   	push   %esi
  80159e:	53                   	push   %ebx
  80159f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b4:	cd 30                	int    $0x30
  8015b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5f                   	pop    %edi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	6a 00                	push   $0x0
  8015dc:	51                   	push   %ecx
  8015dd:	52                   	push   %edx
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 b0 ff ff ff       	call   801599 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	90                   	nop
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 02                	push   $0x2
  8015fe:	e8 96 ff ff ff       	call   801599 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 03                	push   $0x3
  801617:	e8 7d ff ff ff       	call   801599 <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 04                	push   $0x4
  801631:	e8 63 ff ff ff       	call   801599 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	90                   	nop
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 08                	push   $0x8
  80164f:	e8 45 ff ff ff       	call   801599 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165e:	8b 75 18             	mov    0x18(%ebp),%esi
  801661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	56                   	push   %esi
  80166e:	53                   	push   %ebx
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	6a 09                	push   $0x9
  801674:	e8 20 ff ff ff       	call   801599 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	6a 0a                	push   $0xa
  801693:	e8 01 ff ff ff       	call   801599 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	ff 75 08             	pushl  0x8(%ebp)
  8016ac:	6a 0b                	push   $0xb
  8016ae:	e8 e6 fe ff ff       	call   801599 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 0c                	push   $0xc
  8016c7:	e8 cd fe ff ff       	call   801599 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 0d                	push   $0xd
  8016e0:	e8 b4 fe ff ff       	call   801599 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 0e                	push   $0xe
  8016f9:	e8 9b fe ff ff       	call   801599 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 0f                	push   $0xf
  801712:	e8 82 fe ff ff       	call   801599 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	6a 10                	push   $0x10
  80172c:	e8 68 fe ff ff       	call   801599 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 11                	push   $0x11
  801745:	e8 4f fe ff ff       	call   801599 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_cputc>:

void
sys_cputc(const char c)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	50                   	push   %eax
  801769:	6a 01                	push   $0x1
  80176b:	e8 29 fe ff ff       	call   801599 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	90                   	nop
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 14                	push   $0x14
  801785:	e8 0f fe ff ff       	call   801599 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	8b 45 10             	mov    0x10(%ebp),%eax
  801799:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80179c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80179f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	51                   	push   %ecx
  8017a9:	52                   	push   %edx
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	50                   	push   %eax
  8017ae:	6a 15                	push   $0x15
  8017b0:	e8 e4 fd ff ff       	call   801599 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	52                   	push   %edx
  8017ca:	50                   	push   %eax
  8017cb:	6a 16                	push   $0x16
  8017cd:	e8 c7 fd ff ff       	call   801599 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	51                   	push   %ecx
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 17                	push   $0x17
  8017ec:	e8 a8 fd ff ff       	call   801599 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	52                   	push   %edx
  801806:	50                   	push   %eax
  801807:	6a 18                	push   $0x18
  801809:	e8 8b fd ff ff       	call   801599 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 14             	pushl  0x14(%ebp)
  80181e:	ff 75 10             	pushl  0x10(%ebp)
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	50                   	push   %eax
  801825:	6a 19                	push   $0x19
  801827:	e8 6d fd ff ff       	call   801599 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	50                   	push   %eax
  801840:	6a 1a                	push   $0x1a
  801842:	e8 52 fd ff ff       	call   801599 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	50                   	push   %eax
  80185c:	6a 1b                	push   $0x1b
  80185e:	e8 36 fd ff ff       	call   801599 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 05                	push   $0x5
  801877:	e8 1d fd ff ff       	call   801599 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 06                	push   $0x6
  801890:	e8 04 fd ff ff       	call   801599 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 07                	push   $0x7
  8018a9:	e8 eb fc ff ff       	call   801599 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 1c                	push   $0x1c
  8018c2:	e8 d2 fc ff ff       	call   801599 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d6:	8d 50 04             	lea    0x4(%eax),%edx
  8018d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 1d                	push   $0x1d
  8018e6:	e8 ae fc ff ff       	call   801599 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f7:	89 01                	mov    %eax,(%ecx)
  8018f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	c9                   	leave  
  801900:	c2 04 00             	ret    $0x4

00801903 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 10             	pushl  0x10(%ebp)
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	6a 13                	push   $0x13
  801915:	e8 7f fc ff ff       	call   801599 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
	return ;
  80191d:	90                   	nop
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_rcr2>:
uint32 sys_rcr2()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 1e                	push   $0x1e
  80192f:	e8 65 fc ff ff       	call   801599 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801945:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	50                   	push   %eax
  801952:	6a 1f                	push   $0x1f
  801954:	e8 40 fc ff ff       	call   801599 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
	return ;
  80195c:	90                   	nop
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <rsttst>:
void rsttst()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 21                	push   $0x21
  80196e:	e8 26 fc ff ff       	call   801599 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
	return ;
  801976:	90                   	nop
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	8b 45 14             	mov    0x14(%ebp),%eax
  801982:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801985:	8b 55 18             	mov    0x18(%ebp),%edx
  801988:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198c:	52                   	push   %edx
  80198d:	50                   	push   %eax
  80198e:	ff 75 10             	pushl  0x10(%ebp)
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 20                	push   $0x20
  801999:	e8 fb fb ff ff       	call   801599 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <chktst>:
void chktst(uint32 n)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 08             	pushl  0x8(%ebp)
  8019b2:	6a 22                	push   $0x22
  8019b4:	e8 e0 fb ff ff       	call   801599 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bc:	90                   	nop
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <inctst>:

void inctst()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 23                	push   $0x23
  8019ce:	e8 c6 fb ff ff       	call   801599 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <gettst>:
uint32 gettst()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 24                	push   $0x24
  8019e8:	e8 ac fb ff ff       	call   801599 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 25                	push   $0x25
  801a01:	e8 93 fb ff ff       	call   801599 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
  801a09:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a0e:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	6a 26                	push   $0x26
  801a2d:	e8 67 fb ff ff       	call   801599 <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
	return ;
  801a35:	90                   	nop
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	53                   	push   %ebx
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 27                	push   $0x27
  801a50:	e8 44 fb ff ff       	call   801599 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 28                	push   $0x28
  801a70:	e8 24 fb ff ff       	call   801599 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a7d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	51                   	push   %ecx
  801a89:	ff 75 10             	pushl  0x10(%ebp)
  801a8c:	52                   	push   %edx
  801a8d:	50                   	push   %eax
  801a8e:	6a 29                	push   $0x29
  801a90:	e8 04 fb ff ff       	call   801599 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	6a 12                	push   $0x12
  801aac:	e8 e8 fa ff ff       	call   801599 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab4:	90                   	nop
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	6a 2a                	push   $0x2a
  801aca:	e8 ca fa ff ff       	call   801599 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return;
  801ad2:	90                   	nop
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 2b                	push   $0x2b
  801ae4:	e8 b0 fa ff ff       	call   801599 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	6a 2d                	push   $0x2d
  801aff:	e8 95 fa ff ff       	call   801599 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return;
  801b07:	90                   	nop
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	ff 75 08             	pushl  0x8(%ebp)
  801b19:	6a 2c                	push   $0x2c
  801b1b:	e8 79 fa ff ff       	call   801599 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
	return ;
  801b23:	90                   	nop
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	68 28 25 80 00       	push   $0x802528
  801b34:	68 25 01 00 00       	push   $0x125
  801b39:	68 5b 25 80 00       	push   $0x80255b
  801b3e:	e8 a3 e8 ff ff       	call   8003e6 <_panic>

00801b43 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	68 6c 25 80 00       	push   $0x80256c
  801b51:	6a 07                	push   $0x7
  801b53:	68 9b 25 80 00       	push   $0x80259b
  801b58:	e8 89 e8 ff ff       	call   8003e6 <_panic>

00801b5d <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	68 ac 25 80 00       	push   $0x8025ac
  801b6b:	6a 0b                	push   $0xb
  801b6d:	68 9b 25 80 00       	push   $0x80259b
  801b72:	e8 6f e8 ff ff       	call   8003e6 <_panic>

00801b77 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	68 d8 25 80 00       	push   $0x8025d8
  801b85:	6a 10                	push   $0x10
  801b87:	68 9b 25 80 00       	push   $0x80259b
  801b8c:	e8 55 e8 ff ff       	call   8003e6 <_panic>

00801b91 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 08 26 80 00       	push   $0x802608
  801b9f:	6a 15                	push   $0x15
  801ba1:	68 9b 25 80 00       	push   $0x80259b
  801ba6:	e8 3b e8 ff ff       	call   8003e6 <_panic>

00801bab <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	8b 40 10             	mov    0x10(%eax),%eax
}
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    
  801bb6:	66 90                	xchg   %ax,%ax

00801bb8 <__udivdi3>:
  801bb8:	55                   	push   %ebp
  801bb9:	57                   	push   %edi
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
  801bbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bcf:	89 ca                	mov    %ecx,%edx
  801bd1:	89 f8                	mov    %edi,%eax
  801bd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bd7:	85 f6                	test   %esi,%esi
  801bd9:	75 2d                	jne    801c08 <__udivdi3+0x50>
  801bdb:	39 cf                	cmp    %ecx,%edi
  801bdd:	77 65                	ja     801c44 <__udivdi3+0x8c>
  801bdf:	89 fd                	mov    %edi,%ebp
  801be1:	85 ff                	test   %edi,%edi
  801be3:	75 0b                	jne    801bf0 <__udivdi3+0x38>
  801be5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bea:	31 d2                	xor    %edx,%edx
  801bec:	f7 f7                	div    %edi
  801bee:	89 c5                	mov    %eax,%ebp
  801bf0:	31 d2                	xor    %edx,%edx
  801bf2:	89 c8                	mov    %ecx,%eax
  801bf4:	f7 f5                	div    %ebp
  801bf6:	89 c1                	mov    %eax,%ecx
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	f7 f5                	div    %ebp
  801bfc:	89 cf                	mov    %ecx,%edi
  801bfe:	89 fa                	mov    %edi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	39 ce                	cmp    %ecx,%esi
  801c0a:	77 28                	ja     801c34 <__udivdi3+0x7c>
  801c0c:	0f bd fe             	bsr    %esi,%edi
  801c0f:	83 f7 1f             	xor    $0x1f,%edi
  801c12:	75 40                	jne    801c54 <__udivdi3+0x9c>
  801c14:	39 ce                	cmp    %ecx,%esi
  801c16:	72 0a                	jb     801c22 <__udivdi3+0x6a>
  801c18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c1c:	0f 87 9e 00 00 00    	ja     801cc0 <__udivdi3+0x108>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	89 fa                	mov    %edi,%edx
  801c29:	83 c4 1c             	add    $0x1c,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
  801c31:	8d 76 00             	lea    0x0(%esi),%esi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	31 c0                	xor    %eax,%eax
  801c38:	89 fa                	mov    %edi,%edx
  801c3a:	83 c4 1c             	add    $0x1c,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	f7 f7                	div    %edi
  801c48:	31 ff                	xor    %edi,%edi
  801c4a:	89 fa                	mov    %edi,%edx
  801c4c:	83 c4 1c             	add    $0x1c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
  801c54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c59:	89 eb                	mov    %ebp,%ebx
  801c5b:	29 fb                	sub    %edi,%ebx
  801c5d:	89 f9                	mov    %edi,%ecx
  801c5f:	d3 e6                	shl    %cl,%esi
  801c61:	89 c5                	mov    %eax,%ebp
  801c63:	88 d9                	mov    %bl,%cl
  801c65:	d3 ed                	shr    %cl,%ebp
  801c67:	89 e9                	mov    %ebp,%ecx
  801c69:	09 f1                	or     %esi,%ecx
  801c6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c6f:	89 f9                	mov    %edi,%ecx
  801c71:	d3 e0                	shl    %cl,%eax
  801c73:	89 c5                	mov    %eax,%ebp
  801c75:	89 d6                	mov    %edx,%esi
  801c77:	88 d9                	mov    %bl,%cl
  801c79:	d3 ee                	shr    %cl,%esi
  801c7b:	89 f9                	mov    %edi,%ecx
  801c7d:	d3 e2                	shl    %cl,%edx
  801c7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c83:	88 d9                	mov    %bl,%cl
  801c85:	d3 e8                	shr    %cl,%eax
  801c87:	09 c2                	or     %eax,%edx
  801c89:	89 d0                	mov    %edx,%eax
  801c8b:	89 f2                	mov    %esi,%edx
  801c8d:	f7 74 24 0c          	divl   0xc(%esp)
  801c91:	89 d6                	mov    %edx,%esi
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	f7 e5                	mul    %ebp
  801c97:	39 d6                	cmp    %edx,%esi
  801c99:	72 19                	jb     801cb4 <__udivdi3+0xfc>
  801c9b:	74 0b                	je     801ca8 <__udivdi3+0xf0>
  801c9d:	89 d8                	mov    %ebx,%eax
  801c9f:	31 ff                	xor    %edi,%edi
  801ca1:	e9 58 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cac:	89 f9                	mov    %edi,%ecx
  801cae:	d3 e2                	shl    %cl,%edx
  801cb0:	39 c2                	cmp    %eax,%edx
  801cb2:	73 e9                	jae    801c9d <__udivdi3+0xe5>
  801cb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cb7:	31 ff                	xor    %edi,%edi
  801cb9:	e9 40 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	31 c0                	xor    %eax,%eax
  801cc2:	e9 37 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801cc7:	90                   	nop

00801cc8 <__umoddi3>:
  801cc8:	55                   	push   %ebp
  801cc9:	57                   	push   %edi
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 1c             	sub    $0x1c,%esp
  801ccf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ce7:	89 f3                	mov    %esi,%ebx
  801ce9:	89 fa                	mov    %edi,%edx
  801ceb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cef:	89 34 24             	mov    %esi,(%esp)
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	75 1a                	jne    801d10 <__umoddi3+0x48>
  801cf6:	39 f7                	cmp    %esi,%edi
  801cf8:	0f 86 a2 00 00 00    	jbe    801da0 <__umoddi3+0xd8>
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	89 f2                	mov    %esi,%edx
  801d02:	f7 f7                	div    %edi
  801d04:	89 d0                	mov    %edx,%eax
  801d06:	31 d2                	xor    %edx,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	39 f0                	cmp    %esi,%eax
  801d12:	0f 87 ac 00 00 00    	ja     801dc4 <__umoddi3+0xfc>
  801d18:	0f bd e8             	bsr    %eax,%ebp
  801d1b:	83 f5 1f             	xor    $0x1f,%ebp
  801d1e:	0f 84 ac 00 00 00    	je     801dd0 <__umoddi3+0x108>
  801d24:	bf 20 00 00 00       	mov    $0x20,%edi
  801d29:	29 ef                	sub    %ebp,%edi
  801d2b:	89 fe                	mov    %edi,%esi
  801d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d31:	89 e9                	mov    %ebp,%ecx
  801d33:	d3 e0                	shl    %cl,%eax
  801d35:	89 d7                	mov    %edx,%edi
  801d37:	89 f1                	mov    %esi,%ecx
  801d39:	d3 ef                	shr    %cl,%edi
  801d3b:	09 c7                	or     %eax,%edi
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 e2                	shl    %cl,%edx
  801d41:	89 14 24             	mov    %edx,(%esp)
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	d3 e0                	shl    %cl,%eax
  801d48:	89 c2                	mov    %eax,%edx
  801d4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d4e:	d3 e0                	shl    %cl,%eax
  801d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d58:	89 f1                	mov    %esi,%ecx
  801d5a:	d3 e8                	shr    %cl,%eax
  801d5c:	09 d0                	or     %edx,%eax
  801d5e:	d3 eb                	shr    %cl,%ebx
  801d60:	89 da                	mov    %ebx,%edx
  801d62:	f7 f7                	div    %edi
  801d64:	89 d3                	mov    %edx,%ebx
  801d66:	f7 24 24             	mull   (%esp)
  801d69:	89 c6                	mov    %eax,%esi
  801d6b:	89 d1                	mov    %edx,%ecx
  801d6d:	39 d3                	cmp    %edx,%ebx
  801d6f:	0f 82 87 00 00 00    	jb     801dfc <__umoddi3+0x134>
  801d75:	0f 84 91 00 00 00    	je     801e0c <__umoddi3+0x144>
  801d7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d7f:	29 f2                	sub    %esi,%edx
  801d81:	19 cb                	sbb    %ecx,%ebx
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d89:	d3 e0                	shl    %cl,%eax
  801d8b:	89 e9                	mov    %ebp,%ecx
  801d8d:	d3 ea                	shr    %cl,%edx
  801d8f:	09 d0                	or     %edx,%eax
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 eb                	shr    %cl,%ebx
  801d95:	89 da                	mov    %ebx,%edx
  801d97:	83 c4 1c             	add    $0x1c,%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    
  801d9f:	90                   	nop
  801da0:	89 fd                	mov    %edi,%ebp
  801da2:	85 ff                	test   %edi,%edi
  801da4:	75 0b                	jne    801db1 <__umoddi3+0xe9>
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	f7 f7                	div    %edi
  801daf:	89 c5                	mov    %eax,%ebp
  801db1:	89 f0                	mov    %esi,%eax
  801db3:	31 d2                	xor    %edx,%edx
  801db5:	f7 f5                	div    %ebp
  801db7:	89 c8                	mov    %ecx,%eax
  801db9:	f7 f5                	div    %ebp
  801dbb:	89 d0                	mov    %edx,%eax
  801dbd:	e9 44 ff ff ff       	jmp    801d06 <__umoddi3+0x3e>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	89 c8                	mov    %ecx,%eax
  801dc6:	89 f2                	mov    %esi,%edx
  801dc8:	83 c4 1c             	add    $0x1c,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
  801dd0:	3b 04 24             	cmp    (%esp),%eax
  801dd3:	72 06                	jb     801ddb <__umoddi3+0x113>
  801dd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dd9:	77 0f                	ja     801dea <__umoddi3+0x122>
  801ddb:	89 f2                	mov    %esi,%edx
  801ddd:	29 f9                	sub    %edi,%ecx
  801ddf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801de3:	89 14 24             	mov    %edx,(%esp)
  801de6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dee:	8b 14 24             	mov    (%esp),%edx
  801df1:	83 c4 1c             	add    $0x1c,%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
  801df9:	8d 76 00             	lea    0x0(%esi),%esi
  801dfc:	2b 04 24             	sub    (%esp),%eax
  801dff:	19 fa                	sbb    %edi,%edx
  801e01:	89 d1                	mov    %edx,%ecx
  801e03:	89 c6                	mov    %eax,%esi
  801e05:	e9 71 ff ff ff       	jmp    801d7b <__umoddi3+0xb3>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e10:	72 ea                	jb     801dfc <__umoddi3+0x134>
  801e12:	89 d9                	mov    %ebx,%ecx
  801e14:	e9 62 ff ff ff       	jmp    801d7b <__umoddi3+0xb3>
