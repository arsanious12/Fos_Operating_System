
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 dc 02 00 00       	call   800312 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 2c 80 00       	push   $0x802c80
  80004a:	e8 72 15 00 00       	call   8015c1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 5f 16 00 00       	call   8016c2 <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 84 2c 80 00       	push   $0x802c84
  80006b:	e8 47 05 00 00       	call   8005b7 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c1 2c 80 00       	push   $0x802cc1
  80007b:	e8 37 05 00 00       	call   8005b7 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 cf 2c 80 00       	push   $0x802ccf
  80008b:	e8 27 05 00 00       	call   8005b7 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 e0 2c 80 00       	push   $0x802ce0
  80009b:	e8 17 05 00 00       	call   8005b7 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 ef 2c 80 00       	push   $0x802cef
  8000ab:	e8 07 05 00 00       	call   8005b7 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
		select = getchar() ;
  8000b3:	e8 3d 02 00 00       	call   8002f5 <getchar>
  8000b8:	88 45 f3             	mov    %al,-0xd(%ebp)
		cputchar(select);
  8000bb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	50                   	push   %eax
  8000c3:	e8 0e 02 00 00       	call   8002d6 <cputchar>
  8000c8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	e8 01 02 00 00       	call   8002d6 <cputchar>
  8000d5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8000d8:	e8 ff 15 00 00       	call   8016dc <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 09 2d 80 00       	push   $0x802d09
  8000e9:	e8 d3 14 00 00       	call   8015c1 <smalloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*protType = 0 ;
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == '1') 		*protType = 1 ;
  8000fd:	80 7d f3 31          	cmpb   $0x31,-0xd(%ebp)
  800101:	75 0b                	jne    80010e <_main+0xd6>
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  80010c:	eb 0f                	jmp    80011d <_main+0xe5>
	else if (select == '2') *protType = 2 ;
  80010e:	80 7d f3 32          	cmpb   $0x32,-0xd(%ebp)
  800112:	75 09                	jne    80011d <_main+0xe5>
  800114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

	struct semaphore T, finished, finishedCountMutex;
	struct uspinlock *sT, *sfinishedCountMutex;
	int *numOfFinished ;
	if (*protType == 1)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	8b 00                	mov    (%eax),%eax
  800122:	83 f8 01             	cmp    $0x1,%eax
  800125:	75 44                	jne    80016b <_main+0x133>
	{
		T = create_semaphore("T", 0);
  800127:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	6a 00                	push   $0x0
  80012f:	68 12 2d 80 00       	push   $0x802d12
  800134:	50                   	push   %eax
  800135:	e8 6a 25 00 00       	call   8026a4 <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 14 2d 80 00       	push   $0x802d14
  80014a:	50                   	push   %eax
  80014b:	e8 54 25 00 00       	call   8026a4 <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 1d 2d 80 00       	push   $0x802d1d
  800160:	50                   	push   %eax
  800161:	e8 3e 25 00 00       	call   8026a4 <create_semaphore>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	eb 62                	jmp    8001cd <_main+0x195>
	}
	else if (*protType == 2)
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	83 f8 02             	cmp    $0x2,%eax
  800173:	75 58                	jne    8001cd <_main+0x195>
	{
		sT = smalloc("T", sizeof(struct uspinlock), 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 44                	push   $0x44
  80017c:	68 12 2d 80 00       	push   $0x802d12
  800181:	e8 3b 14 00 00       	call   8015c1 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 12 2d 80 00       	push   $0x802d12
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 79 25 00 00       	call   802717 <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 1d 2d 80 00       	push   $0x802d1d
  8001ad:	e8 0f 14 00 00       	call   8015c1 <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 1d 2d 80 00       	push   $0x802d1d
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 4d 25 00 00       	call   802717 <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 30 2d 80 00       	push   $0x802d30
  8001d9:	e8 e3 13 00 00       	call   8015c1 <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 40 80 00       	mov    0x804020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 3e 2d 80 00       	push   $0x802d3e
  800218:	e8 b0 16 00 00       	call   8018cd <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80022e:	a1 20 40 80 00       	mov    0x804020,%eax
  800233:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 40 80 00       	mov    0x804020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 48 2d 80 00       	push   $0x802d48
  80024e:	e8 7a 16 00 00       	call   8018cd <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 87 16 00 00       	call   8018eb <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 79 16 00 00       	call   8018eb <sys_run_env>
  800272:	83 c4 10             	add    $0x10,%esp

	/*[5] WAIT TILL FINISHING BOTH PROCESSES*/
	if (*protType == 1)
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	75 1c                	jne    80029b <_main+0x263>
	{
		wait_semaphore(finished);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	e8 4e 24 00 00       	call   8026d8 <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 40 24 00 00       	call   8026d8 <wait_semaphore>
  800298:	83 c4 10             	add    $0x10,%esp
	}
	if (*protType == 2)
  80029b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 02             	cmp    $0x2,%eax
  8002a3:	75 0d                	jne    8002b2 <_main+0x27a>
	{
		while (*numOfFinished != 2) ;
  8002a5:	90                   	nop
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	83 f8 02             	cmp    $0x2,%eax
  8002ae:	75 f6                	jne    8002a6 <_main+0x26e>
  8002b0:	eb 0b                	jmp    8002bd <_main+0x285>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8002b2:	90                   	nop
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	83 f8 02             	cmp    $0x2,%eax
  8002bb:	75 f6                	jne    8002b3 <_main+0x27b>
	}

	/*[6] PRINT X*/
	atomic_cprintf("%~Final value of X = %d\n", *X);
  8002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 52 2d 80 00       	push   $0x802d52
  8002cb:	e8 59 03 00 00       	call   800629 <atomic_cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp

	return;
  8002d3:	90                   	nop
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8002e2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	e8 1b 15 00 00       	call   80180a <sys_cputc>
  8002ef:	83 c4 10             	add    $0x10,%esp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <getchar>:


int
getchar(void)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8002fb:	e8 a9 13 00 00       	call   8016a9 <sys_cgetc>
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <iscons>:

int iscons(int fdnum)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80030b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80031b:	e8 1b 16 00 00       	call   80193b <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	c1 e0 06             	shl    $0x6,%eax
  80032b:	29 d0                	sub    %edx,%eax
  80032d:	c1 e0 02             	shl    $0x2,%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800339:	01 c8                	add    %ecx,%eax
  80033b:	c1 e0 03             	shl    $0x3,%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800347:	29 c2                	sub    %eax,%edx
  800349:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800350:	89 c2                	mov    %eax,%edx
  800352:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800358:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8a 40 20             	mov    0x20(%eax),%al
  800365:	84 c0                	test   %al,%al
  800367:	74 0d                	je     800376 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800369:	a1 20 40 80 00       	mov    0x804020,%eax
  80036e:	83 c0 20             	add    $0x20,%eax
  800371:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80037a:	7e 0a                	jle    800386 <libmain+0x74>
		binaryname = argv[0];
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	ff 75 0c             	pushl  0xc(%ebp)
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 a4 fc ff ff       	call   800038 <_main>
  800394:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800397:	a1 00 40 80 00       	mov    0x804000,%eax
  80039c:	85 c0                	test   %eax,%eax
  80039e:	0f 84 01 01 00 00    	je     8004a5 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003a4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003aa:	bb 64 2e 80 00       	mov    $0x802e64,%ebx
  8003af:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003b4:	89 c7                	mov    %eax,%edi
  8003b6:	89 de                	mov    %ebx,%esi
  8003b8:	89 d1                	mov    %edx,%ecx
  8003ba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003bc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003bf:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003c4:	b0 00                	mov    $0x0,%al
  8003c6:	89 d7                	mov    %edx,%edi
  8003c8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	50                   	push   %eax
  8003d8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003de:	50                   	push   %eax
  8003df:	e8 8d 17 00 00       	call   801b71 <sys_utilities>
  8003e4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003e7:	e8 d6 12 00 00       	call   8016c2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	68 84 2d 80 00       	push   $0x802d84
  8003f4:	e8 be 01 00 00       	call   8005b7 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ff:	85 c0                	test   %eax,%eax
  800401:	74 18                	je     80041b <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800403:	e8 87 17 00 00       	call   801b8f <sys_get_optimal_num_faults>
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	50                   	push   %eax
  80040c:	68 ac 2d 80 00       	push   $0x802dac
  800411:	e8 a1 01 00 00       	call   8005b7 <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
  800419:	eb 59                	jmp    800474 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80041b:	a1 20 40 80 00       	mov    0x804020,%eax
  800420:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800426:	a1 20 40 80 00       	mov    0x804020,%eax
  80042b:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	52                   	push   %edx
  800435:	50                   	push   %eax
  800436:	68 d0 2d 80 00       	push   $0x802dd0
  80043b:	e8 77 01 00 00       	call   8005b7 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800443:	a1 20 40 80 00       	mov    0x804020,%eax
  800448:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80044e:	a1 20 40 80 00       	mov    0x804020,%eax
  800453:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800464:	51                   	push   %ecx
  800465:	52                   	push   %edx
  800466:	50                   	push   %eax
  800467:	68 f8 2d 80 00       	push   $0x802df8
  80046c:	e8 46 01 00 00       	call   8005b7 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800474:	a1 20 40 80 00       	mov    0x804020,%eax
  800479:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	50                   	push   %eax
  800483:	68 50 2e 80 00       	push   $0x802e50
  800488:	e8 2a 01 00 00       	call   8005b7 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800490:	83 ec 0c             	sub    $0xc,%esp
  800493:	68 84 2d 80 00       	push   $0x802d84
  800498:	e8 1a 01 00 00       	call   8005b7 <cprintf>
  80049d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004a0:	e8 37 12 00 00       	call   8016dc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004a5:	e8 1f 00 00 00       	call   8004c9 <exit>
}
  8004aa:	90                   	nop
  8004ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ae:	5b                   	pop    %ebx
  8004af:	5e                   	pop    %esi
  8004b0:	5f                   	pop    %edi
  8004b1:	5d                   	pop    %ebp
  8004b2:	c3                   	ret    

008004b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b9:	83 ec 0c             	sub    $0xc,%esp
  8004bc:	6a 00                	push   $0x0
  8004be:	e8 44 14 00 00       	call   801907 <sys_destroy_env>
  8004c3:	83 c4 10             	add    $0x10,%esp
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <exit>:

void
exit(void)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004cf:	e8 99 14 00 00       	call   80196d <sys_exit_env>
}
  8004d4:	90                   	nop
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	53                   	push   %ebx
  8004db:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e9:	89 0a                	mov    %ecx,(%edx)
  8004eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ee:	88 d1                	mov    %dl,%cl
  8004f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800501:	75 30                	jne    800533 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800503:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800509:	a0 44 40 80 00       	mov    0x804044,%al
  80050e:	0f b6 c0             	movzbl %al,%eax
  800511:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800514:	8b 09                	mov    (%ecx),%ecx
  800516:	89 cb                	mov    %ecx,%ebx
  800518:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051b:	83 c1 08             	add    $0x8,%ecx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	53                   	push   %ebx
  800521:	51                   	push   %ecx
  800522:	e8 57 11 00 00       	call   80167e <sys_cputs>
  800527:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	8b 40 04             	mov    0x4(%eax),%eax
  800539:	8d 50 01             	lea    0x1(%eax),%edx
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800542:	90                   	nop
  800543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800546:	c9                   	leave  
  800547:	c3                   	ret    

00800548 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800551:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800558:	00 00 00 
	b.cnt = 0;
  80055b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800562:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	ff 75 08             	pushl  0x8(%ebp)
  80056b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	68 d7 04 80 00       	push   $0x8004d7
  800577:	e8 5a 02 00 00       	call   8007d6 <vprintfmt>
  80057c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80057f:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800585:	a0 44 40 80 00       	mov    0x804044,%al
  80058a:	0f b6 c0             	movzbl %al,%eax
  80058d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800593:	52                   	push   %edx
  800594:	50                   	push   %eax
  800595:	51                   	push   %ecx
  800596:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059c:	83 c0 08             	add    $0x8,%eax
  80059f:	50                   	push   %eax
  8005a0:	e8 d9 10 00 00       	call   80167e <sys_cputs>
  8005a5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a8:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8005af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8005c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	e8 6f ff ff ff       	call   800548 <vcprintf>
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ea:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	c1 e0 08             	shl    $0x8,%eax
  8005f7:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  8005fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ff:	83 c0 04             	add    $0x4,%eax
  800602:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	ff 75 f4             	pushl  -0xc(%ebp)
  80060e:	50                   	push   %eax
  80060f:	e8 34 ff ff ff       	call   800548 <vcprintf>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80061a:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800621:	07 00 00 

	return cnt;
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062f:	e8 8e 10 00 00       	call   8016c2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800634:	8d 45 0c             	lea    0xc(%ebp),%eax
  800637:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 f4             	pushl  -0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	e8 ff fe ff ff       	call   800548 <vcprintf>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064f:	e8 88 10 00 00       	call   8016dc <sys_unlock_cons>
	return cnt;
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	53                   	push   %ebx
  80065d:	83 ec 14             	sub    $0x14,%esp
  800660:	8b 45 10             	mov    0x10(%ebp),%eax
  800663:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066c:	8b 45 18             	mov    0x18(%ebp),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800677:	77 55                	ja     8006ce <printnum+0x75>
  800679:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067c:	72 05                	jb     800683 <printnum+0x2a>
  80067e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800681:	77 4b                	ja     8006ce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800683:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800686:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800689:	8b 45 18             	mov    0x18(%ebp),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	52                   	push   %edx
  800692:	50                   	push   %eax
  800693:	ff 75 f4             	pushl  -0xc(%ebp)
  800696:	ff 75 f0             	pushl  -0x10(%ebp)
  800699:	e8 72 23 00 00       	call   802a10 <__udivdi3>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	83 ec 04             	sub    $0x4,%esp
  8006a4:	ff 75 20             	pushl  0x20(%ebp)
  8006a7:	53                   	push   %ebx
  8006a8:	ff 75 18             	pushl  0x18(%ebp)
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 08             	pushl  0x8(%ebp)
  8006b3:	e8 a1 ff ff ff       	call   800659 <printnum>
  8006b8:	83 c4 20             	add    $0x20,%esp
  8006bb:	eb 1a                	jmp    8006d7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	ff 75 20             	pushl  0x20(%ebp)
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	ff d0                	call   *%eax
  8006cb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ce:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d5:	7f e6                	jg     8006bd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e5:	53                   	push   %ebx
  8006e6:	51                   	push   %ecx
  8006e7:	52                   	push   %edx
  8006e8:	50                   	push   %eax
  8006e9:	e8 32 24 00 00       	call   802b20 <__umoddi3>
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	05 f4 30 80 00       	add    $0x8030f4,%eax
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f be c0             	movsbl %al,%eax
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	50                   	push   %eax
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
}
  80070a:	90                   	nop
  80070b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800713:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800717:	7e 1c                	jle    800735 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 08             	lea    0x8(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 08             	sub    $0x8,%eax
  80072e:	8b 50 04             	mov    0x4(%eax),%edx
  800731:	8b 00                	mov    (%eax),%eax
  800733:	eb 40                	jmp    800775 <getuint+0x65>
	else if (lflag)
  800735:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800739:	74 1e                	je     800759 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 04             	lea    0x4(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 04             	sub    $0x4,%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	eb 1c                	jmp    800775 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 50 04             	lea    0x4(%eax),%edx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 10                	mov    %edx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	83 e8 04             	sub    $0x4,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80077a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077e:	7e 1c                	jle    80079c <getint+0x25>
		return va_arg(*ap, long long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 08             	lea    0x8(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 08             	sub    $0x8,%eax
  800795:	8b 50 04             	mov    0x4(%eax),%edx
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	eb 38                	jmp    8007d4 <getint+0x5d>
	else if (lflag)
  80079c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a0:	74 1a                	je     8007bc <getint+0x45>
		return va_arg(*ap, long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 04             	lea    0x4(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 04             	sub    $0x4,%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	99                   	cltd   
  8007ba:	eb 18                	jmp    8007d4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	99                   	cltd   
}
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007de:	eb 17                	jmp    8007f7 <vprintfmt+0x21>
			if (ch == '\0')
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	0f 84 c1 03 00 00    	je     800ba9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	53                   	push   %ebx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	83 fb 25             	cmp    $0x25,%ebx
  800808:	75 d6                	jne    8007e0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80080a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800815:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800823:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082a:	8b 45 10             	mov    0x10(%ebp),%eax
  80082d:	8d 50 01             	lea    0x1(%eax),%edx
  800830:	89 55 10             	mov    %edx,0x10(%ebp)
  800833:	8a 00                	mov    (%eax),%al
  800835:	0f b6 d8             	movzbl %al,%ebx
  800838:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083b:	83 f8 5b             	cmp    $0x5b,%eax
  80083e:	0f 87 3d 03 00 00    	ja     800b81 <vprintfmt+0x3ab>
  800844:	8b 04 85 18 31 80 00 	mov    0x803118(,%eax,4),%eax
  80084b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800851:	eb d7                	jmp    80082a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800853:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800857:	eb d1                	jmp    80082a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800859:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800863:	89 d0                	mov    %edx,%eax
  800865:	c1 e0 02             	shl    $0x2,%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d8                	add    %ebx,%eax
  80086e:	83 e8 30             	sub    $0x30,%eax
  800871:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	8a 00                	mov    (%eax),%al
  800879:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087c:	83 fb 2f             	cmp    $0x2f,%ebx
  80087f:	7e 3e                	jle    8008bf <vprintfmt+0xe9>
  800881:	83 fb 39             	cmp    $0x39,%ebx
  800884:	7f 39                	jg     8008bf <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800886:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800889:	eb d5                	jmp    800860 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089f:	eb 1f                	jmp    8008c0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a5:	79 83                	jns    80082a <vprintfmt+0x54>
				width = 0;
  8008a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ae:	e9 77 ff ff ff       	jmp    80082a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ba:	e9 6b ff ff ff       	jmp    80082a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008bf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c4:	0f 89 60 ff ff ff    	jns    80082a <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d7:	e9 4e ff ff ff       	jmp    80082a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008df:	e9 46 ff ff ff       	jmp    80082a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 c0 04             	add    $0x4,%eax
  8008ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
			break;
  800904:	e9 9b 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80091a:	85 db                	test   %ebx,%ebx
  80091c:	79 02                	jns    800920 <vprintfmt+0x14a>
				err = -err;
  80091e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800920:	83 fb 64             	cmp    $0x64,%ebx
  800923:	7f 0b                	jg     800930 <vprintfmt+0x15a>
  800925:	8b 34 9d 60 2f 80 00 	mov    0x802f60(,%ebx,4),%esi
  80092c:	85 f6                	test   %esi,%esi
  80092e:	75 19                	jne    800949 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800930:	53                   	push   %ebx
  800931:	68 05 31 80 00       	push   $0x803105
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 70 02 00 00       	call   800bb1 <printfmt>
  800941:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800944:	e9 5b 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800949:	56                   	push   %esi
  80094a:	68 0e 31 80 00       	push   $0x80310e
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 57 02 00 00       	call   800bb1 <printfmt>
  80095a:	83 c4 10             	add    $0x10,%esp
			break;
  80095d:	e9 42 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 30                	mov    (%eax),%esi
  800973:	85 f6                	test   %esi,%esi
  800975:	75 05                	jne    80097c <vprintfmt+0x1a6>
				p = "(null)";
  800977:	be 11 31 80 00       	mov    $0x803111,%esi
			if (width > 0 && padc != '-')
  80097c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800980:	7e 6d                	jle    8009ef <vprintfmt+0x219>
  800982:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800986:	74 67                	je     8009ef <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	50                   	push   %eax
  80098f:	56                   	push   %esi
  800990:	e8 1e 03 00 00       	call   800cb3 <strnlen>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099b:	eb 16                	jmp    8009b3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	7f e4                	jg     80099d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	eb 34                	jmp    8009ef <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009bf:	74 1c                	je     8009dd <vprintfmt+0x207>
  8009c1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c4:	7e 05                	jle    8009cb <vprintfmt+0x1f5>
  8009c6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c9:	7e 12                	jle    8009dd <vprintfmt+0x207>
					putch('?', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	6a 3f                	push   $0x3f
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	ff d0                	call   *%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	eb 0f                	jmp    8009ec <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	53                   	push   %ebx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ef:	89 f0                	mov    %esi,%eax
  8009f1:	8d 70 01             	lea    0x1(%eax),%esi
  8009f4:	8a 00                	mov    (%eax),%al
  8009f6:	0f be d8             	movsbl %al,%ebx
  8009f9:	85 db                	test   %ebx,%ebx
  8009fb:	74 24                	je     800a21 <vprintfmt+0x24b>
  8009fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a01:	78 b8                	js     8009bb <vprintfmt+0x1e5>
  800a03:	ff 4d e0             	decl   -0x20(%ebp)
  800a06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0a:	79 af                	jns    8009bb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0c:	eb 13                	jmp    800a21 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 20                	push   $0x20
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a25:	7f e7                	jg     800a0e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a27:	e9 78 01 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a32:	8d 45 14             	lea    0x14(%ebp),%eax
  800a35:	50                   	push   %eax
  800a36:	e8 3c fd ff ff       	call   800777 <getint>
  800a3b:	83 c4 10             	add    $0x10,%esp
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4a:	85 d2                	test   %edx,%edx
  800a4c:	79 23                	jns    800a71 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 2d                	push   $0x2d
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a64:	f7 d8                	neg    %eax
  800a66:	83 d2 00             	adc    $0x0,%edx
  800a69:	f7 da                	neg    %edx
  800a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a78:	e9 bc 00 00 00       	jmp    800b39 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 e8             	pushl  -0x18(%ebp)
  800a83:	8d 45 14             	lea    0x14(%ebp),%eax
  800a86:	50                   	push   %eax
  800a87:	e8 84 fc ff ff       	call   800710 <getuint>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9c:	e9 98 00 00 00       	jmp    800b39 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	6a 58                	push   $0x58
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	6a 58                	push   $0x58
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 58                	push   $0x58
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			break;
  800ad1:	e9 ce 00 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	6a 30                	push   $0x30
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	ff d0                	call   *%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 78                	push   $0x78
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 c0 04             	add    $0x4,%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 e8 04             	sub    $0x4,%eax
  800b05:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b11:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b18:	eb 1f                	jmp    800b39 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b20:	8d 45 14             	lea    0x14(%ebp),%eax
  800b23:	50                   	push   %eax
  800b24:	e8 e7 fb ff ff       	call   800710 <getuint>
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b32:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b39:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b40:	83 ec 04             	sub    $0x4,%esp
  800b43:	52                   	push   %edx
  800b44:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b47:	50                   	push   %eax
  800b48:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 00 fb ff ff       	call   800659 <printnum>
  800b59:	83 c4 20             	add    $0x20,%esp
			break;
  800b5c:	eb 46                	jmp    800ba4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	53                   	push   %ebx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			break;
  800b6d:	eb 35                	jmp    800ba4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6f:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800b76:	eb 2c                	jmp    800ba4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b78:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800b7f:	eb 23                	jmp    800ba4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 25                	push   $0x25
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b91:	ff 4d 10             	decl   0x10(%ebp)
  800b94:	eb 03                	jmp    800b99 <vprintfmt+0x3c3>
  800b96:	ff 4d 10             	decl   0x10(%ebp)
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	48                   	dec    %eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3c 25                	cmp    $0x25,%al
  800ba1:	75 f3                	jne    800b96 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba3:	90                   	nop
		}
	}
  800ba4:	e9 35 fc ff ff       	jmp    8007de <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bba:	83 c0 04             	add    $0x4,%eax
  800bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	ff 75 08             	pushl  0x8(%ebp)
  800bcd:	e8 04 fc ff ff       	call   8007d6 <vprintfmt>
  800bd2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd5:	90                   	nop
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8b 40 08             	mov    0x8(%eax),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	8b 10                	mov    (%eax),%edx
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 04             	mov    0x4(%eax),%eax
  800bf5:	39 c2                	cmp    %eax,%edx
  800bf7:	73 12                	jae    800c0b <sprintputch+0x33>
		*b->buf++ = ch;
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	8d 48 01             	lea    0x1(%eax),%ecx
  800c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c04:	89 0a                	mov    %ecx,(%edx)
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	88 10                	mov    %dl,(%eax)
}
  800c0b:	90                   	nop
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c33:	74 06                	je     800c3b <vsnprintf+0x2d>
  800c35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c39:	7f 07                	jg     800c42 <vsnprintf+0x34>
		return -E_INVAL;
  800c3b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c40:	eb 20                	jmp    800c62 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c42:	ff 75 14             	pushl  0x14(%ebp)
  800c45:	ff 75 10             	pushl  0x10(%ebp)
  800c48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4b:	50                   	push   %eax
  800c4c:	68 d8 0b 80 00       	push   $0x800bd8
  800c51:	e8 80 fb ff ff       	call   8007d6 <vprintfmt>
  800c56:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c6a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6d:	83 c0 04             	add    $0x4,%eax
  800c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	ff 75 f4             	pushl  -0xc(%ebp)
  800c79:	50                   	push   %eax
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	ff 75 08             	pushl  0x8(%ebp)
  800c80:	e8 89 ff ff ff       	call   800c0e <vsnprintf>
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9d:	eb 06                	jmp    800ca5 <strlen+0x15>
		n++;
  800c9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 f1                	jne    800c9f <strlen+0xf>
		n++;
	return n;
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc0:	eb 09                	jmp    800ccb <strnlen+0x18>
		n++;
  800cc2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	ff 4d 0c             	decl   0xc(%ebp)
  800ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccf:	74 09                	je     800cda <strnlen+0x27>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	84 c0                	test   %al,%al
  800cd8:	75 e8                	jne    800cc2 <strnlen+0xf>
		n++;
	return n;
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ceb:	90                   	nop
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8d 50 01             	lea    0x1(%eax),%edx
  800cf2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfe:	8a 12                	mov    (%edx),%dl
  800d00:	88 10                	mov    %dl,(%eax)
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	75 e4                	jne    800cec <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d20:	eb 1f                	jmp    800d41 <strncpy+0x34>
		*dst++ = *src;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8a 12                	mov    (%edx),%dl
  800d30:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	84 c0                	test   %al,%al
  800d39:	74 03                	je     800d3e <strncpy+0x31>
			src++;
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3e:	ff 45 fc             	incl   -0x4(%ebp)
  800d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d47:	72 d9                	jb     800d22 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5e:	74 30                	je     800d90 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d60:	eb 16                	jmp    800d78 <strlcpy+0x2a>
			*dst++ = *src++;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d74:	8a 12                	mov    (%edx),%dl
  800d76:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d78:	ff 4d 10             	decl   0x10(%ebp)
  800d7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7f:	74 09                	je     800d8a <strlcpy+0x3c>
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 d8                	jne    800d62 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	29 c2                	sub    %eax,%edx
  800d98:	89 d0                	mov    %edx,%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9f:	eb 06                	jmp    800da7 <strcmp+0xb>
		p++, q++;
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 0e                	je     800dbe <strcmp+0x22>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 10                	mov    (%eax),%dl
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	38 c2                	cmp    %al,%dl
  800dbc:	74 e3                	je     800da1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	0f b6 d0             	movzbl %al,%edx
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f b6 c0             	movzbl %al,%eax
  800dce:	29 c2                	sub    %eax,%edx
  800dd0:	89 d0                	mov    %edx,%eax
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd7:	eb 09                	jmp    800de2 <strncmp+0xe>
		n--, p++, q++;
  800dd9:	ff 4d 10             	decl   0x10(%ebp)
  800ddc:	ff 45 08             	incl   0x8(%ebp)
  800ddf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de6:	74 17                	je     800dff <strncmp+0x2b>
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	84 c0                	test   %al,%al
  800def:	74 0e                	je     800dff <strncmp+0x2b>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 10                	mov    (%eax),%dl
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	38 c2                	cmp    %al,%dl
  800dfd:	74 da                	je     800dd9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e03:	75 07                	jne    800e0c <strncmp+0x38>
		return 0;
  800e05:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0a:	eb 14                	jmp    800e20 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	0f b6 d0             	movzbl %al,%edx
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 c0             	movzbl %al,%eax
  800e1c:	29 c2                	sub    %eax,%edx
  800e1e:	89 d0                	mov    %edx,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2e:	eb 12                	jmp    800e42 <strchr+0x20>
		if (*s == c)
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e38:	75 05                	jne    800e3f <strchr+0x1d>
			return (char *) s;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	eb 11                	jmp    800e50 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	75 e5                	jne    800e30 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5e:	eb 0d                	jmp    800e6d <strfind+0x1b>
		if (*s == c)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e68:	74 0e                	je     800e78 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	84 c0                	test   %al,%al
  800e74:	75 ea                	jne    800e60 <strfind+0xe>
  800e76:	eb 01                	jmp    800e79 <strfind+0x27>
		if (*s == c)
			break;
  800e78:	90                   	nop
	return (char *) s;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e8a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8e:	76 63                	jbe    800ef3 <memset+0x75>
		uint64 data_block = c;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	99                   	cltd   
  800e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e97:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea4:	c1 e0 08             	shl    $0x8,%eax
  800ea7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eaa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb7:	c1 e0 10             	shl    $0x10,%eax
  800eba:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec6:	89 c2                	mov    %eax,%edx
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed3:	eb 18                	jmp    800eed <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed8:	8d 41 08             	lea    0x8(%ecx),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee4:	89 01                	mov    %eax,(%ecx)
  800ee6:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef1:	77 e2                	ja     800ed5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 23                	je     800f1c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eff:	eb 0e                	jmp    800f0f <memset+0x91>
			*p8++ = (uint8)c;
  800f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 e5                	jne    800f01 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f33:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f37:	76 24                	jbe    800f5d <memcpy+0x3c>
		while(n >= 8){
  800f39:	eb 1c                	jmp    800f57 <memcpy+0x36>
			*d64 = *s64;
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	8b 50 04             	mov    0x4(%eax),%edx
  800f41:	8b 00                	mov    (%eax),%eax
  800f43:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f46:	89 01                	mov    %eax,(%ecx)
  800f48:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f4f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f53:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f57:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5b:	77 de                	ja     800f3b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f61:	74 31                	je     800f94 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f6f:	eb 16                	jmp    800f87 <memcpy+0x66>
			*d8++ = *s8++;
  800f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f74:	8d 50 01             	lea    0x1(%eax),%edx
  800f77:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f80:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f90:	85 c0                	test   %eax,%eax
  800f92:	75 dd                	jne    800f71 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	73 50                	jae    801003 <memmove+0x6a>
  800fb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	01 d0                	add    %edx,%eax
  800fbb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbe:	76 43                	jbe    801003 <memmove+0x6a>
		s += n;
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcc:	eb 10                	jmp    800fde <memmove+0x45>
			*--d = *--s;
  800fce:	ff 4d f8             	decl   -0x8(%ebp)
  800fd1:	ff 4d fc             	decl   -0x4(%ebp)
  800fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd7:	8a 10                	mov    (%eax),%dl
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	75 e3                	jne    800fce <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800feb:	eb 23                	jmp    801010 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff0:	8d 50 01             	lea    0x1(%eax),%edx
  800ff3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fff:	8a 12                	mov    (%edx),%dl
  801001:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	8d 50 ff             	lea    -0x1(%eax),%edx
  801009:	89 55 10             	mov    %edx,0x10(%ebp)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	75 dd                	jne    800fed <memmove+0x54>
			*d++ = *s++;

	return dst;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801027:	eb 2a                	jmp    801053 <memcmp+0x3e>
		if (*s1 != *s2)
  801029:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102c:	8a 10                	mov    (%eax),%dl
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	38 c2                	cmp    %al,%dl
  801035:	74 16                	je     80104d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801037:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	0f b6 d0             	movzbl %al,%edx
  80103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 c0             	movzbl %al,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
  80104b:	eb 18                	jmp    801065 <memcmp+0x50>
		s1++, s2++;
  80104d:	ff 45 fc             	incl   -0x4(%ebp)
  801050:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	8d 50 ff             	lea    -0x1(%eax),%edx
  801059:	89 55 10             	mov    %edx,0x10(%ebp)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	75 c9                	jne    801029 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	01 d0                	add    %edx,%eax
  801075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801078:	eb 15                	jmp    80108f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	0f b6 d0             	movzbl %al,%edx
  801082:	8b 45 0c             	mov    0xc(%ebp),%eax
  801085:	0f b6 c0             	movzbl %al,%eax
  801088:	39 c2                	cmp    %eax,%edx
  80108a:	74 0d                	je     801099 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108c:	ff 45 08             	incl   0x8(%ebp)
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801095:	72 e3                	jb     80107a <memfind+0x13>
  801097:	eb 01                	jmp    80109a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801099:	90                   	nop
	return (void *) s;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b3:	eb 03                	jmp    8010b8 <strtol+0x19>
		s++;
  8010b5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 20                	cmp    $0x20,%al
  8010bf:	74 f4                	je     8010b5 <strtol+0x16>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 09                	cmp    $0x9,%al
  8010c8:	74 eb                	je     8010b5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 2b                	cmp    $0x2b,%al
  8010d1:	75 05                	jne    8010d8 <strtol+0x39>
		s++;
  8010d3:	ff 45 08             	incl   0x8(%ebp)
  8010d6:	eb 13                	jmp    8010eb <strtol+0x4c>
	else if (*s == '-')
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 2d                	cmp    $0x2d,%al
  8010df:	75 0a                	jne    8010eb <strtol+0x4c>
		s++, neg = 1;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ef:	74 06                	je     8010f7 <strtol+0x58>
  8010f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f5:	75 20                	jne    801117 <strtol+0x78>
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 30                	cmp    $0x30,%al
  8010fe:	75 17                	jne    801117 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	40                   	inc    %eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 78                	cmp    $0x78,%al
  801108:	75 0d                	jne    801117 <strtol+0x78>
		s += 2, base = 16;
  80110a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801115:	eb 28                	jmp    80113f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111b:	75 15                	jne    801132 <strtol+0x93>
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 30                	cmp    $0x30,%al
  801124:	75 0c                	jne    801132 <strtol+0x93>
		s++, base = 8;
  801126:	ff 45 08             	incl   0x8(%ebp)
  801129:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801130:	eb 0d                	jmp    80113f <strtol+0xa0>
	else if (base == 0)
  801132:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801136:	75 07                	jne    80113f <strtol+0xa0>
		base = 10;
  801138:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 2f                	cmp    $0x2f,%al
  801146:	7e 19                	jle    801161 <strtol+0xc2>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 39                	cmp    $0x39,%al
  80114f:	7f 10                	jg     801161 <strtol+0xc2>
			dig = *s - '0';
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	83 e8 30             	sub    $0x30,%eax
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115f:	eb 42                	jmp    8011a3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 60                	cmp    $0x60,%al
  801168:	7e 19                	jle    801183 <strtol+0xe4>
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 7a                	cmp    $0x7a,%al
  801171:	7f 10                	jg     801183 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f be c0             	movsbl %al,%eax
  80117b:	83 e8 57             	sub    $0x57,%eax
  80117e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801181:	eb 20                	jmp    8011a3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 40                	cmp    $0x40,%al
  80118a:	7e 39                	jle    8011c5 <strtol+0x126>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 5a                	cmp    $0x5a,%al
  801193:	7f 30                	jg     8011c5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f be c0             	movsbl %al,%eax
  80119d:	83 e8 37             	sub    $0x37,%eax
  8011a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	7d 19                	jge    8011c4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ab:	ff 45 08             	incl   0x8(%ebp)
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011bf:	e9 7b ff ff ff       	jmp    80113f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c9:	74 08                	je     8011d3 <strtol+0x134>
		*endptr = (char *) s;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d7:	74 07                	je     8011e0 <strtol+0x141>
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	f7 d8                	neg    %eax
  8011de:	eb 03                	jmp    8011e3 <strtol+0x144>
  8011e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fd:	79 13                	jns    801212 <ltostr+0x2d>
	{
		neg = 1;
  8011ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121a:	99                   	cltd   
  80121b:	f7 f9                	idiv   %ecx
  80121d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801220:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801223:	8d 50 01             	lea    0x1(%eax),%edx
  801226:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801229:	89 c2                	mov    %eax,%edx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	01 d0                	add    %edx,%eax
  801230:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801233:	83 c2 30             	add    $0x30,%edx
  801236:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801238:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801240:	f7 e9                	imul   %ecx
  801242:	c1 fa 02             	sar    $0x2,%edx
  801245:	89 c8                	mov    %ecx,%eax
  801247:	c1 f8 1f             	sar    $0x1f,%eax
  80124a:	29 c2                	sub    %eax,%edx
  80124c:	89 d0                	mov    %edx,%eax
  80124e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801255:	75 bb                	jne    801212 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	48                   	dec    %eax
  801262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801265:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801269:	74 3d                	je     8012a8 <ltostr+0xc3>
		start = 1 ;
  80126b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801272:	eb 34                	jmp    8012a8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 c2                	add    %eax,%edx
  801289:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c8                	add    %ecx,%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ae:	7c c4                	jl     801274 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	e8 c4 f9 ff ff       	call   800c90 <strlen>
  8012cc:	83 c4 04             	add    $0x4,%esp
  8012cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	e8 b6 f9 ff ff       	call   800c90 <strlen>
  8012da:	83 c4 04             	add    $0x4,%esp
  8012dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ee:	eb 17                	jmp    801307 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 c2                	add    %eax,%edx
  8012f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	01 c8                	add    %ecx,%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801304:	ff 45 fc             	incl   -0x4(%ebp)
  801307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130d:	7c e1                	jl     8012f0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131d:	eb 1f                	jmp    80133e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801328:	89 c2                	mov    %eax,%edx
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
  80132d:	01 c2                	add    %eax,%edx
  80132f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	01 c8                	add    %ecx,%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133b:	ff 45 f8             	incl   -0x8(%ebp)
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c d9                	jl     80131f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801377:	eb 0c                	jmp    801385 <strsplit+0x31>
			*string++ = 0;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8d 50 01             	lea    0x1(%eax),%edx
  80137f:	89 55 08             	mov    %edx,0x8(%ebp)
  801382:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	74 18                	je     8013a6 <strsplit+0x52>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	0f be c0             	movsbl %al,%eax
  801396:	50                   	push   %eax
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	e8 83 fa ff ff       	call   800e22 <strchr>
  80139f:	83 c4 08             	add    $0x8,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	75 d3                	jne    801379 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	84 c0                	test   %al,%al
  8013ad:	74 5a                	je     801409 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	8b 00                	mov    (%eax),%eax
  8013b4:	83 f8 0f             	cmp    $0xf,%eax
  8013b7:	75 07                	jne    8013c0 <strsplit+0x6c>
		{
			return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	eb 66                	jmp    801426 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013cb:	89 0a                	mov    %ecx,(%edx)
  8013cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d7:	01 c2                	add    %eax,%edx
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013de:	eb 03                	jmp    8013e3 <strsplit+0x8f>
			string++;
  8013e0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	74 8b                	je     801377 <strsplit+0x23>
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	0f be c0             	movsbl %al,%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	e8 25 fa ff ff       	call   800e22 <strchr>
  8013fd:	83 c4 08             	add    $0x8,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	74 dc                	je     8013e0 <strsplit+0x8c>
			string++;
	}
  801404:	e9 6e ff ff ff       	jmp    801377 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801409:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140a:	8b 45 14             	mov    0x14(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801421:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143b:	eb 4a                	jmp    801487 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 c8                	add    %ecx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	3c 40                	cmp    $0x40,%al
  80145d:	7e 25                	jle    801484 <str2lower+0x5c>
  80145f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 d0                	add    %edx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 17                	jg     801484 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80146d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	01 ca                	add    %ecx,%edx
  80147d:	8a 12                	mov    (%edx),%dl
  80147f:	83 c2 20             	add    $0x20,%edx
  801482:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801484:	ff 45 fc             	incl   -0x4(%ebp)
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 01 f8 ff ff       	call   800c90 <strlen>
  80148f:	83 c4 04             	add    $0x4,%esp
  801492:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801495:	7f a6                	jg     80143d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	74 42                	je     8014ed <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	68 00 00 00 82       	push   $0x82000000
  8014b3:	68 00 00 00 80       	push   $0x80000000
  8014b8:	e8 00 08 00 00       	call   801cbd <initialize_dynamic_allocator>
  8014bd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014c0:	e8 e7 05 00 00       	call   801aac <sys_get_uheap_strategy>
  8014c5:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8014cf:	05 00 10 00 00       	add    $0x1000,%eax
  8014d4:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014d9:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8014de:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8014e3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8014ea:	00 00 00 
	}
}
  8014ed:	90                   	nop
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	68 06 04 00 00       	push   $0x406
  80150c:	50                   	push   %eax
  80150d:	e8 e4 01 00 00       	call   8016f6 <__sys_allocate_page>
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151c:	79 14                	jns    801532 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	68 88 32 80 00       	push   $0x803288
  801526:	6a 1f                	push   $0x1f
  801528:	68 c4 32 80 00       	push   $0x8032c4
  80152d:	e8 ed 12 00 00       	call   80281f <_panic>
	return 0;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	50                   	push   %eax
  801551:	e8 e7 01 00 00       	call   80173d <__sys_unmap_frame>
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80155c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801560:	79 14                	jns    801576 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	68 d0 32 80 00       	push   $0x8032d0
  80156a:	6a 2a                	push   $0x2a
  80156c:	68 c4 32 80 00       	push   $0x8032c4
  801571:	e8 a9 12 00 00       	call   80281f <_panic>
}
  801576:	90                   	nop
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80157f:	e8 18 ff ff ff       	call   80149c <uheap_init>
	if (size == 0) return NULL ;
  801584:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801588:	75 07                	jne    801591 <malloc+0x18>
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
  80158f:	eb 14                	jmp    8015a5 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 10 33 80 00       	push   $0x803310
  801599:	6a 3e                	push   $0x3e
  80159b:	68 c4 32 80 00       	push   $0x8032c4
  8015a0:	e8 7a 12 00 00       	call   80281f <_panic>
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	68 38 33 80 00       	push   $0x803338
  8015b5:	6a 49                	push   $0x49
  8015b7:	68 c4 32 80 00       	push   $0x8032c4
  8015bc:	e8 5e 12 00 00       	call   80281f <_panic>

008015c1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 18             	sub    $0x18,%esp
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015cd:	e8 ca fe ff ff       	call   80149c <uheap_init>
	if (size == 0) return NULL ;
  8015d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d6:	75 07                	jne    8015df <smalloc+0x1e>
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb 14                	jmp    8015f3 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 5c 33 80 00       	push   $0x80335c
  8015e7:	6a 5a                	push   $0x5a
  8015e9:	68 c4 32 80 00       	push   $0x8032c4
  8015ee:	e8 2c 12 00 00       	call   80281f <_panic>
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015fb:	e8 9c fe ff ff       	call   80149c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 84 33 80 00       	push   $0x803384
  801608:	6a 6a                	push   $0x6a
  80160a:	68 c4 32 80 00       	push   $0x8032c4
  80160f:	e8 0b 12 00 00       	call   80281f <_panic>

00801614 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80161a:	e8 7d fe ff ff       	call   80149c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80161f:	83 ec 04             	sub    $0x4,%esp
  801622:	68 a8 33 80 00       	push   $0x8033a8
  801627:	68 88 00 00 00       	push   $0x88
  80162c:	68 c4 32 80 00       	push   $0x8032c4
  801631:	e8 e9 11 00 00       	call   80281f <_panic>

00801636 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 d0 33 80 00       	push   $0x8033d0
  801644:	68 9b 00 00 00       	push   $0x9b
  801649:	68 c4 32 80 00       	push   $0x8032c4
  80164e:	e8 cc 11 00 00       	call   80281f <_panic>

00801653 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	57                   	push   %edi
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801665:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801668:	8b 7d 18             	mov    0x18(%ebp),%edi
  80166b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80166e:	cd 30                	int    $0x30
  801670:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801673:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	5b                   	pop    %ebx
  80167a:	5e                   	pop    %esi
  80167b:	5f                   	pop    %edi
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80168a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	51                   	push   %ecx
  801697:	52                   	push   %edx
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	50                   	push   %eax
  80169c:	6a 00                	push   $0x0
  80169e:	e8 b0 ff ff ff       	call   801653 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 02                	push   $0x2
  8016b8:	e8 96 ff ff ff       	call   801653 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 03                	push   $0x3
  8016d1:	e8 7d ff ff ff       	call   801653 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	90                   	nop
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 04                	push   $0x4
  8016eb:	e8 63 ff ff ff       	call   801653 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	90                   	nop
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	52                   	push   %edx
  801706:	50                   	push   %eax
  801707:	6a 08                	push   $0x8
  801709:	e8 45 ff ff ff       	call   801653 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801718:	8b 75 18             	mov    0x18(%ebp),%esi
  80171b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801721:	8b 55 0c             	mov    0xc(%ebp),%edx
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
  801729:	51                   	push   %ecx
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	6a 09                	push   $0x9
  80172e:	e8 20 ff ff ff       	call   801653 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	ff 75 08             	pushl  0x8(%ebp)
  80174b:	6a 0a                	push   $0xa
  80174d:	e8 01 ff ff ff       	call   801653 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	6a 0b                	push   $0xb
  801768:	e8 e6 fe ff ff       	call   801653 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 0c                	push   $0xc
  801781:	e8 cd fe ff ff       	call   801653 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 0d                	push   $0xd
  80179a:	e8 b4 fe ff ff       	call   801653 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 0e                	push   $0xe
  8017b3:	e8 9b fe ff ff       	call   801653 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 0f                	push   $0xf
  8017cc:	e8 82 fe ff ff       	call   801653 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	ff 75 08             	pushl  0x8(%ebp)
  8017e4:	6a 10                	push   $0x10
  8017e6:	e8 68 fe ff ff       	call   801653 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 11                	push   $0x11
  8017ff:	e8 4f fe ff ff       	call   801653 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_cputc>:

void
sys_cputc(const char c)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801816:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	50                   	push   %eax
  801823:	6a 01                	push   $0x1
  801825:	e8 29 fe ff ff       	call   801653 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	90                   	nop
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 14                	push   $0x14
  80183f:	e8 0f fe ff ff       	call   801653 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	90                   	nop
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	8b 45 10             	mov    0x10(%ebp),%eax
  801853:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801856:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801859:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	51                   	push   %ecx
  801863:	52                   	push   %edx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	50                   	push   %eax
  801868:	6a 15                	push   $0x15
  80186a:	e8 e4 fd ff ff       	call   801653 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	52                   	push   %edx
  801884:	50                   	push   %eax
  801885:	6a 16                	push   $0x16
  801887:	e8 c7 fd ff ff       	call   801653 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801894:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	51                   	push   %ecx
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 17                	push   $0x17
  8018a6:	e8 a8 fd ff ff       	call   801653 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	52                   	push   %edx
  8018c0:	50                   	push   %eax
  8018c1:	6a 18                	push   $0x18
  8018c3:	e8 8b fd ff ff       	call   801653 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 14             	pushl  0x14(%ebp)
  8018d8:	ff 75 10             	pushl  0x10(%ebp)
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	50                   	push   %eax
  8018df:	6a 19                	push   $0x19
  8018e1:	e8 6d fd ff ff       	call   801653 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	50                   	push   %eax
  8018fa:	6a 1a                	push   $0x1a
  8018fc:	e8 52 fd ff ff       	call   801653 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	90                   	nop
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	50                   	push   %eax
  801916:	6a 1b                	push   $0x1b
  801918:	e8 36 fd ff ff       	call   801653 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 05                	push   $0x5
  801931:	e8 1d fd ff ff       	call   801653 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 06                	push   $0x6
  80194a:	e8 04 fd ff ff       	call   801653 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 07                	push   $0x7
  801963:	e8 eb fc ff ff       	call   801653 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_exit_env>:


void sys_exit_env(void)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 1c                	push   $0x1c
  80197c:	e8 d2 fc ff ff       	call   801653 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801990:	8d 50 04             	lea    0x4(%eax),%edx
  801993:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 1d                	push   $0x1d
  8019a0:	e8 ae fc ff ff       	call   801653 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b1:	89 01                	mov    %eax,(%ecx)
  8019b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	c9                   	leave  
  8019ba:	c2 04 00             	ret    $0x4

008019bd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 13                	push   $0x13
  8019cf:	e8 7f fc ff ff       	call   801653 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_rcr2>:
uint32 sys_rcr2()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 1e                	push   $0x1e
  8019e9:	e8 65 fc ff ff       	call   801653 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	50                   	push   %eax
  801a0c:	6a 1f                	push   $0x1f
  801a0e:	e8 40 fc ff ff       	call   801653 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return ;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <rsttst>:
void rsttst()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 21                	push   $0x21
  801a28:	e8 26 fc ff ff       	call   801653 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801a42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 20                	push   $0x20
  801a53:	e8 fb fb ff ff       	call   801653 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <chktst>:
void chktst(uint32 n)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	6a 22                	push   $0x22
  801a6e:	e8 e0 fb ff ff       	call   801653 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
	return ;
  801a76:	90                   	nop
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <inctst>:

void inctst()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 23                	push   $0x23
  801a88:	e8 c6 fb ff ff       	call   801653 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <gettst>:
uint32 gettst()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 24                	push   $0x24
  801aa2:	e8 ac fb ff ff       	call   801653 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 25                	push   $0x25
  801abb:	e8 93 fb ff ff       	call   801653 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
  801ac3:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801ac8:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 26                	push   $0x26
  801ae7:	e8 67 fb ff ff       	call   801653 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801af6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	53                   	push   %ebx
  801b05:	51                   	push   %ecx
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 27                	push   $0x27
  801b0a:	e8 44 fb ff ff       	call   801653 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 28                	push   $0x28
  801b2a:	e8 24 fb ff ff       	call   801653 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	51                   	push   %ecx
  801b43:	ff 75 10             	pushl  0x10(%ebp)
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 29                	push   $0x29
  801b4a:	e8 04 fb ff ff       	call   801653 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	ff 75 10             	pushl  0x10(%ebp)
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	6a 12                	push   $0x12
  801b66:	e8 e8 fa ff ff       	call   801653 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6e:	90                   	nop
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	52                   	push   %edx
  801b81:	50                   	push   %eax
  801b82:	6a 2a                	push   $0x2a
  801b84:	e8 ca fa ff ff       	call   801653 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
	return;
  801b8c:	90                   	nop
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 2b                	push   $0x2b
  801b9e:	e8 b0 fa ff ff       	call   801653 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 2d                	push   $0x2d
  801bb9:	e8 95 fa ff ff       	call   801653 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	ff 75 08             	pushl  0x8(%ebp)
  801bd3:	6a 2c                	push   $0x2c
  801bd5:	e8 79 fa ff ff       	call   801653 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdd:	90                   	nop
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 f4 33 80 00       	push   $0x8033f4
  801bee:	68 25 01 00 00       	push   $0x125
  801bf3:	68 27 34 80 00       	push   $0x803427
  801bf8:	e8 22 0c 00 00       	call   80281f <_panic>

00801bfd <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801c03:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801c0a:	72 09                	jb     801c15 <to_page_va+0x18>
  801c0c:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801c13:	72 14                	jb     801c29 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	68 38 34 80 00       	push   $0x803438
  801c1d:	6a 15                	push   $0x15
  801c1f:	68 63 34 80 00       	push   $0x803463
  801c24:	e8 f6 0b 00 00       	call   80281f <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	ba 60 40 80 00       	mov    $0x804060,%edx
  801c31:	29 d0                	sub    %edx,%eax
  801c33:	c1 f8 02             	sar    $0x2,%eax
  801c36:	89 c2                	mov    %eax,%edx
  801c38:	89 d0                	mov    %edx,%eax
  801c3a:	c1 e0 02             	shl    $0x2,%eax
  801c3d:	01 d0                	add    %edx,%eax
  801c3f:	c1 e0 02             	shl    $0x2,%eax
  801c42:	01 d0                	add    %edx,%eax
  801c44:	c1 e0 02             	shl    $0x2,%eax
  801c47:	01 d0                	add    %edx,%eax
  801c49:	89 c1                	mov    %eax,%ecx
  801c4b:	c1 e1 08             	shl    $0x8,%ecx
  801c4e:	01 c8                	add    %ecx,%eax
  801c50:	89 c1                	mov    %eax,%ecx
  801c52:	c1 e1 10             	shl    $0x10,%ecx
  801c55:	01 c8                	add    %ecx,%eax
  801c57:	01 c0                	add    %eax,%eax
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	c1 e0 0c             	shl    $0xc,%eax
  801c64:	89 c2                	mov    %eax,%edx
  801c66:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c6b:	01 d0                	add    %edx,%eax
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801c75:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7d:	29 c2                	sub    %eax,%edx
  801c7f:	89 d0                	mov    %edx,%eax
  801c81:	c1 e8 0c             	shr    $0xc,%eax
  801c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8b:	78 09                	js     801c96 <to_page_info+0x27>
  801c8d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c94:	7e 14                	jle    801caa <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 7c 34 80 00       	push   $0x80347c
  801c9e:	6a 22                	push   $0x22
  801ca0:	68 63 34 80 00       	push   $0x803463
  801ca5:	e8 75 0b 00 00       	call   80281f <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	01 c0                	add    %eax,%eax
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	c1 e0 02             	shl    $0x2,%eax
  801cb6:	05 60 40 80 00       	add    $0x804060,%eax
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	05 00 00 00 02       	add    $0x2000000,%eax
  801ccb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cce:	73 16                	jae    801ce6 <initialize_dynamic_allocator+0x29>
  801cd0:	68 a0 34 80 00       	push   $0x8034a0
  801cd5:	68 c6 34 80 00       	push   $0x8034c6
  801cda:	6a 34                	push   $0x34
  801cdc:	68 63 34 80 00       	push   $0x803463
  801ce1:	e8 39 0b 00 00       	call   80281f <_panic>
		is_initialized = 1;
  801ce6:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801ced:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfb:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801d00:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801d07:	00 00 00 
  801d0a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801d11:	00 00 00 
  801d14:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801d1b:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d21:	2b 45 08             	sub    0x8(%ebp),%eax
  801d24:	c1 e8 0c             	shr    $0xc,%eax
  801d27:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d31:	e9 c8 00 00 00       	jmp    801dfe <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	01 c0                	add    %eax,%eax
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	c1 e0 02             	shl    $0x2,%eax
  801d42:	05 68 40 80 00       	add    $0x804068,%eax
  801d47:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	89 d0                	mov    %edx,%eax
  801d51:	01 c0                	add    %eax,%eax
  801d53:	01 d0                	add    %edx,%eax
  801d55:	c1 e0 02             	shl    $0x2,%eax
  801d58:	05 6a 40 80 00       	add    $0x80406a,%eax
  801d5d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801d62:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d68:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d6b:	89 c8                	mov    %ecx,%eax
  801d6d:	01 c0                	add    %eax,%eax
  801d6f:	01 c8                	add    %ecx,%eax
  801d71:	c1 e0 02             	shl    $0x2,%eax
  801d74:	05 64 40 80 00       	add    $0x804064,%eax
  801d79:	89 10                	mov    %edx,(%eax)
  801d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	01 c0                	add    %eax,%eax
  801d82:	01 d0                	add    %edx,%eax
  801d84:	c1 e0 02             	shl    $0x2,%eax
  801d87:	05 64 40 80 00       	add    $0x804064,%eax
  801d8c:	8b 00                	mov    (%eax),%eax
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	74 1b                	je     801dad <initialize_dynamic_allocator+0xf0>
  801d92:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d98:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d9b:	89 c8                	mov    %ecx,%eax
  801d9d:	01 c0                	add    %eax,%eax
  801d9f:	01 c8                	add    %ecx,%eax
  801da1:	c1 e0 02             	shl    $0x2,%eax
  801da4:	05 60 40 80 00       	add    $0x804060,%eax
  801da9:	89 02                	mov    %eax,(%edx)
  801dab:	eb 16                	jmp    801dc3 <initialize_dynamic_allocator+0x106>
  801dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db0:	89 d0                	mov    %edx,%eax
  801db2:	01 c0                	add    %eax,%eax
  801db4:	01 d0                	add    %edx,%eax
  801db6:	c1 e0 02             	shl    $0x2,%eax
  801db9:	05 60 40 80 00       	add    $0x804060,%eax
  801dbe:	a3 48 40 80 00       	mov    %eax,0x804048
  801dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc6:	89 d0                	mov    %edx,%eax
  801dc8:	01 c0                	add    %eax,%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	c1 e0 02             	shl    $0x2,%eax
  801dcf:	05 60 40 80 00       	add    $0x804060,%eax
  801dd4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddc:	89 d0                	mov    %edx,%eax
  801dde:	01 c0                	add    %eax,%eax
  801de0:	01 d0                	add    %edx,%eax
  801de2:	c1 e0 02             	shl    $0x2,%eax
  801de5:	05 60 40 80 00       	add    $0x804060,%eax
  801dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801df0:	a1 54 40 80 00       	mov    0x804054,%eax
  801df5:	40                   	inc    %eax
  801df6:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801dfb:	ff 45 f4             	incl   -0xc(%ebp)
  801dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e01:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e04:	0f 8c 2c ff ff ff    	jl     801d36 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e11:	eb 36                	jmp    801e49 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	c1 e0 04             	shl    $0x4,%eax
  801e19:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e27:	c1 e0 04             	shl    $0x4,%eax
  801e2a:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e38:	c1 e0 04             	shl    $0x4,%eax
  801e3b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e46:	ff 45 f0             	incl   -0x10(%ebp)
  801e49:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801e4d:	7e c4                	jle    801e13 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	50                   	push   %eax
  801e5f:	e8 0b fe ff ff       	call   801c6f <to_page_info>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	8b 40 08             	mov    0x8(%eax),%eax
  801e70:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	e8 77 fd ff ff       	call   801bfd <to_page_va>
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801e8c:	b8 00 10 00 00       	mov    $0x1000,%eax
  801e91:	ba 00 00 00 00       	mov    $0x0,%edx
  801e96:	f7 75 08             	divl   0x8(%ebp)
  801e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	50                   	push   %eax
  801ea3:	e8 48 f6 ff ff       	call   8014f0 <get_page>
  801ea8:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801ebf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801ec6:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801ecd:	eb 19                	jmp    801ee8 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	ba 01 00 00 00       	mov    $0x1,%edx
  801ed7:	88 c1                	mov    %al,%cl
  801ed9:	d3 e2                	shl    %cl,%edx
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ee0:	74 0e                	je     801ef0 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801ee2:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801ee5:	ff 45 f0             	incl   -0x10(%ebp)
  801ee8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801eec:	7e e1                	jle    801ecf <split_page_to_blocks+0x5a>
  801eee:	eb 01                	jmp    801ef1 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801ef0:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801ef1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ef8:	e9 a7 00 00 00       	jmp    801fa4 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f00:	0f af 45 08          	imul   0x8(%ebp),%eax
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f09:	01 d0                	add    %edx,%eax
  801f0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801f0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f12:	75 14                	jne    801f28 <split_page_to_blocks+0xb3>
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 dc 34 80 00       	push   $0x8034dc
  801f1c:	6a 7c                	push   $0x7c
  801f1e:	68 63 34 80 00       	push   $0x803463
  801f23:	e8 f7 08 00 00       	call   80281f <_panic>
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	c1 e0 04             	shl    $0x4,%eax
  801f2e:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f33:	8b 10                	mov    (%eax),%edx
  801f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f38:	89 50 04             	mov    %edx,0x4(%eax)
  801f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3e:	8b 40 04             	mov    0x4(%eax),%eax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	74 14                	je     801f59 <split_page_to_blocks+0xe4>
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	c1 e0 04             	shl    $0x4,%eax
  801f4b:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f55:	89 10                	mov    %edx,(%eax)
  801f57:	eb 11                	jmp    801f6a <split_page_to_blocks+0xf5>
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	c1 e0 04             	shl    $0x4,%eax
  801f5f:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801f65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f68:	89 02                	mov    %eax,(%edx)
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	c1 e0 04             	shl    $0x4,%eax
  801f70:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f79:	89 02                	mov    %eax,(%edx)
  801f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	c1 e0 04             	shl    $0x4,%eax
  801f8a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f8f:	8b 00                	mov    (%eax),%eax
  801f91:	8d 50 01             	lea    0x1(%eax),%edx
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	c1 e0 04             	shl    $0x4,%eax
  801f9a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f9f:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801fa1:	ff 45 ec             	incl   -0x14(%ebp)
  801fa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fa7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801faa:	0f 82 4d ff ff ff    	jb     801efd <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801fb0:	90                   	nop
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801fb9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801fc0:	76 19                	jbe    801fdb <alloc_block+0x28>
  801fc2:	68 00 35 80 00       	push   $0x803500
  801fc7:	68 c6 34 80 00       	push   $0x8034c6
  801fcc:	68 8a 00 00 00       	push   $0x8a
  801fd1:	68 63 34 80 00       	push   $0x803463
  801fd6:	e8 44 08 00 00       	call   80281f <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801fe2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801fe9:	eb 19                	jmp    802004 <alloc_block+0x51>
		if((1 << i) >= size) break;
  801feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fee:	ba 01 00 00 00       	mov    $0x1,%edx
  801ff3:	88 c1                	mov    %al,%cl
  801ff5:	d3 e2                	shl    %cl,%edx
  801ff7:	89 d0                	mov    %edx,%eax
  801ff9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ffc:	73 0e                	jae    80200c <alloc_block+0x59>
		idx++;
  801ffe:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802001:	ff 45 f0             	incl   -0x10(%ebp)
  802004:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802008:	7e e1                	jle    801feb <alloc_block+0x38>
  80200a:	eb 01                	jmp    80200d <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80200c:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	c1 e0 04             	shl    $0x4,%eax
  802013:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802018:	8b 00                	mov    (%eax),%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	0f 84 df 00 00 00    	je     802101 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	c1 e0 04             	shl    $0x4,%eax
  802028:	05 80 c0 81 00       	add    $0x81c080,%eax
  80202d:	8b 00                	mov    (%eax),%eax
  80202f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802032:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802036:	75 17                	jne    80204f <alloc_block+0x9c>
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 21 35 80 00       	push   $0x803521
  802040:	68 9e 00 00 00       	push   $0x9e
  802045:	68 63 34 80 00       	push   $0x803463
  80204a:	e8 d0 07 00 00       	call   80281f <_panic>
  80204f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802052:	8b 00                	mov    (%eax),%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	74 10                	je     802068 <alloc_block+0xb5>
  802058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802060:	8b 52 04             	mov    0x4(%edx),%edx
  802063:	89 50 04             	mov    %edx,0x4(%eax)
  802066:	eb 14                	jmp    80207c <alloc_block+0xc9>
  802068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206b:	8b 40 04             	mov    0x4(%eax),%eax
  80206e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802071:	c1 e2 04             	shl    $0x4,%edx
  802074:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80207a:	89 02                	mov    %eax,(%edx)
  80207c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207f:	8b 40 04             	mov    0x4(%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 0f                	je     802095 <alloc_block+0xe2>
  802086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802089:	8b 40 04             	mov    0x4(%eax),%eax
  80208c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208f:	8b 12                	mov    (%edx),%edx
  802091:	89 10                	mov    %edx,(%eax)
  802093:	eb 13                	jmp    8020a8 <alloc_block+0xf5>
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802098:	8b 00                	mov    (%eax),%eax
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	c1 e2 04             	shl    $0x4,%edx
  8020a0:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8020a6:	89 02                	mov    %eax,(%edx)
  8020a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	c1 e0 04             	shl    $0x4,%eax
  8020c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	c1 e0 04             	shl    $0x4,%eax
  8020d1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020d6:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8020d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	50                   	push   %eax
  8020df:	e8 8b fb ff ff       	call   801c6f <to_page_info>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8020ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ed:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8020f1:	48                   	dec    %eax
  8020f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f5:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8020f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fc:	e9 bc 02 00 00       	jmp    8023bd <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802101:	a1 54 40 80 00       	mov    0x804054,%eax
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 84 7d 02 00 00    	je     80238b <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80210e:	a1 48 40 80 00       	mov    0x804048,%eax
  802113:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802116:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80211a:	75 17                	jne    802133 <alloc_block+0x180>
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 21 35 80 00       	push   $0x803521
  802124:	68 a9 00 00 00       	push   $0xa9
  802129:	68 63 34 80 00       	push   $0x803463
  80212e:	e8 ec 06 00 00       	call   80281f <_panic>
  802133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 10                	je     80214c <alloc_block+0x199>
  80213c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802144:	8b 52 04             	mov    0x4(%edx),%edx
  802147:	89 50 04             	mov    %edx,0x4(%eax)
  80214a:	eb 0b                	jmp    802157 <alloc_block+0x1a4>
  80214c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80214f:	8b 40 04             	mov    0x4(%eax),%eax
  802152:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215a:	8b 40 04             	mov    0x4(%eax),%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	74 0f                	je     802170 <alloc_block+0x1bd>
  802161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802164:	8b 40 04             	mov    0x4(%eax),%eax
  802167:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80216a:	8b 12                	mov    (%edx),%edx
  80216c:	89 10                	mov    %edx,(%eax)
  80216e:	eb 0a                	jmp    80217a <alloc_block+0x1c7>
  802170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	a3 48 40 80 00       	mov    %eax,0x804048
  80217a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218d:	a1 54 40 80 00       	mov    0x804054,%eax
  802192:	48                   	dec    %eax
  802193:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	83 c0 03             	add    $0x3,%eax
  80219e:	ba 01 00 00 00       	mov    $0x1,%edx
  8021a3:	88 c1                	mov    %al,%cl
  8021a5:	d3 e2                	shl    %cl,%edx
  8021a7:	89 d0                	mov    %edx,%eax
  8021a9:	83 ec 08             	sub    $0x8,%esp
  8021ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021af:	50                   	push   %eax
  8021b0:	e8 c0 fc ff ff       	call   801e75 <split_page_to_blocks>
  8021b5:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	c1 e0 04             	shl    $0x4,%eax
  8021be:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021cc:	75 17                	jne    8021e5 <alloc_block+0x232>
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	68 21 35 80 00       	push   $0x803521
  8021d6:	68 b0 00 00 00       	push   $0xb0
  8021db:	68 63 34 80 00       	push   $0x803463
  8021e0:	e8 3a 06 00 00       	call   80281f <_panic>
  8021e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	74 10                	je     8021fe <alloc_block+0x24b>
  8021ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021f6:	8b 52 04             	mov    0x4(%edx),%edx
  8021f9:	89 50 04             	mov    %edx,0x4(%eax)
  8021fc:	eb 14                	jmp    802212 <alloc_block+0x25f>
  8021fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802201:	8b 40 04             	mov    0x4(%eax),%eax
  802204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802207:	c1 e2 04             	shl    $0x4,%edx
  80220a:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802210:	89 02                	mov    %eax,(%edx)
  802212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802215:	8b 40 04             	mov    0x4(%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 0f                	je     80222b <alloc_block+0x278>
  80221c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221f:	8b 40 04             	mov    0x4(%eax),%eax
  802222:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802225:	8b 12                	mov    (%edx),%edx
  802227:	89 10                	mov    %edx,(%eax)
  802229:	eb 13                	jmp    80223e <alloc_block+0x28b>
  80222b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802233:	c1 e2 04             	shl    $0x4,%edx
  802236:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80223c:	89 02                	mov    %eax,(%edx)
  80223e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	c1 e0 04             	shl    $0x4,%eax
  802257:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80225c:	8b 00                	mov    (%eax),%eax
  80225e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	c1 e0 04             	shl    $0x4,%eax
  802267:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80226c:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80226e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	50                   	push   %eax
  802275:	e8 f5 f9 ff ff       	call   801c6f <to_page_info>
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802283:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802287:	48                   	dec    %eax
  802288:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80228b:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80228f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802292:	e9 26 01 00 00       	jmp    8023bd <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802297:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	c1 e0 04             	shl    $0x4,%eax
  8022a0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	0f 84 dc 00 00 00    	je     80238b <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	c1 e0 04             	shl    $0x4,%eax
  8022b5:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022c3:	75 17                	jne    8022dc <alloc_block+0x329>
  8022c5:	83 ec 04             	sub    $0x4,%esp
  8022c8:	68 21 35 80 00       	push   $0x803521
  8022cd:	68 be 00 00 00       	push   $0xbe
  8022d2:	68 63 34 80 00       	push   $0x803463
  8022d7:	e8 43 05 00 00       	call   80281f <_panic>
  8022dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	74 10                	je     8022f5 <alloc_block+0x342>
  8022e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022ed:	8b 52 04             	mov    0x4(%edx),%edx
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	eb 14                	jmp    802309 <alloc_block+0x356>
  8022f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f8:	8b 40 04             	mov    0x4(%eax),%eax
  8022fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fe:	c1 e2 04             	shl    $0x4,%edx
  802301:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802307:	89 02                	mov    %eax,(%edx)
  802309:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80230c:	8b 40 04             	mov    0x4(%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0f                	je     802322 <alloc_block+0x36f>
  802313:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80231c:	8b 12                	mov    (%edx),%edx
  80231e:	89 10                	mov    %edx,(%eax)
  802320:	eb 13                	jmp    802335 <alloc_block+0x382>
  802322:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	c1 e2 04             	shl    $0x4,%edx
  80232d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802333:	89 02                	mov    %eax,(%edx)
  802335:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	c1 e0 04             	shl    $0x4,%eax
  80234e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	8d 50 ff             	lea    -0x1(%eax),%edx
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	c1 e0 04             	shl    $0x4,%eax
  80235e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802363:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802365:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	50                   	push   %eax
  80236c:	e8 fe f8 ff ff       	call   801c6f <to_page_info>
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802377:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80237a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80237e:	48                   	dec    %eax
  80237f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802382:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802386:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802389:	eb 32                	jmp    8023bd <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80238b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80238f:	77 15                	ja     8023a6 <alloc_block+0x3f3>
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	c1 e0 04             	shl    $0x4,%eax
  802397:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	0f 84 f1 fe ff ff    	je     802297 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 3f 35 80 00       	push   $0x80353f
  8023ae:	68 c8 00 00 00       	push   $0xc8
  8023b3:	68 63 34 80 00       	push   $0x803463
  8023b8:	e8 62 04 00 00       	call   80281f <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c8:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023cd:	39 c2                	cmp    %eax,%edx
  8023cf:	72 0c                	jb     8023dd <free_block+0x1e>
  8023d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d4:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d9:	39 c2                	cmp    %eax,%edx
  8023db:	72 19                	jb     8023f6 <free_block+0x37>
  8023dd:	68 50 35 80 00       	push   $0x803550
  8023e2:	68 c6 34 80 00       	push   $0x8034c6
  8023e7:	68 d7 00 00 00       	push   $0xd7
  8023ec:	68 63 34 80 00       	push   $0x803463
  8023f1:	e8 29 04 00 00       	call   80281f <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	83 ec 0c             	sub    $0xc,%esp
  802402:	50                   	push   %eax
  802403:	e8 67 f8 ff ff       	call   801c6f <to_page_info>
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80240e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	0f b7 c0             	movzwl %ax,%eax
  802417:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80241a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802421:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802428:	eb 19                	jmp    802443 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	ba 01 00 00 00       	mov    $0x1,%edx
  802432:	88 c1                	mov    %al,%cl
  802434:	d3 e2                	shl    %cl,%edx
  802436:	89 d0                	mov    %edx,%eax
  802438:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80243b:	74 0e                	je     80244b <free_block+0x8c>
	        break;
	    idx++;
  80243d:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802440:	ff 45 f0             	incl   -0x10(%ebp)
  802443:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802447:	7e e1                	jle    80242a <free_block+0x6b>
  802449:	eb 01                	jmp    80244c <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80244b:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80244c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802453:	40                   	inc    %eax
  802454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802457:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80245b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80245f:	75 17                	jne    802478 <free_block+0xb9>
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	68 dc 34 80 00       	push   $0x8034dc
  802469:	68 ee 00 00 00       	push   $0xee
  80246e:	68 63 34 80 00       	push   $0x803463
  802473:	e8 a7 03 00 00       	call   80281f <_panic>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c1 e0 04             	shl    $0x4,%eax
  80247e:	05 84 c0 81 00       	add    $0x81c084,%eax
  802483:	8b 10                	mov    (%eax),%edx
  802485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802488:	89 50 04             	mov    %edx,0x4(%eax)
  80248b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 14                	je     8024a9 <free_block+0xea>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	c1 e0 04             	shl    $0x4,%eax
  80249b:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	eb 11                	jmp    8024ba <free_block+0xfb>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	c1 e0 04             	shl    $0x4,%eax
  8024af:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8024b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b8:	89 02                	mov    %eax,(%edx)
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	c1 e0 04             	shl    $0x4,%eax
  8024c0:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8024c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c9:	89 02                	mov    %eax,(%edx)
  8024cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	c1 e0 04             	shl    $0x4,%eax
  8024da:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	8d 50 01             	lea    0x1(%eax),%edx
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	c1 e0 04             	shl    $0x4,%eax
  8024ea:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024ef:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8024f1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fb:	f7 75 e0             	divl   -0x20(%ebp)
  8024fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802504:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802508:	0f b7 c0             	movzwl %ax,%eax
  80250b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80250e:	0f 85 70 01 00 00    	jne    802684 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	ff 75 e4             	pushl  -0x1c(%ebp)
  80251a:	e8 de f6 ff ff       	call   801bfd <to_page_va>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80252c:	e9 b7 00 00 00       	jmp    8025e8 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802531:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802537:	01 d0                	add    %edx,%eax
  802539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80253c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802540:	75 17                	jne    802559 <free_block+0x19a>
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 21 35 80 00       	push   $0x803521
  80254a:	68 f8 00 00 00       	push   $0xf8
  80254f:	68 63 34 80 00       	push   $0x803463
  802554:	e8 c6 02 00 00       	call   80281f <_panic>
  802559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 10                	je     802572 <free_block+0x1b3>
  802562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80256a:	8b 52 04             	mov    0x4(%edx),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	eb 14                	jmp    802586 <free_block+0x1c7>
  802572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	c1 e2 04             	shl    $0x4,%edx
  80257e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802584:	89 02                	mov    %eax,(%edx)
  802586:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802589:	8b 40 04             	mov    0x4(%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 0f                	je     80259f <free_block+0x1e0>
  802590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802599:	8b 12                	mov    (%edx),%edx
  80259b:	89 10                	mov    %edx,(%eax)
  80259d:	eb 13                	jmp    8025b2 <free_block+0x1f3>
  80259f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a7:	c1 e2 04             	shl    $0x4,%edx
  8025aa:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8025b0:	89 02                	mov    %eax,(%edx)
  8025b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	c1 e0 04             	shl    $0x4,%eax
  8025cb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c1 e0 04             	shl    $0x4,%eax
  8025db:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025e0:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e5:	01 45 ec             	add    %eax,-0x14(%ebp)
  8025e8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8025ef:	0f 86 3c ff ff ff    	jbe    802531 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8025f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802607:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80260b:	75 17                	jne    802624 <free_block+0x265>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 dc 34 80 00       	push   $0x8034dc
  802615:	68 fe 00 00 00       	push   $0xfe
  80261a:	68 63 34 80 00       	push   $0x803463
  80261f:	e8 fb 01 00 00       	call   80281f <_panic>
  802624:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80262a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802633:	8b 40 04             	mov    0x4(%eax),%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	74 0c                	je     802646 <free_block+0x287>
  80263a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80263f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802642:	89 10                	mov    %edx,(%eax)
  802644:	eb 08                	jmp    80264e <free_block+0x28f>
  802646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802649:	a3 48 40 80 00       	mov    %eax,0x804048
  80264e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802651:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265f:	a1 54 40 80 00       	mov    0x804054,%eax
  802664:	40                   	inc    %eax
  802665:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802670:	e8 88 f5 ff ff       	call   801bfd <to_page_va>
  802675:	83 c4 10             	add    $0x10,%esp
  802678:	83 ec 0c             	sub    $0xc,%esp
  80267b:	50                   	push   %eax
  80267c:	e8 b8 ee ff ff       	call   801539 <return_page>
  802681:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802684:	90                   	nop
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 88 35 80 00       	push   $0x803588
  802695:	68 11 01 00 00       	push   $0x111
  80269a:	68 63 34 80 00       	push   $0x803463
  80269f:	e8 7b 01 00 00       	call   80281f <_panic>

008026a4 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	68 ac 35 80 00       	push   $0x8035ac
  8026b2:	6a 07                	push   $0x7
  8026b4:	68 db 35 80 00       	push   $0x8035db
  8026b9:	e8 61 01 00 00       	call   80281f <_panic>

008026be <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 ec 35 80 00       	push   $0x8035ec
  8026cc:	6a 0b                	push   $0xb
  8026ce:	68 db 35 80 00       	push   $0x8035db
  8026d3:	e8 47 01 00 00       	call   80281f <_panic>

008026d8 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 18 36 80 00       	push   $0x803618
  8026e6:	6a 10                	push   $0x10
  8026e8:	68 db 35 80 00       	push   $0x8035db
  8026ed:	e8 2d 01 00 00       	call   80281f <_panic>

008026f2 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 48 36 80 00       	push   $0x803648
  802700:	6a 15                	push   $0x15
  802702:	68 db 35 80 00       	push   $0x8035db
  802707:	e8 13 01 00 00       	call   80281f <_panic>

0080270c <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	8b 40 10             	mov    0x10(%eax),%eax
}
  802715:	5d                   	pop    %ebp
  802716:	c3                   	ret    

00802717 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80271d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802721:	74 1c                	je     80273f <init_uspinlock+0x28>
  802723:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  802727:	74 16                	je     80273f <init_uspinlock+0x28>
  802729:	68 78 36 80 00       	push   $0x803678
  80272e:	68 97 36 80 00       	push   $0x803697
  802733:	6a 10                	push   $0x10
  802735:	68 ac 36 80 00       	push   $0x8036ac
  80273a:	e8 e0 00 00 00       	call   80281f <_panic>
	strcpy(lk->name, name);
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	83 c0 04             	add    $0x4,%eax
  802745:	83 ec 08             	sub    $0x8,%esp
  802748:	ff 75 0c             	pushl  0xc(%ebp)
  80274b:	50                   	push   %eax
  80274c:	e8 8e e5 ff ff       	call   800cdf <strcpy>
  802751:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  802754:	b8 01 00 00 00       	mov    $0x1,%eax
  802759:	2b 45 10             	sub    0x10(%ebp),%eax
  80275c:	89 c2                	mov    %eax,%edx
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	89 10                	mov    %edx,(%eax)
}
  802763:	90                   	nop
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80276c:	90                   	nop
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802773:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802783:	f0 87 02             	lock xchg %eax,(%edx)
  802786:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  802789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	75 dd                	jne    80276d <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	8d 48 04             	lea    0x4(%eax),%ecx
  802796:	a1 20 40 80 00       	mov    0x804020,%eax
  80279b:	8d 50 20             	lea    0x20(%eax),%edx
  80279e:	a1 20 40 80 00       	mov    0x804020,%eax
  8027a3:	8b 40 10             	mov    0x10(%eax),%eax
  8027a6:	51                   	push   %ecx
  8027a7:	52                   	push   %edx
  8027a8:	50                   	push   %eax
  8027a9:	68 bc 36 80 00       	push   $0x8036bc
  8027ae:	e8 04 de ff ff       	call   8005b7 <cprintf>
  8027b3:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8027b6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8027bb:	90                   	nop
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	75 18                	jne    8027e5 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	83 c0 04             	add    $0x4,%eax
  8027d3:	50                   	push   %eax
  8027d4:	68 e0 36 80 00       	push   $0x8036e0
  8027d9:	6a 2b                	push   $0x2b
  8027db:	68 ac 36 80 00       	push   $0x8036ac
  8027e0:	e8 3a 00 00 00       	call   80281f <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8027e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	8d 48 04             	lea    0x4(%eax),%ecx
  8027fc:	a1 20 40 80 00       	mov    0x804020,%eax
  802801:	8d 50 20             	lea    0x20(%eax),%edx
  802804:	a1 20 40 80 00       	mov    0x804020,%eax
  802809:	8b 40 10             	mov    0x10(%eax),%eax
  80280c:	51                   	push   %ecx
  80280d:	52                   	push   %edx
  80280e:	50                   	push   %eax
  80280f:	68 00 37 80 00       	push   $0x803700
  802814:	e8 9e dd ff ff       	call   8005b7 <cprintf>
  802819:	83 c4 10             	add    $0x10,%esp
}
  80281c:	90                   	nop
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802825:	8d 45 10             	lea    0x10(%ebp),%eax
  802828:	83 c0 04             	add    $0x4,%eax
  80282b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80282e:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 16                	je     80284d <_panic+0x2e>
		cprintf("%s: ", argv0);
  802837:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80283c:	83 ec 08             	sub    $0x8,%esp
  80283f:	50                   	push   %eax
  802840:	68 24 37 80 00       	push   $0x803724
  802845:	e8 6d dd ff ff       	call   8005b7 <cprintf>
  80284a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80284d:	a1 04 40 80 00       	mov    0x804004,%eax
  802852:	83 ec 0c             	sub    $0xc,%esp
  802855:	ff 75 0c             	pushl  0xc(%ebp)
  802858:	ff 75 08             	pushl  0x8(%ebp)
  80285b:	50                   	push   %eax
  80285c:	68 2c 37 80 00       	push   $0x80372c
  802861:	6a 74                	push   $0x74
  802863:	e8 7c dd ff ff       	call   8005e4 <cprintf_colored>
  802868:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80286b:	8b 45 10             	mov    0x10(%ebp),%eax
  80286e:	83 ec 08             	sub    $0x8,%esp
  802871:	ff 75 f4             	pushl  -0xc(%ebp)
  802874:	50                   	push   %eax
  802875:	e8 ce dc ff ff       	call   800548 <vcprintf>
  80287a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80287d:	83 ec 08             	sub    $0x8,%esp
  802880:	6a 00                	push   $0x0
  802882:	68 54 37 80 00       	push   $0x803754
  802887:	e8 bc dc ff ff       	call   800548 <vcprintf>
  80288c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80288f:	e8 35 dc ff ff       	call   8004c9 <exit>

	// should not return here
	while (1) ;
  802894:	eb fe                	jmp    802894 <_panic+0x75>

00802896 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80289c:	a1 20 40 80 00       	mov    0x804020,%eax
  8028a1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028aa:	39 c2                	cmp    %eax,%edx
  8028ac:	74 14                	je     8028c2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 58 37 80 00       	push   $0x803758
  8028b6:	6a 26                	push   $0x26
  8028b8:	68 a4 37 80 00       	push   $0x8037a4
  8028bd:	e8 5d ff ff ff       	call   80281f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8028c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8028c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028d0:	e9 c5 00 00 00       	jmp    80299a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	01 d0                	add    %edx,%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	75 08                	jne    8028f2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8028ea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8028ed:	e9 a5 00 00 00       	jmp    802997 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8028f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802900:	eb 69                	jmp    80296b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802902:	a1 20 40 80 00       	mov    0x804020,%eax
  802907:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80290d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802910:	89 d0                	mov    %edx,%eax
  802912:	01 c0                	add    %eax,%eax
  802914:	01 d0                	add    %edx,%eax
  802916:	c1 e0 03             	shl    $0x3,%eax
  802919:	01 c8                	add    %ecx,%eax
  80291b:	8a 40 04             	mov    0x4(%eax),%al
  80291e:	84 c0                	test   %al,%al
  802920:	75 46                	jne    802968 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802922:	a1 20 40 80 00       	mov    0x804020,%eax
  802927:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80292d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802930:	89 d0                	mov    %edx,%eax
  802932:	01 c0                	add    %eax,%eax
  802934:	01 d0                	add    %edx,%eax
  802936:	c1 e0 03             	shl    $0x3,%eax
  802939:	01 c8                	add    %ecx,%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802940:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802943:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802948:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	01 c8                	add    %ecx,%eax
  802959:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80295b:	39 c2                	cmp    %eax,%edx
  80295d:	75 09                	jne    802968 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80295f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802966:	eb 15                	jmp    80297d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802968:	ff 45 e8             	incl   -0x18(%ebp)
  80296b:	a1 20 40 80 00       	mov    0x804020,%eax
  802970:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	39 c2                	cmp    %eax,%edx
  80297b:	77 85                	ja     802902 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80297d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802981:	75 14                	jne    802997 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	68 b0 37 80 00       	push   $0x8037b0
  80298b:	6a 3a                	push   $0x3a
  80298d:	68 a4 37 80 00       	push   $0x8037a4
  802992:	e8 88 fe ff ff       	call   80281f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802997:	ff 45 f0             	incl   -0x10(%ebp)
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029a0:	0f 8c 2f ff ff ff    	jl     8028d5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8029a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029b4:	eb 26                	jmp    8029dc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8029b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8029bb:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8029c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	01 c0                	add    %eax,%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	c1 e0 03             	shl    $0x3,%eax
  8029cd:	01 c8                	add    %ecx,%eax
  8029cf:	8a 40 04             	mov    0x4(%eax),%al
  8029d2:	3c 01                	cmp    $0x1,%al
  8029d4:	75 03                	jne    8029d9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8029d6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029d9:	ff 45 e0             	incl   -0x20(%ebp)
  8029dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8029e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ea:	39 c2                	cmp    %eax,%edx
  8029ec:	77 c8                	ja     8029b6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029f4:	74 14                	je     802a0a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 04 38 80 00       	push   $0x803804
  8029fe:	6a 44                	push   $0x44
  802a00:	68 a4 37 80 00       	push   $0x8037a4
  802a05:	e8 15 fe ff ff       	call   80281f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802a0a:	90                   	nop
  802a0b:	c9                   	leave  
  802a0c:	c3                   	ret    
  802a0d:	66 90                	xchg   %ax,%ax
  802a0f:	90                   	nop

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a27:	89 ca                	mov    %ecx,%edx
  802a29:	89 f8                	mov    %edi,%eax
  802a2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a2f:	85 f6                	test   %esi,%esi
  802a31:	75 2d                	jne    802a60 <__udivdi3+0x50>
  802a33:	39 cf                	cmp    %ecx,%edi
  802a35:	77 65                	ja     802a9c <__udivdi3+0x8c>
  802a37:	89 fd                	mov    %edi,%ebp
  802a39:	85 ff                	test   %edi,%edi
  802a3b:	75 0b                	jne    802a48 <__udivdi3+0x38>
  802a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a42:	31 d2                	xor    %edx,%edx
  802a44:	f7 f7                	div    %edi
  802a46:	89 c5                	mov    %eax,%ebp
  802a48:	31 d2                	xor    %edx,%edx
  802a4a:	89 c8                	mov    %ecx,%eax
  802a4c:	f7 f5                	div    %ebp
  802a4e:	89 c1                	mov    %eax,%ecx
  802a50:	89 d8                	mov    %ebx,%eax
  802a52:	f7 f5                	div    %ebp
  802a54:	89 cf                	mov    %ecx,%edi
  802a56:	89 fa                	mov    %edi,%edx
  802a58:	83 c4 1c             	add    $0x1c,%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	39 ce                	cmp    %ecx,%esi
  802a62:	77 28                	ja     802a8c <__udivdi3+0x7c>
  802a64:	0f bd fe             	bsr    %esi,%edi
  802a67:	83 f7 1f             	xor    $0x1f,%edi
  802a6a:	75 40                	jne    802aac <__udivdi3+0x9c>
  802a6c:	39 ce                	cmp    %ecx,%esi
  802a6e:	72 0a                	jb     802a7a <__udivdi3+0x6a>
  802a70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a74:	0f 87 9e 00 00 00    	ja     802b18 <__udivdi3+0x108>
  802a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7f:	89 fa                	mov    %edi,%edx
  802a81:	83 c4 1c             	add    $0x1c,%esp
  802a84:	5b                   	pop    %ebx
  802a85:	5e                   	pop    %esi
  802a86:	5f                   	pop    %edi
  802a87:	5d                   	pop    %ebp
  802a88:	c3                   	ret    
  802a89:	8d 76 00             	lea    0x0(%esi),%esi
  802a8c:	31 ff                	xor    %edi,%edi
  802a8e:	31 c0                	xor    %eax,%eax
  802a90:	89 fa                	mov    %edi,%edx
  802a92:	83 c4 1c             	add    $0x1c,%esp
  802a95:	5b                   	pop    %ebx
  802a96:	5e                   	pop    %esi
  802a97:	5f                   	pop    %edi
  802a98:	5d                   	pop    %ebp
  802a99:	c3                   	ret    
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	89 d8                	mov    %ebx,%eax
  802a9e:	f7 f7                	div    %edi
  802aa0:	31 ff                	xor    %edi,%edi
  802aa2:	89 fa                	mov    %edi,%edx
  802aa4:	83 c4 1c             	add    $0x1c,%esp
  802aa7:	5b                   	pop    %ebx
  802aa8:	5e                   	pop    %esi
  802aa9:	5f                   	pop    %edi
  802aaa:	5d                   	pop    %ebp
  802aab:	c3                   	ret    
  802aac:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ab1:	89 eb                	mov    %ebp,%ebx
  802ab3:	29 fb                	sub    %edi,%ebx
  802ab5:	89 f9                	mov    %edi,%ecx
  802ab7:	d3 e6                	shl    %cl,%esi
  802ab9:	89 c5                	mov    %eax,%ebp
  802abb:	88 d9                	mov    %bl,%cl
  802abd:	d3 ed                	shr    %cl,%ebp
  802abf:	89 e9                	mov    %ebp,%ecx
  802ac1:	09 f1                	or     %esi,%ecx
  802ac3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ac7:	89 f9                	mov    %edi,%ecx
  802ac9:	d3 e0                	shl    %cl,%eax
  802acb:	89 c5                	mov    %eax,%ebp
  802acd:	89 d6                	mov    %edx,%esi
  802acf:	88 d9                	mov    %bl,%cl
  802ad1:	d3 ee                	shr    %cl,%esi
  802ad3:	89 f9                	mov    %edi,%ecx
  802ad5:	d3 e2                	shl    %cl,%edx
  802ad7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802adb:	88 d9                	mov    %bl,%cl
  802add:	d3 e8                	shr    %cl,%eax
  802adf:	09 c2                	or     %eax,%edx
  802ae1:	89 d0                	mov    %edx,%eax
  802ae3:	89 f2                	mov    %esi,%edx
  802ae5:	f7 74 24 0c          	divl   0xc(%esp)
  802ae9:	89 d6                	mov    %edx,%esi
  802aeb:	89 c3                	mov    %eax,%ebx
  802aed:	f7 e5                	mul    %ebp
  802aef:	39 d6                	cmp    %edx,%esi
  802af1:	72 19                	jb     802b0c <__udivdi3+0xfc>
  802af3:	74 0b                	je     802b00 <__udivdi3+0xf0>
  802af5:	89 d8                	mov    %ebx,%eax
  802af7:	31 ff                	xor    %edi,%edi
  802af9:	e9 58 ff ff ff       	jmp    802a56 <__udivdi3+0x46>
  802afe:	66 90                	xchg   %ax,%ax
  802b00:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b04:	89 f9                	mov    %edi,%ecx
  802b06:	d3 e2                	shl    %cl,%edx
  802b08:	39 c2                	cmp    %eax,%edx
  802b0a:	73 e9                	jae    802af5 <__udivdi3+0xe5>
  802b0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b0f:	31 ff                	xor    %edi,%edi
  802b11:	e9 40 ff ff ff       	jmp    802a56 <__udivdi3+0x46>
  802b16:	66 90                	xchg   %ax,%ax
  802b18:	31 c0                	xor    %eax,%eax
  802b1a:	e9 37 ff ff ff       	jmp    802a56 <__udivdi3+0x46>
  802b1f:	90                   	nop

00802b20 <__umoddi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	53                   	push   %ebx
  802b24:	83 ec 1c             	sub    $0x1c,%esp
  802b27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b3f:	89 f3                	mov    %esi,%ebx
  802b41:	89 fa                	mov    %edi,%edx
  802b43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b47:	89 34 24             	mov    %esi,(%esp)
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	75 1a                	jne    802b68 <__umoddi3+0x48>
  802b4e:	39 f7                	cmp    %esi,%edi
  802b50:	0f 86 a2 00 00 00    	jbe    802bf8 <__umoddi3+0xd8>
  802b56:	89 c8                	mov    %ecx,%eax
  802b58:	89 f2                	mov    %esi,%edx
  802b5a:	f7 f7                	div    %edi
  802b5c:	89 d0                	mov    %edx,%eax
  802b5e:	31 d2                	xor    %edx,%edx
  802b60:	83 c4 1c             	add    $0x1c,%esp
  802b63:	5b                   	pop    %ebx
  802b64:	5e                   	pop    %esi
  802b65:	5f                   	pop    %edi
  802b66:	5d                   	pop    %ebp
  802b67:	c3                   	ret    
  802b68:	39 f0                	cmp    %esi,%eax
  802b6a:	0f 87 ac 00 00 00    	ja     802c1c <__umoddi3+0xfc>
  802b70:	0f bd e8             	bsr    %eax,%ebp
  802b73:	83 f5 1f             	xor    $0x1f,%ebp
  802b76:	0f 84 ac 00 00 00    	je     802c28 <__umoddi3+0x108>
  802b7c:	bf 20 00 00 00       	mov    $0x20,%edi
  802b81:	29 ef                	sub    %ebp,%edi
  802b83:	89 fe                	mov    %edi,%esi
  802b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	d3 e0                	shl    %cl,%eax
  802b8d:	89 d7                	mov    %edx,%edi
  802b8f:	89 f1                	mov    %esi,%ecx
  802b91:	d3 ef                	shr    %cl,%edi
  802b93:	09 c7                	or     %eax,%edi
  802b95:	89 e9                	mov    %ebp,%ecx
  802b97:	d3 e2                	shl    %cl,%edx
  802b99:	89 14 24             	mov    %edx,(%esp)
  802b9c:	89 d8                	mov    %ebx,%eax
  802b9e:	d3 e0                	shl    %cl,%eax
  802ba0:	89 c2                	mov    %eax,%edx
  802ba2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ba6:	d3 e0                	shl    %cl,%eax
  802ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bac:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bb0:	89 f1                	mov    %esi,%ecx
  802bb2:	d3 e8                	shr    %cl,%eax
  802bb4:	09 d0                	or     %edx,%eax
  802bb6:	d3 eb                	shr    %cl,%ebx
  802bb8:	89 da                	mov    %ebx,%edx
  802bba:	f7 f7                	div    %edi
  802bbc:	89 d3                	mov    %edx,%ebx
  802bbe:	f7 24 24             	mull   (%esp)
  802bc1:	89 c6                	mov    %eax,%esi
  802bc3:	89 d1                	mov    %edx,%ecx
  802bc5:	39 d3                	cmp    %edx,%ebx
  802bc7:	0f 82 87 00 00 00    	jb     802c54 <__umoddi3+0x134>
  802bcd:	0f 84 91 00 00 00    	je     802c64 <__umoddi3+0x144>
  802bd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bd7:	29 f2                	sub    %esi,%edx
  802bd9:	19 cb                	sbb    %ecx,%ebx
  802bdb:	89 d8                	mov    %ebx,%eax
  802bdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802be1:	d3 e0                	shl    %cl,%eax
  802be3:	89 e9                	mov    %ebp,%ecx
  802be5:	d3 ea                	shr    %cl,%edx
  802be7:	09 d0                	or     %edx,%eax
  802be9:	89 e9                	mov    %ebp,%ecx
  802beb:	d3 eb                	shr    %cl,%ebx
  802bed:	89 da                	mov    %ebx,%edx
  802bef:	83 c4 1c             	add    $0x1c,%esp
  802bf2:	5b                   	pop    %ebx
  802bf3:	5e                   	pop    %esi
  802bf4:	5f                   	pop    %edi
  802bf5:	5d                   	pop    %ebp
  802bf6:	c3                   	ret    
  802bf7:	90                   	nop
  802bf8:	89 fd                	mov    %edi,%ebp
  802bfa:	85 ff                	test   %edi,%edi
  802bfc:	75 0b                	jne    802c09 <__umoddi3+0xe9>
  802bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  802c03:	31 d2                	xor    %edx,%edx
  802c05:	f7 f7                	div    %edi
  802c07:	89 c5                	mov    %eax,%ebp
  802c09:	89 f0                	mov    %esi,%eax
  802c0b:	31 d2                	xor    %edx,%edx
  802c0d:	f7 f5                	div    %ebp
  802c0f:	89 c8                	mov    %ecx,%eax
  802c11:	f7 f5                	div    %ebp
  802c13:	89 d0                	mov    %edx,%eax
  802c15:	e9 44 ff ff ff       	jmp    802b5e <__umoddi3+0x3e>
  802c1a:	66 90                	xchg   %ax,%ax
  802c1c:	89 c8                	mov    %ecx,%eax
  802c1e:	89 f2                	mov    %esi,%edx
  802c20:	83 c4 1c             	add    $0x1c,%esp
  802c23:	5b                   	pop    %ebx
  802c24:	5e                   	pop    %esi
  802c25:	5f                   	pop    %edi
  802c26:	5d                   	pop    %ebp
  802c27:	c3                   	ret    
  802c28:	3b 04 24             	cmp    (%esp),%eax
  802c2b:	72 06                	jb     802c33 <__umoddi3+0x113>
  802c2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c31:	77 0f                	ja     802c42 <__umoddi3+0x122>
  802c33:	89 f2                	mov    %esi,%edx
  802c35:	29 f9                	sub    %edi,%ecx
  802c37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c3b:	89 14 24             	mov    %edx,(%esp)
  802c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c42:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c46:	8b 14 24             	mov    (%esp),%edx
  802c49:	83 c4 1c             	add    $0x1c,%esp
  802c4c:	5b                   	pop    %ebx
  802c4d:	5e                   	pop    %esi
  802c4e:	5f                   	pop    %edi
  802c4f:	5d                   	pop    %ebp
  802c50:	c3                   	ret    
  802c51:	8d 76 00             	lea    0x0(%esi),%esi
  802c54:	2b 04 24             	sub    (%esp),%eax
  802c57:	19 fa                	sbb    %edi,%edx
  802c59:	89 d1                	mov    %edx,%ecx
  802c5b:	89 c6                	mov    %eax,%esi
  802c5d:	e9 71 ff ff ff       	jmp    802bd3 <__umoddi3+0xb3>
  802c62:	66 90                	xchg   %ax,%ax
  802c64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c68:	72 ea                	jb     802c54 <__umoddi3+0x134>
  802c6a:	89 d9                	mov    %ebx,%ecx
  802c6c:	e9 62 ff ff ff       	jmp    802bd3 <__umoddi3+0xb3>
