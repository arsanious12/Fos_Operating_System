
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 5d 02 00 00       	call   800293 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	printStats = 0;
  80003e:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  800045:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  800048:	e8 88 18 00 00       	call   8018d5 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 c0 2c 80 00       	push   $0x802cc0
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 16 15 00 00       	call   801576 <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 c2 2c 80 00       	push   $0x802cc2
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 00 15 00 00       	call   801576 <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int * finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 cb 2c 80 00       	push   $0x802ccb
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 ea 14 00 00       	call   801576 <sget>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct semaphore T, finished, finishedCountMutex ;
	struct uspinlock *sT, *sfinishedCountMutex;

	if (*protType == 1)
  800092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800095:	8b 00                	mov    (%eax),%eax
  800097:	83 f8 01             	cmp    $0x1,%eax
  80009a:	75 47                	jne    8000e3 <_main+0xab>
	{
		T = get_semaphore(parentenvID, "T");
  80009c:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 d9 2c 80 00       	push   $0x802cd9
  8000a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000aa:	50                   	push   %eax
  8000ab:	e8 8f 25 00 00       	call   80263f <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 db 2c 80 00       	push   $0x802cdb
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 78 25 00 00       	call   80263f <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 e4 2c 80 00       	push   $0x802ce4
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 61 25 00 00       	call   80263f <get_semaphore>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	eb 36                	jmp    800119 <_main+0xe1>
	}
	else if (*protType == 2)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	83 f8 02             	cmp    $0x2,%eax
  8000eb:	75 2c                	jne    800119 <_main+0xe1>
	{
		sT = sget(parentenvID, "T");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 d9 2c 80 00       	push   $0x802cd9
  8000f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f8:	e8 79 14 00 00       	call   801576 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 e4 2c 80 00       	push   $0x802ce4
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 63 14 00 00       	call   801576 <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Z ;
	if (*protType == 1)
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	83 f8 01             	cmp    $0x1,%eax
  800121:	75 10                	jne    800133 <_main+0xfb>
	{
		wait_semaphore(T);
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 bc             	pushl  -0x44(%ebp)
  800129:	e8 2b 25 00 00       	call   802659 <wait_semaphore>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 18                	jmp    80014b <_main+0x113>
	}
	else if (*protType == 2)
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	75 0e                	jne    80014b <_main+0x113>
	{
		acquire_uspinlock(sT);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 f4             	pushl  -0xc(%ebp)
  800143:	e8 5d 26 00 00       	call   8027a5 <acquire_uspinlock>
  800148:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  80014b:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	e8 b1 17 00 00       	call   801908 <sys_get_virtual_time>
  800157:	83 c4 0c             	add    $0xc,%esp
  80015a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80015d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	f7 f1                	div    %ecx
  800169:	89 d0                	mov    %edx,%eax
  80016b:	05 d0 07 00 00       	add    $0x7d0,%eax
  800170:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	e8 19 25 00 00       	call   802698 <env_sleep>
  80017f:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  800182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	40                   	inc    %eax
  800188:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80018b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	e8 71 17 00 00       	call   801908 <sys_get_virtual_time>
  800197:	83 c4 0c             	add    $0xc,%esp
  80019a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a7:	f7 f1                	div    %ecx
  8001a9:	89 d0                	mov    %edx,%eax
  8001ab:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	e8 d9 24 00 00       	call   802698 <env_sleep>
  8001bf:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c8:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  8001ca:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	50                   	push   %eax
  8001d1:	e8 32 17 00 00       	call   801908 <sys_get_virtual_time>
  8001d6:	83 c4 0c             	add    $0xc,%esp
  8001d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001dc:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e6:	f7 f1                	div    %ecx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 9a 24 00 00       	call   802698 <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	83 f8 01             	cmp    $0x1,%eax
  800209:	75 39                	jne    800244 <_main+0x20c>
	{
		signal_semaphore(finished);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 b8             	pushl  -0x48(%ebp)
  800211:	e8 5d 24 00 00       	call   802673 <signal_semaphore>
  800216:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80021f:	e8 35 24 00 00       	call   802659 <wait_semaphore>
  800224:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 50 01             	lea    0x1(%eax),%edx
  80022f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800232:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023a:	e8 34 24 00 00       	call   802673 <signal_semaphore>
  80023f:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800242:	eb 4c                	jmp    800290 <_main+0x258>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	83 f8 02             	cmp    $0x2,%eax
  80024c:	75 2b                	jne    800279 <_main+0x241>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	ff 75 f0             	pushl  -0x10(%ebp)
  800254:	e8 4c 25 00 00       	call   8027a5 <acquire_uspinlock>
  800259:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80025f:	8b 00                	mov    (%eax),%eax
  800261:	8d 50 01             	lea    0x1(%eax),%edx
  800264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800267:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 f0             	pushl  -0x10(%ebp)
  80026f:	e8 89 25 00 00       	call   8027fd <release_uspinlock>
  800274:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800277:	eb 17                	jmp    800290 <_main+0x258>
			(*finishedCount)++ ;
		}
		release_uspinlock(sfinishedCountMutex);
	}else
	{
		sys_lock_cons();
  800279:	e8 c5 13 00 00       	call   801643 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800281:	8b 00                	mov    (%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028b:	e8 cd 13 00 00       	call   80165d <sys_unlock_cons>
	}
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029c:	e8 1b 16 00 00       	call   8018bc <sys_getenvindex>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a7:	89 d0                	mov    %edx,%eax
  8002a9:	c1 e0 06             	shl    $0x6,%eax
  8002ac:	29 d0                	sub    %edx,%eax
  8002ae:	c1 e0 02             	shl    $0x2,%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ba:	01 c8                	add    %ecx,%eax
  8002bc:	c1 e0 03             	shl    $0x3,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c8:	29 c2                	sub    %eax,%edx
  8002ca:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002d1:	89 c2                	mov    %eax,%edx
  8002d3:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002d9:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002de:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e3:	8a 40 20             	mov    0x20(%eax),%al
  8002e6:	84 c0                	test   %al,%al
  8002e8:	74 0d                	je     8002f7 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	83 c0 20             	add    $0x20,%eax
  8002f2:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fb:	7e 0a                	jle    800307 <libmain+0x74>
		binaryname = argv[0];
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 0c             	pushl  0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 23 fd ff ff       	call   800038 <_main>
  800315:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800318:	a1 00 40 80 00       	mov    0x804000,%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	0f 84 01 01 00 00    	je     800426 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800325:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032b:	bb f0 2d 80 00       	mov    $0x802df0,%ebx
  800330:	ba 0e 00 00 00       	mov    $0xe,%edx
  800335:	89 c7                	mov    %eax,%edi
  800337:	89 de                	mov    %ebx,%esi
  800339:	89 d1                	mov    %edx,%ecx
  80033b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033d:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800340:	b9 56 00 00 00       	mov    $0x56,%ecx
  800345:	b0 00                	mov    $0x0,%al
  800347:	89 d7                	mov    %edx,%edi
  800349:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800352:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	50                   	push   %eax
  800359:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035f:	50                   	push   %eax
  800360:	e8 8d 17 00 00       	call   801af2 <sys_utilities>
  800365:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800368:	e8 d6 12 00 00       	call   801643 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 10 2d 80 00       	push   $0x802d10
  800375:	e8 be 01 00 00       	call   800538 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800380:	85 c0                	test   %eax,%eax
  800382:	74 18                	je     80039c <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800384:	e8 87 17 00 00       	call   801b10 <sys_get_optimal_num_faults>
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	50                   	push   %eax
  80038d:	68 38 2d 80 00       	push   $0x802d38
  800392:	e8 a1 01 00 00       	call   800538 <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb 59                	jmp    8003f5 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039c:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a1:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ac:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	52                   	push   %edx
  8003b6:	50                   	push   %eax
  8003b7:	68 5c 2d 80 00       	push   $0x802d5c
  8003bc:	e8 77 01 00 00       	call   800538 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d4:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003da:	a1 20 40 80 00       	mov    0x804020,%eax
  8003df:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003e5:	51                   	push   %ecx
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	68 84 2d 80 00       	push   $0x802d84
  8003ed:	e8 46 01 00 00       	call   800538 <cprintf>
  8003f2:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fa:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	50                   	push   %eax
  800404:	68 dc 2d 80 00       	push   $0x802ddc
  800409:	e8 2a 01 00 00       	call   800538 <cprintf>
  80040e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800411:	83 ec 0c             	sub    $0xc,%esp
  800414:	68 10 2d 80 00       	push   $0x802d10
  800419:	e8 1a 01 00 00       	call   800538 <cprintf>
  80041e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800421:	e8 37 12 00 00       	call   80165d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800426:	e8 1f 00 00 00       	call   80044a <exit>
}
  80042b:	90                   	nop
  80042c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042f:	5b                   	pop    %ebx
  800430:	5e                   	pop    %esi
  800431:	5f                   	pop    %edi
  800432:	5d                   	pop    %ebp
  800433:	c3                   	ret    

00800434 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043a:	83 ec 0c             	sub    $0xc,%esp
  80043d:	6a 00                	push   $0x0
  80043f:	e8 44 14 00 00       	call   801888 <sys_destroy_env>
  800444:	83 c4 10             	add    $0x10,%esp
}
  800447:	90                   	nop
  800448:	c9                   	leave  
  800449:	c3                   	ret    

0080044a <exit>:

void
exit(void)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800450:	e8 99 14 00 00       	call   8018ee <sys_exit_env>
}
  800455:	90                   	nop
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	53                   	push   %ebx
  80045c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80045f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 48 01             	lea    0x1(%eax),%ecx
  800467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046a:	89 0a                	mov    %ecx,(%edx)
  80046c:	8b 55 08             	mov    0x8(%ebp),%edx
  80046f:	88 d1                	mov    %dl,%cl
  800471:	8b 55 0c             	mov    0xc(%ebp),%edx
  800474:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800482:	75 30                	jne    8004b4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800484:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80048a:	a0 44 40 80 00       	mov    0x804044,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800495:	8b 09                	mov    (%ecx),%ecx
  800497:	89 cb                	mov    %ecx,%ebx
  800499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80049c:	83 c1 08             	add    $0x8,%ecx
  80049f:	52                   	push   %edx
  8004a0:	50                   	push   %eax
  8004a1:	53                   	push   %ebx
  8004a2:	51                   	push   %ecx
  8004a3:	e8 57 11 00 00       	call   8015ff <sys_cputs>
  8004a8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 40 04             	mov    0x4(%eax),%eax
  8004ba:	8d 50 01             	lea    0x1(%eax),%edx
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c3:	90                   	nop
  8004c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d9:	00 00 00 
	b.cnt = 0;
  8004dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f2:	50                   	push   %eax
  8004f3:	68 58 04 80 00       	push   $0x800458
  8004f8:	e8 5a 02 00 00       	call   800757 <vprintfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800500:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800506:	a0 44 40 80 00       	mov    0x804044,%al
  80050b:	0f b6 c0             	movzbl %al,%eax
  80050e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800514:	52                   	push   %edx
  800515:	50                   	push   %eax
  800516:	51                   	push   %ecx
  800517:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051d:	83 c0 08             	add    $0x8,%eax
  800520:	50                   	push   %eax
  800521:	e8 d9 10 00 00       	call   8015ff <sys_cputs>
  800526:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800529:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800530:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800536:	c9                   	leave  
  800537:	c3                   	ret    

00800538 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800545:	8d 45 0c             	lea    0xc(%ebp),%eax
  800548:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 f4             	pushl  -0xc(%ebp)
  800554:	50                   	push   %eax
  800555:	e8 6f ff ff ff       	call   8004c9 <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800560:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	c1 e0 08             	shl    $0x8,%eax
  800578:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80057d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800580:	83 c0 04             	add    $0x4,%eax
  800583:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800586:	8b 45 0c             	mov    0xc(%ebp),%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 f4             	pushl  -0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	e8 34 ff ff ff       	call   8004c9 <vcprintf>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80059b:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8005a2:	07 00 00 

	return cnt;
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005b0:	e8 8e 10 00 00       	call   801643 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c4:	50                   	push   %eax
  8005c5:	e8 ff fe ff ff       	call   8004c9 <vcprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005d0:	e8 88 10 00 00       	call   80165d <sys_unlock_cons>
	return cnt;
  8005d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 14             	sub    $0x14,%esp
  8005e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f8:	77 55                	ja     80064f <printnum+0x75>
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	72 05                	jb     800604 <printnum+0x2a>
  8005ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800602:	77 4b                	ja     80064f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800604:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800607:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060a:	8b 45 18             	mov    0x18(%ebp),%eax
  80060d:	ba 00 00 00 00       	mov    $0x0,%edx
  800612:	52                   	push   %edx
  800613:	50                   	push   %eax
  800614:	ff 75 f4             	pushl  -0xc(%ebp)
  800617:	ff 75 f0             	pushl  -0x10(%ebp)
  80061a:	e8 2d 24 00 00       	call   802a4c <__udivdi3>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	83 ec 04             	sub    $0x4,%esp
  800625:	ff 75 20             	pushl  0x20(%ebp)
  800628:	53                   	push   %ebx
  800629:	ff 75 18             	pushl  0x18(%ebp)
  80062c:	52                   	push   %edx
  80062d:	50                   	push   %eax
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 08             	pushl  0x8(%ebp)
  800634:	e8 a1 ff ff ff       	call   8005da <printnum>
  800639:	83 c4 20             	add    $0x20,%esp
  80063c:	eb 1a                	jmp    800658 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	ff 75 20             	pushl  0x20(%ebp)
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	ff d0                	call   *%eax
  80064c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80064f:	ff 4d 1c             	decl   0x1c(%ebp)
  800652:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800656:	7f e6                	jg     80063e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800658:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80065b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	53                   	push   %ebx
  800667:	51                   	push   %ecx
  800668:	52                   	push   %edx
  800669:	50                   	push   %eax
  80066a:	e8 ed 24 00 00       	call   802b5c <__umoddi3>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	05 74 30 80 00       	add    $0x803074,%eax
  800677:	8a 00                	mov    (%eax),%al
  800679:	0f be c0             	movsbl %al,%eax
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	50                   	push   %eax
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	ff d0                	call   *%eax
  800688:	83 c4 10             	add    $0x10,%esp
}
  80068b:	90                   	nop
  80068c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800694:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800698:	7e 1c                	jle    8006b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	8d 50 08             	lea    0x8(%eax),%edx
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	89 10                	mov    %edx,(%eax)
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	83 e8 08             	sub    $0x8,%eax
  8006af:	8b 50 04             	mov    0x4(%eax),%edx
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	eb 40                	jmp    8006f6 <getuint+0x65>
	else if (lflag)
  8006b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ba:	74 1e                	je     8006da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 50 04             	lea    0x4(%eax),%edx
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	89 10                	mov    %edx,(%eax)
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	83 e8 04             	sub    $0x4,%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	eb 1c                	jmp    8006f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	89 10                	mov    %edx,(%eax)
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	83 e8 04             	sub    $0x4,%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ff:	7e 1c                	jle    80071d <getint+0x25>
		return va_arg(*ap, long long);
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	8d 50 08             	lea    0x8(%eax),%edx
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	89 10                	mov    %edx,(%eax)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	83 e8 08             	sub    $0x8,%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	eb 38                	jmp    800755 <getint+0x5d>
	else if (lflag)
  80071d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800721:	74 1a                	je     80073d <getint+0x45>
		return va_arg(*ap, long);
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	8d 50 04             	lea    0x4(%eax),%edx
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	89 10                	mov    %edx,(%eax)
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	83 e8 04             	sub    $0x4,%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	99                   	cltd   
  80073b:	eb 18                	jmp    800755 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	8d 50 04             	lea    0x4(%eax),%edx
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	89 10                	mov    %edx,(%eax)
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	83 e8 04             	sub    $0x4,%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	99                   	cltd   
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	56                   	push   %esi
  80075b:	53                   	push   %ebx
  80075c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075f:	eb 17                	jmp    800778 <vprintfmt+0x21>
			if (ch == '\0')
  800761:	85 db                	test   %ebx,%ebx
  800763:	0f 84 c1 03 00 00    	je     800b2a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	53                   	push   %ebx
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	ff d0                	call   *%eax
  800775:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	8d 50 01             	lea    0x1(%eax),%edx
  80077e:	89 55 10             	mov    %edx,0x10(%ebp)
  800781:	8a 00                	mov    (%eax),%al
  800783:	0f b6 d8             	movzbl %al,%ebx
  800786:	83 fb 25             	cmp    $0x25,%ebx
  800789:	75 d6                	jne    800761 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80078b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80078f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800796:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80079d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8d 50 01             	lea    0x1(%eax),%edx
  8007b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b4:	8a 00                	mov    (%eax),%al
  8007b6:	0f b6 d8             	movzbl %al,%ebx
  8007b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007bc:	83 f8 5b             	cmp    $0x5b,%eax
  8007bf:	0f 87 3d 03 00 00    	ja     800b02 <vprintfmt+0x3ab>
  8007c5:	8b 04 85 98 30 80 00 	mov    0x803098(,%eax,4),%eax
  8007cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d2:	eb d7                	jmp    8007ab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d8:	eb d1                	jmp    8007ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e4:	89 d0                	mov    %edx,%eax
  8007e6:	c1 e0 02             	shl    $0x2,%eax
  8007e9:	01 d0                	add    %edx,%eax
  8007eb:	01 c0                	add    %eax,%eax
  8007ed:	01 d8                	add    %ebx,%eax
  8007ef:	83 e8 30             	sub    $0x30,%eax
  8007f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f8:	8a 00                	mov    (%eax),%al
  8007fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800800:	7e 3e                	jle    800840 <vprintfmt+0xe9>
  800802:	83 fb 39             	cmp    $0x39,%ebx
  800805:	7f 39                	jg     800840 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800807:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080a:	eb d5                	jmp    8007e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	83 c0 04             	add    $0x4,%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800820:	eb 1f                	jmp    800841 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	79 83                	jns    8007ab <vprintfmt+0x54>
				width = 0;
  800828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80082f:	e9 77 ff ff ff       	jmp    8007ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800834:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80083b:	e9 6b ff ff ff       	jmp    8007ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800840:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800845:	0f 89 60 ff ff ff    	jns    8007ab <vprintfmt+0x54>
				width = precision, precision = -1;
  80084b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80084e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800851:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800858:	e9 4e ff ff ff       	jmp    8007ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80085d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800860:	e9 46 ff ff ff       	jmp    8007ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	83 c0 04             	add    $0x4,%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 e8 04             	sub    $0x4,%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	50                   	push   %eax
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			break;
  800885:	e9 9b 02 00 00       	jmp    800b25 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80089b:	85 db                	test   %ebx,%ebx
  80089d:	79 02                	jns    8008a1 <vprintfmt+0x14a>
				err = -err;
  80089f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a1:	83 fb 64             	cmp    $0x64,%ebx
  8008a4:	7f 0b                	jg     8008b1 <vprintfmt+0x15a>
  8008a6:	8b 34 9d e0 2e 80 00 	mov    0x802ee0(,%ebx,4),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 19                	jne    8008ca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b1:	53                   	push   %ebx
  8008b2:	68 85 30 80 00       	push   $0x803085
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 70 02 00 00       	call   800b32 <printfmt>
  8008c2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c5:	e9 5b 02 00 00       	jmp    800b25 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ca:	56                   	push   %esi
  8008cb:	68 8e 30 80 00       	push   $0x80308e
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	e8 57 02 00 00       	call   800b32 <printfmt>
  8008db:	83 c4 10             	add    $0x10,%esp
			break;
  8008de:	e9 42 02 00 00       	jmp    800b25 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 30                	mov    (%eax),%esi
  8008f4:	85 f6                	test   %esi,%esi
  8008f6:	75 05                	jne    8008fd <vprintfmt+0x1a6>
				p = "(null)";
  8008f8:	be 91 30 80 00       	mov    $0x803091,%esi
			if (width > 0 && padc != '-')
  8008fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800901:	7e 6d                	jle    800970 <vprintfmt+0x219>
  800903:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800907:	74 67                	je     800970 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	50                   	push   %eax
  800910:	56                   	push   %esi
  800911:	e8 1e 03 00 00       	call   800c34 <strnlen>
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80091c:	eb 16                	jmp    800934 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80091e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	50                   	push   %eax
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e4                	jg     80091e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093a:	eb 34                	jmp    800970 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80093c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800940:	74 1c                	je     80095e <vprintfmt+0x207>
  800942:	83 fb 1f             	cmp    $0x1f,%ebx
  800945:	7e 05                	jle    80094c <vprintfmt+0x1f5>
  800947:	83 fb 7e             	cmp    $0x7e,%ebx
  80094a:	7e 12                	jle    80095e <vprintfmt+0x207>
					putch('?', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 3f                	push   $0x3f
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	eb 0f                	jmp    80096d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	53                   	push   %ebx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096d:	ff 4d e4             	decl   -0x1c(%ebp)
  800970:	89 f0                	mov    %esi,%eax
  800972:	8d 70 01             	lea    0x1(%eax),%esi
  800975:	8a 00                	mov    (%eax),%al
  800977:	0f be d8             	movsbl %al,%ebx
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	74 24                	je     8009a2 <vprintfmt+0x24b>
  80097e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800982:	78 b8                	js     80093c <vprintfmt+0x1e5>
  800984:	ff 4d e0             	decl   -0x20(%ebp)
  800987:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098b:	79 af                	jns    80093c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098d:	eb 13                	jmp    8009a2 <vprintfmt+0x24b>
				putch(' ', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	6a 20                	push   $0x20
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	ff d0                	call   *%eax
  80099c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099f:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7f e7                	jg     80098f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a8:	e9 78 01 00 00       	jmp    800b25 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	e8 3c fd ff ff       	call   8006f8 <getint>
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	79 23                	jns    8009f2 <vprintfmt+0x29b>
				putch('-', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 2d                	push   $0x2d
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e5:	f7 d8                	neg    %eax
  8009e7:	83 d2 00             	adc    $0x0,%edx
  8009ea:	f7 da                	neg    %edx
  8009ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f9:	e9 bc 00 00 00       	jmp    800aba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 e8             	pushl  -0x18(%ebp)
  800a04:	8d 45 14             	lea    0x14(%ebp),%eax
  800a07:	50                   	push   %eax
  800a08:	e8 84 fc ff ff       	call   800691 <getuint>
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a1d:	e9 98 00 00 00       	jmp    800aba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	6a 58                	push   $0x58
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	ff d0                	call   *%eax
  800a2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	6a 58                	push   $0x58
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	ff d0                	call   *%eax
  800a3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			break;
  800a52:	e9 ce 00 00 00       	jmp    800b25 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	6a 30                	push   $0x30
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	6a 78                	push   $0x78
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	83 c0 04             	add    $0x4,%eax
  800a7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	83 e8 04             	sub    $0x4,%eax
  800a86:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a92:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a99:	eb 1f                	jmp    800aba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa1:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa4:	50                   	push   %eax
  800aa5:	e8 e7 fb ff ff       	call   800691 <getuint>
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac1:	83 ec 04             	sub    $0x4,%esp
  800ac4:	52                   	push   %edx
  800ac5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac8:	50                   	push   %eax
  800ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  800acc:	ff 75 f0             	pushl  -0x10(%ebp)
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 00 fb ff ff       	call   8005da <printnum>
  800ada:	83 c4 20             	add    $0x20,%esp
			break;
  800add:	eb 46                	jmp    800b25 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	53                   	push   %ebx
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
			break;
  800aee:	eb 35                	jmp    800b25 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800af0:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800af7:	eb 2c                	jmp    800b25 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800af9:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800b00:	eb 23                	jmp    800b25 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 25                	push   $0x25
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b12:	ff 4d 10             	decl   0x10(%ebp)
  800b15:	eb 03                	jmp    800b1a <vprintfmt+0x3c3>
  800b17:	ff 4d 10             	decl   0x10(%ebp)
  800b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1d:	48                   	dec    %eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	3c 25                	cmp    $0x25,%al
  800b22:	75 f3                	jne    800b17 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b24:	90                   	nop
		}
	}
  800b25:	e9 35 fc ff ff       	jmp    80075f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b2a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2e:	5b                   	pop    %ebx
  800b2f:	5e                   	pop    %esi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b38:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3b:	83 c0 04             	add    $0x4,%eax
  800b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b41:	8b 45 10             	mov    0x10(%ebp),%eax
  800b44:	ff 75 f4             	pushl  -0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 04 fc ff ff       	call   800757 <vprintfmt>
  800b53:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b56:	90                   	nop
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 40 08             	mov    0x8(%eax),%eax
  800b62:	8d 50 01             	lea    0x1(%eax),%edx
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	8b 10                	mov    (%eax),%edx
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 40 04             	mov    0x4(%eax),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	73 12                	jae    800b8c <sprintputch+0x33>
		*b->buf++ = ch;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8b 00                	mov    (%eax),%eax
  800b7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b85:	89 0a                	mov    %ecx,(%edx)
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8a:	88 10                	mov    %dl,(%eax)
}
  800b8c:	90                   	nop
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	01 d0                	add    %edx,%eax
  800ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb4:	74 06                	je     800bbc <vsnprintf+0x2d>
  800bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bba:	7f 07                	jg     800bc3 <vsnprintf+0x34>
		return -E_INVAL;
  800bbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc1:	eb 20                	jmp    800be3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc3:	ff 75 14             	pushl  0x14(%ebp)
  800bc6:	ff 75 10             	pushl  0x10(%ebp)
  800bc9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bcc:	50                   	push   %eax
  800bcd:	68 59 0b 80 00       	push   $0x800b59
  800bd2:	e8 80 fb ff ff       	call   800757 <vprintfmt>
  800bd7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800beb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bee:	83 c0 04             	add    $0x4,%eax
  800bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfa:	50                   	push   %eax
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	ff 75 08             	pushl  0x8(%ebp)
  800c01:	e8 89 ff ff ff       	call   800b8f <vsnprintf>
  800c06:	83 c4 10             	add    $0x10,%esp
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1e:	eb 06                	jmp    800c26 <strlen+0x15>
		n++;
  800c20:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c23:	ff 45 08             	incl   0x8(%ebp)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	84 c0                	test   %al,%al
  800c2d:	75 f1                	jne    800c20 <strlen+0xf>
		n++;
	return n;
  800c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c41:	eb 09                	jmp    800c4c <strnlen+0x18>
		n++;
  800c43:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c46:	ff 45 08             	incl   0x8(%ebp)
  800c49:	ff 4d 0c             	decl   0xc(%ebp)
  800c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c50:	74 09                	je     800c5b <strnlen+0x27>
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	84 c0                	test   %al,%al
  800c59:	75 e8                	jne    800c43 <strnlen+0xf>
		n++;
	return n;
  800c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c6c:	90                   	nop
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	89 55 08             	mov    %edx,0x8(%ebp)
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7f:	8a 12                	mov    (%edx),%dl
  800c81:	88 10                	mov    %dl,(%eax)
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 e4                	jne    800c6d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca1:	eb 1f                	jmp    800cc2 <strncpy+0x34>
		*dst++ = *src;
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8d 50 01             	lea    0x1(%eax),%edx
  800ca9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800caf:	8a 12                	mov    (%edx),%dl
  800cb1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	74 03                	je     800cbf <strncpy+0x31>
			src++;
  800cbc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cbf:	ff 45 fc             	incl   -0x4(%ebp)
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc8:	72 d9                	jb     800ca3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdf:	74 30                	je     800d11 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ce1:	eb 16                	jmp    800cf9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8d 50 01             	lea    0x1(%eax),%edx
  800ce9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cef:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf5:	8a 12                	mov    (%edx),%dl
  800cf7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf9:	ff 4d 10             	decl   0x10(%ebp)
  800cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d00:	74 09                	je     800d0b <strlcpy+0x3c>
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	75 d8                	jne    800ce3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	29 c2                	sub    %eax,%edx
  800d19:	89 d0                	mov    %edx,%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d20:	eb 06                	jmp    800d28 <strcmp+0xb>
		p++, q++;
  800d22:	ff 45 08             	incl   0x8(%ebp)
  800d25:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	74 0e                	je     800d3f <strcmp+0x22>
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 10                	mov    (%eax),%dl
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	38 c2                	cmp    %al,%dl
  800d3d:	74 e3                	je     800d22 <strcmp+0x5>
		p++, q++;
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

00800d55 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d58:	eb 09                	jmp    800d63 <strncmp+0xe>
		n--, p++, q++;
  800d5a:	ff 4d 10             	decl   0x10(%ebp)
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	74 17                	je     800d80 <strncmp+0x2b>
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	74 0e                	je     800d80 <strncmp+0x2b>
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 10                	mov    (%eax),%dl
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	38 c2                	cmp    %al,%dl
  800d7e:	74 da                	je     800d5a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d84:	75 07                	jne    800d8d <strncmp+0x38>
		return 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8b:	eb 14                	jmp    800da1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	0f b6 d0             	movzbl %al,%edx
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	0f b6 c0             	movzbl %al,%eax
  800d9d:	29 c2                	sub    %eax,%edx
  800d9f:	89 d0                	mov    %edx,%eax
}
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 04             	sub    $0x4,%esp
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800daf:	eb 12                	jmp    800dc3 <strchr+0x20>
		if (*s == c)
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db9:	75 05                	jne    800dc0 <strchr+0x1d>
			return (char *) s;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	eb 11                	jmp    800dd1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	75 e5                	jne    800db1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 04             	sub    $0x4,%esp
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ddf:	eb 0d                	jmp    800dee <strfind+0x1b>
		if (*s == c)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de9:	74 0e                	je     800df9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800deb:	ff 45 08             	incl   0x8(%ebp)
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	84 c0                	test   %al,%al
  800df5:	75 ea                	jne    800de1 <strfind+0xe>
  800df7:	eb 01                	jmp    800dfa <strfind+0x27>
		if (*s == c)
			break;
  800df9:	90                   	nop
	return (char *) s;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e0b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e0f:	76 63                	jbe    800e74 <memset+0x75>
		uint64 data_block = c;
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	99                   	cltd   
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e21:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e25:	c1 e0 08             	shl    $0x8,%eax
  800e28:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e34:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e38:	c1 e0 10             	shl    $0x10,%eax
  800e3b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e51:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e54:	eb 18                	jmp    800e6e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e56:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e59:	8d 41 08             	lea    0x8(%ecx),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	89 01                	mov    %eax,(%ecx)
  800e67:	89 51 04             	mov    %edx,0x4(%ecx)
  800e6a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e6e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e72:	77 e2                	ja     800e56 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	74 23                	je     800e9d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 0e                	jmp    800e90 <memset+0x91>
			*p8++ = (uint8)c;
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e96:	89 55 10             	mov    %edx,0x10(%ebp)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 e5                	jne    800e82 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eb4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb8:	76 24                	jbe    800ede <memcpy+0x3c>
		while(n >= 8){
  800eba:	eb 1c                	jmp    800ed8 <memcpy+0x36>
			*d64 = *s64;
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	8b 50 04             	mov    0x4(%eax),%edx
  800ec2:	8b 00                	mov    (%eax),%eax
  800ec4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ec7:	89 01                	mov    %eax,(%ecx)
  800ec9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ecc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ed0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ed4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ed8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edc:	77 de                	ja     800ebc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 31                	je     800f15 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800eea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ef0:	eb 16                	jmp    800f08 <memcpy+0x66>
			*d8++ = *s8++;
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8d 50 01             	lea    0x1(%eax),%edx
  800ef8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f01:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f04:	8a 12                	mov    (%edx),%dl
  800f06:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	75 dd                	jne    800ef2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f32:	73 50                	jae    800f84 <memmove+0x6a>
  800f34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	01 d0                	add    %edx,%eax
  800f3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f3f:	76 43                	jbe    800f84 <memmove+0x6a>
		s += n;
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f4d:	eb 10                	jmp    800f5f <memmove+0x45>
			*--d = *--s;
  800f4f:	ff 4d f8             	decl   -0x8(%ebp)
  800f52:	ff 4d fc             	decl   -0x4(%ebp)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 e3                	jne    800f4f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f6c:	eb 23                	jmp    800f91 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	8d 50 01             	lea    0x1(%eax),%edx
  800f74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f80:	8a 12                	mov    (%edx),%dl
  800f82:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	75 dd                	jne    800f6e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fa8:	eb 2a                	jmp    800fd4 <memcmp+0x3e>
		if (*s1 != *s2)
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	8a 10                	mov    (%eax),%dl
  800faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	38 c2                	cmp    %al,%dl
  800fb6:	74 16                	je     800fce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f b6 d0             	movzbl %al,%edx
  800fc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f b6 c0             	movzbl %al,%eax
  800fc8:	29 c2                	sub    %eax,%edx
  800fca:	89 d0                	mov    %edx,%eax
  800fcc:	eb 18                	jmp    800fe6 <memcmp+0x50>
		s1++, s2++;
  800fce:	ff 45 fc             	incl   -0x4(%ebp)
  800fd1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fda:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	75 c9                	jne    800faa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff4:	01 d0                	add    %edx,%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ff9:	eb 15                	jmp    801010 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 d0             	movzbl %al,%edx
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	0f b6 c0             	movzbl %al,%eax
  801009:	39 c2                	cmp    %eax,%edx
  80100b:	74 0d                	je     80101a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801016:	72 e3                	jb     800ffb <memfind+0x13>
  801018:	eb 01                	jmp    80101b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80101a:	90                   	nop
	return (void *) s;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80102d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801034:	eb 03                	jmp    801039 <strtol+0x19>
		s++;
  801036:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 20                	cmp    $0x20,%al
  801040:	74 f4                	je     801036 <strtol+0x16>
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 09                	cmp    $0x9,%al
  801049:	74 eb                	je     801036 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2b                	cmp    $0x2b,%al
  801052:	75 05                	jne    801059 <strtol+0x39>
		s++;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	eb 13                	jmp    80106c <strtol+0x4c>
	else if (*s == '-')
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 2d                	cmp    $0x2d,%al
  801060:	75 0a                	jne    80106c <strtol+0x4c>
		s++, neg = 1;
  801062:	ff 45 08             	incl   0x8(%ebp)
  801065:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 06                	je     801078 <strtol+0x58>
  801072:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801076:	75 20                	jne    801098 <strtol+0x78>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3c 30                	cmp    $0x30,%al
  80107f:	75 17                	jne    801098 <strtol+0x78>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	40                   	inc    %eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 78                	cmp    $0x78,%al
  801089:	75 0d                	jne    801098 <strtol+0x78>
		s += 2, base = 16;
  80108b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80108f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801096:	eb 28                	jmp    8010c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801098:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109c:	75 15                	jne    8010b3 <strtol+0x93>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 30                	cmp    $0x30,%al
  8010a5:	75 0c                	jne    8010b3 <strtol+0x93>
		s++, base = 8;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b1:	eb 0d                	jmp    8010c0 <strtol+0xa0>
	else if (base == 0)
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	75 07                	jne    8010c0 <strtol+0xa0>
		base = 10;
  8010b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 2f                	cmp    $0x2f,%al
  8010c7:	7e 19                	jle    8010e2 <strtol+0xc2>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 39                	cmp    $0x39,%al
  8010d0:	7f 10                	jg     8010e2 <strtol+0xc2>
			dig = *s - '0';
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be c0             	movsbl %al,%eax
  8010da:	83 e8 30             	sub    $0x30,%eax
  8010dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e0:	eb 42                	jmp    801124 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 60                	cmp    $0x60,%al
  8010e9:	7e 19                	jle    801104 <strtol+0xe4>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 7a                	cmp    $0x7a,%al
  8010f2:	7f 10                	jg     801104 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be c0             	movsbl %al,%eax
  8010fc:	83 e8 57             	sub    $0x57,%eax
  8010ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801102:	eb 20                	jmp    801124 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 40                	cmp    $0x40,%al
  80110b:	7e 39                	jle    801146 <strtol+0x126>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 5a                	cmp    $0x5a,%al
  801114:	7f 30                	jg     801146 <strtol+0x126>
			dig = *s - 'A' + 10;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	83 e8 37             	sub    $0x37,%eax
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	3b 45 10             	cmp    0x10(%ebp),%eax
  80112a:	7d 19                	jge    801145 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80112c:	ff 45 08             	incl   0x8(%ebp)
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	0f af 45 10          	imul   0x10(%ebp),%eax
  801136:	89 c2                	mov    %eax,%edx
  801138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801140:	e9 7b ff ff ff       	jmp    8010c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801145:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801146:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114a:	74 08                	je     801154 <strtol+0x134>
		*endptr = (char *) s;
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801154:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801158:	74 07                	je     801161 <strtol+0x141>
  80115a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115d:	f7 d8                	neg    %eax
  80115f:	eb 03                	jmp    801164 <strtol+0x144>
  801161:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <ltostr>:

void
ltostr(long value, char *str)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801173:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80117a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117e:	79 13                	jns    801193 <ltostr+0x2d>
	{
		neg = 1;
  801180:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80118d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801190:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80119b:	99                   	cltd   
  80119c:	f7 f9                	idiv   %ecx
  80119e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	8d 50 01             	lea    0x1(%eax),%edx
  8011a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	01 d0                	add    %edx,%eax
  8011b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b4:	83 c2 30             	add    $0x30,%edx
  8011b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c1:	f7 e9                	imul   %ecx
  8011c3:	c1 fa 02             	sar    $0x2,%edx
  8011c6:	89 c8                	mov    %ecx,%eax
  8011c8:	c1 f8 1f             	sar    $0x1f,%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d6:	75 bb                	jne    801193 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e2:	48                   	dec    %eax
  8011e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ea:	74 3d                	je     801229 <ltostr+0xc3>
		start = 1 ;
  8011ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f3:	eb 34                	jmp    801229 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c2                	add    %eax,%edx
  80120a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	01 c8                	add    %ecx,%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801216:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c2                	add    %eax,%edx
  80121e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801221:	88 02                	mov    %al,(%edx)
		start++ ;
  801223:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801226:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122f:	7c c4                	jl     8011f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801231:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123c:	90                   	nop
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801245:	ff 75 08             	pushl  0x8(%ebp)
  801248:	e8 c4 f9 ff ff       	call   800c11 <strlen>
  80124d:	83 c4 04             	add    $0x4,%esp
  801250:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	e8 b6 f9 ff ff       	call   800c11 <strlen>
  80125b:	83 c4 04             	add    $0x4,%esp
  80125e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 17                	jmp    801288 <strcconcat+0x49>
		final[s] = str1[s] ;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 c2                	add    %eax,%edx
  801279:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	01 c8                	add    %ecx,%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801285:	ff 45 fc             	incl   -0x4(%ebp)
  801288:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128e:	7c e1                	jl     801271 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801297:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129e:	eb 1f                	jmp    8012bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 c2                	add    %eax,%edx
  8012b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	01 c8                	add    %ecx,%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bc:	ff 45 f8             	incl   -0x8(%ebp)
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c5:	7c d9                	jl     8012a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e4:	8b 00                	mov    (%eax),%eax
  8012e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f8:	eb 0c                	jmp    801306 <strsplit+0x31>
			*string++ = 0;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8d 50 01             	lea    0x1(%eax),%edx
  801300:	89 55 08             	mov    %edx,0x8(%ebp)
  801303:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	84 c0                	test   %al,%al
  80130d:	74 18                	je     801327 <strsplit+0x52>
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f be c0             	movsbl %al,%eax
  801317:	50                   	push   %eax
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	e8 83 fa ff ff       	call   800da3 <strchr>
  801320:	83 c4 08             	add    $0x8,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	75 d3                	jne    8012fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	84 c0                	test   %al,%al
  80132e:	74 5a                	je     80138a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801330:	8b 45 14             	mov    0x14(%ebp),%eax
  801333:	8b 00                	mov    (%eax),%eax
  801335:	83 f8 0f             	cmp    $0xf,%eax
  801338:	75 07                	jne    801341 <strsplit+0x6c>
		{
			return 0;
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	eb 66                	jmp    8013a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	8b 00                	mov    (%eax),%eax
  801346:	8d 48 01             	lea    0x1(%eax),%ecx
  801349:	8b 55 14             	mov    0x14(%ebp),%edx
  80134c:	89 0a                	mov    %ecx,(%edx)
  80134e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801355:	8b 45 10             	mov    0x10(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135f:	eb 03                	jmp    801364 <strsplit+0x8f>
			string++;
  801361:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	84 c0                	test   %al,%al
  80136b:	74 8b                	je     8012f8 <strsplit+0x23>
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8a 00                	mov    (%eax),%al
  801372:	0f be c0             	movsbl %al,%eax
  801375:	50                   	push   %eax
  801376:	ff 75 0c             	pushl  0xc(%ebp)
  801379:	e8 25 fa ff ff       	call   800da3 <strchr>
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	74 dc                	je     801361 <strsplit+0x8c>
			string++;
	}
  801385:	e9 6e ff ff ff       	jmp    8012f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138b:	8b 45 14             	mov    0x14(%ebp),%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801397:	8b 45 10             	mov    0x10(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bc:	eb 4a                	jmp    801408 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	01 c2                	add    %eax,%edx
  8013c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 c8                	add    %ecx,%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	3c 40                	cmp    $0x40,%al
  8013de:	7e 25                	jle    801405 <str2lower+0x5c>
  8013e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	01 d0                	add    %edx,%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	3c 5a                	cmp    $0x5a,%al
  8013ec:	7f 17                	jg     801405 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fc:	01 ca                	add    %ecx,%edx
  8013fe:	8a 12                	mov    (%edx),%dl
  801400:	83 c2 20             	add    $0x20,%edx
  801403:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801405:	ff 45 fc             	incl   -0x4(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	e8 01 f8 ff ff       	call   800c11 <strlen>
  801410:	83 c4 04             	add    $0x4,%esp
  801413:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801416:	7f a6                	jg     8013be <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801418:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801423:	a1 08 40 80 00       	mov    0x804008,%eax
  801428:	85 c0                	test   %eax,%eax
  80142a:	74 42                	je     80146e <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80142c:	83 ec 08             	sub    $0x8,%esp
  80142f:	68 00 00 00 82       	push   $0x82000000
  801434:	68 00 00 00 80       	push   $0x80000000
  801439:	e8 00 08 00 00       	call   801c3e <initialize_dynamic_allocator>
  80143e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801441:	e8 e7 05 00 00       	call   801a2d <sys_get_uheap_strategy>
  801446:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80144b:	a1 40 40 80 00       	mov    0x804040,%eax
  801450:	05 00 10 00 00       	add    $0x1000,%eax
  801455:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80145a:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80145f:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801464:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80146b:	00 00 00 
	}
}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	68 06 04 00 00       	push   $0x406
  80148d:	50                   	push   %eax
  80148e:	e8 e4 01 00 00       	call   801677 <__sys_allocate_page>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80149d:	79 14                	jns    8014b3 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	68 08 32 80 00       	push   $0x803208
  8014a7:	6a 1f                	push   $0x1f
  8014a9:	68 44 32 80 00       	push   $0x803244
  8014ae:	e8 ab 13 00 00       	call   80285e <_panic>
	return 0;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	50                   	push   %eax
  8014d2:	e8 e7 01 00 00       	call   8016be <__sys_unmap_frame>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014e1:	79 14                	jns    8014f7 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 50 32 80 00       	push   $0x803250
  8014eb:	6a 2a                	push   $0x2a
  8014ed:	68 44 32 80 00       	push   $0x803244
  8014f2:	e8 67 13 00 00       	call   80285e <_panic>
}
  8014f7:	90                   	nop
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801500:	e8 18 ff ff ff       	call   80141d <uheap_init>
	if (size == 0) return NULL ;
  801505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801509:	75 07                	jne    801512 <malloc+0x18>
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	eb 14                	jmp    801526 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	68 90 32 80 00       	push   $0x803290
  80151a:	6a 3e                	push   $0x3e
  80151c:	68 44 32 80 00       	push   $0x803244
  801521:	e8 38 13 00 00       	call   80285e <_panic>
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 b8 32 80 00       	push   $0x8032b8
  801536:	6a 49                	push   $0x49
  801538:	68 44 32 80 00       	push   $0x803244
  80153d:	e8 1c 13 00 00       	call   80285e <_panic>

00801542 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 18             	sub    $0x18,%esp
  801548:	8b 45 10             	mov    0x10(%ebp),%eax
  80154b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80154e:	e8 ca fe ff ff       	call   80141d <uheap_init>
	if (size == 0) return NULL ;
  801553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801557:	75 07                	jne    801560 <smalloc+0x1e>
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 14                	jmp    801574 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	68 dc 32 80 00       	push   $0x8032dc
  801568:	6a 5a                	push   $0x5a
  80156a:	68 44 32 80 00       	push   $0x803244
  80156f:	e8 ea 12 00 00       	call   80285e <_panic>
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80157c:	e8 9c fe ff ff       	call   80141d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	68 04 33 80 00       	push   $0x803304
  801589:	6a 6a                	push   $0x6a
  80158b:	68 44 32 80 00       	push   $0x803244
  801590:	e8 c9 12 00 00       	call   80285e <_panic>

00801595 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80159b:	e8 7d fe ff ff       	call   80141d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	68 28 33 80 00       	push   $0x803328
  8015a8:	68 88 00 00 00       	push   $0x88
  8015ad:	68 44 32 80 00       	push   $0x803244
  8015b2:	e8 a7 12 00 00       	call   80285e <_panic>

008015b7 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 50 33 80 00       	push   $0x803350
  8015c5:	68 9b 00 00 00       	push   $0x9b
  8015ca:	68 44 32 80 00       	push   $0x803244
  8015cf:	e8 8a 12 00 00       	call   80285e <_panic>

008015d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015ef:	cd 30                	int    $0x30
  8015f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80160b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80160e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	6a 00                	push   $0x0
  801617:	51                   	push   %ecx
  801618:	52                   	push   %edx
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	6a 00                	push   $0x0
  80161f:	e8 b0 ff ff ff       	call   8015d4 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_cgetc>:

int
sys_cgetc(void)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 02                	push   $0x2
  801639:	e8 96 ff ff ff       	call   8015d4 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 03                	push   $0x3
  801652:	e8 7d ff ff ff       	call   8015d4 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 04                	push   $0x4
  80166c:	e8 63 ff ff ff       	call   8015d4 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80167a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	52                   	push   %edx
  801687:	50                   	push   %eax
  801688:	6a 08                	push   $0x8
  80168a:	e8 45 ff ff ff       	call   8015d4 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801699:	8b 75 18             	mov    0x18(%ebp),%esi
  80169c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80169f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	51                   	push   %ecx
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	6a 09                	push   $0x9
  8016af:	e8 20 ff ff ff       	call   8015d4 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	ff 75 08             	pushl  0x8(%ebp)
  8016cc:	6a 0a                	push   $0xa
  8016ce:	e8 01 ff ff ff       	call   8015d4 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 0b                	push   $0xb
  8016e9:	e8 e6 fe ff ff       	call   8015d4 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 0c                	push   $0xc
  801702:	e8 cd fe ff ff       	call   8015d4 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 0d                	push   $0xd
  80171b:	e8 b4 fe ff ff       	call   8015d4 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 0e                	push   $0xe
  801734:	e8 9b fe ff ff       	call   8015d4 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 0f                	push   $0xf
  80174d:	e8 82 fe ff ff       	call   8015d4 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 10                	push   $0x10
  801767:	e8 68 fe ff ff       	call   8015d4 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 11                	push   $0x11
  801780:	e8 4f fe ff ff       	call   8015d4 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_cputc>:

void
sys_cputc(const char c)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801797:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 01                	push   $0x1
  8017a6:	e8 29 fe ff ff       	call   8015d4 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 14                	push   $0x14
  8017c0:	e8 0f fe ff ff       	call   8015d4 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	51                   	push   %ecx
  8017e4:	52                   	push   %edx
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	50                   	push   %eax
  8017e9:	6a 15                	push   $0x15
  8017eb:	e8 e4 fd ff ff       	call   8015d4 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 16                	push   $0x16
  801808:	e8 c7 fd ff ff       	call   8015d4 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801815:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	51                   	push   %ecx
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 17                	push   $0x17
  801827:	e8 a8 fd ff ff       	call   8015d4 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 18                	push   $0x18
  801844:	e8 8b fd ff ff       	call   8015d4 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	ff 75 14             	pushl  0x14(%ebp)
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	6a 19                	push   $0x19
  801862:	e8 6d fd ff ff       	call   8015d4 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	50                   	push   %eax
  80187b:	6a 1a                	push   $0x1a
  80187d:	e8 52 fd ff ff       	call   8015d4 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	50                   	push   %eax
  801897:	6a 1b                	push   $0x1b
  801899:	e8 36 fd ff ff       	call   8015d4 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 05                	push   $0x5
  8018b2:	e8 1d fd ff ff       	call   8015d4 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 06                	push   $0x6
  8018cb:	e8 04 fd ff ff       	call   8015d4 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 07                	push   $0x7
  8018e4:	e8 eb fc ff ff       	call   8015d4 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_exit_env>:


void sys_exit_env(void)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 1c                	push   $0x1c
  8018fd:	e8 d2 fc ff ff       	call   8015d4 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	90                   	nop
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801911:	8d 50 04             	lea    0x4(%eax),%edx
  801914:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 1d                	push   $0x1d
  801921:	e8 ae fc ff ff       	call   8015d4 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
	return result;
  801929:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801932:	89 01                	mov    %eax,(%ecx)
  801934:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	c9                   	leave  
  80193b:	c2 04 00             	ret    $0x4

0080193e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 13                	push   $0x13
  801950:	e8 7f fc ff ff       	call   8015d4 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_rcr2>:
uint32 sys_rcr2()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 1e                	push   $0x1e
  80196a:	e8 65 fc ff ff       	call   8015d4 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801980:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	50                   	push   %eax
  80198d:	6a 1f                	push   $0x1f
  80198f:	e8 40 fc ff ff       	call   8015d4 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return ;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <rsttst>:
void rsttst()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 21                	push   $0x21
  8019a9:	e8 26 fc ff ff       	call   8015d4 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 20                	push   $0x20
  8019d4:	e8 fb fb ff ff       	call   8015d4 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <chktst>:
void chktst(uint32 n)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 22                	push   $0x22
  8019ef:	e8 e0 fb ff ff       	call   8015d4 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <inctst>:

void inctst()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 23                	push   $0x23
  801a09:	e8 c6 fb ff ff       	call   8015d4 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a11:	90                   	nop
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <gettst>:
uint32 gettst()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 24                	push   $0x24
  801a23:	e8 ac fb ff ff       	call   8015d4 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 25                	push   $0x25
  801a3c:	e8 93 fb ff ff       	call   8015d4 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
  801a44:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801a49:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	6a 26                	push   $0x26
  801a68:	e8 67 fb ff ff       	call   8015d4 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a70:	90                   	nop
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	53                   	push   %ebx
  801a86:	51                   	push   %ecx
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 27                	push   $0x27
  801a8b:	e8 44 fb ff ff       	call   8015d4 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 28                	push   $0x28
  801aab:	e8 24 fb ff ff       	call   8015d4 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ab8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	51                   	push   %ecx
  801ac4:	ff 75 10             	pushl  0x10(%ebp)
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 29                	push   $0x29
  801acb:	e8 04 fb ff ff       	call   8015d4 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 12                	push   $0x12
  801ae7:	e8 e8 fa ff ff       	call   8015d4 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	52                   	push   %edx
  801b02:	50                   	push   %eax
  801b03:	6a 2a                	push   $0x2a
  801b05:	e8 ca fa ff ff       	call   8015d4 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 2b                	push   $0x2b
  801b1f:	e8 b0 fa ff ff       	call   8015d4 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 2d                	push   $0x2d
  801b3a:	e8 95 fa ff ff       	call   8015d4 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	6a 2c                	push   $0x2c
  801b56:	e8 79 fa ff ff       	call   8015d4 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 74 33 80 00       	push   $0x803374
  801b6f:	68 25 01 00 00       	push   $0x125
  801b74:	68 a7 33 80 00       	push   $0x8033a7
  801b79:	e8 e0 0c 00 00       	call   80285e <_panic>

00801b7e <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801b84:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801b8b:	72 09                	jb     801b96 <to_page_va+0x18>
  801b8d:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801b94:	72 14                	jb     801baa <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	68 b8 33 80 00       	push   $0x8033b8
  801b9e:	6a 15                	push   $0x15
  801ba0:	68 e3 33 80 00       	push   $0x8033e3
  801ba5:	e8 b4 0c 00 00       	call   80285e <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ba 60 40 80 00       	mov    $0x804060,%edx
  801bb2:	29 d0                	sub    %edx,%eax
  801bb4:	c1 f8 02             	sar    $0x2,%eax
  801bb7:	89 c2                	mov    %eax,%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	c1 e0 02             	shl    $0x2,%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	c1 e0 02             	shl    $0x2,%eax
  801bc3:	01 d0                	add    %edx,%eax
  801bc5:	c1 e0 02             	shl    $0x2,%eax
  801bc8:	01 d0                	add    %edx,%eax
  801bca:	89 c1                	mov    %eax,%ecx
  801bcc:	c1 e1 08             	shl    $0x8,%ecx
  801bcf:	01 c8                	add    %ecx,%eax
  801bd1:	89 c1                	mov    %eax,%ecx
  801bd3:	c1 e1 10             	shl    $0x10,%ecx
  801bd6:	01 c8                	add    %ecx,%eax
  801bd8:	01 c0                	add    %eax,%eax
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	c1 e0 0c             	shl    $0xc,%eax
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801bec:	01 d0                	add    %edx,%eax
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801bf6:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfe:	29 c2                	sub    %eax,%edx
  801c00:	89 d0                	mov    %edx,%eax
  801c02:	c1 e8 0c             	shr    $0xc,%eax
  801c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0c:	78 09                	js     801c17 <to_page_info+0x27>
  801c0e:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c15:	7e 14                	jle    801c2b <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 fc 33 80 00       	push   $0x8033fc
  801c1f:	6a 22                	push   $0x22
  801c21:	68 e3 33 80 00       	push   $0x8033e3
  801c26:	e8 33 0c 00 00       	call   80285e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2e:	89 d0                	mov    %edx,%eax
  801c30:	01 c0                	add    %eax,%eax
  801c32:	01 d0                	add    %edx,%eax
  801c34:	c1 e0 02             	shl    $0x2,%eax
  801c37:	05 60 40 80 00       	add    $0x804060,%eax
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	05 00 00 00 02       	add    $0x2000000,%eax
  801c4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c4f:	73 16                	jae    801c67 <initialize_dynamic_allocator+0x29>
  801c51:	68 20 34 80 00       	push   $0x803420
  801c56:	68 46 34 80 00       	push   $0x803446
  801c5b:	6a 34                	push   $0x34
  801c5d:	68 e3 33 80 00       	push   $0x8033e3
  801c62:	e8 f7 0b 00 00       	call   80285e <_panic>
		is_initialized = 1;
  801c67:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801c6e:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7c:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801c81:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801c88:	00 00 00 
  801c8b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801c92:	00 00 00 
  801c95:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801c9c:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	2b 45 08             	sub    0x8(%ebp),%eax
  801ca5:	c1 e8 0c             	shr    $0xc,%eax
  801ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cb2:	e9 c8 00 00 00       	jmp    801d7f <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	01 c0                	add    %eax,%eax
  801cbe:	01 d0                	add    %edx,%eax
  801cc0:	c1 e0 02             	shl    $0x2,%eax
  801cc3:	05 68 40 80 00       	add    $0x804068,%eax
  801cc8:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd0:	89 d0                	mov    %edx,%eax
  801cd2:	01 c0                	add    %eax,%eax
  801cd4:	01 d0                	add    %edx,%eax
  801cd6:	c1 e0 02             	shl    $0x2,%eax
  801cd9:	05 6a 40 80 00       	add    $0x80406a,%eax
  801cde:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801ce3:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ce9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801cec:	89 c8                	mov    %ecx,%eax
  801cee:	01 c0                	add    %eax,%eax
  801cf0:	01 c8                	add    %ecx,%eax
  801cf2:	c1 e0 02             	shl    $0x2,%eax
  801cf5:	05 64 40 80 00       	add    $0x804064,%eax
  801cfa:	89 10                	mov    %edx,(%eax)
  801cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cff:	89 d0                	mov    %edx,%eax
  801d01:	01 c0                	add    %eax,%eax
  801d03:	01 d0                	add    %edx,%eax
  801d05:	c1 e0 02             	shl    $0x2,%eax
  801d08:	05 64 40 80 00       	add    $0x804064,%eax
  801d0d:	8b 00                	mov    (%eax),%eax
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	74 1b                	je     801d2e <initialize_dynamic_allocator+0xf0>
  801d13:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d1c:	89 c8                	mov    %ecx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 c8                	add    %ecx,%eax
  801d22:	c1 e0 02             	shl    $0x2,%eax
  801d25:	05 60 40 80 00       	add    $0x804060,%eax
  801d2a:	89 02                	mov    %eax,(%edx)
  801d2c:	eb 16                	jmp    801d44 <initialize_dynamic_allocator+0x106>
  801d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d31:	89 d0                	mov    %edx,%eax
  801d33:	01 c0                	add    %eax,%eax
  801d35:	01 d0                	add    %edx,%eax
  801d37:	c1 e0 02             	shl    $0x2,%eax
  801d3a:	05 60 40 80 00       	add    $0x804060,%eax
  801d3f:	a3 48 40 80 00       	mov    %eax,0x804048
  801d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	01 c0                	add    %eax,%eax
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	c1 e0 02             	shl    $0x2,%eax
  801d50:	05 60 40 80 00       	add    $0x804060,%eax
  801d55:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5d:	89 d0                	mov    %edx,%eax
  801d5f:	01 c0                	add    %eax,%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	c1 e0 02             	shl    $0x2,%eax
  801d66:	05 60 40 80 00       	add    $0x804060,%eax
  801d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d71:	a1 54 40 80 00       	mov    0x804054,%eax
  801d76:	40                   	inc    %eax
  801d77:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d7c:	ff 45 f4             	incl   -0xc(%ebp)
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d85:	0f 8c 2c ff ff ff    	jl     801cb7 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801d8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801d92:	eb 36                	jmp    801dca <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d97:	c1 e0 04             	shl    $0x4,%eax
  801d9a:	05 80 c0 81 00       	add    $0x81c080,%eax
  801d9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	c1 e0 04             	shl    $0x4,%eax
  801dab:	05 84 c0 81 00       	add    $0x81c084,%eax
  801db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db9:	c1 e0 04             	shl    $0x4,%eax
  801dbc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801dc7:	ff 45 f0             	incl   -0x10(%ebp)
  801dca:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801dce:	7e c4                	jle    801d94 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	50                   	push   %eax
  801de0:	e8 0b fe ff ff       	call   801bf0 <to_page_info>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	e8 77 fd ff ff       	call   801b7e <to_page_va>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801e0d:	b8 00 10 00 00       	mov    $0x1000,%eax
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	f7 75 08             	divl   0x8(%ebp)
  801e1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	50                   	push   %eax
  801e24:	e8 48 f6 ff ff       	call   801471 <get_page>
  801e29:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e32:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3c:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801e40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e47:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801e4e:	eb 19                	jmp    801e69 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	ba 01 00 00 00       	mov    $0x1,%edx
  801e58:	88 c1                	mov    %al,%cl
  801e5a:	d3 e2                	shl    %cl,%edx
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e61:	74 0e                	je     801e71 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801e63:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e66:	ff 45 f0             	incl   -0x10(%ebp)
  801e69:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801e6d:	7e e1                	jle    801e50 <split_page_to_blocks+0x5a>
  801e6f:	eb 01                	jmp    801e72 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801e71:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801e72:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e79:	e9 a7 00 00 00       	jmp    801f25 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	0f af 45 08          	imul   0x8(%ebp),%eax
  801e85:	89 c2                	mov    %eax,%edx
  801e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801e8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e93:	75 14                	jne    801ea9 <split_page_to_blocks+0xb3>
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 5c 34 80 00       	push   $0x80345c
  801e9d:	6a 7c                	push   $0x7c
  801e9f:	68 e3 33 80 00       	push   $0x8033e3
  801ea4:	e8 b5 09 00 00       	call   80285e <_panic>
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	c1 e0 04             	shl    $0x4,%eax
  801eaf:	05 84 c0 81 00       	add    $0x81c084,%eax
  801eb4:	8b 10                	mov    (%eax),%edx
  801eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb9:	89 50 04             	mov    %edx,0x4(%eax)
  801ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebf:	8b 40 04             	mov    0x4(%eax),%eax
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	74 14                	je     801eda <split_page_to_blocks+0xe4>
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	c1 e0 04             	shl    $0x4,%eax
  801ecc:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ed1:	8b 00                	mov    (%eax),%eax
  801ed3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed6:	89 10                	mov    %edx,(%eax)
  801ed8:	eb 11                	jmp    801eeb <split_page_to_blocks+0xf5>
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	c1 e0 04             	shl    $0x4,%eax
  801ee0:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee9:	89 02                	mov    %eax,(%edx)
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	c1 e0 04             	shl    $0x4,%eax
  801ef1:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801efa:	89 02                	mov    %eax,(%edx)
  801efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	c1 e0 04             	shl    $0x4,%eax
  801f0b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f10:	8b 00                	mov    (%eax),%eax
  801f12:	8d 50 01             	lea    0x1(%eax),%edx
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	c1 e0 04             	shl    $0x4,%eax
  801f1b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f20:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f22:	ff 45 ec             	incl   -0x14(%ebp)
  801f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f28:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f2b:	0f 82 4d ff ff ff    	jb     801e7e <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f3a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f41:	76 19                	jbe    801f5c <alloc_block+0x28>
  801f43:	68 80 34 80 00       	push   $0x803480
  801f48:	68 46 34 80 00       	push   $0x803446
  801f4d:	68 8a 00 00 00       	push   $0x8a
  801f52:	68 e3 33 80 00       	push   $0x8033e3
  801f57:	e8 02 09 00 00       	call   80285e <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f63:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f6a:	eb 19                	jmp    801f85 <alloc_block+0x51>
		if((1 << i) >= size) break;
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6f:	ba 01 00 00 00       	mov    $0x1,%edx
  801f74:	88 c1                	mov    %al,%cl
  801f76:	d3 e2                	shl    %cl,%edx
  801f78:	89 d0                	mov    %edx,%eax
  801f7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f7d:	73 0e                	jae    801f8d <alloc_block+0x59>
		idx++;
  801f7f:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f82:	ff 45 f0             	incl   -0x10(%ebp)
  801f85:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f89:	7e e1                	jle    801f6c <alloc_block+0x38>
  801f8b:	eb 01                	jmp    801f8e <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801f8d:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	c1 e0 04             	shl    $0x4,%eax
  801f94:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	0f 84 df 00 00 00    	je     802082 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	c1 e0 04             	shl    $0x4,%eax
  801fa9:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  801fb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fb7:	75 17                	jne    801fd0 <alloc_block+0x9c>
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 a1 34 80 00       	push   $0x8034a1
  801fc1:	68 9e 00 00 00       	push   $0x9e
  801fc6:	68 e3 33 80 00       	push   $0x8033e3
  801fcb:	e8 8e 08 00 00       	call   80285e <_panic>
  801fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd3:	8b 00                	mov    (%eax),%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	74 10                	je     801fe9 <alloc_block+0xb5>
  801fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdc:	8b 00                	mov    (%eax),%eax
  801fde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe1:	8b 52 04             	mov    0x4(%edx),%edx
  801fe4:	89 50 04             	mov    %edx,0x4(%eax)
  801fe7:	eb 14                	jmp    801ffd <alloc_block+0xc9>
  801fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fec:	8b 40 04             	mov    0x4(%eax),%eax
  801fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff2:	c1 e2 04             	shl    $0x4,%edx
  801ff5:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  801ffb:	89 02                	mov    %eax,(%edx)
  801ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802000:	8b 40 04             	mov    0x4(%eax),%eax
  802003:	85 c0                	test   %eax,%eax
  802005:	74 0f                	je     802016 <alloc_block+0xe2>
  802007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200a:	8b 40 04             	mov    0x4(%eax),%eax
  80200d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802010:	8b 12                	mov    (%edx),%edx
  802012:	89 10                	mov    %edx,(%eax)
  802014:	eb 13                	jmp    802029 <alloc_block+0xf5>
  802016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802027:	89 02                	mov    %eax,(%edx)
  802029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802035:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	c1 e0 04             	shl    $0x4,%eax
  802042:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	c1 e0 04             	shl    $0x4,%eax
  802052:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802057:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	50                   	push   %eax
  802060:	e8 8b fb ff ff       	call   801bf0 <to_page_info>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80206b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802072:	48                   	dec    %eax
  802073:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802076:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	e9 bc 02 00 00       	jmp    80233e <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802082:	a1 54 40 80 00       	mov    0x804054,%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	0f 84 7d 02 00 00    	je     80230c <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80208f:	a1 48 40 80 00       	mov    0x804048,%eax
  802094:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802097:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80209b:	75 17                	jne    8020b4 <alloc_block+0x180>
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 a1 34 80 00       	push   $0x8034a1
  8020a5:	68 a9 00 00 00       	push   $0xa9
  8020aa:	68 e3 33 80 00       	push   $0x8033e3
  8020af:	e8 aa 07 00 00       	call   80285e <_panic>
  8020b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 10                	je     8020cd <alloc_block+0x199>
  8020bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c0:	8b 00                	mov    (%eax),%eax
  8020c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020c5:	8b 52 04             	mov    0x4(%edx),%edx
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	eb 0b                	jmp    8020d8 <alloc_block+0x1a4>
  8020cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d0:	8b 40 04             	mov    0x4(%eax),%eax
  8020d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 0f                	je     8020f1 <alloc_block+0x1bd>
  8020e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e5:	8b 40 04             	mov    0x4(%eax),%eax
  8020e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020eb:	8b 12                	mov    (%edx),%edx
  8020ed:	89 10                	mov    %edx,(%eax)
  8020ef:	eb 0a                	jmp    8020fb <alloc_block+0x1c7>
  8020f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	a3 48 40 80 00       	mov    %eax,0x804048
  8020fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210e:	a1 54 40 80 00       	mov    0x804054,%eax
  802113:	48                   	dec    %eax
  802114:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	83 c0 03             	add    $0x3,%eax
  80211f:	ba 01 00 00 00       	mov    $0x1,%edx
  802124:	88 c1                	mov    %al,%cl
  802126:	d3 e2                	shl    %cl,%edx
  802128:	89 d0                	mov    %edx,%eax
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802130:	50                   	push   %eax
  802131:	e8 c0 fc ff ff       	call   801df6 <split_page_to_blocks>
  802136:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	c1 e0 04             	shl    $0x4,%eax
  80213f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802149:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80214d:	75 17                	jne    802166 <alloc_block+0x232>
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	68 a1 34 80 00       	push   $0x8034a1
  802157:	68 b0 00 00 00       	push   $0xb0
  80215c:	68 e3 33 80 00       	push   $0x8033e3
  802161:	e8 f8 06 00 00       	call   80285e <_panic>
  802166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 10                	je     80217f <alloc_block+0x24b>
  80216f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802177:	8b 52 04             	mov    0x4(%edx),%edx
  80217a:	89 50 04             	mov    %edx,0x4(%eax)
  80217d:	eb 14                	jmp    802193 <alloc_block+0x25f>
  80217f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802188:	c1 e2 04             	shl    $0x4,%edx
  80218b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802191:	89 02                	mov    %eax,(%edx)
  802193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802196:	8b 40 04             	mov    0x4(%eax),%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 0f                	je     8021ac <alloc_block+0x278>
  80219d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a0:	8b 40 04             	mov    0x4(%eax),%eax
  8021a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021a6:	8b 12                	mov    (%edx),%edx
  8021a8:	89 10                	mov    %edx,(%eax)
  8021aa:	eb 13                	jmp    8021bf <alloc_block+0x28b>
  8021ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b4:	c1 e2 04             	shl    $0x4,%edx
  8021b7:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8021bd:	89 02                	mov    %eax,(%edx)
  8021bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	c1 e0 04             	shl    $0x4,%eax
  8021d8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021dd:	8b 00                	mov    (%eax),%eax
  8021df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	c1 e0 04             	shl    $0x4,%eax
  8021e8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021ed:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8021ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	50                   	push   %eax
  8021f6:	e8 f5 f9 ff ff       	call   801bf0 <to_page_info>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802201:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802204:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802208:	48                   	dec    %eax
  802209:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80220c:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802213:	e9 26 01 00 00       	jmp    80233e <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802218:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	c1 e0 04             	shl    $0x4,%eax
  802221:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	0f 84 dc 00 00 00    	je     80230c <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	c1 e0 04             	shl    $0x4,%eax
  802236:	05 80 c0 81 00       	add    $0x81c080,%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802240:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802244:	75 17                	jne    80225d <alloc_block+0x329>
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	68 a1 34 80 00       	push   $0x8034a1
  80224e:	68 be 00 00 00       	push   $0xbe
  802253:	68 e3 33 80 00       	push   $0x8033e3
  802258:	e8 01 06 00 00       	call   80285e <_panic>
  80225d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 10                	je     802276 <alloc_block+0x342>
  802266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80226e:	8b 52 04             	mov    0x4(%edx),%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	eb 14                	jmp    80228a <alloc_block+0x356>
  802276:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227f:	c1 e2 04             	shl    $0x4,%edx
  802282:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802288:	89 02                	mov    %eax,(%edx)
  80228a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80228d:	8b 40 04             	mov    0x4(%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	74 0f                	je     8022a3 <alloc_block+0x36f>
  802294:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802297:	8b 40 04             	mov    0x4(%eax),%eax
  80229a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80229d:	8b 12                	mov    (%edx),%edx
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	eb 13                	jmp    8022b6 <alloc_block+0x382>
  8022a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	c1 e2 04             	shl    $0x4,%edx
  8022ae:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022b4:	89 02                	mov    %eax,(%edx)
  8022b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	c1 e0 04             	shl    $0x4,%eax
  8022cf:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	c1 e0 04             	shl    $0x4,%eax
  8022df:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022e4:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8022e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	50                   	push   %eax
  8022ed:	e8 fe f8 ff ff       	call   801bf0 <to_page_info>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8022f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022fb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022ff:	48                   	dec    %eax
  802300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802303:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802307:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80230a:	eb 32                	jmp    80233e <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80230c:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802310:	77 15                	ja     802327 <alloc_block+0x3f3>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	c1 e0 04             	shl    $0x4,%eax
  802318:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	0f 84 f1 fe ff ff    	je     802218 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 bf 34 80 00       	push   $0x8034bf
  80232f:	68 c8 00 00 00       	push   $0xc8
  802334:	68 e3 33 80 00       	push   $0x8033e3
  802339:	e8 20 05 00 00       	call   80285e <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802346:	8b 55 08             	mov    0x8(%ebp),%edx
  802349:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80234e:	39 c2                	cmp    %eax,%edx
  802350:	72 0c                	jb     80235e <free_block+0x1e>
  802352:	8b 55 08             	mov    0x8(%ebp),%edx
  802355:	a1 40 40 80 00       	mov    0x804040,%eax
  80235a:	39 c2                	cmp    %eax,%edx
  80235c:	72 19                	jb     802377 <free_block+0x37>
  80235e:	68 d0 34 80 00       	push   $0x8034d0
  802363:	68 46 34 80 00       	push   $0x803446
  802368:	68 d7 00 00 00       	push   $0xd7
  80236d:	68 e3 33 80 00       	push   $0x8033e3
  802372:	e8 e7 04 00 00       	call   80285e <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	50                   	push   %eax
  802384:	e8 67 f8 ff ff       	call   801bf0 <to_page_info>
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80238f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802392:	8b 40 08             	mov    0x8(%eax),%eax
  802395:	0f b7 c0             	movzwl %ax,%eax
  802398:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80239b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8023a2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8023a9:	eb 19                	jmp    8023c4 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8023b3:	88 c1                	mov    %al,%cl
  8023b5:	d3 e2                	shl    %cl,%edx
  8023b7:	89 d0                	mov    %edx,%eax
  8023b9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8023bc:	74 0e                	je     8023cc <free_block+0x8c>
	        break;
	    idx++;
  8023be:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8023c1:	ff 45 f0             	incl   -0x10(%ebp)
  8023c4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8023c8:	7e e1                	jle    8023ab <free_block+0x6b>
  8023ca:	eb 01                	jmp    8023cd <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8023cc:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8023cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023d4:	40                   	inc    %eax
  8023d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023d8:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8023dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023e0:	75 17                	jne    8023f9 <free_block+0xb9>
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 5c 34 80 00       	push   $0x80345c
  8023ea:	68 ee 00 00 00       	push   $0xee
  8023ef:	68 e3 33 80 00       	push   $0x8033e3
  8023f4:	e8 65 04 00 00       	call   80285e <_panic>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	c1 e0 04             	shl    $0x4,%eax
  8023ff:	05 84 c0 81 00       	add    $0x81c084,%eax
  802404:	8b 10                	mov    (%eax),%edx
  802406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802409:	89 50 04             	mov    %edx,0x4(%eax)
  80240c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240f:	8b 40 04             	mov    0x4(%eax),%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	74 14                	je     80242a <free_block+0xea>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	c1 e0 04             	shl    $0x4,%eax
  80241c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802426:	89 10                	mov    %edx,(%eax)
  802428:	eb 11                	jmp    80243b <free_block+0xfb>
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	c1 e0 04             	shl    $0x4,%eax
  802430:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802439:	89 02                	mov    %eax,(%edx)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	c1 e0 04             	shl    $0x4,%eax
  802441:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244a:	89 02                	mov    %eax,(%edx)
  80244c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	c1 e0 04             	shl    $0x4,%eax
  80245b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	8d 50 01             	lea    0x1(%eax),%edx
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	c1 e0 04             	shl    $0x4,%eax
  80246b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802470:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802472:	b8 00 10 00 00       	mov    $0x1000,%eax
  802477:	ba 00 00 00 00       	mov    $0x0,%edx
  80247c:	f7 75 e0             	divl   -0x20(%ebp)
  80247f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802485:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802489:	0f b7 c0             	movzwl %ax,%eax
  80248c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80248f:	0f 85 70 01 00 00    	jne    802605 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80249b:	e8 de f6 ff ff       	call   801b7e <to_page_va>
  8024a0:	83 c4 10             	add    $0x10,%esp
  8024a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8024a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8024ad:	e9 b7 00 00 00       	jmp    802569 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8024b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b8:	01 d0                	add    %edx,%eax
  8024ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8024bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024c1:	75 17                	jne    8024da <free_block+0x19a>
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 a1 34 80 00       	push   $0x8034a1
  8024cb:	68 f8 00 00 00       	push   $0xf8
  8024d0:	68 e3 33 80 00       	push   $0x8033e3
  8024d5:	e8 84 03 00 00       	call   80285e <_panic>
  8024da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	74 10                	je     8024f3 <free_block+0x1b3>
  8024e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e6:	8b 00                	mov    (%eax),%eax
  8024e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024eb:	8b 52 04             	mov    0x4(%edx),%edx
  8024ee:	89 50 04             	mov    %edx,0x4(%eax)
  8024f1:	eb 14                	jmp    802507 <free_block+0x1c7>
  8024f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	c1 e2 04             	shl    $0x4,%edx
  8024ff:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802505:	89 02                	mov    %eax,(%edx)
  802507:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250a:	8b 40 04             	mov    0x4(%eax),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	74 0f                	je     802520 <free_block+0x1e0>
  802511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802514:	8b 40 04             	mov    0x4(%eax),%eax
  802517:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80251a:	8b 12                	mov    (%edx),%edx
  80251c:	89 10                	mov    %edx,(%eax)
  80251e:	eb 13                	jmp    802533 <free_block+0x1f3>
  802520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802528:	c1 e2 04             	shl    $0x4,%edx
  80252b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802531:	89 02                	mov    %eax,(%edx)
  802533:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	c1 e0 04             	shl    $0x4,%eax
  80254c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8d 50 ff             	lea    -0x1(%eax),%edx
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c1 e0 04             	shl    $0x4,%eax
  80255c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802561:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802566:	01 45 ec             	add    %eax,-0x14(%ebp)
  802569:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802570:	0f 86 3c ff ff ff    	jbe    8024b2 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802579:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80257f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802582:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802588:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80258c:	75 17                	jne    8025a5 <free_block+0x265>
  80258e:	83 ec 04             	sub    $0x4,%esp
  802591:	68 5c 34 80 00       	push   $0x80345c
  802596:	68 fe 00 00 00       	push   $0xfe
  80259b:	68 e3 33 80 00       	push   $0x8033e3
  8025a0:	e8 b9 02 00 00       	call   80285e <_panic>
  8025a5:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	89 50 04             	mov    %edx,0x4(%eax)
  8025b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b4:	8b 40 04             	mov    0x4(%eax),%eax
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	74 0c                	je     8025c7 <free_block+0x287>
  8025bb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c3:	89 10                	mov    %edx,(%eax)
  8025c5:	eb 08                	jmp    8025cf <free_block+0x28f>
  8025c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ca:	a3 48 40 80 00       	mov    %eax,0x804048
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8025d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e0:	a1 54 40 80 00       	mov    0x804054,%eax
  8025e5:	40                   	inc    %eax
  8025e6:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025f1:	e8 88 f5 ff ff       	call   801b7e <to_page_va>
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	50                   	push   %eax
  8025fd:	e8 b8 ee ff ff       	call   8014ba <return_page>
  802602:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802605:	90                   	nop
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 08 35 80 00       	push   $0x803508
  802616:	68 11 01 00 00       	push   $0x111
  80261b:	68 e3 33 80 00       	push   $0x8033e3
  802620:	e8 39 02 00 00       	call   80285e <_panic>

00802625 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 2c 35 80 00       	push   $0x80352c
  802633:	6a 07                	push   $0x7
  802635:	68 5b 35 80 00       	push   $0x80355b
  80263a:	e8 1f 02 00 00       	call   80285e <_panic>

0080263f <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802645:	83 ec 04             	sub    $0x4,%esp
  802648:	68 6c 35 80 00       	push   $0x80356c
  80264d:	6a 0b                	push   $0xb
  80264f:	68 5b 35 80 00       	push   $0x80355b
  802654:	e8 05 02 00 00       	call   80285e <_panic>

00802659 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80265f:	83 ec 04             	sub    $0x4,%esp
  802662:	68 98 35 80 00       	push   $0x803598
  802667:	6a 10                	push   $0x10
  802669:	68 5b 35 80 00       	push   $0x80355b
  80266e:	e8 eb 01 00 00       	call   80285e <_panic>

00802673 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	68 c8 35 80 00       	push   $0x8035c8
  802681:	6a 15                	push   $0x15
  802683:	68 5b 35 80 00       	push   $0x80355b
  802688:	e8 d1 01 00 00       	call   80285e <_panic>

0080268d <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	8b 40 10             	mov    0x10(%eax),%eax
}
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    

00802698 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80269e:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a1:	89 d0                	mov    %edx,%eax
  8026a3:	c1 e0 02             	shl    $0x2,%eax
  8026a6:	01 d0                	add    %edx,%eax
  8026a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026b8:	01 d0                	add    %edx,%eax
  8026ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	c1 e0 04             	shl    $0x4,%eax
  8026c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8026c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026d0:	0f 31                	rdtsc  
  8026d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026e1:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8026e4:	eb 46                	jmp    80272c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026e6:	0f 31                	rdtsc  
  8026e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8026eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8026fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	29 c2                	sub    %eax,%edx
  802702:	89 d0                	mov    %edx,%eax
  802704:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802707:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	89 d1                	mov    %edx,%ecx
  80270f:	29 c1                	sub    %eax,%ecx
  802711:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802714:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802717:	39 c2                	cmp    %eax,%edx
  802719:	0f 97 c0             	seta   %al
  80271c:	0f b6 c0             	movzbl %al,%eax
  80271f:	29 c1                	sub    %eax,%ecx
  802721:	89 c8                	mov    %ecx,%eax
  802723:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802726:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802729:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80272c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80272f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802732:	72 b2                	jb     8026e6 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802734:	90                   	nop
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
  80273a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80273d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802744:	eb 03                	jmp    802749 <busy_wait+0x12>
  802746:	ff 45 fc             	incl   -0x4(%ebp)
  802749:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80274c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274f:	72 f5                	jb     802746 <busy_wait+0xf>
	return i;
  802751:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80275c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802760:	74 1c                	je     80277e <init_uspinlock+0x28>
  802762:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  802766:	74 16                	je     80277e <init_uspinlock+0x28>
  802768:	68 f8 35 80 00       	push   $0x8035f8
  80276d:	68 17 36 80 00       	push   $0x803617
  802772:	6a 10                	push   $0x10
  802774:	68 2c 36 80 00       	push   $0x80362c
  802779:	e8 e0 00 00 00       	call   80285e <_panic>
	strcpy(lk->name, name);
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	83 c0 04             	add    $0x4,%eax
  802784:	83 ec 08             	sub    $0x8,%esp
  802787:	ff 75 0c             	pushl  0xc(%ebp)
  80278a:	50                   	push   %eax
  80278b:	e8 d0 e4 ff ff       	call   800c60 <strcpy>
  802790:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  802793:	b8 01 00 00 00       	mov    $0x1,%eax
  802798:	2b 45 10             	sub    0x10(%ebp),%eax
  80279b:	89 c2                	mov    %eax,%edx
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	89 10                	mov    %edx,(%eax)
}
  8027a2:	90                   	nop
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8027ab:	90                   	nop
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8027b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027c2:	f0 87 02             	lock xchg %eax,(%edx)
  8027c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8027c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 dd                	jne    8027ac <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8d 48 04             	lea    0x4(%eax),%ecx
  8027d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8027da:	8d 50 20             	lea    0x20(%eax),%edx
  8027dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8027e2:	8b 40 10             	mov    0x10(%eax),%eax
  8027e5:	51                   	push   %ecx
  8027e6:	52                   	push   %edx
  8027e7:	50                   	push   %eax
  8027e8:	68 3c 36 80 00       	push   $0x80363c
  8027ed:	e8 46 dd ff ff       	call   800538 <cprintf>
  8027f2:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8027f5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8027fa:	90                   	nop
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	75 18                	jne    802824 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	83 c0 04             	add    $0x4,%eax
  802812:	50                   	push   %eax
  802813:	68 60 36 80 00       	push   $0x803660
  802818:	6a 2b                	push   $0x2b
  80281a:	68 2c 36 80 00       	push   $0x80362c
  80281f:	e8 3a 00 00 00       	call   80285e <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  802824:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	8b 55 08             	mov    0x8(%ebp),%edx
  80282f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  802835:	8b 45 08             	mov    0x8(%ebp),%eax
  802838:	8d 48 04             	lea    0x4(%eax),%ecx
  80283b:	a1 20 40 80 00       	mov    0x804020,%eax
  802840:	8d 50 20             	lea    0x20(%eax),%edx
  802843:	a1 20 40 80 00       	mov    0x804020,%eax
  802848:	8b 40 10             	mov    0x10(%eax),%eax
  80284b:	51                   	push   %ecx
  80284c:	52                   	push   %edx
  80284d:	50                   	push   %eax
  80284e:	68 80 36 80 00       	push   $0x803680
  802853:	e8 e0 dc ff ff       	call   800538 <cprintf>
  802858:	83 c4 10             	add    $0x10,%esp
}
  80285b:	90                   	nop
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802864:	8d 45 10             	lea    0x10(%ebp),%eax
  802867:	83 c0 04             	add    $0x4,%eax
  80286a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80286d:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 16                	je     80288c <_panic+0x2e>
		cprintf("%s: ", argv0);
  802876:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80287b:	83 ec 08             	sub    $0x8,%esp
  80287e:	50                   	push   %eax
  80287f:	68 a4 36 80 00       	push   $0x8036a4
  802884:	e8 af dc ff ff       	call   800538 <cprintf>
  802889:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80288c:	a1 04 40 80 00       	mov    0x804004,%eax
  802891:	83 ec 0c             	sub    $0xc,%esp
  802894:	ff 75 0c             	pushl  0xc(%ebp)
  802897:	ff 75 08             	pushl  0x8(%ebp)
  80289a:	50                   	push   %eax
  80289b:	68 ac 36 80 00       	push   $0x8036ac
  8028a0:	6a 74                	push   $0x74
  8028a2:	e8 be dc ff ff       	call   800565 <cprintf_colored>
  8028a7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8028aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ad:	83 ec 08             	sub    $0x8,%esp
  8028b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8028b3:	50                   	push   %eax
  8028b4:	e8 10 dc ff ff       	call   8004c9 <vcprintf>
  8028b9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8028bc:	83 ec 08             	sub    $0x8,%esp
  8028bf:	6a 00                	push   $0x0
  8028c1:	68 d4 36 80 00       	push   $0x8036d4
  8028c6:	e8 fe db ff ff       	call   8004c9 <vcprintf>
  8028cb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8028ce:	e8 77 db ff ff       	call   80044a <exit>

	// should not return here
	while (1) ;
  8028d3:	eb fe                	jmp    8028d3 <_panic+0x75>

008028d5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
  8028d8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8028db:	a1 20 40 80 00       	mov    0x804020,%eax
  8028e0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e9:	39 c2                	cmp    %eax,%edx
  8028eb:	74 14                	je     802901 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	68 d8 36 80 00       	push   $0x8036d8
  8028f5:	6a 26                	push   $0x26
  8028f7:	68 24 37 80 00       	push   $0x803724
  8028fc:	e8 5d ff ff ff       	call   80285e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802908:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80290f:	e9 c5 00 00 00       	jmp    8029d9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	01 d0                	add    %edx,%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	75 08                	jne    802931 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802929:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80292c:	e9 a5 00 00 00       	jmp    8029d6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802931:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802938:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80293f:	eb 69                	jmp    8029aa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802941:	a1 20 40 80 00       	mov    0x804020,%eax
  802946:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80294c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80294f:	89 d0                	mov    %edx,%eax
  802951:	01 c0                	add    %eax,%eax
  802953:	01 d0                	add    %edx,%eax
  802955:	c1 e0 03             	shl    $0x3,%eax
  802958:	01 c8                	add    %ecx,%eax
  80295a:	8a 40 04             	mov    0x4(%eax),%al
  80295d:	84 c0                	test   %al,%al
  80295f:	75 46                	jne    8029a7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802961:	a1 20 40 80 00       	mov    0x804020,%eax
  802966:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80296c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296f:	89 d0                	mov    %edx,%eax
  802971:	01 c0                	add    %eax,%eax
  802973:	01 d0                	add    %edx,%eax
  802975:	c1 e0 03             	shl    $0x3,%eax
  802978:	01 c8                	add    %ecx,%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80297f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802987:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	01 c8                	add    %ecx,%eax
  802998:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80299a:	39 c2                	cmp    %eax,%edx
  80299c:	75 09                	jne    8029a7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80299e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8029a5:	eb 15                	jmp    8029bc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029a7:	ff 45 e8             	incl   -0x18(%ebp)
  8029aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8029af:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	39 c2                	cmp    %eax,%edx
  8029ba:	77 85                	ja     802941 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8029bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c0:	75 14                	jne    8029d6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 30 37 80 00       	push   $0x803730
  8029ca:	6a 3a                	push   $0x3a
  8029cc:	68 24 37 80 00       	push   $0x803724
  8029d1:	e8 88 fe ff ff       	call   80285e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8029d6:	ff 45 f0             	incl   -0x10(%ebp)
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029df:	0f 8c 2f ff ff ff    	jl     802914 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8029e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029f3:	eb 26                	jmp    802a1b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8029f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8029fa:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802a00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a03:	89 d0                	mov    %edx,%eax
  802a05:	01 c0                	add    %eax,%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	c1 e0 03             	shl    $0x3,%eax
  802a0c:	01 c8                	add    %ecx,%eax
  802a0e:	8a 40 04             	mov    0x4(%eax),%al
  802a11:	3c 01                	cmp    $0x1,%al
  802a13:	75 03                	jne    802a18 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802a15:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a18:	ff 45 e0             	incl   -0x20(%ebp)
  802a1b:	a1 20 40 80 00       	mov    0x804020,%eax
  802a20:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a29:	39 c2                	cmp    %eax,%edx
  802a2b:	77 c8                	ja     8029f5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a33:	74 14                	je     802a49 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	68 84 37 80 00       	push   $0x803784
  802a3d:	6a 44                	push   $0x44
  802a3f:	68 24 37 80 00       	push   $0x803724
  802a44:	e8 15 fe ff ff       	call   80285e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802a49:	90                   	nop
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    

00802a4c <__udivdi3>:
  802a4c:	55                   	push   %ebp
  802a4d:	57                   	push   %edi
  802a4e:	56                   	push   %esi
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 1c             	sub    $0x1c,%esp
  802a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a63:	89 ca                	mov    %ecx,%edx
  802a65:	89 f8                	mov    %edi,%eax
  802a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a6b:	85 f6                	test   %esi,%esi
  802a6d:	75 2d                	jne    802a9c <__udivdi3+0x50>
  802a6f:	39 cf                	cmp    %ecx,%edi
  802a71:	77 65                	ja     802ad8 <__udivdi3+0x8c>
  802a73:	89 fd                	mov    %edi,%ebp
  802a75:	85 ff                	test   %edi,%edi
  802a77:	75 0b                	jne    802a84 <__udivdi3+0x38>
  802a79:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7e:	31 d2                	xor    %edx,%edx
  802a80:	f7 f7                	div    %edi
  802a82:	89 c5                	mov    %eax,%ebp
  802a84:	31 d2                	xor    %edx,%edx
  802a86:	89 c8                	mov    %ecx,%eax
  802a88:	f7 f5                	div    %ebp
  802a8a:	89 c1                	mov    %eax,%ecx
  802a8c:	89 d8                	mov    %ebx,%eax
  802a8e:	f7 f5                	div    %ebp
  802a90:	89 cf                	mov    %ecx,%edi
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	83 c4 1c             	add    $0x1c,%esp
  802a97:	5b                   	pop    %ebx
  802a98:	5e                   	pop    %esi
  802a99:	5f                   	pop    %edi
  802a9a:	5d                   	pop    %ebp
  802a9b:	c3                   	ret    
  802a9c:	39 ce                	cmp    %ecx,%esi
  802a9e:	77 28                	ja     802ac8 <__udivdi3+0x7c>
  802aa0:	0f bd fe             	bsr    %esi,%edi
  802aa3:	83 f7 1f             	xor    $0x1f,%edi
  802aa6:	75 40                	jne    802ae8 <__udivdi3+0x9c>
  802aa8:	39 ce                	cmp    %ecx,%esi
  802aaa:	72 0a                	jb     802ab6 <__udivdi3+0x6a>
  802aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ab0:	0f 87 9e 00 00 00    	ja     802b54 <__udivdi3+0x108>
  802ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  802abb:	89 fa                	mov    %edi,%edx
  802abd:	83 c4 1c             	add    $0x1c,%esp
  802ac0:	5b                   	pop    %ebx
  802ac1:	5e                   	pop    %esi
  802ac2:	5f                   	pop    %edi
  802ac3:	5d                   	pop    %ebp
  802ac4:	c3                   	ret    
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	31 ff                	xor    %edi,%edi
  802aca:	31 c0                	xor    %eax,%eax
  802acc:	89 fa                	mov    %edi,%edx
  802ace:	83 c4 1c             	add    $0x1c,%esp
  802ad1:	5b                   	pop    %ebx
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	89 d8                	mov    %ebx,%eax
  802ada:	f7 f7                	div    %edi
  802adc:	31 ff                	xor    %edi,%edi
  802ade:	89 fa                	mov    %edi,%edx
  802ae0:	83 c4 1c             	add    $0x1c,%esp
  802ae3:	5b                   	pop    %ebx
  802ae4:	5e                   	pop    %esi
  802ae5:	5f                   	pop    %edi
  802ae6:	5d                   	pop    %ebp
  802ae7:	c3                   	ret    
  802ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802aed:	89 eb                	mov    %ebp,%ebx
  802aef:	29 fb                	sub    %edi,%ebx
  802af1:	89 f9                	mov    %edi,%ecx
  802af3:	d3 e6                	shl    %cl,%esi
  802af5:	89 c5                	mov    %eax,%ebp
  802af7:	88 d9                	mov    %bl,%cl
  802af9:	d3 ed                	shr    %cl,%ebp
  802afb:	89 e9                	mov    %ebp,%ecx
  802afd:	09 f1                	or     %esi,%ecx
  802aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b03:	89 f9                	mov    %edi,%ecx
  802b05:	d3 e0                	shl    %cl,%eax
  802b07:	89 c5                	mov    %eax,%ebp
  802b09:	89 d6                	mov    %edx,%esi
  802b0b:	88 d9                	mov    %bl,%cl
  802b0d:	d3 ee                	shr    %cl,%esi
  802b0f:	89 f9                	mov    %edi,%ecx
  802b11:	d3 e2                	shl    %cl,%edx
  802b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b17:	88 d9                	mov    %bl,%cl
  802b19:	d3 e8                	shr    %cl,%eax
  802b1b:	09 c2                	or     %eax,%edx
  802b1d:	89 d0                	mov    %edx,%eax
  802b1f:	89 f2                	mov    %esi,%edx
  802b21:	f7 74 24 0c          	divl   0xc(%esp)
  802b25:	89 d6                	mov    %edx,%esi
  802b27:	89 c3                	mov    %eax,%ebx
  802b29:	f7 e5                	mul    %ebp
  802b2b:	39 d6                	cmp    %edx,%esi
  802b2d:	72 19                	jb     802b48 <__udivdi3+0xfc>
  802b2f:	74 0b                	je     802b3c <__udivdi3+0xf0>
  802b31:	89 d8                	mov    %ebx,%eax
  802b33:	31 ff                	xor    %edi,%edi
  802b35:	e9 58 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b3a:	66 90                	xchg   %ax,%ax
  802b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b40:	89 f9                	mov    %edi,%ecx
  802b42:	d3 e2                	shl    %cl,%edx
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	73 e9                	jae    802b31 <__udivdi3+0xe5>
  802b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b4b:	31 ff                	xor    %edi,%edi
  802b4d:	e9 40 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b52:	66 90                	xchg   %ax,%ax
  802b54:	31 c0                	xor    %eax,%eax
  802b56:	e9 37 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b5b:	90                   	nop

00802b5c <__umoddi3>:
  802b5c:	55                   	push   %ebp
  802b5d:	57                   	push   %edi
  802b5e:	56                   	push   %esi
  802b5f:	53                   	push   %ebx
  802b60:	83 ec 1c             	sub    $0x1c,%esp
  802b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b7b:	89 f3                	mov    %esi,%ebx
  802b7d:	89 fa                	mov    %edi,%edx
  802b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b83:	89 34 24             	mov    %esi,(%esp)
  802b86:	85 c0                	test   %eax,%eax
  802b88:	75 1a                	jne    802ba4 <__umoddi3+0x48>
  802b8a:	39 f7                	cmp    %esi,%edi
  802b8c:	0f 86 a2 00 00 00    	jbe    802c34 <__umoddi3+0xd8>
  802b92:	89 c8                	mov    %ecx,%eax
  802b94:	89 f2                	mov    %esi,%edx
  802b96:	f7 f7                	div    %edi
  802b98:	89 d0                	mov    %edx,%eax
  802b9a:	31 d2                	xor    %edx,%edx
  802b9c:	83 c4 1c             	add    $0x1c,%esp
  802b9f:	5b                   	pop    %ebx
  802ba0:	5e                   	pop    %esi
  802ba1:	5f                   	pop    %edi
  802ba2:	5d                   	pop    %ebp
  802ba3:	c3                   	ret    
  802ba4:	39 f0                	cmp    %esi,%eax
  802ba6:	0f 87 ac 00 00 00    	ja     802c58 <__umoddi3+0xfc>
  802bac:	0f bd e8             	bsr    %eax,%ebp
  802baf:	83 f5 1f             	xor    $0x1f,%ebp
  802bb2:	0f 84 ac 00 00 00    	je     802c64 <__umoddi3+0x108>
  802bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  802bbd:	29 ef                	sub    %ebp,%edi
  802bbf:	89 fe                	mov    %edi,%esi
  802bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bc5:	89 e9                	mov    %ebp,%ecx
  802bc7:	d3 e0                	shl    %cl,%eax
  802bc9:	89 d7                	mov    %edx,%edi
  802bcb:	89 f1                	mov    %esi,%ecx
  802bcd:	d3 ef                	shr    %cl,%edi
  802bcf:	09 c7                	or     %eax,%edi
  802bd1:	89 e9                	mov    %ebp,%ecx
  802bd3:	d3 e2                	shl    %cl,%edx
  802bd5:	89 14 24             	mov    %edx,(%esp)
  802bd8:	89 d8                	mov    %ebx,%eax
  802bda:	d3 e0                	shl    %cl,%eax
  802bdc:	89 c2                	mov    %eax,%edx
  802bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  802be2:	d3 e0                	shl    %cl,%eax
  802be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bec:	89 f1                	mov    %esi,%ecx
  802bee:	d3 e8                	shr    %cl,%eax
  802bf0:	09 d0                	or     %edx,%eax
  802bf2:	d3 eb                	shr    %cl,%ebx
  802bf4:	89 da                	mov    %ebx,%edx
  802bf6:	f7 f7                	div    %edi
  802bf8:	89 d3                	mov    %edx,%ebx
  802bfa:	f7 24 24             	mull   (%esp)
  802bfd:	89 c6                	mov    %eax,%esi
  802bff:	89 d1                	mov    %edx,%ecx
  802c01:	39 d3                	cmp    %edx,%ebx
  802c03:	0f 82 87 00 00 00    	jb     802c90 <__umoddi3+0x134>
  802c09:	0f 84 91 00 00 00    	je     802ca0 <__umoddi3+0x144>
  802c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c13:	29 f2                	sub    %esi,%edx
  802c15:	19 cb                	sbb    %ecx,%ebx
  802c17:	89 d8                	mov    %ebx,%eax
  802c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c1d:	d3 e0                	shl    %cl,%eax
  802c1f:	89 e9                	mov    %ebp,%ecx
  802c21:	d3 ea                	shr    %cl,%edx
  802c23:	09 d0                	or     %edx,%eax
  802c25:	89 e9                	mov    %ebp,%ecx
  802c27:	d3 eb                	shr    %cl,%ebx
  802c29:	89 da                	mov    %ebx,%edx
  802c2b:	83 c4 1c             	add    $0x1c,%esp
  802c2e:	5b                   	pop    %ebx
  802c2f:	5e                   	pop    %esi
  802c30:	5f                   	pop    %edi
  802c31:	5d                   	pop    %ebp
  802c32:	c3                   	ret    
  802c33:	90                   	nop
  802c34:	89 fd                	mov    %edi,%ebp
  802c36:	85 ff                	test   %edi,%edi
  802c38:	75 0b                	jne    802c45 <__umoddi3+0xe9>
  802c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3f:	31 d2                	xor    %edx,%edx
  802c41:	f7 f7                	div    %edi
  802c43:	89 c5                	mov    %eax,%ebp
  802c45:	89 f0                	mov    %esi,%eax
  802c47:	31 d2                	xor    %edx,%edx
  802c49:	f7 f5                	div    %ebp
  802c4b:	89 c8                	mov    %ecx,%eax
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 d0                	mov    %edx,%eax
  802c51:	e9 44 ff ff ff       	jmp    802b9a <__umoddi3+0x3e>
  802c56:	66 90                	xchg   %ax,%ax
  802c58:	89 c8                	mov    %ecx,%eax
  802c5a:	89 f2                	mov    %esi,%edx
  802c5c:	83 c4 1c             	add    $0x1c,%esp
  802c5f:	5b                   	pop    %ebx
  802c60:	5e                   	pop    %esi
  802c61:	5f                   	pop    %edi
  802c62:	5d                   	pop    %ebp
  802c63:	c3                   	ret    
  802c64:	3b 04 24             	cmp    (%esp),%eax
  802c67:	72 06                	jb     802c6f <__umoddi3+0x113>
  802c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c6d:	77 0f                	ja     802c7e <__umoddi3+0x122>
  802c6f:	89 f2                	mov    %esi,%edx
  802c71:	29 f9                	sub    %edi,%ecx
  802c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c77:	89 14 24             	mov    %edx,(%esp)
  802c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c82:	8b 14 24             	mov    (%esp),%edx
  802c85:	83 c4 1c             	add    $0x1c,%esp
  802c88:	5b                   	pop    %ebx
  802c89:	5e                   	pop    %esi
  802c8a:	5f                   	pop    %edi
  802c8b:	5d                   	pop    %ebp
  802c8c:	c3                   	ret    
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	2b 04 24             	sub    (%esp),%eax
  802c93:	19 fa                	sbb    %edi,%edx
  802c95:	89 d1                	mov    %edx,%ecx
  802c97:	89 c6                	mov    %eax,%esi
  802c99:	e9 71 ff ff ff       	jmp    802c0f <__umoddi3+0xb3>
  802c9e:	66 90                	xchg   %ax,%ax
  802ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802ca4:	72 ea                	jb     802c90 <__umoddi3+0x134>
  802ca6:	89 d9                	mov    %ebx,%ecx
  802ca8:	e9 62 ff ff ff       	jmp    802c0f <__umoddi3+0xb3>
