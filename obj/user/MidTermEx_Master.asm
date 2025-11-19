
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
  800045:	68 60 2c 80 00       	push   $0x802c60
  80004a:	e8 5d 15 00 00       	call   8015ac <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 4a 16 00 00       	call   8016ad <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 64 2c 80 00       	push   $0x802c64
  80006b:	e8 32 05 00 00       	call   8005a2 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a1 2c 80 00       	push   $0x802ca1
  80007b:	e8 22 05 00 00       	call   8005a2 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 af 2c 80 00       	push   $0x802caf
  80008b:	e8 12 05 00 00       	call   8005a2 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 c0 2c 80 00       	push   $0x802cc0
  80009b:	e8 02 05 00 00       	call   8005a2 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 cf 2c 80 00       	push   $0x802ccf
  8000ab:	e8 f2 04 00 00       	call   8005a2 <cprintf>
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
  8000d8:	e8 ea 15 00 00       	call   8016c7 <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 e9 2c 80 00       	push   $0x802ce9
  8000e9:	e8 be 14 00 00       	call   8015ac <smalloc>
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
  80012f:	68 f2 2c 80 00       	push   $0x802cf2
  800134:	50                   	push   %eax
  800135:	e8 55 25 00 00       	call   80268f <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 f4 2c 80 00       	push   $0x802cf4
  80014a:	50                   	push   %eax
  80014b:	e8 3f 25 00 00       	call   80268f <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 fd 2c 80 00       	push   $0x802cfd
  800160:	50                   	push   %eax
  800161:	e8 29 25 00 00       	call   80268f <create_semaphore>
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
  80017c:	68 f2 2c 80 00       	push   $0x802cf2
  800181:	e8 26 14 00 00       	call   8015ac <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 f2 2c 80 00       	push   $0x802cf2
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 64 25 00 00       	call   802702 <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 fd 2c 80 00       	push   $0x802cfd
  8001ad:	e8 fa 13 00 00       	call   8015ac <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 fd 2c 80 00       	push   $0x802cfd
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 38 25 00 00       	call   802702 <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 10 2d 80 00       	push   $0x802d10
  8001d9:	e8 ce 13 00 00       	call   8015ac <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 40 80 00       	mov    0x804020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 1e 2d 80 00       	push   $0x802d1e
  800218:	e8 9b 16 00 00       	call   8018b8 <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80022e:	a1 20 40 80 00       	mov    0x804020,%eax
  800233:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 40 80 00       	mov    0x804020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 28 2d 80 00       	push   $0x802d28
  80024e:	e8 65 16 00 00       	call   8018b8 <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 72 16 00 00       	call   8018d6 <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 64 16 00 00       	call   8018d6 <sys_run_env>
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
  800285:	e8 39 24 00 00       	call   8026c3 <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 2b 24 00 00       	call   8026c3 <wait_semaphore>
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
  8002c6:	68 32 2d 80 00       	push   $0x802d32
  8002cb:	e8 44 03 00 00       	call   800614 <atomic_cprintf>
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
  8002ea:	e8 06 15 00 00       	call   8017f5 <sys_cputc>
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
  8002fb:	e8 94 13 00 00       	call   801694 <sys_cgetc>
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
  80031b:	e8 06 16 00 00       	call   801926 <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	c1 e0 03             	shl    $0x3,%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800339:	01 d0                	add    %edx,%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800343:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800348:	a1 20 40 80 00       	mov    0x804020,%eax
  80034d:	8a 40 20             	mov    0x20(%eax),%al
  800350:	84 c0                	test   %al,%al
  800352:	74 0d                	je     800361 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800354:	a1 20 40 80 00       	mov    0x804020,%eax
  800359:	83 c0 20             	add    $0x20,%eax
  80035c:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800365:	7e 0a                	jle    800371 <libmain+0x5f>
		binaryname = argv[0];
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 b9 fc ff ff       	call   800038 <_main>
  80037f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800382:	a1 00 40 80 00       	mov    0x804000,%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	0f 84 01 01 00 00    	je     800490 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	bb 44 2e 80 00       	mov    $0x802e44,%ebx
  80039a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	89 de                	mov    %ebx,%esi
  8003a3:	89 d1                	mov    %edx,%ecx
  8003a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003af:	b0 00                	mov    $0x0,%al
  8003b1:	89 d7                	mov    %edx,%edi
  8003b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c9:	50                   	push   %eax
  8003ca:	e8 8d 17 00 00       	call   801b5c <sys_utilities>
  8003cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003d2:	e8 d6 12 00 00       	call   8016ad <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 64 2d 80 00       	push   $0x802d64
  8003df:	e8 be 01 00 00       	call   8005a2 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	74 18                	je     800406 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ee:	e8 87 17 00 00       	call   801b7a <sys_get_optimal_num_faults>
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 8c 2d 80 00       	push   $0x802d8c
  8003fc:	e8 a1 01 00 00       	call   8005a2 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	eb 59                	jmp    80045f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800406:	a1 20 40 80 00       	mov    0x804020,%eax
  80040b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800411:	a1 20 40 80 00       	mov    0x804020,%eax
  800416:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	52                   	push   %edx
  800420:	50                   	push   %eax
  800421:	68 b0 2d 80 00       	push   $0x802db0
  800426:	e8 77 01 00 00       	call   8005a2 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042e:	a1 20 40 80 00       	mov    0x804020,%eax
  800433:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800439:	a1 20 40 80 00       	mov    0x804020,%eax
  80043e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80044f:	51                   	push   %ecx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	68 d8 2d 80 00       	push   $0x802dd8
  800457:	e8 46 01 00 00       	call   8005a2 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045f:	a1 20 40 80 00       	mov    0x804020,%eax
  800464:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	50                   	push   %eax
  80046e:	68 30 2e 80 00       	push   $0x802e30
  800473:	e8 2a 01 00 00       	call   8005a2 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	68 64 2d 80 00       	push   $0x802d64
  800483:	e8 1a 01 00 00       	call   8005a2 <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80048b:	e8 37 12 00 00       	call   8016c7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800490:	e8 1f 00 00 00       	call   8004b4 <exit>
}
  800495:	90                   	nop
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	6a 00                	push   $0x0
  8004a9:	e8 44 14 00 00       	call   8018f2 <sys_destroy_env>
  8004ae:	83 c4 10             	add    $0x10,%esp
}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <exit>:

void
exit(void)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ba:	e8 99 14 00 00       	call   801958 <sys_exit_env>
}
  8004bf:	90                   	nop
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d4:	89 0a                	mov    %ecx,(%edx)
  8004d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d9:	88 d1                	mov    %dl,%cl
  8004db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004de:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ec:	75 30                	jne    80051e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ee:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8004f4:	a0 44 40 80 00       	mov    0x804044,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ff:	8b 09                	mov    (%ecx),%ecx
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800506:	83 c1 08             	add    $0x8,%ecx
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	53                   	push   %ebx
  80050c:	51                   	push   %ecx
  80050d:	e8 57 11 00 00       	call   801669 <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 40 04             	mov    0x4(%eax),%eax
  800524:	8d 50 01             	lea    0x1(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052d:	90                   	nop
  80052e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800543:	00 00 00 
	b.cnt = 0;
  800546:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	50                   	push   %eax
  80055d:	68 c2 04 80 00       	push   $0x8004c2
  800562:	e8 5a 02 00 00       	call   8007c1 <vprintfmt>
  800567:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80056a:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800570:	a0 44 40 80 00       	mov    0x804044,%al
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	51                   	push   %ecx
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	83 c0 08             	add    $0x8,%eax
  80058a:	50                   	push   %eax
  80058b:	e8 d9 10 00 00       	call   801669 <sys_cputs>
  800590:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800593:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80059a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a8:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 6f ff ff ff       	call   800533 <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d5:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	c1 e0 08             	shl    $0x8,%eax
  8005e2:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 34 ff ff ff       	call   800533 <vcprintf>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800605:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  80060c:	07 00 00 

	return cnt;
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80061a:	e8 8e 10 00 00       	call   8016ad <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80061f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 f4             	pushl  -0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 ff fe ff ff       	call   800533 <vcprintf>
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80063a:	e8 88 10 00 00       	call   8016c7 <sys_unlock_cons>
	return cnt;
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	53                   	push   %ebx
  800648:	83 ec 14             	sub    $0x14,%esp
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800657:	8b 45 18             	mov    0x18(%ebp),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800662:	77 55                	ja     8006b9 <printnum+0x75>
  800664:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800667:	72 05                	jb     80066e <printnum+0x2a>
  800669:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066c:	77 4b                	ja     8006b9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80066e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800671:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800674:	8b 45 18             	mov    0x18(%ebp),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 f4             	pushl  -0xc(%ebp)
  800681:	ff 75 f0             	pushl  -0x10(%ebp)
  800684:	e8 6f 23 00 00       	call   8029f8 <__udivdi3>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	ff 75 20             	pushl  0x20(%ebp)
  800692:	53                   	push   %ebx
  800693:	ff 75 18             	pushl  0x18(%ebp)
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	ff 75 08             	pushl  0x8(%ebp)
  80069e:	e8 a1 ff ff ff       	call   800644 <printnum>
  8006a3:	83 c4 20             	add    $0x20,%esp
  8006a6:	eb 1a                	jmp    8006c2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 20             	pushl  0x20(%ebp)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	ff d0                	call   *%eax
  8006b6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b9:	ff 4d 1c             	decl   0x1c(%ebp)
  8006bc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c0:	7f e6                	jg     8006a8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d0:	53                   	push   %ebx
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	e8 2f 24 00 00       	call   802b08 <__umoddi3>
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	05 d4 30 80 00       	add    $0x8030d4,%eax
  8006e1:	8a 00                	mov    (%eax),%al
  8006e3:	0f be c0             	movsbl %al,%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800702:	7e 1c                	jle    800720 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 08             	lea    0x8(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 08             	sub    $0x8,%eax
  800719:	8b 50 04             	mov    0x4(%eax),%edx
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	eb 40                	jmp    800760 <getuint+0x65>
	else if (lflag)
  800720:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800724:	74 1e                	je     800744 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	eb 1c                	jmp    800760 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800765:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800769:	7e 1c                	jle    800787 <getint+0x25>
		return va_arg(*ap, long long);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	8d 50 08             	lea    0x8(%eax),%edx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 10                	mov    %edx,(%eax)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	83 e8 08             	sub    $0x8,%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	eb 38                	jmp    8007bf <getint+0x5d>
	else if (lflag)
  800787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078b:	74 1a                	je     8007a7 <getint+0x45>
		return va_arg(*ap, long);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
  8007a5:	eb 18                	jmp    8007bf <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8d 50 04             	lea    0x4(%eax),%edx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 10                	mov    %edx,(%eax)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	99                   	cltd   
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	eb 17                	jmp    8007e2 <vprintfmt+0x21>
			if (ch == '\0')
  8007cb:	85 db                	test   %ebx,%ebx
  8007cd:	0f 84 c1 03 00 00    	je     800b94 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	53                   	push   %ebx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	83 fb 25             	cmp    $0x25,%ebx
  8007f3:	75 d6                	jne    8007cb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800800:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800807:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80080e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8d 50 01             	lea    0x1(%eax),%edx
  80081b:	89 55 10             	mov    %edx,0x10(%ebp)
  80081e:	8a 00                	mov    (%eax),%al
  800820:	0f b6 d8             	movzbl %al,%ebx
  800823:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800826:	83 f8 5b             	cmp    $0x5b,%eax
  800829:	0f 87 3d 03 00 00    	ja     800b6c <vprintfmt+0x3ab>
  80082f:	8b 04 85 f8 30 80 00 	mov    0x8030f8(,%eax,4),%eax
  800836:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800838:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d7                	jmp    800815 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80083e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800842:	eb d1                	jmp    800815 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800844:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084e:	89 d0                	mov    %edx,%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	01 d8                	add    %ebx,%eax
  800859:	83 e8 30             	sub    $0x30,%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8a 00                	mov    (%eax),%al
  800864:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800867:	83 fb 2f             	cmp    $0x2f,%ebx
  80086a:	7e 3e                	jle    8008aa <vprintfmt+0xe9>
  80086c:	83 fb 39             	cmp    $0x39,%ebx
  80086f:	7f 39                	jg     8008aa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800871:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800874:	eb d5                	jmp    80084b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088a:	eb 1f                	jmp    8008ab <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800890:	79 83                	jns    800815 <vprintfmt+0x54>
				width = 0;
  800892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800899:	e9 77 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80089e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a5:	e9 6b ff ff ff       	jmp    800815 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	0f 89 60 ff ff ff    	jns    800815 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c2:	e9 4e ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ca:	e9 46 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	ff d0                	call   *%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 9b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800905:	85 db                	test   %ebx,%ebx
  800907:	79 02                	jns    80090b <vprintfmt+0x14a>
				err = -err;
  800909:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090b:	83 fb 64             	cmp    $0x64,%ebx
  80090e:	7f 0b                	jg     80091b <vprintfmt+0x15a>
  800910:	8b 34 9d 40 2f 80 00 	mov    0x802f40(,%ebx,4),%esi
  800917:	85 f6                	test   %esi,%esi
  800919:	75 19                	jne    800934 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091b:	53                   	push   %ebx
  80091c:	68 e5 30 80 00       	push   $0x8030e5
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 70 02 00 00       	call   800b9c <printfmt>
  80092c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092f:	e9 5b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800934:	56                   	push   %esi
  800935:	68 ee 30 80 00       	push   $0x8030ee
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 08             	pushl  0x8(%ebp)
  800940:	e8 57 02 00 00       	call   800b9c <printfmt>
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 42 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 30                	mov    (%eax),%esi
  80095e:	85 f6                	test   %esi,%esi
  800960:	75 05                	jne    800967 <vprintfmt+0x1a6>
				p = "(null)";
  800962:	be f1 30 80 00       	mov    $0x8030f1,%esi
			if (width > 0 && padc != '-')
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	7e 6d                	jle    8009da <vprintfmt+0x219>
  80096d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800971:	74 67                	je     8009da <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	50                   	push   %eax
  80097a:	56                   	push   %esi
  80097b:	e8 1e 03 00 00       	call   800c9e <strnlen>
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800986:	eb 16                	jmp    80099e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099b:	ff 4d e4             	decl   -0x1c(%ebp)
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7f e4                	jg     800988 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	eb 34                	jmp    8009da <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009aa:	74 1c                	je     8009c8 <vprintfmt+0x207>
  8009ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8009af:	7e 05                	jle    8009b6 <vprintfmt+0x1f5>
  8009b1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b4:	7e 12                	jle    8009c8 <vprintfmt+0x207>
					putch('?', putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	6a 3f                	push   $0x3f
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb 0f                	jmp    8009d7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009da:	89 f0                	mov    %esi,%eax
  8009dc:	8d 70 01             	lea    0x1(%eax),%esi
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	0f be d8             	movsbl %al,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	74 24                	je     800a0c <vprintfmt+0x24b>
  8009e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ec:	78 b8                	js     8009a6 <vprintfmt+0x1e5>
  8009ee:	ff 4d e0             	decl   -0x20(%ebp)
  8009f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f5:	79 af                	jns    8009a6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	eb 13                	jmp    800a0c <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 20                	push   $0x20
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7f e7                	jg     8009f9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a12:	e9 78 01 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a20:	50                   	push   %eax
  800a21:	e8 3c fd ff ff       	call   800762 <getint>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	85 d2                	test   %edx,%edx
  800a37:	79 23                	jns    800a5c <vprintfmt+0x29b>
				putch('-', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 2d                	push   $0x2d
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	f7 d8                	neg    %eax
  800a51:	83 d2 00             	adc    $0x0,%edx
  800a54:	f7 da                	neg    %edx
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 84 fc ff ff       	call   8006fb <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a87:	e9 98 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	6a 58                	push   $0x58
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 58                	push   $0x58
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 58                	push   $0x58
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 ce 00 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 30                	push   $0x30
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 78                	push   $0x78
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b03:	eb 1f                	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0e:	50                   	push   %eax
  800b0f:	e8 e7 fb ff ff       	call   8006fb <getuint>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b24:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	52                   	push   %edx
  800b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 00 fb ff ff       	call   800644 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
			break;
  800b47:	eb 46                	jmp    800b8f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	eb 35                	jmp    800b8f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b5a:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800b61:	eb 2c                	jmp    800b8f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b63:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800b6a:	eb 23                	jmp    800b8f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 25                	push   $0x25
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7c:	ff 4d 10             	decl   0x10(%ebp)
  800b7f:	eb 03                	jmp    800b84 <vprintfmt+0x3c3>
  800b81:	ff 4d 10             	decl   0x10(%ebp)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	48                   	dec    %eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3c 25                	cmp    $0x25,%al
  800b8c:	75 f3                	jne    800b81 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b8e:	90                   	nop
		}
	}
  800b8f:	e9 35 fc ff ff       	jmp    8007c9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b94:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 04 fc ff ff       	call   8007c1 <vprintfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc0:	90                   	nop
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8b 40 08             	mov    0x8(%eax),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 10                	mov    (%eax),%edx
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 04             	mov    0x4(%eax),%eax
  800be0:	39 c2                	cmp    %eax,%edx
  800be2:	73 12                	jae    800bf6 <sprintputch+0x33>
		*b->buf++ = ch;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bef:	89 0a                	mov    %ecx,(%edx)
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
}
  800bf6:	90                   	nop
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	01 d0                	add    %edx,%eax
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c1e:	74 06                	je     800c26 <vsnprintf+0x2d>
  800c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c24:	7f 07                	jg     800c2d <vsnprintf+0x34>
		return -E_INVAL;
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	eb 20                	jmp    800c4d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2d:	ff 75 14             	pushl  0x14(%ebp)
  800c30:	ff 75 10             	pushl  0x10(%ebp)
  800c33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c36:	50                   	push   %eax
  800c37:	68 c3 0b 80 00       	push   $0x800bc3
  800c3c:	e8 80 fb ff ff       	call   8007c1 <vprintfmt>
  800c41:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c47:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c55:	8d 45 10             	lea    0x10(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 89 ff ff ff       	call   800bf9 <vsnprintf>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c88:	eb 06                	jmp    800c90 <strlen+0x15>
		n++;
  800c8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 f1                	jne    800c8a <strlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cab:	eb 09                	jmp    800cb6 <strnlen+0x18>
		n++;
  800cad:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	ff 4d 0c             	decl   0xc(%ebp)
  800cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cba:	74 09                	je     800cc5 <strnlen+0x27>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e8                	jne    800cad <strnlen+0xf>
		n++;
	return n;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd6:	90                   	nop
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 e4                	jne    800cd7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0b:	eb 1f                	jmp    800d2c <strncpy+0x34>
		*dst++ = *src;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	89 55 08             	mov    %edx,0x8(%ebp)
  800d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d19:	8a 12                	mov    (%edx),%dl
  800d1b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 03                	je     800d29 <strncpy+0x31>
			src++;
  800d26:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d29:	ff 45 fc             	incl   -0x4(%ebp)
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d32:	72 d9                	jb     800d0d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 30                	je     800d7b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d4b:	eb 16                	jmp    800d63 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	89 55 08             	mov    %edx,0x8(%ebp)
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d63:	ff 4d 10             	decl   0x10(%ebp)
  800d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6a:	74 09                	je     800d75 <strlcpy+0x3c>
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 d8                	jne    800d4d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	29 c2                	sub    %eax,%edx
  800d83:	89 d0                	mov    %edx,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d8a:	eb 06                	jmp    800d92 <strcmp+0xb>
		p++, q++;
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	74 0e                	je     800da9 <strcmp+0x22>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 10                	mov    (%eax),%dl
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	38 c2                	cmp    %al,%dl
  800da7:	74 e3                	je     800d8c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	0f b6 d0             	movzbl %al,%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f b6 c0             	movzbl %al,%eax
  800db9:	29 c2                	sub    %eax,%edx
  800dbb:	89 d0                	mov    %edx,%eax
}
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dc2:	eb 09                	jmp    800dcd <strncmp+0xe>
		n--, p++, q++;
  800dc4:	ff 4d 10             	decl   0x10(%ebp)
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 17                	je     800dea <strncmp+0x2b>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 0e                	je     800dea <strncmp+0x2b>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 10                	mov    (%eax),%dl
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	38 c2                	cmp    %al,%dl
  800de8:	74 da                	je     800dc4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	75 07                	jne    800df7 <strncmp+0x38>
		return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	eb 14                	jmp    800e0b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 12                	jmp    800e2d <strchr+0x20>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	75 05                	jne    800e2a <strchr+0x1d>
			return (char *) s;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	eb 11                	jmp    800e3b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 e5                	jne    800e1b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e49:	eb 0d                	jmp    800e58 <strfind+0x1b>
		if (*s == c)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e53:	74 0e                	je     800e63 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 ea                	jne    800e4b <strfind+0xe>
  800e61:	eb 01                	jmp    800e64 <strfind+0x27>
		if (*s == c)
			break;
  800e63:	90                   	nop
	return (char *) s;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e79:	76 63                	jbe    800ede <memset+0x75>
		uint64 data_block = c;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	99                   	cltd   
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e8f:	c1 e0 08             	shl    $0x8,%eax
  800e92:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e95:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ea2:	c1 e0 10             	shl    $0x10,%eax
  800ea5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ebe:	eb 18                	jmp    800ed8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ec0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec3:	8d 41 08             	lea    0x8(%ecx),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 01                	mov    %eax,(%ecx)
  800ed1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ed4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edc:	77 e2                	ja     800ec0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 23                	je     800f07 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eea:	eb 0e                	jmp    800efa <memset+0x91>
			*p8++ = (uint8)c;
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8d 50 01             	lea    0x1(%eax),%edx
  800ef2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 e5                	jne    800eec <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f22:	76 24                	jbe    800f48 <memcpy+0x3c>
		while(n >= 8){
  800f24:	eb 1c                	jmp    800f42 <memcpy+0x36>
			*d64 = *s64;
  800f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f29:	8b 50 04             	mov    0x4(%eax),%edx
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f31:	89 01                	mov    %eax,(%ecx)
  800f33:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f36:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f3a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f3e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	77 de                	ja     800f26 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 31                	je     800f7f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x66>
			*d8++ = *s8++;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801240:	75 bb                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	48                   	dec    %eax
  80124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801254:	74 3d                	je     801293 <ltostr+0xc3>
		start = 1 ;
  801256:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125d:	eb 34                	jmp    801293 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 c2                	add    %eax,%edx
  801274:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801280:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128b:	88 02                	mov    %al,(%edx)
		start++ ;
  80128d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801290:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801299:	7c c4                	jl     80125f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 c4 f9 ff ff       	call   800c7b <strlen>
  8012b7:	83 c4 04             	add    $0x4,%esp
  8012ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b6 f9 ff ff       	call   800c7b <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d9:	eb 17                	jmp    8012f2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 c2                	add    %eax,%edx
  8012e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	01 c8                	add    %ecx,%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f8:	7c e1                	jl     8012db <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801308:	eb 1f                	jmp    801329 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	8d 50 01             	lea    0x1(%eax),%edx
  801310:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	01 c8                	add    %ecx,%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801326:	ff 45 f8             	incl   -0x8(%ebp)
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132f:	7c d9                	jl     80130a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801331:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c6 00 00             	movb   $0x0,(%eax)
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	8b 00                	mov    (%eax),%eax
  801350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801362:	eb 0c                	jmp    801370 <strsplit+0x31>
			*string++ = 0;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 08             	mov    %edx,0x8(%ebp)
  80136d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	74 18                	je     801391 <strsplit+0x52>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	50                   	push   %eax
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	e8 83 fa ff ff       	call   800e0d <strchr>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	75 d3                	jne    801364 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 5a                	je     8013f4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	83 f8 0f             	cmp    $0xf,%eax
  8013a2:	75 07                	jne    8013ab <strsplit+0x6c>
		{
			return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 66                	jmp    801411 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b6:	89 0a                	mov    %ecx,(%edx)
  8013b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 c2                	add    %eax,%edx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c9:	eb 03                	jmp    8013ce <strsplit+0x8f>
			string++;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	74 8b                	je     801362 <strsplit+0x23>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	0f be c0             	movsbl %al,%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 25 fa ff ff       	call   800e0d <strchr>
  8013e8:	83 c4 08             	add    $0x8,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 dc                	je     8013cb <strsplit+0x8c>
			string++;
	}
  8013ef:	e9 6e ff ff ff       	jmp    801362 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 4a                	jmp    801472 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 40                	cmp    $0x40,%al
  801448:	7e 25                	jle    80146f <str2lower+0x5c>
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 5a                	cmp    $0x5a,%al
  801456:	7f 17                	jg     80146f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	01 ca                	add    %ecx,%edx
  801468:	8a 12                	mov    (%edx),%dl
  80146a:	83 c2 20             	add    $0x20,%edx
  80146d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 01 f8 ff ff       	call   800c7b <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801480:	7f a6                	jg     801428 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80148d:	a1 08 40 80 00       	mov    0x804008,%eax
  801492:	85 c0                	test   %eax,%eax
  801494:	74 42                	je     8014d8 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	68 00 00 00 82       	push   $0x82000000
  80149e:	68 00 00 00 80       	push   $0x80000000
  8014a3:	e8 00 08 00 00       	call   801ca8 <initialize_dynamic_allocator>
  8014a8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014ab:	e8 e7 05 00 00       	call   801a97 <sys_get_uheap_strategy>
  8014b0:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8014ba:	05 00 10 00 00       	add    $0x1000,%eax
  8014bf:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014c4:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8014c9:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8014ce:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8014d5:	00 00 00 
	}
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	68 06 04 00 00       	push   $0x406
  8014f7:	50                   	push   %eax
  8014f8:	e8 e4 01 00 00       	call   8016e1 <__sys_allocate_page>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801507:	79 14                	jns    80151d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 68 32 80 00       	push   $0x803268
  801511:	6a 1f                	push   $0x1f
  801513:	68 a4 32 80 00       	push   $0x8032a4
  801518:	e8 ed 12 00 00       	call   80280a <_panic>
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	50                   	push   %eax
  80153c:	e8 e7 01 00 00       	call   801728 <__sys_unmap_frame>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801547:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80154b:	79 14                	jns    801561 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 b0 32 80 00       	push   $0x8032b0
  801555:	6a 2a                	push   $0x2a
  801557:	68 a4 32 80 00       	push   $0x8032a4
  80155c:	e8 a9 12 00 00       	call   80280a <_panic>
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80156a:	e8 18 ff ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  80156f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801573:	75 07                	jne    80157c <malloc+0x18>
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
  80157a:	eb 14                	jmp    801590 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	68 f0 32 80 00       	push   $0x8032f0
  801584:	6a 3e                	push   $0x3e
  801586:	68 a4 32 80 00       	push   $0x8032a4
  80158b:	e8 7a 12 00 00       	call   80280a <_panic>
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	68 18 33 80 00       	push   $0x803318
  8015a0:	6a 49                	push   $0x49
  8015a2:	68 a4 32 80 00       	push   $0x8032a4
  8015a7:	e8 5e 12 00 00       	call   80280a <_panic>

008015ac <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 18             	sub    $0x18,%esp
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015b8:	e8 ca fe ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  8015bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c1:	75 07                	jne    8015ca <smalloc+0x1e>
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	eb 14                	jmp    8015de <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	68 3c 33 80 00       	push   $0x80333c
  8015d2:	6a 5a                	push   $0x5a
  8015d4:	68 a4 32 80 00       	push   $0x8032a4
  8015d9:	e8 2c 12 00 00       	call   80280a <_panic>
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015e6:	e8 9c fe ff ff       	call   801487 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 64 33 80 00       	push   $0x803364
  8015f3:	6a 6a                	push   $0x6a
  8015f5:	68 a4 32 80 00       	push   $0x8032a4
  8015fa:	e8 0b 12 00 00       	call   80280a <_panic>

008015ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801605:	e8 7d fe ff ff       	call   801487 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 88 33 80 00       	push   $0x803388
  801612:	68 88 00 00 00       	push   $0x88
  801617:	68 a4 32 80 00       	push   $0x8032a4
  80161c:	e8 e9 11 00 00       	call   80280a <_panic>

00801621 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 b0 33 80 00       	push   $0x8033b0
  80162f:	68 9b 00 00 00       	push   $0x9b
  801634:	68 a4 32 80 00       	push   $0x8032a4
  801639:	e8 cc 11 00 00       	call   80280a <_panic>

0080163e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801650:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801653:	8b 7d 18             	mov    0x18(%ebp),%edi
  801656:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801659:	cd 30                	int    $0x30
  80165b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801675:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801678:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	51                   	push   %ecx
  801682:	52                   	push   %edx
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	50                   	push   %eax
  801687:	6a 00                	push   $0x0
  801689:	e8 b0 ff ff ff       	call   80163e <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_cgetc>:

int
sys_cgetc(void)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 02                	push   $0x2
  8016a3:	e8 96 ff ff ff       	call   80163e <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 03                	push   $0x3
  8016bc:	e8 7d ff ff ff       	call   80163e <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	90                   	nop
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 04                	push   $0x4
  8016d6:	e8 63 ff ff ff       	call   80163e <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	90                   	nop
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 08                	push   $0x8
  8016f4:	e8 45 ff ff ff       	call   80163e <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801703:	8b 75 18             	mov    0x18(%ebp),%esi
  801706:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801709:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	51                   	push   %ecx
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 09                	push   $0x9
  801719:	e8 20 ff ff ff       	call   80163e <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	6a 0a                	push   $0xa
  801738:	e8 01 ff ff ff       	call   80163e <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 0b                	push   $0xb
  801753:	e8 e6 fe ff ff       	call   80163e <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 0c                	push   $0xc
  80176c:	e8 cd fe ff ff       	call   80163e <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 0d                	push   $0xd
  801785:	e8 b4 fe ff ff       	call   80163e <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 0e                	push   $0xe
  80179e:	e8 9b fe ff ff       	call   80163e <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 0f                	push   $0xf
  8017b7:	e8 82 fe ff ff       	call   80163e <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	6a 10                	push   $0x10
  8017d1:	e8 68 fe ff ff       	call   80163e <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 11                	push   $0x11
  8017ea:	e8 4f fe ff ff       	call   80163e <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801801:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	50                   	push   %eax
  80180e:	6a 01                	push   $0x1
  801810:	e8 29 fe ff ff       	call   80163e <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 14                	push   $0x14
  80182a:	e8 0f fe ff ff       	call   80163e <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	90                   	nop
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801841:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801844:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	51                   	push   %ecx
  80184e:	52                   	push   %edx
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	6a 15                	push   $0x15
  801855:	e8 e4 fd ff ff       	call   80163e <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	52                   	push   %edx
  80186f:	50                   	push   %eax
  801870:	6a 16                	push   $0x16
  801872:	e8 c7 fd ff ff       	call   80163e <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80187f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	51                   	push   %ecx
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 17                	push   $0x17
  801891:	e8 a8 fd ff ff       	call   80163e <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 18                	push   $0x18
  8018ae:	e8 8b fd ff ff       	call   80163e <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 14             	pushl  0x14(%ebp)
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	6a 19                	push   $0x19
  8018cc:	e8 6d fd ff ff       	call   80163e <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	50                   	push   %eax
  8018e5:	6a 1a                	push   $0x1a
  8018e7:	e8 52 fd ff ff       	call   80163e <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	50                   	push   %eax
  801901:	6a 1b                	push   $0x1b
  801903:	e8 36 fd ff ff       	call   80163e <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 05                	push   $0x5
  80191c:	e8 1d fd ff ff       	call   80163e <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 06                	push   $0x6
  801935:	e8 04 fd ff ff       	call   80163e <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 07                	push   $0x7
  80194e:	e8 eb fc ff ff       	call   80163e <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_exit_env>:


void sys_exit_env(void)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 1c                	push   $0x1c
  801967:	e8 d2 fc ff ff       	call   80163e <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801978:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80197b:	8d 50 04             	lea    0x4(%eax),%edx
  80197e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	52                   	push   %edx
  801988:	50                   	push   %eax
  801989:	6a 1d                	push   $0x1d
  80198b:	e8 ae fc ff ff       	call   80163e <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
	return result;
  801993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80199c:	89 01                	mov    %eax,(%ecx)
  80199e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	c9                   	leave  
  8019a5:	c2 04 00             	ret    $0x4

008019a8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 13                	push   $0x13
  8019ba:	e8 7f fc ff ff       	call   80163e <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 1e                	push   $0x1e
  8019d4:	e8 65 fc ff ff       	call   80163e <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	50                   	push   %eax
  8019f7:	6a 1f                	push   $0x1f
  8019f9:	e8 40 fc ff ff       	call   80163e <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <rsttst>:
void rsttst()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 21                	push   $0x21
  801a13:	e8 26 fc ff ff       	call   80163e <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1b:	90                   	nop
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	8b 45 14             	mov    0x14(%ebp),%eax
  801a27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801a2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	6a 20                	push   $0x20
  801a3e:	e8 fb fb ff ff       	call   80163e <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
	return ;
  801a46:	90                   	nop
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <chktst>:
void chktst(uint32 n)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 08             	pushl  0x8(%ebp)
  801a57:	6a 22                	push   $0x22
  801a59:	e8 e0 fb ff ff       	call   80163e <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a61:	90                   	nop
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <inctst>:

void inctst()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 23                	push   $0x23
  801a73:	e8 c6 fb ff ff       	call   80163e <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <gettst>:
uint32 gettst()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 24                	push   $0x24
  801a8d:	e8 ac fb ff ff       	call   80163e <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 25                	push   $0x25
  801aa6:	e8 93 fb ff ff       	call   80163e <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
  801aae:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801ab3:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	6a 26                	push   $0x26
  801ad2:	e8 67 fb ff ff       	call   80163e <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ae1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	53                   	push   %ebx
  801af0:	51                   	push   %ecx
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 27                	push   $0x27
  801af5:	e8 44 fb ff ff       	call   80163e <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 28                	push   $0x28
  801b15:	e8 24 fb ff ff       	call   80163e <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	51                   	push   %ecx
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 29                	push   $0x29
  801b35:	e8 04 fb ff ff       	call   80163e <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 12                	push   $0x12
  801b51:	e8 e8 fa ff ff       	call   80163e <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return ;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 2a                	push   $0x2a
  801b6f:	e8 ca fa ff ff       	call   80163e <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 2b                	push   $0x2b
  801b89:	e8 b0 fa ff ff       	call   80163e <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 2d                	push   $0x2d
  801ba4:	e8 95 fa ff ff       	call   80163e <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return;
  801bac:	90                   	nop
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 2c                	push   $0x2c
  801bc0:	e8 79 fa ff ff       	call   80163e <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	68 d4 33 80 00       	push   $0x8033d4
  801bd9:	68 25 01 00 00       	push   $0x125
  801bde:	68 07 34 80 00       	push   $0x803407
  801be3:	e8 22 0c 00 00       	call   80280a <_panic>

00801be8 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801bee:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801bf5:	72 09                	jb     801c00 <to_page_va+0x18>
  801bf7:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801bfe:	72 14                	jb     801c14 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 18 34 80 00       	push   $0x803418
  801c08:	6a 15                	push   $0x15
  801c0a:	68 43 34 80 00       	push   $0x803443
  801c0f:	e8 f6 0b 00 00       	call   80280a <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	ba 60 40 80 00       	mov    $0x804060,%edx
  801c1c:	29 d0                	sub    %edx,%eax
  801c1e:	c1 f8 02             	sar    $0x2,%eax
  801c21:	89 c2                	mov    %eax,%edx
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	c1 e0 02             	shl    $0x2,%eax
  801c28:	01 d0                	add    %edx,%eax
  801c2a:	c1 e0 02             	shl    $0x2,%eax
  801c2d:	01 d0                	add    %edx,%eax
  801c2f:	c1 e0 02             	shl    $0x2,%eax
  801c32:	01 d0                	add    %edx,%eax
  801c34:	89 c1                	mov    %eax,%ecx
  801c36:	c1 e1 08             	shl    $0x8,%ecx
  801c39:	01 c8                	add    %ecx,%eax
  801c3b:	89 c1                	mov    %eax,%ecx
  801c3d:	c1 e1 10             	shl    $0x10,%ecx
  801c40:	01 c8                	add    %ecx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4c:	c1 e0 0c             	shl    $0xc,%eax
  801c4f:	89 c2                	mov    %eax,%edx
  801c51:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c56:	01 d0                	add    %edx,%eax
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801c60:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801c65:	8b 55 08             	mov    0x8(%ebp),%edx
  801c68:	29 c2                	sub    %eax,%edx
  801c6a:	89 d0                	mov    %edx,%eax
  801c6c:	c1 e8 0c             	shr    $0xc,%eax
  801c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c76:	78 09                	js     801c81 <to_page_info+0x27>
  801c78:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801c7f:	7e 14                	jle    801c95 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 5c 34 80 00       	push   $0x80345c
  801c89:	6a 22                	push   $0x22
  801c8b:	68 43 34 80 00       	push   $0x803443
  801c90:	e8 75 0b 00 00       	call   80280a <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c98:	89 d0                	mov    %edx,%eax
  801c9a:	01 c0                	add    %eax,%eax
  801c9c:	01 d0                	add    %edx,%eax
  801c9e:	c1 e0 02             	shl    $0x2,%eax
  801ca1:	05 60 40 80 00       	add    $0x804060,%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	05 00 00 00 02       	add    $0x2000000,%eax
  801cb6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cb9:	73 16                	jae    801cd1 <initialize_dynamic_allocator+0x29>
  801cbb:	68 80 34 80 00       	push   $0x803480
  801cc0:	68 a6 34 80 00       	push   $0x8034a6
  801cc5:	6a 34                	push   $0x34
  801cc7:	68 43 34 80 00       	push   $0x803443
  801ccc:	e8 39 0b 00 00       	call   80280a <_panic>
		is_initialized = 1;
  801cd1:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801cd8:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce6:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801ceb:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801cf2:	00 00 00 
  801cf5:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801cfc:	00 00 00 
  801cff:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801d06:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0c:	2b 45 08             	sub    0x8(%ebp),%eax
  801d0f:	c1 e8 0c             	shr    $0xc,%eax
  801d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d1c:	e9 c8 00 00 00       	jmp    801de9 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d24:	89 d0                	mov    %edx,%eax
  801d26:	01 c0                	add    %eax,%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	c1 e0 02             	shl    $0x2,%eax
  801d2d:	05 68 40 80 00       	add    $0x804068,%eax
  801d32:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3a:	89 d0                	mov    %edx,%eax
  801d3c:	01 c0                	add    %eax,%eax
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	c1 e0 02             	shl    $0x2,%eax
  801d43:	05 6a 40 80 00       	add    $0x80406a,%eax
  801d48:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801d4d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d53:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d56:	89 c8                	mov    %ecx,%eax
  801d58:	01 c0                	add    %eax,%eax
  801d5a:	01 c8                	add    %ecx,%eax
  801d5c:	c1 e0 02             	shl    $0x2,%eax
  801d5f:	05 64 40 80 00       	add    $0x804064,%eax
  801d64:	89 10                	mov    %edx,(%eax)
  801d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	01 c0                	add    %eax,%eax
  801d6d:	01 d0                	add    %edx,%eax
  801d6f:	c1 e0 02             	shl    $0x2,%eax
  801d72:	05 64 40 80 00       	add    $0x804064,%eax
  801d77:	8b 00                	mov    (%eax),%eax
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	74 1b                	je     801d98 <initialize_dynamic_allocator+0xf0>
  801d7d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801d83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d86:	89 c8                	mov    %ecx,%eax
  801d88:	01 c0                	add    %eax,%eax
  801d8a:	01 c8                	add    %ecx,%eax
  801d8c:	c1 e0 02             	shl    $0x2,%eax
  801d8f:	05 60 40 80 00       	add    $0x804060,%eax
  801d94:	89 02                	mov    %eax,(%edx)
  801d96:	eb 16                	jmp    801dae <initialize_dynamic_allocator+0x106>
  801d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9b:	89 d0                	mov    %edx,%eax
  801d9d:	01 c0                	add    %eax,%eax
  801d9f:	01 d0                	add    %edx,%eax
  801da1:	c1 e0 02             	shl    $0x2,%eax
  801da4:	05 60 40 80 00       	add    $0x804060,%eax
  801da9:	a3 48 40 80 00       	mov    %eax,0x804048
  801dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db1:	89 d0                	mov    %edx,%eax
  801db3:	01 c0                	add    %eax,%eax
  801db5:	01 d0                	add    %edx,%eax
  801db7:	c1 e0 02             	shl    $0x2,%eax
  801dba:	05 60 40 80 00       	add    $0x804060,%eax
  801dbf:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	01 c0                	add    %eax,%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c1 e0 02             	shl    $0x2,%eax
  801dd0:	05 60 40 80 00       	add    $0x804060,%eax
  801dd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ddb:	a1 54 40 80 00       	mov    0x804054,%eax
  801de0:	40                   	inc    %eax
  801de1:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801de6:	ff 45 f4             	incl   -0xc(%ebp)
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801def:	0f 8c 2c ff ff ff    	jl     801d21 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801df5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801dfc:	eb 36                	jmp    801e34 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e01:	c1 e0 04             	shl    $0x4,%eax
  801e04:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e12:	c1 e0 04             	shl    $0x4,%eax
  801e15:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e23:	c1 e0 04             	shl    $0x4,%eax
  801e26:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e31:	ff 45 f0             	incl   -0x10(%ebp)
  801e34:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801e38:	7e c4                	jle    801dfe <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801e3a:	90                   	nop
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	50                   	push   %eax
  801e4a:	e8 0b fe ff ff       	call   801c5a <to_page_info>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 40 08             	mov    0x8(%eax),%eax
  801e5b:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	e8 77 fd ff ff       	call   801be8 <to_page_va>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801e77:	b8 00 10 00 00       	mov    $0x1000,%eax
  801e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e81:	f7 75 08             	divl   0x8(%ebp)
  801e84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	50                   	push   %eax
  801e8e:	e8 48 f6 ff ff       	call   8014db <get_page>
  801e93:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801eb1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801eb8:	eb 19                	jmp    801ed3 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	ba 01 00 00 00       	mov    $0x1,%edx
  801ec2:	88 c1                	mov    %al,%cl
  801ec4:	d3 e2                	shl    %cl,%edx
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ecb:	74 0e                	je     801edb <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801ecd:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801ed0:	ff 45 f0             	incl   -0x10(%ebp)
  801ed3:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801ed7:	7e e1                	jle    801eba <split_page_to_blocks+0x5a>
  801ed9:	eb 01                	jmp    801edc <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801edb:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801edc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ee3:	e9 a7 00 00 00       	jmp    801f8f <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	0f af 45 08          	imul   0x8(%ebp),%eax
  801eef:	89 c2                	mov    %eax,%edx
  801ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801ef9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801efd:	75 14                	jne    801f13 <split_page_to_blocks+0xb3>
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	68 bc 34 80 00       	push   $0x8034bc
  801f07:	6a 7c                	push   $0x7c
  801f09:	68 43 34 80 00       	push   $0x803443
  801f0e:	e8 f7 08 00 00       	call   80280a <_panic>
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	c1 e0 04             	shl    $0x4,%eax
  801f19:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f1e:	8b 10                	mov    (%eax),%edx
  801f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f23:	89 50 04             	mov    %edx,0x4(%eax)
  801f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f29:	8b 40 04             	mov    0x4(%eax),%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	74 14                	je     801f44 <split_page_to_blocks+0xe4>
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	c1 e0 04             	shl    $0x4,%eax
  801f36:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f3b:	8b 00                	mov    (%eax),%eax
  801f3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f40:	89 10                	mov    %edx,(%eax)
  801f42:	eb 11                	jmp    801f55 <split_page_to_blocks+0xf5>
  801f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f47:	c1 e0 04             	shl    $0x4,%eax
  801f4a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f53:	89 02                	mov    %eax,(%edx)
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	c1 e0 04             	shl    $0x4,%eax
  801f5b:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f64:	89 02                	mov    %eax,(%edx)
  801f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	c1 e0 04             	shl    $0x4,%eax
  801f75:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	8d 50 01             	lea    0x1(%eax),%edx
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	c1 e0 04             	shl    $0x4,%eax
  801f85:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f8a:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f8c:	ff 45 ec             	incl   -0x14(%ebp)
  801f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f92:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f95:	0f 82 4d ff ff ff    	jb     801ee8 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801fa4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801fab:	76 19                	jbe    801fc6 <alloc_block+0x28>
  801fad:	68 e0 34 80 00       	push   $0x8034e0
  801fb2:	68 a6 34 80 00       	push   $0x8034a6
  801fb7:	68 8a 00 00 00       	push   $0x8a
  801fbc:	68 43 34 80 00       	push   $0x803443
  801fc1:	e8 44 08 00 00       	call   80280a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801fcd:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801fd4:	eb 19                	jmp    801fef <alloc_block+0x51>
		if((1 << i) >= size) break;
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	ba 01 00 00 00       	mov    $0x1,%edx
  801fde:	88 c1                	mov    %al,%cl
  801fe0:	d3 e2                	shl    %cl,%edx
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fe7:	73 0e                	jae    801ff7 <alloc_block+0x59>
		idx++;
  801fe9:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801fec:	ff 45 f0             	incl   -0x10(%ebp)
  801fef:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801ff3:	7e e1                	jle    801fd6 <alloc_block+0x38>
  801ff5:	eb 01                	jmp    801ff8 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801ff7:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	c1 e0 04             	shl    $0x4,%eax
  801ffe:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	0f 84 df 00 00 00    	je     8020ec <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	c1 e0 04             	shl    $0x4,%eax
  802013:	05 80 c0 81 00       	add    $0x81c080,%eax
  802018:	8b 00                	mov    (%eax),%eax
  80201a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80201d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802021:	75 17                	jne    80203a <alloc_block+0x9c>
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	68 01 35 80 00       	push   $0x803501
  80202b:	68 9e 00 00 00       	push   $0x9e
  802030:	68 43 34 80 00       	push   $0x803443
  802035:	e8 d0 07 00 00       	call   80280a <_panic>
  80203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203d:	8b 00                	mov    (%eax),%eax
  80203f:	85 c0                	test   %eax,%eax
  802041:	74 10                	je     802053 <alloc_block+0xb5>
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	8b 00                	mov    (%eax),%eax
  802048:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80204b:	8b 52 04             	mov    0x4(%edx),%edx
  80204e:	89 50 04             	mov    %edx,0x4(%eax)
  802051:	eb 14                	jmp    802067 <alloc_block+0xc9>
  802053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802056:	8b 40 04             	mov    0x4(%eax),%eax
  802059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205c:	c1 e2 04             	shl    $0x4,%edx
  80205f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802065:	89 02                	mov    %eax,(%edx)
  802067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206a:	8b 40 04             	mov    0x4(%eax),%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	74 0f                	je     802080 <alloc_block+0xe2>
  802071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802074:	8b 40 04             	mov    0x4(%eax),%eax
  802077:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80207a:	8b 12                	mov    (%edx),%edx
  80207c:	89 10                	mov    %edx,(%eax)
  80207e:	eb 13                	jmp    802093 <alloc_block+0xf5>
  802080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802083:	8b 00                	mov    (%eax),%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802091:	89 02                	mov    %eax,(%edx)
  802093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80209c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	c1 e0 04             	shl    $0x4,%eax
  8020ac:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	c1 e0 04             	shl    $0x4,%eax
  8020bc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020c1:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8020c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	50                   	push   %eax
  8020ca:	e8 8b fb ff ff       	call   801c5a <to_page_info>
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8020d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8020dc:	48                   	dec    %eax
  8020dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020e0:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8020e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e7:	e9 bc 02 00 00       	jmp    8023a8 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8020ec:	a1 54 40 80 00       	mov    0x804054,%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	0f 84 7d 02 00 00    	je     802376 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8020f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802101:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802105:	75 17                	jne    80211e <alloc_block+0x180>
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	68 01 35 80 00       	push   $0x803501
  80210f:	68 a9 00 00 00       	push   $0xa9
  802114:	68 43 34 80 00       	push   $0x803443
  802119:	e8 ec 06 00 00       	call   80280a <_panic>
  80211e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802121:	8b 00                	mov    (%eax),%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	74 10                	je     802137 <alloc_block+0x199>
  802127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80212f:	8b 52 04             	mov    0x4(%edx),%edx
  802132:	89 50 04             	mov    %edx,0x4(%eax)
  802135:	eb 0b                	jmp    802142 <alloc_block+0x1a4>
  802137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213a:	8b 40 04             	mov    0x4(%eax),%eax
  80213d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802145:	8b 40 04             	mov    0x4(%eax),%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	74 0f                	je     80215b <alloc_block+0x1bd>
  80214c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80214f:	8b 40 04             	mov    0x4(%eax),%eax
  802152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802155:	8b 12                	mov    (%edx),%edx
  802157:	89 10                	mov    %edx,(%eax)
  802159:	eb 0a                	jmp    802165 <alloc_block+0x1c7>
  80215b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	a3 48 40 80 00       	mov    %eax,0x804048
  802165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802168:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80216e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802171:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802178:	a1 54 40 80 00       	mov    0x804054,%eax
  80217d:	48                   	dec    %eax
  80217e:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	83 c0 03             	add    $0x3,%eax
  802189:	ba 01 00 00 00       	mov    $0x1,%edx
  80218e:	88 c1                	mov    %al,%cl
  802190:	d3 e2                	shl    %cl,%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	83 ec 08             	sub    $0x8,%esp
  802197:	ff 75 e4             	pushl  -0x1c(%ebp)
  80219a:	50                   	push   %eax
  80219b:	e8 c0 fc ff ff       	call   801e60 <split_page_to_blocks>
  8021a0:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	c1 e0 04             	shl    $0x4,%eax
  8021a9:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021b7:	75 17                	jne    8021d0 <alloc_block+0x232>
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 01 35 80 00       	push   $0x803501
  8021c1:	68 b0 00 00 00       	push   $0xb0
  8021c6:	68 43 34 80 00       	push   $0x803443
  8021cb:	e8 3a 06 00 00       	call   80280a <_panic>
  8021d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 10                	je     8021e9 <alloc_block+0x24b>
  8021d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021e1:	8b 52 04             	mov    0x4(%edx),%edx
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	eb 14                	jmp    8021fd <alloc_block+0x25f>
  8021e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ec:	8b 40 04             	mov    0x4(%eax),%eax
  8021ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f2:	c1 e2 04             	shl    $0x4,%edx
  8021f5:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8021fb:	89 02                	mov    %eax,(%edx)
  8021fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802200:	8b 40 04             	mov    0x4(%eax),%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	74 0f                	je     802216 <alloc_block+0x278>
  802207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220a:	8b 40 04             	mov    0x4(%eax),%eax
  80220d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802210:	8b 12                	mov    (%edx),%edx
  802212:	89 10                	mov    %edx,(%eax)
  802214:	eb 13                	jmp    802229 <alloc_block+0x28b>
  802216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221e:	c1 e2 04             	shl    $0x4,%edx
  802221:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802227:	89 02                	mov    %eax,(%edx)
  802229:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	c1 e0 04             	shl    $0x4,%eax
  802242:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802247:	8b 00                	mov    (%eax),%eax
  802249:	8d 50 ff             	lea    -0x1(%eax),%edx
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	c1 e0 04             	shl    $0x4,%eax
  802252:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802257:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802259:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	50                   	push   %eax
  802260:	e8 f5 f9 ff ff       	call   801c5a <to_page_info>
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80226b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80226e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802272:	48                   	dec    %eax
  802273:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802276:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80227a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227d:	e9 26 01 00 00       	jmp    8023a8 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802282:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	c1 e0 04             	shl    $0x4,%eax
  80228b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	0f 84 dc 00 00 00    	je     802376 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	c1 e0 04             	shl    $0x4,%eax
  8022a0:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022ae:	75 17                	jne    8022c7 <alloc_block+0x329>
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	68 01 35 80 00       	push   $0x803501
  8022b8:	68 be 00 00 00       	push   $0xbe
  8022bd:	68 43 34 80 00       	push   $0x803443
  8022c2:	e8 43 05 00 00       	call   80280a <_panic>
  8022c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 10                	je     8022e0 <alloc_block+0x342>
  8022d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022d8:	8b 52 04             	mov    0x4(%edx),%edx
  8022db:	89 50 04             	mov    %edx,0x4(%eax)
  8022de:	eb 14                	jmp    8022f4 <alloc_block+0x356>
  8022e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022e3:	8b 40 04             	mov    0x4(%eax),%eax
  8022e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e9:	c1 e2 04             	shl    $0x4,%edx
  8022ec:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022f2:	89 02                	mov    %eax,(%edx)
  8022f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0f                	je     80230d <alloc_block+0x36f>
  8022fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802307:	8b 12                	mov    (%edx),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 13                	jmp    802320 <alloc_block+0x382>
  80230d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802315:	c1 e2 04             	shl    $0x4,%edx
  802318:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80231e:	89 02                	mov    %eax,(%edx)
  802320:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802329:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80232c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	c1 e0 04             	shl    $0x4,%eax
  802339:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	8d 50 ff             	lea    -0x1(%eax),%edx
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	c1 e0 04             	shl    $0x4,%eax
  802349:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80234e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802350:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802353:	83 ec 0c             	sub    $0xc,%esp
  802356:	50                   	push   %eax
  802357:	e8 fe f8 ff ff       	call   801c5a <to_page_info>
  80235c:	83 c4 10             	add    $0x10,%esp
  80235f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802362:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802365:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802369:	48                   	dec    %eax
  80236a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80236d:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802371:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802374:	eb 32                	jmp    8023a8 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802376:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80237a:	77 15                	ja     802391 <alloc_block+0x3f3>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	c1 e0 04             	shl    $0x4,%eax
  802382:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802387:	8b 00                	mov    (%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	0f 84 f1 fe ff ff    	je     802282 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 1f 35 80 00       	push   $0x80351f
  802399:	68 c8 00 00 00       	push   $0xc8
  80239e:	68 43 34 80 00       	push   $0x803443
  8023a3:	e8 62 04 00 00       	call   80280a <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023b8:	39 c2                	cmp    %eax,%edx
  8023ba:	72 0c                	jb     8023c8 <free_block+0x1e>
  8023bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bf:	a1 40 40 80 00       	mov    0x804040,%eax
  8023c4:	39 c2                	cmp    %eax,%edx
  8023c6:	72 19                	jb     8023e1 <free_block+0x37>
  8023c8:	68 30 35 80 00       	push   $0x803530
  8023cd:	68 a6 34 80 00       	push   $0x8034a6
  8023d2:	68 d7 00 00 00       	push   $0xd7
  8023d7:	68 43 34 80 00       	push   $0x803443
  8023dc:	e8 29 04 00 00       	call   80280a <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	83 ec 0c             	sub    $0xc,%esp
  8023ed:	50                   	push   %eax
  8023ee:	e8 67 f8 ff ff       	call   801c5a <to_page_info>
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8023f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023fc:	8b 40 08             	mov    0x8(%eax),%eax
  8023ff:	0f b7 c0             	movzwl %ax,%eax
  802402:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80240c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802413:	eb 19                	jmp    80242e <free_block+0x84>
	    if ((1 << i) == blk_size)
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	ba 01 00 00 00       	mov    $0x1,%edx
  80241d:	88 c1                	mov    %al,%cl
  80241f:	d3 e2                	shl    %cl,%edx
  802421:	89 d0                	mov    %edx,%eax
  802423:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802426:	74 0e                	je     802436 <free_block+0x8c>
	        break;
	    idx++;
  802428:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80242b:	ff 45 f0             	incl   -0x10(%ebp)
  80242e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802432:	7e e1                	jle    802415 <free_block+0x6b>
  802434:	eb 01                	jmp    802437 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802436:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80243e:	40                   	inc    %eax
  80243f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802442:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802446:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80244a:	75 17                	jne    802463 <free_block+0xb9>
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 bc 34 80 00       	push   $0x8034bc
  802454:	68 ee 00 00 00       	push   $0xee
  802459:	68 43 34 80 00       	push   $0x803443
  80245e:	e8 a7 03 00 00       	call   80280a <_panic>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	c1 e0 04             	shl    $0x4,%eax
  802469:	05 84 c0 81 00       	add    $0x81c084,%eax
  80246e:	8b 10                	mov    (%eax),%edx
  802470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802473:	89 50 04             	mov    %edx,0x4(%eax)
  802476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802479:	8b 40 04             	mov    0x4(%eax),%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 14                	je     802494 <free_block+0xea>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	c1 e0 04             	shl    $0x4,%eax
  802486:	05 84 c0 81 00       	add    $0x81c084,%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	eb 11                	jmp    8024a5 <free_block+0xfb>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	c1 e0 04             	shl    $0x4,%eax
  80249a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8024a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a3:	89 02                	mov    %eax,(%edx)
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	c1 e0 04             	shl    $0x4,%eax
  8024ab:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8024b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b4:	89 02                	mov    %eax,(%edx)
  8024b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	c1 e0 04             	shl    $0x4,%eax
  8024c5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	8d 50 01             	lea    0x1(%eax),%edx
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c1 e0 04             	shl    $0x4,%eax
  8024d5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024da:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8024dc:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e6:	f7 75 e0             	divl   -0x20(%ebp)
  8024e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024f3:	0f b7 c0             	movzwl %ax,%eax
  8024f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8024f9:	0f 85 70 01 00 00    	jne    80266f <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8024ff:	83 ec 0c             	sub    $0xc,%esp
  802502:	ff 75 e4             	pushl  -0x1c(%ebp)
  802505:	e8 de f6 ff ff       	call   801be8 <to_page_va>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802510:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802517:	e9 b7 00 00 00       	jmp    8025d3 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80251c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	01 d0                	add    %edx,%eax
  802524:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802527:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80252b:	75 17                	jne    802544 <free_block+0x19a>
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 01 35 80 00       	push   $0x803501
  802535:	68 f8 00 00 00       	push   $0xf8
  80253a:	68 43 34 80 00       	push   $0x803443
  80253f:	e8 c6 02 00 00       	call   80280a <_panic>
  802544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 10                	je     80255d <free_block+0x1b3>
  80254d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802555:	8b 52 04             	mov    0x4(%edx),%edx
  802558:	89 50 04             	mov    %edx,0x4(%eax)
  80255b:	eb 14                	jmp    802571 <free_block+0x1c7>
  80255d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	c1 e2 04             	shl    $0x4,%edx
  802569:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80256f:	89 02                	mov    %eax,(%edx)
  802571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	74 0f                	je     80258a <free_block+0x1e0>
  80257b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802584:	8b 12                	mov    (%edx),%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	eb 13                	jmp    80259d <free_block+0x1f3>
  80258a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802592:	c1 e2 04             	shl    $0x4,%edx
  802595:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80259b:	89 02                	mov    %eax,(%edx)
  80259d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	c1 e0 04             	shl    $0x4,%eax
  8025b6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	c1 e0 04             	shl    $0x4,%eax
  8025c6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025cb:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d0:	01 45 ec             	add    %eax,-0x14(%ebp)
  8025d3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8025da:	0f 86 3c ff ff ff    	jbe    80251c <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8025e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ec:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8025f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025f6:	75 17                	jne    80260f <free_block+0x265>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 bc 34 80 00       	push   $0x8034bc
  802600:	68 fe 00 00 00       	push   $0xfe
  802605:	68 43 34 80 00       	push   $0x803443
  80260a:	e8 fb 01 00 00       	call   80280a <_panic>
  80260f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0c                	je     802631 <free_block+0x287>
  802625:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80262a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80262d:	89 10                	mov    %edx,(%eax)
  80262f:	eb 08                	jmp    802639 <free_block+0x28f>
  802631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802634:	a3 48 40 80 00       	mov    %eax,0x804048
  802639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	a1 54 40 80 00       	mov    0x804054,%eax
  80264f:	40                   	inc    %eax
  802650:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802655:	83 ec 0c             	sub    $0xc,%esp
  802658:	ff 75 e4             	pushl  -0x1c(%ebp)
  80265b:	e8 88 f5 ff ff       	call   801be8 <to_page_va>
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	50                   	push   %eax
  802667:	e8 b8 ee ff ff       	call   801524 <return_page>
  80266c:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80266f:	90                   	nop
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 68 35 80 00       	push   $0x803568
  802680:	68 11 01 00 00       	push   $0x111
  802685:	68 43 34 80 00       	push   $0x803443
  80268a:	e8 7b 01 00 00       	call   80280a <_panic>

0080268f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 8c 35 80 00       	push   $0x80358c
  80269d:	6a 07                	push   $0x7
  80269f:	68 bb 35 80 00       	push   $0x8035bb
  8026a4:	e8 61 01 00 00       	call   80280a <_panic>

008026a9 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8026af:	83 ec 04             	sub    $0x4,%esp
  8026b2:	68 cc 35 80 00       	push   $0x8035cc
  8026b7:	6a 0b                	push   $0xb
  8026b9:	68 bb 35 80 00       	push   $0x8035bb
  8026be:	e8 47 01 00 00       	call   80280a <_panic>

008026c3 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	68 f8 35 80 00       	push   $0x8035f8
  8026d1:	6a 10                	push   $0x10
  8026d3:	68 bb 35 80 00       	push   $0x8035bb
  8026d8:	e8 2d 01 00 00       	call   80280a <_panic>

008026dd <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 28 36 80 00       	push   $0x803628
  8026eb:	6a 15                	push   $0x15
  8026ed:	68 bb 35 80 00       	push   $0x8035bb
  8026f2:	e8 13 01 00 00       	call   80280a <_panic>

008026f7 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	8b 40 10             	mov    0x10(%eax),%eax
}
  802700:	5d                   	pop    %ebp
  802701:	c3                   	ret    

00802702 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  802708:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80270c:	74 1c                	je     80272a <init_uspinlock+0x28>
  80270e:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  802712:	74 16                	je     80272a <init_uspinlock+0x28>
  802714:	68 58 36 80 00       	push   $0x803658
  802719:	68 77 36 80 00       	push   $0x803677
  80271e:	6a 10                	push   $0x10
  802720:	68 8c 36 80 00       	push   $0x80368c
  802725:	e8 e0 00 00 00       	call   80280a <_panic>
	strcpy(lk->name, name);
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	83 c0 04             	add    $0x4,%eax
  802730:	83 ec 08             	sub    $0x8,%esp
  802733:	ff 75 0c             	pushl  0xc(%ebp)
  802736:	50                   	push   %eax
  802737:	e8 8e e5 ff ff       	call   800cca <strcpy>
  80273c:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80273f:	b8 01 00 00 00       	mov    $0x1,%eax
  802744:	2b 45 10             	sub    0x10(%ebp),%eax
  802747:	89 c2                	mov    %eax,%edx
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
}
  80274e:	90                   	nop
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  802757:	90                   	nop
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  802765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80276e:	f0 87 02             	lock xchg %eax,(%edx)
  802771:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	75 dd                	jne    802758 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	8d 48 04             	lea    0x4(%eax),%ecx
  802781:	a1 20 40 80 00       	mov    0x804020,%eax
  802786:	8d 50 20             	lea    0x20(%eax),%edx
  802789:	a1 20 40 80 00       	mov    0x804020,%eax
  80278e:	8b 40 10             	mov    0x10(%eax),%eax
  802791:	51                   	push   %ecx
  802792:	52                   	push   %edx
  802793:	50                   	push   %eax
  802794:	68 9c 36 80 00       	push   $0x80369c
  802799:	e8 04 de ff ff       	call   8005a2 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8027a1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8027a6:	90                   	nop
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	75 18                	jne    8027d0 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	83 c0 04             	add    $0x4,%eax
  8027be:	50                   	push   %eax
  8027bf:	68 c0 36 80 00       	push   $0x8036c0
  8027c4:	6a 2b                	push   $0x2b
  8027c6:	68 8c 36 80 00       	push   $0x80368c
  8027cb:	e8 3a 00 00 00       	call   80280a <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8027d0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	8d 48 04             	lea    0x4(%eax),%ecx
  8027e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8027ec:	8d 50 20             	lea    0x20(%eax),%edx
  8027ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8027f4:	8b 40 10             	mov    0x10(%eax),%eax
  8027f7:	51                   	push   %ecx
  8027f8:	52                   	push   %edx
  8027f9:	50                   	push   %eax
  8027fa:	68 e0 36 80 00       	push   $0x8036e0
  8027ff:	e8 9e dd ff ff       	call   8005a2 <cprintf>
  802804:	83 c4 10             	add    $0x10,%esp
}
  802807:	90                   	nop
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802810:	8d 45 10             	lea    0x10(%ebp),%eax
  802813:	83 c0 04             	add    $0x4,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802819:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	74 16                	je     802838 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802822:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802827:	83 ec 08             	sub    $0x8,%esp
  80282a:	50                   	push   %eax
  80282b:	68 04 37 80 00       	push   $0x803704
  802830:	e8 6d dd ff ff       	call   8005a2 <cprintf>
  802835:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802838:	a1 04 40 80 00       	mov    0x804004,%eax
  80283d:	83 ec 0c             	sub    $0xc,%esp
  802840:	ff 75 0c             	pushl  0xc(%ebp)
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	50                   	push   %eax
  802847:	68 0c 37 80 00       	push   $0x80370c
  80284c:	6a 74                	push   $0x74
  80284e:	e8 7c dd ff ff       	call   8005cf <cprintf_colored>
  802853:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802856:	8b 45 10             	mov    0x10(%ebp),%eax
  802859:	83 ec 08             	sub    $0x8,%esp
  80285c:	ff 75 f4             	pushl  -0xc(%ebp)
  80285f:	50                   	push   %eax
  802860:	e8 ce dc ff ff       	call   800533 <vcprintf>
  802865:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802868:	83 ec 08             	sub    $0x8,%esp
  80286b:	6a 00                	push   $0x0
  80286d:	68 34 37 80 00       	push   $0x803734
  802872:	e8 bc dc ff ff       	call   800533 <vcprintf>
  802877:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80287a:	e8 35 dc ff ff       	call   8004b4 <exit>

	// should not return here
	while (1) ;
  80287f:	eb fe                	jmp    80287f <_panic+0x75>

00802881 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
  802884:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802887:	a1 20 40 80 00       	mov    0x804020,%eax
  80288c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802892:	8b 45 0c             	mov    0xc(%ebp),%eax
  802895:	39 c2                	cmp    %eax,%edx
  802897:	74 14                	je     8028ad <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802899:	83 ec 04             	sub    $0x4,%esp
  80289c:	68 38 37 80 00       	push   $0x803738
  8028a1:	6a 26                	push   $0x26
  8028a3:	68 84 37 80 00       	push   $0x803784
  8028a8:	e8 5d ff ff ff       	call   80280a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8028ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8028b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028bb:	e9 c5 00 00 00       	jmp    802985 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	75 08                	jne    8028dd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8028d5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8028d8:	e9 a5 00 00 00       	jmp    802982 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8028dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028eb:	eb 69                	jmp    802956 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8028ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8028f2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8028f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fb:	89 d0                	mov    %edx,%eax
  8028fd:	01 c0                	add    %eax,%eax
  8028ff:	01 d0                	add    %edx,%eax
  802901:	c1 e0 03             	shl    $0x3,%eax
  802904:	01 c8                	add    %ecx,%eax
  802906:	8a 40 04             	mov    0x4(%eax),%al
  802909:	84 c0                	test   %al,%al
  80290b:	75 46                	jne    802953 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80290d:	a1 20 40 80 00       	mov    0x804020,%eax
  802912:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802918:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	01 c0                	add    %eax,%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	c1 e0 03             	shl    $0x3,%eax
  802924:	01 c8                	add    %ecx,%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80292b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80292e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802933:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	01 c8                	add    %ecx,%eax
  802944:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802946:	39 c2                	cmp    %eax,%edx
  802948:	75 09                	jne    802953 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80294a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802951:	eb 15                	jmp    802968 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802953:	ff 45 e8             	incl   -0x18(%ebp)
  802956:	a1 20 40 80 00       	mov    0x804020,%eax
  80295b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802964:	39 c2                	cmp    %eax,%edx
  802966:	77 85                	ja     8028ed <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802968:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80296c:	75 14                	jne    802982 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	68 90 37 80 00       	push   $0x803790
  802976:	6a 3a                	push   $0x3a
  802978:	68 84 37 80 00       	push   $0x803784
  80297d:	e8 88 fe ff ff       	call   80280a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802982:	ff 45 f0             	incl   -0x10(%ebp)
  802985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802988:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80298b:	0f 8c 2f ff ff ff    	jl     8028c0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802991:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802998:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80299f:	eb 26                	jmp    8029c7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8029a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8029a6:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8029ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029af:	89 d0                	mov    %edx,%eax
  8029b1:	01 c0                	add    %eax,%eax
  8029b3:	01 d0                	add    %edx,%eax
  8029b5:	c1 e0 03             	shl    $0x3,%eax
  8029b8:	01 c8                	add    %ecx,%eax
  8029ba:	8a 40 04             	mov    0x4(%eax),%al
  8029bd:	3c 01                	cmp    $0x1,%al
  8029bf:	75 03                	jne    8029c4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8029c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029c4:	ff 45 e0             	incl   -0x20(%ebp)
  8029c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8029cc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d5:	39 c2                	cmp    %eax,%edx
  8029d7:	77 c8                	ja     8029a1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029df:	74 14                	je     8029f5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 e4 37 80 00       	push   $0x8037e4
  8029e9:	6a 44                	push   $0x44
  8029eb:	68 84 37 80 00       	push   $0x803784
  8029f0:	e8 15 fe ff ff       	call   80280a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8029f5:	90                   	nop
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <__udivdi3>:
  8029f8:	55                   	push   %ebp
  8029f9:	57                   	push   %edi
  8029fa:	56                   	push   %esi
  8029fb:	53                   	push   %ebx
  8029fc:	83 ec 1c             	sub    $0x1c,%esp
  8029ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a0f:	89 ca                	mov    %ecx,%edx
  802a11:	89 f8                	mov    %edi,%eax
  802a13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a17:	85 f6                	test   %esi,%esi
  802a19:	75 2d                	jne    802a48 <__udivdi3+0x50>
  802a1b:	39 cf                	cmp    %ecx,%edi
  802a1d:	77 65                	ja     802a84 <__udivdi3+0x8c>
  802a1f:	89 fd                	mov    %edi,%ebp
  802a21:	85 ff                	test   %edi,%edi
  802a23:	75 0b                	jne    802a30 <__udivdi3+0x38>
  802a25:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2a:	31 d2                	xor    %edx,%edx
  802a2c:	f7 f7                	div    %edi
  802a2e:	89 c5                	mov    %eax,%ebp
  802a30:	31 d2                	xor    %edx,%edx
  802a32:	89 c8                	mov    %ecx,%eax
  802a34:	f7 f5                	div    %ebp
  802a36:	89 c1                	mov    %eax,%ecx
  802a38:	89 d8                	mov    %ebx,%eax
  802a3a:	f7 f5                	div    %ebp
  802a3c:	89 cf                	mov    %ecx,%edi
  802a3e:	89 fa                	mov    %edi,%edx
  802a40:	83 c4 1c             	add    $0x1c,%esp
  802a43:	5b                   	pop    %ebx
  802a44:	5e                   	pop    %esi
  802a45:	5f                   	pop    %edi
  802a46:	5d                   	pop    %ebp
  802a47:	c3                   	ret    
  802a48:	39 ce                	cmp    %ecx,%esi
  802a4a:	77 28                	ja     802a74 <__udivdi3+0x7c>
  802a4c:	0f bd fe             	bsr    %esi,%edi
  802a4f:	83 f7 1f             	xor    $0x1f,%edi
  802a52:	75 40                	jne    802a94 <__udivdi3+0x9c>
  802a54:	39 ce                	cmp    %ecx,%esi
  802a56:	72 0a                	jb     802a62 <__udivdi3+0x6a>
  802a58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a5c:	0f 87 9e 00 00 00    	ja     802b00 <__udivdi3+0x108>
  802a62:	b8 01 00 00 00       	mov    $0x1,%eax
  802a67:	89 fa                	mov    %edi,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d 76 00             	lea    0x0(%esi),%esi
  802a74:	31 ff                	xor    %edi,%edi
  802a76:	31 c0                	xor    %eax,%eax
  802a78:	89 fa                	mov    %edi,%edx
  802a7a:	83 c4 1c             	add    $0x1c,%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    
  802a82:	66 90                	xchg   %ax,%ax
  802a84:	89 d8                	mov    %ebx,%eax
  802a86:	f7 f7                	div    %edi
  802a88:	31 ff                	xor    %edi,%edi
  802a8a:	89 fa                	mov    %edi,%edx
  802a8c:	83 c4 1c             	add    $0x1c,%esp
  802a8f:	5b                   	pop    %ebx
  802a90:	5e                   	pop    %esi
  802a91:	5f                   	pop    %edi
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    
  802a94:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a99:	89 eb                	mov    %ebp,%ebx
  802a9b:	29 fb                	sub    %edi,%ebx
  802a9d:	89 f9                	mov    %edi,%ecx
  802a9f:	d3 e6                	shl    %cl,%esi
  802aa1:	89 c5                	mov    %eax,%ebp
  802aa3:	88 d9                	mov    %bl,%cl
  802aa5:	d3 ed                	shr    %cl,%ebp
  802aa7:	89 e9                	mov    %ebp,%ecx
  802aa9:	09 f1                	or     %esi,%ecx
  802aab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802aaf:	89 f9                	mov    %edi,%ecx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 c5                	mov    %eax,%ebp
  802ab5:	89 d6                	mov    %edx,%esi
  802ab7:	88 d9                	mov    %bl,%cl
  802ab9:	d3 ee                	shr    %cl,%esi
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e2                	shl    %cl,%edx
  802abf:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ac3:	88 d9                	mov    %bl,%cl
  802ac5:	d3 e8                	shr    %cl,%eax
  802ac7:	09 c2                	or     %eax,%edx
  802ac9:	89 d0                	mov    %edx,%eax
  802acb:	89 f2                	mov    %esi,%edx
  802acd:	f7 74 24 0c          	divl   0xc(%esp)
  802ad1:	89 d6                	mov    %edx,%esi
  802ad3:	89 c3                	mov    %eax,%ebx
  802ad5:	f7 e5                	mul    %ebp
  802ad7:	39 d6                	cmp    %edx,%esi
  802ad9:	72 19                	jb     802af4 <__udivdi3+0xfc>
  802adb:	74 0b                	je     802ae8 <__udivdi3+0xf0>
  802add:	89 d8                	mov    %ebx,%eax
  802adf:	31 ff                	xor    %edi,%edi
  802ae1:	e9 58 ff ff ff       	jmp    802a3e <__udivdi3+0x46>
  802ae6:	66 90                	xchg   %ax,%ax
  802ae8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802aec:	89 f9                	mov    %edi,%ecx
  802aee:	d3 e2                	shl    %cl,%edx
  802af0:	39 c2                	cmp    %eax,%edx
  802af2:	73 e9                	jae    802add <__udivdi3+0xe5>
  802af4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802af7:	31 ff                	xor    %edi,%edi
  802af9:	e9 40 ff ff ff       	jmp    802a3e <__udivdi3+0x46>
  802afe:	66 90                	xchg   %ax,%ax
  802b00:	31 c0                	xor    %eax,%eax
  802b02:	e9 37 ff ff ff       	jmp    802a3e <__udivdi3+0x46>
  802b07:	90                   	nop

00802b08 <__umoddi3>:
  802b08:	55                   	push   %ebp
  802b09:	57                   	push   %edi
  802b0a:	56                   	push   %esi
  802b0b:	53                   	push   %ebx
  802b0c:	83 ec 1c             	sub    $0x1c,%esp
  802b0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b13:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b27:	89 f3                	mov    %esi,%ebx
  802b29:	89 fa                	mov    %edi,%edx
  802b2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b2f:	89 34 24             	mov    %esi,(%esp)
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 1a                	jne    802b50 <__umoddi3+0x48>
  802b36:	39 f7                	cmp    %esi,%edi
  802b38:	0f 86 a2 00 00 00    	jbe    802be0 <__umoddi3+0xd8>
  802b3e:	89 c8                	mov    %ecx,%eax
  802b40:	89 f2                	mov    %esi,%edx
  802b42:	f7 f7                	div    %edi
  802b44:	89 d0                	mov    %edx,%eax
  802b46:	31 d2                	xor    %edx,%edx
  802b48:	83 c4 1c             	add    $0x1c,%esp
  802b4b:	5b                   	pop    %ebx
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	39 f0                	cmp    %esi,%eax
  802b52:	0f 87 ac 00 00 00    	ja     802c04 <__umoddi3+0xfc>
  802b58:	0f bd e8             	bsr    %eax,%ebp
  802b5b:	83 f5 1f             	xor    $0x1f,%ebp
  802b5e:	0f 84 ac 00 00 00    	je     802c10 <__umoddi3+0x108>
  802b64:	bf 20 00 00 00       	mov    $0x20,%edi
  802b69:	29 ef                	sub    %ebp,%edi
  802b6b:	89 fe                	mov    %edi,%esi
  802b6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b71:	89 e9                	mov    %ebp,%ecx
  802b73:	d3 e0                	shl    %cl,%eax
  802b75:	89 d7                	mov    %edx,%edi
  802b77:	89 f1                	mov    %esi,%ecx
  802b79:	d3 ef                	shr    %cl,%edi
  802b7b:	09 c7                	or     %eax,%edi
  802b7d:	89 e9                	mov    %ebp,%ecx
  802b7f:	d3 e2                	shl    %cl,%edx
  802b81:	89 14 24             	mov    %edx,(%esp)
  802b84:	89 d8                	mov    %ebx,%eax
  802b86:	d3 e0                	shl    %cl,%eax
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b8e:	d3 e0                	shl    %cl,%eax
  802b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b94:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b98:	89 f1                	mov    %esi,%ecx
  802b9a:	d3 e8                	shr    %cl,%eax
  802b9c:	09 d0                	or     %edx,%eax
  802b9e:	d3 eb                	shr    %cl,%ebx
  802ba0:	89 da                	mov    %ebx,%edx
  802ba2:	f7 f7                	div    %edi
  802ba4:	89 d3                	mov    %edx,%ebx
  802ba6:	f7 24 24             	mull   (%esp)
  802ba9:	89 c6                	mov    %eax,%esi
  802bab:	89 d1                	mov    %edx,%ecx
  802bad:	39 d3                	cmp    %edx,%ebx
  802baf:	0f 82 87 00 00 00    	jb     802c3c <__umoddi3+0x134>
  802bb5:	0f 84 91 00 00 00    	je     802c4c <__umoddi3+0x144>
  802bbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bbf:	29 f2                	sub    %esi,%edx
  802bc1:	19 cb                	sbb    %ecx,%ebx
  802bc3:	89 d8                	mov    %ebx,%eax
  802bc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802bc9:	d3 e0                	shl    %cl,%eax
  802bcb:	89 e9                	mov    %ebp,%ecx
  802bcd:	d3 ea                	shr    %cl,%edx
  802bcf:	09 d0                	or     %edx,%eax
  802bd1:	89 e9                	mov    %ebp,%ecx
  802bd3:	d3 eb                	shr    %cl,%ebx
  802bd5:	89 da                	mov    %ebx,%edx
  802bd7:	83 c4 1c             	add    $0x1c,%esp
  802bda:	5b                   	pop    %ebx
  802bdb:	5e                   	pop    %esi
  802bdc:	5f                   	pop    %edi
  802bdd:	5d                   	pop    %ebp
  802bde:	c3                   	ret    
  802bdf:	90                   	nop
  802be0:	89 fd                	mov    %edi,%ebp
  802be2:	85 ff                	test   %edi,%edi
  802be4:	75 0b                	jne    802bf1 <__umoddi3+0xe9>
  802be6:	b8 01 00 00 00       	mov    $0x1,%eax
  802beb:	31 d2                	xor    %edx,%edx
  802bed:	f7 f7                	div    %edi
  802bef:	89 c5                	mov    %eax,%ebp
  802bf1:	89 f0                	mov    %esi,%eax
  802bf3:	31 d2                	xor    %edx,%edx
  802bf5:	f7 f5                	div    %ebp
  802bf7:	89 c8                	mov    %ecx,%eax
  802bf9:	f7 f5                	div    %ebp
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	e9 44 ff ff ff       	jmp    802b46 <__umoddi3+0x3e>
  802c02:	66 90                	xchg   %ax,%ax
  802c04:	89 c8                	mov    %ecx,%eax
  802c06:	89 f2                	mov    %esi,%edx
  802c08:	83 c4 1c             	add    $0x1c,%esp
  802c0b:	5b                   	pop    %ebx
  802c0c:	5e                   	pop    %esi
  802c0d:	5f                   	pop    %edi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    
  802c10:	3b 04 24             	cmp    (%esp),%eax
  802c13:	72 06                	jb     802c1b <__umoddi3+0x113>
  802c15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c19:	77 0f                	ja     802c2a <__umoddi3+0x122>
  802c1b:	89 f2                	mov    %esi,%edx
  802c1d:	29 f9                	sub    %edi,%ecx
  802c1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c23:	89 14 24             	mov    %edx,(%esp)
  802c26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c2e:	8b 14 24             	mov    (%esp),%edx
  802c31:	83 c4 1c             	add    $0x1c,%esp
  802c34:	5b                   	pop    %ebx
  802c35:	5e                   	pop    %esi
  802c36:	5f                   	pop    %edi
  802c37:	5d                   	pop    %ebp
  802c38:	c3                   	ret    
  802c39:	8d 76 00             	lea    0x0(%esi),%esi
  802c3c:	2b 04 24             	sub    (%esp),%eax
  802c3f:	19 fa                	sbb    %edi,%edx
  802c41:	89 d1                	mov    %edx,%ecx
  802c43:	89 c6                	mov    %eax,%esi
  802c45:	e9 71 ff ff ff       	jmp    802bbb <__umoddi3+0xb3>
  802c4a:	66 90                	xchg   %ax,%ax
  802c4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c50:	72 ea                	jb     802c3c <__umoddi3+0x134>
  802c52:	89 d9                	mov    %ebx,%ecx
  802c54:	e9 62 ff ff ff       	jmp    802bbb <__umoddi3+0xb3>
