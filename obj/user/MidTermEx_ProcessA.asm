
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 5e 02 00 00       	call   800294 <libmain>
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
  800048:	e8 89 18 00 00       	call   8018d6 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 c0 2c 80 00       	push   $0x802cc0
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 17 15 00 00       	call   801577 <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 c2 2c 80 00       	push   $0x802cc2
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 01 15 00 00       	call   801577 <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 cb 2c 80 00       	push   $0x802ccb
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 eb 14 00 00       	call   801577 <sget>
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
  8000ab:	e8 90 25 00 00       	call   802640 <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 db 2c 80 00       	push   $0x802cdb
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 79 25 00 00       	call   802640 <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 e4 2c 80 00       	push   $0x802ce4
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 62 25 00 00       	call   802640 <get_semaphore>
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
  8000f8:	e8 7a 14 00 00       	call   801577 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 e4 2c 80 00       	push   $0x802ce4
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 64 14 00 00       	call   801577 <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800119:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	50                   	push   %eax
  800120:	e8 e4 17 00 00       	call   801909 <sys_get_virtual_time>
  800125:	83 c4 0c             	add    $0xc,%esp
  800128:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80012b:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	f7 f1                	div    %ecx
  800137:	89 d0                	mov    %edx,%eax
  800139:	05 d0 07 00 00       	add    $0x7d0,%eax
  80013e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	e8 4c 25 00 00       	call   802699 <env_sleep>
  80014d:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  800150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	01 c0                	add    %eax,%eax
  800157:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80015a:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	50                   	push   %eax
  800161:	e8 a3 17 00 00       	call   801909 <sys_get_virtual_time>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80016c:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	f7 f1                	div    %ecx
  800178:	89 d0                	mov    %edx,%eax
  80017a:	05 d0 07 00 00       	add    $0x7d0,%eax
  80017f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 0b 25 00 00       	call   802699 <env_sleep>
  80018e:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800197:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800199:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	e8 64 17 00 00       	call   801909 <sys_get_virtual_time>
  8001a5:	83 c4 0c             	add    $0xc,%esp
  8001a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ab:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b5:	f7 f1                	div    %ecx
  8001b7:	89 d0                	mov    %edx,%eax
  8001b9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 cc 24 00 00       	call   802699 <env_sleep>
  8001cd:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	if (*protType == 1)
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 f8 01             	cmp    $0x1,%eax
  8001d8:	75 10                	jne    8001ea <_main+0x1b2>
	{
		signal_semaphore(T);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8001e0:	e8 8f 24 00 00       	call   802674 <signal_semaphore>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 18                	jmp    800202 <_main+0x1ca>
	}
	else if (*protType == 2)
  8001ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	83 f8 02             	cmp    $0x2,%eax
  8001f2:	75 0e                	jne    800202 <_main+0x1ca>
	{
		release_uspinlock(sT);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fa:	e8 ff 25 00 00       	call   8027fe <release_uspinlock>
  8001ff:	83 c4 10             	add    $0x10,%esp
	}
	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	83 f8 01             	cmp    $0x1,%eax
  80020a:	75 39                	jne    800245 <_main+0x20d>
	{
		signal_semaphore(finished);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	ff 75 b8             	pushl  -0x48(%ebp)
  800212:	e8 5d 24 00 00       	call   802674 <signal_semaphore>
  800217:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 b4             	pushl  -0x4c(%ebp)
  800220:	e8 35 24 00 00       	call   80265a <wait_semaphore>
  800225:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800228:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	8d 50 01             	lea    0x1(%eax),%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023b:	e8 34 24 00 00       	call   802674 <signal_semaphore>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800243:	eb 4c                	jmp    800291 <_main+0x259>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	83 f8 02             	cmp    $0x2,%eax
  80024d:	75 2b                	jne    80027a <_main+0x242>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 f0             	pushl  -0x10(%ebp)
  800255:	e8 4c 25 00 00       	call   8027a6 <acquire_uspinlock>
  80025a:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	8d 50 01             	lea    0x1(%eax),%edx
  800265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800268:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 f0             	pushl  -0x10(%ebp)
  800270:	e8 89 25 00 00       	call   8027fe <release_uspinlock>
  800275:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800278:	eb 17                	jmp    800291 <_main+0x259>
		}
		release_uspinlock(sfinishedCountMutex);
	}
	else
	{
		sys_lock_cons();
  80027a:	e8 c5 13 00 00       	call   801644 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	8d 50 01             	lea    0x1(%eax),%edx
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028c:	e8 cd 13 00 00       	call   80165e <sys_unlock_cons>
	}


}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029d:	e8 1b 16 00 00       	call   8018bd <sys_getenvindex>
  8002a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	c1 e0 06             	shl    $0x6,%eax
  8002ad:	29 d0                	sub    %edx,%eax
  8002af:	c1 e0 02             	shl    $0x2,%eax
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bb:	01 c8                	add    %ecx,%eax
  8002bd:	c1 e0 03             	shl    $0x3,%eax
  8002c0:	01 d0                	add    %edx,%eax
  8002c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c9:	29 c2                	sub    %eax,%edx
  8002cb:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002d2:	89 c2                	mov    %eax,%edx
  8002d4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e4:	8a 40 20             	mov    0x20(%eax),%al
  8002e7:	84 c0                	test   %al,%al
  8002e9:	74 0d                	je     8002f8 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f0:	83 c0 20             	add    $0x20,%eax
  8002f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fc:	7e 0a                	jle    800308 <libmain+0x74>
		binaryname = argv[0];
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 22 fd ff ff       	call   800038 <_main>
  800316:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800319:	a1 00 40 80 00       	mov    0x804000,%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 01 01 00 00    	je     800427 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800326:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032c:	bb f0 2d 80 00       	mov    $0x802df0,%ebx
  800331:	ba 0e 00 00 00       	mov    $0xe,%edx
  800336:	89 c7                	mov    %eax,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800341:	b9 56 00 00 00       	mov    $0x56,%ecx
  800346:	b0 00                	mov    $0x0,%al
  800348:	89 d7                	mov    %edx,%edi
  80034a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800353:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	50                   	push   %eax
  80035a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	e8 8d 17 00 00       	call   801af3 <sys_utilities>
  800366:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800369:	e8 d6 12 00 00       	call   801644 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 10 2d 80 00       	push   $0x802d10
  800376:	e8 be 01 00 00       	call   800539 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	74 18                	je     80039d <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800385:	e8 87 17 00 00       	call   801b11 <sys_get_optimal_num_faults>
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	50                   	push   %eax
  80038e:	68 38 2d 80 00       	push   $0x802d38
  800393:	e8 a1 01 00 00       	call   800539 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb 59                	jmp    8003f6 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ad:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 5c 2d 80 00       	push   $0x802d5c
  8003bd:	e8 77 01 00 00       	call   800539 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ca:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d5:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	68 84 2d 80 00       	push   $0x802d84
  8003ee:	e8 46 01 00 00       	call   800539 <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	50                   	push   %eax
  800405:	68 dc 2d 80 00       	push   $0x802ddc
  80040a:	e8 2a 01 00 00       	call   800539 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	68 10 2d 80 00       	push   $0x802d10
  80041a:	e8 1a 01 00 00       	call   800539 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800422:	e8 37 12 00 00       	call   80165e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800427:	e8 1f 00 00 00       	call   80044b <exit>
}
  80042c:	90                   	nop
  80042d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	6a 00                	push   $0x0
  800440:	e8 44 14 00 00       	call   801889 <sys_destroy_env>
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <exit>:

void
exit(void)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800451:	e8 99 14 00 00       	call   8018ef <sys_exit_env>
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	53                   	push   %ebx
  80045d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 48 01             	lea    0x1(%eax),%ecx
  800468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046b:	89 0a                	mov    %ecx,(%edx)
  80046d:	8b 55 08             	mov    0x8(%ebp),%edx
  800470:	88 d1                	mov    %dl,%cl
  800472:	8b 55 0c             	mov    0xc(%ebp),%edx
  800475:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800483:	75 30                	jne    8004b5 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800485:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80048b:	a0 44 40 80 00       	mov    0x804044,%al
  800490:	0f b6 c0             	movzbl %al,%eax
  800493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800496:	8b 09                	mov    (%ecx),%ecx
  800498:	89 cb                	mov    %ecx,%ebx
  80049a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80049d:	83 c1 08             	add    $0x8,%ecx
  8004a0:	52                   	push   %edx
  8004a1:	50                   	push   %eax
  8004a2:	53                   	push   %ebx
  8004a3:	51                   	push   %ecx
  8004a4:	e8 57 11 00 00       	call   801600 <sys_cputs>
  8004a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 40 04             	mov    0x4(%eax),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c4:	90                   	nop
  8004c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004da:	00 00 00 
	b.cnt = 0;
  8004dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ea:	ff 75 08             	pushl  0x8(%ebp)
  8004ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f3:	50                   	push   %eax
  8004f4:	68 59 04 80 00       	push   $0x800459
  8004f9:	e8 5a 02 00 00       	call   800758 <vprintfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800501:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800507:	a0 44 40 80 00       	mov    0x804044,%al
  80050c:	0f b6 c0             	movzbl %al,%eax
  80050f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800515:	52                   	push   %edx
  800516:	50                   	push   %eax
  800517:	51                   	push   %ecx
  800518:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051e:	83 c0 08             	add    $0x8,%eax
  800521:	50                   	push   %eax
  800522:	e8 d9 10 00 00       	call   801600 <sys_cputs>
  800527:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052a:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800531:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800546:	8d 45 0c             	lea    0xc(%ebp),%eax
  800549:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 f4             	pushl  -0xc(%ebp)
  800555:	50                   	push   %eax
  800556:	e8 6f ff ff ff       	call   8004ca <vcprintf>
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	c1 e0 08             	shl    $0x8,%eax
  800579:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	83 c0 04             	add    $0x4,%eax
  800584:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	ff 75 f4             	pushl  -0xc(%ebp)
  800590:	50                   	push   %eax
  800591:	e8 34 ff ff ff       	call   8004ca <vcprintf>
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80059c:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8005a3:	07 00 00 

	return cnt;
  8005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005b1:	e8 8e 10 00 00       	call   801644 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	50                   	push   %eax
  8005c6:	e8 ff fe ff ff       	call   8004ca <vcprintf>
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005d1:	e8 88 10 00 00       	call   80165e <sys_unlock_cons>
	return cnt;
  8005d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d9:	c9                   	leave  
  8005da:	c3                   	ret    

008005db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	53                   	push   %ebx
  8005df:	83 ec 14             	sub    $0x14,%esp
  8005e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f9:	77 55                	ja     800650 <printnum+0x75>
  8005fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fe:	72 05                	jb     800605 <printnum+0x2a>
  800600:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800603:	77 4b                	ja     800650 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800605:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800608:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060b:	8b 45 18             	mov    0x18(%ebp),%eax
  80060e:	ba 00 00 00 00       	mov    $0x0,%edx
  800613:	52                   	push   %edx
  800614:	50                   	push   %eax
  800615:	ff 75 f4             	pushl  -0xc(%ebp)
  800618:	ff 75 f0             	pushl  -0x10(%ebp)
  80061b:	e8 30 24 00 00       	call   802a50 <__udivdi3>
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	83 ec 04             	sub    $0x4,%esp
  800626:	ff 75 20             	pushl  0x20(%ebp)
  800629:	53                   	push   %ebx
  80062a:	ff 75 18             	pushl  0x18(%ebp)
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	ff 75 08             	pushl  0x8(%ebp)
  800635:	e8 a1 ff ff ff       	call   8005db <printnum>
  80063a:	83 c4 20             	add    $0x20,%esp
  80063d:	eb 1a                	jmp    800659 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	ff 75 0c             	pushl  0xc(%ebp)
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800650:	ff 4d 1c             	decl   0x1c(%ebp)
  800653:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800657:	7f e6                	jg     80063f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800659:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80065c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800667:	53                   	push   %ebx
  800668:	51                   	push   %ecx
  800669:	52                   	push   %edx
  80066a:	50                   	push   %eax
  80066b:	e8 f0 24 00 00       	call   802b60 <__umoddi3>
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	05 74 30 80 00       	add    $0x803074,%eax
  800678:	8a 00                	mov    (%eax),%al
  80067a:	0f be c0             	movsbl %al,%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	50                   	push   %eax
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
}
  80068c:	90                   	nop
  80068d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800690:	c9                   	leave  
  800691:	c3                   	ret    

00800692 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800695:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800699:	7e 1c                	jle    8006b7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	8d 50 08             	lea    0x8(%eax),%edx
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	89 10                	mov    %edx,(%eax)
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	83 e8 08             	sub    $0x8,%eax
  8006b0:	8b 50 04             	mov    0x4(%eax),%edx
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	eb 40                	jmp    8006f7 <getuint+0x65>
	else if (lflag)
  8006b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bb:	74 1e                	je     8006db <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	8d 50 04             	lea    0x4(%eax),%edx
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	89 10                	mov    %edx,(%eax)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	83 e8 04             	sub    $0x4,%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	eb 1c                	jmp    8006f7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	8d 50 04             	lea    0x4(%eax),%edx
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	89 10                	mov    %edx,(%eax)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006f7:	5d                   	pop    %ebp
  8006f8:	c3                   	ret    

008006f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800700:	7e 1c                	jle    80071e <getint+0x25>
		return va_arg(*ap, long long);
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	8d 50 08             	lea    0x8(%eax),%edx
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	89 10                	mov    %edx,(%eax)
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	83 e8 08             	sub    $0x8,%eax
  800717:	8b 50 04             	mov    0x4(%eax),%edx
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	eb 38                	jmp    800756 <getint+0x5d>
	else if (lflag)
  80071e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800722:	74 1a                	je     80073e <getint+0x45>
		return va_arg(*ap, long);
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	8d 50 04             	lea    0x4(%eax),%edx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 10                	mov    %edx,(%eax)
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	83 e8 04             	sub    $0x4,%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	99                   	cltd   
  80073c:	eb 18                	jmp    800756 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	8d 50 04             	lea    0x4(%eax),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	89 10                	mov    %edx,(%eax)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	99                   	cltd   
}
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800760:	eb 17                	jmp    800779 <vprintfmt+0x21>
			if (ch == '\0')
  800762:	85 db                	test   %ebx,%ebx
  800764:	0f 84 c1 03 00 00    	je     800b2b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	53                   	push   %ebx
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	ff d0                	call   *%eax
  800776:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800779:	8b 45 10             	mov    0x10(%ebp),%eax
  80077c:	8d 50 01             	lea    0x1(%eax),%edx
  80077f:	89 55 10             	mov    %edx,0x10(%ebp)
  800782:	8a 00                	mov    (%eax),%al
  800784:	0f b6 d8             	movzbl %al,%ebx
  800787:	83 fb 25             	cmp    $0x25,%ebx
  80078a:	75 d6                	jne    800762 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80078c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800790:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800797:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80079e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8007af:	8d 50 01             	lea    0x1(%eax),%edx
  8007b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f b6 d8             	movzbl %al,%ebx
  8007ba:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007bd:	83 f8 5b             	cmp    $0x5b,%eax
  8007c0:	0f 87 3d 03 00 00    	ja     800b03 <vprintfmt+0x3ab>
  8007c6:	8b 04 85 98 30 80 00 	mov    0x803098(,%eax,4),%eax
  8007cd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007cf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d3:	eb d7                	jmp    8007ac <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d9:	eb d1                	jmp    8007ac <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e5:	89 d0                	mov    %edx,%eax
  8007e7:	c1 e0 02             	shl    $0x2,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d8                	add    %ebx,%eax
  8007f0:	83 e8 30             	sub    $0x30,%eax
  8007f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	8a 00                	mov    (%eax),%al
  8007fb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007fe:	83 fb 2f             	cmp    $0x2f,%ebx
  800801:	7e 3e                	jle    800841 <vprintfmt+0xe9>
  800803:	83 fb 39             	cmp    $0x39,%ebx
  800806:	7f 39                	jg     800841 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800808:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080b:	eb d5                	jmp    8007e2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800821:	eb 1f                	jmp    800842 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800823:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800827:	79 83                	jns    8007ac <vprintfmt+0x54>
				width = 0;
  800829:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800830:	e9 77 ff ff ff       	jmp    8007ac <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800835:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80083c:	e9 6b ff ff ff       	jmp    8007ac <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800841:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	0f 89 60 ff ff ff    	jns    8007ac <vprintfmt+0x54>
				width = precision, precision = -1;
  80084c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80084f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800852:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800859:	e9 4e ff ff ff       	jmp    8007ac <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80085e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800861:	e9 46 ff ff ff       	jmp    8007ac <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	83 c0 04             	add    $0x4,%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	83 e8 04             	sub    $0x4,%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	50                   	push   %eax
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	ff d0                	call   *%eax
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 9b 02 00 00       	jmp    800b26 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80089c:	85 db                	test   %ebx,%ebx
  80089e:	79 02                	jns    8008a2 <vprintfmt+0x14a>
				err = -err;
  8008a0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a2:	83 fb 64             	cmp    $0x64,%ebx
  8008a5:	7f 0b                	jg     8008b2 <vprintfmt+0x15a>
  8008a7:	8b 34 9d e0 2e 80 00 	mov    0x802ee0(,%ebx,4),%esi
  8008ae:	85 f6                	test   %esi,%esi
  8008b0:	75 19                	jne    8008cb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b2:	53                   	push   %ebx
  8008b3:	68 85 30 80 00       	push   $0x803085
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	ff 75 08             	pushl  0x8(%ebp)
  8008be:	e8 70 02 00 00       	call   800b33 <printfmt>
  8008c3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c6:	e9 5b 02 00 00       	jmp    800b26 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cb:	56                   	push   %esi
  8008cc:	68 8e 30 80 00       	push   $0x80308e
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	ff 75 08             	pushl  0x8(%ebp)
  8008d7:	e8 57 02 00 00       	call   800b33 <printfmt>
  8008dc:	83 c4 10             	add    $0x10,%esp
			break;
  8008df:	e9 42 02 00 00       	jmp    800b26 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 c0 04             	add    $0x4,%eax
  8008ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 30                	mov    (%eax),%esi
  8008f5:	85 f6                	test   %esi,%esi
  8008f7:	75 05                	jne    8008fe <vprintfmt+0x1a6>
				p = "(null)";
  8008f9:	be 91 30 80 00       	mov    $0x803091,%esi
			if (width > 0 && padc != '-')
  8008fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800902:	7e 6d                	jle    800971 <vprintfmt+0x219>
  800904:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800908:	74 67                	je     800971 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	50                   	push   %eax
  800911:	56                   	push   %esi
  800912:	e8 1e 03 00 00       	call   800c35 <strnlen>
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80091d:	eb 16                	jmp    800935 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80091f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	50                   	push   %eax
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800932:	ff 4d e4             	decl   -0x1c(%ebp)
  800935:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800939:	7f e4                	jg     80091f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093b:	eb 34                	jmp    800971 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80093d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800941:	74 1c                	je     80095f <vprintfmt+0x207>
  800943:	83 fb 1f             	cmp    $0x1f,%ebx
  800946:	7e 05                	jle    80094d <vprintfmt+0x1f5>
  800948:	83 fb 7e             	cmp    $0x7e,%ebx
  80094b:	7e 12                	jle    80095f <vprintfmt+0x207>
					putch('?', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 3f                	push   $0x3f
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	eb 0f                	jmp    80096e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	53                   	push   %ebx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	ff d0                	call   *%eax
  80096b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096e:	ff 4d e4             	decl   -0x1c(%ebp)
  800971:	89 f0                	mov    %esi,%eax
  800973:	8d 70 01             	lea    0x1(%eax),%esi
  800976:	8a 00                	mov    (%eax),%al
  800978:	0f be d8             	movsbl %al,%ebx
  80097b:	85 db                	test   %ebx,%ebx
  80097d:	74 24                	je     8009a3 <vprintfmt+0x24b>
  80097f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800983:	78 b8                	js     80093d <vprintfmt+0x1e5>
  800985:	ff 4d e0             	decl   -0x20(%ebp)
  800988:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098c:	79 af                	jns    80093d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098e:	eb 13                	jmp    8009a3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	6a 20                	push   $0x20
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a7:	7f e7                	jg     800990 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a9:	e9 78 01 00 00       	jmp    800b26 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	e8 3c fd ff ff       	call   8006f9 <getint>
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009cc:	85 d2                	test   %edx,%edx
  8009ce:	79 23                	jns    8009f3 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 2d                	push   $0x2d
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e6:	f7 d8                	neg    %eax
  8009e8:	83 d2 00             	adc    $0x0,%edx
  8009eb:	f7 da                	neg    %edx
  8009ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 e8             	pushl  -0x18(%ebp)
  800a05:	8d 45 14             	lea    0x14(%ebp),%eax
  800a08:	50                   	push   %eax
  800a09:	e8 84 fc ff ff       	call   800692 <getuint>
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a17:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a1e:	e9 98 00 00 00       	jmp    800abb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 58                	push   $0x58
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 58                	push   $0x58
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 58                	push   $0x58
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			break;
  800a53:	e9 ce 00 00 00       	jmp    800b26 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	6a 30                	push   $0x30
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 78                	push   $0x78
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	83 c0 04             	add    $0x4,%eax
  800a7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 e8 04             	sub    $0x4,%eax
  800a87:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a93:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9a:	eb 1f                	jmp    800abb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa2:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa5:	50                   	push   %eax
  800aa6:	e8 e7 fb ff ff       	call   800692 <getuint>
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac2:	83 ec 04             	sub    $0x4,%esp
  800ac5:	52                   	push   %edx
  800ac6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	ff 75 f4             	pushl  -0xc(%ebp)
  800acd:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 00 fb ff ff       	call   8005db <printnum>
  800adb:	83 c4 20             	add    $0x20,%esp
			break;
  800ade:	eb 46                	jmp    800b26 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	53                   	push   %ebx
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	ff d0                	call   *%eax
  800aec:	83 c4 10             	add    $0x10,%esp
			break;
  800aef:	eb 35                	jmp    800b26 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800af1:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800af8:	eb 2c                	jmp    800b26 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800afa:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800b01:	eb 23                	jmp    800b26 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	6a 25                	push   $0x25
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	eb 03                	jmp    800b1b <vprintfmt+0x3c3>
  800b18:	ff 4d 10             	decl   0x10(%ebp)
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1e:	48                   	dec    %eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	3c 25                	cmp    $0x25,%al
  800b23:	75 f3                	jne    800b18 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b25:	90                   	nop
		}
	}
  800b26:	e9 35 fc ff ff       	jmp    800760 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b2b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b39:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3c:	83 c0 04             	add    $0x4,%eax
  800b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	ff 75 f4             	pushl  -0xc(%ebp)
  800b48:	50                   	push   %eax
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	ff 75 08             	pushl  0x8(%ebp)
  800b4f:	e8 04 fc ff ff       	call   800758 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b57:	90                   	nop
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8b 40 08             	mov    0x8(%eax),%eax
  800b63:	8d 50 01             	lea    0x1(%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8b 10                	mov    (%eax),%edx
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8b 40 04             	mov    0x4(%eax),%eax
  800b77:	39 c2                	cmp    %eax,%edx
  800b79:	73 12                	jae    800b8d <sprintputch+0x33>
		*b->buf++ = ch;
  800b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7e:	8b 00                	mov    (%eax),%eax
  800b80:	8d 48 01             	lea    0x1(%eax),%ecx
  800b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b86:	89 0a                	mov    %ecx,(%edx)
  800b88:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8b:	88 10                	mov    %dl,(%eax)
}
  800b8d:	90                   	nop
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	01 d0                	add    %edx,%eax
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb5:	74 06                	je     800bbd <vsnprintf+0x2d>
  800bb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbb:	7f 07                	jg     800bc4 <vsnprintf+0x34>
		return -E_INVAL;
  800bbd:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc2:	eb 20                	jmp    800be4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc4:	ff 75 14             	pushl  0x14(%ebp)
  800bc7:	ff 75 10             	pushl  0x10(%ebp)
  800bca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bcd:	50                   	push   %eax
  800bce:	68 5a 0b 80 00       	push   $0x800b5a
  800bd3:	e8 80 fb ff ff       	call   800758 <vprintfmt>
  800bd8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bde:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bec:	8d 45 10             	lea    0x10(%ebp),%eax
  800bef:	83 c0 04             	add    $0x4,%eax
  800bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	ff 75 08             	pushl  0x8(%ebp)
  800c02:	e8 89 ff ff ff       	call   800b90 <vsnprintf>
  800c07:	83 c4 10             	add    $0x10,%esp
  800c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1f:	eb 06                	jmp    800c27 <strlen+0x15>
		n++;
  800c21:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c24:	ff 45 08             	incl   0x8(%ebp)
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 f1                	jne    800c21 <strlen+0xf>
		n++;
	return n;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c42:	eb 09                	jmp    800c4d <strnlen+0x18>
		n++;
  800c44:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c47:	ff 45 08             	incl   0x8(%ebp)
  800c4a:	ff 4d 0c             	decl   0xc(%ebp)
  800c4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c51:	74 09                	je     800c5c <strnlen+0x27>
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	84 c0                	test   %al,%al
  800c5a:	75 e8                	jne    800c44 <strnlen+0xf>
		n++;
	return n;
  800c5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c6d:	90                   	nop
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 08             	mov    %edx,0x8(%ebp)
  800c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c80:	8a 12                	mov    (%edx),%dl
  800c82:	88 10                	mov    %dl,(%eax)
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	84 c0                	test   %al,%al
  800c88:	75 e4                	jne    800c6e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca2:	eb 1f                	jmp    800cc3 <strncpy+0x34>
		*dst++ = *src;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8d 50 01             	lea    0x1(%eax),%edx
  800caa:	89 55 08             	mov    %edx,0x8(%ebp)
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	8a 12                	mov    (%edx),%dl
  800cb2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	74 03                	je     800cc0 <strncpy+0x31>
			src++;
  800cbd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cc0:	ff 45 fc             	incl   -0x4(%ebp)
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc9:	72 d9                	jb     800ca4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ccb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce0:	74 30                	je     800d12 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ce2:	eb 16                	jmp    800cfa <strlcpy+0x2a>
			*dst++ = *src++;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8d 50 01             	lea    0x1(%eax),%edx
  800cea:	89 55 08             	mov    %edx,0x8(%ebp)
  800ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf6:	8a 12                	mov    (%edx),%dl
  800cf8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cfa:	ff 4d 10             	decl   0x10(%ebp)
  800cfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d01:	74 09                	je     800d0c <strlcpy+0x3c>
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	75 d8                	jne    800ce4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d18:	29 c2                	sub    %eax,%edx
  800d1a:	89 d0                	mov    %edx,%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d21:	eb 06                	jmp    800d29 <strcmp+0xb>
		p++, q++;
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	84 c0                	test   %al,%al
  800d30:	74 0e                	je     800d40 <strcmp+0x22>
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 10                	mov    (%eax),%dl
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	38 c2                	cmp    %al,%dl
  800d3e:	74 e3                	je     800d23 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	0f b6 d0             	movzbl %al,%edx
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	0f b6 c0             	movzbl %al,%eax
  800d50:	29 c2                	sub    %eax,%edx
  800d52:	89 d0                	mov    %edx,%eax
}
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d59:	eb 09                	jmp    800d64 <strncmp+0xe>
		n--, p++, q++;
  800d5b:	ff 4d 10             	decl   0x10(%ebp)
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d68:	74 17                	je     800d81 <strncmp+0x2b>
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	74 0e                	je     800d81 <strncmp+0x2b>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 10                	mov    (%eax),%dl
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	38 c2                	cmp    %al,%dl
  800d7f:	74 da                	je     800d5b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d85:	75 07                	jne    800d8e <strncmp+0x38>
		return 0;
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8c:	eb 14                	jmp    800da2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	0f b6 d0             	movzbl %al,%edx
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	0f b6 c0             	movzbl %al,%eax
  800d9e:	29 c2                	sub    %eax,%edx
  800da0:	89 d0                	mov    %edx,%eax
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db0:	eb 12                	jmp    800dc4 <strchr+0x20>
		if (*s == c)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dba:	75 05                	jne    800dc1 <strchr+0x1d>
			return (char *) s;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	eb 11                	jmp    800dd2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dc1:	ff 45 08             	incl   0x8(%ebp)
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 e5                	jne    800db2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de0:	eb 0d                	jmp    800def <strfind+0x1b>
		if (*s == c)
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dea:	74 0e                	je     800dfa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	84 c0                	test   %al,%al
  800df6:	75 ea                	jne    800de2 <strfind+0xe>
  800df8:	eb 01                	jmp    800dfb <strfind+0x27>
		if (*s == c)
			break;
  800dfa:	90                   	nop
	return (char *) s;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e10:	76 63                	jbe    800e75 <memset+0x75>
		uint64 data_block = c;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	99                   	cltd   
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e22:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e26:	c1 e0 08             	shl    $0x8,%eax
  800e29:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e35:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e39:	c1 e0 10             	shl    $0x10,%eax
  800e3c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e48:	89 c2                	mov    %eax,%edx
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e52:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e55:	eb 18                	jmp    800e6f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e57:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e5a:	8d 41 08             	lea    0x8(%ecx),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e66:	89 01                	mov    %eax,(%ecx)
  800e68:	89 51 04             	mov    %edx,0x4(%ecx)
  800e6b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e6f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e73:	77 e2                	ja     800e57 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e79:	74 23                	je     800e9e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e81:	eb 0e                	jmp    800e91 <memset+0x91>
			*p8++ = (uint8)c;
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e97:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	75 e5                	jne    800e83 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eb5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb9:	76 24                	jbe    800edf <memcpy+0x3c>
		while(n >= 8){
  800ebb:	eb 1c                	jmp    800ed9 <memcpy+0x36>
			*d64 = *s64;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8b 50 04             	mov    0x4(%eax),%edx
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ec8:	89 01                	mov    %eax,(%ecx)
  800eca:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ecd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ed1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ed5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ed9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edd:	77 de                	ja     800ebd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	74 31                	je     800f16 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ef1:	eb 16                	jmp    800f09 <memcpy+0x66>
			*d8++ = *s8++;
  800ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef6:	8d 50 01             	lea    0x1(%eax),%edx
  800ef9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f02:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f05:	8a 12                	mov    (%edx),%dl
  800f07:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 dd                	jne    800ef3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	73 50                	jae    800f85 <memmove+0x6a>
  800f35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f40:	76 43                	jbe    800f85 <memmove+0x6a>
		s += n;
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f4e:	eb 10                	jmp    800f60 <memmove+0x45>
			*--d = *--s;
  800f50:	ff 4d f8             	decl   -0x8(%ebp)
  800f53:	ff 4d fc             	decl   -0x4(%ebp)
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	8a 10                	mov    (%eax),%dl
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 e3                	jne    800f50 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f6d:	eb 23                	jmp    800f92 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f72:	8d 50 01             	lea    0x1(%eax),%edx
  800f75:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f81:	8a 12                	mov    (%edx),%dl
  800f83:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 dd                	jne    800f6f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fa9:	eb 2a                	jmp    800fd5 <memcmp+0x3e>
		if (*s1 != *s2)
  800fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fae:	8a 10                	mov    (%eax),%dl
  800fb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	38 c2                	cmp    %al,%dl
  800fb7:	74 16                	je     800fcf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f b6 d0             	movzbl %al,%edx
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f b6 c0             	movzbl %al,%eax
  800fc9:	29 c2                	sub    %eax,%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	eb 18                	jmp    800fe7 <memcmp+0x50>
		s1++, s2++;
  800fcf:	ff 45 fc             	incl   -0x4(%ebp)
  800fd2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	75 c9                	jne    800fab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	01 d0                	add    %edx,%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ffa:	eb 15                	jmp    801011 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	0f b6 c0             	movzbl %al,%eax
  80100a:	39 c2                	cmp    %eax,%edx
  80100c:	74 0d                	je     80101b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801017:	72 e3                	jb     800ffc <memfind+0x13>
  801019:	eb 01                	jmp    80101c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80101b:	90                   	nop
	return (void *) s;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801027:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80102e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801035:	eb 03                	jmp    80103a <strtol+0x19>
		s++;
  801037:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 20                	cmp    $0x20,%al
  801041:	74 f4                	je     801037 <strtol+0x16>
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	3c 09                	cmp    $0x9,%al
  80104a:	74 eb                	je     801037 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 2b                	cmp    $0x2b,%al
  801053:	75 05                	jne    80105a <strtol+0x39>
		s++;
  801055:	ff 45 08             	incl   0x8(%ebp)
  801058:	eb 13                	jmp    80106d <strtol+0x4c>
	else if (*s == '-')
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	3c 2d                	cmp    $0x2d,%al
  801061:	75 0a                	jne    80106d <strtol+0x4c>
		s++, neg = 1;
  801063:	ff 45 08             	incl   0x8(%ebp)
  801066:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801071:	74 06                	je     801079 <strtol+0x58>
  801073:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801077:	75 20                	jne    801099 <strtol+0x78>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 30                	cmp    $0x30,%al
  801080:	75 17                	jne    801099 <strtol+0x78>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	40                   	inc    %eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 78                	cmp    $0x78,%al
  80108a:	75 0d                	jne    801099 <strtol+0x78>
		s += 2, base = 16;
  80108c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801090:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801097:	eb 28                	jmp    8010c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801099:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109d:	75 15                	jne    8010b4 <strtol+0x93>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 30                	cmp    $0x30,%al
  8010a6:	75 0c                	jne    8010b4 <strtol+0x93>
		s++, base = 8;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
  8010ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b2:	eb 0d                	jmp    8010c1 <strtol+0xa0>
	else if (base == 0)
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	75 07                	jne    8010c1 <strtol+0xa0>
		base = 10;
  8010ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 2f                	cmp    $0x2f,%al
  8010c8:	7e 19                	jle    8010e3 <strtol+0xc2>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 39                	cmp    $0x39,%al
  8010d1:	7f 10                	jg     8010e3 <strtol+0xc2>
			dig = *s - '0';
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 e8 30             	sub    $0x30,%eax
  8010de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e1:	eb 42                	jmp    801125 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 60                	cmp    $0x60,%al
  8010ea:	7e 19                	jle    801105 <strtol+0xe4>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 7a                	cmp    $0x7a,%al
  8010f3:	7f 10                	jg     801105 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	0f be c0             	movsbl %al,%eax
  8010fd:	83 e8 57             	sub    $0x57,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801103:	eb 20                	jmp    801125 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 40                	cmp    $0x40,%al
  80110c:	7e 39                	jle    801147 <strtol+0x126>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 5a                	cmp    $0x5a,%al
  801115:	7f 30                	jg     801147 <strtol+0x126>
			dig = *s - 'A' + 10;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 37             	sub    $0x37,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801128:	3b 45 10             	cmp    0x10(%ebp),%eax
  80112b:	7d 19                	jge    801146 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80112d:	ff 45 08             	incl   0x8(%ebp)
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	0f af 45 10          	imul   0x10(%ebp),%eax
  801137:	89 c2                	mov    %eax,%edx
  801139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801141:	e9 7b ff ff ff       	jmp    8010c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801146:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801147:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114b:	74 08                	je     801155 <strtol+0x134>
		*endptr = (char *) s;
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801159:	74 07                	je     801162 <strtol+0x141>
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115e:	f7 d8                	neg    %eax
  801160:	eb 03                	jmp    801165 <strtol+0x144>
  801162:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <ltostr>:

void
ltostr(long value, char *str)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801174:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80117b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117f:	79 13                	jns    801194 <ltostr+0x2d>
	{
		neg = 1;
  801181:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80118e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801191:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80119c:	99                   	cltd   
  80119d:	f7 f9                	idiv   %ecx
  80119f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b5:	83 c2 30             	add    $0x30,%edx
  8011b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c2:	f7 e9                	imul   %ecx
  8011c4:	c1 fa 02             	sar    $0x2,%edx
  8011c7:	89 c8                	mov    %ecx,%eax
  8011c9:	c1 f8 1f             	sar    $0x1f,%eax
  8011cc:	29 c2                	sub    %eax,%edx
  8011ce:	89 d0                	mov    %edx,%eax
  8011d0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d7:	75 bb                	jne    801194 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e3:	48                   	dec    %eax
  8011e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011eb:	74 3d                	je     80122a <ltostr+0xc3>
		start = 1 ;
  8011ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f4:	eb 34                	jmp    80122a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	01 c2                	add    %eax,%edx
  80120b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	01 c8                	add    %ecx,%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801217:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801222:	88 02                	mov    %al,(%edx)
		start++ ;
  801224:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801227:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801230:	7c c4                	jl     8011f6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801232:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	01 d0                	add    %edx,%eax
  80123a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123d:	90                   	nop
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	e8 c4 f9 ff ff       	call   800c12 <strlen>
  80124e:	83 c4 04             	add    $0x4,%esp
  801251:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801254:	ff 75 0c             	pushl  0xc(%ebp)
  801257:	e8 b6 f9 ff ff       	call   800c12 <strlen>
  80125c:	83 c4 04             	add    $0x4,%esp
  80125f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801270:	eb 17                	jmp    801289 <strcconcat+0x49>
		final[s] = str1[s] ;
  801272:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801286:	ff 45 fc             	incl   -0x4(%ebp)
  801289:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128f:	7c e1                	jl     801272 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801291:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801298:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129f:	eb 1f                	jmp    8012c0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a4:	8d 50 01             	lea    0x1(%eax),%edx
  8012a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012aa:	89 c2                	mov    %eax,%edx
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	01 c2                	add    %eax,%edx
  8012b1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 c8                	add    %ecx,%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bd:	ff 45 f8             	incl   -0x8(%ebp)
  8012c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c6:	7c d9                	jl     8012a1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d3:	90                   	nop
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 d0                	add    %edx,%eax
  8012f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f9:	eb 0c                	jmp    801307 <strsplit+0x31>
			*string++ = 0;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	84 c0                	test   %al,%al
  80130e:	74 18                	je     801328 <strsplit+0x52>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	0f be c0             	movsbl %al,%eax
  801318:	50                   	push   %eax
  801319:	ff 75 0c             	pushl  0xc(%ebp)
  80131c:	e8 83 fa ff ff       	call   800da4 <strchr>
  801321:	83 c4 08             	add    $0x8,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	75 d3                	jne    8012fb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	84 c0                	test   %al,%al
  80132f:	74 5a                	je     80138b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	83 f8 0f             	cmp    $0xf,%eax
  801339:	75 07                	jne    801342 <strsplit+0x6c>
		{
			return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
  801340:	eb 66                	jmp    8013a8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	8d 48 01             	lea    0x1(%eax),%ecx
  80134a:	8b 55 14             	mov    0x14(%ebp),%edx
  80134d:	89 0a                	mov    %ecx,(%edx)
  80134f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	01 c2                	add    %eax,%edx
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801360:	eb 03                	jmp    801365 <strsplit+0x8f>
			string++;
  801362:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	84 c0                	test   %al,%al
  80136c:	74 8b                	je     8012f9 <strsplit+0x23>
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	0f be c0             	movsbl %al,%eax
  801376:	50                   	push   %eax
  801377:	ff 75 0c             	pushl  0xc(%ebp)
  80137a:	e8 25 fa ff ff       	call   800da4 <strchr>
  80137f:	83 c4 08             	add    $0x8,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	74 dc                	je     801362 <strsplit+0x8c>
			string++;
	}
  801386:	e9 6e ff ff ff       	jmp    8012f9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138c:	8b 45 14             	mov    0x14(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 d0                	add    %edx,%eax
  80139d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bd:	eb 4a                	jmp    801409 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	01 c2                	add    %eax,%edx
  8013c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	01 c8                	add    %ecx,%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d9:	01 d0                	add    %edx,%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	3c 40                	cmp    $0x40,%al
  8013df:	7e 25                	jle    801406 <str2lower+0x5c>
  8013e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	3c 5a                	cmp    $0x5a,%al
  8013ed:	7f 17                	jg     801406 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fd:	01 ca                	add    %ecx,%edx
  8013ff:	8a 12                	mov    (%edx),%dl
  801401:	83 c2 20             	add    $0x20,%edx
  801404:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801406:	ff 45 fc             	incl   -0x4(%ebp)
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	e8 01 f8 ff ff       	call   800c12 <strlen>
  801411:	83 c4 04             	add    $0x4,%esp
  801414:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801417:	7f a6                	jg     8013bf <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801419:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801424:	a1 08 40 80 00       	mov    0x804008,%eax
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 42                	je     80146f <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	68 00 00 00 82       	push   $0x82000000
  801435:	68 00 00 00 80       	push   $0x80000000
  80143a:	e8 00 08 00 00       	call   801c3f <initialize_dynamic_allocator>
  80143f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801442:	e8 e7 05 00 00       	call   801a2e <sys_get_uheap_strategy>
  801447:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80144c:	a1 40 40 80 00       	mov    0x804040,%eax
  801451:	05 00 10 00 00       	add    $0x1000,%eax
  801456:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80145b:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801460:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801465:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80146c:	00 00 00 
	}
}
  80146f:	90                   	nop
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	68 06 04 00 00       	push   $0x406
  80148e:	50                   	push   %eax
  80148f:	e8 e4 01 00 00       	call   801678 <__sys_allocate_page>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80149a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80149e:	79 14                	jns    8014b4 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	68 08 32 80 00       	push   $0x803208
  8014a8:	6a 1f                	push   $0x1f
  8014aa:	68 44 32 80 00       	push   $0x803244
  8014af:	e8 ab 13 00 00       	call   80285f <_panic>
	return 0;
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 e7 01 00 00       	call   8016bf <__sys_unmap_frame>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014e2:	79 14                	jns    8014f8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	68 50 32 80 00       	push   $0x803250
  8014ec:	6a 2a                	push   $0x2a
  8014ee:	68 44 32 80 00       	push   $0x803244
  8014f3:	e8 67 13 00 00       	call   80285f <_panic>
}
  8014f8:	90                   	nop
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801501:	e8 18 ff ff ff       	call   80141e <uheap_init>
	if (size == 0) return NULL ;
  801506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150a:	75 07                	jne    801513 <malloc+0x18>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	eb 14                	jmp    801527 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	68 90 32 80 00       	push   $0x803290
  80151b:	6a 3e                	push   $0x3e
  80151d:	68 44 32 80 00       	push   $0x803244
  801522:	e8 38 13 00 00       	call   80285f <_panic>
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	68 b8 32 80 00       	push   $0x8032b8
  801537:	6a 49                	push   $0x49
  801539:	68 44 32 80 00       	push   $0x803244
  80153e:	e8 1c 13 00 00       	call   80285f <_panic>

00801543 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 18             	sub    $0x18,%esp
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80154f:	e8 ca fe ff ff       	call   80141e <uheap_init>
	if (size == 0) return NULL ;
  801554:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801558:	75 07                	jne    801561 <smalloc+0x1e>
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 14                	jmp    801575 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 dc 32 80 00       	push   $0x8032dc
  801569:	6a 5a                	push   $0x5a
  80156b:	68 44 32 80 00       	push   $0x803244
  801570:	e8 ea 12 00 00       	call   80285f <_panic>
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80157d:	e8 9c fe ff ff       	call   80141e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 04 33 80 00       	push   $0x803304
  80158a:	6a 6a                	push   $0x6a
  80158c:	68 44 32 80 00       	push   $0x803244
  801591:	e8 c9 12 00 00       	call   80285f <_panic>

00801596 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80159c:	e8 7d fe ff ff       	call   80141e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 28 33 80 00       	push   $0x803328
  8015a9:	68 88 00 00 00       	push   $0x88
  8015ae:	68 44 32 80 00       	push   $0x803244
  8015b3:	e8 a7 12 00 00       	call   80285f <_panic>

008015b8 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 50 33 80 00       	push   $0x803350
  8015c6:	68 9b 00 00 00       	push   $0x9b
  8015cb:	68 44 32 80 00       	push   $0x803244
  8015d0:	e8 8a 12 00 00       	call   80285f <_panic>

008015d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	57                   	push   %edi
  8015d9:	56                   	push   %esi
  8015da:	53                   	push   %ebx
  8015db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015f0:	cd 30                	int    $0x30
  8015f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5f                   	pop    %edi
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	8b 45 10             	mov    0x10(%ebp),%eax
  801609:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80160c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80160f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	51                   	push   %ecx
  801619:	52                   	push   %edx
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	50                   	push   %eax
  80161e:	6a 00                	push   $0x0
  801620:	e8 b0 ff ff ff       	call   8015d5 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_cgetc>:

int
sys_cgetc(void)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 02                	push   $0x2
  80163a:	e8 96 ff ff ff       	call   8015d5 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 03                	push   $0x3
  801653:	e8 7d ff ff ff       	call   8015d5 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 04                	push   $0x4
  80166d:	e8 63 ff ff ff       	call   8015d5 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	52                   	push   %edx
  801688:	50                   	push   %eax
  801689:	6a 08                	push   $0x8
  80168b:	e8 45 ff ff ff       	call   8015d5 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80169a:	8b 75 18             	mov    0x18(%ebp),%esi
  80169d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	51                   	push   %ecx
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 09                	push   $0x9
  8016b0:	e8 20 ff ff ff       	call   8015d5 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    

008016bf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	ff 75 08             	pushl  0x8(%ebp)
  8016cd:	6a 0a                	push   $0xa
  8016cf:	e8 01 ff ff ff       	call   8015d5 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	6a 0b                	push   $0xb
  8016ea:	e8 e6 fe ff ff       	call   8015d5 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 0c                	push   $0xc
  801703:	e8 cd fe ff ff       	call   8015d5 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 0d                	push   $0xd
  80171c:	e8 b4 fe ff ff       	call   8015d5 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 0e                	push   $0xe
  801735:	e8 9b fe ff ff       	call   8015d5 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 0f                	push   $0xf
  80174e:	e8 82 fe ff ff       	call   8015d5 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	6a 10                	push   $0x10
  801768:	e8 68 fe ff ff       	call   8015d5 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 11                	push   $0x11
  801781:	e8 4f fe ff ff       	call   8015d5 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_cputc>:

void
sys_cputc(const char c)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801798:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	50                   	push   %eax
  8017a5:	6a 01                	push   $0x1
  8017a7:	e8 29 fe ff ff       	call   8015d5 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	90                   	nop
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 14                	push   $0x14
  8017c1:	e8 0f fe ff ff       	call   8015d5 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	90                   	nop
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	51                   	push   %ecx
  8017e5:	52                   	push   %edx
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	50                   	push   %eax
  8017ea:	6a 15                	push   $0x15
  8017ec:	e8 e4 fd ff ff       	call   8015d5 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	52                   	push   %edx
  801806:	50                   	push   %eax
  801807:	6a 16                	push   $0x16
  801809:	e8 c7 fd ff ff       	call   8015d5 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801816:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	51                   	push   %ecx
  801824:	52                   	push   %edx
  801825:	50                   	push   %eax
  801826:	6a 17                	push   $0x17
  801828:	e8 a8 fd ff ff       	call   8015d5 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801835:	8b 55 0c             	mov    0xc(%ebp),%edx
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 18                	push   $0x18
  801845:	e8 8b fd ff ff       	call   8015d5 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	ff 75 14             	pushl  0x14(%ebp)
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	6a 19                	push   $0x19
  801863:	e8 6d fd ff ff       	call   8015d5 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	50                   	push   %eax
  80187c:	6a 1a                	push   $0x1a
  80187e:	e8 52 fd ff ff       	call   8015d5 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	50                   	push   %eax
  801898:	6a 1b                	push   $0x1b
  80189a:	e8 36 fd ff ff       	call   8015d5 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 05                	push   $0x5
  8018b3:	e8 1d fd ff ff       	call   8015d5 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 06                	push   $0x6
  8018cc:	e8 04 fd ff ff       	call   8015d5 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 07                	push   $0x7
  8018e5:	e8 eb fc ff ff       	call   8015d5 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_exit_env>:


void sys_exit_env(void)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 1c                	push   $0x1c
  8018fe:	e8 d2 fc ff ff       	call   8015d5 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	90                   	nop
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801912:	8d 50 04             	lea    0x4(%eax),%edx
  801915:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 1d                	push   $0x1d
  801922:	e8 ae fc ff ff       	call   8015d5 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return result;
  80192a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801933:	89 01                	mov    %eax,(%ecx)
  801935:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	c9                   	leave  
  80193c:	c2 04 00             	ret    $0x4

0080193f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 13                	push   $0x13
  801951:	e8 7f fc ff ff       	call   8015d5 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_rcr2>:
uint32 sys_rcr2()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 1e                	push   $0x1e
  80196b:	e8 65 fc ff ff       	call   8015d5 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801981:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 1f                	push   $0x1f
  801990:	e8 40 fc ff ff       	call   8015d5 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <rsttst>:
void rsttst()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 21                	push   $0x21
  8019aa:	e8 26 fc ff ff       	call   8015d5 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	ff 75 10             	pushl  0x10(%ebp)
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	6a 20                	push   $0x20
  8019d5:	e8 fb fb ff ff       	call   8015d5 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dd:	90                   	nop
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <chktst>:
void chktst(uint32 n)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 22                	push   $0x22
  8019f0:	e8 e0 fb ff ff       	call   8015d5 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <inctst>:

void inctst()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 23                	push   $0x23
  801a0a:	e8 c6 fb ff ff       	call   8015d5 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <gettst>:
uint32 gettst()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 24                	push   $0x24
  801a24:	e8 ac fb ff ff       	call   8015d5 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 25                	push   $0x25
  801a3d:	e8 93 fb ff ff       	call   8015d5 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
  801a45:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801a4a:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 08             	pushl  0x8(%ebp)
  801a67:	6a 26                	push   $0x26
  801a69:	e8 67 fb ff ff       	call   8015d5 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a71:	90                   	nop
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	53                   	push   %ebx
  801a87:	51                   	push   %ecx
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 27                	push   $0x27
  801a8c:	e8 44 fb ff ff       	call   8015d5 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	52                   	push   %edx
  801aa9:	50                   	push   %eax
  801aaa:	6a 28                	push   $0x28
  801aac:	e8 24 fb ff ff       	call   8015d5 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ab9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	51                   	push   %ecx
  801ac5:	ff 75 10             	pushl  0x10(%ebp)
  801ac8:	52                   	push   %edx
  801ac9:	50                   	push   %eax
  801aca:	6a 29                	push   $0x29
  801acc:	e8 04 fb ff ff       	call   8015d5 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	6a 12                	push   $0x12
  801ae8:	e8 e8 fa ff ff       	call   8015d5 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 2a                	push   $0x2a
  801b06:	e8 ca fa ff ff       	call   8015d5 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 2b                	push   $0x2b
  801b20:	e8 b0 fa ff ff       	call   8015d5 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 2d                	push   $0x2d
  801b3b:	e8 95 fa ff ff       	call   8015d5 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 2c                	push   $0x2c
  801b57:	e8 79 fa ff ff       	call   8015d5 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	68 74 33 80 00       	push   $0x803374
  801b70:	68 25 01 00 00       	push   $0x125
  801b75:	68 a7 33 80 00       	push   $0x8033a7
  801b7a:	e8 e0 0c 00 00       	call   80285f <_panic>

00801b7f <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801b85:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801b8c:	72 09                	jb     801b97 <to_page_va+0x18>
  801b8e:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801b95:	72 14                	jb     801bab <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 b8 33 80 00       	push   $0x8033b8
  801b9f:	6a 15                	push   $0x15
  801ba1:	68 e3 33 80 00       	push   $0x8033e3
  801ba6:	e8 b4 0c 00 00       	call   80285f <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	ba 60 40 80 00       	mov    $0x804060,%edx
  801bb3:	29 d0                	sub    %edx,%eax
  801bb5:	c1 f8 02             	sar    $0x2,%eax
  801bb8:	89 c2                	mov    %eax,%edx
  801bba:	89 d0                	mov    %edx,%eax
  801bbc:	c1 e0 02             	shl    $0x2,%eax
  801bbf:	01 d0                	add    %edx,%eax
  801bc1:	c1 e0 02             	shl    $0x2,%eax
  801bc4:	01 d0                	add    %edx,%eax
  801bc6:	c1 e0 02             	shl    $0x2,%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	89 c1                	mov    %eax,%ecx
  801bcd:	c1 e1 08             	shl    $0x8,%ecx
  801bd0:	01 c8                	add    %ecx,%eax
  801bd2:	89 c1                	mov    %eax,%ecx
  801bd4:	c1 e1 10             	shl    $0x10,%ecx
  801bd7:	01 c8                	add    %ecx,%eax
  801bd9:	01 c0                	add    %eax,%eax
  801bdb:	01 d0                	add    %edx,%eax
  801bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be3:	c1 e0 0c             	shl    $0xc,%eax
  801be6:	89 c2                	mov    %eax,%edx
  801be8:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801bed:	01 d0                	add    %edx,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801bf7:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bff:	29 c2                	sub    %eax,%edx
  801c01:	89 d0                	mov    %edx,%eax
  801c03:	c1 e8 0c             	shr    $0xc,%eax
  801c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0d:	78 09                	js     801c18 <to_page_info+0x27>
  801c0f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c16:	7e 14                	jle    801c2c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	68 fc 33 80 00       	push   $0x8033fc
  801c20:	6a 22                	push   $0x22
  801c22:	68 e3 33 80 00       	push   $0x8033e3
  801c27:	e8 33 0c 00 00       	call   80285f <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	01 c0                	add    %eax,%eax
  801c33:	01 d0                	add    %edx,%eax
  801c35:	c1 e0 02             	shl    $0x2,%eax
  801c38:	05 60 40 80 00       	add    $0x804060,%eax
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	05 00 00 00 02       	add    $0x2000000,%eax
  801c4d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c50:	73 16                	jae    801c68 <initialize_dynamic_allocator+0x29>
  801c52:	68 20 34 80 00       	push   $0x803420
  801c57:	68 46 34 80 00       	push   $0x803446
  801c5c:	6a 34                	push   $0x34
  801c5e:	68 e3 33 80 00       	push   $0x8033e3
  801c63:	e8 f7 0b 00 00       	call   80285f <_panic>
		is_initialized = 1;
  801c68:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801c6f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801c82:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801c89:	00 00 00 
  801c8c:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801c93:	00 00 00 
  801c96:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801c9d:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca3:	2b 45 08             	sub    0x8(%ebp),%eax
  801ca6:	c1 e8 0c             	shr    $0xc,%eax
  801ca9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801cac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cb3:	e9 c8 00 00 00       	jmp    801d80 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	01 c0                	add    %eax,%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c1 e0 02             	shl    $0x2,%eax
  801cc4:	05 68 40 80 00       	add    $0x804068,%eax
  801cc9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	01 c0                	add    %eax,%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c1 e0 02             	shl    $0x2,%eax
  801cda:	05 6a 40 80 00       	add    $0x80406a,%eax
  801cdf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801ce4:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801cea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ced:	89 c8                	mov    %ecx,%eax
  801cef:	01 c0                	add    %eax,%eax
  801cf1:	01 c8                	add    %ecx,%eax
  801cf3:	c1 e0 02             	shl    $0x2,%eax
  801cf6:	05 64 40 80 00       	add    $0x804064,%eax
  801cfb:	89 10                	mov    %edx,(%eax)
  801cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d00:	89 d0                	mov    %edx,%eax
  801d02:	01 c0                	add    %eax,%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	c1 e0 02             	shl    $0x2,%eax
  801d09:	05 64 40 80 00       	add    $0x804064,%eax
  801d0e:	8b 00                	mov    (%eax),%eax
  801d10:	85 c0                	test   %eax,%eax
  801d12:	74 1b                	je     801d2f <initialize_dynamic_allocator+0xf0>
  801d14:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d1a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d1d:	89 c8                	mov    %ecx,%eax
  801d1f:	01 c0                	add    %eax,%eax
  801d21:	01 c8                	add    %ecx,%eax
  801d23:	c1 e0 02             	shl    $0x2,%eax
  801d26:	05 60 40 80 00       	add    $0x804060,%eax
  801d2b:	89 02                	mov    %eax,(%edx)
  801d2d:	eb 16                	jmp    801d45 <initialize_dynamic_allocator+0x106>
  801d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d32:	89 d0                	mov    %edx,%eax
  801d34:	01 c0                	add    %eax,%eax
  801d36:	01 d0                	add    %edx,%eax
  801d38:	c1 e0 02             	shl    $0x2,%eax
  801d3b:	05 60 40 80 00       	add    $0x804060,%eax
  801d40:	a3 48 40 80 00       	mov    %eax,0x804048
  801d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d48:	89 d0                	mov    %edx,%eax
  801d4a:	01 c0                	add    %eax,%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	c1 e0 02             	shl    $0x2,%eax
  801d51:	05 60 40 80 00       	add    $0x804060,%eax
  801d56:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5e:	89 d0                	mov    %edx,%eax
  801d60:	01 c0                	add    %eax,%eax
  801d62:	01 d0                	add    %edx,%eax
  801d64:	c1 e0 02             	shl    $0x2,%eax
  801d67:	05 60 40 80 00       	add    $0x804060,%eax
  801d6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d72:	a1 54 40 80 00       	mov    0x804054,%eax
  801d77:	40                   	inc    %eax
  801d78:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d7d:	ff 45 f4             	incl   -0xc(%ebp)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d86:	0f 8c 2c ff ff ff    	jl     801cb8 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801d8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801d93:	eb 36                	jmp    801dcb <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	c1 e0 04             	shl    $0x4,%eax
  801d9b:	05 80 c0 81 00       	add    $0x81c080,%eax
  801da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da9:	c1 e0 04             	shl    $0x4,%eax
  801dac:	05 84 c0 81 00       	add    $0x81c084,%eax
  801db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dba:	c1 e0 04             	shl    $0x4,%eax
  801dbd:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801dc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801dc8:	ff 45 f0             	incl   -0x10(%ebp)
  801dcb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801dcf:	7e c4                	jle    801d95 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801dd1:	90                   	nop
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	50                   	push   %eax
  801de1:	e8 0b fe ff ff       	call   801bf1 <to_page_info>
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 40 08             	mov    0x8(%eax),%eax
  801df2:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	e8 77 fd ff ff       	call   801b7f <to_page_va>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801e0e:	b8 00 10 00 00       	mov    $0x1000,%eax
  801e13:	ba 00 00 00 00       	mov    $0x0,%edx
  801e18:	f7 75 08             	divl   0x8(%ebp)
  801e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	50                   	push   %eax
  801e25:	e8 48 f6 ff ff       	call   801472 <get_page>
  801e2a:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801e41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e48:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801e4f:	eb 19                	jmp    801e6a <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e54:	ba 01 00 00 00       	mov    $0x1,%edx
  801e59:	88 c1                	mov    %al,%cl
  801e5b:	d3 e2                	shl    %cl,%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e62:	74 0e                	je     801e72 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801e64:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801e67:	ff 45 f0             	incl   -0x10(%ebp)
  801e6a:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801e6e:	7e e1                	jle    801e51 <split_page_to_blocks+0x5a>
  801e70:	eb 01                	jmp    801e73 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801e72:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801e73:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e7a:	e9 a7 00 00 00       	jmp    801f26 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e82:	0f af 45 08          	imul   0x8(%ebp),%eax
  801e86:	89 c2                	mov    %eax,%edx
  801e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801e90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e94:	75 14                	jne    801eaa <split_page_to_blocks+0xb3>
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 5c 34 80 00       	push   $0x80345c
  801e9e:	6a 7c                	push   $0x7c
  801ea0:	68 e3 33 80 00       	push   $0x8033e3
  801ea5:	e8 b5 09 00 00       	call   80285f <_panic>
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	c1 e0 04             	shl    $0x4,%eax
  801eb0:	05 84 c0 81 00       	add    $0x81c084,%eax
  801eb5:	8b 10                	mov    (%eax),%edx
  801eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eba:	89 50 04             	mov    %edx,0x4(%eax)
  801ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec0:	8b 40 04             	mov    0x4(%eax),%eax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	74 14                	je     801edb <split_page_to_blocks+0xe4>
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	c1 e0 04             	shl    $0x4,%eax
  801ecd:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed7:	89 10                	mov    %edx,(%eax)
  801ed9:	eb 11                	jmp    801eec <split_page_to_blocks+0xf5>
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	c1 e0 04             	shl    $0x4,%eax
  801ee1:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801ee7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eea:	89 02                	mov    %eax,(%edx)
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	c1 e0 04             	shl    $0x4,%eax
  801ef2:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801efb:	89 02                	mov    %eax,(%edx)
  801efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f09:	c1 e0 04             	shl    $0x4,%eax
  801f0c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f11:	8b 00                	mov    (%eax),%eax
  801f13:	8d 50 01             	lea    0x1(%eax),%edx
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	c1 e0 04             	shl    $0x4,%eax
  801f1c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f21:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f23:	ff 45 ec             	incl   -0x14(%ebp)
  801f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f29:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f2c:	0f 82 4d ff ff ff    	jb     801e7f <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f3b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f42:	76 19                	jbe    801f5d <alloc_block+0x28>
  801f44:	68 80 34 80 00       	push   $0x803480
  801f49:	68 46 34 80 00       	push   $0x803446
  801f4e:	68 8a 00 00 00       	push   $0x8a
  801f53:	68 e3 33 80 00       	push   $0x8033e3
  801f58:	e8 02 09 00 00       	call   80285f <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f64:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f6b:	eb 19                	jmp    801f86 <alloc_block+0x51>
		if((1 << i) >= size) break;
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	ba 01 00 00 00       	mov    $0x1,%edx
  801f75:	88 c1                	mov    %al,%cl
  801f77:	d3 e2                	shl    %cl,%edx
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f7e:	73 0e                	jae    801f8e <alloc_block+0x59>
		idx++;
  801f80:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801f83:	ff 45 f0             	incl   -0x10(%ebp)
  801f86:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f8a:	7e e1                	jle    801f6d <alloc_block+0x38>
  801f8c:	eb 01                	jmp    801f8f <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801f8e:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c1 e0 04             	shl    $0x4,%eax
  801f95:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	0f 84 df 00 00 00    	je     802083 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	c1 e0 04             	shl    $0x4,%eax
  801faa:	05 80 c0 81 00       	add    $0x81c080,%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  801fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fb8:	75 17                	jne    801fd1 <alloc_block+0x9c>
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	68 a1 34 80 00       	push   $0x8034a1
  801fc2:	68 9e 00 00 00       	push   $0x9e
  801fc7:	68 e3 33 80 00       	push   $0x8033e3
  801fcc:	e8 8e 08 00 00       	call   80285f <_panic>
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	74 10                	je     801fea <alloc_block+0xb5>
  801fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdd:	8b 00                	mov    (%eax),%eax
  801fdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe2:	8b 52 04             	mov    0x4(%edx),%edx
  801fe5:	89 50 04             	mov    %edx,0x4(%eax)
  801fe8:	eb 14                	jmp    801ffe <alloc_block+0xc9>
  801fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fed:	8b 40 04             	mov    0x4(%eax),%eax
  801ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff3:	c1 e2 04             	shl    $0x4,%edx
  801ff6:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  801ffc:	89 02                	mov    %eax,(%edx)
  801ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802001:	8b 40 04             	mov    0x4(%eax),%eax
  802004:	85 c0                	test   %eax,%eax
  802006:	74 0f                	je     802017 <alloc_block+0xe2>
  802008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200b:	8b 40 04             	mov    0x4(%eax),%eax
  80200e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802011:	8b 12                	mov    (%edx),%edx
  802013:	89 10                	mov    %edx,(%eax)
  802015:	eb 13                	jmp    80202a <alloc_block+0xf5>
  802017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201f:	c1 e2 04             	shl    $0x4,%edx
  802022:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802028:	89 02                	mov    %eax,(%edx)
  80202a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802036:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	c1 e0 04             	shl    $0x4,%eax
  802043:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	c1 e0 04             	shl    $0x4,%eax
  802053:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802058:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	50                   	push   %eax
  802061:	e8 8b fb ff ff       	call   801bf1 <to_page_info>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80206c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802073:	48                   	dec    %eax
  802074:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802077:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	e9 bc 02 00 00       	jmp    80233f <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802083:	a1 54 40 80 00       	mov    0x804054,%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	0f 84 7d 02 00 00    	je     80230d <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802090:	a1 48 40 80 00       	mov    0x804048,%eax
  802095:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802098:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80209c:	75 17                	jne    8020b5 <alloc_block+0x180>
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	68 a1 34 80 00       	push   $0x8034a1
  8020a6:	68 a9 00 00 00       	push   $0xa9
  8020ab:	68 e3 33 80 00       	push   $0x8033e3
  8020b0:	e8 aa 07 00 00       	call   80285f <_panic>
  8020b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	74 10                	je     8020ce <alloc_block+0x199>
  8020be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020c6:	8b 52 04             	mov    0x4(%edx),%edx
  8020c9:	89 50 04             	mov    %edx,0x4(%eax)
  8020cc:	eb 0b                	jmp    8020d9 <alloc_block+0x1a4>
  8020ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d1:	8b 40 04             	mov    0x4(%eax),%eax
  8020d4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020dc:	8b 40 04             	mov    0x4(%eax),%eax
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	74 0f                	je     8020f2 <alloc_block+0x1bd>
  8020e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e6:	8b 40 04             	mov    0x4(%eax),%eax
  8020e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020ec:	8b 12                	mov    (%edx),%edx
  8020ee:	89 10                	mov    %edx,(%eax)
  8020f0:	eb 0a                	jmp    8020fc <alloc_block+0x1c7>
  8020f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	a3 48 40 80 00       	mov    %eax,0x804048
  8020fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802108:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210f:	a1 54 40 80 00       	mov    0x804054,%eax
  802114:	48                   	dec    %eax
  802115:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	83 c0 03             	add    $0x3,%eax
  802120:	ba 01 00 00 00       	mov    $0x1,%edx
  802125:	88 c1                	mov    %al,%cl
  802127:	d3 e2                	shl    %cl,%edx
  802129:	89 d0                	mov    %edx,%eax
  80212b:	83 ec 08             	sub    $0x8,%esp
  80212e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802131:	50                   	push   %eax
  802132:	e8 c0 fc ff ff       	call   801df7 <split_page_to_blocks>
  802137:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	c1 e0 04             	shl    $0x4,%eax
  802140:	05 80 c0 81 00       	add    $0x81c080,%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80214a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80214e:	75 17                	jne    802167 <alloc_block+0x232>
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	68 a1 34 80 00       	push   $0x8034a1
  802158:	68 b0 00 00 00       	push   $0xb0
  80215d:	68 e3 33 80 00       	push   $0x8033e3
  802162:	e8 f8 06 00 00       	call   80285f <_panic>
  802167:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	74 10                	je     802180 <alloc_block+0x24b>
  802170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802178:	8b 52 04             	mov    0x4(%edx),%edx
  80217b:	89 50 04             	mov    %edx,0x4(%eax)
  80217e:	eb 14                	jmp    802194 <alloc_block+0x25f>
  802180:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802189:	c1 e2 04             	shl    $0x4,%edx
  80218c:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802192:	89 02                	mov    %eax,(%edx)
  802194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802197:	8b 40 04             	mov    0x4(%eax),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	74 0f                	je     8021ad <alloc_block+0x278>
  80219e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a1:	8b 40 04             	mov    0x4(%eax),%eax
  8021a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021a7:	8b 12                	mov    (%edx),%edx
  8021a9:	89 10                	mov    %edx,(%eax)
  8021ab:	eb 13                	jmp    8021c0 <alloc_block+0x28b>
  8021ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b5:	c1 e2 04             	shl    $0x4,%edx
  8021b8:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8021be:	89 02                	mov    %eax,(%edx)
  8021c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c1 e0 04             	shl    $0x4,%eax
  8021d9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021de:	8b 00                	mov    (%eax),%eax
  8021e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	c1 e0 04             	shl    $0x4,%eax
  8021e9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021ee:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8021f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	50                   	push   %eax
  8021f7:	e8 f5 f9 ff ff       	call   801bf1 <to_page_info>
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802202:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802205:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802209:	48                   	dec    %eax
  80220a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80220d:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802214:	e9 26 01 00 00       	jmp    80233f <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802219:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	c1 e0 04             	shl    $0x4,%eax
  802222:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802227:	8b 00                	mov    (%eax),%eax
  802229:	85 c0                	test   %eax,%eax
  80222b:	0f 84 dc 00 00 00    	je     80230d <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	c1 e0 04             	shl    $0x4,%eax
  802237:	05 80 c0 81 00       	add    $0x81c080,%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802241:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802245:	75 17                	jne    80225e <alloc_block+0x329>
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	68 a1 34 80 00       	push   $0x8034a1
  80224f:	68 be 00 00 00       	push   $0xbe
  802254:	68 e3 33 80 00       	push   $0x8033e3
  802259:	e8 01 06 00 00       	call   80285f <_panic>
  80225e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 10                	je     802277 <alloc_block+0x342>
  802267:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80226f:	8b 52 04             	mov    0x4(%edx),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	eb 14                	jmp    80228b <alloc_block+0x356>
  802277:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802280:	c1 e2 04             	shl    $0x4,%edx
  802283:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802289:	89 02                	mov    %eax,(%edx)
  80228b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80228e:	8b 40 04             	mov    0x4(%eax),%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	74 0f                	je     8022a4 <alloc_block+0x36f>
  802295:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802298:	8b 40 04             	mov    0x4(%eax),%eax
  80229b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80229e:	8b 12                	mov    (%edx),%edx
  8022a0:	89 10                	mov    %edx,(%eax)
  8022a2:	eb 13                	jmp    8022b7 <alloc_block+0x382>
  8022a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	c1 e2 04             	shl    $0x4,%edx
  8022af:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022b5:	89 02                	mov    %eax,(%edx)
  8022b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	c1 e0 04             	shl    $0x4,%eax
  8022d0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	c1 e0 04             	shl    $0x4,%eax
  8022e0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022e5:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8022e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	50                   	push   %eax
  8022ee:	e8 fe f8 ff ff       	call   801bf1 <to_page_info>
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8022f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022fc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802300:	48                   	dec    %eax
  802301:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802304:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802308:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80230b:	eb 32                	jmp    80233f <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80230d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802311:	77 15                	ja     802328 <alloc_block+0x3f3>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	c1 e0 04             	shl    $0x4,%eax
  802319:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	0f 84 f1 fe ff ff    	je     802219 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 bf 34 80 00       	push   $0x8034bf
  802330:	68 c8 00 00 00       	push   $0xc8
  802335:	68 e3 33 80 00       	push   $0x8033e3
  80233a:	e8 20 05 00 00       	call   80285f <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80234f:	39 c2                	cmp    %eax,%edx
  802351:	72 0c                	jb     80235f <free_block+0x1e>
  802353:	8b 55 08             	mov    0x8(%ebp),%edx
  802356:	a1 40 40 80 00       	mov    0x804040,%eax
  80235b:	39 c2                	cmp    %eax,%edx
  80235d:	72 19                	jb     802378 <free_block+0x37>
  80235f:	68 d0 34 80 00       	push   $0x8034d0
  802364:	68 46 34 80 00       	push   $0x803446
  802369:	68 d7 00 00 00       	push   $0xd7
  80236e:	68 e3 33 80 00       	push   $0x8033e3
  802373:	e8 e7 04 00 00       	call   80285f <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	50                   	push   %eax
  802385:	e8 67 f8 ff ff       	call   801bf1 <to_page_info>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802393:	8b 40 08             	mov    0x8(%eax),%eax
  802396:	0f b7 c0             	movzwl %ax,%eax
  802399:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80239c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8023a3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8023aa:	eb 19                	jmp    8023c5 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	ba 01 00 00 00       	mov    $0x1,%edx
  8023b4:	88 c1                	mov    %al,%cl
  8023b6:	d3 e2                	shl    %cl,%edx
  8023b8:	89 d0                	mov    %edx,%eax
  8023ba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8023bd:	74 0e                	je     8023cd <free_block+0x8c>
	        break;
	    idx++;
  8023bf:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8023c2:	ff 45 f0             	incl   -0x10(%ebp)
  8023c5:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8023c9:	7e e1                	jle    8023ac <free_block+0x6b>
  8023cb:	eb 01                	jmp    8023ce <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8023cd:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8023ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023d5:	40                   	inc    %eax
  8023d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023d9:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8023dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023e1:	75 17                	jne    8023fa <free_block+0xb9>
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	68 5c 34 80 00       	push   $0x80345c
  8023eb:	68 ee 00 00 00       	push   $0xee
  8023f0:	68 e3 33 80 00       	push   $0x8033e3
  8023f5:	e8 65 04 00 00       	call   80285f <_panic>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	c1 e0 04             	shl    $0x4,%eax
  802400:	05 84 c0 81 00       	add    $0x81c084,%eax
  802405:	8b 10                	mov    (%eax),%edx
  802407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 14                	je     80242b <free_block+0xea>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	c1 e0 04             	shl    $0x4,%eax
  80241d:	05 84 c0 81 00       	add    $0x81c084,%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802427:	89 10                	mov    %edx,(%eax)
  802429:	eb 11                	jmp    80243c <free_block+0xfb>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	c1 e0 04             	shl    $0x4,%eax
  802431:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243a:	89 02                	mov    %eax,(%edx)
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c1 e0 04             	shl    $0x4,%eax
  802442:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244b:	89 02                	mov    %eax,(%edx)
  80244d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	c1 e0 04             	shl    $0x4,%eax
  80245c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	8d 50 01             	lea    0x1(%eax),%edx
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	c1 e0 04             	shl    $0x4,%eax
  80246c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802471:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802473:	b8 00 10 00 00       	mov    $0x1000,%eax
  802478:	ba 00 00 00 00       	mov    $0x0,%edx
  80247d:	f7 75 e0             	divl   -0x20(%ebp)
  802480:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802486:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80248a:	0f b7 c0             	movzwl %ax,%eax
  80248d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802490:	0f 85 70 01 00 00    	jne    802606 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80249c:	e8 de f6 ff ff       	call   801b7f <to_page_va>
  8024a1:	83 c4 10             	add    $0x10,%esp
  8024a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8024a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8024ae:	e9 b7 00 00 00       	jmp    80256a <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8024b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8024be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024c2:	75 17                	jne    8024db <free_block+0x19a>
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	68 a1 34 80 00       	push   $0x8034a1
  8024cc:	68 f8 00 00 00       	push   $0xf8
  8024d1:	68 e3 33 80 00       	push   $0x8033e3
  8024d6:	e8 84 03 00 00       	call   80285f <_panic>
  8024db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 10                	je     8024f4 <free_block+0x1b3>
  8024e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024ec:	8b 52 04             	mov    0x4(%edx),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)
  8024f2:	eb 14                	jmp    802508 <free_block+0x1c7>
  8024f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	c1 e2 04             	shl    $0x4,%edx
  802500:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802506:	89 02                	mov    %eax,(%edx)
  802508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250b:	8b 40 04             	mov    0x4(%eax),%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	74 0f                	je     802521 <free_block+0x1e0>
  802512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80251b:	8b 12                	mov    (%edx),%edx
  80251d:	89 10                	mov    %edx,(%eax)
  80251f:	eb 13                	jmp    802534 <free_block+0x1f3>
  802521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802529:	c1 e2 04             	shl    $0x4,%edx
  80252c:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802532:	89 02                	mov    %eax,(%edx)
  802534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	c1 e0 04             	shl    $0x4,%eax
  80254d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8d 50 ff             	lea    -0x1(%eax),%edx
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	c1 e0 04             	shl    $0x4,%eax
  80255d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802562:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802567:	01 45 ec             	add    %eax,-0x14(%ebp)
  80256a:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802571:	0f 86 3c ff ff ff    	jbe    8024b3 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802583:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80258d:	75 17                	jne    8025a6 <free_block+0x265>
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 5c 34 80 00       	push   $0x80345c
  802597:	68 fe 00 00 00       	push   $0xfe
  80259c:	68 e3 33 80 00       	push   $0x8033e3
  8025a1:	e8 b9 02 00 00       	call   80285f <_panic>
  8025a6:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 0c                	je     8025c8 <free_block+0x287>
  8025bc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	eb 08                	jmp    8025d0 <free_block+0x28f>
  8025c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cb:	a3 48 40 80 00       	mov    %eax,0x804048
  8025d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e1:	a1 54 40 80 00       	mov    0x804054,%eax
  8025e6:	40                   	inc    %eax
  8025e7:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8025ec:	83 ec 0c             	sub    $0xc,%esp
  8025ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025f2:	e8 88 f5 ff ff       	call   801b7f <to_page_va>
  8025f7:	83 c4 10             	add    $0x10,%esp
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	50                   	push   %eax
  8025fe:	e8 b8 ee ff ff       	call   8014bb <return_page>
  802603:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802606:	90                   	nop
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80260f:	83 ec 04             	sub    $0x4,%esp
  802612:	68 08 35 80 00       	push   $0x803508
  802617:	68 11 01 00 00       	push   $0x111
  80261c:	68 e3 33 80 00       	push   $0x8033e3
  802621:	e8 39 02 00 00       	call   80285f <_panic>

00802626 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	68 2c 35 80 00       	push   $0x80352c
  802634:	6a 07                	push   $0x7
  802636:	68 5b 35 80 00       	push   $0x80355b
  80263b:	e8 1f 02 00 00       	call   80285f <_panic>

00802640 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	68 6c 35 80 00       	push   $0x80356c
  80264e:	6a 0b                	push   $0xb
  802650:	68 5b 35 80 00       	push   $0x80355b
  802655:	e8 05 02 00 00       	call   80285f <_panic>

0080265a <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	68 98 35 80 00       	push   $0x803598
  802668:	6a 10                	push   $0x10
  80266a:	68 5b 35 80 00       	push   $0x80355b
  80266f:	e8 eb 01 00 00       	call   80285f <_panic>

00802674 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 c8 35 80 00       	push   $0x8035c8
  802682:	6a 15                	push   $0x15
  802684:	68 5b 35 80 00       	push   $0x80355b
  802689:	e8 d1 01 00 00       	call   80285f <_panic>

0080268e <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	8b 40 10             	mov    0x10(%eax),%eax
}
  802697:	5d                   	pop    %ebp
  802698:	c3                   	ret    

00802699 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80269f:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a2:	89 d0                	mov    %edx,%eax
  8026a4:	c1 e0 02             	shl    $0x2,%eax
  8026a7:	01 d0                	add    %edx,%eax
  8026a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	c1 e0 04             	shl    $0x4,%eax
  8026c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8026ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026d1:	0f 31                	rdtsc  
  8026d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026e2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8026e5:	eb 46                	jmp    80272d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8026e7:	0f 31                	rdtsc  
  8026e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8026ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8026ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8026fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	29 c2                	sub    %eax,%edx
  802703:	89 d0                	mov    %edx,%eax
  802705:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802708:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	89 d1                	mov    %edx,%ecx
  802710:	29 c1                	sub    %eax,%ecx
  802712:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802718:	39 c2                	cmp    %eax,%edx
  80271a:	0f 97 c0             	seta   %al
  80271d:	0f b6 c0             	movzbl %al,%eax
  802720:	29 c1                	sub    %eax,%ecx
  802722:	89 c8                	mov    %ecx,%eax
  802724:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802727:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80272a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80272d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802730:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802733:	72 b2                	jb     8026e7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802735:	90                   	nop
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80273e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802745:	eb 03                	jmp    80274a <busy_wait+0x12>
  802747:	ff 45 fc             	incl   -0x4(%ebp)
  80274a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80274d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802750:	72 f5                	jb     802747 <busy_wait+0xf>
	return i;
  802752:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80275d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802761:	74 1c                	je     80277f <init_uspinlock+0x28>
  802763:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  802767:	74 16                	je     80277f <init_uspinlock+0x28>
  802769:	68 f8 35 80 00       	push   $0x8035f8
  80276e:	68 17 36 80 00       	push   $0x803617
  802773:	6a 10                	push   $0x10
  802775:	68 2c 36 80 00       	push   $0x80362c
  80277a:	e8 e0 00 00 00       	call   80285f <_panic>
	strcpy(lk->name, name);
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	83 c0 04             	add    $0x4,%eax
  802785:	83 ec 08             	sub    $0x8,%esp
  802788:	ff 75 0c             	pushl  0xc(%ebp)
  80278b:	50                   	push   %eax
  80278c:	e8 d0 e4 ff ff       	call   800c61 <strcpy>
  802791:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  802794:	b8 01 00 00 00       	mov    $0x1,%eax
  802799:	2b 45 10             	sub    0x10(%ebp),%eax
  80279c:	89 c2                	mov    %eax,%edx
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	89 10                	mov    %edx,(%eax)
}
  8027a3:	90                   	nop
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8027ac:	90                   	nop
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027c3:	f0 87 02             	lock xchg %eax,(%edx)
  8027c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8027c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	75 dd                	jne    8027ad <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8d 48 04             	lea    0x4(%eax),%ecx
  8027d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8027db:	8d 50 20             	lea    0x20(%eax),%edx
  8027de:	a1 20 40 80 00       	mov    0x804020,%eax
  8027e3:	8b 40 10             	mov    0x10(%eax),%eax
  8027e6:	51                   	push   %ecx
  8027e7:	52                   	push   %edx
  8027e8:	50                   	push   %eax
  8027e9:	68 3c 36 80 00       	push   $0x80363c
  8027ee:	e8 46 dd ff ff       	call   800539 <cprintf>
  8027f3:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8027f6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	75 18                	jne    802825 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	83 c0 04             	add    $0x4,%eax
  802813:	50                   	push   %eax
  802814:	68 60 36 80 00       	push   $0x803660
  802819:	6a 2b                	push   $0x2b
  80281b:	68 2c 36 80 00       	push   $0x80362c
  802820:	e8 3a 00 00 00       	call   80285f <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  802825:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	8b 55 08             	mov    0x8(%ebp),%edx
  802830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	8d 48 04             	lea    0x4(%eax),%ecx
  80283c:	a1 20 40 80 00       	mov    0x804020,%eax
  802841:	8d 50 20             	lea    0x20(%eax),%edx
  802844:	a1 20 40 80 00       	mov    0x804020,%eax
  802849:	8b 40 10             	mov    0x10(%eax),%eax
  80284c:	51                   	push   %ecx
  80284d:	52                   	push   %edx
  80284e:	50                   	push   %eax
  80284f:	68 80 36 80 00       	push   $0x803680
  802854:	e8 e0 dc ff ff       	call   800539 <cprintf>
  802859:	83 c4 10             	add    $0x10,%esp
}
  80285c:	90                   	nop
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802865:	8d 45 10             	lea    0x10(%ebp),%eax
  802868:	83 c0 04             	add    $0x4,%eax
  80286b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80286e:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 16                	je     80288d <_panic+0x2e>
		cprintf("%s: ", argv0);
  802877:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80287c:	83 ec 08             	sub    $0x8,%esp
  80287f:	50                   	push   %eax
  802880:	68 a4 36 80 00       	push   $0x8036a4
  802885:	e8 af dc ff ff       	call   800539 <cprintf>
  80288a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80288d:	a1 04 40 80 00       	mov    0x804004,%eax
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	ff 75 0c             	pushl  0xc(%ebp)
  802898:	ff 75 08             	pushl  0x8(%ebp)
  80289b:	50                   	push   %eax
  80289c:	68 ac 36 80 00       	push   $0x8036ac
  8028a1:	6a 74                	push   $0x74
  8028a3:	e8 be dc ff ff       	call   800566 <cprintf_colored>
  8028a8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8028ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ae:	83 ec 08             	sub    $0x8,%esp
  8028b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028b4:	50                   	push   %eax
  8028b5:	e8 10 dc ff ff       	call   8004ca <vcprintf>
  8028ba:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8028bd:	83 ec 08             	sub    $0x8,%esp
  8028c0:	6a 00                	push   $0x0
  8028c2:	68 d4 36 80 00       	push   $0x8036d4
  8028c7:	e8 fe db ff ff       	call   8004ca <vcprintf>
  8028cc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8028cf:	e8 77 db ff ff       	call   80044b <exit>

	// should not return here
	while (1) ;
  8028d4:	eb fe                	jmp    8028d4 <_panic+0x75>

008028d6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8028dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8028e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ea:	39 c2                	cmp    %eax,%edx
  8028ec:	74 14                	je     802902 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	68 d8 36 80 00       	push   $0x8036d8
  8028f6:	6a 26                	push   $0x26
  8028f8:	68 24 37 80 00       	push   $0x803724
  8028fd:	e8 5d ff ff ff       	call   80285f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802910:	e9 c5 00 00 00       	jmp    8029da <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80291f:	8b 45 08             	mov    0x8(%ebp),%eax
  802922:	01 d0                	add    %edx,%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	85 c0                	test   %eax,%eax
  802928:	75 08                	jne    802932 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80292a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80292d:	e9 a5 00 00 00       	jmp    8029d7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802932:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802939:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802940:	eb 69                	jmp    8029ab <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802942:	a1 20 40 80 00       	mov    0x804020,%eax
  802947:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80294d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802950:	89 d0                	mov    %edx,%eax
  802952:	01 c0                	add    %eax,%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	c1 e0 03             	shl    $0x3,%eax
  802959:	01 c8                	add    %ecx,%eax
  80295b:	8a 40 04             	mov    0x4(%eax),%al
  80295e:	84 c0                	test   %al,%al
  802960:	75 46                	jne    8029a8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802962:	a1 20 40 80 00       	mov    0x804020,%eax
  802967:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80296d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802970:	89 d0                	mov    %edx,%eax
  802972:	01 c0                	add    %eax,%eax
  802974:	01 d0                	add    %edx,%eax
  802976:	c1 e0 03             	shl    $0x3,%eax
  802979:	01 c8                	add    %ecx,%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802983:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802988:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	01 c8                	add    %ecx,%eax
  802999:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80299b:	39 c2                	cmp    %eax,%edx
  80299d:	75 09                	jne    8029a8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80299f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8029a6:	eb 15                	jmp    8029bd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029a8:	ff 45 e8             	incl   -0x18(%ebp)
  8029ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8029b0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	39 c2                	cmp    %eax,%edx
  8029bb:	77 85                	ja     802942 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8029bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c1:	75 14                	jne    8029d7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 30 37 80 00       	push   $0x803730
  8029cb:	6a 3a                	push   $0x3a
  8029cd:	68 24 37 80 00       	push   $0x803724
  8029d2:	e8 88 fe ff ff       	call   80285f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8029d7:	ff 45 f0             	incl   -0x10(%ebp)
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029e0:	0f 8c 2f ff ff ff    	jl     802915 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8029e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029f4:	eb 26                	jmp    802a1c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8029f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8029fb:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802a01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a04:	89 d0                	mov    %edx,%eax
  802a06:	01 c0                	add    %eax,%eax
  802a08:	01 d0                	add    %edx,%eax
  802a0a:	c1 e0 03             	shl    $0x3,%eax
  802a0d:	01 c8                	add    %ecx,%eax
  802a0f:	8a 40 04             	mov    0x4(%eax),%al
  802a12:	3c 01                	cmp    $0x1,%al
  802a14:	75 03                	jne    802a19 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802a16:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a19:	ff 45 e0             	incl   -0x20(%ebp)
  802a1c:	a1 20 40 80 00       	mov    0x804020,%eax
  802a21:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2a:	39 c2                	cmp    %eax,%edx
  802a2c:	77 c8                	ja     8029f6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a34:	74 14                	je     802a4a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	68 84 37 80 00       	push   $0x803784
  802a3e:	6a 44                	push   $0x44
  802a40:	68 24 37 80 00       	push   $0x803724
  802a45:	e8 15 fe ff ff       	call   80285f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802a4a:	90                   	nop
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    
  802a4d:	66 90                	xchg   %ax,%ax
  802a4f:	90                   	nop

00802a50 <__udivdi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	83 ec 1c             	sub    $0x1c,%esp
  802a57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a67:	89 ca                	mov    %ecx,%edx
  802a69:	89 f8                	mov    %edi,%eax
  802a6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a6f:	85 f6                	test   %esi,%esi
  802a71:	75 2d                	jne    802aa0 <__udivdi3+0x50>
  802a73:	39 cf                	cmp    %ecx,%edi
  802a75:	77 65                	ja     802adc <__udivdi3+0x8c>
  802a77:	89 fd                	mov    %edi,%ebp
  802a79:	85 ff                	test   %edi,%edi
  802a7b:	75 0b                	jne    802a88 <__udivdi3+0x38>
  802a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a82:	31 d2                	xor    %edx,%edx
  802a84:	f7 f7                	div    %edi
  802a86:	89 c5                	mov    %eax,%ebp
  802a88:	31 d2                	xor    %edx,%edx
  802a8a:	89 c8                	mov    %ecx,%eax
  802a8c:	f7 f5                	div    %ebp
  802a8e:	89 c1                	mov    %eax,%ecx
  802a90:	89 d8                	mov    %ebx,%eax
  802a92:	f7 f5                	div    %ebp
  802a94:	89 cf                	mov    %ecx,%edi
  802a96:	89 fa                	mov    %edi,%edx
  802a98:	83 c4 1c             	add    $0x1c,%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	39 ce                	cmp    %ecx,%esi
  802aa2:	77 28                	ja     802acc <__udivdi3+0x7c>
  802aa4:	0f bd fe             	bsr    %esi,%edi
  802aa7:	83 f7 1f             	xor    $0x1f,%edi
  802aaa:	75 40                	jne    802aec <__udivdi3+0x9c>
  802aac:	39 ce                	cmp    %ecx,%esi
  802aae:	72 0a                	jb     802aba <__udivdi3+0x6a>
  802ab0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ab4:	0f 87 9e 00 00 00    	ja     802b58 <__udivdi3+0x108>
  802aba:	b8 01 00 00 00       	mov    $0x1,%eax
  802abf:	89 fa                	mov    %edi,%edx
  802ac1:	83 c4 1c             	add    $0x1c,%esp
  802ac4:	5b                   	pop    %ebx
  802ac5:	5e                   	pop    %esi
  802ac6:	5f                   	pop    %edi
  802ac7:	5d                   	pop    %ebp
  802ac8:	c3                   	ret    
  802ac9:	8d 76 00             	lea    0x0(%esi),%esi
  802acc:	31 ff                	xor    %edi,%edi
  802ace:	31 c0                	xor    %eax,%eax
  802ad0:	89 fa                	mov    %edi,%edx
  802ad2:	83 c4 1c             	add    $0x1c,%esp
  802ad5:	5b                   	pop    %ebx
  802ad6:	5e                   	pop    %esi
  802ad7:	5f                   	pop    %edi
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	89 d8                	mov    %ebx,%eax
  802ade:	f7 f7                	div    %edi
  802ae0:	31 ff                	xor    %edi,%edi
  802ae2:	89 fa                	mov    %edi,%edx
  802ae4:	83 c4 1c             	add    $0x1c,%esp
  802ae7:	5b                   	pop    %ebx
  802ae8:	5e                   	pop    %esi
  802ae9:	5f                   	pop    %edi
  802aea:	5d                   	pop    %ebp
  802aeb:	c3                   	ret    
  802aec:	bd 20 00 00 00       	mov    $0x20,%ebp
  802af1:	89 eb                	mov    %ebp,%ebx
  802af3:	29 fb                	sub    %edi,%ebx
  802af5:	89 f9                	mov    %edi,%ecx
  802af7:	d3 e6                	shl    %cl,%esi
  802af9:	89 c5                	mov    %eax,%ebp
  802afb:	88 d9                	mov    %bl,%cl
  802afd:	d3 ed                	shr    %cl,%ebp
  802aff:	89 e9                	mov    %ebp,%ecx
  802b01:	09 f1                	or     %esi,%ecx
  802b03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b07:	89 f9                	mov    %edi,%ecx
  802b09:	d3 e0                	shl    %cl,%eax
  802b0b:	89 c5                	mov    %eax,%ebp
  802b0d:	89 d6                	mov    %edx,%esi
  802b0f:	88 d9                	mov    %bl,%cl
  802b11:	d3 ee                	shr    %cl,%esi
  802b13:	89 f9                	mov    %edi,%ecx
  802b15:	d3 e2                	shl    %cl,%edx
  802b17:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b1b:	88 d9                	mov    %bl,%cl
  802b1d:	d3 e8                	shr    %cl,%eax
  802b1f:	09 c2                	or     %eax,%edx
  802b21:	89 d0                	mov    %edx,%eax
  802b23:	89 f2                	mov    %esi,%edx
  802b25:	f7 74 24 0c          	divl   0xc(%esp)
  802b29:	89 d6                	mov    %edx,%esi
  802b2b:	89 c3                	mov    %eax,%ebx
  802b2d:	f7 e5                	mul    %ebp
  802b2f:	39 d6                	cmp    %edx,%esi
  802b31:	72 19                	jb     802b4c <__udivdi3+0xfc>
  802b33:	74 0b                	je     802b40 <__udivdi3+0xf0>
  802b35:	89 d8                	mov    %ebx,%eax
  802b37:	31 ff                	xor    %edi,%edi
  802b39:	e9 58 ff ff ff       	jmp    802a96 <__udivdi3+0x46>
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b44:	89 f9                	mov    %edi,%ecx
  802b46:	d3 e2                	shl    %cl,%edx
  802b48:	39 c2                	cmp    %eax,%edx
  802b4a:	73 e9                	jae    802b35 <__udivdi3+0xe5>
  802b4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b4f:	31 ff                	xor    %edi,%edi
  802b51:	e9 40 ff ff ff       	jmp    802a96 <__udivdi3+0x46>
  802b56:	66 90                	xchg   %ax,%ax
  802b58:	31 c0                	xor    %eax,%eax
  802b5a:	e9 37 ff ff ff       	jmp    802a96 <__udivdi3+0x46>
  802b5f:	90                   	nop

00802b60 <__umoddi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	53                   	push   %ebx
  802b64:	83 ec 1c             	sub    $0x1c,%esp
  802b67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b7f:	89 f3                	mov    %esi,%ebx
  802b81:	89 fa                	mov    %edi,%edx
  802b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b87:	89 34 24             	mov    %esi,(%esp)
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	75 1a                	jne    802ba8 <__umoddi3+0x48>
  802b8e:	39 f7                	cmp    %esi,%edi
  802b90:	0f 86 a2 00 00 00    	jbe    802c38 <__umoddi3+0xd8>
  802b96:	89 c8                	mov    %ecx,%eax
  802b98:	89 f2                	mov    %esi,%edx
  802b9a:	f7 f7                	div    %edi
  802b9c:	89 d0                	mov    %edx,%eax
  802b9e:	31 d2                	xor    %edx,%edx
  802ba0:	83 c4 1c             	add    $0x1c,%esp
  802ba3:	5b                   	pop    %ebx
  802ba4:	5e                   	pop    %esi
  802ba5:	5f                   	pop    %edi
  802ba6:	5d                   	pop    %ebp
  802ba7:	c3                   	ret    
  802ba8:	39 f0                	cmp    %esi,%eax
  802baa:	0f 87 ac 00 00 00    	ja     802c5c <__umoddi3+0xfc>
  802bb0:	0f bd e8             	bsr    %eax,%ebp
  802bb3:	83 f5 1f             	xor    $0x1f,%ebp
  802bb6:	0f 84 ac 00 00 00    	je     802c68 <__umoddi3+0x108>
  802bbc:	bf 20 00 00 00       	mov    $0x20,%edi
  802bc1:	29 ef                	sub    %ebp,%edi
  802bc3:	89 fe                	mov    %edi,%esi
  802bc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	d3 e0                	shl    %cl,%eax
  802bcd:	89 d7                	mov    %edx,%edi
  802bcf:	89 f1                	mov    %esi,%ecx
  802bd1:	d3 ef                	shr    %cl,%edi
  802bd3:	09 c7                	or     %eax,%edi
  802bd5:	89 e9                	mov    %ebp,%ecx
  802bd7:	d3 e2                	shl    %cl,%edx
  802bd9:	89 14 24             	mov    %edx,(%esp)
  802bdc:	89 d8                	mov    %ebx,%eax
  802bde:	d3 e0                	shl    %cl,%eax
  802be0:	89 c2                	mov    %eax,%edx
  802be2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802be6:	d3 e0                	shl    %cl,%eax
  802be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bec:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bf0:	89 f1                	mov    %esi,%ecx
  802bf2:	d3 e8                	shr    %cl,%eax
  802bf4:	09 d0                	or     %edx,%eax
  802bf6:	d3 eb                	shr    %cl,%ebx
  802bf8:	89 da                	mov    %ebx,%edx
  802bfa:	f7 f7                	div    %edi
  802bfc:	89 d3                	mov    %edx,%ebx
  802bfe:	f7 24 24             	mull   (%esp)
  802c01:	89 c6                	mov    %eax,%esi
  802c03:	89 d1                	mov    %edx,%ecx
  802c05:	39 d3                	cmp    %edx,%ebx
  802c07:	0f 82 87 00 00 00    	jb     802c94 <__umoddi3+0x134>
  802c0d:	0f 84 91 00 00 00    	je     802ca4 <__umoddi3+0x144>
  802c13:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c17:	29 f2                	sub    %esi,%edx
  802c19:	19 cb                	sbb    %ecx,%ebx
  802c1b:	89 d8                	mov    %ebx,%eax
  802c1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c21:	d3 e0                	shl    %cl,%eax
  802c23:	89 e9                	mov    %ebp,%ecx
  802c25:	d3 ea                	shr    %cl,%edx
  802c27:	09 d0                	or     %edx,%eax
  802c29:	89 e9                	mov    %ebp,%ecx
  802c2b:	d3 eb                	shr    %cl,%ebx
  802c2d:	89 da                	mov    %ebx,%edx
  802c2f:	83 c4 1c             	add    $0x1c,%esp
  802c32:	5b                   	pop    %ebx
  802c33:	5e                   	pop    %esi
  802c34:	5f                   	pop    %edi
  802c35:	5d                   	pop    %ebp
  802c36:	c3                   	ret    
  802c37:	90                   	nop
  802c38:	89 fd                	mov    %edi,%ebp
  802c3a:	85 ff                	test   %edi,%edi
  802c3c:	75 0b                	jne    802c49 <__umoddi3+0xe9>
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	31 d2                	xor    %edx,%edx
  802c45:	f7 f7                	div    %edi
  802c47:	89 c5                	mov    %eax,%ebp
  802c49:	89 f0                	mov    %esi,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 c8                	mov    %ecx,%eax
  802c51:	f7 f5                	div    %ebp
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	e9 44 ff ff ff       	jmp    802b9e <__umoddi3+0x3e>
  802c5a:	66 90                	xchg   %ax,%ax
  802c5c:	89 c8                	mov    %ecx,%eax
  802c5e:	89 f2                	mov    %esi,%edx
  802c60:	83 c4 1c             	add    $0x1c,%esp
  802c63:	5b                   	pop    %ebx
  802c64:	5e                   	pop    %esi
  802c65:	5f                   	pop    %edi
  802c66:	5d                   	pop    %ebp
  802c67:	c3                   	ret    
  802c68:	3b 04 24             	cmp    (%esp),%eax
  802c6b:	72 06                	jb     802c73 <__umoddi3+0x113>
  802c6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c71:	77 0f                	ja     802c82 <__umoddi3+0x122>
  802c73:	89 f2                	mov    %esi,%edx
  802c75:	29 f9                	sub    %edi,%ecx
  802c77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c7b:	89 14 24             	mov    %edx,(%esp)
  802c7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c82:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c86:	8b 14 24             	mov    (%esp),%edx
  802c89:	83 c4 1c             	add    $0x1c,%esp
  802c8c:	5b                   	pop    %ebx
  802c8d:	5e                   	pop    %esi
  802c8e:	5f                   	pop    %edi
  802c8f:	5d                   	pop    %ebp
  802c90:	c3                   	ret    
  802c91:	8d 76 00             	lea    0x0(%esi),%esi
  802c94:	2b 04 24             	sub    (%esp),%eax
  802c97:	19 fa                	sbb    %edi,%edx
  802c99:	89 d1                	mov    %edx,%ecx
  802c9b:	89 c6                	mov    %eax,%esi
  802c9d:	e9 71 ff ff ff       	jmp    802c13 <__umoddi3+0xb3>
  802ca2:	66 90                	xchg   %ax,%ax
  802ca4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802ca8:	72 ea                	jb     802c94 <__umoddi3+0x134>
  802caa:	89 d9                	mov    %ebx,%ecx
  802cac:	e9 62 ff ff ff       	jmp    802c13 <__umoddi3+0xb3>
