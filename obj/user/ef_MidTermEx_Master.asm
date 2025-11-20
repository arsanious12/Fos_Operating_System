
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 8b 02 00 00       	call   8002c1 <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 20 2b 80 00       	push   $0x802b20
  800050:	e8 f4 16 00 00       	call   801749 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*X = 5 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  800064:	c6 45 e3 79          	movb   $0x79,-0x1d(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	6a 04                	push   $0x4
  80006f:	68 22 2b 80 00       	push   $0x802b22
  800074:	e8 d0 16 00 00       	call   801749 <smalloc>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	*useSem = 0 ;
  80007f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800088:	80 7d e3 59          	cmpb   $0x59,-0x1d(%ebp)
  80008c:	74 06                	je     800094 <_main+0x5c>
  80008e:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  800092:	75 09                	jne    80009d <_main+0x65>
		*useSem = 1 ;
  800094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800097:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	struct semaphore T, finished, finishedCountMutex ;
	int *numOfFinished ;
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	6a 01                	push   $0x1
  8000a2:	6a 04                	push   $0x4
  8000a4:	68 29 2b 80 00       	push   $0x802b29
  8000a9:	e8 9b 16 00 00       	call   801749 <smalloc>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	*numOfFinished = 0 ;
  8000b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	if (*useSem == 1)
  8000bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	83 f8 01             	cmp    $0x1,%eax
  8000c5:	75 42                	jne    800109 <_main+0xd1>
	{
		T = create_semaphore("T", 0);
  8000c7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 37 2b 80 00       	push   $0x802b37
  8000d4:	50                   	push   %eax
  8000d5:	e8 52 27 00 00       	call   80282c <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  8000dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 00                	push   $0x0
  8000e5:	68 39 2b 80 00       	push   $0x802b39
  8000ea:	50                   	push   %eax
  8000eb:	e8 3c 27 00 00       	call   80282c <create_semaphore>
  8000f0:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  8000f3:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 42 2b 80 00       	push   $0x802b42
  800100:	50                   	push   %eax
  800101:	e8 26 27 00 00       	call   80282c <create_semaphore>
  800106:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 40 80 00       	mov    0x804020,%eax
  80011b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800121:	6a 32                	push   $0x32
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	68 55 2b 80 00       	push   $0x802b55
  80012a:	e8 26 19 00 00       	call   801a55 <sys_create_env>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800135:	a1 20 40 80 00       	mov    0x804020,%eax
  80013a:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800140:	89 c2                	mov    %eax,%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80014d:	6a 32                	push   $0x32
  80014f:	52                   	push   %edx
  800150:	50                   	push   %eax
  800151:	68 5f 2b 80 00       	push   $0x802b5f
  800156:	e8 fa 18 00 00       	call   801a55 <sys_create_env>
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800161:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800165:	74 06                	je     80016d <_main+0x135>
  800167:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  80016b:	75 14                	jne    800181 <_main+0x149>
		panic("NO AVAILABLE ENVs...");
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 69 2b 80 00       	push   $0x802b69
  800175:	6a 2b                	push   $0x2b
  800177:	68 7e 2b 80 00       	push   $0x802b7e
  80017c:	e8 f0 02 00 00       	call   800471 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 e7 18 00 00       	call   801a73 <sys_run_env>
  80018c:	83 c4 10             	add    $0x10,%esp
	//env_sleep(10000);
	sys_run_env(envIdProcessB);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 d0             	pushl  -0x30(%ebp)
  800195:	e8 d9 18 00 00       	call   801a73 <sys_run_env>
  80019a:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	if (*useSem == 1)
  80019d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	83 f8 01             	cmp    $0x1,%eax
  8001a5:	75 1e                	jne    8001c5 <_main+0x18d>
	{
		wait_semaphore(finished);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 c0             	pushl  -0x40(%ebp)
  8001ad:	e8 ae 26 00 00       	call   802860 <wait_semaphore>
  8001b2:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8001bb:	e8 a0 26 00 00       	call   802860 <wait_semaphore>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	eb 0b                	jmp    8001d0 <_main+0x198>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8001c5:	90                   	nop
  8001c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c9:	8b 00                	mov    (%eax),%eax
  8001cb:	83 f8 02             	cmp    $0x2,%eax
  8001ce:	75 f6                	jne    8001c6 <_main+0x18e>
	}

	/*[6] PRINT X*/
	atomic_cprintf("Final value of X = %d\n", *X);
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	50                   	push   %eax
  8001d9:	68 99 2b 80 00       	push   $0x802b99
  8001de:	e8 ce 05 00 00       	call   8007b1 <atomic_cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp

	//ensure that X has the expected value (=11)
	if (*X != 11)
  8001e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	83 f8 0b             	cmp    $0xb,%eax
  8001ee:	74 14                	je     800204 <_main+0x1cc>
		panic("Final value of X is not correct. Semaphore and/or shared variables are not working correctly\n");
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 b0 2b 80 00       	push   $0x802bb0
  8001f8:	6a 42                	push   $0x42
  8001fa:	68 7e 2b 80 00       	push   $0x802b7e
  8001ff:	e8 6d 02 00 00       	call   800471 <_panic>

	int32 parentenvID = sys_getparentenvid();
  800204:	e8 d3 18 00 00       	call   801adc <sys_getparentenvid>
  800209:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(parentenvID > 0)
  80020c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800210:	0f 8e a2 00 00 00    	jle    8002b8 <_main+0x280>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  800216:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	68 29 2b 80 00       	push   $0x802b29
  800225:	ff 75 cc             	pushl  -0x34(%ebp)
  800228:	e8 50 15 00 00       	call   80177d <sget>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	89 45 c8             	mov    %eax,-0x38(%ebp)

		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames
		char changeIntCmd[100] = "__changeInterruptStatus__";
  800233:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800239:	bb 0e 2c 80 00       	mov    $0x802c0e,%ebx
  80023e:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800243:	89 c7                	mov    %eax,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	89 d1                	mov    %edx,%ecx
  800249:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024b:	8d 95 72 ff ff ff    	lea    -0x8e(%ebp),%edx
  800251:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800256:	b0 00                	mov    $0x0,%al
  800258:	89 d7                	mov    %edx,%edi
  80025a:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	6a 00                	push   $0x0
  800261:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800267:	50                   	push   %eax
  800268:	e8 8c 1a 00 00       	call   801cf9 <sys_utilities>
  80026d:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(envIdProcessA);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	ff 75 d4             	pushl  -0x2c(%ebp)
  800276:	e8 14 18 00 00       	call   801a8f <sys_destroy_env>
  80027b:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdProcessB);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 d0             	pushl  -0x30(%ebp)
  800284:	e8 06 18 00 00       	call   801a8f <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	6a 01                	push   $0x1
  800291:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 5c 1a 00 00       	call   801cf9 <sys_utilities>
  80029d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002a0:	e8 a5 15 00 00       	call   80184a <sys_lock_cons>
		{
			(*AllFinish)++ ;
  8002a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	8d 50 01             	lea    0x1(%eax),%edx
  8002ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002b0:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8002b2:	e8 ad 15 00 00       	call   801864 <sys_unlock_cons>
	}

	return;
  8002b7:	90                   	nop
  8002b8:	90                   	nop
}
  8002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ca:	e8 f4 17 00 00       	call   801ac3 <sys_getenvindex>
  8002cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	c1 e0 02             	shl    $0x2,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	c1 e0 03             	shl    $0x3,%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	c1 e0 02             	shl    $0x2,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8a 40 20             	mov    0x20(%eax),%al
  8002ff:	84 c0                	test   %al,%al
  800301:	74 0d                	je     800310 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	83 c0 20             	add    $0x20,%eax
  80030b:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x5f>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800331:	a1 00 40 80 00       	mov    0x804000,%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	0f 84 01 01 00 00    	je     80043f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80033e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800344:	bb 6c 2d 80 00       	mov    $0x802d6c,%ebx
  800349:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034e:	89 c7                	mov    %eax,%edi
  800350:	89 de                	mov    %ebx,%esi
  800352:	89 d1                	mov    %edx,%ecx
  800354:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800356:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800359:	b9 56 00 00 00       	mov    $0x56,%ecx
  80035e:	b0 00                	mov    $0x0,%al
  800360:	89 d7                	mov    %edx,%edi
  800362:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800364:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80036b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800378:	50                   	push   %eax
  800379:	e8 7b 19 00 00       	call   801cf9 <sys_utilities>
  80037e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800381:	e8 c4 14 00 00       	call   80184a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 8c 2c 80 00       	push   $0x802c8c
  80038e:	e8 ac 03 00 00       	call   80073f <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	85 c0                	test   %eax,%eax
  80039b:	74 18                	je     8003b5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80039d:	e8 75 19 00 00       	call   801d17 <sys_get_optimal_num_faults>
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 b4 2c 80 00       	push   $0x802cb4
  8003ab:	e8 8f 03 00 00       	call   80073f <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	eb 59                	jmp    80040e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c5:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	52                   	push   %edx
  8003cf:	50                   	push   %eax
  8003d0:	68 d8 2c 80 00       	push   $0x802cd8
  8003d5:	e8 65 03 00 00       	call   80073f <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e2:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003fe:	51                   	push   %ecx
  8003ff:	52                   	push   %edx
  800400:	50                   	push   %eax
  800401:	68 00 2d 80 00       	push   $0x802d00
  800406:	e8 34 03 00 00       	call   80073f <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 58 2d 80 00       	push   $0x802d58
  800422:	e8 18 03 00 00       	call   80073f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	68 8c 2c 80 00       	push   $0x802c8c
  800432:	e8 08 03 00 00       	call   80073f <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80043a:	e8 25 14 00 00       	call   801864 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80043f:	e8 1f 00 00 00       	call   800463 <exit>
}
  800444:	90                   	nop
  800445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800448:	5b                   	pop    %ebx
  800449:	5e                   	pop    %esi
  80044a:	5f                   	pop    %edi
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	6a 00                	push   $0x0
  800458:	e8 32 16 00 00       	call   801a8f <sys_destroy_env>
  80045d:	83 c4 10             	add    $0x10,%esp
}
  800460:	90                   	nop
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <exit>:

void
exit(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800469:	e8 87 16 00 00       	call   801af5 <sys_exit_env>
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800477:	8d 45 10             	lea    0x10(%ebp),%eax
  80047a:	83 c0 04             	add    $0x4,%eax
  80047d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800480:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	74 16                	je     80049f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800489:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	50                   	push   %eax
  800492:	68 d0 2d 80 00       	push   $0x802dd0
  800497:	e8 a3 02 00 00       	call   80073f <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80049f:	a1 04 40 80 00       	mov    0x804004,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 d8 2d 80 00       	push   $0x802dd8
  8004b3:	6a 74                	push   $0x74
  8004b5:	e8 b2 02 00 00       	call   80076c <cprintf_colored>
  8004ba:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c6:	50                   	push   %eax
  8004c7:	e8 04 02 00 00       	call   8006d0 <vcprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	6a 00                	push   $0x0
  8004d4:	68 00 2e 80 00       	push   $0x802e00
  8004d9:	e8 f2 01 00 00       	call   8006d0 <vcprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e1:	e8 7d ff ff ff       	call   800463 <exit>

	// should not return here
	while (1) ;
  8004e6:	eb fe                	jmp    8004e6 <_panic+0x75>

008004e8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fc:	39 c2                	cmp    %eax,%edx
  8004fe:	74 14                	je     800514 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	68 04 2e 80 00       	push   $0x802e04
  800508:	6a 26                	push   $0x26
  80050a:	68 50 2e 80 00       	push   $0x802e50
  80050f:	e8 5d ff ff ff       	call   800471 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800514:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80051b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800522:	e9 c5 00 00 00       	jmp    8005ec <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	75 08                	jne    800544 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80053c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053f:	e9 a5 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800544:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800552:	eb 69                	jmp    8005bd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800554:	a1 20 40 80 00       	mov    0x804020,%eax
  800559:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80055f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800562:	89 d0                	mov    %edx,%eax
  800564:	01 c0                	add    %eax,%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	c1 e0 03             	shl    $0x3,%eax
  80056b:	01 c8                	add    %ecx,%eax
  80056d:	8a 40 04             	mov    0x4(%eax),%al
  800570:	84 c0                	test   %al,%al
  800572:	75 46                	jne    8005ba <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800592:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	01 c8                	add    %ecx,%eax
  8005ab:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ad:	39 c2                	cmp    %eax,%edx
  8005af:	75 09                	jne    8005ba <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005b1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b8:	eb 15                	jmp    8005cf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	ff 45 e8             	incl   -0x18(%ebp)
  8005bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cb:	39 c2                	cmp    %eax,%edx
  8005cd:	77 85                	ja     800554 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d3:	75 14                	jne    8005e9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005d5:	83 ec 04             	sub    $0x4,%esp
  8005d8:	68 5c 2e 80 00       	push   $0x802e5c
  8005dd:	6a 3a                	push   $0x3a
  8005df:	68 50 2e 80 00       	push   $0x802e50
  8005e4:	e8 88 fe ff ff       	call   800471 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e9:	ff 45 f0             	incl   -0x10(%ebp)
  8005ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f2:	0f 8c 2f ff ff ff    	jl     800527 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800606:	eb 26                	jmp    80062e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800608:	a1 20 40 80 00       	mov    0x804020,%eax
  80060d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800613:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800616:	89 d0                	mov    %edx,%eax
  800618:	01 c0                	add    %eax,%eax
  80061a:	01 d0                	add    %edx,%eax
  80061c:	c1 e0 03             	shl    $0x3,%eax
  80061f:	01 c8                	add    %ecx,%eax
  800621:	8a 40 04             	mov    0x4(%eax),%al
  800624:	3c 01                	cmp    $0x1,%al
  800626:	75 03                	jne    80062b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800628:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062b:	ff 45 e0             	incl   -0x20(%ebp)
  80062e:	a1 20 40 80 00       	mov    0x804020,%eax
  800633:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	77 c8                	ja     800608 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800643:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800646:	74 14                	je     80065c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800648:	83 ec 04             	sub    $0x4,%esp
  80064b:	68 b0 2e 80 00       	push   $0x802eb0
  800650:	6a 44                	push   $0x44
  800652:	68 50 2e 80 00       	push   $0x802e50
  800657:	e8 15 fe ff ff       	call   800471 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80065c:	90                   	nop
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	53                   	push   %ebx
  800663:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800666:	8b 45 0c             	mov    0xc(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	8d 48 01             	lea    0x1(%eax),%ecx
  80066e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800671:	89 0a                	mov    %ecx,(%edx)
  800673:	8b 55 08             	mov    0x8(%ebp),%edx
  800676:	88 d1                	mov    %dl,%cl
  800678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	3d ff 00 00 00       	cmp    $0xff,%eax
  800689:	75 30                	jne    8006bb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80068b:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800691:	a0 44 40 80 00       	mov    0x804044,%al
  800696:	0f b6 c0             	movzbl %al,%eax
  800699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80069c:	8b 09                	mov    (%ecx),%ecx
  80069e:	89 cb                	mov    %ecx,%ebx
  8006a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a3:	83 c1 08             	add    $0x8,%ecx
  8006a6:	52                   	push   %edx
  8006a7:	50                   	push   %eax
  8006a8:	53                   	push   %ebx
  8006a9:	51                   	push   %ecx
  8006aa:	e8 57 11 00 00       	call   801806 <sys_cputs>
  8006af:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	8b 40 04             	mov    0x4(%eax),%eax
  8006c1:	8d 50 01             	lea    0x1(%eax),%edx
  8006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ca:	90                   	nop
  8006cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ce:	c9                   	leave  
  8006cf:	c3                   	ret    

008006d0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e0:	00 00 00 
	b.cnt = 0;
  8006e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	ff 75 08             	pushl  0x8(%ebp)
  8006f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	68 5f 06 80 00       	push   $0x80065f
  8006ff:	e8 5a 02 00 00       	call   80095e <vprintfmt>
  800704:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800707:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80070d:	a0 44 40 80 00       	mov    0x804044,%al
  800712:	0f b6 c0             	movzbl %al,%eax
  800715:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80071b:	52                   	push   %edx
  80071c:	50                   	push   %eax
  80071d:	51                   	push   %ecx
  80071e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800724:	83 c0 08             	add    $0x8,%eax
  800727:	50                   	push   %eax
  800728:	e8 d9 10 00 00       	call   801806 <sys_cputs>
  80072d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800730:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800737:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800745:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  80074c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	e8 6f ff ff ff       	call   8006d0 <vcprintf>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800767:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800772:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	c1 e0 08             	shl    $0x8,%eax
  80077f:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800784:	8d 45 0c             	lea    0xc(%ebp),%eax
  800787:	83 c0 04             	add    $0x4,%eax
  80078a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 f4             	pushl  -0xc(%ebp)
  800796:	50                   	push   %eax
  800797:	e8 34 ff ff ff       	call   8006d0 <vcprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007a2:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007a9:	07 00 00 

	return cnt;
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007b7:	e8 8e 10 00 00       	call   80184a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	e8 ff fe ff ff       	call   8006d0 <vcprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007d7:	e8 88 10 00 00       	call   801864 <sys_unlock_cons>
	return cnt;
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	53                   	push   %ebx
  8007e5:	83 ec 14             	sub    $0x14,%esp
  8007e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ff:	77 55                	ja     800856 <printnum+0x75>
  800801:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800804:	72 05                	jb     80080b <printnum+0x2a>
  800806:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800809:	77 4b                	ja     800856 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80080b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80080e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800811:	8b 45 18             	mov    0x18(%ebp),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	52                   	push   %edx
  80081a:	50                   	push   %eax
  80081b:	ff 75 f4             	pushl  -0xc(%ebp)
  80081e:	ff 75 f0             	pushl  -0x10(%ebp)
  800821:	e8 7a 20 00 00       	call   8028a0 <__udivdi3>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	ff 75 20             	pushl  0x20(%ebp)
  80082f:	53                   	push   %ebx
  800830:	ff 75 18             	pushl  0x18(%ebp)
  800833:	52                   	push   %edx
  800834:	50                   	push   %eax
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 a1 ff ff ff       	call   8007e1 <printnum>
  800840:	83 c4 20             	add    $0x20,%esp
  800843:	eb 1a                	jmp    80085f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 20             	pushl  0x20(%ebp)
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	ff d0                	call   *%eax
  800853:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800856:	ff 4d 1c             	decl   0x1c(%ebp)
  800859:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085d:	7f e6                	jg     800845 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800862:	bb 00 00 00 00       	mov    $0x0,%ebx
  800867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086d:	53                   	push   %ebx
  80086e:	51                   	push   %ecx
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	e8 3a 21 00 00       	call   8029b0 <__umoddi3>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	05 14 31 80 00       	add    $0x803114,%eax
  80087e:	8a 00                	mov    (%eax),%al
  800880:	0f be c0             	movsbl %al,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	50                   	push   %eax
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
}
  800892:	90                   	nop
  800893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089f:	7e 1c                	jle    8008bd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	8d 50 08             	lea    0x8(%eax),%edx
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	89 10                	mov    %edx,(%eax)
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	83 e8 08             	sub    $0x8,%eax
  8008b6:	8b 50 04             	mov    0x4(%eax),%edx
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	eb 40                	jmp    8008fd <getuint+0x65>
	else if (lflag)
  8008bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c1:	74 1e                	je     8008e1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 04             	lea    0x4(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 04             	sub    $0x4,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	ba 00 00 00 00       	mov    $0x0,%edx
  8008df:	eb 1c                	jmp    8008fd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	8d 50 04             	lea    0x4(%eax),%edx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	89 10                	mov    %edx,(%eax)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800902:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800906:	7e 1c                	jle    800924 <getint+0x25>
		return va_arg(*ap, long long);
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	8d 50 08             	lea    0x8(%eax),%edx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 10                	mov    %edx,(%eax)
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	83 e8 08             	sub    $0x8,%eax
  80091d:	8b 50 04             	mov    0x4(%eax),%edx
  800920:	8b 00                	mov    (%eax),%eax
  800922:	eb 38                	jmp    80095c <getint+0x5d>
	else if (lflag)
  800924:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800928:	74 1a                	je     800944 <getint+0x45>
		return va_arg(*ap, long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 04             	lea    0x4(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 04             	sub    $0x4,%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	99                   	cltd   
  800942:	eb 18                	jmp    80095c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	8d 50 04             	lea    0x4(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 10                	mov    %edx,(%eax)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	99                   	cltd   
}
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	56                   	push   %esi
  800962:	53                   	push   %ebx
  800963:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800966:	eb 17                	jmp    80097f <vprintfmt+0x21>
			if (ch == '\0')
  800968:	85 db                	test   %ebx,%ebx
  80096a:	0f 84 c1 03 00 00    	je     800d31 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	53                   	push   %ebx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097f:	8b 45 10             	mov    0x10(%ebp),%eax
  800982:	8d 50 01             	lea    0x1(%eax),%edx
  800985:	89 55 10             	mov    %edx,0x10(%ebp)
  800988:	8a 00                	mov    (%eax),%al
  80098a:	0f b6 d8             	movzbl %al,%ebx
  80098d:	83 fb 25             	cmp    $0x25,%ebx
  800990:	75 d6                	jne    800968 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800992:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800996:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b5:	8d 50 01             	lea    0x1(%eax),%edx
  8009b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	0f b6 d8             	movzbl %al,%ebx
  8009c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c3:	83 f8 5b             	cmp    $0x5b,%eax
  8009c6:	0f 87 3d 03 00 00    	ja     800d09 <vprintfmt+0x3ab>
  8009cc:	8b 04 85 38 31 80 00 	mov    0x803138(,%eax,4),%eax
  8009d3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d9:	eb d7                	jmp    8009b2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d1                	jmp    8009b2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	c1 e0 02             	shl    $0x2,%eax
  8009f0:	01 d0                	add    %edx,%eax
  8009f2:	01 c0                	add    %eax,%eax
  8009f4:	01 d8                	add    %ebx,%eax
  8009f6:	83 e8 30             	sub    $0x30,%eax
  8009f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ff:	8a 00                	mov    (%eax),%al
  800a01:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a04:	83 fb 2f             	cmp    $0x2f,%ebx
  800a07:	7e 3e                	jle    800a47 <vprintfmt+0xe9>
  800a09:	83 fb 39             	cmp    $0x39,%ebx
  800a0c:	7f 39                	jg     800a47 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a11:	eb d5                	jmp    8009e8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	83 c0 04             	add    $0x4,%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 e8 04             	sub    $0x4,%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a27:	eb 1f                	jmp    800a48 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2d:	79 83                	jns    8009b2 <vprintfmt+0x54>
				width = 0;
  800a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a36:	e9 77 ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a3b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a42:	e9 6b ff ff ff       	jmp    8009b2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a47:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4c:	0f 89 60 ff ff ff    	jns    8009b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a58:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a5f:	e9 4e ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a64:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a67:	e9 46 ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 c0 04             	add    $0x4,%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 e8 04             	sub    $0x4,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	50                   	push   %eax
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	ff d0                	call   *%eax
  800a89:	83 c4 10             	add    $0x10,%esp
			break;
  800a8c:	e9 9b 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 c0 04             	add    $0x4,%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 e8 04             	sub    $0x4,%eax
  800aa0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	79 02                	jns    800aa8 <vprintfmt+0x14a>
				err = -err;
  800aa6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa8:	83 fb 64             	cmp    $0x64,%ebx
  800aab:	7f 0b                	jg     800ab8 <vprintfmt+0x15a>
  800aad:	8b 34 9d 80 2f 80 00 	mov    0x802f80(,%ebx,4),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 19                	jne    800ad1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab8:	53                   	push   %ebx
  800ab9:	68 25 31 80 00       	push   $0x803125
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 70 02 00 00       	call   800d39 <printfmt>
  800ac9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800acc:	e9 5b 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad1:	56                   	push   %esi
  800ad2:	68 2e 31 80 00       	push   $0x80312e
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 57 02 00 00       	call   800d39 <printfmt>
  800ae2:	83 c4 10             	add    $0x10,%esp
			break;
  800ae5:	e9 42 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 c0 04             	add    $0x4,%eax
  800af0:	89 45 14             	mov    %eax,0x14(%ebp)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 e8 04             	sub    $0x4,%eax
  800af9:	8b 30                	mov    (%eax),%esi
  800afb:	85 f6                	test   %esi,%esi
  800afd:	75 05                	jne    800b04 <vprintfmt+0x1a6>
				p = "(null)";
  800aff:	be 31 31 80 00       	mov    $0x803131,%esi
			if (width > 0 && padc != '-')
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7e 6d                	jle    800b77 <vprintfmt+0x219>
  800b0a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b0e:	74 67                	je     800b77 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	50                   	push   %eax
  800b17:	56                   	push   %esi
  800b18:	e8 1e 03 00 00       	call   800e3b <strnlen>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b23:	eb 16                	jmp    800b3b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b25:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	50                   	push   %eax
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b38:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3f:	7f e4                	jg     800b25 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b41:	eb 34                	jmp    800b77 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b47:	74 1c                	je     800b65 <vprintfmt+0x207>
  800b49:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4c:	7e 05                	jle    800b53 <vprintfmt+0x1f5>
  800b4e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b51:	7e 12                	jle    800b65 <vprintfmt+0x207>
					putch('?', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 3f                	push   $0x3f
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	eb 0f                	jmp    800b74 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b74:	ff 4d e4             	decl   -0x1c(%ebp)
  800b77:	89 f0                	mov    %esi,%eax
  800b79:	8d 70 01             	lea    0x1(%eax),%esi
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f be d8             	movsbl %al,%ebx
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	74 24                	je     800ba9 <vprintfmt+0x24b>
  800b85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b89:	78 b8                	js     800b43 <vprintfmt+0x1e5>
  800b8b:	ff 4d e0             	decl   -0x20(%ebp)
  800b8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b92:	79 af                	jns    800b43 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b94:	eb 13                	jmp    800ba9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 20                	push   $0x20
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bad:	7f e7                	jg     800b96 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800baf:	e9 78 01 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bba:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 3c fd ff ff       	call   8008ff <getint>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd2:	85 d2                	test   %edx,%edx
  800bd4:	79 23                	jns    800bf9 <vprintfmt+0x29b>
				putch('-', putdat);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	6a 2d                	push   $0x2d
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	ff d0                	call   *%eax
  800be3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bec:	f7 d8                	neg    %eax
  800bee:	83 d2 00             	adc    $0x0,%edx
  800bf1:	f7 da                	neg    %edx
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c00:	e9 bc 00 00 00       	jmp    800cc1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0e:	50                   	push   %eax
  800c0f:	e8 84 fc ff ff       	call   800898 <getuint>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c24:	e9 98 00 00 00       	jmp    800cc1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 58                	push   $0x58
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 58                	push   $0x58
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 58                	push   $0x58
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			break;
  800c59:	e9 ce 00 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 30                	push   $0x30
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 78                	push   $0x78
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 14             	mov    %eax,0x14(%ebp)
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca0:	eb 1f                	jmp    800cc1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca8:	8d 45 14             	lea    0x14(%ebp),%eax
  800cab:	50                   	push   %eax
  800cac:	e8 e7 fb ff ff       	call   800898 <getuint>
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc8:	83 ec 04             	sub    $0x4,%esp
  800ccb:	52                   	push   %edx
  800ccc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ccf:	50                   	push   %eax
  800cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 00 fb ff ff       	call   8007e1 <printnum>
  800ce1:	83 c4 20             	add    $0x20,%esp
			break;
  800ce4:	eb 46                	jmp    800d2c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	53                   	push   %ebx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			break;
  800cf5:	eb 35                	jmp    800d2c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cf7:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800cfe:	eb 2c                	jmp    800d2c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d00:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d07:	eb 23                	jmp    800d2c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	6a 25                	push   $0x25
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	ff d0                	call   *%eax
  800d16:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d19:	ff 4d 10             	decl   0x10(%ebp)
  800d1c:	eb 03                	jmp    800d21 <vprintfmt+0x3c3>
  800d1e:	ff 4d 10             	decl   0x10(%ebp)
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	48                   	dec    %eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 25                	cmp    $0x25,%al
  800d29:	75 f3                	jne    800d1e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d2b:	90                   	nop
		}
	}
  800d2c:	e9 35 fc ff ff       	jmp    800966 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d31:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d3f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d42:	83 c0 04             	add    $0x4,%eax
  800d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	ff 75 08             	pushl  0x8(%ebp)
  800d55:	e8 04 fc ff ff       	call   80095e <vprintfmt>
  800d5a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d5d:	90                   	nop
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 40 08             	mov    0x8(%eax),%eax
  800d69:	8d 50 01             	lea    0x1(%eax),%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 10                	mov    (%eax),%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8b 40 04             	mov    0x4(%eax),%eax
  800d7d:	39 c2                	cmp    %eax,%edx
  800d7f:	73 12                	jae    800d93 <sprintputch+0x33>
		*b->buf++ = ch;
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8b 00                	mov    (%eax),%eax
  800d86:	8d 48 01             	lea    0x1(%eax),%ecx
  800d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8c:	89 0a                	mov    %ecx,(%edx)
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	88 10                	mov    %dl,(%eax)
}
  800d93:	90                   	nop
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	01 d0                	add    %edx,%eax
  800dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dbb:	74 06                	je     800dc3 <vsnprintf+0x2d>
  800dbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc1:	7f 07                	jg     800dca <vsnprintf+0x34>
		return -E_INVAL;
  800dc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc8:	eb 20                	jmp    800dea <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dca:	ff 75 14             	pushl  0x14(%ebp)
  800dcd:	ff 75 10             	pushl  0x10(%ebp)
  800dd0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd3:	50                   	push   %eax
  800dd4:	68 60 0d 80 00       	push   $0x800d60
  800dd9:	e8 80 fb ff ff       	call   80095e <vprintfmt>
  800dde:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df2:	8d 45 10             	lea    0x10(%ebp),%eax
  800df5:	83 c0 04             	add    $0x4,%eax
  800df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	ff 75 f4             	pushl  -0xc(%ebp)
  800e01:	50                   	push   %eax
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	ff 75 08             	pushl  0x8(%ebp)
  800e08:	e8 89 ff ff ff       	call   800d96 <vsnprintf>
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e25:	eb 06                	jmp    800e2d <strlen+0x15>
		n++;
  800e27:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 f1                	jne    800e27 <strlen+0xf>
		n++;
	return n;
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e48:	eb 09                	jmp    800e53 <strnlen+0x18>
		n++;
  800e4a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4d:	ff 45 08             	incl   0x8(%ebp)
  800e50:	ff 4d 0c             	decl   0xc(%ebp)
  800e53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e57:	74 09                	je     800e62 <strnlen+0x27>
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	75 e8                	jne    800e4a <strnlen+0xf>
		n++;
	return n;
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e73:	90                   	nop
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 e4                	jne    800e74 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea8:	eb 1f                	jmp    800ec9 <strncpy+0x34>
		*dst++ = *src;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	84 c0                	test   %al,%al
  800ec1:	74 03                	je     800ec6 <strncpy+0x31>
			src++;
  800ec3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ecf:	72 d9                	jb     800eaa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	74 30                	je     800f18 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ee8:	eb 16                	jmp    800f00 <strlcpy+0x2a>
			*dst++ = *src++;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800efc:	8a 12                	mov    (%edx),%dl
  800efe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f00:	ff 4d 10             	decl   0x10(%ebp)
  800f03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f07:	74 09                	je     800f12 <strlcpy+0x3c>
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	84 c0                	test   %al,%al
  800f10:	75 d8                	jne    800eea <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1e:	29 c2                	sub    %eax,%edx
  800f20:	89 d0                	mov    %edx,%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f27:	eb 06                	jmp    800f2f <strcmp+0xb>
		p++, q++;
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	74 0e                	je     800f46 <strcmp+0x22>
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 10                	mov    (%eax),%dl
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	38 c2                	cmp    %al,%dl
  800f44:	74 e3                	je     800f29 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f b6 d0             	movzbl %al,%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 c0             	movzbl %al,%eax
  800f56:	29 c2                	sub    %eax,%edx
  800f58:	89 d0                	mov    %edx,%eax
}
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f5f:	eb 09                	jmp    800f6a <strncmp+0xe>
		n--, p++, q++;
  800f61:	ff 4d 10             	decl   0x10(%ebp)
  800f64:	ff 45 08             	incl   0x8(%ebp)
  800f67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6e:	74 17                	je     800f87 <strncmp+0x2b>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	84 c0                	test   %al,%al
  800f77:	74 0e                	je     800f87 <strncmp+0x2b>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 10                	mov    (%eax),%dl
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	38 c2                	cmp    %al,%dl
  800f85:	74 da                	je     800f61 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8b:	75 07                	jne    800f94 <strncmp+0x38>
		return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f92:	eb 14                	jmp    800fa8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f b6 d0             	movzbl %al,%edx
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 c0             	movzbl %al,%eax
  800fa4:	29 c2                	sub    %eax,%edx
  800fa6:	89 d0                	mov    %edx,%eax
}
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 04             	sub    $0x4,%esp
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb6:	eb 12                	jmp    800fca <strchr+0x20>
		if (*s == c)
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc0:	75 05                	jne    800fc7 <strchr+0x1d>
			return (char *) s;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	eb 11                	jmp    800fd8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fc7:	ff 45 08             	incl   0x8(%ebp)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	84 c0                	test   %al,%al
  800fd1:	75 e5                	jne    800fb8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    

00800fda <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe6:	eb 0d                	jmp    800ff5 <strfind+0x1b>
		if (*s == c)
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff0:	74 0e                	je     801000 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 ea                	jne    800fe8 <strfind+0xe>
  800ffe:	eb 01                	jmp    801001 <strfind+0x27>
		if (*s == c)
			break;
  801000:	90                   	nop
	return (char *) s;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801012:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801016:	76 63                	jbe    80107b <memset+0x75>
		uint64 data_block = c;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	99                   	cltd   
  80101c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80102c:	c1 e0 08             	shl    $0x8,%eax
  80102f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801032:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80103f:	c1 e0 10             	shl    $0x10,%eax
  801042:	09 45 f0             	or     %eax,-0x10(%ebp)
  801045:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	89 c2                	mov    %eax,%edx
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	09 45 f0             	or     %eax,-0x10(%ebp)
  801058:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80105b:	eb 18                	jmp    801075 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80105d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801060:	8d 41 08             	lea    0x8(%ecx),%eax
  801063:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106c:	89 01                	mov    %eax,(%ecx)
  80106e:	89 51 04             	mov    %edx,0x4(%ecx)
  801071:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801075:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801079:	77 e2                	ja     80105d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80107b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107f:	74 23                	je     8010a4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801087:	eb 0e                	jmp    801097 <memset+0x91>
			*p8++ = (uint8)c;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	8d 50 01             	lea    0x1(%eax),%edx
  80108f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801092:	8b 55 0c             	mov    0xc(%ebp),%edx
  801095:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109d:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	75 e5                	jne    801089 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010bb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010bf:	76 24                	jbe    8010e5 <memcpy+0x3c>
		while(n >= 8){
  8010c1:	eb 1c                	jmp    8010df <memcpy+0x36>
			*d64 = *s64;
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	8b 50 04             	mov    0x4(%eax),%edx
  8010c9:	8b 00                	mov    (%eax),%eax
  8010cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ce:	89 01                	mov    %eax,(%ecx)
  8010d0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010d3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010d7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010db:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e3:	77 de                	ja     8010c3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e9:	74 31                	je     80111c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010f7:	eb 16                	jmp    80110f <memcpy+0x66>
			*d8++ = *s8++;
  8010f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fc:	8d 50 01             	lea    0x1(%eax),%edx
  8010ff:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801105:	8d 4a 01             	lea    0x1(%edx),%ecx
  801108:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80110b:	8a 12                	mov    (%edx),%dl
  80110d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	8d 50 ff             	lea    -0x1(%eax),%edx
  801115:	89 55 10             	mov    %edx,0x10(%ebp)
  801118:	85 c0                	test   %eax,%eax
  80111a:	75 dd                	jne    8010f9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801136:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801139:	73 50                	jae    80118b <memmove+0x6a>
  80113b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801146:	76 43                	jbe    80118b <memmove+0x6a>
		s += n;
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801154:	eb 10                	jmp    801166 <memmove+0x45>
			*--d = *--s;
  801156:	ff 4d f8             	decl   -0x8(%ebp)
  801159:	ff 4d fc             	decl   -0x4(%ebp)
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	8a 10                	mov    (%eax),%dl
  801161:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801164:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116c:	89 55 10             	mov    %edx,0x10(%ebp)
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 e3                	jne    801156 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801173:	eb 23                	jmp    801198 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801178:	8d 50 01             	lea    0x1(%eax),%edx
  80117b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80117e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801181:	8d 4a 01             	lea    0x1(%edx),%ecx
  801184:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801187:	8a 12                	mov    (%edx),%dl
  801189:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801191:	89 55 10             	mov    %edx,0x10(%ebp)
  801194:	85 c0                	test   %eax,%eax
  801196:	75 dd                	jne    801175 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011af:	eb 2a                	jmp    8011db <memcmp+0x3e>
		if (*s1 != *s2)
  8011b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b4:	8a 10                	mov    (%eax),%dl
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	38 c2                	cmp    %al,%dl
  8011bd:	74 16                	je     8011d5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	0f b6 d0             	movzbl %al,%edx
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 c0             	movzbl %al,%eax
  8011cf:	29 c2                	sub    %eax,%edx
  8011d1:	89 d0                	mov    %edx,%eax
  8011d3:	eb 18                	jmp    8011ed <memcmp+0x50>
		s1++, s2++;
  8011d5:	ff 45 fc             	incl   -0x4(%ebp)
  8011d8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	75 c9                	jne    8011b1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801200:	eb 15                	jmp    801217 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f b6 d0             	movzbl %al,%edx
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	0f b6 c0             	movzbl %al,%eax
  801210:	39 c2                	cmp    %eax,%edx
  801212:	74 0d                	je     801221 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80121d:	72 e3                	jb     801202 <memfind+0x13>
  80121f:	eb 01                	jmp    801222 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801221:	90                   	nop
	return (void *) s;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80122d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801234:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123b:	eb 03                	jmp    801240 <strtol+0x19>
		s++;
  80123d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 20                	cmp    $0x20,%al
  801247:	74 f4                	je     80123d <strtol+0x16>
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 09                	cmp    $0x9,%al
  801250:	74 eb                	je     80123d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 2b                	cmp    $0x2b,%al
  801259:	75 05                	jne    801260 <strtol+0x39>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
  80125e:	eb 13                	jmp    801273 <strtol+0x4c>
	else if (*s == '-')
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 2d                	cmp    $0x2d,%al
  801267:	75 0a                	jne    801273 <strtol+0x4c>
		s++, neg = 1;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	74 06                	je     80127f <strtol+0x58>
  801279:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80127d:	75 20                	jne    80129f <strtol+0x78>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 30                	cmp    $0x30,%al
  801286:	75 17                	jne    80129f <strtol+0x78>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	40                   	inc    %eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 78                	cmp    $0x78,%al
  801290:	75 0d                	jne    80129f <strtol+0x78>
		s += 2, base = 16;
  801292:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801296:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80129d:	eb 28                	jmp    8012c7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	75 15                	jne    8012ba <strtol+0x93>
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 30                	cmp    $0x30,%al
  8012ac:	75 0c                	jne    8012ba <strtol+0x93>
		s++, base = 8;
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b8:	eb 0d                	jmp    8012c7 <strtol+0xa0>
	else if (base == 0)
  8012ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012be:	75 07                	jne    8012c7 <strtol+0xa0>
		base = 10;
  8012c0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 2f                	cmp    $0x2f,%al
  8012ce:	7e 19                	jle    8012e9 <strtol+0xc2>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 39                	cmp    $0x39,%al
  8012d7:	7f 10                	jg     8012e9 <strtol+0xc2>
			dig = *s - '0';
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	83 e8 30             	sub    $0x30,%eax
  8012e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e7:	eb 42                	jmp    80132b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 60                	cmp    $0x60,%al
  8012f0:	7e 19                	jle    80130b <strtol+0xe4>
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 7a                	cmp    $0x7a,%al
  8012f9:	7f 10                	jg     80130b <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 57             	sub    $0x57,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 20                	jmp    80132b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 40                	cmp    $0x40,%al
  801312:	7e 39                	jle    80134d <strtol+0x126>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 5a                	cmp    $0x5a,%al
  80131b:	7f 30                	jg     80134d <strtol+0x126>
			dig = *s - 'A' + 10;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	83 e8 37             	sub    $0x37,%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801331:	7d 19                	jge    80134c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801333:	ff 45 08             	incl   0x8(%ebp)
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	0f af 45 10          	imul   0x10(%ebp),%eax
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801347:	e9 7b ff ff ff       	jmp    8012c7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80134c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80134d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801351:	74 08                	je     80135b <strtol+0x134>
		*endptr = (char *) s;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8b 55 08             	mov    0x8(%ebp),%edx
  801359:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80135b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135f:	74 07                	je     801368 <strtol+0x141>
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	f7 d8                	neg    %eax
  801366:	eb 03                	jmp    80136b <strtol+0x144>
  801368:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <ltostr>:

void
ltostr(long value, char *str)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80137a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801385:	79 13                	jns    80139a <ltostr+0x2d>
	{
		neg = 1;
  801387:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801394:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801397:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a2:	99                   	cltd   
  8013a3:	f7 f9                	idiv   %ecx
  8013a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ab:	8d 50 01             	lea    0x1(%eax),%edx
  8013ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013bb:	83 c2 30             	add    $0x30,%edx
  8013be:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c8:	f7 e9                	imul   %ecx
  8013ca:	c1 fa 02             	sar    $0x2,%edx
  8013cd:	89 c8                	mov    %ecx,%eax
  8013cf:	c1 f8 1f             	sar    $0x1f,%eax
  8013d2:	29 c2                	sub    %eax,%edx
  8013d4:	89 d0                	mov    %edx,%eax
  8013d6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013dd:	75 bb                	jne    80139a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	48                   	dec    %eax
  8013ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f1:	74 3d                	je     801430 <ltostr+0xc3>
		start = 1 ;
  8013f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013fa:	eb 34                	jmp    801430 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	01 d0                	add    %edx,%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 c2                	add    %eax,%edx
  801411:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	01 c8                	add    %ecx,%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80141d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	01 c2                	add    %eax,%edx
  801425:	8a 45 eb             	mov    -0x15(%ebp),%al
  801428:	88 02                	mov    %al,(%edx)
		start++ ;
  80142a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80142d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801436:	7c c4                	jl     8013fc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801438:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	e8 c4 f9 ff ff       	call   800e18 <strlen>
  801454:	83 c4 04             	add    $0x4,%esp
  801457:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	e8 b6 f9 ff ff       	call   800e18 <strlen>
  801462:	83 c4 04             	add    $0x4,%esp
  801465:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80146f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801476:	eb 17                	jmp    80148f <strcconcat+0x49>
		final[s] = str1[s] ;
  801478:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 c2                	add    %eax,%edx
  801480:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	01 c8                	add    %ecx,%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80148c:	ff 45 fc             	incl   -0x4(%ebp)
  80148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801492:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801495:	7c e1                	jl     801478 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801497:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80149e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a5:	eb 1f                	jmp    8014c6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b0:	89 c2                	mov    %eax,%edx
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	01 c2                	add    %eax,%edx
  8014b7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 c8                	add    %ecx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c3:	ff 45 f8             	incl   -0x8(%ebp)
  8014c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014cc:	7c d9                	jl     8014a7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014eb:	8b 00                	mov    (%eax),%eax
  8014ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ff:	eb 0c                	jmp    80150d <strsplit+0x31>
			*string++ = 0;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8d 50 01             	lea    0x1(%eax),%edx
  801507:	89 55 08             	mov    %edx,0x8(%ebp)
  80150a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	84 c0                	test   %al,%al
  801514:	74 18                	je     80152e <strsplit+0x52>
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	0f be c0             	movsbl %al,%eax
  80151e:	50                   	push   %eax
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	e8 83 fa ff ff       	call   800faa <strchr>
  801527:	83 c4 08             	add    $0x8,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	75 d3                	jne    801501 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	74 5a                	je     801591 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801537:	8b 45 14             	mov    0x14(%ebp),%eax
  80153a:	8b 00                	mov    (%eax),%eax
  80153c:	83 f8 0f             	cmp    $0xf,%eax
  80153f:	75 07                	jne    801548 <strsplit+0x6c>
		{
			return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	eb 66                	jmp    8015ae <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801548:	8b 45 14             	mov    0x14(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	8d 48 01             	lea    0x1(%eax),%ecx
  801550:	8b 55 14             	mov    0x14(%ebp),%edx
  801553:	89 0a                	mov    %ecx,(%edx)
  801555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	01 c2                	add    %eax,%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801566:	eb 03                	jmp    80156b <strsplit+0x8f>
			string++;
  801568:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 8b                	je     8014ff <strsplit+0x23>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	0f be c0             	movsbl %al,%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	e8 25 fa ff ff       	call   800faa <strchr>
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	74 dc                	je     801568 <strsplit+0x8c>
			string++;
	}
  80158c:	e9 6e ff ff ff       	jmp    8014ff <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801591:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801592:	8b 45 14             	mov    0x14(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c3:	eb 4a                	jmp    80160f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	01 c2                	add    %eax,%edx
  8015cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	01 c8                	add    %ecx,%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	3c 40                	cmp    $0x40,%al
  8015e5:	7e 25                	jle    80160c <str2lower+0x5c>
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 d0                	add    %edx,%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	3c 5a                	cmp    $0x5a,%al
  8015f3:	7f 17                	jg     80160c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801600:	8b 55 08             	mov    0x8(%ebp),%edx
  801603:	01 ca                	add    %ecx,%edx
  801605:	8a 12                	mov    (%edx),%dl
  801607:	83 c2 20             	add    $0x20,%edx
  80160a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80160c:	ff 45 fc             	incl   -0x4(%ebp)
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	e8 01 f8 ff ff       	call   800e18 <strlen>
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80161d:	7f a6                	jg     8015c5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80161f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80162a:	a1 08 40 80 00       	mov    0x804008,%eax
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 42                	je     801675 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	68 00 00 00 82       	push   $0x82000000
  80163b:	68 00 00 00 80       	push   $0x80000000
  801640:	e8 00 08 00 00       	call   801e45 <initialize_dynamic_allocator>
  801645:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801648:	e8 e7 05 00 00       	call   801c34 <sys_get_uheap_strategy>
  80164d:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801652:	a1 40 40 80 00       	mov    0x804040,%eax
  801657:	05 00 10 00 00       	add    $0x1000,%eax
  80165c:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801661:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801666:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80166b:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801672:	00 00 00 
	}
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	68 06 04 00 00       	push   $0x406
  801694:	50                   	push   %eax
  801695:	e8 e4 01 00 00       	call   80187e <__sys_allocate_page>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a4:	79 14                	jns    8016ba <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	68 a8 32 80 00       	push   $0x8032a8
  8016ae:	6a 1f                	push   $0x1f
  8016b0:	68 e4 32 80 00       	push   $0x8032e4
  8016b5:	e8 b7 ed ff ff       	call   800471 <_panic>
	return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	50                   	push   %eax
  8016d9:	e8 e7 01 00 00       	call   8018c5 <__sys_unmap_frame>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016e8:	79 14                	jns    8016fe <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	68 f0 32 80 00       	push   $0x8032f0
  8016f2:	6a 2a                	push   $0x2a
  8016f4:	68 e4 32 80 00       	push   $0x8032e4
  8016f9:	e8 73 ed ff ff       	call   800471 <_panic>
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801707:	e8 18 ff ff ff       	call   801624 <uheap_init>
	if (size == 0) return NULL ;
  80170c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801710:	75 07                	jne    801719 <malloc+0x18>
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	eb 14                	jmp    80172d <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	68 30 33 80 00       	push   $0x803330
  801721:	6a 3e                	push   $0x3e
  801723:	68 e4 32 80 00       	push   $0x8032e4
  801728:	e8 44 ed ff ff       	call   800471 <_panic>
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 58 33 80 00       	push   $0x803358
  80173d:	6a 49                	push   $0x49
  80173f:	68 e4 32 80 00       	push   $0x8032e4
  801744:	e8 28 ed ff ff       	call   800471 <_panic>

00801749 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 18             	sub    $0x18,%esp
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801755:	e8 ca fe ff ff       	call   801624 <uheap_init>
	if (size == 0) return NULL ;
  80175a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80175e:	75 07                	jne    801767 <smalloc+0x1e>
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 14                	jmp    80177b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	68 7c 33 80 00       	push   $0x80337c
  80176f:	6a 5a                	push   $0x5a
  801771:	68 e4 32 80 00       	push   $0x8032e4
  801776:	e8 f6 ec ff ff       	call   800471 <_panic>
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801783:	e8 9c fe ff ff       	call   801624 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	68 a4 33 80 00       	push   $0x8033a4
  801790:	6a 6a                	push   $0x6a
  801792:	68 e4 32 80 00       	push   $0x8032e4
  801797:	e8 d5 ec ff ff       	call   800471 <_panic>

0080179c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017a2:	e8 7d fe ff ff       	call   801624 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 c8 33 80 00       	push   $0x8033c8
  8017af:	68 88 00 00 00       	push   $0x88
  8017b4:	68 e4 32 80 00       	push   $0x8032e4
  8017b9:	e8 b3 ec ff ff       	call   800471 <_panic>

008017be <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 f0 33 80 00       	push   $0x8033f0
  8017cc:	68 9b 00 00 00       	push   $0x9b
  8017d1:	68 e4 32 80 00       	push   $0x8032e4
  8017d6:	e8 96 ec ff ff       	call   800471 <_panic>

008017db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f6:	cd 30                	int    $0x30
  8017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801815:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	51                   	push   %ecx
  80181f:	52                   	push   %edx
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	6a 00                	push   $0x0
  801826:	e8 b0 ff ff ff       	call   8017db <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_cgetc>:

int
sys_cgetc(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 02                	push   $0x2
  801840:	e8 96 ff ff ff       	call   8017db <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 03                	push   $0x3
  801859:	e8 7d ff ff ff       	call   8017db <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 04                	push   $0x4
  801873:	e8 63 ff ff ff       	call   8017db <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	90                   	nop
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 08                	push   $0x8
  801891:	e8 45 ff ff ff       	call   8017db <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	51                   	push   %ecx
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 09                	push   $0x9
  8018b6:	e8 20 ff ff ff       	call   8017db <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	6a 0a                	push   $0xa
  8018d5:	e8 01 ff ff ff       	call   8017db <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 0b                	push   $0xb
  8018f0:	e8 e6 fe ff ff       	call   8017db <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 0c                	push   $0xc
  801909:	e8 cd fe ff ff       	call   8017db <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 0d                	push   $0xd
  801922:	e8 b4 fe ff ff       	call   8017db <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0e                	push   $0xe
  80193b:	e8 9b fe ff ff       	call   8017db <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 0f                	push   $0xf
  801954:	e8 82 fe ff ff       	call   8017db <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 10                	push   $0x10
  80196e:	e8 68 fe ff ff       	call   8017db <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 11                	push   $0x11
  801987:	e8 4f fe ff ff       	call   8017db <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_cputc>:

void
sys_cputc(const char c)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	50                   	push   %eax
  8019ab:	6a 01                	push   $0x1
  8019ad:	e8 29 fe ff ff       	call   8017db <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 14                	push   $0x14
  8019c7:	e8 0f fe ff ff       	call   8017db <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	51                   	push   %ecx
  8019eb:	52                   	push   %edx
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 15                	push   $0x15
  8019f2:	e8 e4 fd ff ff       	call   8017db <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 16                	push   $0x16
  801a0f:	e8 c7 fd ff ff       	call   8017db <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	51                   	push   %ecx
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 17                	push   $0x17
  801a2e:	e8 a8 fd ff ff       	call   8017db <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 18                	push   $0x18
  801a4b:	e8 8b fd ff ff       	call   8017db <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 14             	pushl  0x14(%ebp)
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	6a 19                	push   $0x19
  801a69:	e8 6d fd ff ff       	call   8017db <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	50                   	push   %eax
  801a82:	6a 1a                	push   $0x1a
  801a84:	e8 52 fd ff ff       	call   8017db <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	50                   	push   %eax
  801a9e:	6a 1b                	push   $0x1b
  801aa0:	e8 36 fd ff ff       	call   8017db <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 05                	push   $0x5
  801ab9:	e8 1d fd ff ff       	call   8017db <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 06                	push   $0x6
  801ad2:	e8 04 fd ff ff       	call   8017db <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 07                	push   $0x7
  801aeb:	e8 eb fc ff ff       	call   8017db <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_exit_env>:


void sys_exit_env(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 1c                	push   $0x1c
  801b04:	e8 d2 fc ff ff       	call   8017db <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b18:	8d 50 04             	lea    0x4(%eax),%edx
  801b1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 1d                	push   $0x1d
  801b28:	e8 ae fc ff ff       	call   8017db <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	89 01                	mov    %eax,(%ecx)
  801b3b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	c9                   	leave  
  801b42:	c2 04 00             	ret    $0x4

00801b45 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 13                	push   $0x13
  801b57:	e8 7f fc ff ff       	call   8017db <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 1e                	push   $0x1e
  801b71:	e8 65 fc ff ff       	call   8017db <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b87:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 1f                	push   $0x1f
  801b96:	e8 40 fc ff ff       	call   8017db <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9e:	90                   	nop
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <rsttst>:
void rsttst()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 21                	push   $0x21
  801bb0:	e8 26 fc ff ff       	call   8017db <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc7:	8b 55 18             	mov    0x18(%ebp),%edx
  801bca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 20                	push   $0x20
  801bdb:	e8 fb fb ff ff       	call   8017db <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <chktst>:
void chktst(uint32 n)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 e0 fb ff ff       	call   8017db <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <inctst>:

void inctst()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 23                	push   $0x23
  801c10:	e8 c6 fb ff ff       	call   8017db <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <gettst>:
uint32 gettst()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 24                	push   $0x24
  801c2a:	e8 ac fb ff ff       	call   8017db <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 25                	push   $0x25
  801c43:	e8 93 fb ff ff       	call   8017db <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
  801c4b:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c50:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 08             	pushl  0x8(%ebp)
  801c6d:	6a 26                	push   $0x26
  801c6f:	e8 67 fb ff ff       	call   8017db <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return ;
  801c77:	90                   	nop
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	53                   	push   %ebx
  801c8d:	51                   	push   %ecx
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 27                	push   $0x27
  801c92:	e8 44 fb ff ff       	call   8017db <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	52                   	push   %edx
  801caf:	50                   	push   %eax
  801cb0:	6a 28                	push   $0x28
  801cb2:	e8 24 fb ff ff       	call   8017db <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cbf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	51                   	push   %ecx
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	6a 29                	push   $0x29
  801cd2:	e8 04 fb ff ff       	call   8017db <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 10             	pushl  0x10(%ebp)
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	6a 12                	push   $0x12
  801cee:	e8 e8 fa ff ff       	call   8017db <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 2a                	push   $0x2a
  801d0c:	e8 ca fa ff ff       	call   8017db <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
	return;
  801d14:	90                   	nop
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2b                	push   $0x2b
  801d26:	e8 b0 fa ff ff       	call   8017db <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	ff 75 08             	pushl  0x8(%ebp)
  801d3f:	6a 2d                	push   $0x2d
  801d41:	e8 95 fa ff ff       	call   8017db <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 2c                	push   $0x2c
  801d5d:	e8 79 fa ff ff       	call   8017db <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	68 14 34 80 00       	push   $0x803414
  801d76:	68 25 01 00 00       	push   $0x125
  801d7b:	68 47 34 80 00       	push   $0x803447
  801d80:	e8 ec e6 ff ff       	call   800471 <_panic>

00801d85 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801d8b:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801d92:	72 09                	jb     801d9d <to_page_va+0x18>
  801d94:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801d9b:	72 14                	jb     801db1 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	68 58 34 80 00       	push   $0x803458
  801da5:	6a 15                	push   $0x15
  801da7:	68 83 34 80 00       	push   $0x803483
  801dac:	e8 c0 e6 ff ff       	call   800471 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	ba 60 40 80 00       	mov    $0x804060,%edx
  801db9:	29 d0                	sub    %edx,%eax
  801dbb:	c1 f8 02             	sar    $0x2,%eax
  801dbe:	89 c2                	mov    %eax,%edx
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	c1 e0 02             	shl    $0x2,%eax
  801dc5:	01 d0                	add    %edx,%eax
  801dc7:	c1 e0 02             	shl    $0x2,%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	c1 e0 02             	shl    $0x2,%eax
  801dcf:	01 d0                	add    %edx,%eax
  801dd1:	89 c1                	mov    %eax,%ecx
  801dd3:	c1 e1 08             	shl    $0x8,%ecx
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	89 c1                	mov    %eax,%ecx
  801dda:	c1 e1 10             	shl    $0x10,%ecx
  801ddd:	01 c8                	add    %ecx,%eax
  801ddf:	01 c0                	add    %eax,%eax
  801de1:	01 d0                	add    %edx,%eax
  801de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	c1 e0 0c             	shl    $0xc,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801df3:	01 d0                	add    %edx,%eax
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801dfd:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e02:	8b 55 08             	mov    0x8(%ebp),%edx
  801e05:	29 c2                	sub    %eax,%edx
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	c1 e8 0c             	shr    $0xc,%eax
  801e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e13:	78 09                	js     801e1e <to_page_info+0x27>
  801e15:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e1c:	7e 14                	jle    801e32 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 9c 34 80 00       	push   $0x80349c
  801e26:	6a 22                	push   $0x22
  801e28:	68 83 34 80 00       	push   $0x803483
  801e2d:	e8 3f e6 ff ff       	call   800471 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e35:	89 d0                	mov    %edx,%eax
  801e37:	01 c0                	add    %eax,%eax
  801e39:	01 d0                	add    %edx,%eax
  801e3b:	c1 e0 02             	shl    $0x2,%eax
  801e3e:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	05 00 00 00 02       	add    $0x2000000,%eax
  801e53:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e56:	73 16                	jae    801e6e <initialize_dynamic_allocator+0x29>
  801e58:	68 c0 34 80 00       	push   $0x8034c0
  801e5d:	68 e6 34 80 00       	push   $0x8034e6
  801e62:	6a 34                	push   $0x34
  801e64:	68 83 34 80 00       	push   $0x803483
  801e69:	e8 03 e6 ff ff       	call   800471 <_panic>
		is_initialized = 1;
  801e6e:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e75:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e88:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801e8f:	00 00 00 
  801e92:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801e99:	00 00 00 
  801e9c:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ea3:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	2b 45 08             	sub    0x8(%ebp),%eax
  801eac:	c1 e8 0c             	shr    $0xc,%eax
  801eaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eb9:	e9 c8 00 00 00       	jmp    801f86 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	01 c0                	add    %eax,%eax
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	c1 e0 02             	shl    $0x2,%eax
  801eca:	05 68 40 80 00       	add    $0x804068,%eax
  801ecf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed7:	89 d0                	mov    %edx,%eax
  801ed9:	01 c0                	add    %eax,%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	c1 e0 02             	shl    $0x2,%eax
  801ee0:	05 6a 40 80 00       	add    $0x80406a,%eax
  801ee5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801eea:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ef0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ef3:	89 c8                	mov    %ecx,%eax
  801ef5:	01 c0                	add    %eax,%eax
  801ef7:	01 c8                	add    %ecx,%eax
  801ef9:	c1 e0 02             	shl    $0x2,%eax
  801efc:	05 64 40 80 00       	add    $0x804064,%eax
  801f01:	89 10                	mov    %edx,(%eax)
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	01 c0                	add    %eax,%eax
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	c1 e0 02             	shl    $0x2,%eax
  801f0f:	05 64 40 80 00       	add    $0x804064,%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	74 1b                	je     801f35 <initialize_dynamic_allocator+0xf0>
  801f1a:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f20:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f23:	89 c8                	mov    %ecx,%eax
  801f25:	01 c0                	add    %eax,%eax
  801f27:	01 c8                	add    %ecx,%eax
  801f29:	c1 e0 02             	shl    $0x2,%eax
  801f2c:	05 60 40 80 00       	add    $0x804060,%eax
  801f31:	89 02                	mov    %eax,(%edx)
  801f33:	eb 16                	jmp    801f4b <initialize_dynamic_allocator+0x106>
  801f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f38:	89 d0                	mov    %edx,%eax
  801f3a:	01 c0                	add    %eax,%eax
  801f3c:	01 d0                	add    %edx,%eax
  801f3e:	c1 e0 02             	shl    $0x2,%eax
  801f41:	05 60 40 80 00       	add    $0x804060,%eax
  801f46:	a3 48 40 80 00       	mov    %eax,0x804048
  801f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4e:	89 d0                	mov    %edx,%eax
  801f50:	01 c0                	add    %eax,%eax
  801f52:	01 d0                	add    %edx,%eax
  801f54:	c1 e0 02             	shl    $0x2,%eax
  801f57:	05 60 40 80 00       	add    $0x804060,%eax
  801f5c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	01 c0                	add    %eax,%eax
  801f68:	01 d0                	add    %edx,%eax
  801f6a:	c1 e0 02             	shl    $0x2,%eax
  801f6d:	05 60 40 80 00       	add    $0x804060,%eax
  801f72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f78:	a1 54 40 80 00       	mov    0x804054,%eax
  801f7d:	40                   	inc    %eax
  801f7e:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f83:	ff 45 f4             	incl   -0xc(%ebp)
  801f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f89:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f8c:	0f 8c 2c ff ff ff    	jl     801ebe <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f99:	eb 36                	jmp    801fd1 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9e:	c1 e0 04             	shl    $0x4,%eax
  801fa1:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	c1 e0 04             	shl    $0x4,%eax
  801fb2:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc0:	c1 e0 04             	shl    $0x4,%eax
  801fc3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fce:	ff 45 f0             	incl   -0x10(%ebp)
  801fd1:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801fd5:	7e c4                	jle    801f9b <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801fd7:	90                   	nop
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	50                   	push   %eax
  801fe7:	e8 0b fe ff ff       	call   801df7 <to_page_info>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 40 08             	mov    0x8(%eax),%eax
  801ff8:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	e8 77 fd ff ff       	call   801d85 <to_page_va>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802014:	b8 00 10 00 00       	mov    $0x1000,%eax
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	f7 75 08             	divl   0x8(%ebp)
  802021:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	50                   	push   %eax
  80202b:	e8 48 f6 ff ff       	call   801678 <get_page>
  802030:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802036:	8b 55 0c             	mov    0xc(%ebp),%edx
  802039:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	8b 55 0c             	mov    0xc(%ebp),%edx
  802043:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80204e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802055:	eb 19                	jmp    802070 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	ba 01 00 00 00       	mov    $0x1,%edx
  80205f:	88 c1                	mov    %al,%cl
  802061:	d3 e2                	shl    %cl,%edx
  802063:	89 d0                	mov    %edx,%eax
  802065:	3b 45 08             	cmp    0x8(%ebp),%eax
  802068:	74 0e                	je     802078 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80206a:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80206d:	ff 45 f0             	incl   -0x10(%ebp)
  802070:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802074:	7e e1                	jle    802057 <split_page_to_blocks+0x5a>
  802076:	eb 01                	jmp    802079 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802078:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802079:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802080:	e9 a7 00 00 00       	jmp    80212c <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802088:	0f af 45 08          	imul   0x8(%ebp),%eax
  80208c:	89 c2                	mov    %eax,%edx
  80208e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802091:	01 d0                	add    %edx,%eax
  802093:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802096:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80209a:	75 14                	jne    8020b0 <split_page_to_blocks+0xb3>
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	68 fc 34 80 00       	push   $0x8034fc
  8020a4:	6a 7c                	push   $0x7c
  8020a6:	68 83 34 80 00       	push   $0x803483
  8020ab:	e8 c1 e3 ff ff       	call   800471 <_panic>
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	c1 e0 04             	shl    $0x4,%eax
  8020b6:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020bb:	8b 10                	mov    (%eax),%edx
  8020bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c0:	89 50 04             	mov    %edx,0x4(%eax)
  8020c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c6:	8b 40 04             	mov    0x4(%eax),%eax
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	74 14                	je     8020e1 <split_page_to_blocks+0xe4>
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	c1 e0 04             	shl    $0x4,%eax
  8020d3:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020dd:	89 10                	mov    %edx,(%eax)
  8020df:	eb 11                	jmp    8020f2 <split_page_to_blocks+0xf5>
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	c1 e0 04             	shl    $0x4,%eax
  8020e7:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8020ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f0:	89 02                	mov    %eax,(%edx)
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	c1 e0 04             	shl    $0x4,%eax
  8020f8:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8020fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802101:	89 02                	mov    %eax,(%edx)
  802103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	c1 e0 04             	shl    $0x4,%eax
  802112:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	8d 50 01             	lea    0x1(%eax),%edx
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	c1 e0 04             	shl    $0x4,%eax
  802122:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802127:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802129:	ff 45 ec             	incl   -0x14(%ebp)
  80212c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802132:	0f 82 4d ff ff ff    	jb     802085 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802138:	90                   	nop
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802141:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802148:	76 19                	jbe    802163 <alloc_block+0x28>
  80214a:	68 20 35 80 00       	push   $0x803520
  80214f:	68 e6 34 80 00       	push   $0x8034e6
  802154:	68 8a 00 00 00       	push   $0x8a
  802159:	68 83 34 80 00       	push   $0x803483
  80215e:	e8 0e e3 ff ff       	call   800471 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802163:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80216a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802171:	eb 19                	jmp    80218c <alloc_block+0x51>
		if((1 << i) >= size) break;
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	ba 01 00 00 00       	mov    $0x1,%edx
  80217b:	88 c1                	mov    %al,%cl
  80217d:	d3 e2                	shl    %cl,%edx
  80217f:	89 d0                	mov    %edx,%eax
  802181:	3b 45 08             	cmp    0x8(%ebp),%eax
  802184:	73 0e                	jae    802194 <alloc_block+0x59>
		idx++;
  802186:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802189:	ff 45 f0             	incl   -0x10(%ebp)
  80218c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802190:	7e e1                	jle    802173 <alloc_block+0x38>
  802192:	eb 01                	jmp    802195 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802194:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	c1 e0 04             	shl    $0x4,%eax
  80219b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021a0:	8b 00                	mov    (%eax),%eax
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 84 df 00 00 00    	je     802289 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	c1 e0 04             	shl    $0x4,%eax
  8021b0:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021be:	75 17                	jne    8021d7 <alloc_block+0x9c>
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 41 35 80 00       	push   $0x803541
  8021c8:	68 9e 00 00 00       	push   $0x9e
  8021cd:	68 83 34 80 00       	push   $0x803483
  8021d2:	e8 9a e2 ff ff       	call   800471 <_panic>
  8021d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	74 10                	je     8021f0 <alloc_block+0xb5>
  8021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021e8:	8b 52 04             	mov    0x4(%edx),%edx
  8021eb:	89 50 04             	mov    %edx,0x4(%eax)
  8021ee:	eb 14                	jmp    802204 <alloc_block+0xc9>
  8021f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f3:	8b 40 04             	mov    0x4(%eax),%eax
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	c1 e2 04             	shl    $0x4,%edx
  8021fc:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802202:	89 02                	mov    %eax,(%edx)
  802204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802207:	8b 40 04             	mov    0x4(%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 0f                	je     80221d <alloc_block+0xe2>
  80220e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802211:	8b 40 04             	mov    0x4(%eax),%eax
  802214:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802217:	8b 12                	mov    (%edx),%edx
  802219:	89 10                	mov    %edx,(%eax)
  80221b:	eb 13                	jmp    802230 <alloc_block+0xf5>
  80221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802225:	c1 e2 04             	shl    $0x4,%edx
  802228:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80222e:	89 02                	mov    %eax,(%edx)
  802230:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	c1 e0 04             	shl    $0x4,%eax
  802249:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	8d 50 ff             	lea    -0x1(%eax),%edx
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c1 e0 04             	shl    $0x4,%eax
  802259:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80225e:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802263:	83 ec 0c             	sub    $0xc,%esp
  802266:	50                   	push   %eax
  802267:	e8 8b fb ff ff       	call   801df7 <to_page_info>
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802275:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802279:	48                   	dec    %eax
  80227a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80227d:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802281:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802284:	e9 bc 02 00 00       	jmp    802545 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802289:	a1 54 40 80 00       	mov    0x804054,%eax
  80228e:	85 c0                	test   %eax,%eax
  802290:	0f 84 7d 02 00 00    	je     802513 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802296:	a1 48 40 80 00       	mov    0x804048,%eax
  80229b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80229e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022a2:	75 17                	jne    8022bb <alloc_block+0x180>
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	68 41 35 80 00       	push   $0x803541
  8022ac:	68 a9 00 00 00       	push   $0xa9
  8022b1:	68 83 34 80 00       	push   $0x803483
  8022b6:	e8 b6 e1 ff ff       	call   800471 <_panic>
  8022bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 10                	je     8022d4 <alloc_block+0x199>
  8022c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022cc:	8b 52 04             	mov    0x4(%edx),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	eb 0b                	jmp    8022df <alloc_block+0x1a4>
  8022d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d7:	8b 40 04             	mov    0x4(%eax),%eax
  8022da:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 0f                	je     8022f8 <alloc_block+0x1bd>
  8022e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f2:	8b 12                	mov    (%edx),%edx
  8022f4:	89 10                	mov    %edx,(%eax)
  8022f6:	eb 0a                	jmp    802302 <alloc_block+0x1c7>
  8022f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	a3 48 40 80 00       	mov    %eax,0x804048
  802302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802315:	a1 54 40 80 00       	mov    0x804054,%eax
  80231a:	48                   	dec    %eax
  80231b:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	83 c0 03             	add    $0x3,%eax
  802326:	ba 01 00 00 00       	mov    $0x1,%edx
  80232b:	88 c1                	mov    %al,%cl
  80232d:	d3 e2                	shl    %cl,%edx
  80232f:	89 d0                	mov    %edx,%eax
  802331:	83 ec 08             	sub    $0x8,%esp
  802334:	ff 75 e4             	pushl  -0x1c(%ebp)
  802337:	50                   	push   %eax
  802338:	e8 c0 fc ff ff       	call   801ffd <split_page_to_blocks>
  80233d:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	c1 e0 04             	shl    $0x4,%eax
  802346:	05 80 c0 81 00       	add    $0x81c080,%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802354:	75 17                	jne    80236d <alloc_block+0x232>
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 41 35 80 00       	push   $0x803541
  80235e:	68 b0 00 00 00       	push   $0xb0
  802363:	68 83 34 80 00       	push   $0x803483
  802368:	e8 04 e1 ff ff       	call   800471 <_panic>
  80236d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 10                	je     802386 <alloc_block+0x24b>
  802376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237e:	8b 52 04             	mov    0x4(%edx),%edx
  802381:	89 50 04             	mov    %edx,0x4(%eax)
  802384:	eb 14                	jmp    80239a <alloc_block+0x25f>
  802386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238f:	c1 e2 04             	shl    $0x4,%edx
  802392:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802398:	89 02                	mov    %eax,(%edx)
  80239a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239d:	8b 40 04             	mov    0x4(%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 0f                	je     8023b3 <alloc_block+0x278>
  8023a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a7:	8b 40 04             	mov    0x4(%eax),%eax
  8023aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023ad:	8b 12                	mov    (%edx),%edx
  8023af:	89 10                	mov    %edx,(%eax)
  8023b1:	eb 13                	jmp    8023c6 <alloc_block+0x28b>
  8023b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bb:	c1 e2 04             	shl    $0x4,%edx
  8023be:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023c4:	89 02                	mov    %eax,(%edx)
  8023c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	c1 e0 04             	shl    $0x4,%eax
  8023df:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	c1 e0 04             	shl    $0x4,%eax
  8023ef:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f4:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	50                   	push   %eax
  8023fd:	e8 f5 f9 ff ff       	call   801df7 <to_page_info>
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802408:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80240b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80240f:	48                   	dec    %eax
  802410:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802413:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241a:	e9 26 01 00 00       	jmp    802545 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80241f:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	c1 e0 04             	shl    $0x4,%eax
  802428:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	0f 84 dc 00 00 00    	je     802513 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	c1 e0 04             	shl    $0x4,%eax
  80243d:	05 80 c0 81 00       	add    $0x81c080,%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802447:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80244b:	75 17                	jne    802464 <alloc_block+0x329>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 41 35 80 00       	push   $0x803541
  802455:	68 be 00 00 00       	push   $0xbe
  80245a:	68 83 34 80 00       	push   $0x803483
  80245f:	e8 0d e0 ff ff       	call   800471 <_panic>
  802464:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	74 10                	je     80247d <alloc_block+0x342>
  80246d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802475:	8b 52 04             	mov    0x4(%edx),%edx
  802478:	89 50 04             	mov    %edx,0x4(%eax)
  80247b:	eb 14                	jmp    802491 <alloc_block+0x356>
  80247d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	c1 e2 04             	shl    $0x4,%edx
  802489:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80248f:	89 02                	mov    %eax,(%edx)
  802491:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802494:	8b 40 04             	mov    0x4(%eax),%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	74 0f                	je     8024aa <alloc_block+0x36f>
  80249b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249e:	8b 40 04             	mov    0x4(%eax),%eax
  8024a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024a4:	8b 12                	mov    (%edx),%edx
  8024a6:	89 10                	mov    %edx,(%eax)
  8024a8:	eb 13                	jmp    8024bd <alloc_block+0x382>
  8024aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b2:	c1 e2 04             	shl    $0x4,%edx
  8024b5:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024bb:	89 02                	mov    %eax,(%edx)
  8024bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	c1 e0 04             	shl    $0x4,%eax
  8024d6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c1 e0 04             	shl    $0x4,%eax
  8024e6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024eb:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8024ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	50                   	push   %eax
  8024f4:	e8 fe f8 ff ff       	call   801df7 <to_page_info>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8024ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802502:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802506:	48                   	dec    %eax
  802507:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80250a:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80250e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802511:	eb 32                	jmp    802545 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802513:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802517:	77 15                	ja     80252e <alloc_block+0x3f3>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	c1 e0 04             	shl    $0x4,%eax
  80251f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	0f 84 f1 fe ff ff    	je     80241f <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 5f 35 80 00       	push   $0x80355f
  802536:	68 c8 00 00 00       	push   $0xc8
  80253b:	68 83 34 80 00       	push   $0x803483
  802540:	e8 2c df ff ff       	call   800471 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80254d:	8b 55 08             	mov    0x8(%ebp),%edx
  802550:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802555:	39 c2                	cmp    %eax,%edx
  802557:	72 0c                	jb     802565 <free_block+0x1e>
  802559:	8b 55 08             	mov    0x8(%ebp),%edx
  80255c:	a1 40 40 80 00       	mov    0x804040,%eax
  802561:	39 c2                	cmp    %eax,%edx
  802563:	72 19                	jb     80257e <free_block+0x37>
  802565:	68 70 35 80 00       	push   $0x803570
  80256a:	68 e6 34 80 00       	push   $0x8034e6
  80256f:	68 d7 00 00 00       	push   $0xd7
  802574:	68 83 34 80 00       	push   $0x803483
  802579:	e8 f3 de ff ff       	call   800471 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	83 ec 0c             	sub    $0xc,%esp
  80258a:	50                   	push   %eax
  80258b:	e8 67 f8 ff ff       	call   801df7 <to_page_info>
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802599:	8b 40 08             	mov    0x8(%eax),%eax
  80259c:	0f b7 c0             	movzwl %ax,%eax
  80259f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025a9:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025b0:	eb 19                	jmp    8025cb <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	ba 01 00 00 00       	mov    $0x1,%edx
  8025ba:	88 c1                	mov    %al,%cl
  8025bc:	d3 e2                	shl    %cl,%edx
  8025be:	89 d0                	mov    %edx,%eax
  8025c0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025c3:	74 0e                	je     8025d3 <free_block+0x8c>
	        break;
	    idx++;
  8025c5:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025c8:	ff 45 f0             	incl   -0x10(%ebp)
  8025cb:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025cf:	7e e1                	jle    8025b2 <free_block+0x6b>
  8025d1:	eb 01                	jmp    8025d4 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025d3:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025db:	40                   	inc    %eax
  8025dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025df:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8025e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e7:	75 17                	jne    802600 <free_block+0xb9>
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	68 fc 34 80 00       	push   $0x8034fc
  8025f1:	68 ee 00 00 00       	push   $0xee
  8025f6:	68 83 34 80 00       	push   $0x803483
  8025fb:	e8 71 de ff ff       	call   800471 <_panic>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	c1 e0 04             	shl    $0x4,%eax
  802606:	05 84 c0 81 00       	add    $0x81c084,%eax
  80260b:	8b 10                	mov    (%eax),%edx
  80260d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 14                	je     802631 <free_block+0xea>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	c1 e0 04             	shl    $0x4,%eax
  802623:	05 84 c0 81 00       	add    $0x81c084,%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80262d:	89 10                	mov    %edx,(%eax)
  80262f:	eb 11                	jmp    802642 <free_block+0xfb>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	c1 e0 04             	shl    $0x4,%eax
  802637:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80263d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802640:	89 02                	mov    %eax,(%edx)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	c1 e0 04             	shl    $0x4,%eax
  802648:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80264e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802651:	89 02                	mov    %eax,(%edx)
  802653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	c1 e0 04             	shl    $0x4,%eax
  802662:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	8d 50 01             	lea    0x1(%eax),%edx
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c1 e0 04             	shl    $0x4,%eax
  802672:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802677:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802679:	b8 00 10 00 00       	mov    $0x1000,%eax
  80267e:	ba 00 00 00 00       	mov    $0x0,%edx
  802683:	f7 75 e0             	divl   -0x20(%ebp)
  802686:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802690:	0f b7 c0             	movzwl %ax,%eax
  802693:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802696:	0f 85 70 01 00 00    	jne    80280c <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80269c:	83 ec 0c             	sub    $0xc,%esp
  80269f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026a2:	e8 de f6 ff ff       	call   801d85 <to_page_va>
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026b4:	e9 b7 00 00 00       	jmp    802770 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026c8:	75 17                	jne    8026e1 <free_block+0x19a>
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	68 41 35 80 00       	push   $0x803541
  8026d2:	68 f8 00 00 00       	push   $0xf8
  8026d7:	68 83 34 80 00       	push   $0x803483
  8026dc:	e8 90 dd ff ff       	call   800471 <_panic>
  8026e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e4:	8b 00                	mov    (%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 10                	je     8026fa <free_block+0x1b3>
  8026ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f2:	8b 52 04             	mov    0x4(%edx),%edx
  8026f5:	89 50 04             	mov    %edx,0x4(%eax)
  8026f8:	eb 14                	jmp    80270e <free_block+0x1c7>
  8026fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802703:	c1 e2 04             	shl    $0x4,%edx
  802706:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80270c:	89 02                	mov    %eax,(%edx)
  80270e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 0f                	je     802727 <free_block+0x1e0>
  802718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802721:	8b 12                	mov    (%edx),%edx
  802723:	89 10                	mov    %edx,(%eax)
  802725:	eb 13                	jmp    80273a <free_block+0x1f3>
  802727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	c1 e2 04             	shl    $0x4,%edx
  802732:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802738:	89 02                	mov    %eax,(%edx)
  80273a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802743:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	c1 e0 04             	shl    $0x4,%eax
  802753:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	c1 e0 04             	shl    $0x4,%eax
  802763:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802768:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80276a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276d:	01 45 ec             	add    %eax,-0x14(%ebp)
  802770:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802777:	0f 86 3c ff ff ff    	jbe    8026b9 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80278f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802793:	75 17                	jne    8027ac <free_block+0x265>
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	68 fc 34 80 00       	push   $0x8034fc
  80279d:	68 fe 00 00 00       	push   $0xfe
  8027a2:	68 83 34 80 00       	push   $0x803483
  8027a7:	e8 c5 dc ff ff       	call   800471 <_panic>
  8027ac:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b5:	89 50 04             	mov    %edx,0x4(%eax)
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	74 0c                	je     8027ce <free_block+0x287>
  8027c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ca:	89 10                	mov    %edx,(%eax)
  8027cc:	eb 08                	jmp    8027d6 <free_block+0x28f>
  8027ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d1:	a3 48 40 80 00       	mov    %eax,0x804048
  8027d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	a1 54 40 80 00       	mov    0x804054,%eax
  8027ec:	40                   	inc    %eax
  8027ed:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8027f2:	83 ec 0c             	sub    $0xc,%esp
  8027f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027f8:	e8 88 f5 ff ff       	call   801d85 <to_page_va>
  8027fd:	83 c4 10             	add    $0x10,%esp
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	50                   	push   %eax
  802804:	e8 b8 ee ff ff       	call   8016c1 <return_page>
  802809:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80280c:	90                   	nop
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 a8 35 80 00       	push   $0x8035a8
  80281d:	68 11 01 00 00       	push   $0x111
  802822:	68 83 34 80 00       	push   $0x803483
  802827:	e8 45 dc ff ff       	call   800471 <_panic>

0080282c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	68 cc 35 80 00       	push   $0x8035cc
  80283a:	6a 07                	push   $0x7
  80283c:	68 fb 35 80 00       	push   $0x8035fb
  802841:	e8 2b dc ff ff       	call   800471 <_panic>

00802846 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	68 0c 36 80 00       	push   $0x80360c
  802854:	6a 0b                	push   $0xb
  802856:	68 fb 35 80 00       	push   $0x8035fb
  80285b:	e8 11 dc ff ff       	call   800471 <_panic>

00802860 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 38 36 80 00       	push   $0x803638
  80286e:	6a 10                	push   $0x10
  802870:	68 fb 35 80 00       	push   $0x8035fb
  802875:	e8 f7 db ff ff       	call   800471 <_panic>

0080287a <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 68 36 80 00       	push   $0x803668
  802888:	6a 15                	push   $0x15
  80288a:	68 fb 35 80 00       	push   $0x8035fb
  80288f:	e8 dd db ff ff       	call   800471 <_panic>

00802894 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    
  80289f:	90                   	nop

008028a0 <__udivdi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 1c             	sub    $0x1c,%esp
  8028a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028b7:	89 ca                	mov    %ecx,%edx
  8028b9:	89 f8                	mov    %edi,%eax
  8028bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8028bf:	85 f6                	test   %esi,%esi
  8028c1:	75 2d                	jne    8028f0 <__udivdi3+0x50>
  8028c3:	39 cf                	cmp    %ecx,%edi
  8028c5:	77 65                	ja     80292c <__udivdi3+0x8c>
  8028c7:	89 fd                	mov    %edi,%ebp
  8028c9:	85 ff                	test   %edi,%edi
  8028cb:	75 0b                	jne    8028d8 <__udivdi3+0x38>
  8028cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d2:	31 d2                	xor    %edx,%edx
  8028d4:	f7 f7                	div    %edi
  8028d6:	89 c5                	mov    %eax,%ebp
  8028d8:	31 d2                	xor    %edx,%edx
  8028da:	89 c8                	mov    %ecx,%eax
  8028dc:	f7 f5                	div    %ebp
  8028de:	89 c1                	mov    %eax,%ecx
  8028e0:	89 d8                	mov    %ebx,%eax
  8028e2:	f7 f5                	div    %ebp
  8028e4:	89 cf                	mov    %ecx,%edi
  8028e6:	89 fa                	mov    %edi,%edx
  8028e8:	83 c4 1c             	add    $0x1c,%esp
  8028eb:	5b                   	pop    %ebx
  8028ec:	5e                   	pop    %esi
  8028ed:	5f                   	pop    %edi
  8028ee:	5d                   	pop    %ebp
  8028ef:	c3                   	ret    
  8028f0:	39 ce                	cmp    %ecx,%esi
  8028f2:	77 28                	ja     80291c <__udivdi3+0x7c>
  8028f4:	0f bd fe             	bsr    %esi,%edi
  8028f7:	83 f7 1f             	xor    $0x1f,%edi
  8028fa:	75 40                	jne    80293c <__udivdi3+0x9c>
  8028fc:	39 ce                	cmp    %ecx,%esi
  8028fe:	72 0a                	jb     80290a <__udivdi3+0x6a>
  802900:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802904:	0f 87 9e 00 00 00    	ja     8029a8 <__udivdi3+0x108>
  80290a:	b8 01 00 00 00       	mov    $0x1,%eax
  80290f:	89 fa                	mov    %edi,%edx
  802911:	83 c4 1c             	add    $0x1c,%esp
  802914:	5b                   	pop    %ebx
  802915:	5e                   	pop    %esi
  802916:	5f                   	pop    %edi
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    
  802919:	8d 76 00             	lea    0x0(%esi),%esi
  80291c:	31 ff                	xor    %edi,%edi
  80291e:	31 c0                	xor    %eax,%eax
  802920:	89 fa                	mov    %edi,%edx
  802922:	83 c4 1c             	add    $0x1c,%esp
  802925:	5b                   	pop    %ebx
  802926:	5e                   	pop    %esi
  802927:	5f                   	pop    %edi
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	89 d8                	mov    %ebx,%eax
  80292e:	f7 f7                	div    %edi
  802930:	31 ff                	xor    %edi,%edi
  802932:	89 fa                	mov    %edi,%edx
  802934:	83 c4 1c             	add    $0x1c,%esp
  802937:	5b                   	pop    %ebx
  802938:	5e                   	pop    %esi
  802939:	5f                   	pop    %edi
  80293a:	5d                   	pop    %ebp
  80293b:	c3                   	ret    
  80293c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802941:	89 eb                	mov    %ebp,%ebx
  802943:	29 fb                	sub    %edi,%ebx
  802945:	89 f9                	mov    %edi,%ecx
  802947:	d3 e6                	shl    %cl,%esi
  802949:	89 c5                	mov    %eax,%ebp
  80294b:	88 d9                	mov    %bl,%cl
  80294d:	d3 ed                	shr    %cl,%ebp
  80294f:	89 e9                	mov    %ebp,%ecx
  802951:	09 f1                	or     %esi,%ecx
  802953:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802957:	89 f9                	mov    %edi,%ecx
  802959:	d3 e0                	shl    %cl,%eax
  80295b:	89 c5                	mov    %eax,%ebp
  80295d:	89 d6                	mov    %edx,%esi
  80295f:	88 d9                	mov    %bl,%cl
  802961:	d3 ee                	shr    %cl,%esi
  802963:	89 f9                	mov    %edi,%ecx
  802965:	d3 e2                	shl    %cl,%edx
  802967:	8b 44 24 08          	mov    0x8(%esp),%eax
  80296b:	88 d9                	mov    %bl,%cl
  80296d:	d3 e8                	shr    %cl,%eax
  80296f:	09 c2                	or     %eax,%edx
  802971:	89 d0                	mov    %edx,%eax
  802973:	89 f2                	mov    %esi,%edx
  802975:	f7 74 24 0c          	divl   0xc(%esp)
  802979:	89 d6                	mov    %edx,%esi
  80297b:	89 c3                	mov    %eax,%ebx
  80297d:	f7 e5                	mul    %ebp
  80297f:	39 d6                	cmp    %edx,%esi
  802981:	72 19                	jb     80299c <__udivdi3+0xfc>
  802983:	74 0b                	je     802990 <__udivdi3+0xf0>
  802985:	89 d8                	mov    %ebx,%eax
  802987:	31 ff                	xor    %edi,%edi
  802989:	e9 58 ff ff ff       	jmp    8028e6 <__udivdi3+0x46>
  80298e:	66 90                	xchg   %ax,%ax
  802990:	8b 54 24 08          	mov    0x8(%esp),%edx
  802994:	89 f9                	mov    %edi,%ecx
  802996:	d3 e2                	shl    %cl,%edx
  802998:	39 c2                	cmp    %eax,%edx
  80299a:	73 e9                	jae    802985 <__udivdi3+0xe5>
  80299c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80299f:	31 ff                	xor    %edi,%edi
  8029a1:	e9 40 ff ff ff       	jmp    8028e6 <__udivdi3+0x46>
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	31 c0                	xor    %eax,%eax
  8029aa:	e9 37 ff ff ff       	jmp    8028e6 <__udivdi3+0x46>
  8029af:	90                   	nop

008029b0 <__umoddi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 1c             	sub    $0x1c,%esp
  8029b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8029bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029cf:	89 f3                	mov    %esi,%ebx
  8029d1:	89 fa                	mov    %edi,%edx
  8029d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029d7:	89 34 24             	mov    %esi,(%esp)
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	75 1a                	jne    8029f8 <__umoddi3+0x48>
  8029de:	39 f7                	cmp    %esi,%edi
  8029e0:	0f 86 a2 00 00 00    	jbe    802a88 <__umoddi3+0xd8>
  8029e6:	89 c8                	mov    %ecx,%eax
  8029e8:	89 f2                	mov    %esi,%edx
  8029ea:	f7 f7                	div    %edi
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	31 d2                	xor    %edx,%edx
  8029f0:	83 c4 1c             	add    $0x1c,%esp
  8029f3:	5b                   	pop    %ebx
  8029f4:	5e                   	pop    %esi
  8029f5:	5f                   	pop    %edi
  8029f6:	5d                   	pop    %ebp
  8029f7:	c3                   	ret    
  8029f8:	39 f0                	cmp    %esi,%eax
  8029fa:	0f 87 ac 00 00 00    	ja     802aac <__umoddi3+0xfc>
  802a00:	0f bd e8             	bsr    %eax,%ebp
  802a03:	83 f5 1f             	xor    $0x1f,%ebp
  802a06:	0f 84 ac 00 00 00    	je     802ab8 <__umoddi3+0x108>
  802a0c:	bf 20 00 00 00       	mov    $0x20,%edi
  802a11:	29 ef                	sub    %ebp,%edi
  802a13:	89 fe                	mov    %edi,%esi
  802a15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a19:	89 e9                	mov    %ebp,%ecx
  802a1b:	d3 e0                	shl    %cl,%eax
  802a1d:	89 d7                	mov    %edx,%edi
  802a1f:	89 f1                	mov    %esi,%ecx
  802a21:	d3 ef                	shr    %cl,%edi
  802a23:	09 c7                	or     %eax,%edi
  802a25:	89 e9                	mov    %ebp,%ecx
  802a27:	d3 e2                	shl    %cl,%edx
  802a29:	89 14 24             	mov    %edx,(%esp)
  802a2c:	89 d8                	mov    %ebx,%eax
  802a2e:	d3 e0                	shl    %cl,%eax
  802a30:	89 c2                	mov    %eax,%edx
  802a32:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a36:	d3 e0                	shl    %cl,%eax
  802a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a40:	89 f1                	mov    %esi,%ecx
  802a42:	d3 e8                	shr    %cl,%eax
  802a44:	09 d0                	or     %edx,%eax
  802a46:	d3 eb                	shr    %cl,%ebx
  802a48:	89 da                	mov    %ebx,%edx
  802a4a:	f7 f7                	div    %edi
  802a4c:	89 d3                	mov    %edx,%ebx
  802a4e:	f7 24 24             	mull   (%esp)
  802a51:	89 c6                	mov    %eax,%esi
  802a53:	89 d1                	mov    %edx,%ecx
  802a55:	39 d3                	cmp    %edx,%ebx
  802a57:	0f 82 87 00 00 00    	jb     802ae4 <__umoddi3+0x134>
  802a5d:	0f 84 91 00 00 00    	je     802af4 <__umoddi3+0x144>
  802a63:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a67:	29 f2                	sub    %esi,%edx
  802a69:	19 cb                	sbb    %ecx,%ebx
  802a6b:	89 d8                	mov    %ebx,%eax
  802a6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a71:	d3 e0                	shl    %cl,%eax
  802a73:	89 e9                	mov    %ebp,%ecx
  802a75:	d3 ea                	shr    %cl,%edx
  802a77:	09 d0                	or     %edx,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	d3 eb                	shr    %cl,%ebx
  802a7d:	89 da                	mov    %ebx,%edx
  802a7f:	83 c4 1c             	add    $0x1c,%esp
  802a82:	5b                   	pop    %ebx
  802a83:	5e                   	pop    %esi
  802a84:	5f                   	pop    %edi
  802a85:	5d                   	pop    %ebp
  802a86:	c3                   	ret    
  802a87:	90                   	nop
  802a88:	89 fd                	mov    %edi,%ebp
  802a8a:	85 ff                	test   %edi,%edi
  802a8c:	75 0b                	jne    802a99 <__umoddi3+0xe9>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f7                	div    %edi
  802a97:	89 c5                	mov    %eax,%ebp
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f5                	div    %ebp
  802a9f:	89 c8                	mov    %ecx,%eax
  802aa1:	f7 f5                	div    %ebp
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	e9 44 ff ff ff       	jmp    8029ee <__umoddi3+0x3e>
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	89 c8                	mov    %ecx,%eax
  802aae:	89 f2                	mov    %esi,%edx
  802ab0:	83 c4 1c             	add    $0x1c,%esp
  802ab3:	5b                   	pop    %ebx
  802ab4:	5e                   	pop    %esi
  802ab5:	5f                   	pop    %edi
  802ab6:	5d                   	pop    %ebp
  802ab7:	c3                   	ret    
  802ab8:	3b 04 24             	cmp    (%esp),%eax
  802abb:	72 06                	jb     802ac3 <__umoddi3+0x113>
  802abd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802ac1:	77 0f                	ja     802ad2 <__umoddi3+0x122>
  802ac3:	89 f2                	mov    %esi,%edx
  802ac5:	29 f9                	sub    %edi,%ecx
  802ac7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802acb:	89 14 24             	mov    %edx,(%esp)
  802ace:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ad2:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ad6:	8b 14 24             	mov    (%esp),%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d 76 00             	lea    0x0(%esi),%esi
  802ae4:	2b 04 24             	sub    (%esp),%eax
  802ae7:	19 fa                	sbb    %edi,%edx
  802ae9:	89 d1                	mov    %edx,%ecx
  802aeb:	89 c6                	mov    %eax,%esi
  802aed:	e9 71 ff ff ff       	jmp    802a63 <__umoddi3+0xb3>
  802af2:	66 90                	xchg   %ax,%ax
  802af4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802af8:	72 ea                	jb     802ae4 <__umoddi3+0x134>
  802afa:	89 d9                	mov    %ebx,%ecx
  802afc:	e9 62 ff ff ff       	jmp    802a63 <__umoddi3+0xb3>
