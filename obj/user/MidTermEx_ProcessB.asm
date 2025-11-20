
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
  800048:	e8 73 18 00 00       	call   8018c0 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 a0 2c 80 00       	push   $0x802ca0
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 01 15 00 00       	call   801561 <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 a2 2c 80 00       	push   $0x802ca2
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 eb 14 00 00       	call   801561 <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int * finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 ab 2c 80 00       	push   $0x802cab
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 d5 14 00 00       	call   801561 <sget>
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
  8000a2:	68 b9 2c 80 00       	push   $0x802cb9
  8000a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000aa:	50                   	push   %eax
  8000ab:	e8 7a 25 00 00       	call   80262a <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 bb 2c 80 00       	push   $0x802cbb
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 63 25 00 00       	call   80262a <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 c4 2c 80 00       	push   $0x802cc4
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 4c 25 00 00       	call   80262a <get_semaphore>
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
  8000f0:	68 b9 2c 80 00       	push   $0x802cb9
  8000f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f8:	e8 64 14 00 00       	call   801561 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 c4 2c 80 00       	push   $0x802cc4
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 4e 14 00 00       	call   801561 <sget>
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
  800129:	e8 16 25 00 00       	call   802644 <wait_semaphore>
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
  800143:	e8 48 26 00 00       	call   802790 <acquire_uspinlock>
  800148:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  80014b:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	e8 9c 17 00 00       	call   8018f3 <sys_get_virtual_time>
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
  80017a:	e8 04 25 00 00       	call   802683 <env_sleep>
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
  800192:	e8 5c 17 00 00       	call   8018f3 <sys_get_virtual_time>
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
  8001ba:	e8 c4 24 00 00       	call   802683 <env_sleep>
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
  8001d1:	e8 1d 17 00 00       	call   8018f3 <sys_get_virtual_time>
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
  8001f9:	e8 85 24 00 00       	call   802683 <env_sleep>
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
  800211:	e8 48 24 00 00       	call   80265e <signal_semaphore>
  800216:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80021f:	e8 20 24 00 00       	call   802644 <wait_semaphore>
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
  80023a:	e8 1f 24 00 00       	call   80265e <signal_semaphore>
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
  800254:	e8 37 25 00 00       	call   802790 <acquire_uspinlock>
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
  80026f:	e8 74 25 00 00       	call   8027e8 <release_uspinlock>
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
  800279:	e8 b0 13 00 00       	call   80162e <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800281:	8b 00                	mov    (%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028b:	e8 b8 13 00 00       	call   801648 <sys_unlock_cons>
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
  80029c:	e8 06 16 00 00       	call   8018a7 <sys_getenvindex>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a7:	89 d0                	mov    %edx,%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	c1 e0 03             	shl    $0x3,%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002ba:	01 d0                	add    %edx,%eax
  8002bc:	c1 e0 02             	shl    $0x2,%eax
  8002bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c4:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8a 40 20             	mov    0x20(%eax),%al
  8002d1:	84 c0                	test   %al,%al
  8002d3:	74 0d                	je     8002e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002da:	83 c0 20             	add    $0x20,%eax
  8002dd:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e6:	7e 0a                	jle    8002f2 <libmain+0x5f>
		binaryname = argv[0];
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 38 fd ff ff       	call   800038 <_main>
  800300:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800303:	a1 00 40 80 00       	mov    0x804000,%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	0f 84 01 01 00 00    	je     800411 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800310:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800316:	bb d0 2d 80 00       	mov    $0x802dd0,%ebx
  80031b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800320:	89 c7                	mov    %eax,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	89 d1                	mov    %edx,%ecx
  800326:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800328:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800330:	b0 00                	mov    $0x0,%al
  800332:	89 d7                	mov    %edx,%edi
  800334:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800336:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034a:	50                   	push   %eax
  80034b:	e8 8d 17 00 00       	call   801add <sys_utilities>
  800350:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800353:	e8 d6 12 00 00       	call   80162e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800358:	83 ec 0c             	sub    $0xc,%esp
  80035b:	68 f0 2c 80 00       	push   $0x802cf0
  800360:	e8 be 01 00 00       	call   800523 <cprintf>
  800365:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	74 18                	je     800387 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036f:	e8 87 17 00 00       	call   801afb <sys_get_optimal_num_faults>
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	50                   	push   %eax
  800378:	68 18 2d 80 00       	push   $0x802d18
  80037d:	e8 a1 01 00 00       	call   800523 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb 59                	jmp    8003e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800387:	a1 20 40 80 00       	mov    0x804020,%eax
  80038c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800392:	a1 20 40 80 00       	mov    0x804020,%eax
  800397:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	68 3c 2d 80 00       	push   $0x802d3c
  8003a7:	e8 77 01 00 00       	call   800523 <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003af:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bf:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003c5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ca:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	68 64 2d 80 00       	push   $0x802d64
  8003d8:	e8 46 01 00 00       	call   800523 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 bc 2d 80 00       	push   $0x802dbc
  8003f4:	e8 2a 01 00 00       	call   800523 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	68 f0 2c 80 00       	push   $0x802cf0
  800404:	e8 1a 01 00 00       	call   800523 <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040c:	e8 37 12 00 00       	call   801648 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800411:	e8 1f 00 00 00       	call   800435 <exit>
}
  800416:	90                   	nop
  800417:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800425:	83 ec 0c             	sub    $0xc,%esp
  800428:	6a 00                	push   $0x0
  80042a:	e8 44 14 00 00       	call   801873 <sys_destroy_env>
  80042f:	83 c4 10             	add    $0x10,%esp
}
  800432:	90                   	nop
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <exit>:

void
exit(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043b:	e8 99 14 00 00       	call   8018d9 <sys_exit_env>
}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	53                   	push   %ebx
  800447:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	8d 48 01             	lea    0x1(%eax),%ecx
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 0a                	mov    %ecx,(%edx)
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	88 d1                	mov    %dl,%cl
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046d:	75 30                	jne    80049f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80046f:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800475:	a0 44 40 80 00       	mov    0x804044,%al
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800480:	8b 09                	mov    (%ecx),%ecx
  800482:	89 cb                	mov    %ecx,%ebx
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	83 c1 08             	add    $0x8,%ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	53                   	push   %ebx
  80048d:	51                   	push   %ecx
  80048e:	e8 57 11 00 00       	call   8015ea <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 43 04 80 00       	push   $0x800443
  8004e3:	e8 5a 02 00 00       	call   800742 <vprintfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004eb:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8004f1:	a0 44 40 80 00       	mov    0x804044,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	51                   	push   %ecx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 d9 10 00 00       	call   8015ea <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 6f ff ff ff       	call   8004b4 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800556:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	c1 e0 08             	shl    $0x8,%eax
  800563:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800568:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 34 ff ff ff       	call   8004b4 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800586:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  80058d:	07 00 00 

	return cnt;
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059b:	e8 8e 10 00 00       	call   80162e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 ff fe ff ff       	call   8004b4 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bb:	e8 88 10 00 00       	call   801648 <sys_unlock_cons>
	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 14             	sub    $0x14,%esp
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e3:	77 55                	ja     80063a <printnum+0x75>
  8005e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e8:	72 05                	jb     8005ef <printnum+0x2a>
  8005ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ed:	77 4b                	ja     80063a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	ff 75 f0             	pushl  -0x10(%ebp)
  800605:	e8 2e 24 00 00       	call   802a38 <__udivdi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	53                   	push   %ebx
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 a1 ff ff ff       	call   8005c5 <printnum>
  800624:	83 c4 20             	add    $0x20,%esp
  800627:	eb 1a                	jmp    800643 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 20             	pushl  0x20(%ebp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063a:	ff 4d 1c             	decl   0x1c(%ebp)
  80063d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800641:	7f e6                	jg     800629 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800643:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	e8 ee 24 00 00       	call   802b48 <__umoddi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	05 54 30 80 00       	add    $0x803054,%eax
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
}
  800676:	90                   	nop
  800677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800683:	7e 1c                	jle    8006a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 50 08             	lea    0x8(%eax),%edx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	89 10                	mov    %edx,(%eax)
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 e8 08             	sub    $0x8,%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	eb 40                	jmp    8006e1 <getuint+0x65>
	else if (lflag)
  8006a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a5:	74 1e                	je     8006c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	eb 1c                	jmp    8006e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ea:	7e 1c                	jle    800708 <getint+0x25>
		return va_arg(*ap, long long);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 08             	lea    0x8(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 08             	sub    $0x8,%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	eb 38                	jmp    800740 <getint+0x5d>
	else if (lflag)
  800708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070c:	74 1a                	je     800728 <getint+0x45>
		return va_arg(*ap, long);
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	8d 50 04             	lea    0x4(%eax),%edx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	89 10                	mov    %edx,(%eax)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	eb 18                	jmp    800740 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	eb 17                	jmp    800763 <vprintfmt+0x21>
			if (ch == '\0')
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	0f 84 c1 03 00 00    	je     800b15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	53                   	push   %ebx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	83 fb 25             	cmp    $0x25,%ebx
  800774:	75 d6                	jne    80074c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800776:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	89 55 10             	mov    %edx,0x10(%ebp)
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a7:	83 f8 5b             	cmp    $0x5b,%eax
  8007aa:	0f 87 3d 03 00 00    	ja     800aed <vprintfmt+0x3ab>
  8007b0:	8b 04 85 78 30 80 00 	mov    0x803078(,%eax,4),%eax
  8007b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bd:	eb d7                	jmp    800796 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c3:	eb d1                	jmp    800796 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	c1 e0 02             	shl    $0x2,%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	01 c0                	add    %eax,%eax
  8007d8:	01 d8                	add    %ebx,%eax
  8007da:	83 e8 30             	sub    $0x30,%eax
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 3e                	jle    80082b <vprintfmt+0xe9>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 39                	jg     80082b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f5:	eb d5                	jmp    8007cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080b:	eb 1f                	jmp    80082c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	79 83                	jns    800796 <vprintfmt+0x54>
				width = 0;
  800813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081a:	e9 77 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800826:	e9 6b ff ff ff       	jmp    800796 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800830:	0f 89 60 ff ff ff    	jns    800796 <vprintfmt+0x54>
				width = precision, precision = -1;
  800836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800843:	e9 4e ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800848:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084b:	e9 46 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 9b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800886:	85 db                	test   %ebx,%ebx
  800888:	79 02                	jns    80088c <vprintfmt+0x14a>
				err = -err;
  80088a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088c:	83 fb 64             	cmp    $0x64,%ebx
  80088f:	7f 0b                	jg     80089c <vprintfmt+0x15a>
  800891:	8b 34 9d c0 2e 80 00 	mov    0x802ec0(,%ebx,4),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 19                	jne    8008b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089c:	53                   	push   %ebx
  80089d:	68 65 30 80 00       	push   $0x803065
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	ff 75 08             	pushl  0x8(%ebp)
  8008a8:	e8 70 02 00 00       	call   800b1d <printfmt>
  8008ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b0:	e9 5b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b5:	56                   	push   %esi
  8008b6:	68 6e 30 80 00       	push   $0x80306e
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 57 02 00 00       	call   800b1d <printfmt>
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	e9 42 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 30                	mov    (%eax),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 05                	jne    8008e8 <vprintfmt+0x1a6>
				p = "(null)";
  8008e3:	be 71 30 80 00       	mov    $0x803071,%esi
			if (width > 0 && padc != '-')
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7e 6d                	jle    80095b <vprintfmt+0x219>
  8008ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f2:	74 67                	je     80095b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	50                   	push   %eax
  8008fb:	56                   	push   %esi
  8008fc:	e8 1e 03 00 00       	call   800c1f <strnlen>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800907:	eb 16                	jmp    80091f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800909:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e4                	jg     800909 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	eb 34                	jmp    80095b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800927:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092b:	74 1c                	je     800949 <vprintfmt+0x207>
  80092d:	83 fb 1f             	cmp    $0x1f,%ebx
  800930:	7e 05                	jle    800937 <vprintfmt+0x1f5>
  800932:	83 fb 7e             	cmp    $0x7e,%ebx
  800935:	7e 12                	jle    800949 <vprintfmt+0x207>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb 0f                	jmp    800958 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	89 f0                	mov    %esi,%eax
  80095d:	8d 70 01             	lea    0x1(%eax),%esi
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
  800965:	85 db                	test   %ebx,%ebx
  800967:	74 24                	je     80098d <vprintfmt+0x24b>
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	78 b8                	js     800927 <vprintfmt+0x1e5>
  80096f:	ff 4d e0             	decl   -0x20(%ebp)
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	79 af                	jns    800927 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	eb 13                	jmp    80098d <vprintfmt+0x24b>
				putch(' ', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 20                	push   $0x20
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098a:	ff 4d e4             	decl   -0x1c(%ebp)
  80098d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800991:	7f e7                	jg     80097a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800993:	e9 78 01 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 e8             	pushl  -0x18(%ebp)
  80099e:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	e8 3c fd ff ff       	call   8006e3 <getint>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	79 23                	jns    8009dd <vprintfmt+0x29b>
				putch('-', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	f7 d8                	neg    %eax
  8009d2:	83 d2 00             	adc    $0x0,%edx
  8009d5:	f7 da                	neg    %edx
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 84 fc ff ff       	call   80067c <getuint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a08:	e9 98 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 58                	push   $0x58
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 58                	push   $0x58
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 58                	push   $0x58
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 ce 00 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 30                	push   $0x30
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 78                	push   $0x78
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a84:	eb 1f                	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 e7 fb ff ff       	call   80067c <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	52                   	push   %edx
  800ab0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 00 fb ff ff       	call   8005c5 <printnum>
  800ac5:	83 c4 20             	add    $0x20,%esp
			break;
  800ac8:	eb 46                	jmp    800b10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	eb 35                	jmp    800b10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adb:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800ae2:	eb 2c                	jmp    800b10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae4:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800aeb:	eb 23                	jmp    800b10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	6a 25                	push   $0x25
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	ff 4d 10             	decl   0x10(%ebp)
  800b00:	eb 03                	jmp    800b05 <vprintfmt+0x3c3>
  800b02:	ff 4d 10             	decl   0x10(%ebp)
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	48                   	dec    %eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	3c 25                	cmp    $0x25,%al
  800b0d:	75 f3                	jne    800b02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b0f:	90                   	nop
		}
	}
  800b10:	e9 35 fc ff ff       	jmp    80074a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b23:	8d 45 10             	lea    0x10(%ebp),%eax
  800b26:	83 c0 04             	add    $0x4,%eax
  800b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 04 fc ff ff       	call   800742 <vprintfmt>
  800b3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b41:	90                   	nop
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 08             	mov    0x8(%eax),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 04             	mov    0x4(%eax),%eax
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	73 12                	jae    800b77 <sprintputch+0x33>
		*b->buf++ = ch;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	89 0a                	mov    %ecx,(%edx)
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	88 10                	mov    %dl,(%eax)
}
  800b77:	90                   	nop
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	01 d0                	add    %edx,%eax
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	74 06                	je     800ba7 <vsnprintf+0x2d>
  800ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba5:	7f 07                	jg     800bae <vsnprintf+0x34>
		return -E_INVAL;
  800ba7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bac:	eb 20                	jmp    800bce <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bae:	ff 75 14             	pushl  0x14(%ebp)
  800bb1:	ff 75 10             	pushl  0x10(%ebp)
  800bb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	68 44 0b 80 00       	push   $0x800b44
  800bbd:	e8 80 fb ff ff       	call   800742 <vprintfmt>
  800bc2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 89 ff ff ff       	call   800b7a <vsnprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 06                	jmp    800c11 <strlen+0x15>
		n++;
  800c0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 f1                	jne    800c0b <strlen+0xf>
		n++;
	return n;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 09                	jmp    800c37 <strnlen+0x18>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	ff 4d 0c             	decl   0xc(%ebp)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 09                	je     800c46 <strnlen+0x27>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e8                	jne    800c2e <strnlen+0xf>
		n++;
	return n;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c57:	90                   	nop
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	75 e4                	jne    800c58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 1f                	jmp    800cad <strncpy+0x34>
		*dst++ = *src;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	74 03                	je     800caa <strncpy+0x31>
			src++;
  800ca7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb3:	72 d9                	jb     800c8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 30                	je     800cfc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccc:	eb 16                	jmp    800ce4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce0:	8a 12                	mov    (%edx),%dl
  800ce2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 09                	je     800cf6 <strlcpy+0x3c>
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	75 d8                	jne    800cce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	29 c2                	sub    %eax,%edx
  800d04:	89 d0                	mov    %edx,%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0b:	eb 06                	jmp    800d13 <strcmp+0xb>
		p++, q++;
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 0e                	je     800d2a <strcmp+0x22>
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 10                	mov    (%eax),%dl
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	38 c2                	cmp    %al,%dl
  800d28:	74 e3                	je     800d0d <strcmp+0x5>
		p++, q++;
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

00800d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d43:	eb 09                	jmp    800d4e <strncmp+0xe>
		n--, p++, q++;
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	74 17                	je     800d6b <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 0e                	je     800d6b <strncmp+0x2b>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	38 c2                	cmp    %al,%dl
  800d69:	74 da                	je     800d45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6f:	75 07                	jne    800d78 <strncmp+0x38>
		return 0;
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	eb 14                	jmp    800d8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 d0             	movzbl %al,%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	29 c2                	sub    %eax,%edx
  800d8a:	89 d0                	mov    %edx,%eax
}
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9a:	eb 12                	jmp    800dae <strchr+0x20>
		if (*s == c)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da4:	75 05                	jne    800dab <strchr+0x1d>
			return (char *) s;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	eb 11                	jmp    800dbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dab:	ff 45 08             	incl   0x8(%ebp)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	75 e5                	jne    800d9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dca:	eb 0d                	jmp    800dd9 <strfind+0x1b>
		if (*s == c)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd4:	74 0e                	je     800de4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 ea                	jne    800dcc <strfind+0xe>
  800de2:	eb 01                	jmp    800de5 <strfind+0x27>
		if (*s == c)
			break;
  800de4:	90                   	nop
	return (char *) s;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfa:	76 63                	jbe    800e5f <memset+0x75>
		uint64 data_block = c;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	99                   	cltd   
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e10:	c1 e0 08             	shl    $0x8,%eax
  800e13:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e16:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e23:	c1 e0 10             	shl    $0x10,%eax
  800e26:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e29:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e3f:	eb 18                	jmp    800e59 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e44:	8d 41 08             	lea    0x8(%ecx),%eax
  800e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e50:	89 01                	mov    %eax,(%ecx)
  800e52:	89 51 04             	mov    %edx,0x4(%ecx)
  800e55:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5d:	77 e2                	ja     800e41 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 23                	je     800e88 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x91>
			*p8++ = (uint8)c;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	89 55 10             	mov    %edx,0x10(%ebp)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	75 e5                	jne    800e6d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e9f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea3:	76 24                	jbe    800ec9 <memcpy+0x3c>
		while(n >= 8){
  800ea5:	eb 1c                	jmp    800ec3 <memcpy+0x36>
			*d64 = *s64;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	8b 50 04             	mov    0x4(%eax),%edx
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb2:	89 01                	mov    %eax,(%ecx)
  800eb4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ebf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec7:	77 de                	ja     800ea7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 31                	je     800f00 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edb:	eb 16                	jmp    800ef3 <memcpy+0x66>
			*d8++ = *s8++;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eef:	8a 12                	mov    (%edx),%dl
  800ef1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef9:	89 55 10             	mov    %edx,0x10(%ebp)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	75 dd                	jne    800edd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1d:	73 50                	jae    800f6f <memmove+0x6a>
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2a:	76 43                	jbe    800f6f <memmove+0x6a>
		s += n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f38:	eb 10                	jmp    800f4a <memmove+0x45>
			*--d = *--s;
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	ff 4d fc             	decl   -0x4(%ebp)
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8a 10                	mov    (%eax),%dl
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f50:	89 55 10             	mov    %edx,0x10(%ebp)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 e3                	jne    800f3a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f57:	eb 23                	jmp    800f7c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6b:	8a 12                	mov    (%edx),%dl
  800f6d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 dd                	jne    800f59 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f93:	eb 2a                	jmp    800fbf <memcmp+0x3e>
		if (*s1 != *s2)
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8a 10                	mov    (%eax),%dl
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	38 c2                	cmp    %al,%dl
  800fa1:	74 16                	je     800fb9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 d0             	movzbl %al,%edx
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 c0             	movzbl %al,%eax
  800fb3:	29 c2                	sub    %eax,%edx
  800fb5:	89 d0                	mov    %edx,%eax
  800fb7:	eb 18                	jmp    800fd1 <memcmp+0x50>
		s1++, s2++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
  800fbc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 c9                	jne    800f95 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe4:	eb 15                	jmp    800ffb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	74 0d                	je     801005 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801001:	72 e3                	jb     800fe6 <memfind+0x13>
  801003:	eb 01                	jmp    801006 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801005:	90                   	nop
	return (void *) s;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101f:	eb 03                	jmp    801024 <strtol+0x19>
		s++;
  801021:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 20                	cmp    $0x20,%al
  80102b:	74 f4                	je     801021 <strtol+0x16>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 09                	cmp    $0x9,%al
  801034:	74 eb                	je     801021 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 2b                	cmp    $0x2b,%al
  80103d:	75 05                	jne    801044 <strtol+0x39>
		s++;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	eb 13                	jmp    801057 <strtol+0x4c>
	else if (*s == '-')
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 2d                	cmp    $0x2d,%al
  80104b:	75 0a                	jne    801057 <strtol+0x4c>
		s++, neg = 1;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801057:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105b:	74 06                	je     801063 <strtol+0x58>
  80105d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801061:	75 20                	jne    801083 <strtol+0x78>
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 30                	cmp    $0x30,%al
  80106a:	75 17                	jne    801083 <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	40                   	inc    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 78                	cmp    $0x78,%al
  801074:	75 0d                	jne    801083 <strtol+0x78>
		s += 2, base = 16;
  801076:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801081:	eb 28                	jmp    8010ab <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801087:	75 15                	jne    80109e <strtol+0x93>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 30                	cmp    $0x30,%al
  801090:	75 0c                	jne    80109e <strtol+0x93>
		s++, base = 8;
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109c:	eb 0d                	jmp    8010ab <strtol+0xa0>
	else if (base == 0)
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 07                	jne    8010ab <strtol+0xa0>
		base = 10;
  8010a4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2f                	cmp    $0x2f,%al
  8010b2:	7e 19                	jle    8010cd <strtol+0xc2>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 39                	cmp    $0x39,%al
  8010bb:	7f 10                	jg     8010cd <strtol+0xc2>
			dig = *s - '0';
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be c0             	movsbl %al,%eax
  8010c5:	83 e8 30             	sub    $0x30,%eax
  8010c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cb:	eb 42                	jmp    80110f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 60                	cmp    $0x60,%al
  8010d4:	7e 19                	jle    8010ef <strtol+0xe4>
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 7a                	cmp    $0x7a,%al
  8010dd:	7f 10                	jg     8010ef <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	83 e8 57             	sub    $0x57,%eax
  8010ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ed:	eb 20                	jmp    80110f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 40                	cmp    $0x40,%al
  8010f6:	7e 39                	jle    801131 <strtol+0x126>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 5a                	cmp    $0x5a,%al
  8010ff:	7f 30                	jg     801131 <strtol+0x126>
			dig = *s - 'A' + 10;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	0f be c0             	movsbl %al,%eax
  801109:	83 e8 37             	sub    $0x37,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 10             	cmp    0x10(%ebp),%eax
  801115:	7d 19                	jge    801130 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801121:	89 c2                	mov    %eax,%edx
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112b:	e9 7b ff ff ff       	jmp    8010ab <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801130:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801135:	74 08                	je     80113f <strtol+0x134>
		*endptr = (char *) s;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80113f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801143:	74 07                	je     80114c <strtol+0x141>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	f7 d8                	neg    %eax
  80114a:	eb 03                	jmp    80114f <strtol+0x144>
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <ltostr>:

void
ltostr(long value, char *str)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	79 13                	jns    80117e <ltostr+0x2d>
	{
		neg = 1;
  80116b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801178:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801186:	99                   	cltd   
  801187:	f7 f9                	idiv   %ecx
  801189:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119f:	83 c2 30             	add    $0x30,%edx
  8011a2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ac:	f7 e9                	imul   %ecx
  8011ae:	c1 fa 02             	sar    $0x2,%edx
  8011b1:	89 c8                	mov    %ecx,%eax
  8011b3:	c1 f8 1f             	sar    $0x1f,%eax
  8011b6:	29 c2                	sub    %eax,%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	75 bb                	jne    80117e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	48                   	dec    %eax
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 3d                	je     801214 <ltostr+0xc3>
		start = 1 ;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011de:	eb 34                	jmp    801214 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120c:	88 02                	mov    %al,(%edx)
		start++ ;
  80120e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801211:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121a:	7c c4                	jl     8011e0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 c4 f9 ff ff       	call   800bfc <strlen>
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 b6 f9 ff ff       	call   800bfc <strlen>
  801246:	83 c4 04             	add    $0x4,%esp
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125a:	eb 17                	jmp    801273 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801270:	ff 45 fc             	incl   -0x4(%ebp)
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801279:	7c e1                	jl     80125c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801289:	eb 1f                	jmp    8012aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c d9                	jl     80128b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e3:	eb 0c                	jmp    8012f1 <strsplit+0x31>
			*string++ = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 18                	je     801312 <strsplit+0x52>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	50                   	push   %eax
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	e8 83 fa ff ff       	call   800d8e <strchr>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 d3                	jne    8012e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 5a                	je     801375 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	83 f8 0f             	cmp    $0xf,%eax
  801323:	75 07                	jne    80132c <strsplit+0x6c>
		{
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 66                	jmp    801392 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 48 01             	lea    0x1(%eax),%ecx
  801334:	8b 55 14             	mov    0x14(%ebp),%edx
  801337:	89 0a                	mov    %ecx,(%edx)
  801339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134a:	eb 03                	jmp    80134f <strsplit+0x8f>
			string++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	74 8b                	je     8012e3 <strsplit+0x23>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	0f be c0             	movsbl %al,%eax
  801360:	50                   	push   %eax
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 25 fa ff ff       	call   800d8e <strchr>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 dc                	je     80134c <strsplit+0x8c>
			string++;
	}
  801370:	e9 6e ff ff ff       	jmp    8012e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801375:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a7:	eb 4a                	jmp    8013f3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	01 c2                	add    %eax,%edx
  8013b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c8                	add    %ecx,%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 40                	cmp    $0x40,%al
  8013c9:	7e 25                	jle    8013f0 <str2lower+0x5c>
  8013cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 5a                	cmp    $0x5a,%al
  8013d7:	7f 17                	jg     8013f0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e7:	01 ca                	add    %ecx,%edx
  8013e9:	8a 12                	mov    (%edx),%dl
  8013eb:	83 c2 20             	add    $0x20,%edx
  8013ee:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	e8 01 f8 ff ff       	call   800bfc <strlen>
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801401:	7f a6                	jg     8013a9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80140e:	a1 08 40 80 00       	mov    0x804008,%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 42                	je     801459 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	68 00 00 00 82       	push   $0x82000000
  80141f:	68 00 00 00 80       	push   $0x80000000
  801424:	e8 00 08 00 00       	call   801c29 <initialize_dynamic_allocator>
  801429:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80142c:	e8 e7 05 00 00       	call   801a18 <sys_get_uheap_strategy>
  801431:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801436:	a1 40 40 80 00       	mov    0x804040,%eax
  80143b:	05 00 10 00 00       	add    $0x1000,%eax
  801440:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801445:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80144a:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80144f:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801456:	00 00 00 
	}
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	68 06 04 00 00       	push   $0x406
  801478:	50                   	push   %eax
  801479:	e8 e4 01 00 00       	call   801662 <__sys_allocate_page>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801484:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801488:	79 14                	jns    80149e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 e8 31 80 00       	push   $0x8031e8
  801492:	6a 1f                	push   $0x1f
  801494:	68 24 32 80 00       	push   $0x803224
  801499:	e8 ab 13 00 00       	call   802849 <_panic>
	return 0;
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b9:	83 ec 0c             	sub    $0xc,%esp
  8014bc:	50                   	push   %eax
  8014bd:	e8 e7 01 00 00       	call   8016a9 <__sys_unmap_frame>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014cc:	79 14                	jns    8014e2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 30 32 80 00       	push   $0x803230
  8014d6:	6a 2a                	push   $0x2a
  8014d8:	68 24 32 80 00       	push   $0x803224
  8014dd:	e8 67 13 00 00       	call   802849 <_panic>
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8014eb:	e8 18 ff ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  8014f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f4:	75 07                	jne    8014fd <malloc+0x18>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 14                	jmp    801511 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	68 70 32 80 00       	push   $0x803270
  801505:	6a 3e                	push   $0x3e
  801507:	68 24 32 80 00       	push   $0x803224
  80150c:	e8 38 13 00 00       	call   802849 <_panic>
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	68 98 32 80 00       	push   $0x803298
  801521:	6a 49                	push   $0x49
  801523:	68 24 32 80 00       	push   $0x803224
  801528:	e8 1c 13 00 00       	call   802849 <_panic>

0080152d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 18             	sub    $0x18,%esp
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801539:	e8 ca fe ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  80153e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801542:	75 07                	jne    80154b <smalloc+0x1e>
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 14                	jmp    80155f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	68 bc 32 80 00       	push   $0x8032bc
  801553:	6a 5a                	push   $0x5a
  801555:	68 24 32 80 00       	push   $0x803224
  80155a:	e8 ea 12 00 00       	call   802849 <_panic>
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801567:	e8 9c fe ff ff       	call   801408 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 e4 32 80 00       	push   $0x8032e4
  801574:	6a 6a                	push   $0x6a
  801576:	68 24 32 80 00       	push   $0x803224
  80157b:	e8 c9 12 00 00       	call   802849 <_panic>

00801580 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801586:	e8 7d fe ff ff       	call   801408 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 08 33 80 00       	push   $0x803308
  801593:	68 88 00 00 00       	push   $0x88
  801598:	68 24 32 80 00       	push   $0x803224
  80159d:	e8 a7 12 00 00       	call   802849 <_panic>

008015a2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	68 30 33 80 00       	push   $0x803330
  8015b0:	68 9b 00 00 00       	push   $0x9b
  8015b5:	68 24 32 80 00       	push   $0x803224
  8015ba:	e8 8a 12 00 00       	call   802849 <_panic>

008015bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	57                   	push   %edi
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015da:	cd 30                	int    $0x30
  8015dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	51                   	push   %ecx
  801603:	52                   	push   %edx
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	50                   	push   %eax
  801608:	6a 00                	push   $0x0
  80160a:	e8 b0 ff ff ff       	call   8015bf <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	90                   	nop
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_cgetc>:

int
sys_cgetc(void)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 02                	push   $0x2
  801624:	e8 96 ff ff ff       	call   8015bf <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 03                	push   $0x3
  80163d:	e8 7d ff ff ff       	call   8015bf <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	90                   	nop
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 04                	push   $0x4
  801657:	e8 63 ff ff ff       	call   8015bf <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	52                   	push   %edx
  801672:	50                   	push   %eax
  801673:	6a 08                	push   $0x8
  801675:	e8 45 ff ff ff       	call   8015bf <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801684:	8b 75 18             	mov    0x18(%ebp),%esi
  801687:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	50                   	push   %eax
  801698:	6a 09                	push   $0x9
  80169a:	e8 20 ff ff ff       	call   8015bf <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	6a 0a                	push   $0xa
  8016b9:	e8 01 ff ff ff       	call   8015bf <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	6a 0b                	push   $0xb
  8016d4:	e8 e6 fe ff ff       	call   8015bf <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0c                	push   $0xc
  8016ed:	e8 cd fe ff ff       	call   8015bf <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0d                	push   $0xd
  801706:	e8 b4 fe ff ff       	call   8015bf <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 0e                	push   $0xe
  80171f:	e8 9b fe ff ff       	call   8015bf <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 0f                	push   $0xf
  801738:	e8 82 fe ff ff       	call   8015bf <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	6a 10                	push   $0x10
  801752:	e8 68 fe ff ff       	call   8015bf <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 11                	push   $0x11
  80176b:	e8 4f fe ff ff       	call   8015bf <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	90                   	nop
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_cputc>:

void
sys_cputc(const char c)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801782:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	50                   	push   %eax
  80178f:	6a 01                	push   $0x1
  801791:	e8 29 fe ff ff       	call   8015bf <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 14                	push   $0x14
  8017ab:	e8 0f fe ff ff       	call   8015bf <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	51                   	push   %ecx
  8017cf:	52                   	push   %edx
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	6a 15                	push   $0x15
  8017d6:	e8 e4 fd ff ff       	call   8015bf <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 16                	push   $0x16
  8017f3:	e8 c7 fd ff ff       	call   8015bf <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	51                   	push   %ecx
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 17                	push   $0x17
  801812:	e8 a8 fd ff ff       	call   8015bf <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 18                	push   $0x18
  80182f:	e8 8b fd ff ff       	call   8015bf <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 14             	pushl  0x14(%ebp)
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	6a 19                	push   $0x19
  80184d:	e8 6d fd ff ff       	call   8015bf <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	50                   	push   %eax
  801866:	6a 1a                	push   $0x1a
  801868:	e8 52 fd ff ff       	call   8015bf <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	50                   	push   %eax
  801882:	6a 1b                	push   $0x1b
  801884:	e8 36 fd ff ff       	call   8015bf <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 05                	push   $0x5
  80189d:	e8 1d fd ff ff       	call   8015bf <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 06                	push   $0x6
  8018b6:	e8 04 fd ff ff       	call   8015bf <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 07                	push   $0x7
  8018cf:	e8 eb fc ff ff       	call   8015bf <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_exit_env>:


void sys_exit_env(void)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 1c                	push   $0x1c
  8018e8:	e8 d2 fc ff ff       	call   8015bf <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018fc:	8d 50 04             	lea    0x4(%eax),%edx
  8018ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 1d                	push   $0x1d
  80190c:	e8 ae fc ff ff       	call   8015bf <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
	return result;
  801914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191d:	89 01                	mov    %eax,(%ecx)
  80191f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	c9                   	leave  
  801926:	c2 04 00             	ret    $0x4

00801929 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 13                	push   $0x13
  80193b:	e8 7f fc ff ff       	call   8015bf <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_rcr2>:
uint32 sys_rcr2()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 1e                	push   $0x1e
  801955:	e8 65 fc ff ff       	call   8015bf <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80196b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	50                   	push   %eax
  801978:	6a 1f                	push   $0x1f
  80197a:	e8 40 fc ff ff       	call   8015bf <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <rsttst>:
void rsttst()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 21                	push   $0x21
  801994:	e8 26 fc ff ff       	call   8015bf <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
	return ;
  80199c:	90                   	nop
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 20                	push   $0x20
  8019bf:	e8 fb fb ff ff       	call   8015bf <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <chktst>:
void chktst(uint32 n)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 22                	push   $0x22
  8019da:	e8 e0 fb ff ff       	call   8015bf <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <inctst>:

void inctst()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 23                	push   $0x23
  8019f4:	e8 c6 fb ff ff       	call   8015bf <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <gettst>:
uint32 gettst()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 24                	push   $0x24
  801a0e:	e8 ac fb ff ff       	call   8015bf <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 25                	push   $0x25
  801a27:	e8 93 fb ff ff       	call   8015bf <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
  801a2f:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801a34:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 26                	push   $0x26
  801a53:	e8 67 fb ff ff       	call   8015bf <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	53                   	push   %ebx
  801a71:	51                   	push   %ecx
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 27                	push   $0x27
  801a76:	e8 44 fb ff ff       	call   8015bf <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 28                	push   $0x28
  801a96:	e8 24 fb ff ff       	call   8015bf <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 29                	push   $0x29
  801ab6:	e8 04 fb ff ff       	call   8015bf <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	ff 75 10             	pushl  0x10(%ebp)
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	6a 12                	push   $0x12
  801ad2:	e8 e8 fa ff ff       	call   8015bf <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 2a                	push   $0x2a
  801af0:	e8 ca fa ff ff       	call   8015bf <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 2b                	push   $0x2b
  801b0a:	e8 b0 fa ff ff       	call   8015bf <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 2d                	push   $0x2d
  801b25:	e8 95 fa ff ff       	call   8015bf <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 2c                	push   $0x2c
  801b41:	e8 79 fa ff ff       	call   8015bf <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 54 33 80 00       	push   $0x803354
  801b5a:	68 25 01 00 00       	push   $0x125
  801b5f:	68 87 33 80 00       	push   $0x803387
  801b64:	e8 e0 0c 00 00       	call   802849 <_panic>

00801b69 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801b6f:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801b76:	72 09                	jb     801b81 <to_page_va+0x18>
  801b78:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801b7f:	72 14                	jb     801b95 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	68 98 33 80 00       	push   $0x803398
  801b89:	6a 15                	push   $0x15
  801b8b:	68 c3 33 80 00       	push   $0x8033c3
  801b90:	e8 b4 0c 00 00       	call   802849 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	ba 60 40 80 00       	mov    $0x804060,%edx
  801b9d:	29 d0                	sub    %edx,%eax
  801b9f:	c1 f8 02             	sar    $0x2,%eax
  801ba2:	89 c2                	mov    %eax,%edx
  801ba4:	89 d0                	mov    %edx,%eax
  801ba6:	c1 e0 02             	shl    $0x2,%eax
  801ba9:	01 d0                	add    %edx,%eax
  801bab:	c1 e0 02             	shl    $0x2,%eax
  801bae:	01 d0                	add    %edx,%eax
  801bb0:	c1 e0 02             	shl    $0x2,%eax
  801bb3:	01 d0                	add    %edx,%eax
  801bb5:	89 c1                	mov    %eax,%ecx
  801bb7:	c1 e1 08             	shl    $0x8,%ecx
  801bba:	01 c8                	add    %ecx,%eax
  801bbc:	89 c1                	mov    %eax,%ecx
  801bbe:	c1 e1 10             	shl    $0x10,%ecx
  801bc1:	01 c8                	add    %ecx,%eax
  801bc3:	01 c0                	add    %eax,%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcd:	c1 e0 0c             	shl    $0xc,%eax
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801bd7:	01 d0                	add    %edx,%eax
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801be1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801be6:	8b 55 08             	mov    0x8(%ebp),%edx
  801be9:	29 c2                	sub    %eax,%edx
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	c1 e8 0c             	shr    $0xc,%eax
  801bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf7:	78 09                	js     801c02 <to_page_info+0x27>
  801bf9:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c00:	7e 14                	jle    801c16 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 dc 33 80 00       	push   $0x8033dc
  801c0a:	6a 22                	push   $0x22
  801c0c:	68 c3 33 80 00       	push   $0x8033c3
  801c11:	e8 33 0c 00 00       	call   802849 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	01 c0                	add    %eax,%eax
  801c1d:	01 d0                	add    %edx,%eax
  801c1f:	c1 e0 02             	shl    $0x2,%eax
  801c22:	05 60 40 80 00       	add    $0x804060,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	05 00 00 00 02       	add    $0x2000000,%eax
  801c37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c3a:	73 16                	jae    801c52 <initialize_dynamic_allocator+0x29>
  801c3c:	68 00 34 80 00       	push   $0x803400
  801c41:	68 26 34 80 00       	push   $0x803426
  801c46:	6a 34                	push   $0x34
  801c48:	68 c3 33 80 00       	push   $0x8033c3
  801c4d:	e8 f7 0b 00 00       	call   802849 <_panic>
		is_initialized = 1;
  801c52:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801c59:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801c6c:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801c73:	00 00 00 
  801c76:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801c7d:	00 00 00 
  801c80:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801c87:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	2b 45 08             	sub    0x8(%ebp),%eax
  801c90:	c1 e8 0c             	shr    $0xc,%eax
  801c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c9d:	e9 c8 00 00 00       	jmp    801d6a <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca5:	89 d0                	mov    %edx,%eax
  801ca7:	01 c0                	add    %eax,%eax
  801ca9:	01 d0                	add    %edx,%eax
  801cab:	c1 e0 02             	shl    $0x2,%eax
  801cae:	05 68 40 80 00       	add    $0x804068,%eax
  801cb3:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	01 c0                	add    %eax,%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c1 e0 02             	shl    $0x2,%eax
  801cc4:	05 6a 40 80 00       	add    $0x80406a,%eax
  801cc9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801cce:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801cd4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801cd7:	89 c8                	mov    %ecx,%eax
  801cd9:	01 c0                	add    %eax,%eax
  801cdb:	01 c8                	add    %ecx,%eax
  801cdd:	c1 e0 02             	shl    $0x2,%eax
  801ce0:	05 64 40 80 00       	add    $0x804064,%eax
  801ce5:	89 10                	mov    %edx,(%eax)
  801ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cea:	89 d0                	mov    %edx,%eax
  801cec:	01 c0                	add    %eax,%eax
  801cee:	01 d0                	add    %edx,%eax
  801cf0:	c1 e0 02             	shl    $0x2,%eax
  801cf3:	05 64 40 80 00       	add    $0x804064,%eax
  801cf8:	8b 00                	mov    (%eax),%eax
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	74 1b                	je     801d19 <initialize_dynamic_allocator+0xf0>
  801cfe:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d04:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d07:	89 c8                	mov    %ecx,%eax
  801d09:	01 c0                	add    %eax,%eax
  801d0b:	01 c8                	add    %ecx,%eax
  801d0d:	c1 e0 02             	shl    $0x2,%eax
  801d10:	05 60 40 80 00       	add    $0x804060,%eax
  801d15:	89 02                	mov    %eax,(%edx)
  801d17:	eb 16                	jmp    801d2f <initialize_dynamic_allocator+0x106>
  801d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	c1 e0 02             	shl    $0x2,%eax
  801d25:	05 60 40 80 00       	add    $0x804060,%eax
  801d2a:	a3 48 40 80 00       	mov    %eax,0x804048
  801d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d32:	89 d0                	mov    %edx,%eax
  801d34:	01 c0                	add    %eax,%eax
  801d36:	01 d0                	add    %edx,%eax
  801d38:	c1 e0 02             	shl    $0x2,%eax
  801d3b:	05 60 40 80 00       	add    $0x804060,%eax
  801d40:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d48:	89 d0                	mov    %edx,%eax
  801d4a:	01 c0                	add    %eax,%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	c1 e0 02             	shl    $0x2,%eax
  801d51:	05 60 40 80 00       	add    $0x804060,%eax
  801d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d5c:	a1 54 40 80 00       	mov    0x804054,%eax
  801d61:	40                   	inc    %eax
  801d62:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d67:	ff 45 f4             	incl   -0xc(%ebp)
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d70:	0f 8c 2c ff ff ff    	jl     801ca2 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801d76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801d7d:	eb 36                	jmp    801db5 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d82:	c1 e0 04             	shl    $0x4,%eax
  801d85:	05 80 c0 81 00       	add    $0x81c080,%eax
  801d8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	c1 e0 04             	shl    $0x4,%eax
  801d96:	05 84 c0 81 00       	add    $0x81c084,%eax
  801d9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da4:	c1 e0 04             	shl    $0x4,%eax
  801da7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801db2:	ff 45 f0             	incl   -0x10(%ebp)
  801db5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801db9:	7e c4                	jle    801d7f <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801dbb:	90                   	nop
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	50                   	push   %eax
  801dcb:	e8 0b fe ff ff       	call   801bdb <to_page_info>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 40 08             	mov    0x8(%eax),%eax
  801ddc:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	e8 77 fd ff ff       	call   801b69 <to_page_va>
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801df8:	b8 00 10 00 00       	mov    $0x1000,%eax
  801dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801e02:	f7 75 08             	divl   0x8(%ebp)
  801e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801e08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	50                   	push   %eax
  801e0f:	e8 48 f6 ff ff       	call   80145c <get_page>
  801e14:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e27:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801e2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e32:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801e39:	eb 19                	jmp    801e54 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3e:	ba 01 00 00 00       	mov    $0x1,%edx
  801e43:	88 c1                	mov    %al,%cl
  801e45:	d3 e2                	shl    %cl,%edx
  801e47:	89 d0                	mov    %edx,%eax
  801e49:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e4c:	74 0e                	je     801e5c <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801e4e:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e51:	ff 45 f0             	incl   -0x10(%ebp)
  801e54:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801e58:	7e e1                	jle    801e3b <split_page_to_blocks+0x5a>
  801e5a:	eb 01                	jmp    801e5d <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801e5c:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801e5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e64:	e9 a7 00 00 00       	jmp    801f10 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6c:	0f af 45 08          	imul   0x8(%ebp),%eax
  801e70:	89 c2                	mov    %eax,%edx
  801e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e7e:	75 14                	jne    801e94 <split_page_to_blocks+0xb3>
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	68 3c 34 80 00       	push   $0x80343c
  801e88:	6a 7c                	push   $0x7c
  801e8a:	68 c3 33 80 00       	push   $0x8033c3
  801e8f:	e8 b5 09 00 00       	call   802849 <_panic>
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	c1 e0 04             	shl    $0x4,%eax
  801e9a:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e9f:	8b 10                	mov    (%eax),%edx
  801ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea4:	89 50 04             	mov    %edx,0x4(%eax)
  801ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaa:	8b 40 04             	mov    0x4(%eax),%eax
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	74 14                	je     801ec5 <split_page_to_blocks+0xe4>
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	c1 e0 04             	shl    $0x4,%eax
  801eb7:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ec1:	89 10                	mov    %edx,(%eax)
  801ec3:	eb 11                	jmp    801ed6 <split_page_to_blocks+0xf5>
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec8:	c1 e0 04             	shl    $0x4,%eax
  801ecb:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed4:	89 02                	mov    %eax,(%edx)
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	c1 e0 04             	shl    $0x4,%eax
  801edc:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee5:	89 02                	mov    %eax,(%edx)
  801ee7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	c1 e0 04             	shl    $0x4,%eax
  801ef6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801efb:	8b 00                	mov    (%eax),%eax
  801efd:	8d 50 01             	lea    0x1(%eax),%edx
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	c1 e0 04             	shl    $0x4,%eax
  801f06:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f0b:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f0d:	ff 45 ec             	incl   -0x14(%ebp)
  801f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f13:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f16:	0f 82 4d ff ff ff    	jb     801e69 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801f1c:	90                   	nop
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f25:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f2c:	76 19                	jbe    801f47 <alloc_block+0x28>
  801f2e:	68 60 34 80 00       	push   $0x803460
  801f33:	68 26 34 80 00       	push   $0x803426
  801f38:	68 8a 00 00 00       	push   $0x8a
  801f3d:	68 c3 33 80 00       	push   $0x8033c3
  801f42:	e8 02 09 00 00       	call   802849 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801f47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f4e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f55:	eb 19                	jmp    801f70 <alloc_block+0x51>
		if((1 << i) >= size) break;
  801f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5a:	ba 01 00 00 00       	mov    $0x1,%edx
  801f5f:	88 c1                	mov    %al,%cl
  801f61:	d3 e2                	shl    %cl,%edx
  801f63:	89 d0                	mov    %edx,%eax
  801f65:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f68:	73 0e                	jae    801f78 <alloc_block+0x59>
		idx++;
  801f6a:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f6d:	ff 45 f0             	incl   -0x10(%ebp)
  801f70:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f74:	7e e1                	jle    801f57 <alloc_block+0x38>
  801f76:	eb 01                	jmp    801f79 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801f78:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	c1 e0 04             	shl    $0x4,%eax
  801f7f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	0f 84 df 00 00 00    	je     80206d <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	c1 e0 04             	shl    $0x4,%eax
  801f94:	05 80 c0 81 00       	add    $0x81c080,%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  801f9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa2:	75 17                	jne    801fbb <alloc_block+0x9c>
  801fa4:	83 ec 04             	sub    $0x4,%esp
  801fa7:	68 81 34 80 00       	push   $0x803481
  801fac:	68 9e 00 00 00       	push   $0x9e
  801fb1:	68 c3 33 80 00       	push   $0x8033c3
  801fb6:	e8 8e 08 00 00       	call   802849 <_panic>
  801fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbe:	8b 00                	mov    (%eax),%eax
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	74 10                	je     801fd4 <alloc_block+0xb5>
  801fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fcc:	8b 52 04             	mov    0x4(%edx),%edx
  801fcf:	89 50 04             	mov    %edx,0x4(%eax)
  801fd2:	eb 14                	jmp    801fe8 <alloc_block+0xc9>
  801fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd7:	8b 40 04             	mov    0x4(%eax),%eax
  801fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdd:	c1 e2 04             	shl    $0x4,%edx
  801fe0:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  801fe6:	89 02                	mov    %eax,(%edx)
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	8b 40 04             	mov    0x4(%eax),%eax
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	74 0f                	je     802001 <alloc_block+0xe2>
  801ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff5:	8b 40 04             	mov    0x4(%eax),%eax
  801ff8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ffb:	8b 12                	mov    (%edx),%edx
  801ffd:	89 10                	mov    %edx,(%eax)
  801fff:	eb 13                	jmp    802014 <alloc_block+0xf5>
  802001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802004:	8b 00                	mov    (%eax),%eax
  802006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802009:	c1 e2 04             	shl    $0x4,%edx
  80200c:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802012:	89 02                	mov    %eax,(%edx)
  802014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	c1 e0 04             	shl    $0x4,%eax
  80202d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802032:	8b 00                	mov    (%eax),%eax
  802034:	8d 50 ff             	lea    -0x1(%eax),%edx
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	c1 e0 04             	shl    $0x4,%eax
  80203d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802042:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	50                   	push   %eax
  80204b:	e8 8b fb ff ff       	call   801bdb <to_page_info>
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802059:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80205d:	48                   	dec    %eax
  80205e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802061:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	e9 bc 02 00 00       	jmp    802329 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80206d:	a1 54 40 80 00       	mov    0x804054,%eax
  802072:	85 c0                	test   %eax,%eax
  802074:	0f 84 7d 02 00 00    	je     8022f7 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80207a:	a1 48 40 80 00       	mov    0x804048,%eax
  80207f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802082:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802086:	75 17                	jne    80209f <alloc_block+0x180>
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 81 34 80 00       	push   $0x803481
  802090:	68 a9 00 00 00       	push   $0xa9
  802095:	68 c3 33 80 00       	push   $0x8033c3
  80209a:	e8 aa 07 00 00       	call   802849 <_panic>
  80209f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	74 10                	je     8020b8 <alloc_block+0x199>
  8020a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020b0:	8b 52 04             	mov    0x4(%edx),%edx
  8020b3:	89 50 04             	mov    %edx,0x4(%eax)
  8020b6:	eb 0b                	jmp    8020c3 <alloc_block+0x1a4>
  8020b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020bb:	8b 40 04             	mov    0x4(%eax),%eax
  8020be:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c6:	8b 40 04             	mov    0x4(%eax),%eax
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	74 0f                	je     8020dc <alloc_block+0x1bd>
  8020cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d0:	8b 40 04             	mov    0x4(%eax),%eax
  8020d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020d6:	8b 12                	mov    (%edx),%edx
  8020d8:	89 10                	mov    %edx,(%eax)
  8020da:	eb 0a                	jmp    8020e6 <alloc_block+0x1c7>
  8020dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	a3 48 40 80 00       	mov    %eax,0x804048
  8020e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f9:	a1 54 40 80 00       	mov    0x804054,%eax
  8020fe:	48                   	dec    %eax
  8020ff:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	83 c0 03             	add    $0x3,%eax
  80210a:	ba 01 00 00 00       	mov    $0x1,%edx
  80210f:	88 c1                	mov    %al,%cl
  802111:	d3 e2                	shl    %cl,%edx
  802113:	89 d0                	mov    %edx,%eax
  802115:	83 ec 08             	sub    $0x8,%esp
  802118:	ff 75 e4             	pushl  -0x1c(%ebp)
  80211b:	50                   	push   %eax
  80211c:	e8 c0 fc ff ff       	call   801de1 <split_page_to_blocks>
  802121:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	c1 e0 04             	shl    $0x4,%eax
  80212a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802134:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802138:	75 17                	jne    802151 <alloc_block+0x232>
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 81 34 80 00       	push   $0x803481
  802142:	68 b0 00 00 00       	push   $0xb0
  802147:	68 c3 33 80 00       	push   $0x8033c3
  80214c:	e8 f8 06 00 00       	call   802849 <_panic>
  802151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	74 10                	je     80216a <alloc_block+0x24b>
  80215a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802162:	8b 52 04             	mov    0x4(%edx),%edx
  802165:	89 50 04             	mov    %edx,0x4(%eax)
  802168:	eb 14                	jmp    80217e <alloc_block+0x25f>
  80216a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216d:	8b 40 04             	mov    0x4(%eax),%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80217c:	89 02                	mov    %eax,(%edx)
  80217e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802181:	8b 40 04             	mov    0x4(%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	74 0f                	je     802197 <alloc_block+0x278>
  802188:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218b:	8b 40 04             	mov    0x4(%eax),%eax
  80218e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802191:	8b 12                	mov    (%edx),%edx
  802193:	89 10                	mov    %edx,(%eax)
  802195:	eb 13                	jmp    8021aa <alloc_block+0x28b>
  802197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80219a:	8b 00                	mov    (%eax),%eax
  80219c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219f:	c1 e2 04             	shl    $0x4,%edx
  8021a2:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8021a8:	89 02                	mov    %eax,(%edx)
  8021aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	c1 e0 04             	shl    $0x4,%eax
  8021c3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	c1 e0 04             	shl    $0x4,%eax
  8021d3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021d8:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8021da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	50                   	push   %eax
  8021e1:	e8 f5 f9 ff ff       	call   801bdb <to_page_info>
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8021ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021ef:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8021f3:	48                   	dec    %eax
  8021f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021f7:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8021fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fe:	e9 26 01 00 00       	jmp    802329 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802203:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	c1 e0 04             	shl    $0x4,%eax
  80220c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 84 dc 00 00 00    	je     8022f7 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	c1 e0 04             	shl    $0x4,%eax
  802221:	05 80 c0 81 00       	add    $0x81c080,%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80222b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80222f:	75 17                	jne    802248 <alloc_block+0x329>
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 81 34 80 00       	push   $0x803481
  802239:	68 be 00 00 00       	push   $0xbe
  80223e:	68 c3 33 80 00       	push   $0x8033c3
  802243:	e8 01 06 00 00       	call   802849 <_panic>
  802248:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	74 10                	je     802261 <alloc_block+0x342>
  802251:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802259:	8b 52 04             	mov    0x4(%edx),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	eb 14                	jmp    802275 <alloc_block+0x356>
  802261:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802264:	8b 40 04             	mov    0x4(%eax),%eax
  802267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226a:	c1 e2 04             	shl    $0x4,%edx
  80226d:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802273:	89 02                	mov    %eax,(%edx)
  802275:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802278:	8b 40 04             	mov    0x4(%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	74 0f                	je     80228e <alloc_block+0x36f>
  80227f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802282:	8b 40 04             	mov    0x4(%eax),%eax
  802285:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802288:	8b 12                	mov    (%edx),%edx
  80228a:	89 10                	mov    %edx,(%eax)
  80228c:	eb 13                	jmp    8022a1 <alloc_block+0x382>
  80228e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802296:	c1 e2 04             	shl    $0x4,%edx
  802299:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80229f:	89 02                	mov    %eax,(%edx)
  8022a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	c1 e0 04             	shl    $0x4,%eax
  8022ba:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	c1 e0 04             	shl    $0x4,%eax
  8022ca:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022cf:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8022d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	50                   	push   %eax
  8022d8:	e8 fe f8 ff ff       	call   801bdb <to_page_info>
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8022e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022e6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022ea:	48                   	dec    %eax
  8022eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022ee:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8022f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f5:	eb 32                	jmp    802329 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8022f7:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8022fb:	77 15                	ja     802312 <alloc_block+0x3f3>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	c1 e0 04             	shl    $0x4,%eax
  802303:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	0f 84 f1 fe ff ff    	je     802203 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 9f 34 80 00       	push   $0x80349f
  80231a:	68 c8 00 00 00       	push   $0xc8
  80231f:	68 c3 33 80 00       	push   $0x8033c3
  802324:	e8 20 05 00 00       	call   802849 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802331:	8b 55 08             	mov    0x8(%ebp),%edx
  802334:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802339:	39 c2                	cmp    %eax,%edx
  80233b:	72 0c                	jb     802349 <free_block+0x1e>
  80233d:	8b 55 08             	mov    0x8(%ebp),%edx
  802340:	a1 40 40 80 00       	mov    0x804040,%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	72 19                	jb     802362 <free_block+0x37>
  802349:	68 b0 34 80 00       	push   $0x8034b0
  80234e:	68 26 34 80 00       	push   $0x803426
  802353:	68 d7 00 00 00       	push   $0xd7
  802358:	68 c3 33 80 00       	push   $0x8033c3
  80235d:	e8 e7 04 00 00       	call   802849 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	50                   	push   %eax
  80236f:	e8 67 f8 ff ff       	call   801bdb <to_page_info>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80237a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237d:	8b 40 08             	mov    0x8(%eax),%eax
  802380:	0f b7 c0             	movzwl %ax,%eax
  802383:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80238d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802394:	eb 19                	jmp    8023af <free_block+0x84>
	    if ((1 << i) == blk_size)
  802396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802399:	ba 01 00 00 00       	mov    $0x1,%edx
  80239e:	88 c1                	mov    %al,%cl
  8023a0:	d3 e2                	shl    %cl,%edx
  8023a2:	89 d0                	mov    %edx,%eax
  8023a4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8023a7:	74 0e                	je     8023b7 <free_block+0x8c>
	        break;
	    idx++;
  8023a9:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8023ac:	ff 45 f0             	incl   -0x10(%ebp)
  8023af:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8023b3:	7e e1                	jle    802396 <free_block+0x6b>
  8023b5:	eb 01                	jmp    8023b8 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8023b7:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8023b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023bf:	40                   	inc    %eax
  8023c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c3:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8023c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023cb:	75 17                	jne    8023e4 <free_block+0xb9>
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	68 3c 34 80 00       	push   $0x80343c
  8023d5:	68 ee 00 00 00       	push   $0xee
  8023da:	68 c3 33 80 00       	push   $0x8033c3
  8023df:	e8 65 04 00 00       	call   802849 <_panic>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	c1 e0 04             	shl    $0x4,%eax
  8023ea:	05 84 c0 81 00       	add    $0x81c084,%eax
  8023ef:	8b 10                	mov    (%eax),%edx
  8023f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023f4:	89 50 04             	mov    %edx,0x4(%eax)
  8023f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	74 14                	je     802415 <free_block+0xea>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	c1 e0 04             	shl    $0x4,%eax
  802407:	05 84 c0 81 00       	add    $0x81c084,%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	eb 11                	jmp    802426 <free_block+0xfb>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	c1 e0 04             	shl    $0x4,%eax
  80241b:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802421:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802424:	89 02                	mov    %eax,(%edx)
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	c1 e0 04             	shl    $0x4,%eax
  80242c:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802435:	89 02                	mov    %eax,(%edx)
  802437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	c1 e0 04             	shl    $0x4,%eax
  802446:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	8d 50 01             	lea    0x1(%eax),%edx
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	c1 e0 04             	shl    $0x4,%eax
  802456:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80245b:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80245d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802462:	ba 00 00 00 00       	mov    $0x0,%edx
  802467:	f7 75 e0             	divl   -0x20(%ebp)
  80246a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80246d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802470:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802474:	0f b7 c0             	movzwl %ax,%eax
  802477:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80247a:	0f 85 70 01 00 00    	jne    8025f0 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802480:	83 ec 0c             	sub    $0xc,%esp
  802483:	ff 75 e4             	pushl  -0x1c(%ebp)
  802486:	e8 de f6 ff ff       	call   801b69 <to_page_va>
  80248b:	83 c4 10             	add    $0x10,%esp
  80248e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802491:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802498:	e9 b7 00 00 00       	jmp    802554 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80249d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8024a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024ac:	75 17                	jne    8024c5 <free_block+0x19a>
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	68 81 34 80 00       	push   $0x803481
  8024b6:	68 f8 00 00 00       	push   $0xf8
  8024bb:	68 c3 33 80 00       	push   $0x8033c3
  8024c0:	e8 84 03 00 00       	call   802849 <_panic>
  8024c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 10                	je     8024de <free_block+0x1b3>
  8024ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024d6:	8b 52 04             	mov    0x4(%edx),%edx
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)
  8024dc:	eb 14                	jmp    8024f2 <free_block+0x1c7>
  8024de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	c1 e2 04             	shl    $0x4,%edx
  8024ea:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024f0:	89 02                	mov    %eax,(%edx)
  8024f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f5:	8b 40 04             	mov    0x4(%eax),%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	74 0f                	je     80250b <free_block+0x1e0>
  8024fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ff:	8b 40 04             	mov    0x4(%eax),%eax
  802502:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802505:	8b 12                	mov    (%edx),%edx
  802507:	89 10                	mov    %edx,(%eax)
  802509:	eb 13                	jmp    80251e <free_block+0x1f3>
  80250b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	c1 e2 04             	shl    $0x4,%edx
  802516:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80251c:	89 02                	mov    %eax,(%edx)
  80251e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	c1 e0 04             	shl    $0x4,%eax
  802537:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	c1 e0 04             	shl    $0x4,%eax
  802547:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80254c:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	01 45 ec             	add    %eax,-0x14(%ebp)
  802554:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80255b:	0f 86 3c ff ff ff    	jbe    80249d <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802564:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802573:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802577:	75 17                	jne    802590 <free_block+0x265>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 3c 34 80 00       	push   $0x80343c
  802581:	68 fe 00 00 00       	push   $0xfe
  802586:	68 c3 33 80 00       	push   $0x8033c3
  80258b:	e8 b9 02 00 00       	call   802849 <_panic>
  802590:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 0c                	je     8025b2 <free_block+0x287>
  8025a6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ae:	89 10                	mov    %edx,(%eax)
  8025b0:	eb 08                	jmp    8025ba <free_block+0x28f>
  8025b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b5:	a3 48 40 80 00       	mov    %eax,0x804048
  8025ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8025c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cb:	a1 54 40 80 00       	mov    0x804054,%eax
  8025d0:	40                   	inc    %eax
  8025d1:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8025d6:	83 ec 0c             	sub    $0xc,%esp
  8025d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025dc:	e8 88 f5 ff ff       	call   801b69 <to_page_va>
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	50                   	push   %eax
  8025e8:	e8 b8 ee ff ff       	call   8014a5 <return_page>
  8025ed:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8025f0:	90                   	nop
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 e8 34 80 00       	push   $0x8034e8
  802601:	68 11 01 00 00       	push   $0x111
  802606:	68 c3 33 80 00       	push   $0x8033c3
  80260b:	e8 39 02 00 00       	call   802849 <_panic>

00802610 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 0c 35 80 00       	push   $0x80350c
  80261e:	6a 07                	push   $0x7
  802620:	68 3b 35 80 00       	push   $0x80353b
  802625:	e8 1f 02 00 00       	call   802849 <_panic>

0080262a <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	68 4c 35 80 00       	push   $0x80354c
  802638:	6a 0b                	push   $0xb
  80263a:	68 3b 35 80 00       	push   $0x80353b
  80263f:	e8 05 02 00 00       	call   802849 <_panic>

00802644 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 78 35 80 00       	push   $0x803578
  802652:	6a 10                	push   $0x10
  802654:	68 3b 35 80 00       	push   $0x80353b
  802659:	e8 eb 01 00 00       	call   802849 <_panic>

0080265e <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 a8 35 80 00       	push   $0x8035a8
  80266c:	6a 15                	push   $0x15
  80266e:	68 3b 35 80 00       	push   $0x80353b
  802673:	e8 d1 01 00 00       	call   802849 <_panic>

00802678 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	8b 40 10             	mov    0x10(%eax),%eax
}
  802681:	5d                   	pop    %ebp
  802682:	c3                   	ret    

00802683 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802689:	8b 55 08             	mov    0x8(%ebp),%edx
  80268c:	89 d0                	mov    %edx,%eax
  80268e:	c1 e0 02             	shl    $0x2,%eax
  802691:	01 d0                	add    %edx,%eax
  802693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80269a:	01 d0                	add    %edx,%eax
  80269c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026a3:	01 d0                	add    %edx,%eax
  8026a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	c1 e0 04             	shl    $0x4,%eax
  8026b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8026b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026bb:	0f 31                	rdtsc  
  8026bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026cc:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8026cf:	eb 46                	jmp    802717 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026d1:	0f 31                	rdtsc  
  8026d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8026d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8026e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	29 c2                	sub    %eax,%edx
  8026ed:	89 d0                	mov    %edx,%eax
  8026ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8026f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	89 d1                	mov    %edx,%ecx
  8026fa:	29 c1                	sub    %eax,%ecx
  8026fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802702:	39 c2                	cmp    %eax,%edx
  802704:	0f 97 c0             	seta   %al
  802707:	0f b6 c0             	movzbl %al,%eax
  80270a:	29 c1                	sub    %eax,%ecx
  80270c:	89 c8                	mov    %ecx,%eax
  80270e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802711:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80271a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80271d:	72 b2                	jb     8026d1 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80271f:	90                   	nop
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802728:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80272f:	eb 03                	jmp    802734 <busy_wait+0x12>
  802731:	ff 45 fc             	incl   -0x4(%ebp)
  802734:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802737:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273a:	72 f5                	jb     802731 <busy_wait+0xf>
	return i;
  80273c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  802747:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80274b:	74 1c                	je     802769 <init_uspinlock+0x28>
  80274d:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  802751:	74 16                	je     802769 <init_uspinlock+0x28>
  802753:	68 d8 35 80 00       	push   $0x8035d8
  802758:	68 f7 35 80 00       	push   $0x8035f7
  80275d:	6a 10                	push   $0x10
  80275f:	68 0c 36 80 00       	push   $0x80360c
  802764:	e8 e0 00 00 00       	call   802849 <_panic>
	strcpy(lk->name, name);
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	83 c0 04             	add    $0x4,%eax
  80276f:	83 ec 08             	sub    $0x8,%esp
  802772:	ff 75 0c             	pushl  0xc(%ebp)
  802775:	50                   	push   %eax
  802776:	e8 d0 e4 ff ff       	call   800c4b <strcpy>
  80277b:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	2b 45 10             	sub    0x10(%ebp),%eax
  802786:	89 c2                	mov    %eax,%edx
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	89 10                	mov    %edx,(%eax)
}
  80278d:	90                   	nop
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  802796:	90                   	nop
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8027a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027ad:	f0 87 02             	lock xchg %eax,(%edx)
  8027b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8027b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	75 dd                	jne    802797 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	8d 48 04             	lea    0x4(%eax),%ecx
  8027c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8027c5:	8d 50 20             	lea    0x20(%eax),%edx
  8027c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8027cd:	8b 40 10             	mov    0x10(%eax),%eax
  8027d0:	51                   	push   %ecx
  8027d1:	52                   	push   %edx
  8027d2:	50                   	push   %eax
  8027d3:	68 1c 36 80 00       	push   $0x80361c
  8027d8:	e8 46 dd ff ff       	call   800523 <cprintf>
  8027dd:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8027e0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8027e5:	90                   	nop
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 18                	jne    80280f <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	83 c0 04             	add    $0x4,%eax
  8027fd:	50                   	push   %eax
  8027fe:	68 40 36 80 00       	push   $0x803640
  802803:	6a 2b                	push   $0x2b
  802805:	68 0c 36 80 00       	push   $0x80360c
  80280a:	e8 3a 00 00 00       	call   802849 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80280f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	8b 55 08             	mov    0x8(%ebp),%edx
  80281a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  802820:	8b 45 08             	mov    0x8(%ebp),%eax
  802823:	8d 48 04             	lea    0x4(%eax),%ecx
  802826:	a1 20 40 80 00       	mov    0x804020,%eax
  80282b:	8d 50 20             	lea    0x20(%eax),%edx
  80282e:	a1 20 40 80 00       	mov    0x804020,%eax
  802833:	8b 40 10             	mov    0x10(%eax),%eax
  802836:	51                   	push   %ecx
  802837:	52                   	push   %edx
  802838:	50                   	push   %eax
  802839:	68 60 36 80 00       	push   $0x803660
  80283e:	e8 e0 dc ff ff       	call   800523 <cprintf>
  802843:	83 c4 10             	add    $0x10,%esp
}
  802846:	90                   	nop
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80284f:	8d 45 10             	lea    0x10(%ebp),%eax
  802852:	83 c0 04             	add    $0x4,%eax
  802855:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802858:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 16                	je     802877 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802861:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802866:	83 ec 08             	sub    $0x8,%esp
  802869:	50                   	push   %eax
  80286a:	68 84 36 80 00       	push   $0x803684
  80286f:	e8 af dc ff ff       	call   800523 <cprintf>
  802874:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802877:	a1 04 40 80 00       	mov    0x804004,%eax
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 0c             	pushl  0xc(%ebp)
  802882:	ff 75 08             	pushl  0x8(%ebp)
  802885:	50                   	push   %eax
  802886:	68 8c 36 80 00       	push   $0x80368c
  80288b:	6a 74                	push   $0x74
  80288d:	e8 be dc ff ff       	call   800550 <cprintf_colored>
  802892:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802895:	8b 45 10             	mov    0x10(%ebp),%eax
  802898:	83 ec 08             	sub    $0x8,%esp
  80289b:	ff 75 f4             	pushl  -0xc(%ebp)
  80289e:	50                   	push   %eax
  80289f:	e8 10 dc ff ff       	call   8004b4 <vcprintf>
  8028a4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8028a7:	83 ec 08             	sub    $0x8,%esp
  8028aa:	6a 00                	push   $0x0
  8028ac:	68 b4 36 80 00       	push   $0x8036b4
  8028b1:	e8 fe db ff ff       	call   8004b4 <vcprintf>
  8028b6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8028b9:	e8 77 db ff ff       	call   800435 <exit>

	// should not return here
	while (1) ;
  8028be:	eb fe                	jmp    8028be <_panic+0x75>

008028c0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8028c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8028cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d4:	39 c2                	cmp    %eax,%edx
  8028d6:	74 14                	je     8028ec <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 b8 36 80 00       	push   $0x8036b8
  8028e0:	6a 26                	push   $0x26
  8028e2:	68 04 37 80 00       	push   $0x803704
  8028e7:	e8 5d ff ff ff       	call   802849 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8028ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8028f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028fa:	e9 c5 00 00 00       	jmp    8029c4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	75 08                	jne    80291c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802914:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802917:	e9 a5 00 00 00       	jmp    8029c1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80291c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802923:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80292a:	eb 69                	jmp    802995 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80292c:	a1 20 40 80 00       	mov    0x804020,%eax
  802931:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802937:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80293a:	89 d0                	mov    %edx,%eax
  80293c:	01 c0                	add    %eax,%eax
  80293e:	01 d0                	add    %edx,%eax
  802940:	c1 e0 03             	shl    $0x3,%eax
  802943:	01 c8                	add    %ecx,%eax
  802945:	8a 40 04             	mov    0x4(%eax),%al
  802948:	84 c0                	test   %al,%al
  80294a:	75 46                	jne    802992 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80294c:	a1 20 40 80 00       	mov    0x804020,%eax
  802951:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802957:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295a:	89 d0                	mov    %edx,%eax
  80295c:	01 c0                	add    %eax,%eax
  80295e:	01 d0                	add    %edx,%eax
  802960:	c1 e0 03             	shl    $0x3,%eax
  802963:	01 c8                	add    %ecx,%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80296a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80296d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802972:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	01 c8                	add    %ecx,%eax
  802983:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802985:	39 c2                	cmp    %eax,%edx
  802987:	75 09                	jne    802992 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802989:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802990:	eb 15                	jmp    8029a7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802992:	ff 45 e8             	incl   -0x18(%ebp)
  802995:	a1 20 40 80 00       	mov    0x804020,%eax
  80299a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a3:	39 c2                	cmp    %eax,%edx
  8029a5:	77 85                	ja     80292c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8029a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ab:	75 14                	jne    8029c1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 10 37 80 00       	push   $0x803710
  8029b5:	6a 3a                	push   $0x3a
  8029b7:	68 04 37 80 00       	push   $0x803704
  8029bc:	e8 88 fe ff ff       	call   802849 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8029c1:	ff 45 f0             	incl   -0x10(%ebp)
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029ca:	0f 8c 2f ff ff ff    	jl     8028ff <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8029d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029de:	eb 26                	jmp    802a06 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8029e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8029e5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8029eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ee:	89 d0                	mov    %edx,%eax
  8029f0:	01 c0                	add    %eax,%eax
  8029f2:	01 d0                	add    %edx,%eax
  8029f4:	c1 e0 03             	shl    $0x3,%eax
  8029f7:	01 c8                	add    %ecx,%eax
  8029f9:	8a 40 04             	mov    0x4(%eax),%al
  8029fc:	3c 01                	cmp    $0x1,%al
  8029fe:	75 03                	jne    802a03 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802a00:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a03:	ff 45 e0             	incl   -0x20(%ebp)
  802a06:	a1 20 40 80 00       	mov    0x804020,%eax
  802a0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a14:	39 c2                	cmp    %eax,%edx
  802a16:	77 c8                	ja     8029e0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a1e:	74 14                	je     802a34 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 64 37 80 00       	push   $0x803764
  802a28:	6a 44                	push   $0x44
  802a2a:	68 04 37 80 00       	push   $0x803704
  802a2f:	e8 15 fe ff ff       	call   802849 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802a34:	90                   	nop
  802a35:	c9                   	leave  
  802a36:	c3                   	ret    
  802a37:	90                   	nop

00802a38 <__udivdi3>:
  802a38:	55                   	push   %ebp
  802a39:	57                   	push   %edi
  802a3a:	56                   	push   %esi
  802a3b:	53                   	push   %ebx
  802a3c:	83 ec 1c             	sub    $0x1c,%esp
  802a3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a4f:	89 ca                	mov    %ecx,%edx
  802a51:	89 f8                	mov    %edi,%eax
  802a53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a57:	85 f6                	test   %esi,%esi
  802a59:	75 2d                	jne    802a88 <__udivdi3+0x50>
  802a5b:	39 cf                	cmp    %ecx,%edi
  802a5d:	77 65                	ja     802ac4 <__udivdi3+0x8c>
  802a5f:	89 fd                	mov    %edi,%ebp
  802a61:	85 ff                	test   %edi,%edi
  802a63:	75 0b                	jne    802a70 <__udivdi3+0x38>
  802a65:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6a:	31 d2                	xor    %edx,%edx
  802a6c:	f7 f7                	div    %edi
  802a6e:	89 c5                	mov    %eax,%ebp
  802a70:	31 d2                	xor    %edx,%edx
  802a72:	89 c8                	mov    %ecx,%eax
  802a74:	f7 f5                	div    %ebp
  802a76:	89 c1                	mov    %eax,%ecx
  802a78:	89 d8                	mov    %ebx,%eax
  802a7a:	f7 f5                	div    %ebp
  802a7c:	89 cf                	mov    %ecx,%edi
  802a7e:	89 fa                	mov    %edi,%edx
  802a80:	83 c4 1c             	add    $0x1c,%esp
  802a83:	5b                   	pop    %ebx
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    
  802a88:	39 ce                	cmp    %ecx,%esi
  802a8a:	77 28                	ja     802ab4 <__udivdi3+0x7c>
  802a8c:	0f bd fe             	bsr    %esi,%edi
  802a8f:	83 f7 1f             	xor    $0x1f,%edi
  802a92:	75 40                	jne    802ad4 <__udivdi3+0x9c>
  802a94:	39 ce                	cmp    %ecx,%esi
  802a96:	72 0a                	jb     802aa2 <__udivdi3+0x6a>
  802a98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a9c:	0f 87 9e 00 00 00    	ja     802b40 <__udivdi3+0x108>
  802aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d 76 00             	lea    0x0(%esi),%esi
  802ab4:	31 ff                	xor    %edi,%edi
  802ab6:	31 c0                	xor    %eax,%eax
  802ab8:	89 fa                	mov    %edi,%edx
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	66 90                	xchg   %ax,%ax
  802ac4:	89 d8                	mov    %ebx,%eax
  802ac6:	f7 f7                	div    %edi
  802ac8:	31 ff                	xor    %edi,%edi
  802aca:	89 fa                	mov    %edi,%edx
  802acc:	83 c4 1c             	add    $0x1c,%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ad9:	89 eb                	mov    %ebp,%ebx
  802adb:	29 fb                	sub    %edi,%ebx
  802add:	89 f9                	mov    %edi,%ecx
  802adf:	d3 e6                	shl    %cl,%esi
  802ae1:	89 c5                	mov    %eax,%ebp
  802ae3:	88 d9                	mov    %bl,%cl
  802ae5:	d3 ed                	shr    %cl,%ebp
  802ae7:	89 e9                	mov    %ebp,%ecx
  802ae9:	09 f1                	or     %esi,%ecx
  802aeb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802aef:	89 f9                	mov    %edi,%ecx
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 c5                	mov    %eax,%ebp
  802af5:	89 d6                	mov    %edx,%esi
  802af7:	88 d9                	mov    %bl,%cl
  802af9:	d3 ee                	shr    %cl,%esi
  802afb:	89 f9                	mov    %edi,%ecx
  802afd:	d3 e2                	shl    %cl,%edx
  802aff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b03:	88 d9                	mov    %bl,%cl
  802b05:	d3 e8                	shr    %cl,%eax
  802b07:	09 c2                	or     %eax,%edx
  802b09:	89 d0                	mov    %edx,%eax
  802b0b:	89 f2                	mov    %esi,%edx
  802b0d:	f7 74 24 0c          	divl   0xc(%esp)
  802b11:	89 d6                	mov    %edx,%esi
  802b13:	89 c3                	mov    %eax,%ebx
  802b15:	f7 e5                	mul    %ebp
  802b17:	39 d6                	cmp    %edx,%esi
  802b19:	72 19                	jb     802b34 <__udivdi3+0xfc>
  802b1b:	74 0b                	je     802b28 <__udivdi3+0xf0>
  802b1d:	89 d8                	mov    %ebx,%eax
  802b1f:	31 ff                	xor    %edi,%edi
  802b21:	e9 58 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b2c:	89 f9                	mov    %edi,%ecx
  802b2e:	d3 e2                	shl    %cl,%edx
  802b30:	39 c2                	cmp    %eax,%edx
  802b32:	73 e9                	jae    802b1d <__udivdi3+0xe5>
  802b34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b37:	31 ff                	xor    %edi,%edi
  802b39:	e9 40 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	31 c0                	xor    %eax,%eax
  802b42:	e9 37 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b47:	90                   	nop

00802b48 <__umoddi3>:
  802b48:	55                   	push   %ebp
  802b49:	57                   	push   %edi
  802b4a:	56                   	push   %esi
  802b4b:	53                   	push   %ebx
  802b4c:	83 ec 1c             	sub    $0x1c,%esp
  802b4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b53:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	89 fa                	mov    %edi,%edx
  802b6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b6f:	89 34 24             	mov    %esi,(%esp)
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 1a                	jne    802b90 <__umoddi3+0x48>
  802b76:	39 f7                	cmp    %esi,%edi
  802b78:	0f 86 a2 00 00 00    	jbe    802c20 <__umoddi3+0xd8>
  802b7e:	89 c8                	mov    %ecx,%eax
  802b80:	89 f2                	mov    %esi,%edx
  802b82:	f7 f7                	div    %edi
  802b84:	89 d0                	mov    %edx,%eax
  802b86:	31 d2                	xor    %edx,%edx
  802b88:	83 c4 1c             	add    $0x1c,%esp
  802b8b:	5b                   	pop    %ebx
  802b8c:	5e                   	pop    %esi
  802b8d:	5f                   	pop    %edi
  802b8e:	5d                   	pop    %ebp
  802b8f:	c3                   	ret    
  802b90:	39 f0                	cmp    %esi,%eax
  802b92:	0f 87 ac 00 00 00    	ja     802c44 <__umoddi3+0xfc>
  802b98:	0f bd e8             	bsr    %eax,%ebp
  802b9b:	83 f5 1f             	xor    $0x1f,%ebp
  802b9e:	0f 84 ac 00 00 00    	je     802c50 <__umoddi3+0x108>
  802ba4:	bf 20 00 00 00       	mov    $0x20,%edi
  802ba9:	29 ef                	sub    %ebp,%edi
  802bab:	89 fe                	mov    %edi,%esi
  802bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e0                	shl    %cl,%eax
  802bb5:	89 d7                	mov    %edx,%edi
  802bb7:	89 f1                	mov    %esi,%ecx
  802bb9:	d3 ef                	shr    %cl,%edi
  802bbb:	09 c7                	or     %eax,%edi
  802bbd:	89 e9                	mov    %ebp,%ecx
  802bbf:	d3 e2                	shl    %cl,%edx
  802bc1:	89 14 24             	mov    %edx,(%esp)
  802bc4:	89 d8                	mov    %ebx,%eax
  802bc6:	d3 e0                	shl    %cl,%eax
  802bc8:	89 c2                	mov    %eax,%edx
  802bca:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bce:	d3 e0                	shl    %cl,%eax
  802bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bd8:	89 f1                	mov    %esi,%ecx
  802bda:	d3 e8                	shr    %cl,%eax
  802bdc:	09 d0                	or     %edx,%eax
  802bde:	d3 eb                	shr    %cl,%ebx
  802be0:	89 da                	mov    %ebx,%edx
  802be2:	f7 f7                	div    %edi
  802be4:	89 d3                	mov    %edx,%ebx
  802be6:	f7 24 24             	mull   (%esp)
  802be9:	89 c6                	mov    %eax,%esi
  802beb:	89 d1                	mov    %edx,%ecx
  802bed:	39 d3                	cmp    %edx,%ebx
  802bef:	0f 82 87 00 00 00    	jb     802c7c <__umoddi3+0x134>
  802bf5:	0f 84 91 00 00 00    	je     802c8c <__umoddi3+0x144>
  802bfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bff:	29 f2                	sub    %esi,%edx
  802c01:	19 cb                	sbb    %ecx,%ebx
  802c03:	89 d8                	mov    %ebx,%eax
  802c05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c09:	d3 e0                	shl    %cl,%eax
  802c0b:	89 e9                	mov    %ebp,%ecx
  802c0d:	d3 ea                	shr    %cl,%edx
  802c0f:	09 d0                	or     %edx,%eax
  802c11:	89 e9                	mov    %ebp,%ecx
  802c13:	d3 eb                	shr    %cl,%ebx
  802c15:	89 da                	mov    %ebx,%edx
  802c17:	83 c4 1c             	add    $0x1c,%esp
  802c1a:	5b                   	pop    %ebx
  802c1b:	5e                   	pop    %esi
  802c1c:	5f                   	pop    %edi
  802c1d:	5d                   	pop    %ebp
  802c1e:	c3                   	ret    
  802c1f:	90                   	nop
  802c20:	89 fd                	mov    %edi,%ebp
  802c22:	85 ff                	test   %edi,%edi
  802c24:	75 0b                	jne    802c31 <__umoddi3+0xe9>
  802c26:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	f7 f7                	div    %edi
  802c2f:	89 c5                	mov    %eax,%ebp
  802c31:	89 f0                	mov    %esi,%eax
  802c33:	31 d2                	xor    %edx,%edx
  802c35:	f7 f5                	div    %ebp
  802c37:	89 c8                	mov    %ecx,%eax
  802c39:	f7 f5                	div    %ebp
  802c3b:	89 d0                	mov    %edx,%eax
  802c3d:	e9 44 ff ff ff       	jmp    802b86 <__umoddi3+0x3e>
  802c42:	66 90                	xchg   %ax,%ax
  802c44:	89 c8                	mov    %ecx,%eax
  802c46:	89 f2                	mov    %esi,%edx
  802c48:	83 c4 1c             	add    $0x1c,%esp
  802c4b:	5b                   	pop    %ebx
  802c4c:	5e                   	pop    %esi
  802c4d:	5f                   	pop    %edi
  802c4e:	5d                   	pop    %ebp
  802c4f:	c3                   	ret    
  802c50:	3b 04 24             	cmp    (%esp),%eax
  802c53:	72 06                	jb     802c5b <__umoddi3+0x113>
  802c55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c59:	77 0f                	ja     802c6a <__umoddi3+0x122>
  802c5b:	89 f2                	mov    %esi,%edx
  802c5d:	29 f9                	sub    %edi,%ecx
  802c5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c63:	89 14 24             	mov    %edx,(%esp)
  802c66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c6e:	8b 14 24             	mov    (%esp),%edx
  802c71:	83 c4 1c             	add    $0x1c,%esp
  802c74:	5b                   	pop    %ebx
  802c75:	5e                   	pop    %esi
  802c76:	5f                   	pop    %edi
  802c77:	5d                   	pop    %ebp
  802c78:	c3                   	ret    
  802c79:	8d 76 00             	lea    0x0(%esi),%esi
  802c7c:	2b 04 24             	sub    (%esp),%eax
  802c7f:	19 fa                	sbb    %edi,%edx
  802c81:	89 d1                	mov    %edx,%ecx
  802c83:	89 c6                	mov    %eax,%esi
  802c85:	e9 71 ff ff ff       	jmp    802bfb <__umoddi3+0xb3>
  802c8a:	66 90                	xchg   %ax,%ax
  802c8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c90:	72 ea                	jb     802c7c <__umoddi3+0x134>
  802c92:	89 d9                	mov    %ebx,%ecx
  802c94:	e9 62 ff ff ff       	jmp    802bfb <__umoddi3+0xb3>
