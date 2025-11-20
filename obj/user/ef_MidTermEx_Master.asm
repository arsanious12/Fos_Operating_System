
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
  800050:	e8 09 17 00 00       	call   80175e <smalloc>
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
  800074:	e8 e5 16 00 00       	call   80175e <smalloc>
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
  8000a9:	e8 b0 16 00 00       	call   80175e <smalloc>
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
  8000d5:	e8 67 27 00 00       	call   802841 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  8000dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 00                	push   $0x0
  8000e5:	68 39 2b 80 00       	push   $0x802b39
  8000ea:	50                   	push   %eax
  8000eb:	e8 51 27 00 00       	call   802841 <create_semaphore>
  8000f0:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  8000f3:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 42 2b 80 00       	push   $0x802b42
  800100:	50                   	push   %eax
  800101:	e8 3b 27 00 00       	call   802841 <create_semaphore>
  800106:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 40 80 00       	mov    0x804020,%eax
  80011b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800121:	6a 32                	push   $0x32
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	68 55 2b 80 00       	push   $0x802b55
  80012a:	e8 3b 19 00 00       	call   801a6a <sys_create_env>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800135:	a1 20 40 80 00       	mov    0x804020,%eax
  80013a:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800140:	89 c2                	mov    %eax,%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80014d:	6a 32                	push   $0x32
  80014f:	52                   	push   %edx
  800150:	50                   	push   %eax
  800151:	68 5f 2b 80 00       	push   $0x802b5f
  800156:	e8 0f 19 00 00       	call   801a6a <sys_create_env>
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
  80017c:	e8 05 03 00 00       	call   800486 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 fc 18 00 00       	call   801a88 <sys_run_env>
  80018c:	83 c4 10             	add    $0x10,%esp
	//env_sleep(10000);
	sys_run_env(envIdProcessB);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 d0             	pushl  -0x30(%ebp)
  800195:	e8 ee 18 00 00       	call   801a88 <sys_run_env>
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
  8001ad:	e8 c3 26 00 00       	call   802875 <wait_semaphore>
  8001b2:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8001bb:	e8 b5 26 00 00       	call   802875 <wait_semaphore>
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
  8001de:	e8 e3 05 00 00       	call   8007c6 <atomic_cprintf>
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
  8001ff:	e8 82 02 00 00       	call   800486 <_panic>

	int32 parentenvID = sys_getparentenvid();
  800204:	e8 e8 18 00 00       	call   801af1 <sys_getparentenvid>
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
  800228:	e8 65 15 00 00       	call   801792 <sget>
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
  800268:	e8 a1 1a 00 00       	call   801d0e <sys_utilities>
  80026d:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(envIdProcessA);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	ff 75 d4             	pushl  -0x2c(%ebp)
  800276:	e8 29 18 00 00       	call   801aa4 <sys_destroy_env>
  80027b:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdProcessB);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 d0             	pushl  -0x30(%ebp)
  800284:	e8 1b 18 00 00       	call   801aa4 <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	6a 01                	push   $0x1
  800291:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 71 1a 00 00       	call   801d0e <sys_utilities>
  80029d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002a0:	e8 ba 15 00 00       	call   80185f <sys_lock_cons>
		{
			(*AllFinish)++ ;
  8002a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	8d 50 01             	lea    0x1(%eax),%edx
  8002ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002b0:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8002b2:	e8 c2 15 00 00       	call   801879 <sys_unlock_cons>
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
  8002ca:	e8 09 18 00 00       	call   801ad8 <sys_getenvindex>
  8002cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	c1 e0 06             	shl    $0x6,%eax
  8002da:	29 d0                	sub    %edx,%eax
  8002dc:	c1 e0 02             	shl    $0x2,%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e8:	01 c8                	add    %ecx,%eax
  8002ea:	c1 e0 03             	shl    $0x3,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f6:	29 c2                	sub    %eax,%edx
  8002f8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002ff:	89 c2                	mov    %eax,%edx
  800301:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800307:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030c:	a1 20 40 80 00       	mov    0x804020,%eax
  800311:	8a 40 20             	mov    0x20(%eax),%al
  800314:	84 c0                	test   %al,%al
  800316:	74 0d                	je     800325 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	83 c0 20             	add    $0x20,%eax
  800320:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800329:	7e 0a                	jle    800335 <libmain+0x74>
		binaryname = argv[0];
  80032b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	e8 f5 fc ff ff       	call   800038 <_main>
  800343:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800346:	a1 00 40 80 00       	mov    0x804000,%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	0f 84 01 01 00 00    	je     800454 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800353:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800359:	bb 6c 2d 80 00       	mov    $0x802d6c,%ebx
  80035e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800363:	89 c7                	mov    %eax,%edi
  800365:	89 de                	mov    %ebx,%esi
  800367:	89 d1                	mov    %edx,%ecx
  800369:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80036b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800373:	b0 00                	mov    $0x0,%al
  800375:	89 d7                	mov    %edx,%edi
  800377:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800379:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800380:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	50                   	push   %eax
  800387:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	e8 7b 19 00 00       	call   801d0e <sys_utilities>
  800393:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800396:	e8 c4 14 00 00       	call   80185f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	68 8c 2c 80 00       	push   $0x802c8c
  8003a3:	e8 ac 03 00 00       	call   800754 <cprintf>
  8003a8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ae:	85 c0                	test   %eax,%eax
  8003b0:	74 18                	je     8003ca <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b2:	e8 75 19 00 00       	call   801d2c <sys_get_optimal_num_faults>
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	50                   	push   %eax
  8003bb:	68 b4 2c 80 00       	push   $0x802cb4
  8003c0:	e8 8f 03 00 00       	call   800754 <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
  8003c8:	eb 59                	jmp    800423 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cf:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003da:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	68 d8 2c 80 00       	push   $0x802cd8
  8003ea:	e8 65 03 00 00       	call   800754 <cprintf>
  8003ef:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800413:	51                   	push   %ecx
  800414:	52                   	push   %edx
  800415:	50                   	push   %eax
  800416:	68 00 2d 80 00       	push   $0x802d00
  80041b:	e8 34 03 00 00       	call   800754 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	50                   	push   %eax
  800432:	68 58 2d 80 00       	push   $0x802d58
  800437:	e8 18 03 00 00       	call   800754 <cprintf>
  80043c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	68 8c 2c 80 00       	push   $0x802c8c
  800447:	e8 08 03 00 00       	call   800754 <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80044f:	e8 25 14 00 00       	call   801879 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800454:	e8 1f 00 00 00       	call   800478 <exit>
}
  800459:	90                   	nop
  80045a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045d:	5b                   	pop    %ebx
  80045e:	5e                   	pop    %esi
  80045f:	5f                   	pop    %edi
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	6a 00                	push   $0x0
  80046d:	e8 32 16 00 00       	call   801aa4 <sys_destroy_env>
  800472:	83 c4 10             	add    $0x10,%esp
}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <exit>:

void
exit(void)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047e:	e8 87 16 00 00       	call   801b0a <sys_exit_env>
}
  800483:	90                   	nop
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048c:	8d 45 10             	lea    0x10(%ebp),%eax
  80048f:	83 c0 04             	add    $0x4,%eax
  800492:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800495:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80049a:	85 c0                	test   %eax,%eax
  80049c:	74 16                	je     8004b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049e:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	50                   	push   %eax
  8004a7:	68 d0 2d 80 00       	push   $0x802dd0
  8004ac:	e8 a3 02 00 00       	call   800754 <cprintf>
  8004b1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8004b9:	83 ec 0c             	sub    $0xc,%esp
  8004bc:	ff 75 0c             	pushl  0xc(%ebp)
  8004bf:	ff 75 08             	pushl  0x8(%ebp)
  8004c2:	50                   	push   %eax
  8004c3:	68 d8 2d 80 00       	push   $0x802dd8
  8004c8:	6a 74                	push   $0x74
  8004ca:	e8 b2 02 00 00       	call   800781 <cprintf_colored>
  8004cf:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004db:	50                   	push   %eax
  8004dc:	e8 04 02 00 00       	call   8006e5 <vcprintf>
  8004e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	6a 00                	push   $0x0
  8004e9:	68 00 2e 80 00       	push   $0x802e00
  8004ee:	e8 f2 01 00 00       	call   8006e5 <vcprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f6:	e8 7d ff ff ff       	call   800478 <exit>

	// should not return here
	while (1) ;
  8004fb:	eb fe                	jmp    8004fb <_panic+0x75>

008004fd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800503:	a1 20 40 80 00       	mov    0x804020,%eax
  800508:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	39 c2                	cmp    %eax,%edx
  800513:	74 14                	je     800529 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	68 04 2e 80 00       	push   $0x802e04
  80051d:	6a 26                	push   $0x26
  80051f:	68 50 2e 80 00       	push   $0x802e50
  800524:	e8 5d ff ff ff       	call   800486 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800530:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800537:	e9 c5 00 00 00       	jmp    800601 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80053c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	01 d0                	add    %edx,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	85 c0                	test   %eax,%eax
  80054f:	75 08                	jne    800559 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800551:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800554:	e9 a5 00 00 00       	jmp    8005fe <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800559:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800560:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800567:	eb 69                	jmp    8005d2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800569:	a1 20 40 80 00       	mov    0x804020,%eax
  80056e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800574:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800577:	89 d0                	mov    %edx,%eax
  800579:	01 c0                	add    %eax,%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	c1 e0 03             	shl    $0x3,%eax
  800580:	01 c8                	add    %ecx,%eax
  800582:	8a 40 04             	mov    0x4(%eax),%al
  800585:	84 c0                	test   %al,%al
  800587:	75 46                	jne    8005cf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800589:	a1 20 40 80 00       	mov    0x804020,%eax
  80058e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800594:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800597:	89 d0                	mov    %edx,%eax
  800599:	01 c0                	add    %eax,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	c1 e0 03             	shl    $0x3,%eax
  8005a0:	01 c8                	add    %ecx,%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c2:	39 c2                	cmp    %eax,%edx
  8005c4:	75 09                	jne    8005cf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005cd:	eb 15                	jmp    8005e4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cf:	ff 45 e8             	incl   -0x18(%ebp)
  8005d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	39 c2                	cmp    %eax,%edx
  8005e2:	77 85                	ja     800569 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e8:	75 14                	jne    8005fe <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	68 5c 2e 80 00       	push   $0x802e5c
  8005f2:	6a 3a                	push   $0x3a
  8005f4:	68 50 2e 80 00       	push   $0x802e50
  8005f9:	e8 88 fe ff ff       	call   800486 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005fe:	ff 45 f0             	incl   -0x10(%ebp)
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800604:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800607:	0f 8c 2f ff ff ff    	jl     80053c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800614:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061b:	eb 26                	jmp    800643 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061d:	a1 20 40 80 00       	mov    0x804020,%eax
  800622:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062b:	89 d0                	mov    %edx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	c1 e0 03             	shl    $0x3,%eax
  800634:	01 c8                	add    %ecx,%eax
  800636:	8a 40 04             	mov    0x4(%eax),%al
  800639:	3c 01                	cmp    $0x1,%al
  80063b:	75 03                	jne    800640 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80063d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800640:	ff 45 e0             	incl   -0x20(%ebp)
  800643:	a1 20 40 80 00       	mov    0x804020,%eax
  800648:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	77 c8                	ja     80061d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800658:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80065b:	74 14                	je     800671 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 b0 2e 80 00       	push   $0x802eb0
  800665:	6a 44                	push   $0x44
  800667:	68 50 2e 80 00       	push   $0x802e50
  80066c:	e8 15 fe ff ff       	call   800486 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800671:	90                   	nop
  800672:	c9                   	leave  
  800673:	c3                   	ret    

00800674 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
  800677:	53                   	push   %ebx
  800678:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	8d 48 01             	lea    0x1(%eax),%ecx
  800683:	8b 55 0c             	mov    0xc(%ebp),%edx
  800686:	89 0a                	mov    %ecx,(%edx)
  800688:	8b 55 08             	mov    0x8(%ebp),%edx
  80068b:	88 d1                	mov    %dl,%cl
  80068d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800690:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800694:	8b 45 0c             	mov    0xc(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069e:	75 30                	jne    8006d0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a0:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006a6:	a0 44 40 80 00       	mov    0x804044,%al
  8006ab:	0f b6 c0             	movzbl %al,%eax
  8006ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b1:	8b 09                	mov    (%ecx),%ecx
  8006b3:	89 cb                	mov    %ecx,%ebx
  8006b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b8:	83 c1 08             	add    $0x8,%ecx
  8006bb:	52                   	push   %edx
  8006bc:	50                   	push   %eax
  8006bd:	53                   	push   %ebx
  8006be:	51                   	push   %ecx
  8006bf:	e8 57 11 00 00       	call   80181b <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f5:	00 00 00 
	b.cnt = 0;
  8006f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ff:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070e:	50                   	push   %eax
  80070f:	68 74 06 80 00       	push   $0x800674
  800714:	e8 5a 02 00 00       	call   800973 <vprintfmt>
  800719:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071c:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800722:	a0 44 40 80 00       	mov    0x804044,%al
  800727:	0f b6 c0             	movzbl %al,%eax
  80072a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800730:	52                   	push   %edx
  800731:	50                   	push   %eax
  800732:	51                   	push   %ecx
  800733:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800739:	83 c0 08             	add    $0x8,%eax
  80073c:	50                   	push   %eax
  80073d:	e8 d9 10 00 00       	call   80181b <sys_cputs>
  800742:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800745:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80074c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800761:	8d 45 0c             	lea    0xc(%ebp),%eax
  800764:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 f4             	pushl  -0xc(%ebp)
  800770:	50                   	push   %eax
  800771:	e8 6f ff ff ff       	call   8006e5 <vcprintf>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800787:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	c1 e0 08             	shl    $0x8,%eax
  800794:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800799:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079c:	83 c0 04             	add    $0x4,%eax
  80079f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	e8 34 ff ff ff       	call   8006e5 <vcprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b7:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007be:	07 00 00 

	return cnt;
  8007c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cc:	e8 8e 10 00 00       	call   80185f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e0:	50                   	push   %eax
  8007e1:	e8 ff fe ff ff       	call   8006e5 <vcprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ec:	e8 88 10 00 00       	call   801879 <sys_unlock_cons>
	return cnt;
  8007f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    

008007f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	53                   	push   %ebx
  8007fa:	83 ec 14             	sub    $0x14,%esp
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800809:	8b 45 18             	mov    0x18(%ebp),%eax
  80080c:	ba 00 00 00 00       	mov    $0x0,%edx
  800811:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800814:	77 55                	ja     80086b <printnum+0x75>
  800816:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800819:	72 05                	jb     800820 <printnum+0x2a>
  80081b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80081e:	77 4b                	ja     80086b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800820:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800823:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800826:	8b 45 18             	mov    0x18(%ebp),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	52                   	push   %edx
  80082f:	50                   	push   %eax
  800830:	ff 75 f4             	pushl  -0xc(%ebp)
  800833:	ff 75 f0             	pushl  -0x10(%ebp)
  800836:	e8 79 20 00 00       	call   8028b4 <__udivdi3>
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	83 ec 04             	sub    $0x4,%esp
  800841:	ff 75 20             	pushl  0x20(%ebp)
  800844:	53                   	push   %ebx
  800845:	ff 75 18             	pushl  0x18(%ebp)
  800848:	52                   	push   %edx
  800849:	50                   	push   %eax
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	ff 75 08             	pushl  0x8(%ebp)
  800850:	e8 a1 ff ff ff       	call   8007f6 <printnum>
  800855:	83 c4 20             	add    $0x20,%esp
  800858:	eb 1a                	jmp    800874 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 20             	pushl  0x20(%ebp)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	ff d0                	call   *%eax
  800868:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086b:	ff 4d 1c             	decl   0x1c(%ebp)
  80086e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800872:	7f e6                	jg     80085a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800874:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800877:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800882:	53                   	push   %ebx
  800883:	51                   	push   %ecx
  800884:	52                   	push   %edx
  800885:	50                   	push   %eax
  800886:	e8 39 21 00 00       	call   8029c4 <__umoddi3>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	05 14 31 80 00       	add    $0x803114,%eax
  800893:	8a 00                	mov    (%eax),%al
  800895:	0f be c0             	movsbl %al,%eax
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	50                   	push   %eax
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	ff d0                	call   *%eax
  8008a4:	83 c4 10             	add    $0x10,%esp
}
  8008a7:	90                   	nop
  8008a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b4:	7e 1c                	jle    8008d2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	8d 50 08             	lea    0x8(%eax),%edx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	89 10                	mov    %edx,(%eax)
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	83 e8 08             	sub    $0x8,%eax
  8008cb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	eb 40                	jmp    800912 <getuint+0x65>
	else if (lflag)
  8008d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d6:	74 1e                	je     8008f6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 50 04             	lea    0x4(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 10                	mov    %edx,(%eax)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	eb 1c                	jmp    800912 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	8d 50 04             	lea    0x4(%eax),%edx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	89 10                	mov    %edx,(%eax)
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	83 e8 04             	sub    $0x4,%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800917:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091b:	7e 1c                	jle    800939 <getint+0x25>
		return va_arg(*ap, long long);
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	8d 50 08             	lea    0x8(%eax),%edx
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	89 10                	mov    %edx,(%eax)
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	83 e8 08             	sub    $0x8,%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	eb 38                	jmp    800971 <getint+0x5d>
	else if (lflag)
  800939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093d:	74 1a                	je     800959 <getint+0x45>
		return va_arg(*ap, long);
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 50 04             	lea    0x4(%eax),%edx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 10                	mov    %edx,(%eax)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	83 e8 04             	sub    $0x4,%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	99                   	cltd   
  800957:	eb 18                	jmp    800971 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	8d 50 04             	lea    0x4(%eax),%edx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 10                	mov    %edx,(%eax)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	99                   	cltd   
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	56                   	push   %esi
  800977:	53                   	push   %ebx
  800978:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097b:	eb 17                	jmp    800994 <vprintfmt+0x21>
			if (ch == '\0')
  80097d:	85 db                	test   %ebx,%ebx
  80097f:	0f 84 c1 03 00 00    	je     800d46 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800994:	8b 45 10             	mov    0x10(%ebp),%eax
  800997:	8d 50 01             	lea    0x1(%eax),%edx
  80099a:	89 55 10             	mov    %edx,0x10(%ebp)
  80099d:	8a 00                	mov    (%eax),%al
  80099f:	0f b6 d8             	movzbl %al,%ebx
  8009a2:	83 fb 25             	cmp    $0x25,%ebx
  8009a5:	75 d6                	jne    80097d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ab:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ca:	8d 50 01             	lea    0x1(%eax),%edx
  8009cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d0:	8a 00                	mov    (%eax),%al
  8009d2:	0f b6 d8             	movzbl %al,%ebx
  8009d5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d8:	83 f8 5b             	cmp    $0x5b,%eax
  8009db:	0f 87 3d 03 00 00    	ja     800d1e <vprintfmt+0x3ab>
  8009e1:	8b 04 85 38 31 80 00 	mov    0x803138(,%eax,4),%eax
  8009e8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ea:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ee:	eb d7                	jmp    8009c7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f4:	eb d1                	jmp    8009c7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a00:	89 d0                	mov    %edx,%eax
  800a02:	c1 e0 02             	shl    $0x2,%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	01 c0                	add    %eax,%eax
  800a09:	01 d8                	add    %ebx,%eax
  800a0b:	83 e8 30             	sub    $0x30,%eax
  800a0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a11:	8b 45 10             	mov    0x10(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a19:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1c:	7e 3e                	jle    800a5c <vprintfmt+0xe9>
  800a1e:	83 fb 39             	cmp    $0x39,%ebx
  800a21:	7f 39                	jg     800a5c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a23:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a26:	eb d5                	jmp    8009fd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 c0 04             	add    $0x4,%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	83 e8 04             	sub    $0x4,%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3c:	eb 1f                	jmp    800a5d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	79 83                	jns    8009c7 <vprintfmt+0x54>
				width = 0;
  800a44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4b:	e9 77 ff ff ff       	jmp    8009c7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a50:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a57:	e9 6b ff ff ff       	jmp    8009c7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a61:	0f 89 60 ff ff ff    	jns    8009c7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a74:	e9 4e ff ff ff       	jmp    8009c7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a79:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7c:	e9 46 ff ff ff       	jmp    8009c7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 c0 04             	add    $0x4,%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	50                   	push   %eax
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
			break;
  800aa1:	e9 9b 02 00 00       	jmp    800d41 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 c0 04             	add    $0x4,%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 e8 04             	sub    $0x4,%eax
  800ab5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	79 02                	jns    800abd <vprintfmt+0x14a>
				err = -err;
  800abb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800abd:	83 fb 64             	cmp    $0x64,%ebx
  800ac0:	7f 0b                	jg     800acd <vprintfmt+0x15a>
  800ac2:	8b 34 9d 80 2f 80 00 	mov    0x802f80(,%ebx,4),%esi
  800ac9:	85 f6                	test   %esi,%esi
  800acb:	75 19                	jne    800ae6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800acd:	53                   	push   %ebx
  800ace:	68 25 31 80 00       	push   $0x803125
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	ff 75 08             	pushl  0x8(%ebp)
  800ad9:	e8 70 02 00 00       	call   800d4e <printfmt>
  800ade:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae1:	e9 5b 02 00 00       	jmp    800d41 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae6:	56                   	push   %esi
  800ae7:	68 2e 31 80 00       	push   $0x80312e
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 57 02 00 00       	call   800d4e <printfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
			break;
  800afa:	e9 42 02 00 00       	jmp    800d41 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 30                	mov    (%eax),%esi
  800b10:	85 f6                	test   %esi,%esi
  800b12:	75 05                	jne    800b19 <vprintfmt+0x1a6>
				p = "(null)";
  800b14:	be 31 31 80 00       	mov    $0x803131,%esi
			if (width > 0 && padc != '-')
  800b19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1d:	7e 6d                	jle    800b8c <vprintfmt+0x219>
  800b1f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b23:	74 67                	je     800b8c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	50                   	push   %eax
  800b2c:	56                   	push   %esi
  800b2d:	e8 1e 03 00 00       	call   800e50 <strnlen>
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b38:	eb 16                	jmp    800b50 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	50                   	push   %eax
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	ff d0                	call   *%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b54:	7f e4                	jg     800b3a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b56:	eb 34                	jmp    800b8c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b58:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5c:	74 1c                	je     800b7a <vprintfmt+0x207>
  800b5e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b61:	7e 05                	jle    800b68 <vprintfmt+0x1f5>
  800b63:	83 fb 7e             	cmp    $0x7e,%ebx
  800b66:	7e 12                	jle    800b7a <vprintfmt+0x207>
					putch('?', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	6a 3f                	push   $0x3f
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	eb 0f                	jmp    800b89 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	53                   	push   %ebx
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b89:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8c:	89 f0                	mov    %esi,%eax
  800b8e:	8d 70 01             	lea    0x1(%eax),%esi
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	0f be d8             	movsbl %al,%ebx
  800b96:	85 db                	test   %ebx,%ebx
  800b98:	74 24                	je     800bbe <vprintfmt+0x24b>
  800b9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9e:	78 b8                	js     800b58 <vprintfmt+0x1e5>
  800ba0:	ff 4d e0             	decl   -0x20(%ebp)
  800ba3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba7:	79 af                	jns    800b58 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba9:	eb 13                	jmp    800bbe <vprintfmt+0x24b>
				putch(' ', putdat);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	6a 20                	push   $0x20
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc2:	7f e7                	jg     800bab <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc4:	e9 78 01 00 00       	jmp    800d41 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcf:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd2:	50                   	push   %eax
  800bd3:	e8 3c fd ff ff       	call   800914 <getint>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be7:	85 d2                	test   %edx,%edx
  800be9:	79 23                	jns    800c0e <vprintfmt+0x29b>
				putch('-', putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	6a 2d                	push   $0x2d
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c01:	f7 d8                	neg    %eax
  800c03:	83 d2 00             	adc    $0x0,%edx
  800c06:	f7 da                	neg    %edx
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c15:	e9 bc 00 00 00       	jmp    800cd6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c20:	8d 45 14             	lea    0x14(%ebp),%eax
  800c23:	50                   	push   %eax
  800c24:	e8 84 fc ff ff       	call   8008ad <getuint>
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c39:	e9 98 00 00 00       	jmp    800cd6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	6a 58                	push   $0x58
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	ff d0                	call   *%eax
  800c4b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	6a 58                	push   $0x58
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 58                	push   $0x58
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			break;
  800c6e:	e9 ce 00 00 00       	jmp    800d41 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	6a 30                	push   $0x30
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff d0                	call   *%eax
  800c80:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c83:	83 ec 08             	sub    $0x8,%esp
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	6a 78                	push   $0x78
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	ff d0                	call   *%eax
  800c90:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c93:	8b 45 14             	mov    0x14(%ebp),%eax
  800c96:	83 c0 04             	add    $0x4,%eax
  800c99:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 e8 04             	sub    $0x4,%eax
  800ca2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cae:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb5:	eb 1f                	jmp    800cd6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 e8             	pushl  -0x18(%ebp)
  800cbd:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	e8 e7 fb ff ff       	call   8008ad <getuint>
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ccf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cdd:	83 ec 04             	sub    $0x4,%esp
  800ce0:	52                   	push   %edx
  800ce1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce4:	50                   	push   %eax
  800ce5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	ff 75 08             	pushl  0x8(%ebp)
  800cf1:	e8 00 fb ff ff       	call   8007f6 <printnum>
  800cf6:	83 c4 20             	add    $0x20,%esp
			break;
  800cf9:	eb 46                	jmp    800d41 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			break;
  800d0a:	eb 35                	jmp    800d41 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0c:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d13:	eb 2c                	jmp    800d41 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d15:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d1c:	eb 23                	jmp    800d41 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	6a 25                	push   $0x25
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	ff d0                	call   *%eax
  800d2b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	eb 03                	jmp    800d36 <vprintfmt+0x3c3>
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	48                   	dec    %eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	3c 25                	cmp    $0x25,%al
  800d3e:	75 f3                	jne    800d33 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d40:	90                   	nop
		}
	}
  800d41:	e9 35 fc ff ff       	jmp    80097b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d46:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d54:	8d 45 10             	lea    0x10(%ebp),%eax
  800d57:	83 c0 04             	add    $0x4,%eax
  800d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	ff 75 f4             	pushl  -0xc(%ebp)
  800d63:	50                   	push   %eax
  800d64:	ff 75 0c             	pushl  0xc(%ebp)
  800d67:	ff 75 08             	pushl  0x8(%ebp)
  800d6a:	e8 04 fc ff ff       	call   800973 <vprintfmt>
  800d6f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d72:	90                   	nop
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8b 40 08             	mov    0x8(%eax),%eax
  800d7e:	8d 50 01             	lea    0x1(%eax),%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 10                	mov    (%eax),%edx
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8b 40 04             	mov    0x4(%eax),%eax
  800d92:	39 c2                	cmp    %eax,%edx
  800d94:	73 12                	jae    800da8 <sprintputch+0x33>
		*b->buf++ = ch;
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8b 00                	mov    (%eax),%eax
  800d9b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da1:	89 0a                	mov    %ecx,(%edx)
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	88 10                	mov    %dl,(%eax)
}
  800da8:	90                   	nop
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	01 d0                	add    %edx,%eax
  800dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd0:	74 06                	je     800dd8 <vsnprintf+0x2d>
  800dd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd6:	7f 07                	jg     800ddf <vsnprintf+0x34>
		return -E_INVAL;
  800dd8:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddd:	eb 20                	jmp    800dff <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ddf:	ff 75 14             	pushl  0x14(%ebp)
  800de2:	ff 75 10             	pushl  0x10(%ebp)
  800de5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de8:	50                   	push   %eax
  800de9:	68 75 0d 80 00       	push   $0x800d75
  800dee:	e8 80 fb ff ff       	call   800973 <vprintfmt>
  800df3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e07:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0a:	83 c0 04             	add    $0x4,%eax
  800e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e10:	8b 45 10             	mov    0x10(%ebp),%eax
  800e13:	ff 75 f4             	pushl  -0xc(%ebp)
  800e16:	50                   	push   %eax
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	ff 75 08             	pushl  0x8(%ebp)
  800e1d:	e8 89 ff ff ff       	call   800dab <vsnprintf>
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3a:	eb 06                	jmp    800e42 <strlen+0x15>
		n++;
  800e3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	75 f1                	jne    800e3c <strlen+0xf>
		n++;
	return n;
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5d:	eb 09                	jmp    800e68 <strnlen+0x18>
		n++;
  800e5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e62:	ff 45 08             	incl   0x8(%ebp)
  800e65:	ff 4d 0c             	decl   0xc(%ebp)
  800e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6c:	74 09                	je     800e77 <strnlen+0x27>
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	84 c0                	test   %al,%al
  800e75:	75 e8                	jne    800e5f <strnlen+0xf>
		n++;
	return n;
  800e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e88:	90                   	nop
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8d 50 01             	lea    0x1(%eax),%edx
  800e8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9b:	8a 12                	mov    (%edx),%dl
  800e9d:	88 10                	mov    %dl,(%eax)
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	84 c0                	test   %al,%al
  800ea3:	75 e4                	jne    800e89 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebd:	eb 1f                	jmp    800ede <strncpy+0x34>
		*dst++ = *src;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecb:	8a 12                	mov    (%edx),%dl
  800ecd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	84 c0                	test   %al,%al
  800ed6:	74 03                	je     800edb <strncpy+0x31>
			src++;
  800ed8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edb:	ff 45 fc             	incl   -0x4(%ebp)
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee4:	72 d9                	jb     800ebf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 30                	je     800f2d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800efd:	eb 16                	jmp    800f15 <strlcpy+0x2a>
			*dst++ = *src++;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8d 50 01             	lea    0x1(%eax),%edx
  800f05:	89 55 08             	mov    %edx,0x8(%ebp)
  800f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f11:	8a 12                	mov    (%edx),%dl
  800f13:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f15:	ff 4d 10             	decl   0x10(%ebp)
  800f18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1c:	74 09                	je     800f27 <strlcpy+0x3c>
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	84 c0                	test   %al,%al
  800f25:	75 d8                	jne    800eff <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f33:	29 c2                	sub    %eax,%edx
  800f35:	89 d0                	mov    %edx,%eax
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3c:	eb 06                	jmp    800f44 <strcmp+0xb>
		p++, q++;
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	84 c0                	test   %al,%al
  800f4b:	74 0e                	je     800f5b <strcmp+0x22>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 10                	mov    (%eax),%dl
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	38 c2                	cmp    %al,%dl
  800f59:	74 e3                	je     800f3e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f b6 d0             	movzbl %al,%edx
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 c0             	movzbl %al,%eax
  800f6b:	29 c2                	sub    %eax,%edx
  800f6d:	89 d0                	mov    %edx,%eax
}
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f74:	eb 09                	jmp    800f7f <strncmp+0xe>
		n--, p++, q++;
  800f76:	ff 4d 10             	decl   0x10(%ebp)
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	74 17                	je     800f9c <strncmp+0x2b>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	74 0e                	je     800f9c <strncmp+0x2b>
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 da                	je     800f76 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa0:	75 07                	jne    800fa9 <strncmp+0x38>
		return 0;
  800fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa7:	eb 14                	jmp    800fbd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	0f b6 d0             	movzbl %al,%edx
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	0f b6 c0             	movzbl %al,%eax
  800fb9:	29 c2                	sub    %eax,%edx
  800fbb:	89 d0                	mov    %edx,%eax
}
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcb:	eb 12                	jmp    800fdf <strchr+0x20>
		if (*s == c)
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd5:	75 05                	jne    800fdc <strchr+0x1d>
			return (char *) s;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	eb 11                	jmp    800fed <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdc:	ff 45 08             	incl   0x8(%ebp)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	84 c0                	test   %al,%al
  800fe6:	75 e5                	jne    800fcd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 04             	sub    $0x4,%esp
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffb:	eb 0d                	jmp    80100a <strfind+0x1b>
		if (*s == c)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801005:	74 0e                	je     801015 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801007:	ff 45 08             	incl   0x8(%ebp)
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	84 c0                	test   %al,%al
  801011:	75 ea                	jne    800ffd <strfind+0xe>
  801013:	eb 01                	jmp    801016 <strfind+0x27>
		if (*s == c)
			break;
  801015:	90                   	nop
	return (char *) s;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801019:	c9                   	leave  
  80101a:	c3                   	ret    

0080101b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801027:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102b:	76 63                	jbe    801090 <memset+0x75>
		uint64 data_block = c;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	99                   	cltd   
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801034:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801041:	c1 e0 08             	shl    $0x8,%eax
  801044:	09 45 f0             	or     %eax,-0x10(%ebp)
  801047:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801050:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801054:	c1 e0 10             	shl    $0x10,%eax
  801057:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80105d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801063:	89 c2                	mov    %eax,%edx
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80106d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801070:	eb 18                	jmp    80108a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801072:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801075:	8d 41 08             	lea    0x8(%ecx),%eax
  801078:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801081:	89 01                	mov    %eax,(%ecx)
  801083:	89 51 04             	mov    %edx,0x4(%ecx)
  801086:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108e:	77 e2                	ja     801072 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801090:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801094:	74 23                	je     8010b9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109c:	eb 0e                	jmp    8010ac <memset+0x91>
			*p8++ = (uint8)c;
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	8d 50 01             	lea    0x1(%eax),%edx
  8010a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010aa:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8010af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	75 e5                	jne    80109e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d4:	76 24                	jbe    8010fa <memcpy+0x3c>
		while(n >= 8){
  8010d6:	eb 1c                	jmp    8010f4 <memcpy+0x36>
			*d64 = *s64;
  8010d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010db:	8b 50 04             	mov    0x4(%eax),%edx
  8010de:	8b 00                	mov    (%eax),%eax
  8010e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e3:	89 01                	mov    %eax,(%ecx)
  8010e5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ec:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f8:	77 de                	ja     8010d8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fe:	74 31                	je     801131 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801103:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801106:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801109:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110c:	eb 16                	jmp    801124 <memcpy+0x66>
			*d8++ = *s8++;
  80110e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801111:	8d 50 01             	lea    0x1(%eax),%edx
  801114:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801120:	8a 12                	mov    (%edx),%dl
  801122:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112a:	89 55 10             	mov    %edx,0x10(%ebp)
  80112d:	85 c0                	test   %eax,%eax
  80112f:	75 dd                	jne    80110e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114e:	73 50                	jae    8011a0 <memmove+0x6a>
  801150:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	01 d0                	add    %edx,%eax
  801158:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115b:	76 43                	jbe    8011a0 <memmove+0x6a>
		s += n;
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801169:	eb 10                	jmp    80117b <memmove+0x45>
			*--d = *--s;
  80116b:	ff 4d f8             	decl   -0x8(%ebp)
  80116e:	ff 4d fc             	decl   -0x4(%ebp)
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801174:	8a 10                	mov    (%eax),%dl
  801176:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801179:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801181:	89 55 10             	mov    %edx,0x10(%ebp)
  801184:	85 c0                	test   %eax,%eax
  801186:	75 e3                	jne    80116b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801188:	eb 23                	jmp    8011ad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801193:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801196:	8d 4a 01             	lea    0x1(%edx),%ecx
  801199:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119c:	8a 12                	mov    (%edx),%dl
  80119e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 dd                	jne    80118a <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c4:	eb 2a                	jmp    8011f0 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c9:	8a 10                	mov    (%eax),%dl
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	38 c2                	cmp    %al,%dl
  8011d2:	74 16                	je     8011ea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	0f b6 d0             	movzbl %al,%edx
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	0f b6 c0             	movzbl %al,%eax
  8011e4:	29 c2                	sub    %eax,%edx
  8011e6:	89 d0                	mov    %edx,%eax
  8011e8:	eb 18                	jmp    801202 <memcmp+0x50>
		s1++, s2++;
  8011ea:	ff 45 fc             	incl   -0x4(%ebp)
  8011ed:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 c9                	jne    8011c6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120a:	8b 55 08             	mov    0x8(%ebp),%edx
  80120d:	8b 45 10             	mov    0x10(%ebp),%eax
  801210:	01 d0                	add    %edx,%eax
  801212:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801215:	eb 15                	jmp    80122c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	0f b6 d0             	movzbl %al,%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	0f b6 c0             	movzbl %al,%eax
  801225:	39 c2                	cmp    %eax,%edx
  801227:	74 0d                	je     801236 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801229:	ff 45 08             	incl   0x8(%ebp)
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801232:	72 e3                	jb     801217 <memfind+0x13>
  801234:	eb 01                	jmp    801237 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801236:	90                   	nop
	return (void *) s;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801249:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801250:	eb 03                	jmp    801255 <strtol+0x19>
		s++;
  801252:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 20                	cmp    $0x20,%al
  80125c:	74 f4                	je     801252 <strtol+0x16>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 09                	cmp    $0x9,%al
  801265:	74 eb                	je     801252 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 2b                	cmp    $0x2b,%al
  80126e:	75 05                	jne    801275 <strtol+0x39>
		s++;
  801270:	ff 45 08             	incl   0x8(%ebp)
  801273:	eb 13                	jmp    801288 <strtol+0x4c>
	else if (*s == '-')
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 2d                	cmp    $0x2d,%al
  80127c:	75 0a                	jne    801288 <strtol+0x4c>
		s++, neg = 1;
  80127e:	ff 45 08             	incl   0x8(%ebp)
  801281:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801288:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128c:	74 06                	je     801294 <strtol+0x58>
  80128e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801292:	75 20                	jne    8012b4 <strtol+0x78>
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 30                	cmp    $0x30,%al
  80129b:	75 17                	jne    8012b4 <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	40                   	inc    %eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 78                	cmp    $0x78,%al
  8012a5:	75 0d                	jne    8012b4 <strtol+0x78>
		s += 2, base = 16;
  8012a7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b2:	eb 28                	jmp    8012dc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b8:	75 15                	jne    8012cf <strtol+0x93>
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 30                	cmp    $0x30,%al
  8012c1:	75 0c                	jne    8012cf <strtol+0x93>
		s++, base = 8;
  8012c3:	ff 45 08             	incl   0x8(%ebp)
  8012c6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012cd:	eb 0d                	jmp    8012dc <strtol+0xa0>
	else if (base == 0)
  8012cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d3:	75 07                	jne    8012dc <strtol+0xa0>
		base = 10;
  8012d5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	3c 2f                	cmp    $0x2f,%al
  8012e3:	7e 19                	jle    8012fe <strtol+0xc2>
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 39                	cmp    $0x39,%al
  8012ec:	7f 10                	jg     8012fe <strtol+0xc2>
			dig = *s - '0';
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	0f be c0             	movsbl %al,%eax
  8012f6:	83 e8 30             	sub    $0x30,%eax
  8012f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fc:	eb 42                	jmp    801340 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	3c 60                	cmp    $0x60,%al
  801305:	7e 19                	jle    801320 <strtol+0xe4>
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 7a                	cmp    $0x7a,%al
  80130e:	7f 10                	jg     801320 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	0f be c0             	movsbl %al,%eax
  801318:	83 e8 57             	sub    $0x57,%eax
  80131b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131e:	eb 20                	jmp    801340 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	3c 40                	cmp    $0x40,%al
  801327:	7e 39                	jle    801362 <strtol+0x126>
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 5a                	cmp    $0x5a,%al
  801330:	7f 30                	jg     801362 <strtol+0x126>
			dig = *s - 'A' + 10;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	0f be c0             	movsbl %al,%eax
  80133a:	83 e8 37             	sub    $0x37,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801343:	3b 45 10             	cmp    0x10(%ebp),%eax
  801346:	7d 19                	jge    801361 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801348:	ff 45 08             	incl   0x8(%ebp)
  80134b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801352:	89 c2                	mov    %eax,%edx
  801354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135c:	e9 7b ff ff ff       	jmp    8012dc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801361:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801362:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801366:	74 08                	je     801370 <strtol+0x134>
		*endptr = (char *) s;
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	8b 55 08             	mov    0x8(%ebp),%edx
  80136e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801370:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801374:	74 07                	je     80137d <strtol+0x141>
  801376:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801379:	f7 d8                	neg    %eax
  80137b:	eb 03                	jmp    801380 <strtol+0x144>
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <ltostr>:

void
ltostr(long value, char *str)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80138f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139a:	79 13                	jns    8013af <ltostr+0x2d>
	{
		neg = 1;
  80139c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b7:	99                   	cltd   
  8013b8:	f7 f9                	idiv   %ecx
  8013ba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c0:	8d 50 01             	lea    0x1(%eax),%edx
  8013c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c6:	89 c2                	mov    %eax,%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 d0                	add    %edx,%eax
  8013cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d0:	83 c2 30             	add    $0x30,%edx
  8013d3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013dd:	f7 e9                	imul   %ecx
  8013df:	c1 fa 02             	sar    $0x2,%edx
  8013e2:	89 c8                	mov    %ecx,%eax
  8013e4:	c1 f8 1f             	sar    $0x1f,%eax
  8013e7:	29 c2                	sub    %eax,%edx
  8013e9:	89 d0                	mov    %edx,%eax
  8013eb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f2:	75 bb                	jne    8013af <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	48                   	dec    %eax
  8013ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801402:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801406:	74 3d                	je     801445 <ltostr+0xc3>
		start = 1 ;
  801408:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80140f:	eb 34                	jmp    801445 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 c2                	add    %eax,%edx
  801426:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142c:	01 c8                	add    %ecx,%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	01 c2                	add    %eax,%edx
  80143a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80143d:	88 02                	mov    %al,(%edx)
		start++ ;
  80143f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801442:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801448:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144b:	7c c4                	jl     801411 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80144d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	01 d0                	add    %edx,%eax
  801455:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801461:	ff 75 08             	pushl  0x8(%ebp)
  801464:	e8 c4 f9 ff ff       	call   800e2d <strlen>
  801469:	83 c4 04             	add    $0x4,%esp
  80146c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	e8 b6 f9 ff ff       	call   800e2d <strlen>
  801477:	83 c4 04             	add    $0x4,%esp
  80147a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80147d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148b:	eb 17                	jmp    8014a4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80148d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	01 c2                	add    %eax,%edx
  801495:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	01 c8                	add    %ecx,%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a1:	ff 45 fc             	incl   -0x4(%ebp)
  8014a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014aa:	7c e1                	jl     80148d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014ba:	eb 1f                	jmp    8014db <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bf:	8d 50 01             	lea    0x1(%eax),%edx
  8014c2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c5:	89 c2                	mov    %eax,%edx
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	01 c2                	add    %eax,%edx
  8014cc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d2:	01 c8                	add    %ecx,%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d8:	ff 45 f8             	incl   -0x8(%ebp)
  8014db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e1:	7c d9                	jl     8014bc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e9:	01 d0                	add    %edx,%eax
  8014eb:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ee:	90                   	nop
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801500:	8b 00                	mov    (%eax),%eax
  801502:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801509:	8b 45 10             	mov    0x10(%ebp),%eax
  80150c:	01 d0                	add    %edx,%eax
  80150e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801514:	eb 0c                	jmp    801522 <strsplit+0x31>
			*string++ = 0;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8d 50 01             	lea    0x1(%eax),%edx
  80151c:	89 55 08             	mov    %edx,0x8(%ebp)
  80151f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	84 c0                	test   %al,%al
  801529:	74 18                	je     801543 <strsplit+0x52>
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f be c0             	movsbl %al,%eax
  801533:	50                   	push   %eax
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	e8 83 fa ff ff       	call   800fbf <strchr>
  80153c:	83 c4 08             	add    $0x8,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	75 d3                	jne    801516 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 5a                	je     8015a6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154c:	8b 45 14             	mov    0x14(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	83 f8 0f             	cmp    $0xf,%eax
  801554:	75 07                	jne    80155d <strsplit+0x6c>
		{
			return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	eb 66                	jmp    8015c3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80155d:	8b 45 14             	mov    0x14(%ebp),%eax
  801560:	8b 00                	mov    (%eax),%eax
  801562:	8d 48 01             	lea    0x1(%eax),%ecx
  801565:	8b 55 14             	mov    0x14(%ebp),%edx
  801568:	89 0a                	mov    %ecx,(%edx)
  80156a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801571:	8b 45 10             	mov    0x10(%ebp),%eax
  801574:	01 c2                	add    %eax,%edx
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157b:	eb 03                	jmp    801580 <strsplit+0x8f>
			string++;
  80157d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 8b                	je     801514 <strsplit+0x23>
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	0f be c0             	movsbl %al,%eax
  801591:	50                   	push   %eax
  801592:	ff 75 0c             	pushl  0xc(%ebp)
  801595:	e8 25 fa ff ff       	call   800fbf <strchr>
  80159a:	83 c4 08             	add    $0x8,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 dc                	je     80157d <strsplit+0x8c>
			string++;
	}
  8015a1:	e9 6e ff ff ff       	jmp    801514 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	01 d0                	add    %edx,%eax
  8015b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d8:	eb 4a                	jmp    801624 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	01 c2                	add    %eax,%edx
  8015e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e8:	01 c8                	add    %ecx,%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	3c 40                	cmp    $0x40,%al
  8015fa:	7e 25                	jle    801621 <str2lower+0x5c>
  8015fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	01 d0                	add    %edx,%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	3c 5a                	cmp    $0x5a,%al
  801608:	7f 17                	jg     801621 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801615:	8b 55 08             	mov    0x8(%ebp),%edx
  801618:	01 ca                	add    %ecx,%edx
  80161a:	8a 12                	mov    (%edx),%dl
  80161c:	83 c2 20             	add    $0x20,%edx
  80161f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801621:	ff 45 fc             	incl   -0x4(%ebp)
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	e8 01 f8 ff ff       	call   800e2d <strlen>
  80162c:	83 c4 04             	add    $0x4,%esp
  80162f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801632:	7f a6                	jg     8015da <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801634:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80163f:	a1 08 40 80 00       	mov    0x804008,%eax
  801644:	85 c0                	test   %eax,%eax
  801646:	74 42                	je     80168a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	68 00 00 00 82       	push   $0x82000000
  801650:	68 00 00 00 80       	push   $0x80000000
  801655:	e8 00 08 00 00       	call   801e5a <initialize_dynamic_allocator>
  80165a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80165d:	e8 e7 05 00 00       	call   801c49 <sys_get_uheap_strategy>
  801662:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801667:	a1 40 40 80 00       	mov    0x804040,%eax
  80166c:	05 00 10 00 00       	add    $0x1000,%eax
  801671:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801676:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80167b:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801680:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801687:	00 00 00 
	}
}
  80168a:	90                   	nop
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	68 06 04 00 00       	push   $0x406
  8016a9:	50                   	push   %eax
  8016aa:	e8 e4 01 00 00       	call   801893 <__sys_allocate_page>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b9:	79 14                	jns    8016cf <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	68 a8 32 80 00       	push   $0x8032a8
  8016c3:	6a 1f                	push   $0x1f
  8016c5:	68 e4 32 80 00       	push   $0x8032e4
  8016ca:	e8 b7 ed ff ff       	call   800486 <_panic>
	return 0;
  8016cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	50                   	push   %eax
  8016ee:	e8 e7 01 00 00       	call   8018da <__sys_unmap_frame>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016fd:	79 14                	jns    801713 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	68 f0 32 80 00       	push   $0x8032f0
  801707:	6a 2a                	push   $0x2a
  801709:	68 e4 32 80 00       	push   $0x8032e4
  80170e:	e8 73 ed ff ff       	call   800486 <_panic>
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171c:	e8 18 ff ff ff       	call   801639 <uheap_init>
	if (size == 0) return NULL ;
  801721:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801725:	75 07                	jne    80172e <malloc+0x18>
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
  80172c:	eb 14                	jmp    801742 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 30 33 80 00       	push   $0x803330
  801736:	6a 3e                	push   $0x3e
  801738:	68 e4 32 80 00       	push   $0x8032e4
  80173d:	e8 44 ed ff ff       	call   800486 <_panic>
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	68 58 33 80 00       	push   $0x803358
  801752:	6a 49                	push   $0x49
  801754:	68 e4 32 80 00       	push   $0x8032e4
  801759:	e8 28 ed ff ff       	call   800486 <_panic>

0080175e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 18             	sub    $0x18,%esp
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80176a:	e8 ca fe ff ff       	call   801639 <uheap_init>
	if (size == 0) return NULL ;
  80176f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801773:	75 07                	jne    80177c <smalloc+0x1e>
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 14                	jmp    801790 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	68 7c 33 80 00       	push   $0x80337c
  801784:	6a 5a                	push   $0x5a
  801786:	68 e4 32 80 00       	push   $0x8032e4
  80178b:	e8 f6 ec ff ff       	call   800486 <_panic>
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801798:	e8 9c fe ff ff       	call   801639 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 a4 33 80 00       	push   $0x8033a4
  8017a5:	6a 6a                	push   $0x6a
  8017a7:	68 e4 32 80 00       	push   $0x8032e4
  8017ac:	e8 d5 ec ff ff       	call   800486 <_panic>

008017b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017b7:	e8 7d fe ff ff       	call   801639 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 c8 33 80 00       	push   $0x8033c8
  8017c4:	68 88 00 00 00       	push   $0x88
  8017c9:	68 e4 32 80 00       	push   $0x8032e4
  8017ce:	e8 b3 ec ff ff       	call   800486 <_panic>

008017d3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 f0 33 80 00       	push   $0x8033f0
  8017e1:	68 9b 00 00 00       	push   $0x9b
  8017e6:	68 e4 32 80 00       	push   $0x8032e4
  8017eb:	e8 96 ec ff ff       	call   800486 <_panic>

008017f0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	57                   	push   %edi
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801805:	8b 7d 18             	mov    0x18(%ebp),%edi
  801808:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180b:	cd 30                	int    $0x30
  80180d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801810:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	5b                   	pop    %ebx
  801817:	5e                   	pop    %esi
  801818:	5f                   	pop    %edi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
  801824:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801827:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	51                   	push   %ecx
  801834:	52                   	push   %edx
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	50                   	push   %eax
  801839:	6a 00                	push   $0x0
  80183b:	e8 b0 ff ff ff       	call   8017f0 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	90                   	nop
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_cgetc>:

int
sys_cgetc(void)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 02                	push   $0x2
  801855:	e8 96 ff ff ff       	call   8017f0 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 03                	push   $0x3
  80186e:	e8 7d ff ff ff       	call   8017f0 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 04                	push   $0x4
  801888:	e8 63 ff ff ff       	call   8017f0 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 08                	push   $0x8
  8018a6:	e8 45 ff ff ff       	call   8017f0 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	56                   	push   %esi
  8018b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	51                   	push   %ecx
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 09                	push   $0x9
  8018cb:	e8 20 ff ff ff       	call   8017f0 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d6:	5b                   	pop    %ebx
  8018d7:	5e                   	pop    %esi
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    

008018da <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	6a 0a                	push   $0xa
  8018ea:	e8 01 ff ff ff       	call   8017f0 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	6a 0b                	push   $0xb
  801905:	e8 e6 fe ff ff       	call   8017f0 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 0c                	push   $0xc
  80191e:	e8 cd fe ff ff       	call   8017f0 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0d                	push   $0xd
  801937:	e8 b4 fe ff ff       	call   8017f0 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 0e                	push   $0xe
  801950:	e8 9b fe ff ff       	call   8017f0 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 0f                	push   $0xf
  801969:	e8 82 fe ff ff       	call   8017f0 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 10                	push   $0x10
  801983:	e8 68 fe ff ff       	call   8017f0 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 11                	push   $0x11
  80199c:	e8 4f fe ff ff       	call   8017f0 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	90                   	nop
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	50                   	push   %eax
  8019c0:	6a 01                	push   $0x1
  8019c2:	e8 29 fe ff ff       	call   8017f0 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 14                	push   $0x14
  8019dc:	e8 0f fe ff ff       	call   8017f0 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	90                   	nop
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	51                   	push   %ecx
  801a00:	52                   	push   %edx
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	50                   	push   %eax
  801a05:	6a 15                	push   $0x15
  801a07:	e8 e4 fd ff ff       	call   8017f0 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	52                   	push   %edx
  801a21:	50                   	push   %eax
  801a22:	6a 16                	push   $0x16
  801a24:	e8 c7 fd ff ff       	call   8017f0 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	51                   	push   %ecx
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 17                	push   $0x17
  801a43:	e8 a8 fd ff ff       	call   8017f0 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 18                	push   $0x18
  801a60:	e8 8b fd ff ff       	call   8017f0 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 14             	pushl  0x14(%ebp)
  801a75:	ff 75 10             	pushl  0x10(%ebp)
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	50                   	push   %eax
  801a7c:	6a 19                	push   $0x19
  801a7e:	e8 6d fd ff ff       	call   8017f0 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	50                   	push   %eax
  801a97:	6a 1a                	push   $0x1a
  801a99:	e8 52 fd ff ff       	call   8017f0 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	50                   	push   %eax
  801ab3:	6a 1b                	push   $0x1b
  801ab5:	e8 36 fd ff ff       	call   8017f0 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 05                	push   $0x5
  801ace:	e8 1d fd ff ff       	call   8017f0 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 06                	push   $0x6
  801ae7:	e8 04 fd ff ff       	call   8017f0 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 07                	push   $0x7
  801b00:	e8 eb fc ff ff       	call   8017f0 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_exit_env>:


void sys_exit_env(void)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 1c                	push   $0x1c
  801b19:	e8 d2 fc ff ff       	call   8017f0 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2d:	8d 50 04             	lea    0x4(%eax),%edx
  801b30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 1d                	push   $0x1d
  801b3d:	e8 ae fc ff ff       	call   8017f0 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return result;
  801b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4e:	89 01                	mov    %eax,(%ecx)
  801b50:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	c9                   	leave  
  801b57:	c2 04 00             	ret    $0x4

00801b5a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 10             	pushl  0x10(%ebp)
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	6a 13                	push   $0x13
  801b6c:	e8 7f fc ff ff       	call   8017f0 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 1e                	push   $0x1e
  801b86:	e8 65 fc ff ff       	call   8017f0 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	50                   	push   %eax
  801ba9:	6a 1f                	push   $0x1f
  801bab:	e8 40 fc ff ff       	call   8017f0 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb3:	90                   	nop
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <rsttst>:
void rsttst()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 21                	push   $0x21
  801bc5:	e8 26 fc ff ff       	call   8017f0 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bdc:	8b 55 18             	mov    0x18(%ebp),%edx
  801bdf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	ff 75 10             	pushl  0x10(%ebp)
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	6a 20                	push   $0x20
  801bf0:	e8 fb fb ff ff       	call   8017f0 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf8:	90                   	nop
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <chktst>:
void chktst(uint32 n)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 22                	push   $0x22
  801c0b:	e8 e0 fb ff ff       	call   8017f0 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <inctst>:

void inctst()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 23                	push   $0x23
  801c25:	e8 c6 fb ff ff       	call   8017f0 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <gettst>:
uint32 gettst()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 24                	push   $0x24
  801c3f:	e8 ac fb ff ff       	call   8017f0 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 25                	push   $0x25
  801c58:	e8 93 fb ff ff       	call   8017f0 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
  801c60:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c65:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	6a 26                	push   $0x26
  801c84:	e8 67 fb ff ff       	call   8017f0 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	53                   	push   %ebx
  801ca2:	51                   	push   %ecx
  801ca3:	52                   	push   %edx
  801ca4:	50                   	push   %eax
  801ca5:	6a 27                	push   $0x27
  801ca7:	e8 44 fb ff ff       	call   8017f0 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	52                   	push   %edx
  801cc4:	50                   	push   %eax
  801cc5:	6a 28                	push   $0x28
  801cc7:	e8 24 fb ff ff       	call   8017f0 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	51                   	push   %ecx
  801ce0:	ff 75 10             	pushl  0x10(%ebp)
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 29                	push   $0x29
  801ce7:	e8 04 fb ff ff       	call   8017f0 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	ff 75 10             	pushl  0x10(%ebp)
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	ff 75 08             	pushl  0x8(%ebp)
  801d01:	6a 12                	push   $0x12
  801d03:	e8 e8 fa ff ff       	call   8017f0 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0b:	90                   	nop
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	6a 2a                	push   $0x2a
  801d21:	e8 ca fa ff ff       	call   8017f0 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 2b                	push   $0x2b
  801d3b:	e8 b0 fa ff ff       	call   8017f0 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 2d                	push   $0x2d
  801d56:	e8 95 fa ff ff       	call   8017f0 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	6a 2c                	push   $0x2c
  801d72:	e8 79 fa ff ff       	call   8017f0 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d83:	83 ec 04             	sub    $0x4,%esp
  801d86:	68 14 34 80 00       	push   $0x803414
  801d8b:	68 25 01 00 00       	push   $0x125
  801d90:	68 47 34 80 00       	push   $0x803447
  801d95:	e8 ec e6 ff ff       	call   800486 <_panic>

00801d9a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801da0:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801da7:	72 09                	jb     801db2 <to_page_va+0x18>
  801da9:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801db0:	72 14                	jb     801dc6 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	68 58 34 80 00       	push   $0x803458
  801dba:	6a 15                	push   $0x15
  801dbc:	68 83 34 80 00       	push   $0x803483
  801dc1:	e8 c0 e6 ff ff       	call   800486 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	ba 60 40 80 00       	mov    $0x804060,%edx
  801dce:	29 d0                	sub    %edx,%eax
  801dd0:	c1 f8 02             	sar    $0x2,%eax
  801dd3:	89 c2                	mov    %eax,%edx
  801dd5:	89 d0                	mov    %edx,%eax
  801dd7:	c1 e0 02             	shl    $0x2,%eax
  801dda:	01 d0                	add    %edx,%eax
  801ddc:	c1 e0 02             	shl    $0x2,%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	c1 e0 02             	shl    $0x2,%eax
  801de4:	01 d0                	add    %edx,%eax
  801de6:	89 c1                	mov    %eax,%ecx
  801de8:	c1 e1 08             	shl    $0x8,%ecx
  801deb:	01 c8                	add    %ecx,%eax
  801ded:	89 c1                	mov    %eax,%ecx
  801def:	c1 e1 10             	shl    $0x10,%ecx
  801df2:	01 c8                	add    %ecx,%eax
  801df4:	01 c0                	add    %eax,%eax
  801df6:	01 d0                	add    %edx,%eax
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	c1 e0 0c             	shl    $0xc,%eax
  801e01:	89 c2                	mov    %eax,%edx
  801e03:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e08:	01 d0                	add    %edx,%eax
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e12:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e17:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1a:	29 c2                	sub    %eax,%edx
  801e1c:	89 d0                	mov    %edx,%eax
  801e1e:	c1 e8 0c             	shr    $0xc,%eax
  801e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e28:	78 09                	js     801e33 <to_page_info+0x27>
  801e2a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e31:	7e 14                	jle    801e47 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	68 9c 34 80 00       	push   $0x80349c
  801e3b:	6a 22                	push   $0x22
  801e3d:	68 83 34 80 00       	push   $0x803483
  801e42:	e8 3f e6 ff ff       	call   800486 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4a:	89 d0                	mov    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d0                	add    %edx,%eax
  801e50:	c1 e0 02             	shl    $0x2,%eax
  801e53:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	05 00 00 00 02       	add    $0x2000000,%eax
  801e68:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e6b:	73 16                	jae    801e83 <initialize_dynamic_allocator+0x29>
  801e6d:	68 c0 34 80 00       	push   $0x8034c0
  801e72:	68 e6 34 80 00       	push   $0x8034e6
  801e77:	6a 34                	push   $0x34
  801e79:	68 83 34 80 00       	push   $0x803483
  801e7e:	e8 03 e6 ff ff       	call   800486 <_panic>
		is_initialized = 1;
  801e83:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e8a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e9d:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801ea4:	00 00 00 
  801ea7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801eae:	00 00 00 
  801eb1:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801eb8:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	2b 45 08             	sub    0x8(%ebp),%eax
  801ec1:	c1 e8 0c             	shr    $0xc,%eax
  801ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ec7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ece:	e9 c8 00 00 00       	jmp    801f9b <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed6:	89 d0                	mov    %edx,%eax
  801ed8:	01 c0                	add    %eax,%eax
  801eda:	01 d0                	add    %edx,%eax
  801edc:	c1 e0 02             	shl    $0x2,%eax
  801edf:	05 68 40 80 00       	add    $0x804068,%eax
  801ee4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	01 c0                	add    %eax,%eax
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	c1 e0 02             	shl    $0x2,%eax
  801ef5:	05 6a 40 80 00       	add    $0x80406a,%eax
  801efa:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801eff:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f08:	89 c8                	mov    %ecx,%eax
  801f0a:	01 c0                	add    %eax,%eax
  801f0c:	01 c8                	add    %ecx,%eax
  801f0e:	c1 e0 02             	shl    $0x2,%eax
  801f11:	05 64 40 80 00       	add    $0x804064,%eax
  801f16:	89 10                	mov    %edx,(%eax)
  801f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1b:	89 d0                	mov    %edx,%eax
  801f1d:	01 c0                	add    %eax,%eax
  801f1f:	01 d0                	add    %edx,%eax
  801f21:	c1 e0 02             	shl    $0x2,%eax
  801f24:	05 64 40 80 00       	add    $0x804064,%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	74 1b                	je     801f4a <initialize_dynamic_allocator+0xf0>
  801f2f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f35:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f38:	89 c8                	mov    %ecx,%eax
  801f3a:	01 c0                	add    %eax,%eax
  801f3c:	01 c8                	add    %ecx,%eax
  801f3e:	c1 e0 02             	shl    $0x2,%eax
  801f41:	05 60 40 80 00       	add    $0x804060,%eax
  801f46:	89 02                	mov    %eax,(%edx)
  801f48:	eb 16                	jmp    801f60 <initialize_dynamic_allocator+0x106>
  801f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4d:	89 d0                	mov    %edx,%eax
  801f4f:	01 c0                	add    %eax,%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	c1 e0 02             	shl    $0x2,%eax
  801f56:	05 60 40 80 00       	add    $0x804060,%eax
  801f5b:	a3 48 40 80 00       	mov    %eax,0x804048
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	89 d0                	mov    %edx,%eax
  801f65:	01 c0                	add    %eax,%eax
  801f67:	01 d0                	add    %edx,%eax
  801f69:	c1 e0 02             	shl    $0x2,%eax
  801f6c:	05 60 40 80 00       	add    $0x804060,%eax
  801f71:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	01 c0                	add    %eax,%eax
  801f7d:	01 d0                	add    %edx,%eax
  801f7f:	c1 e0 02             	shl    $0x2,%eax
  801f82:	05 60 40 80 00       	add    $0x804060,%eax
  801f87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f8d:	a1 54 40 80 00       	mov    0x804054,%eax
  801f92:	40                   	inc    %eax
  801f93:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f98:	ff 45 f4             	incl   -0xc(%ebp)
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fa1:	0f 8c 2c ff ff ff    	jl     801ed3 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fa7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fae:	eb 36                	jmp    801fe6 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb3:	c1 e0 04             	shl    $0x4,%eax
  801fb6:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	c1 e0 04             	shl    $0x4,%eax
  801fc7:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd5:	c1 e0 04             	shl    $0x4,%eax
  801fd8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fe3:	ff 45 f0             	incl   -0x10(%ebp)
  801fe6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801fea:	7e c4                	jle    801fb0 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801fec:	90                   	nop
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	50                   	push   %eax
  801ffc:	e8 0b fe ff ff       	call   801e0c <to_page_info>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 40 08             	mov    0x8(%eax),%eax
  80200d:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	e8 77 fd ff ff       	call   801d9a <to_page_va>
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802029:	b8 00 10 00 00       	mov    $0x1000,%eax
  80202e:	ba 00 00 00 00       	mov    $0x0,%edx
  802033:	f7 75 08             	divl   0x8(%ebp)
  802036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	50                   	push   %eax
  802040:	e8 48 f6 ff ff       	call   80168d <get_page>
  802045:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	8b 55 0c             	mov    0xc(%ebp),%edx
  802058:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80205c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802063:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80206a:	eb 19                	jmp    802085 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80206c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206f:	ba 01 00 00 00       	mov    $0x1,%edx
  802074:	88 c1                	mov    %al,%cl
  802076:	d3 e2                	shl    %cl,%edx
  802078:	89 d0                	mov    %edx,%eax
  80207a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80207d:	74 0e                	je     80208d <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80207f:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802082:	ff 45 f0             	incl   -0x10(%ebp)
  802085:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802089:	7e e1                	jle    80206c <split_page_to_blocks+0x5a>
  80208b:	eb 01                	jmp    80208e <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80208d:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80208e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802095:	e9 a7 00 00 00       	jmp    802141 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80209a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209d:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020af:	75 14                	jne    8020c5 <split_page_to_blocks+0xb3>
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	68 fc 34 80 00       	push   $0x8034fc
  8020b9:	6a 7c                	push   $0x7c
  8020bb:	68 83 34 80 00       	push   $0x803483
  8020c0:	e8 c1 e3 ff ff       	call   800486 <_panic>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	c1 e0 04             	shl    $0x4,%eax
  8020cb:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020d0:	8b 10                	mov    (%eax),%edx
  8020d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d5:	89 50 04             	mov    %edx,0x4(%eax)
  8020d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 14                	je     8020f6 <split_page_to_blocks+0xe4>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	c1 e0 04             	shl    $0x4,%eax
  8020e8:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	eb 11                	jmp    802107 <split_page_to_blocks+0xf5>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	c1 e0 04             	shl    $0x4,%eax
  8020fc:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802105:	89 02                	mov    %eax,(%edx)
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	c1 e0 04             	shl    $0x4,%eax
  80210d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802116:	89 02                	mov    %eax,(%edx)
  802118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	c1 e0 04             	shl    $0x4,%eax
  802127:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80212c:	8b 00                	mov    (%eax),%eax
  80212e:	8d 50 01             	lea    0x1(%eax),%edx
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	c1 e0 04             	shl    $0x4,%eax
  802137:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80213c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80213e:	ff 45 ec             	incl   -0x14(%ebp)
  802141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802144:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802147:	0f 82 4d ff ff ff    	jb     80209a <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80214d:	90                   	nop
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802156:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80215d:	76 19                	jbe    802178 <alloc_block+0x28>
  80215f:	68 20 35 80 00       	push   $0x803520
  802164:	68 e6 34 80 00       	push   $0x8034e6
  802169:	68 8a 00 00 00       	push   $0x8a
  80216e:	68 83 34 80 00       	push   $0x803483
  802173:	e8 0e e3 ff ff       	call   800486 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80217f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802186:	eb 19                	jmp    8021a1 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	ba 01 00 00 00       	mov    $0x1,%edx
  802190:	88 c1                	mov    %al,%cl
  802192:	d3 e2                	shl    %cl,%edx
  802194:	89 d0                	mov    %edx,%eax
  802196:	3b 45 08             	cmp    0x8(%ebp),%eax
  802199:	73 0e                	jae    8021a9 <alloc_block+0x59>
		idx++;
  80219b:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80219e:	ff 45 f0             	incl   -0x10(%ebp)
  8021a1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021a5:	7e e1                	jle    802188 <alloc_block+0x38>
  8021a7:	eb 01                	jmp    8021aa <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021a9:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	c1 e0 04             	shl    $0x4,%eax
  8021b0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	0f 84 df 00 00 00    	je     80229e <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	c1 e0 04             	shl    $0x4,%eax
  8021c5:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d3:	75 17                	jne    8021ec <alloc_block+0x9c>
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 41 35 80 00       	push   $0x803541
  8021dd:	68 9e 00 00 00       	push   $0x9e
  8021e2:	68 83 34 80 00       	push   $0x803483
  8021e7:	e8 9a e2 ff ff       	call   800486 <_panic>
  8021ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	74 10                	je     802205 <alloc_block+0xb5>
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fd:	8b 52 04             	mov    0x4(%edx),%edx
  802200:	89 50 04             	mov    %edx,0x4(%eax)
  802203:	eb 14                	jmp    802219 <alloc_block+0xc9>
  802205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802208:	8b 40 04             	mov    0x4(%eax),%eax
  80220b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220e:	c1 e2 04             	shl    $0x4,%edx
  802211:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802217:	89 02                	mov    %eax,(%edx)
  802219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221c:	8b 40 04             	mov    0x4(%eax),%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	74 0f                	je     802232 <alloc_block+0xe2>
  802223:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802226:	8b 40 04             	mov    0x4(%eax),%eax
  802229:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222c:	8b 12                	mov    (%edx),%edx
  80222e:	89 10                	mov    %edx,(%eax)
  802230:	eb 13                	jmp    802245 <alloc_block+0xf5>
  802232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223a:	c1 e2 04             	shl    $0x4,%edx
  80223d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802243:	89 02                	mov    %eax,(%edx)
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	c1 e0 04             	shl    $0x4,%eax
  80225e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	8d 50 ff             	lea    -0x1(%eax),%edx
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	c1 e0 04             	shl    $0x4,%eax
  80226e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802273:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	83 ec 0c             	sub    $0xc,%esp
  80227b:	50                   	push   %eax
  80227c:	e8 8b fb ff ff       	call   801e0c <to_page_info>
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80228e:	48                   	dec    %eax
  80228f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802292:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	e9 bc 02 00 00       	jmp    80255a <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80229e:	a1 54 40 80 00       	mov    0x804054,%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	0f 84 7d 02 00 00    	je     802528 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022ab:	a1 48 40 80 00       	mov    0x804048,%eax
  8022b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022b7:	75 17                	jne    8022d0 <alloc_block+0x180>
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 41 35 80 00       	push   $0x803541
  8022c1:	68 a9 00 00 00       	push   $0xa9
  8022c6:	68 83 34 80 00       	push   $0x803483
  8022cb:	e8 b6 e1 ff ff       	call   800486 <_panic>
  8022d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 10                	je     8022e9 <alloc_block+0x199>
  8022d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022e1:	8b 52 04             	mov    0x4(%edx),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 0b                	jmp    8022f4 <alloc_block+0x1a4>
  8022e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0f                	je     80230d <alloc_block+0x1bd>
  8022fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802307:	8b 12                	mov    (%edx),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 0a                	jmp    802317 <alloc_block+0x1c7>
  80230d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	a3 48 40 80 00       	mov    %eax,0x804048
  802317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802323:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232a:	a1 54 40 80 00       	mov    0x804054,%eax
  80232f:	48                   	dec    %eax
  802330:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	83 c0 03             	add    $0x3,%eax
  80233b:	ba 01 00 00 00       	mov    $0x1,%edx
  802340:	88 c1                	mov    %al,%cl
  802342:	d3 e2                	shl    %cl,%edx
  802344:	89 d0                	mov    %edx,%eax
  802346:	83 ec 08             	sub    $0x8,%esp
  802349:	ff 75 e4             	pushl  -0x1c(%ebp)
  80234c:	50                   	push   %eax
  80234d:	e8 c0 fc ff ff       	call   802012 <split_page_to_blocks>
  802352:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	c1 e0 04             	shl    $0x4,%eax
  80235b:	05 80 c0 81 00       	add    $0x81c080,%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802365:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802369:	75 17                	jne    802382 <alloc_block+0x232>
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	68 41 35 80 00       	push   $0x803541
  802373:	68 b0 00 00 00       	push   $0xb0
  802378:	68 83 34 80 00       	push   $0x803483
  80237d:	e8 04 e1 ff ff       	call   800486 <_panic>
  802382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	74 10                	je     80239b <alloc_block+0x24b>
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802393:	8b 52 04             	mov    0x4(%edx),%edx
  802396:	89 50 04             	mov    %edx,0x4(%eax)
  802399:	eb 14                	jmp    8023af <alloc_block+0x25f>
  80239b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239e:	8b 40 04             	mov    0x4(%eax),%eax
  8023a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a4:	c1 e2 04             	shl    $0x4,%edx
  8023a7:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023ad:	89 02                	mov    %eax,(%edx)
  8023af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 0f                	je     8023c8 <alloc_block+0x278>
  8023b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bc:	8b 40 04             	mov    0x4(%eax),%eax
  8023bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023c2:	8b 12                	mov    (%edx),%edx
  8023c4:	89 10                	mov    %edx,(%eax)
  8023c6:	eb 13                	jmp    8023db <alloc_block+0x28b>
  8023c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d0:	c1 e2 04             	shl    $0x4,%edx
  8023d3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023d9:	89 02                	mov    %eax,(%edx)
  8023db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c1 e0 04             	shl    $0x4,%eax
  8023f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	c1 e0 04             	shl    $0x4,%eax
  802404:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802409:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80240b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	50                   	push   %eax
  802412:	e8 f5 f9 ff ff       	call   801e0c <to_page_info>
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80241d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802420:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802424:	48                   	dec    %eax
  802425:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802428:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80242c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242f:	e9 26 01 00 00       	jmp    80255a <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802434:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	c1 e0 04             	shl    $0x4,%eax
  80243d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	0f 84 dc 00 00 00    	je     802528 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	c1 e0 04             	shl    $0x4,%eax
  802452:	05 80 c0 81 00       	add    $0x81c080,%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80245c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802460:	75 17                	jne    802479 <alloc_block+0x329>
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	68 41 35 80 00       	push   $0x803541
  80246a:	68 be 00 00 00       	push   $0xbe
  80246f:	68 83 34 80 00       	push   $0x803483
  802474:	e8 0d e0 ff ff       	call   800486 <_panic>
  802479:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 10                	je     802492 <alloc_block+0x342>
  802482:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80248a:	8b 52 04             	mov    0x4(%edx),%edx
  80248d:	89 50 04             	mov    %edx,0x4(%eax)
  802490:	eb 14                	jmp    8024a6 <alloc_block+0x356>
  802492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802495:	8b 40 04             	mov    0x4(%eax),%eax
  802498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249b:	c1 e2 04             	shl    $0x4,%edx
  80249e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024a4:	89 02                	mov    %eax,(%edx)
  8024a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0f                	je     8024bf <alloc_block+0x36f>
  8024b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024b9:	8b 12                	mov    (%edx),%edx
  8024bb:	89 10                	mov    %edx,(%eax)
  8024bd:	eb 13                	jmp    8024d2 <alloc_block+0x382>
  8024bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	c1 e2 04             	shl    $0x4,%edx
  8024ca:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024d0:	89 02                	mov    %eax,(%edx)
  8024d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	c1 e0 04             	shl    $0x4,%eax
  8024eb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	c1 e0 04             	shl    $0x4,%eax
  8024fb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802500:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802502:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	50                   	push   %eax
  802509:	e8 fe f8 ff ff       	call   801e0c <to_page_info>
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802517:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80251b:	48                   	dec    %eax
  80251c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80251f:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802523:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802526:	eb 32                	jmp    80255a <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802528:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80252c:	77 15                	ja     802543 <alloc_block+0x3f3>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	c1 e0 04             	shl    $0x4,%eax
  802534:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	0f 84 f1 fe ff ff    	je     802434 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 5f 35 80 00       	push   $0x80355f
  80254b:	68 c8 00 00 00       	push   $0xc8
  802550:	68 83 34 80 00       	push   $0x803483
  802555:	e8 2c df ff ff       	call   800486 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802562:	8b 55 08             	mov    0x8(%ebp),%edx
  802565:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80256a:	39 c2                	cmp    %eax,%edx
  80256c:	72 0c                	jb     80257a <free_block+0x1e>
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	a1 40 40 80 00       	mov    0x804040,%eax
  802576:	39 c2                	cmp    %eax,%edx
  802578:	72 19                	jb     802593 <free_block+0x37>
  80257a:	68 70 35 80 00       	push   $0x803570
  80257f:	68 e6 34 80 00       	push   $0x8034e6
  802584:	68 d7 00 00 00       	push   $0xd7
  802589:	68 83 34 80 00       	push   $0x803483
  80258e:	e8 f3 de ff ff       	call   800486 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	83 ec 0c             	sub    $0xc,%esp
  80259f:	50                   	push   %eax
  8025a0:	e8 67 f8 ff ff       	call   801e0c <to_page_info>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	8b 40 08             	mov    0x8(%eax),%eax
  8025b1:	0f b7 c0             	movzwl %ax,%eax
  8025b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025be:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025c5:	eb 19                	jmp    8025e0 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ca:	ba 01 00 00 00       	mov    $0x1,%edx
  8025cf:	88 c1                	mov    %al,%cl
  8025d1:	d3 e2                	shl    %cl,%edx
  8025d3:	89 d0                	mov    %edx,%eax
  8025d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025d8:	74 0e                	je     8025e8 <free_block+0x8c>
	        break;
	    idx++;
  8025da:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025dd:	ff 45 f0             	incl   -0x10(%ebp)
  8025e0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025e4:	7e e1                	jle    8025c7 <free_block+0x6b>
  8025e6:	eb 01                	jmp    8025e9 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025e8:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ec:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025f0:	40                   	inc    %eax
  8025f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8025f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025fc:	75 17                	jne    802615 <free_block+0xb9>
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 fc 34 80 00       	push   $0x8034fc
  802606:	68 ee 00 00 00       	push   $0xee
  80260b:	68 83 34 80 00       	push   $0x803483
  802610:	e8 71 de ff ff       	call   800486 <_panic>
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	c1 e0 04             	shl    $0x4,%eax
  80261b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802620:	8b 10                	mov    (%eax),%edx
  802622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802625:	89 50 04             	mov    %edx,0x4(%eax)
  802628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 14                	je     802646 <free_block+0xea>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c1 e0 04             	shl    $0x4,%eax
  802638:	05 84 c0 81 00       	add    $0x81c084,%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802642:	89 10                	mov    %edx,(%eax)
  802644:	eb 11                	jmp    802657 <free_block+0xfb>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	c1 e0 04             	shl    $0x4,%eax
  80264c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802655:	89 02                	mov    %eax,(%edx)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	c1 e0 04             	shl    $0x4,%eax
  80265d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802666:	89 02                	mov    %eax,(%edx)
  802668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	c1 e0 04             	shl    $0x4,%eax
  802677:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	8d 50 01             	lea    0x1(%eax),%edx
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	c1 e0 04             	shl    $0x4,%eax
  802687:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80268c:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80268e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802693:	ba 00 00 00 00       	mov    $0x0,%edx
  802698:	f7 75 e0             	divl   -0x20(%ebp)
  80269b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026a5:	0f b7 c0             	movzwl %ax,%eax
  8026a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026ab:	0f 85 70 01 00 00    	jne    802821 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026b1:	83 ec 0c             	sub    $0xc,%esp
  8026b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026b7:	e8 de f6 ff ff       	call   801d9a <to_page_va>
  8026bc:	83 c4 10             	add    $0x10,%esp
  8026bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026c9:	e9 b7 00 00 00       	jmp    802785 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026dd:	75 17                	jne    8026f6 <free_block+0x19a>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 41 35 80 00       	push   $0x803541
  8026e7:	68 f8 00 00 00       	push   $0xf8
  8026ec:	68 83 34 80 00       	push   $0x803483
  8026f1:	e8 90 dd ff ff       	call   800486 <_panic>
  8026f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 10                	je     80270f <free_block+0x1b3>
  8026ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802707:	8b 52 04             	mov    0x4(%edx),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
  80270d:	eb 14                	jmp    802723 <free_block+0x1c7>
  80270f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	c1 e2 04             	shl    $0x4,%edx
  80271b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802721:	89 02                	mov    %eax,(%edx)
  802723:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 0f                	je     80273c <free_block+0x1e0>
  80272d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802736:	8b 12                	mov    (%edx),%edx
  802738:	89 10                	mov    %edx,(%eax)
  80273a:	eb 13                	jmp    80274f <free_block+0x1f3>
  80273c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802744:	c1 e2 04             	shl    $0x4,%edx
  802747:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80274d:	89 02                	mov    %eax,(%edx)
  80274f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80275b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	c1 e0 04             	shl    $0x4,%eax
  802768:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	c1 e0 04             	shl    $0x4,%eax
  802778:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80277d:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80277f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802782:	01 45 ec             	add    %eax,-0x14(%ebp)
  802785:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80278c:	0f 86 3c ff ff ff    	jbe    8026ce <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802795:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80279b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027a8:	75 17                	jne    8027c1 <free_block+0x265>
  8027aa:	83 ec 04             	sub    $0x4,%esp
  8027ad:	68 fc 34 80 00       	push   $0x8034fc
  8027b2:	68 fe 00 00 00       	push   $0xfe
  8027b7:	68 83 34 80 00       	push   $0x803483
  8027bc:	e8 c5 dc ff ff       	call   800486 <_panic>
  8027c1:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d0:	8b 40 04             	mov    0x4(%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 0c                	je     8027e3 <free_block+0x287>
  8027d7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027df:	89 10                	mov    %edx,(%eax)
  8027e1:	eb 08                	jmp    8027eb <free_block+0x28f>
  8027e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e6:	a3 48 40 80 00       	mov    %eax,0x804048
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fc:	a1 54 40 80 00       	mov    0x804054,%eax
  802801:	40                   	inc    %eax
  802802:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80280d:	e8 88 f5 ff ff       	call   801d9a <to_page_va>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	83 ec 0c             	sub    $0xc,%esp
  802818:	50                   	push   %eax
  802819:	e8 b8 ee ff ff       	call   8016d6 <return_page>
  80281e:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802821:	90                   	nop
  802822:	c9                   	leave  
  802823:	c3                   	ret    

00802824 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
  802827:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 a8 35 80 00       	push   $0x8035a8
  802832:	68 11 01 00 00       	push   $0x111
  802837:	68 83 34 80 00       	push   $0x803483
  80283c:	e8 45 dc ff ff       	call   800486 <_panic>

00802841 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	68 cc 35 80 00       	push   $0x8035cc
  80284f:	6a 07                	push   $0x7
  802851:	68 fb 35 80 00       	push   $0x8035fb
  802856:	e8 2b dc ff ff       	call   800486 <_panic>

0080285b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 0c 36 80 00       	push   $0x80360c
  802869:	6a 0b                	push   $0xb
  80286b:	68 fb 35 80 00       	push   $0x8035fb
  802870:	e8 11 dc ff ff       	call   800486 <_panic>

00802875 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 38 36 80 00       	push   $0x803638
  802883:	6a 10                	push   $0x10
  802885:	68 fb 35 80 00       	push   $0x8035fb
  80288a:	e8 f7 db ff ff       	call   800486 <_panic>

0080288f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 68 36 80 00       	push   $0x803668
  80289d:	6a 15                	push   $0x15
  80289f:	68 fb 35 80 00       	push   $0x8035fb
  8028a4:	e8 dd db ff ff       	call   800486 <_panic>

008028a9 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 40 10             	mov    0x10(%eax),%eax
}
  8028b2:	5d                   	pop    %ebp
  8028b3:	c3                   	ret    

008028b4 <__udivdi3>:
  8028b4:	55                   	push   %ebp
  8028b5:	57                   	push   %edi
  8028b6:	56                   	push   %esi
  8028b7:	53                   	push   %ebx
  8028b8:	83 ec 1c             	sub    $0x1c,%esp
  8028bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028cb:	89 ca                	mov    %ecx,%edx
  8028cd:	89 f8                	mov    %edi,%eax
  8028cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8028d3:	85 f6                	test   %esi,%esi
  8028d5:	75 2d                	jne    802904 <__udivdi3+0x50>
  8028d7:	39 cf                	cmp    %ecx,%edi
  8028d9:	77 65                	ja     802940 <__udivdi3+0x8c>
  8028db:	89 fd                	mov    %edi,%ebp
  8028dd:	85 ff                	test   %edi,%edi
  8028df:	75 0b                	jne    8028ec <__udivdi3+0x38>
  8028e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e6:	31 d2                	xor    %edx,%edx
  8028e8:	f7 f7                	div    %edi
  8028ea:	89 c5                	mov    %eax,%ebp
  8028ec:	31 d2                	xor    %edx,%edx
  8028ee:	89 c8                	mov    %ecx,%eax
  8028f0:	f7 f5                	div    %ebp
  8028f2:	89 c1                	mov    %eax,%ecx
  8028f4:	89 d8                	mov    %ebx,%eax
  8028f6:	f7 f5                	div    %ebp
  8028f8:	89 cf                	mov    %ecx,%edi
  8028fa:	89 fa                	mov    %edi,%edx
  8028fc:	83 c4 1c             	add    $0x1c,%esp
  8028ff:	5b                   	pop    %ebx
  802900:	5e                   	pop    %esi
  802901:	5f                   	pop    %edi
  802902:	5d                   	pop    %ebp
  802903:	c3                   	ret    
  802904:	39 ce                	cmp    %ecx,%esi
  802906:	77 28                	ja     802930 <__udivdi3+0x7c>
  802908:	0f bd fe             	bsr    %esi,%edi
  80290b:	83 f7 1f             	xor    $0x1f,%edi
  80290e:	75 40                	jne    802950 <__udivdi3+0x9c>
  802910:	39 ce                	cmp    %ecx,%esi
  802912:	72 0a                	jb     80291e <__udivdi3+0x6a>
  802914:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802918:	0f 87 9e 00 00 00    	ja     8029bc <__udivdi3+0x108>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	89 fa                	mov    %edi,%edx
  802925:	83 c4 1c             	add    $0x1c,%esp
  802928:	5b                   	pop    %ebx
  802929:	5e                   	pop    %esi
  80292a:	5f                   	pop    %edi
  80292b:	5d                   	pop    %ebp
  80292c:	c3                   	ret    
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	31 ff                	xor    %edi,%edi
  802932:	31 c0                	xor    %eax,%eax
  802934:	89 fa                	mov    %edi,%edx
  802936:	83 c4 1c             	add    $0x1c,%esp
  802939:	5b                   	pop    %ebx
  80293a:	5e                   	pop    %esi
  80293b:	5f                   	pop    %edi
  80293c:	5d                   	pop    %ebp
  80293d:	c3                   	ret    
  80293e:	66 90                	xchg   %ax,%ax
  802940:	89 d8                	mov    %ebx,%eax
  802942:	f7 f7                	div    %edi
  802944:	31 ff                	xor    %edi,%edi
  802946:	89 fa                	mov    %edi,%edx
  802948:	83 c4 1c             	add    $0x1c,%esp
  80294b:	5b                   	pop    %ebx
  80294c:	5e                   	pop    %esi
  80294d:	5f                   	pop    %edi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    
  802950:	bd 20 00 00 00       	mov    $0x20,%ebp
  802955:	89 eb                	mov    %ebp,%ebx
  802957:	29 fb                	sub    %edi,%ebx
  802959:	89 f9                	mov    %edi,%ecx
  80295b:	d3 e6                	shl    %cl,%esi
  80295d:	89 c5                	mov    %eax,%ebp
  80295f:	88 d9                	mov    %bl,%cl
  802961:	d3 ed                	shr    %cl,%ebp
  802963:	89 e9                	mov    %ebp,%ecx
  802965:	09 f1                	or     %esi,%ecx
  802967:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80296b:	89 f9                	mov    %edi,%ecx
  80296d:	d3 e0                	shl    %cl,%eax
  80296f:	89 c5                	mov    %eax,%ebp
  802971:	89 d6                	mov    %edx,%esi
  802973:	88 d9                	mov    %bl,%cl
  802975:	d3 ee                	shr    %cl,%esi
  802977:	89 f9                	mov    %edi,%ecx
  802979:	d3 e2                	shl    %cl,%edx
  80297b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80297f:	88 d9                	mov    %bl,%cl
  802981:	d3 e8                	shr    %cl,%eax
  802983:	09 c2                	or     %eax,%edx
  802985:	89 d0                	mov    %edx,%eax
  802987:	89 f2                	mov    %esi,%edx
  802989:	f7 74 24 0c          	divl   0xc(%esp)
  80298d:	89 d6                	mov    %edx,%esi
  80298f:	89 c3                	mov    %eax,%ebx
  802991:	f7 e5                	mul    %ebp
  802993:	39 d6                	cmp    %edx,%esi
  802995:	72 19                	jb     8029b0 <__udivdi3+0xfc>
  802997:	74 0b                	je     8029a4 <__udivdi3+0xf0>
  802999:	89 d8                	mov    %ebx,%eax
  80299b:	31 ff                	xor    %edi,%edi
  80299d:	e9 58 ff ff ff       	jmp    8028fa <__udivdi3+0x46>
  8029a2:	66 90                	xchg   %ax,%ax
  8029a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029a8:	89 f9                	mov    %edi,%ecx
  8029aa:	d3 e2                	shl    %cl,%edx
  8029ac:	39 c2                	cmp    %eax,%edx
  8029ae:	73 e9                	jae    802999 <__udivdi3+0xe5>
  8029b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029b3:	31 ff                	xor    %edi,%edi
  8029b5:	e9 40 ff ff ff       	jmp    8028fa <__udivdi3+0x46>
  8029ba:	66 90                	xchg   %ax,%ax
  8029bc:	31 c0                	xor    %eax,%eax
  8029be:	e9 37 ff ff ff       	jmp    8028fa <__udivdi3+0x46>
  8029c3:	90                   	nop

008029c4 <__umoddi3>:
  8029c4:	55                   	push   %ebp
  8029c5:	57                   	push   %edi
  8029c6:	56                   	push   %esi
  8029c7:	53                   	push   %ebx
  8029c8:	83 ec 1c             	sub    $0x1c,%esp
  8029cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8029cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e3:	89 f3                	mov    %esi,%ebx
  8029e5:	89 fa                	mov    %edi,%edx
  8029e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029eb:	89 34 24             	mov    %esi,(%esp)
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	75 1a                	jne    802a0c <__umoddi3+0x48>
  8029f2:	39 f7                	cmp    %esi,%edi
  8029f4:	0f 86 a2 00 00 00    	jbe    802a9c <__umoddi3+0xd8>
  8029fa:	89 c8                	mov    %ecx,%eax
  8029fc:	89 f2                	mov    %esi,%edx
  8029fe:	f7 f7                	div    %edi
  802a00:	89 d0                	mov    %edx,%eax
  802a02:	31 d2                	xor    %edx,%edx
  802a04:	83 c4 1c             	add    $0x1c,%esp
  802a07:	5b                   	pop    %ebx
  802a08:	5e                   	pop    %esi
  802a09:	5f                   	pop    %edi
  802a0a:	5d                   	pop    %ebp
  802a0b:	c3                   	ret    
  802a0c:	39 f0                	cmp    %esi,%eax
  802a0e:	0f 87 ac 00 00 00    	ja     802ac0 <__umoddi3+0xfc>
  802a14:	0f bd e8             	bsr    %eax,%ebp
  802a17:	83 f5 1f             	xor    $0x1f,%ebp
  802a1a:	0f 84 ac 00 00 00    	je     802acc <__umoddi3+0x108>
  802a20:	bf 20 00 00 00       	mov    $0x20,%edi
  802a25:	29 ef                	sub    %ebp,%edi
  802a27:	89 fe                	mov    %edi,%esi
  802a29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a2d:	89 e9                	mov    %ebp,%ecx
  802a2f:	d3 e0                	shl    %cl,%eax
  802a31:	89 d7                	mov    %edx,%edi
  802a33:	89 f1                	mov    %esi,%ecx
  802a35:	d3 ef                	shr    %cl,%edi
  802a37:	09 c7                	or     %eax,%edi
  802a39:	89 e9                	mov    %ebp,%ecx
  802a3b:	d3 e2                	shl    %cl,%edx
  802a3d:	89 14 24             	mov    %edx,(%esp)
  802a40:	89 d8                	mov    %ebx,%eax
  802a42:	d3 e0                	shl    %cl,%eax
  802a44:	89 c2                	mov    %eax,%edx
  802a46:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a4a:	d3 e0                	shl    %cl,%eax
  802a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a50:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a54:	89 f1                	mov    %esi,%ecx
  802a56:	d3 e8                	shr    %cl,%eax
  802a58:	09 d0                	or     %edx,%eax
  802a5a:	d3 eb                	shr    %cl,%ebx
  802a5c:	89 da                	mov    %ebx,%edx
  802a5e:	f7 f7                	div    %edi
  802a60:	89 d3                	mov    %edx,%ebx
  802a62:	f7 24 24             	mull   (%esp)
  802a65:	89 c6                	mov    %eax,%esi
  802a67:	89 d1                	mov    %edx,%ecx
  802a69:	39 d3                	cmp    %edx,%ebx
  802a6b:	0f 82 87 00 00 00    	jb     802af8 <__umoddi3+0x134>
  802a71:	0f 84 91 00 00 00    	je     802b08 <__umoddi3+0x144>
  802a77:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a7b:	29 f2                	sub    %esi,%edx
  802a7d:	19 cb                	sbb    %ecx,%ebx
  802a7f:	89 d8                	mov    %ebx,%eax
  802a81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a85:	d3 e0                	shl    %cl,%eax
  802a87:	89 e9                	mov    %ebp,%ecx
  802a89:	d3 ea                	shr    %cl,%edx
  802a8b:	09 d0                	or     %edx,%eax
  802a8d:	89 e9                	mov    %ebp,%ecx
  802a8f:	d3 eb                	shr    %cl,%ebx
  802a91:	89 da                	mov    %ebx,%edx
  802a93:	83 c4 1c             	add    $0x1c,%esp
  802a96:	5b                   	pop    %ebx
  802a97:	5e                   	pop    %esi
  802a98:	5f                   	pop    %edi
  802a99:	5d                   	pop    %ebp
  802a9a:	c3                   	ret    
  802a9b:	90                   	nop
  802a9c:	89 fd                	mov    %edi,%ebp
  802a9e:	85 ff                	test   %edi,%edi
  802aa0:	75 0b                	jne    802aad <__umoddi3+0xe9>
  802aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa7:	31 d2                	xor    %edx,%edx
  802aa9:	f7 f7                	div    %edi
  802aab:	89 c5                	mov    %eax,%ebp
  802aad:	89 f0                	mov    %esi,%eax
  802aaf:	31 d2                	xor    %edx,%edx
  802ab1:	f7 f5                	div    %ebp
  802ab3:	89 c8                	mov    %ecx,%eax
  802ab5:	f7 f5                	div    %ebp
  802ab7:	89 d0                	mov    %edx,%eax
  802ab9:	e9 44 ff ff ff       	jmp    802a02 <__umoddi3+0x3e>
  802abe:	66 90                	xchg   %ax,%ax
  802ac0:	89 c8                	mov    %ecx,%eax
  802ac2:	89 f2                	mov    %esi,%edx
  802ac4:	83 c4 1c             	add    $0x1c,%esp
  802ac7:	5b                   	pop    %ebx
  802ac8:	5e                   	pop    %esi
  802ac9:	5f                   	pop    %edi
  802aca:	5d                   	pop    %ebp
  802acb:	c3                   	ret    
  802acc:	3b 04 24             	cmp    (%esp),%eax
  802acf:	72 06                	jb     802ad7 <__umoddi3+0x113>
  802ad1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802ad5:	77 0f                	ja     802ae6 <__umoddi3+0x122>
  802ad7:	89 f2                	mov    %esi,%edx
  802ad9:	29 f9                	sub    %edi,%ecx
  802adb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802adf:	89 14 24             	mov    %edx,(%esp)
  802ae2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ae6:	8b 44 24 04          	mov    0x4(%esp),%eax
  802aea:	8b 14 24             	mov    (%esp),%edx
  802aed:	83 c4 1c             	add    $0x1c,%esp
  802af0:	5b                   	pop    %ebx
  802af1:	5e                   	pop    %esi
  802af2:	5f                   	pop    %edi
  802af3:	5d                   	pop    %ebp
  802af4:	c3                   	ret    
  802af5:	8d 76 00             	lea    0x0(%esi),%esi
  802af8:	2b 04 24             	sub    (%esp),%eax
  802afb:	19 fa                	sbb    %edi,%edx
  802afd:	89 d1                	mov    %edx,%ecx
  802aff:	89 c6                	mov    %eax,%esi
  802b01:	e9 71 ff ff ff       	jmp    802a77 <__umoddi3+0xb3>
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b0c:	72 ea                	jb     802af8 <__umoddi3+0x134>
  802b0e:	89 d9                	mov    %ebx,%ecx
  802b10:	e9 62 ff ff ff       	jmp    802a77 <__umoddi3+0xb3>
