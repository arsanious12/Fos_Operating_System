
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 b7 08 00 00       	call   8008ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	/*[1] CREATE SEMAPHORES*/
	struct semaphore ready = create_semaphore("Ready", 0);
  800044:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	6a 00                	push   $0x0
  80004c:	68 c0 34 80 00       	push   $0x8034c0
  800051:	50                   	push   %eax
  800052:	e8 1e 30 00 00       	call   803075 <create_semaphore>
  800057:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  80005a:	8d 45 80             	lea    -0x80(%ebp),%eax
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	6a 00                	push   $0x0
  800062:	68 c6 34 80 00       	push   $0x8034c6
  800067:	50                   	push   %eax
  800068:	e8 08 30 00 00       	call   803075 <create_semaphore>
  80006d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  800070:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	6a 01                	push   $0x1
  80007b:	68 cf 34 80 00       	push   $0x8034cf
  800080:	50                   	push   %eax
  800081:	e8 ef 2f 00 00       	call   803075 <create_semaphore>
  800086:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800089:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  800090:	a1 20 50 80 00       	mov    0x805020,%eax
  800095:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80009b:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a0:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000a6:	89 c1                	mov    %eax,%ecx
  8000a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ad:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b3:	52                   	push   %edx
  8000b4:	51                   	push   %ecx
  8000b5:	50                   	push   %eax
  8000b6:	68 dd 34 80 00       	push   $0x8034dd
  8000bb:	e8 de 21 00 00       	call   80229e <sys_create_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000cb:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d6:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000dc:	89 c1                	mov    %eax,%ecx
  8000de:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e9:	52                   	push   %edx
  8000ea:	51                   	push   %ecx
  8000eb:	50                   	push   %eax
  8000ec:	68 e6 34 80 00       	push   $0x8034e6
  8000f1:	e8 a8 21 00 00       	call   80229e <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800101:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800107:	a1 20 50 80 00       	mov    0x805020,%eax
  80010c:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800112:	89 c1                	mov    %eax,%ecx
  800114:	a1 20 50 80 00       	mov    0x805020,%eax
  800119:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80011f:	52                   	push   %edx
  800120:	51                   	push   %ecx
  800121:	50                   	push   %eax
  800122:	68 ef 34 80 00       	push   $0x8034ef
  800127:	e8 72 21 00 00       	call   80229e <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800132:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800136:	74 0c                	je     800144 <_main+0x10c>
  800138:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  80013c:	74 06                	je     800144 <_main+0x10c>
  80013e:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  800142:	75 14                	jne    800158 <_main+0x120>
		panic("NO AVAILABLE ENVs...");
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 fb 34 80 00       	push   $0x8034fb
  80014c:	6a 1a                	push   $0x1a
  80014e:	68 10 35 80 00       	push   $0x803510
  800153:	e8 5a 09 00 00       	call   800ab2 <_panic>

	sys_run_env(envIdQuickSort);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d8             	pushl  -0x28(%ebp)
  80015e:	e8 59 21 00 00       	call   8022bc <sys_run_env>
  800163:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 d4             	pushl  -0x2c(%ebp)
  80016c:	e8 4b 21 00 00       	call   8022bc <sys_run_env>
  800171:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 d0             	pushl  -0x30(%ebp)
  80017a:	e8 3d 21 00 00       	call   8022bc <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  800182:	83 ec 04             	sub    $0x4,%esp
  800185:	6a 00                	push   $0x0
  800187:	6a 04                	push   $0x4
  800189:	68 2e 35 80 00       	push   $0x80352e
  80018e:	e8 ff 1d 00 00       	call   801f92 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  800199:	a1 20 50 80 00       	mov    0x805020,%eax
  80019e:	8b 50 10             	mov    0x10(%eax),%edx
  8001a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a4:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  8001a6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
	wait_semaphore(cons_mutex);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8001b6:	e8 ee 2e 00 00       	call   8030a9 <wait_semaphore>
  8001bb:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 41 35 80 00       	push   $0x803541
  8001c6:	e8 b5 0b 00 00       	call   800d80 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 43 35 80 00       	push   $0x803543
  8001d6:	e8 a5 0b 00 00       	call   800d80 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 61 35 80 00       	push   $0x803561
  8001e6:	e8 95 0b 00 00       	call   800d80 <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 43 35 80 00       	push   $0x803543
  8001f6:	e8 85 0b 00 00       	call   800d80 <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 41 35 80 00       	push   $0x803541
  800206:	e8 75 0b 00 00       	call   800d80 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	68 80 35 80 00       	push   $0x803580
  80021d:	e8 37 12 00 00       	call   801459 <readline>
  800222:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	6a 00                	push   $0x0
  80022a:	6a 04                	push   $0x4
  80022c:	68 9f 35 80 00       	push   $0x80359f
  800231:	e8 5c 1d 00 00       	call   801f92 <smalloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	6a 0a                	push   $0xa
  800241:	6a 00                	push   $0x0
  800243:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 21 18 00 00       	call   801a70 <strtol>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 c2                	mov    %eax,%edx
  800254:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800257:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  800259:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  800261:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800264:	c1 e0 02             	shl    $0x2,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	68 a7 35 80 00       	push   $0x8035a7
  800272:	e8 1b 1d 00 00       	call   801f92 <smalloc>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	68 ac 35 80 00       	push   $0x8035ac
  800285:	e8 f6 0a 00 00       	call   800d80 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 ce 35 80 00       	push   $0x8035ce
  800295:	e8 e6 0a 00 00       	call   800d80 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 dc 35 80 00       	push   $0x8035dc
  8002a5:	e8 d6 0a 00 00       	call   800d80 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 eb 35 80 00       	push   $0x8035eb
  8002b5:	e8 c6 0a 00 00       	call   800d80 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	68 fb 35 80 00       	push   $0x8035fb
  8002c5:	e8 b6 0a 00 00       	call   800d80 <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002cd:	e8 fe 05 00 00       	call   8008d0 <getchar>
  8002d2:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  8002d5:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	e8 cf 05 00 00       	call   8008b1 <cputchar>
  8002e2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	6a 0a                	push   $0xa
  8002ea:	e8 c2 05 00 00       	call   8008b1 <cputchar>
  8002ef:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  8002f2:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  8002f6:	74 0c                	je     800304 <_main+0x2cc>
  8002f8:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  8002fc:	74 06                	je     800304 <_main+0x2cc>
  8002fe:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800302:	75 b9                	jne    8002bd <_main+0x285>

	}
	signal_semaphore(cons_mutex);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80030d:	e8 b1 2d 00 00       	call   8030c3 <signal_semaphore>
  800312:	83 c4 10             	add    $0x10,%esp
	//unlock the console

	int  i ;
	switch (Chose)
  800315:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  800319:	83 f8 62             	cmp    $0x62,%eax
  80031c:	74 1d                	je     80033b <_main+0x303>
  80031e:	83 f8 63             	cmp    $0x63,%eax
  800321:	74 2b                	je     80034e <_main+0x316>
  800323:	83 f8 61             	cmp    $0x61,%eax
  800326:	75 39                	jne    800361 <_main+0x329>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	ff 75 c0             	pushl  -0x40(%ebp)
  80032e:	ff 75 c8             	pushl  -0x38(%ebp)
  800331:	e8 82 03 00 00       	call   8006b8 <InitializeAscending>
  800336:	83 c4 10             	add    $0x10,%esp
		break ;
  800339:	eb 37                	jmp    800372 <_main+0x33a>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	ff 75 c8             	pushl  -0x38(%ebp)
  800344:	e8 a0 03 00 00       	call   8006e9 <InitializeDescending>
  800349:	83 c4 10             	add    $0x10,%esp
		break ;
  80034c:	eb 24                	jmp    800372 <_main+0x33a>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 c0             	pushl  -0x40(%ebp)
  800354:	ff 75 c8             	pushl  -0x38(%ebp)
  800357:	e8 c2 03 00 00       	call   80071e <InitializeSemiRandom>
  80035c:	83 c4 10             	add    $0x10,%esp
		break ;
  80035f:	eb 11                	jmp    800372 <_main+0x33a>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 c0             	pushl  -0x40(%ebp)
  800367:	ff 75 c8             	pushl  -0x38(%ebp)
  80036a:	e8 af 03 00 00       	call   80071e <InitializeSemiRandom>
  80036f:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800372:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800379:	eb 11                	jmp    80038c <_main+0x354>
		signal_semaphore(ready);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 84             	pushl  -0x7c(%ebp)
  800381:	e8 3d 2d 00 00       	call   8030c3 <signal_semaphore>
  800386:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800389:	ff 45 e4             	incl   -0x1c(%ebp)
  80038c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800392:	7c e7                	jl     80037b <_main+0x343>
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039b:	eb 11                	jmp    8003ae <_main+0x376>
		wait_semaphore(finished);
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	ff 75 80             	pushl  -0x80(%ebp)
  8003a3:	e8 01 2d 00 00       	call   8030a9 <wait_semaphore>
  8003a8:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < numOfSlaveProgs; ++i) {
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  8003ab:	ff 45 e0             	incl   -0x20(%ebp)
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003b4:	7c e7                	jl     80039d <_main+0x365>
		wait_semaphore(finished);
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8003b6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8003bd:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8003c4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8003cb:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8003d2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8003d9:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  8003e0:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	68 04 36 80 00       	push   $0x803604
  8003ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f2:	e8 cf 1b 00 00       	call   801fc6 <sget>
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	68 13 36 80 00       	push   $0x803613
  800405:	ff 75 d4             	pushl  -0x2c(%ebp)
  800408:	e8 b9 1b 00 00       	call   801fc6 <sget>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 22 36 80 00       	push   $0x803622
  80041b:	ff 75 d0             	pushl  -0x30(%ebp)
  80041e:	e8 a3 1b 00 00       	call   801fc6 <sget>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	68 27 36 80 00       	push   $0x803627
  800431:	ff 75 d0             	pushl  -0x30(%ebp)
  800434:	e8 8d 1b 00 00       	call   801fc6 <sget>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	68 2b 36 80 00       	push   $0x80362b
  800447:	ff 75 d0             	pushl  -0x30(%ebp)
  80044a:	e8 77 1b 00 00       	call   801fc6 <sget>
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	68 2f 36 80 00       	push   $0x80362f
  80045d:	ff 75 d0             	pushl  -0x30(%ebp)
  800460:	e8 61 1b 00 00       	call   801fc6 <sget>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	68 33 36 80 00       	push   $0x803633
  800473:	ff 75 d0             	pushl  -0x30(%ebp)
  800476:	e8 4b 1b 00 00       	call   801fc6 <sget>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 c0             	pushl  -0x40(%ebp)
  800487:	ff 75 b8             	pushl  -0x48(%ebp)
  80048a:	e8 d2 01 00 00       	call   800661 <CheckSorted>
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  800495:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800499:	75 14                	jne    8004af <_main+0x477>
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	68 38 36 80 00       	push   $0x803638
  8004a3:	6a 77                	push   $0x77
  8004a5:	68 10 35 80 00       	push   $0x803510
  8004aa:	e8 03 06 00 00       	call   800ab2 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004b8:	e8 a4 01 00 00       	call   800661 <CheckSorted>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8004c3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8004c7:	75 14                	jne    8004dd <_main+0x4a5>
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 60 36 80 00       	push   $0x803660
  8004d1:	6a 79                	push   $0x79
  8004d3:	68 10 35 80 00       	push   $0x803510
  8004d8:	e8 d5 05 00 00       	call   800ab2 <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8004dd:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f1:	e8 74 02 00 00       	call   80076a <ArrayStats>
  8004f6:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8004f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	48                   	dec    %eax
  800505:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = (NumOfElements+1)/2 - 1; /*-1 to make it ZERO-Based*/
  800508:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050b:	40                   	inc    %eax
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	c1 ea 1f             	shr    $0x1f,%edx
  800511:	01 d0                	add    %edx,%eax
  800513:	d1 f8                	sar    %eax
  800515:	48                   	dec    %eax
  800516:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800519:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800523:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  80052d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800537:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 88             	mov    %eax,-0x78(%ebp)
	wait_semaphore(cons_mutex);
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80054a:	e8 5a 2b 00 00       	call   8030a9 <wait_semaphore>
  80054f:	83 c4 10             	add    $0x10,%esp
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  800552:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  80055d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800560:	8b 38                	mov    (%eax),%edi
  800562:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800565:	8b 30                	mov    (%eax),%esi
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8b 08                	mov    (%eax),%ecx
  80056c:	8b 58 04             	mov    0x4(%eax),%ebx
  80056f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
  80057d:	57                   	push   %edi
  80057e:	56                   	push   %esi
  80057f:	53                   	push   %ebx
  800580:	51                   	push   %ecx
  800581:	52                   	push   %edx
  800582:	50                   	push   %eax
  800583:	68 88 36 80 00       	push   $0x803688
  800588:	e8 f3 07 00 00       	call   800d80 <cprintf>
  80058d:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  800590:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800596:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
  80059c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005a2:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005a8:	ff 75 88             	pushl  -0x78(%ebp)
  8005ab:	ff 75 8c             	pushl  -0x74(%ebp)
  8005ae:	ff 75 98             	pushl  -0x68(%ebp)
  8005b1:	53                   	push   %ebx
  8005b2:	51                   	push   %ecx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	68 88 36 80 00       	push   $0x803688
  8005ba:	e8 c1 07 00 00       	call   800d80 <cprintf>
  8005bf:	83 c4 20             	add    $0x20,%esp
	}
	signal_semaphore(cons_mutex);
  8005c2:	83 ec 0c             	sub    $0xc,%esp
  8005c5:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8005cb:	e8 f3 2a 00 00       	call   8030c3 <signal_semaphore>
  8005d0:	83 c4 10             	add    $0x10,%esp
	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  8005d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005d6:	8b 08                	mov    (%eax),%ecx
  8005d8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005db:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005e1:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005e7:	89 de                	mov    %ebx,%esi
  8005e9:	31 d6                	xor    %edx,%esi
  8005eb:	31 c8                	xor    %ecx,%eax
  8005ed:	09 f0                	or     %esi,%eax
  8005ef:	85 c0                	test   %eax,%eax
  8005f1:	75 3e                	jne    800631 <_main+0x5f9>
  8005f3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005f6:	8b 08                	mov    (%eax),%ecx
  8005f8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005fb:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800601:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800607:	89 de                	mov    %ebx,%esi
  800609:	31 d6                	xor    %edx,%esi
  80060b:	31 c8                	xor    %ecx,%eax
  80060d:	09 f0                	or     %esi,%eax
  80060f:	85 c0                	test   %eax,%eax
  800611:	75 1e                	jne    800631 <_main+0x5f9>
  800613:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80061b:	75 14                	jne    800631 <_main+0x5f9>
  80061d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800625:	75 0a                	jne    800631 <_main+0x5f9>
  800627:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	3b 45 88             	cmp    -0x78(%ebp),%eax
  80062f:	74 17                	je     800648 <_main+0x610>
		panic("The array STATS are NOT calculated correctly") ;
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 c0 36 80 00       	push   $0x8036c0
  800639:	68 8d 00 00 00       	push   $0x8d
  80063e:	68 10 35 80 00       	push   $0x803510
  800643:	e8 6a 04 00 00       	call   800ab2 <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	68 f0 36 80 00       	push   $0x8036f0
  800650:	e8 2b 07 00 00       	call   800d80 <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp

	return;
  800658:	90                   	nop
}
  800659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065c:	5b                   	pop    %ebx
  80065d:	5e                   	pop    %esi
  80065e:	5f                   	pop    %edi
  80065f:	5d                   	pop    %ebp
  800660:	c3                   	ret    

00800661 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800667:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80066e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800675:	eb 33                	jmp    8006aa <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800677:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80068b:	40                   	inc    %eax
  80068c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	01 c8                	add    %ecx,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	39 c2                	cmp    %eax,%edx
  80069c:	7e 09                	jle    8006a7 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80069e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8006a5:	eb 0c                	jmp    8006b3 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8006a7:	ff 45 f8             	incl   -0x8(%ebp)
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	48                   	dec    %eax
  8006ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8006b1:	7f c4                	jg     800677 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8006b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006c5:	eb 17                	jmp    8006de <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	01 c2                	add    %eax,%edx
  8006d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006db:	ff 45 fc             	incl   -0x4(%ebp)
  8006de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e4:	7c e1                	jl     8006c7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006e6:	90                   	nop
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006f6:	eb 1b                	jmp    800713 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	01 c2                	add    %eax,%edx
  800707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070a:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80070d:	48                   	dec    %eax
  80070e:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800710:	ff 45 fc             	incl   -0x4(%ebp)
  800713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800716:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800719:	7c dd                	jl     8006f8 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800727:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072c:	f7 e9                	imul   %ecx
  80072e:	c1 f9 1f             	sar    $0x1f,%ecx
  800731:	89 d0                	mov    %edx,%eax
  800733:	29 c8                	sub    %ecx,%eax
  800735:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80073f:	eb 1e                	jmp    80075f <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800751:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800754:	99                   	cltd   
  800755:	f7 7d f8             	idivl  -0x8(%ebp)
  800758:	89 d0                	mov    %edx,%eax
  80075a:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80075c:	ff 45 fc             	incl   -0x4(%ebp)
  80075f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800762:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800765:	7c da                	jl     800741 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  800767:	90                   	nop
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	57                   	push   %edi
  80076e:	56                   	push   %esi
  80076f:	53                   	push   %ebx
  800770:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800773:	8b 45 10             	mov    0x10(%ebp),%eax
  800776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80077c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800783:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80078a:	eb 29                	jmp    8007b5 <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8b 08                	mov    (%eax),%ecx
  800791:	8b 58 04             	mov    0x4(%eax),%ebx
  800794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800797:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	01 d0                	add    %edx,%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	99                   	cltd   
  8007a6:	01 c8                	add    %ecx,%eax
  8007a8:	11 da                	adc    %ebx,%edx
  8007aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ad:	89 01                	mov    %eax,(%ecx)
  8007af:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007b2:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007bb:	7c cf                	jl     80078c <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	8b 50 04             	mov    0x4(%eax),%edx
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c8:	89 cb                	mov    %ecx,%ebx
  8007ca:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cd:	53                   	push   %ebx
  8007ce:	51                   	push   %ecx
  8007cf:	52                   	push   %edx
  8007d0:	50                   	push   %eax
  8007d1:	e8 12 29 00 00       	call   8030e8 <__divdi3>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007dc:	89 01                	mov    %eax,(%ecx)
  8007de:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8007ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8007f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f8:	eb 7e                	jmp    800878 <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800805:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	01 d0                	add    %edx,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 c1                	mov    %eax,%ecx
  80081b:	89 c3                	mov    %eax,%ebx
  80081d:	c1 fb 1f             	sar    $0x1f,%ebx
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8b 50 04             	mov    0x4(%eax),%edx
  800826:	8b 00                	mov    (%eax),%eax
  800828:	29 c1                	sub    %eax,%ecx
  80082a:	19 d3                	sbb    %edx,%ebx
  80082c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 c6                	mov    %eax,%esi
  80083f:	89 c7                	mov    %eax,%edi
  800841:	c1 ff 1f             	sar    $0x1f,%edi
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	29 c6                	sub    %eax,%esi
  80084e:	19 d7                	sbb    %edx,%edi
  800850:	89 f0                	mov    %esi,%eax
  800852:	89 fa                	mov    %edi,%edx
  800854:	89 df                	mov    %ebx,%edi
  800856:	0f af f8             	imul   %eax,%edi
  800859:	89 d6                	mov    %edx,%esi
  80085b:	0f af f1             	imul   %ecx,%esi
  80085e:	01 fe                	add    %edi,%esi
  800860:	f7 e1                	mul    %ecx
  800862:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800865:	89 ca                	mov    %ecx,%edx
  800867:	03 45 d0             	add    -0x30(%ebp),%eax
  80086a:	13 55 d4             	adc    -0x2c(%ebp),%edx
  80086d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800870:	89 01                	mov    %eax,(%ecx)
  800872:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800875:	ff 45 e4             	incl   -0x1c(%ebp)
  800878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80087b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087e:	0f 8c 76 ff ff ff    	jl     8007fa <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 50 04             	mov    0x4(%eax),%edx
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088f:	89 cb                	mov    %ecx,%ebx
  800891:	c1 fb 1f             	sar    $0x1f,%ebx
  800894:	53                   	push   %ebx
  800895:	51                   	push   %ecx
  800896:	52                   	push   %edx
  800897:	50                   	push   %eax
  800898:	e8 4b 28 00 00       	call   8030e8 <__divdi3>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008a3:	89 01                	mov    %eax,(%ecx)
  8008a5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8008a8:	90                   	nop
  8008a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8008bd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	50                   	push   %eax
  8008c5:	e8 11 19 00 00       	call   8021db <sys_cputc>
  8008ca:	83 c4 10             	add    $0x10,%esp
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <getchar>:


int
getchar(void)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8008d6:	e8 9f 17 00 00       	call   80207a <sys_cgetc>
  8008db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <iscons>:

int iscons(int fdnum)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8008e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	57                   	push   %edi
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8008f6:	e8 11 1a 00 00       	call   80230c <sys_getenvindex>
  8008fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8008fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	c1 e0 06             	shl    $0x6,%eax
  800906:	29 d0                	sub    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800914:	01 c8                	add    %ecx,%eax
  800916:	c1 e0 03             	shl    $0x3,%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800922:	29 c2                	sub    %eax,%edx
  800924:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80092b:	89 c2                	mov    %eax,%edx
  80092d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800933:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800938:	a1 20 50 80 00       	mov    0x805020,%eax
  80093d:	8a 40 20             	mov    0x20(%eax),%al
  800940:	84 c0                	test   %al,%al
  800942:	74 0d                	je     800951 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800944:	a1 20 50 80 00       	mov    0x805020,%eax
  800949:	83 c0 20             	add    $0x20,%eax
  80094c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800951:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800955:	7e 0a                	jle    800961 <libmain+0x74>
		binaryname = argv[0];
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	e8 c9 f6 ff ff       	call   800038 <_main>
  80096f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800972:	a1 00 50 80 00       	mov    0x805000,%eax
  800977:	85 c0                	test   %eax,%eax
  800979:	0f 84 01 01 00 00    	je     800a80 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80097f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800985:	bb 4c 38 80 00       	mov    $0x80384c,%ebx
  80098a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80098f:	89 c7                	mov    %eax,%edi
  800991:	89 de                	mov    %ebx,%esi
  800993:	89 d1                	mov    %edx,%ecx
  800995:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800997:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80099a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80099f:	b0 00                	mov    $0x0,%al
  8009a1:	89 d7                	mov    %edx,%edi
  8009a3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8009a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8009ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	50                   	push   %eax
  8009b3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	e8 83 1b 00 00       	call   802542 <sys_utilities>
  8009bf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8009c2:	e8 cc 16 00 00       	call   802093 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8009c7:	83 ec 0c             	sub    $0xc,%esp
  8009ca:	68 6c 37 80 00       	push   $0x80376c
  8009cf:	e8 ac 03 00 00       	call   800d80 <cprintf>
  8009d4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8009d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009da:	85 c0                	test   %eax,%eax
  8009dc:	74 18                	je     8009f6 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8009de:	e8 7d 1b 00 00       	call   802560 <sys_get_optimal_num_faults>
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	50                   	push   %eax
  8009e7:	68 94 37 80 00       	push   $0x803794
  8009ec:	e8 8f 03 00 00       	call   800d80 <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	eb 59                	jmp    800a4f <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8009fb:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800a01:	a1 20 50 80 00       	mov    0x805020,%eax
  800a06:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	52                   	push   %edx
  800a10:	50                   	push   %eax
  800a11:	68 b8 37 80 00       	push   $0x8037b8
  800a16:	e8 65 03 00 00       	call   800d80 <cprintf>
  800a1b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800a23:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800a34:	a1 20 50 80 00       	mov    0x805020,%eax
  800a39:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800a3f:	51                   	push   %ecx
  800a40:	52                   	push   %edx
  800a41:	50                   	push   %eax
  800a42:	68 e0 37 80 00       	push   $0x8037e0
  800a47:	e8 34 03 00 00       	call   800d80 <cprintf>
  800a4c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	50                   	push   %eax
  800a5e:	68 38 38 80 00       	push   $0x803838
  800a63:	e8 18 03 00 00       	call   800d80 <cprintf>
  800a68:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800a6b:	83 ec 0c             	sub    $0xc,%esp
  800a6e:	68 6c 37 80 00       	push   $0x80376c
  800a73:	e8 08 03 00 00       	call   800d80 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800a7b:	e8 2d 16 00 00       	call   8020ad <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800a80:	e8 1f 00 00 00       	call   800aa4 <exit>
}
  800a85:	90                   	nop
  800a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a89:	5b                   	pop    %ebx
  800a8a:	5e                   	pop    %esi
  800a8b:	5f                   	pop    %edi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a94:	83 ec 0c             	sub    $0xc,%esp
  800a97:	6a 00                	push   $0x0
  800a99:	e8 3a 18 00 00       	call   8022d8 <sys_destroy_env>
  800a9e:	83 c4 10             	add    $0x10,%esp
}
  800aa1:	90                   	nop
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <exit>:

void
exit(void)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aaa:	e8 8f 18 00 00       	call   80233e <sys_exit_env>
}
  800aaf:	90                   	nop
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac1:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800ac6:	85 c0                	test   %eax,%eax
  800ac8:	74 16                	je     800ae0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800aca:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	50                   	push   %eax
  800ad3:	68 b0 38 80 00       	push   $0x8038b0
  800ad8:	e8 a3 02 00 00       	call   800d80 <cprintf>
  800add:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800ae0:	a1 04 50 80 00       	mov    0x805004,%eax
  800ae5:	83 ec 0c             	sub    $0xc,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 b8 38 80 00       	push   $0x8038b8
  800af4:	6a 74                	push   $0x74
  800af6:	e8 b2 02 00 00       	call   800dad <cprintf_colored>
  800afb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	50                   	push   %eax
  800b08:	e8 04 02 00 00       	call   800d11 <vcprintf>
  800b0d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	6a 00                	push   $0x0
  800b15:	68 e0 38 80 00       	push   $0x8038e0
  800b1a:	e8 f2 01 00 00       	call   800d11 <vcprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b22:	e8 7d ff ff ff       	call   800aa4 <exit>

	// should not return here
	while (1) ;
  800b27:	eb fe                	jmp    800b27 <_panic+0x75>

00800b29 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b34:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 14                	je     800b55 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 e4 38 80 00       	push   $0x8038e4
  800b49:	6a 26                	push   $0x26
  800b4b:	68 30 39 80 00       	push   $0x803930
  800b50:	e8 5d ff ff ff       	call   800ab2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b63:	e9 c5 00 00 00       	jmp    800c2d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	85 c0                	test   %eax,%eax
  800b7b:	75 08                	jne    800b85 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b7d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b80:	e9 a5 00 00 00       	jmp    800c2a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b85:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b93:	eb 69                	jmp    800bfe <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b95:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800ba0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ba3:	89 d0                	mov    %edx,%eax
  800ba5:	01 c0                	add    %eax,%eax
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	c1 e0 03             	shl    $0x3,%eax
  800bac:	01 c8                	add    %ecx,%eax
  800bae:	8a 40 04             	mov    0x4(%eax),%al
  800bb1:	84 c0                	test   %al,%al
  800bb3:	75 46                	jne    800bfb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb5:	a1 20 50 80 00       	mov    0x805020,%eax
  800bba:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800bc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc3:	89 d0                	mov    %edx,%eax
  800bc5:	01 c0                	add    %eax,%eax
  800bc7:	01 d0                	add    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 c8                	add    %ecx,%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bdb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	01 c8                	add    %ecx,%eax
  800bec:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bee:	39 c2                	cmp    %eax,%edx
  800bf0:	75 09                	jne    800bfb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800bf2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf9:	eb 15                	jmp    800c10 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bfb:	ff 45 e8             	incl   -0x18(%ebp)
  800bfe:	a1 20 50 80 00       	mov    0x805020,%eax
  800c03:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c0c:	39 c2                	cmp    %eax,%edx
  800c0e:	77 85                	ja     800b95 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c14:	75 14                	jne    800c2a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800c16:	83 ec 04             	sub    $0x4,%esp
  800c19:	68 3c 39 80 00       	push   $0x80393c
  800c1e:	6a 3a                	push   $0x3a
  800c20:	68 30 39 80 00       	push   $0x803930
  800c25:	e8 88 fe ff ff       	call   800ab2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c2a:	ff 45 f0             	incl   -0x10(%ebp)
  800c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c30:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c33:	0f 8c 2f ff ff ff    	jl     800b68 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c39:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c47:	eb 26                	jmp    800c6f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c49:	a1 20 50 80 00       	mov    0x805020,%eax
  800c4e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800c54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c57:	89 d0                	mov    %edx,%eax
  800c59:	01 c0                	add    %eax,%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	c1 e0 03             	shl    $0x3,%eax
  800c60:	01 c8                	add    %ecx,%eax
  800c62:	8a 40 04             	mov    0x4(%eax),%al
  800c65:	3c 01                	cmp    $0x1,%al
  800c67:	75 03                	jne    800c6c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c69:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c6c:	ff 45 e0             	incl   -0x20(%ebp)
  800c6f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c74:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c7d:	39 c2                	cmp    %eax,%edx
  800c7f:	77 c8                	ja     800c49 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c84:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c87:	74 14                	je     800c9d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 90 39 80 00       	push   $0x803990
  800c91:	6a 44                	push   $0x44
  800c93:	68 30 39 80 00       	push   $0x803930
  800c98:	e8 15 fe ff ff       	call   800ab2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c9d:	90                   	nop
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	8d 48 01             	lea    0x1(%eax),%ecx
  800caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb2:	89 0a                	mov    %ecx,(%edx)
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	88 d1                	mov    %dl,%cl
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cca:	75 30                	jne    800cfc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800ccc:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800cd2:	a0 44 50 80 00       	mov    0x805044,%al
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	8b 09                	mov    (%ecx),%ecx
  800cdf:	89 cb                	mov    %ecx,%ebx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	83 c1 08             	add    $0x8,%ecx
  800ce7:	52                   	push   %edx
  800ce8:	50                   	push   %eax
  800ce9:	53                   	push   %ebx
  800cea:	51                   	push   %ecx
  800ceb:	e8 5f 13 00 00       	call   80204f <sys_cputs>
  800cf0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8b 40 04             	mov    0x4(%eax),%eax
  800d02:	8d 50 01             	lea    0x1(%eax),%edx
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d0b:	90                   	nop
  800d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d1a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d21:	00 00 00 
	b.cnt = 0;
  800d24:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d2b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	ff 75 08             	pushl  0x8(%ebp)
  800d34:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d3a:	50                   	push   %eax
  800d3b:	68 a0 0c 80 00       	push   $0x800ca0
  800d40:	e8 5a 02 00 00       	call   800f9f <vprintfmt>
  800d45:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800d48:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800d4e:	a0 44 50 80 00       	mov    0x805044,%al
  800d53:	0f b6 c0             	movzbl %al,%eax
  800d56:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800d5c:	52                   	push   %edx
  800d5d:	50                   	push   %eax
  800d5e:	51                   	push   %ecx
  800d5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d65:	83 c0 08             	add    $0x8,%eax
  800d68:	50                   	push   %eax
  800d69:	e8 e1 12 00 00       	call   80204f <sys_cputs>
  800d6e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d71:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800d78:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d86:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800d8d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9c:	50                   	push   %eax
  800d9d:	e8 6f ff ff ff       	call   800d11 <vcprintf>
  800da2:	83 c4 10             	add    $0x10,%esp
  800da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800db3:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	c1 e0 08             	shl    $0x8,%eax
  800dc0:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800dc5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800dc8:	83 c0 04             	add    $0x4,%eax
  800dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd7:	50                   	push   %eax
  800dd8:	e8 34 ff ff ff       	call   800d11 <vcprintf>
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800de3:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800dea:	07 00 00 

	return cnt;
  800ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800df8:	e8 96 12 00 00       	call   802093 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800dfd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0c:	50                   	push   %eax
  800e0d:	e8 ff fe ff ff       	call   800d11 <vcprintf>
  800e12:	83 c4 10             	add    $0x10,%esp
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800e18:	e8 90 12 00 00       	call   8020ad <sys_unlock_cons>
	return cnt;
  800e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	53                   	push   %ebx
  800e26:	83 ec 14             	sub    $0x14,%esp
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e35:	8b 45 18             	mov    0x18(%ebp),%eax
  800e38:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e40:	77 55                	ja     800e97 <printnum+0x75>
  800e42:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e45:	72 05                	jb     800e4c <printnum+0x2a>
  800e47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e4a:	77 4b                	ja     800e97 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e4c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e4f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e52:	8b 45 18             	mov    0x18(%ebp),%eax
  800e55:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5a:	52                   	push   %edx
  800e5b:	50                   	push   %eax
  800e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e62:	e8 e9 23 00 00       	call   803250 <__udivdi3>
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	83 ec 04             	sub    $0x4,%esp
  800e6d:	ff 75 20             	pushl  0x20(%ebp)
  800e70:	53                   	push   %ebx
  800e71:	ff 75 18             	pushl  0x18(%ebp)
  800e74:	52                   	push   %edx
  800e75:	50                   	push   %eax
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	ff 75 08             	pushl  0x8(%ebp)
  800e7c:	e8 a1 ff ff ff       	call   800e22 <printnum>
  800e81:	83 c4 20             	add    $0x20,%esp
  800e84:	eb 1a                	jmp    800ea0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	ff 75 20             	pushl  0x20(%ebp)
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e97:	ff 4d 1c             	decl   0x1c(%ebp)
  800e9a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e9e:	7f e6                	jg     800e86 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ea0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eae:	53                   	push   %ebx
  800eaf:	51                   	push   %ecx
  800eb0:	52                   	push   %edx
  800eb1:	50                   	push   %eax
  800eb2:	e8 a9 24 00 00       	call   803360 <__umoddi3>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	05 f4 3b 80 00       	add    $0x803bf4,%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f be c0             	movsbl %al,%eax
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	50                   	push   %eax
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	ff d0                	call   *%eax
  800ed0:	83 c4 10             	add    $0x10,%esp
}
  800ed3:	90                   	nop
  800ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800edc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ee0:	7e 1c                	jle    800efe <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8b 00                	mov    (%eax),%eax
  800ee7:	8d 50 08             	lea    0x8(%eax),%edx
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 10                	mov    %edx,(%eax)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	83 e8 08             	sub    $0x8,%eax
  800ef7:	8b 50 04             	mov    0x4(%eax),%edx
  800efa:	8b 00                	mov    (%eax),%eax
  800efc:	eb 40                	jmp    800f3e <getuint+0x65>
	else if (lflag)
  800efe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f02:	74 1e                	je     800f22 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	8d 50 04             	lea    0x4(%eax),%edx
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 10                	mov    %edx,(%eax)
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8b 00                	mov    (%eax),%eax
  800f16:	83 e8 04             	sub    $0x4,%eax
  800f19:	8b 00                	mov    (%eax),%eax
  800f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f20:	eb 1c                	jmp    800f3e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8b 00                	mov    (%eax),%eax
  800f27:	8d 50 04             	lea    0x4(%eax),%edx
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	89 10                	mov    %edx,(%eax)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8b 00                	mov    (%eax),%eax
  800f34:	83 e8 04             	sub    $0x4,%eax
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f43:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f47:	7e 1c                	jle    800f65 <getint+0x25>
		return va_arg(*ap, long long);
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8b 00                	mov    (%eax),%eax
  800f4e:	8d 50 08             	lea    0x8(%eax),%edx
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	89 10                	mov    %edx,(%eax)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	83 e8 08             	sub    $0x8,%eax
  800f5e:	8b 50 04             	mov    0x4(%eax),%edx
  800f61:	8b 00                	mov    (%eax),%eax
  800f63:	eb 38                	jmp    800f9d <getint+0x5d>
	else if (lflag)
  800f65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f69:	74 1a                	je     800f85 <getint+0x45>
		return va_arg(*ap, long);
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8b 00                	mov    (%eax),%eax
  800f70:	8d 50 04             	lea    0x4(%eax),%edx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 10                	mov    %edx,(%eax)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	83 e8 04             	sub    $0x4,%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	99                   	cltd   
  800f83:	eb 18                	jmp    800f9d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8b 00                	mov    (%eax),%eax
  800f8a:	8d 50 04             	lea    0x4(%eax),%edx
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	89 10                	mov    %edx,(%eax)
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8b 00                	mov    (%eax),%eax
  800f97:	83 e8 04             	sub    $0x4,%eax
  800f9a:	8b 00                	mov    (%eax),%eax
  800f9c:	99                   	cltd   
}
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fa7:	eb 17                	jmp    800fc0 <vprintfmt+0x21>
			if (ch == '\0')
  800fa9:	85 db                	test   %ebx,%ebx
  800fab:	0f 84 c1 03 00 00    	je     801372 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 d8             	movzbl %al,%ebx
  800fce:	83 fb 25             	cmp    $0x25,%ebx
  800fd1:	75 d6                	jne    800fa9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800fd3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800fd7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fde:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fe5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f b6 d8             	movzbl %al,%ebx
  801001:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801004:	83 f8 5b             	cmp    $0x5b,%eax
  801007:	0f 87 3d 03 00 00    	ja     80134a <vprintfmt+0x3ab>
  80100d:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
  801014:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801016:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80101a:	eb d7                	jmp    800ff3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80101c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801020:	eb d1                	jmp    800ff3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801022:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801029:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80102c:	89 d0                	mov    %edx,%eax
  80102e:	c1 e0 02             	shl    $0x2,%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	01 c0                	add    %eax,%eax
  801035:	01 d8                	add    %ebx,%eax
  801037:	83 e8 30             	sub    $0x30,%eax
  80103a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801045:	83 fb 2f             	cmp    $0x2f,%ebx
  801048:	7e 3e                	jle    801088 <vprintfmt+0xe9>
  80104a:	83 fb 39             	cmp    $0x39,%ebx
  80104d:	7f 39                	jg     801088 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80104f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801052:	eb d5                	jmp    801029 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 c0 04             	add    $0x4,%eax
  80105a:	89 45 14             	mov    %eax,0x14(%ebp)
  80105d:	8b 45 14             	mov    0x14(%ebp),%eax
  801060:	83 e8 04             	sub    $0x4,%eax
  801063:	8b 00                	mov    (%eax),%eax
  801065:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801068:	eb 1f                	jmp    801089 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80106a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106e:	79 83                	jns    800ff3 <vprintfmt+0x54>
				width = 0;
  801070:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801077:	e9 77 ff ff ff       	jmp    800ff3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80107c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801083:	e9 6b ff ff ff       	jmp    800ff3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801088:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801089:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108d:	0f 89 60 ff ff ff    	jns    800ff3 <vprintfmt+0x54>
				width = precision, precision = -1;
  801093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801099:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8010a0:	e9 4e ff ff ff       	jmp    800ff3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010a5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8010a8:	e9 46 ff ff ff       	jmp    800ff3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8010ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b0:	83 c0 04             	add    $0x4,%eax
  8010b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b9:	83 e8 04             	sub    $0x4,%eax
  8010bc:	8b 00                	mov    (%eax),%eax
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	50                   	push   %eax
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
			break;
  8010cd:	e9 9b 02 00 00       	jmp    80136d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d5:	83 c0 04             	add    $0x4,%eax
  8010d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8010db:	8b 45 14             	mov    0x14(%ebp),%eax
  8010de:	83 e8 04             	sub    $0x4,%eax
  8010e1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010e3:	85 db                	test   %ebx,%ebx
  8010e5:	79 02                	jns    8010e9 <vprintfmt+0x14a>
				err = -err;
  8010e7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010e9:	83 fb 64             	cmp    $0x64,%ebx
  8010ec:	7f 0b                	jg     8010f9 <vprintfmt+0x15a>
  8010ee:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  8010f5:	85 f6                	test   %esi,%esi
  8010f7:	75 19                	jne    801112 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010f9:	53                   	push   %ebx
  8010fa:	68 05 3c 80 00       	push   $0x803c05
  8010ff:	ff 75 0c             	pushl  0xc(%ebp)
  801102:	ff 75 08             	pushl  0x8(%ebp)
  801105:	e8 70 02 00 00       	call   80137a <printfmt>
  80110a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80110d:	e9 5b 02 00 00       	jmp    80136d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801112:	56                   	push   %esi
  801113:	68 0e 3c 80 00       	push   $0x803c0e
  801118:	ff 75 0c             	pushl  0xc(%ebp)
  80111b:	ff 75 08             	pushl  0x8(%ebp)
  80111e:	e8 57 02 00 00       	call   80137a <printfmt>
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	e9 42 02 00 00       	jmp    80136d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	83 c0 04             	add    $0x4,%eax
  801131:	89 45 14             	mov    %eax,0x14(%ebp)
  801134:	8b 45 14             	mov    0x14(%ebp),%eax
  801137:	83 e8 04             	sub    $0x4,%eax
  80113a:	8b 30                	mov    (%eax),%esi
  80113c:	85 f6                	test   %esi,%esi
  80113e:	75 05                	jne    801145 <vprintfmt+0x1a6>
				p = "(null)";
  801140:	be 11 3c 80 00       	mov    $0x803c11,%esi
			if (width > 0 && padc != '-')
  801145:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801149:	7e 6d                	jle    8011b8 <vprintfmt+0x219>
  80114b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80114f:	74 67                	je     8011b8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801154:	83 ec 08             	sub    $0x8,%esp
  801157:	50                   	push   %eax
  801158:	56                   	push   %esi
  801159:	e8 26 05 00 00       	call   801684 <strnlen>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801164:	eb 16                	jmp    80117c <vprintfmt+0x1dd>
					putch(padc, putdat);
  801166:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	50                   	push   %eax
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801179:	ff 4d e4             	decl   -0x1c(%ebp)
  80117c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801180:	7f e4                	jg     801166 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801182:	eb 34                	jmp    8011b8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801184:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801188:	74 1c                	je     8011a6 <vprintfmt+0x207>
  80118a:	83 fb 1f             	cmp    $0x1f,%ebx
  80118d:	7e 05                	jle    801194 <vprintfmt+0x1f5>
  80118f:	83 fb 7e             	cmp    $0x7e,%ebx
  801192:	7e 12                	jle    8011a6 <vprintfmt+0x207>
					putch('?', putdat);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	ff 75 0c             	pushl  0xc(%ebp)
  80119a:	6a 3f                	push   $0x3f
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	ff d0                	call   *%eax
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	eb 0f                	jmp    8011b5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	53                   	push   %ebx
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8011b8:	89 f0                	mov    %esi,%eax
  8011ba:	8d 70 01             	lea    0x1(%eax),%esi
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	0f be d8             	movsbl %al,%ebx
  8011c2:	85 db                	test   %ebx,%ebx
  8011c4:	74 24                	je     8011ea <vprintfmt+0x24b>
  8011c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011ca:	78 b8                	js     801184 <vprintfmt+0x1e5>
  8011cc:	ff 4d e0             	decl   -0x20(%ebp)
  8011cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011d3:	79 af                	jns    801184 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011d5:	eb 13                	jmp    8011ea <vprintfmt+0x24b>
				putch(' ', putdat);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	6a 20                	push   $0x20
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	ff d0                	call   *%eax
  8011e4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8011ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ee:	7f e7                	jg     8011d7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011f0:	e9 78 01 00 00       	jmp    80136d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011f5:	83 ec 08             	sub    $0x8,%esp
  8011f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8011fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	e8 3c fd ff ff       	call   800f40 <getint>
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80120d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801210:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801213:	85 d2                	test   %edx,%edx
  801215:	79 23                	jns    80123a <vprintfmt+0x29b>
				putch('-', putdat);
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	6a 2d                	push   $0x2d
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	ff d0                	call   *%eax
  801224:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	f7 d8                	neg    %eax
  80122f:	83 d2 00             	adc    $0x0,%edx
  801232:	f7 da                	neg    %edx
  801234:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801237:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80123a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801241:	e9 bc 00 00 00       	jmp    801302 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801246:	83 ec 08             	sub    $0x8,%esp
  801249:	ff 75 e8             	pushl  -0x18(%ebp)
  80124c:	8d 45 14             	lea    0x14(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	e8 84 fc ff ff       	call   800ed9 <getuint>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80125e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801265:	e9 98 00 00 00       	jmp    801302 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	6a 58                	push   $0x58
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	ff d0                	call   *%eax
  801277:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	ff 75 0c             	pushl  0xc(%ebp)
  801280:	6a 58                	push   $0x58
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	ff d0                	call   *%eax
  801287:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	6a 58                	push   $0x58
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	ff d0                	call   *%eax
  801297:	83 c4 10             	add    $0x10,%esp
			break;
  80129a:	e9 ce 00 00 00       	jmp    80136d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	6a 30                	push   $0x30
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	ff d0                	call   *%eax
  8012ac:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	ff 75 0c             	pushl  0xc(%ebp)
  8012b5:	6a 78                	push   $0x78
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	ff d0                	call   *%eax
  8012bc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	83 c0 04             	add    $0x4,%eax
  8012c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8012c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cb:	83 e8 04             	sub    $0x4,%eax
  8012ce:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012da:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012e1:	eb 1f                	jmp    801302 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8012e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8012ec:	50                   	push   %eax
  8012ed:	e8 e7 fb ff ff       	call   800ed9 <getuint>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801302:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	52                   	push   %edx
  80130d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801310:	50                   	push   %eax
  801311:	ff 75 f4             	pushl  -0xc(%ebp)
  801314:	ff 75 f0             	pushl  -0x10(%ebp)
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	e8 00 fb ff ff       	call   800e22 <printnum>
  801322:	83 c4 20             	add    $0x20,%esp
			break;
  801325:	eb 46                	jmp    80136d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	53                   	push   %ebx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	ff d0                	call   *%eax
  801333:	83 c4 10             	add    $0x10,%esp
			break;
  801336:	eb 35                	jmp    80136d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801338:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  80133f:	eb 2c                	jmp    80136d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801341:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801348:	eb 23                	jmp    80136d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 25                	push   $0x25
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80135a:	ff 4d 10             	decl   0x10(%ebp)
  80135d:	eb 03                	jmp    801362 <vprintfmt+0x3c3>
  80135f:	ff 4d 10             	decl   0x10(%ebp)
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	48                   	dec    %eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	3c 25                	cmp    $0x25,%al
  80136a:	75 f3                	jne    80135f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80136c:	90                   	nop
		}
	}
  80136d:	e9 35 fc ff ff       	jmp    800fa7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801372:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801373:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801376:	5b                   	pop    %ebx
  801377:	5e                   	pop    %esi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801380:	8d 45 10             	lea    0x10(%ebp),%eax
  801383:	83 c0 04             	add    $0x4,%eax
  801386:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	ff 75 f4             	pushl  -0xc(%ebp)
  80138f:	50                   	push   %eax
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	ff 75 08             	pushl  0x8(%ebp)
  801396:	e8 04 fc ff ff       	call   800f9f <vprintfmt>
  80139b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80139e:	90                   	nop
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	8b 40 08             	mov    0x8(%eax),%eax
  8013aa:	8d 50 01             	lea    0x1(%eax),%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	8b 10                	mov    (%eax),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	8b 40 04             	mov    0x4(%eax),%eax
  8013be:	39 c2                	cmp    %eax,%edx
  8013c0:	73 12                	jae    8013d4 <sprintputch+0x33>
		*b->buf++ = ch;
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	89 0a                	mov    %ecx,(%edx)
  8013cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d2:	88 10                	mov    %dl,(%eax)
}
  8013d4:	90                   	nop
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013fc:	74 06                	je     801404 <vsnprintf+0x2d>
  8013fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801402:	7f 07                	jg     80140b <vsnprintf+0x34>
		return -E_INVAL;
  801404:	b8 03 00 00 00       	mov    $0x3,%eax
  801409:	eb 20                	jmp    80142b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80140b:	ff 75 14             	pushl  0x14(%ebp)
  80140e:	ff 75 10             	pushl  0x10(%ebp)
  801411:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801414:	50                   	push   %eax
  801415:	68 a1 13 80 00       	push   $0x8013a1
  80141a:	e8 80 fb ff ff       	call   800f9f <vprintfmt>
  80141f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801425:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801433:	8d 45 10             	lea    0x10(%ebp),%eax
  801436:	83 c0 04             	add    $0x4,%eax
  801439:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	ff 75 f4             	pushl  -0xc(%ebp)
  801442:	50                   	push   %eax
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	ff 75 08             	pushl  0x8(%ebp)
  801449:	e8 89 ff ff ff       	call   8013d7 <vsnprintf>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80145f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801463:	74 13                	je     801478 <readline+0x1f>
		cprintf("%s", prompt);
  801465:	83 ec 08             	sub    $0x8,%esp
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	68 88 3d 80 00       	push   $0x803d88
  801470:	e8 0b f9 ff ff       	call   800d80 <cprintf>
  801475:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	6a 00                	push   $0x0
  801484:	e8 5a f4 ff ff       	call   8008e3 <iscons>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80148f:	e8 3c f4 ff ff       	call   8008d0 <getchar>
  801494:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80149b:	79 22                	jns    8014bf <readline+0x66>
			if (c != -E_EOF)
  80149d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014a1:	0f 84 ad 00 00 00    	je     801554 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ad:	68 8b 3d 80 00       	push   $0x803d8b
  8014b2:	e8 c9 f8 ff ff       	call   800d80 <cprintf>
  8014b7:	83 c4 10             	add    $0x10,%esp
			break;
  8014ba:	e9 95 00 00 00       	jmp    801554 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8014bf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014c3:	7e 34                	jle    8014f9 <readline+0xa0>
  8014c5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014cc:	7f 2b                	jg     8014f9 <readline+0xa0>
			if (echoing)
  8014ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014d2:	74 0e                	je     8014e2 <readline+0x89>
				cputchar(c);
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014da:	e8 d2 f3 ff ff       	call   8008b1 <cputchar>
  8014df:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e5:	8d 50 01             	lea    0x1(%eax),%edx
  8014e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014eb:	89 c2                	mov    %eax,%edx
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f5:	88 10                	mov    %dl,(%eax)
  8014f7:	eb 56                	jmp    80154f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8014f9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8014fd:	75 1f                	jne    80151e <readline+0xc5>
  8014ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801503:	7e 19                	jle    80151e <readline+0xc5>
			if (echoing)
  801505:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801509:	74 0e                	je     801519 <readline+0xc0>
				cputchar(c);
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	ff 75 ec             	pushl  -0x14(%ebp)
  801511:	e8 9b f3 ff ff       	call   8008b1 <cputchar>
  801516:	83 c4 10             	add    $0x10,%esp

			i--;
  801519:	ff 4d f4             	decl   -0xc(%ebp)
  80151c:	eb 31                	jmp    80154f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80151e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801522:	74 0a                	je     80152e <readline+0xd5>
  801524:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801528:	0f 85 61 ff ff ff    	jne    80148f <readline+0x36>
			if (echoing)
  80152e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801532:	74 0e                	je     801542 <readline+0xe9>
				cputchar(c);
  801534:	83 ec 0c             	sub    $0xc,%esp
  801537:	ff 75 ec             	pushl  -0x14(%ebp)
  80153a:	e8 72 f3 ff ff       	call   8008b1 <cputchar>
  80153f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80154d:	eb 06                	jmp    801555 <readline+0xfc>
		}
	}
  80154f:	e9 3b ff ff ff       	jmp    80148f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801554:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801555:	90                   	nop
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80155e:	e8 30 0b 00 00       	call   802093 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801563:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801567:	74 13                	je     80157c <atomic_readline+0x24>
			cprintf("%s", prompt);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	ff 75 08             	pushl  0x8(%ebp)
  80156f:	68 88 3d 80 00       	push   $0x803d88
  801574:	e8 07 f8 ff ff       	call   800d80 <cprintf>
  801579:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80157c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	6a 00                	push   $0x0
  801588:	e8 56 f3 ff ff       	call   8008e3 <iscons>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801593:	e8 38 f3 ff ff       	call   8008d0 <getchar>
  801598:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80159b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80159f:	79 22                	jns    8015c3 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8015a1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8015a5:	0f 84 ad 00 00 00    	je     801658 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b1:	68 8b 3d 80 00       	push   $0x803d8b
  8015b6:	e8 c5 f7 ff ff       	call   800d80 <cprintf>
  8015bb:	83 c4 10             	add    $0x10,%esp
				break;
  8015be:	e9 95 00 00 00       	jmp    801658 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8015c3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8015c7:	7e 34                	jle    8015fd <atomic_readline+0xa5>
  8015c9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8015d0:	7f 2b                	jg     8015fd <atomic_readline+0xa5>
				if (echoing)
  8015d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d6:	74 0e                	je     8015e6 <atomic_readline+0x8e>
					cputchar(c);
  8015d8:	83 ec 0c             	sub    $0xc,%esp
  8015db:	ff 75 ec             	pushl  -0x14(%ebp)
  8015de:	e8 ce f2 ff ff       	call   8008b1 <cputchar>
  8015e3:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8015e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e9:	8d 50 01             	lea    0x1(%eax),%edx
  8015ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
  8015fb:	eb 56                	jmp    801653 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8015fd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801601:	75 1f                	jne    801622 <atomic_readline+0xca>
  801603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801607:	7e 19                	jle    801622 <atomic_readline+0xca>
				if (echoing)
  801609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80160d:	74 0e                	je     80161d <atomic_readline+0xc5>
					cputchar(c);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 ec             	pushl  -0x14(%ebp)
  801615:	e8 97 f2 ff ff       	call   8008b1 <cputchar>
  80161a:	83 c4 10             	add    $0x10,%esp
				i--;
  80161d:	ff 4d f4             	decl   -0xc(%ebp)
  801620:	eb 31                	jmp    801653 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801622:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801626:	74 0a                	je     801632 <atomic_readline+0xda>
  801628:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80162c:	0f 85 61 ff ff ff    	jne    801593 <atomic_readline+0x3b>
				if (echoing)
  801632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801636:	74 0e                	je     801646 <atomic_readline+0xee>
					cputchar(c);
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	ff 75 ec             	pushl  -0x14(%ebp)
  80163e:	e8 6e f2 ff ff       	call   8008b1 <cputchar>
  801643:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801651:	eb 06                	jmp    801659 <atomic_readline+0x101>
			}
		}
  801653:	e9 3b ff ff ff       	jmp    801593 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801658:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801659:	e8 4f 0a 00 00       	call   8020ad <sys_unlock_cons>
}
  80165e:	90                   	nop
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166e:	eb 06                	jmp    801676 <strlen+0x15>
		n++;
  801670:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801673:	ff 45 08             	incl   0x8(%ebp)
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	84 c0                	test   %al,%al
  80167d:	75 f1                	jne    801670 <strlen+0xf>
		n++;
	return n;
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80168a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801691:	eb 09                	jmp    80169c <strnlen+0x18>
		n++;
  801693:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	ff 4d 0c             	decl   0xc(%ebp)
  80169c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a0:	74 09                	je     8016ab <strnlen+0x27>
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	84 c0                	test   %al,%al
  8016a9:	75 e8                	jne    801693 <strnlen+0xf>
		n++;
	return n;
  8016ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016bc:	90                   	nop
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8d 50 01             	lea    0x1(%eax),%edx
  8016c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cf:	8a 12                	mov    (%edx),%dl
  8016d1:	88 10                	mov    %dl,(%eax)
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	84 c0                	test   %al,%al
  8016d7:	75 e4                	jne    8016bd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016f1:	eb 1f                	jmp    801712 <strncpy+0x34>
		*dst++ = *src;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8d 50 01             	lea    0x1(%eax),%edx
  8016f9:	89 55 08             	mov    %edx,0x8(%ebp)
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8a 12                	mov    (%edx),%dl
  801701:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	84 c0                	test   %al,%al
  80170a:	74 03                	je     80170f <strncpy+0x31>
			src++;
  80170c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170f:	ff 45 fc             	incl   -0x4(%ebp)
  801712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801715:	3b 45 10             	cmp    0x10(%ebp),%eax
  801718:	72 d9                	jb     8016f3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80172b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172f:	74 30                	je     801761 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801731:	eb 16                	jmp    801749 <strlcpy+0x2a>
			*dst++ = *src++;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8d 50 01             	lea    0x1(%eax),%edx
  801739:	89 55 08             	mov    %edx,0x8(%ebp)
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801742:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801745:	8a 12                	mov    (%edx),%dl
  801747:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801749:	ff 4d 10             	decl   0x10(%ebp)
  80174c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801750:	74 09                	je     80175b <strlcpy+0x3c>
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	75 d8                	jne    801733 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801761:	8b 55 08             	mov    0x8(%ebp),%edx
  801764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801767:	29 c2                	sub    %eax,%edx
  801769:	89 d0                	mov    %edx,%eax
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801770:	eb 06                	jmp    801778 <strcmp+0xb>
		p++, q++;
  801772:	ff 45 08             	incl   0x8(%ebp)
  801775:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 0e                	je     80178f <strcmp+0x22>
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8a 10                	mov    (%eax),%dl
  801786:	8b 45 0c             	mov    0xc(%ebp),%eax
  801789:	8a 00                	mov    (%eax),%al
  80178b:	38 c2                	cmp    %al,%dl
  80178d:	74 e3                	je     801772 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8a 00                	mov    (%eax),%al
  801794:	0f b6 d0             	movzbl %al,%edx
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	0f b6 c0             	movzbl %al,%eax
  80179f:	29 c2                	sub    %eax,%edx
  8017a1:	89 d0                	mov    %edx,%eax
}
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a8:	eb 09                	jmp    8017b3 <strncmp+0xe>
		n--, p++, q++;
  8017aa:	ff 4d 10             	decl   0x10(%ebp)
  8017ad:	ff 45 08             	incl   0x8(%ebp)
  8017b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b7:	74 17                	je     8017d0 <strncmp+0x2b>
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	84 c0                	test   %al,%al
  8017c0:	74 0e                	je     8017d0 <strncmp+0x2b>
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8a 10                	mov    (%eax),%dl
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	38 c2                	cmp    %al,%dl
  8017ce:	74 da                	je     8017aa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d4:	75 07                	jne    8017dd <strncmp+0x38>
		return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017db:	eb 14                	jmp    8017f1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	0f b6 d0             	movzbl %al,%edx
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	0f b6 c0             	movzbl %al,%eax
  8017ed:	29 c2                	sub    %eax,%edx
  8017ef:	89 d0                	mov    %edx,%eax
}
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ff:	eb 12                	jmp    801813 <strchr+0x20>
		if (*s == c)
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801809:	75 05                	jne    801810 <strchr+0x1d>
			return (char *) s;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	eb 11                	jmp    801821 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801810:	ff 45 08             	incl   0x8(%ebp)
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	84 c0                	test   %al,%al
  80181a:	75 e5                	jne    801801 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182f:	eb 0d                	jmp    80183e <strfind+0x1b>
		if (*s == c)
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8a 00                	mov    (%eax),%al
  801836:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801839:	74 0e                	je     801849 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80183b:	ff 45 08             	incl   0x8(%ebp)
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	84 c0                	test   %al,%al
  801845:	75 ea                	jne    801831 <strfind+0xe>
  801847:	eb 01                	jmp    80184a <strfind+0x27>
		if (*s == c)
			break;
  801849:	90                   	nop
	return (char *) s;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80185b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80185f:	76 63                	jbe    8018c4 <memset+0x75>
		uint64 data_block = c;
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	99                   	cltd   
  801865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801868:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801871:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801875:	c1 e0 08             	shl    $0x8,%eax
  801878:	09 45 f0             	or     %eax,-0x10(%ebp)
  80187b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801888:	c1 e0 10             	shl    $0x10,%eax
  80188b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80188e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801897:	89 c2                	mov    %eax,%edx
  801899:	b8 00 00 00 00       	mov    $0x0,%eax
  80189e:	09 45 f0             	or     %eax,-0x10(%ebp)
  8018a1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8018a4:	eb 18                	jmp    8018be <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8018a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a9:	8d 41 08             	lea    0x8(%ecx),%eax
  8018ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b5:	89 01                	mov    %eax,(%ecx)
  8018b7:	89 51 04             	mov    %edx,0x4(%ecx)
  8018ba:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8018be:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8018c2:	77 e2                	ja     8018a6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8018c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c8:	74 23                	je     8018ed <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018d0:	eb 0e                	jmp    8018e0 <memset+0x91>
			*p8++ = (uint8)c;
  8018d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d5:	8d 50 01             	lea    0x1(%eax),%edx
  8018d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	75 e5                	jne    8018d2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801904:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801908:	76 24                	jbe    80192e <memcpy+0x3c>
		while(n >= 8){
  80190a:	eb 1c                	jmp    801928 <memcpy+0x36>
			*d64 = *s64;
  80190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80190f:	8b 50 04             	mov    0x4(%eax),%edx
  801912:	8b 00                	mov    (%eax),%eax
  801914:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801917:	89 01                	mov    %eax,(%ecx)
  801919:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80191c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801920:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801924:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801928:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80192c:	77 de                	ja     80190c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80192e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801932:	74 31                	je     801965 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801937:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80193a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801940:	eb 16                	jmp    801958 <memcpy+0x66>
			*d8++ = *s8++;
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	8d 50 01             	lea    0x1(%eax),%edx
  801948:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80194b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801951:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801954:	8a 12                	mov    (%edx),%dl
  801956:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80195e:	89 55 10             	mov    %edx,0x10(%ebp)
  801961:	85 c0                	test   %eax,%eax
  801963:	75 dd                	jne    801942 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801982:	73 50                	jae    8019d4 <memmove+0x6a>
  801984:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	01 d0                	add    %edx,%eax
  80198c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80198f:	76 43                	jbe    8019d4 <memmove+0x6a>
		s += n;
  801991:	8b 45 10             	mov    0x10(%ebp),%eax
  801994:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801997:	8b 45 10             	mov    0x10(%ebp),%eax
  80199a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80199d:	eb 10                	jmp    8019af <memmove+0x45>
			*--d = *--s;
  80199f:	ff 4d f8             	decl   -0x8(%ebp)
  8019a2:	ff 4d fc             	decl   -0x4(%ebp)
  8019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a8:	8a 10                	mov    (%eax),%dl
  8019aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ad:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019af:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	75 e3                	jne    80199f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019bc:	eb 23                	jmp    8019e1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c1:	8d 50 01             	lea    0x1(%eax),%edx
  8019c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019cd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019d0:	8a 12                	mov    (%edx),%dl
  8019d2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019da:	89 55 10             	mov    %edx,0x10(%ebp)
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	75 dd                	jne    8019be <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8019f8:	eb 2a                	jmp    801a24 <memcmp+0x3e>
		if (*s1 != *s2)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8a 10                	mov    (%eax),%dl
  8019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	38 c2                	cmp    %al,%dl
  801a06:	74 16                	je     801a1e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	0f b6 d0             	movzbl %al,%edx
  801a10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	0f b6 c0             	movzbl %al,%eax
  801a18:	29 c2                	sub    %eax,%edx
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	eb 18                	jmp    801a36 <memcmp+0x50>
		s1++, s2++;
  801a1e:	ff 45 fc             	incl   -0x4(%ebp)
  801a21:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a24:	8b 45 10             	mov    0x10(%ebp),%eax
  801a27:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a2a:	89 55 10             	mov    %edx,0x10(%ebp)
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	75 c9                	jne    8019fa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a41:	8b 45 10             	mov    0x10(%ebp),%eax
  801a44:	01 d0                	add    %edx,%eax
  801a46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a49:	eb 15                	jmp    801a60 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	8a 00                	mov    (%eax),%al
  801a50:	0f b6 d0             	movzbl %al,%edx
  801a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a56:	0f b6 c0             	movzbl %al,%eax
  801a59:	39 c2                	cmp    %eax,%edx
  801a5b:	74 0d                	je     801a6a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a5d:	ff 45 08             	incl   0x8(%ebp)
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a66:	72 e3                	jb     801a4b <memfind+0x13>
  801a68:	eb 01                	jmp    801a6b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a6a:	90                   	nop
	return (void *) s;
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a84:	eb 03                	jmp    801a89 <strtol+0x19>
		s++;
  801a86:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 20                	cmp    $0x20,%al
  801a90:	74 f4                	je     801a86 <strtol+0x16>
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	3c 09                	cmp    $0x9,%al
  801a99:	74 eb                	je     801a86 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	8a 00                	mov    (%eax),%al
  801aa0:	3c 2b                	cmp    $0x2b,%al
  801aa2:	75 05                	jne    801aa9 <strtol+0x39>
		s++;
  801aa4:	ff 45 08             	incl   0x8(%ebp)
  801aa7:	eb 13                	jmp    801abc <strtol+0x4c>
	else if (*s == '-')
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	8a 00                	mov    (%eax),%al
  801aae:	3c 2d                	cmp    $0x2d,%al
  801ab0:	75 0a                	jne    801abc <strtol+0x4c>
		s++, neg = 1;
  801ab2:	ff 45 08             	incl   0x8(%ebp)
  801ab5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801abc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac0:	74 06                	je     801ac8 <strtol+0x58>
  801ac2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801ac6:	75 20                	jne    801ae8 <strtol+0x78>
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	8a 00                	mov    (%eax),%al
  801acd:	3c 30                	cmp    $0x30,%al
  801acf:	75 17                	jne    801ae8 <strtol+0x78>
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	40                   	inc    %eax
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	3c 78                	cmp    $0x78,%al
  801ad9:	75 0d                	jne    801ae8 <strtol+0x78>
		s += 2, base = 16;
  801adb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801adf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ae6:	eb 28                	jmp    801b10 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aec:	75 15                	jne    801b03 <strtol+0x93>
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	8a 00                	mov    (%eax),%al
  801af3:	3c 30                	cmp    $0x30,%al
  801af5:	75 0c                	jne    801b03 <strtol+0x93>
		s++, base = 8;
  801af7:	ff 45 08             	incl   0x8(%ebp)
  801afa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b01:	eb 0d                	jmp    801b10 <strtol+0xa0>
	else if (base == 0)
  801b03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b07:	75 07                	jne    801b10 <strtol+0xa0>
		base = 10;
  801b09:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	8a 00                	mov    (%eax),%al
  801b15:	3c 2f                	cmp    $0x2f,%al
  801b17:	7e 19                	jle    801b32 <strtol+0xc2>
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	8a 00                	mov    (%eax),%al
  801b1e:	3c 39                	cmp    $0x39,%al
  801b20:	7f 10                	jg     801b32 <strtol+0xc2>
			dig = *s - '0';
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	8a 00                	mov    (%eax),%al
  801b27:	0f be c0             	movsbl %al,%eax
  801b2a:	83 e8 30             	sub    $0x30,%eax
  801b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b30:	eb 42                	jmp    801b74 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 60                	cmp    $0x60,%al
  801b39:	7e 19                	jle    801b54 <strtol+0xe4>
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	3c 7a                	cmp    $0x7a,%al
  801b42:	7f 10                	jg     801b54 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	8a 00                	mov    (%eax),%al
  801b49:	0f be c0             	movsbl %al,%eax
  801b4c:	83 e8 57             	sub    $0x57,%eax
  801b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b52:	eb 20                	jmp    801b74 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 40                	cmp    $0x40,%al
  801b5b:	7e 39                	jle    801b96 <strtol+0x126>
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	3c 5a                	cmp    $0x5a,%al
  801b64:	7f 30                	jg     801b96 <strtol+0x126>
			dig = *s - 'A' + 10;
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	8a 00                	mov    (%eax),%al
  801b6b:	0f be c0             	movsbl %al,%eax
  801b6e:	83 e8 37             	sub    $0x37,%eax
  801b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b7a:	7d 19                	jge    801b95 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b7c:	ff 45 08             	incl   0x8(%ebp)
  801b7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b82:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801b90:	e9 7b ff ff ff       	jmp    801b10 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b95:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b9a:	74 08                	je     801ba4 <strtol+0x134>
		*endptr = (char *) s;
  801b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ba4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba8:	74 07                	je     801bb1 <strtol+0x141>
  801baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bad:	f7 d8                	neg    %eax
  801baf:	eb 03                	jmp    801bb4 <strtol+0x144>
  801bb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <ltostr>:

void
ltostr(long value, char *str)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bc3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bce:	79 13                	jns    801be3 <ltostr+0x2d>
	{
		neg = 1;
  801bd0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bda:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bdd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801be0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801beb:	99                   	cltd   
  801bec:	f7 f9                	idiv   %ecx
  801bee:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801bf1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bf4:	8d 50 01             	lea    0x1(%eax),%edx
  801bf7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801bfa:	89 c2                	mov    %eax,%edx
  801bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bff:	01 d0                	add    %edx,%eax
  801c01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c04:	83 c2 30             	add    $0x30,%edx
  801c07:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c0c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c11:	f7 e9                	imul   %ecx
  801c13:	c1 fa 02             	sar    $0x2,%edx
  801c16:	89 c8                	mov    %ecx,%eax
  801c18:	c1 f8 1f             	sar    $0x1f,%eax
  801c1b:	29 c2                	sub    %eax,%edx
  801c1d:	89 d0                	mov    %edx,%eax
  801c1f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801c22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c26:	75 bb                	jne    801be3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c32:	48                   	dec    %eax
  801c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c36:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c3a:	74 3d                	je     801c79 <ltostr+0xc3>
		start = 1 ;
  801c3c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c43:	eb 34                	jmp    801c79 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	01 d0                	add    %edx,%eax
  801c4d:	8a 00                	mov    (%eax),%al
  801c4f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c58:	01 c2                	add    %eax,%edx
  801c5a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c60:	01 c8                	add    %ecx,%eax
  801c62:	8a 00                	mov    (%eax),%al
  801c64:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6c:	01 c2                	add    %eax,%edx
  801c6e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801c71:	88 02                	mov    %al,(%edx)
		start++ ;
  801c73:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c76:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c7f:	7c c4                	jl     801c45 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c81:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	01 d0                	add    %edx,%eax
  801c89:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c8c:	90                   	nop
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c95:	ff 75 08             	pushl  0x8(%ebp)
  801c98:	e8 c4 f9 ff ff       	call   801661 <strlen>
  801c9d:	83 c4 04             	add    $0x4,%esp
  801ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ca3:	ff 75 0c             	pushl  0xc(%ebp)
  801ca6:	e8 b6 f9 ff ff       	call   801661 <strlen>
  801cab:	83 c4 04             	add    $0x4,%esp
  801cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cbf:	eb 17                	jmp    801cd8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc7:	01 c2                	add    %eax,%edx
  801cc9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	01 c8                	add    %ecx,%eax
  801cd1:	8a 00                	mov    (%eax),%al
  801cd3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801cd5:	ff 45 fc             	incl   -0x4(%ebp)
  801cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cdb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cde:	7c e1                	jl     801cc1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ce0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ce7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801cee:	eb 1f                	jmp    801d0f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cf3:	8d 50 01             	lea    0x1(%eax),%edx
  801cf6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801cf9:	89 c2                	mov    %eax,%edx
  801cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfe:	01 c2                	add    %eax,%edx
  801d00:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d06:	01 c8                	add    %ecx,%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d0c:	ff 45 f8             	incl   -0x8(%ebp)
  801d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d15:	7c d9                	jl     801cf0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	c6 00 00             	movb   $0x0,(%eax)
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d28:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d31:	8b 45 14             	mov    0x14(%ebp),%eax
  801d34:	8b 00                	mov    (%eax),%eax
  801d36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d48:	eb 0c                	jmp    801d56 <strsplit+0x31>
			*string++ = 0;
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	8d 50 01             	lea    0x1(%eax),%edx
  801d50:	89 55 08             	mov    %edx,0x8(%ebp)
  801d53:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	8a 00                	mov    (%eax),%al
  801d5b:	84 c0                	test   %al,%al
  801d5d:	74 18                	je     801d77 <strsplit+0x52>
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	8a 00                	mov    (%eax),%al
  801d64:	0f be c0             	movsbl %al,%eax
  801d67:	50                   	push   %eax
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	e8 83 fa ff ff       	call   8017f3 <strchr>
  801d70:	83 c4 08             	add    $0x8,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	75 d3                	jne    801d4a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	8a 00                	mov    (%eax),%al
  801d7c:	84 c0                	test   %al,%al
  801d7e:	74 5a                	je     801dda <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d80:	8b 45 14             	mov    0x14(%ebp),%eax
  801d83:	8b 00                	mov    (%eax),%eax
  801d85:	83 f8 0f             	cmp    $0xf,%eax
  801d88:	75 07                	jne    801d91 <strsplit+0x6c>
		{
			return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8f:	eb 66                	jmp    801df7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d91:	8b 45 14             	mov    0x14(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	8d 48 01             	lea    0x1(%eax),%ecx
  801d99:	8b 55 14             	mov    0x14(%ebp),%edx
  801d9c:	89 0a                	mov    %ecx,(%edx)
  801d9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	01 c2                	add    %eax,%edx
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801daf:	eb 03                	jmp    801db4 <strsplit+0x8f>
			string++;
  801db1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8a 00                	mov    (%eax),%al
  801db9:	84 c0                	test   %al,%al
  801dbb:	74 8b                	je     801d48 <strsplit+0x23>
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	0f be c0             	movsbl %al,%eax
  801dc5:	50                   	push   %eax
  801dc6:	ff 75 0c             	pushl  0xc(%ebp)
  801dc9:	e8 25 fa ff ff       	call   8017f3 <strchr>
  801dce:	83 c4 08             	add    $0x8,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	74 dc                	je     801db1 <strsplit+0x8c>
			string++;
	}
  801dd5:	e9 6e ff ff ff       	jmp    801d48 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801dda:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dea:	01 d0                	add    %edx,%eax
  801dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801e05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e0c:	eb 4a                	jmp    801e58 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801e0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	01 c2                	add    %eax,%edx
  801e16:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	01 c8                	add    %ecx,%eax
  801e1e:	8a 00                	mov    (%eax),%al
  801e20:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801e22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	8a 00                	mov    (%eax),%al
  801e2c:	3c 40                	cmp    $0x40,%al
  801e2e:	7e 25                	jle    801e55 <str2lower+0x5c>
  801e30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e36:	01 d0                	add    %edx,%eax
  801e38:	8a 00                	mov    (%eax),%al
  801e3a:	3c 5a                	cmp    $0x5a,%al
  801e3c:	7f 17                	jg     801e55 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	01 d0                	add    %edx,%eax
  801e46:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e49:	8b 55 08             	mov    0x8(%ebp),%edx
  801e4c:	01 ca                	add    %ecx,%edx
  801e4e:	8a 12                	mov    (%edx),%dl
  801e50:	83 c2 20             	add    $0x20,%edx
  801e53:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801e55:	ff 45 fc             	incl   -0x4(%ebp)
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	e8 01 f8 ff ff       	call   801661 <strlen>
  801e60:	83 c4 04             	add    $0x4,%esp
  801e63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e66:	7f a6                	jg     801e0e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801e73:	a1 08 50 80 00       	mov    0x805008,%eax
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	74 42                	je     801ebe <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801e7c:	83 ec 08             	sub    $0x8,%esp
  801e7f:	68 00 00 00 82       	push   $0x82000000
  801e84:	68 00 00 00 80       	push   $0x80000000
  801e89:	e8 00 08 00 00       	call   80268e <initialize_dynamic_allocator>
  801e8e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801e91:	e8 e7 05 00 00       	call   80247d <sys_get_uheap_strategy>
  801e96:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801e9b:	a1 40 50 80 00       	mov    0x805040,%eax
  801ea0:	05 00 10 00 00       	add    $0x1000,%eax
  801ea5:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801eaa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801eaf:	a3 68 d0 81 00       	mov    %eax,0x81d068

		__firstTimeFlag = 0;
  801eb4:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ebb:	00 00 00 
	}
}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ed5:	83 ec 08             	sub    $0x8,%esp
  801ed8:	68 06 04 00 00       	push   $0x406
  801edd:	50                   	push   %eax
  801ede:	e8 e4 01 00 00       	call   8020c7 <__sys_allocate_page>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eed:	79 14                	jns    801f03 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 9c 3d 80 00       	push   $0x803d9c
  801ef7:	6a 1f                	push   $0x1f
  801ef9:	68 d8 3d 80 00       	push   $0x803dd8
  801efe:	e8 af eb ff ff       	call   800ab2 <_panic>
	return 0;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	50                   	push   %eax
  801f22:	e8 e7 01 00 00       	call   80210e <__sys_unmap_frame>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f31:	79 14                	jns    801f47 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	68 e4 3d 80 00       	push   $0x803de4
  801f3b:	6a 2a                	push   $0x2a
  801f3d:	68 d8 3d 80 00       	push   $0x803dd8
  801f42:	e8 6b eb ff ff       	call   800ab2 <_panic>
}
  801f47:	90                   	nop
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f50:	e8 18 ff ff ff       	call   801e6d <uheap_init>
	if (size == 0) return NULL ;
  801f55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f59:	75 07                	jne    801f62 <malloc+0x18>
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	eb 14                	jmp    801f76 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	68 24 3e 80 00       	push   $0x803e24
  801f6a:	6a 3e                	push   $0x3e
  801f6c:	68 d8 3d 80 00       	push   $0x803dd8
  801f71:	e8 3c eb ff ff       	call   800ab2 <_panic>
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	68 4c 3e 80 00       	push   $0x803e4c
  801f86:	6a 49                	push   $0x49
  801f88:	68 d8 3d 80 00       	push   $0x803dd8
  801f8d:	e8 20 eb ff ff       	call   800ab2 <_panic>

00801f92 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 18             	sub    $0x18,%esp
  801f98:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f9e:	e8 ca fe ff ff       	call   801e6d <uheap_init>
	if (size == 0) return NULL ;
  801fa3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fa7:	75 07                	jne    801fb0 <smalloc+0x1e>
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	eb 14                	jmp    801fc4 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 70 3e 80 00       	push   $0x803e70
  801fb8:	6a 5a                	push   $0x5a
  801fba:	68 d8 3d 80 00       	push   $0x803dd8
  801fbf:	e8 ee ea ff ff       	call   800ab2 <_panic>
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fcc:	e8 9c fe ff ff       	call   801e6d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	68 98 3e 80 00       	push   $0x803e98
  801fd9:	6a 6a                	push   $0x6a
  801fdb:	68 d8 3d 80 00       	push   $0x803dd8
  801fe0:	e8 cd ea ff ff       	call   800ab2 <_panic>

00801fe5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801feb:	e8 7d fe ff ff       	call   801e6d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 bc 3e 80 00       	push   $0x803ebc
  801ff8:	68 88 00 00 00       	push   $0x88
  801ffd:	68 d8 3d 80 00       	push   $0x803dd8
  802002:	e8 ab ea ff ff       	call   800ab2 <_panic>

00802007 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 e4 3e 80 00       	push   $0x803ee4
  802015:	68 9b 00 00 00       	push   $0x9b
  80201a:	68 d8 3d 80 00       	push   $0x803dd8
  80201f:	e8 8e ea ff ff       	call   800ab2 <_panic>

00802024 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	57                   	push   %edi
  802028:	56                   	push   %esi
  802029:	53                   	push   %ebx
  80202a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802036:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802039:	8b 7d 18             	mov    0x18(%ebp),%edi
  80203c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80203f:	cd 30                	int    $0x30
  802041:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802047:	83 c4 10             	add    $0x10,%esp
  80204a:	5b                   	pop    %ebx
  80204b:	5e                   	pop    %esi
  80204c:	5f                   	pop    %edi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	8b 45 10             	mov    0x10(%ebp),%eax
  802058:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80205b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80205e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	51                   	push   %ecx
  802068:	52                   	push   %edx
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	50                   	push   %eax
  80206d:	6a 00                	push   $0x0
  80206f:	e8 b0 ff ff ff       	call   802024 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	90                   	nop
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_cgetc>:

int
sys_cgetc(void)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 02                	push   $0x2
  802089:	e8 96 ff ff ff       	call   802024 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 03                	push   $0x3
  8020a2:	e8 7d ff ff ff       	call   802024 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 04                	push   $0x4
  8020bc:	e8 63 ff ff ff       	call   802024 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	90                   	nop
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	52                   	push   %edx
  8020d7:	50                   	push   %eax
  8020d8:	6a 08                	push   $0x8
  8020da:	e8 45 ff ff ff       	call   802024 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	56                   	push   %esi
  8020f9:	53                   	push   %ebx
  8020fa:	51                   	push   %ecx
  8020fb:	52                   	push   %edx
  8020fc:	50                   	push   %eax
  8020fd:	6a 09                	push   $0x9
  8020ff:	e8 20 ff ff ff       	call   802024 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210a:	5b                   	pop    %ebx
  80210b:	5e                   	pop    %esi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	6a 0a                	push   $0xa
  80211e:	e8 01 ff ff ff       	call   802024 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	ff 75 0c             	pushl  0xc(%ebp)
  802134:	ff 75 08             	pushl  0x8(%ebp)
  802137:	6a 0b                	push   $0xb
  802139:	e8 e6 fe ff ff       	call   802024 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 0c                	push   $0xc
  802152:	e8 cd fe ff ff       	call   802024 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 0d                	push   $0xd
  80216b:	e8 b4 fe ff ff       	call   802024 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 0e                	push   $0xe
  802184:	e8 9b fe ff ff       	call   802024 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 0f                	push   $0xf
  80219d:	e8 82 fe ff ff       	call   802024 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	6a 10                	push   $0x10
  8021b7:	e8 68 fe ff ff       	call   802024 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 11                	push   $0x11
  8021d0:	e8 4f fe ff ff       	call   802024 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	90                   	nop
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_cputc>:

void
sys_cputc(const char c)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	50                   	push   %eax
  8021f4:	6a 01                	push   $0x1
  8021f6:	e8 29 fe ff ff       	call   802024 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	90                   	nop
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 14                	push   $0x14
  802210:	e8 0f fe ff ff       	call   802024 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	90                   	nop
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	8b 45 10             	mov    0x10(%ebp),%eax
  802224:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802227:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80222a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	6a 00                	push   $0x0
  802233:	51                   	push   %ecx
  802234:	52                   	push   %edx
  802235:	ff 75 0c             	pushl  0xc(%ebp)
  802238:	50                   	push   %eax
  802239:	6a 15                	push   $0x15
  80223b:	e8 e4 fd ff ff       	call   802024 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	52                   	push   %edx
  802255:	50                   	push   %eax
  802256:	6a 16                	push   $0x16
  802258:	e8 c7 fd ff ff       	call   802024 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802265:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	51                   	push   %ecx
  802273:	52                   	push   %edx
  802274:	50                   	push   %eax
  802275:	6a 17                	push   $0x17
  802277:	e8 a8 fd ff ff       	call   802024 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802284:	8b 55 0c             	mov    0xc(%ebp),%edx
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	52                   	push   %edx
  802291:	50                   	push   %eax
  802292:	6a 18                	push   $0x18
  802294:	e8 8b fd ff ff       	call   802024 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	6a 00                	push   $0x0
  8022a6:	ff 75 14             	pushl  0x14(%ebp)
  8022a9:	ff 75 10             	pushl  0x10(%ebp)
  8022ac:	ff 75 0c             	pushl  0xc(%ebp)
  8022af:	50                   	push   %eax
  8022b0:	6a 19                	push   $0x19
  8022b2:	e8 6d fd ff ff       	call   802024 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	50                   	push   %eax
  8022cb:	6a 1a                	push   $0x1a
  8022cd:	e8 52 fd ff ff       	call   802024 <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	90                   	nop
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	50                   	push   %eax
  8022e7:	6a 1b                	push   $0x1b
  8022e9:	e8 36 fd ff ff       	call   802024 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 05                	push   $0x5
  802302:	e8 1d fd ff ff       	call   802024 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 06                	push   $0x6
  80231b:	e8 04 fd ff ff       	call   802024 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 07                	push   $0x7
  802334:	e8 eb fc ff ff       	call   802024 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_exit_env>:


void sys_exit_env(void)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 1c                	push   $0x1c
  80234d:	e8 d2 fc ff ff       	call   802024 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	90                   	nop
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80235e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802361:	8d 50 04             	lea    0x4(%eax),%edx
  802364:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	52                   	push   %edx
  80236e:	50                   	push   %eax
  80236f:	6a 1d                	push   $0x1d
  802371:	e8 ae fc ff ff       	call   802024 <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
	return result;
  802379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80237c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80237f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802382:	89 01                	mov    %eax,(%ecx)
  802384:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	c9                   	leave  
  80238b:	c2 04 00             	ret    $0x4

0080238e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	ff 75 10             	pushl  0x10(%ebp)
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	6a 13                	push   $0x13
  8023a0:	e8 7f fc ff ff       	call   802024 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a8:	90                   	nop
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_rcr2>:
uint32 sys_rcr2()
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 1e                	push   $0x1e
  8023ba:	e8 65 fc ff ff       	call   802024 <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023d0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	50                   	push   %eax
  8023dd:	6a 1f                	push   $0x1f
  8023df:	e8 40 fc ff ff       	call   802024 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e7:	90                   	nop
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <rsttst>:
void rsttst()
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 21                	push   $0x21
  8023f9:	e8 26 fc ff ff       	call   802024 <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802401:	90                   	nop
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	8b 45 14             	mov    0x14(%ebp),%eax
  80240d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802410:	8b 55 18             	mov    0x18(%ebp),%edx
  802413:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802417:	52                   	push   %edx
  802418:	50                   	push   %eax
  802419:	ff 75 10             	pushl  0x10(%ebp)
  80241c:	ff 75 0c             	pushl  0xc(%ebp)
  80241f:	ff 75 08             	pushl  0x8(%ebp)
  802422:	6a 20                	push   $0x20
  802424:	e8 fb fb ff ff       	call   802024 <syscall>
  802429:	83 c4 18             	add    $0x18,%esp
	return ;
  80242c:	90                   	nop
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <chktst>:
void chktst(uint32 n)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	ff 75 08             	pushl  0x8(%ebp)
  80243d:	6a 22                	push   $0x22
  80243f:	e8 e0 fb ff ff       	call   802024 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
	return ;
  802447:	90                   	nop
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <inctst>:

void inctst()
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 23                	push   $0x23
  802459:	e8 c6 fb ff ff       	call   802024 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
	return ;
  802461:	90                   	nop
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <gettst>:
uint32 gettst()
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 24                	push   $0x24
  802473:	e8 ac fb ff ff       	call   802024 <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 25                	push   $0x25
  80248c:	e8 93 fb ff ff       	call   802024 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
  802494:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802499:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	ff 75 08             	pushl  0x8(%ebp)
  8024b6:	6a 26                	push   $0x26
  8024b8:	e8 67 fb ff ff       	call   802024 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c0:	90                   	nop
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	53                   	push   %ebx
  8024d6:	51                   	push   %ecx
  8024d7:	52                   	push   %edx
  8024d8:	50                   	push   %eax
  8024d9:	6a 27                	push   $0x27
  8024db:	e8 44 fb ff ff       	call   802024 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 28                	push   $0x28
  8024fb:	e8 24 fb ff ff       	call   802024 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802508:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80250b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	6a 00                	push   $0x0
  802513:	51                   	push   %ecx
  802514:	ff 75 10             	pushl  0x10(%ebp)
  802517:	52                   	push   %edx
  802518:	50                   	push   %eax
  802519:	6a 29                	push   $0x29
  80251b:	e8 04 fb ff ff       	call   802024 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	ff 75 10             	pushl  0x10(%ebp)
  80252f:	ff 75 0c             	pushl  0xc(%ebp)
  802532:	ff 75 08             	pushl  0x8(%ebp)
  802535:	6a 12                	push   $0x12
  802537:	e8 e8 fa ff ff       	call   802024 <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
	return ;
  80253f:	90                   	nop
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802545:	8b 55 0c             	mov    0xc(%ebp),%edx
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	52                   	push   %edx
  802552:	50                   	push   %eax
  802553:	6a 2a                	push   $0x2a
  802555:	e8 ca fa ff ff       	call   802024 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
	return;
  80255d:	90                   	nop
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 2b                	push   $0x2b
  80256f:	e8 b0 fa ff ff       	call   802024 <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	ff 75 0c             	pushl  0xc(%ebp)
  802585:	ff 75 08             	pushl  0x8(%ebp)
  802588:	6a 2d                	push   $0x2d
  80258a:	e8 95 fa ff ff       	call   802024 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
	return;
  802592:	90                   	nop
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	ff 75 0c             	pushl  0xc(%ebp)
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	6a 2c                	push   $0x2c
  8025a6:	e8 79 fa ff ff       	call   802024 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ae:	90                   	nop
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 08 3f 80 00       	push   $0x803f08
  8025bf:	68 25 01 00 00       	push   $0x125
  8025c4:	68 3b 3f 80 00       	push   $0x803f3b
  8025c9:	e8 e4 e4 ff ff       	call   800ab2 <_panic>

008025ce <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8025d4:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8025db:	72 09                	jb     8025e6 <to_page_va+0x18>
  8025dd:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8025e4:	72 14                	jb     8025fa <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 4c 3f 80 00       	push   $0x803f4c
  8025ee:	6a 15                	push   $0x15
  8025f0:	68 77 3f 80 00       	push   $0x803f77
  8025f5:	e8 b8 e4 ff ff       	call   800ab2 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	ba 60 50 80 00       	mov    $0x805060,%edx
  802602:	29 d0                	sub    %edx,%eax
  802604:	c1 f8 02             	sar    $0x2,%eax
  802607:	89 c2                	mov    %eax,%edx
  802609:	89 d0                	mov    %edx,%eax
  80260b:	c1 e0 02             	shl    $0x2,%eax
  80260e:	01 d0                	add    %edx,%eax
  802610:	c1 e0 02             	shl    $0x2,%eax
  802613:	01 d0                	add    %edx,%eax
  802615:	c1 e0 02             	shl    $0x2,%eax
  802618:	01 d0                	add    %edx,%eax
  80261a:	89 c1                	mov    %eax,%ecx
  80261c:	c1 e1 08             	shl    $0x8,%ecx
  80261f:	01 c8                	add    %ecx,%eax
  802621:	89 c1                	mov    %eax,%ecx
  802623:	c1 e1 10             	shl    $0x10,%ecx
  802626:	01 c8                	add    %ecx,%eax
  802628:	01 c0                	add    %eax,%eax
  80262a:	01 d0                	add    %edx,%eax
  80262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c1 e0 0c             	shl    $0xc,%eax
  802635:	89 c2                	mov    %eax,%edx
  802637:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80263c:	01 d0                	add    %edx,%eax
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802646:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80264b:	8b 55 08             	mov    0x8(%ebp),%edx
  80264e:	29 c2                	sub    %eax,%edx
  802650:	89 d0                	mov    %edx,%eax
  802652:	c1 e8 0c             	shr    $0xc,%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	78 09                	js     802667 <to_page_info+0x27>
  80265e:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802665:	7e 14                	jle    80267b <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 90 3f 80 00       	push   $0x803f90
  80266f:	6a 22                	push   $0x22
  802671:	68 77 3f 80 00       	push   $0x803f77
  802676:	e8 37 e4 ff ff       	call   800ab2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80267b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267e:	89 d0                	mov    %edx,%eax
  802680:	01 c0                	add    %eax,%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	c1 e0 02             	shl    $0x2,%eax
  802687:	05 60 50 80 00       	add    $0x805060,%eax
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	05 00 00 00 02       	add    $0x2000000,%eax
  80269c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80269f:	73 16                	jae    8026b7 <initialize_dynamic_allocator+0x29>
  8026a1:	68 b4 3f 80 00       	push   $0x803fb4
  8026a6:	68 da 3f 80 00       	push   $0x803fda
  8026ab:	6a 34                	push   $0x34
  8026ad:	68 77 3f 80 00       	push   $0x803f77
  8026b2:	e8 fb e3 ff ff       	call   800ab2 <_panic>
		is_initialized = 1;
  8026b7:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8026be:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8026c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026cc:	a3 40 50 80 00       	mov    %eax,0x805040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8026d1:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8026d8:	00 00 00 
  8026db:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8026e2:	00 00 00 
  8026e5:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8026ec:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  8026ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f5:	c1 e8 0c             	shr    $0xc,%eax
  8026f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8026fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802702:	e9 c8 00 00 00       	jmp    8027cf <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	89 d0                	mov    %edx,%eax
  80270c:	01 c0                	add    %eax,%eax
  80270e:	01 d0                	add    %edx,%eax
  802710:	c1 e0 02             	shl    $0x2,%eax
  802713:	05 68 50 80 00       	add    $0x805068,%eax
  802718:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80271d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802720:	89 d0                	mov    %edx,%eax
  802722:	01 c0                	add    %eax,%eax
  802724:	01 d0                	add    %edx,%eax
  802726:	c1 e0 02             	shl    $0x2,%eax
  802729:	05 6a 50 80 00       	add    $0x80506a,%eax
  80272e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802733:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802739:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80273c:	89 c8                	mov    %ecx,%eax
  80273e:	01 c0                	add    %eax,%eax
  802740:	01 c8                	add    %ecx,%eax
  802742:	c1 e0 02             	shl    $0x2,%eax
  802745:	05 64 50 80 00       	add    $0x805064,%eax
  80274a:	89 10                	mov    %edx,(%eax)
  80274c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274f:	89 d0                	mov    %edx,%eax
  802751:	01 c0                	add    %eax,%eax
  802753:	01 d0                	add    %edx,%eax
  802755:	c1 e0 02             	shl    $0x2,%eax
  802758:	05 64 50 80 00       	add    $0x805064,%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 1b                	je     80277e <initialize_dynamic_allocator+0xf0>
  802763:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802769:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80276c:	89 c8                	mov    %ecx,%eax
  80276e:	01 c0                	add    %eax,%eax
  802770:	01 c8                	add    %ecx,%eax
  802772:	c1 e0 02             	shl    $0x2,%eax
  802775:	05 60 50 80 00       	add    $0x805060,%eax
  80277a:	89 02                	mov    %eax,(%edx)
  80277c:	eb 16                	jmp    802794 <initialize_dynamic_allocator+0x106>
  80277e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802781:	89 d0                	mov    %edx,%eax
  802783:	01 c0                	add    %eax,%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	c1 e0 02             	shl    $0x2,%eax
  80278a:	05 60 50 80 00       	add    $0x805060,%eax
  80278f:	a3 48 50 80 00       	mov    %eax,0x805048
  802794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802797:	89 d0                	mov    %edx,%eax
  802799:	01 c0                	add    %eax,%eax
  80279b:	01 d0                	add    %edx,%eax
  80279d:	c1 e0 02             	shl    $0x2,%eax
  8027a0:	05 60 50 80 00       	add    $0x805060,%eax
  8027a5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8027aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	c1 e0 02             	shl    $0x2,%eax
  8027b6:	05 60 50 80 00       	add    $0x805060,%eax
  8027bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c1:	a1 54 50 80 00       	mov    0x805054,%eax
  8027c6:	40                   	inc    %eax
  8027c7:	a3 54 50 80 00       	mov    %eax,0x805054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8027cc:	ff 45 f4             	incl   -0xc(%ebp)
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027d5:	0f 8c 2c ff ff ff    	jl     802707 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8027db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8027e2:	eb 36                	jmp    80281a <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	c1 e0 04             	shl    $0x4,%eax
  8027ea:	05 80 d0 81 00       	add    $0x81d080,%eax
  8027ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	c1 e0 04             	shl    $0x4,%eax
  8027fb:	05 84 d0 81 00       	add    $0x81d084,%eax
  802800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	c1 e0 04             	shl    $0x4,%eax
  80280c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802817:	ff 45 f0             	incl   -0x10(%ebp)
  80281a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80281e:	7e c4                	jle    8027e4 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802820:	90                   	nop
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 ec 0c             	sub    $0xc,%esp
  80282f:	50                   	push   %eax
  802830:	e8 0b fe ff ff       	call   802640 <to_page_info>
  802835:	83 c4 10             	add    $0x10,%esp
  802838:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 08             	mov    0x8(%eax),%eax
  802841:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80284c:	83 ec 0c             	sub    $0xc,%esp
  80284f:	ff 75 0c             	pushl  0xc(%ebp)
  802852:	e8 77 fd ff ff       	call   8025ce <to_page_va>
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80285d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802862:	ba 00 00 00 00       	mov    $0x0,%edx
  802867:	f7 75 08             	divl   0x8(%ebp)
  80286a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80286d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802870:	83 ec 0c             	sub    $0xc,%esp
  802873:	50                   	push   %eax
  802874:	e8 48 f6 ff ff       	call   801ec1 <get_page>
  802879:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80287c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802882:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288c:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802897:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80289e:	eb 19                	jmp    8028b9 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	ba 01 00 00 00       	mov    $0x1,%edx
  8028a8:	88 c1                	mov    %al,%cl
  8028aa:	d3 e2                	shl    %cl,%edx
  8028ac:	89 d0                	mov    %edx,%eax
  8028ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b1:	74 0e                	je     8028c1 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8028b3:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8028b6:	ff 45 f0             	incl   -0x10(%ebp)
  8028b9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8028bd:	7e e1                	jle    8028a0 <split_page_to_blocks+0x5a>
  8028bf:	eb 01                	jmp    8028c2 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8028c1:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8028c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8028c9:	e9 a7 00 00 00       	jmp    802975 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	0f af 45 08          	imul   0x8(%ebp),%eax
  8028d5:	89 c2                	mov    %eax,%edx
  8028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028da:	01 d0                	add    %edx,%eax
  8028dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8028df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028e3:	75 14                	jne    8028f9 <split_page_to_blocks+0xb3>
  8028e5:	83 ec 04             	sub    $0x4,%esp
  8028e8:	68 f0 3f 80 00       	push   $0x803ff0
  8028ed:	6a 7c                	push   $0x7c
  8028ef:	68 77 3f 80 00       	push   $0x803f77
  8028f4:	e8 b9 e1 ff ff       	call   800ab2 <_panic>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	c1 e0 04             	shl    $0x4,%eax
  8028ff:	05 84 d0 81 00       	add    $0x81d084,%eax
  802904:	8b 10                	mov    (%eax),%edx
  802906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 14                	je     80292a <split_page_to_blocks+0xe4>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c1 e0 04             	shl    $0x4,%eax
  80291c:	05 84 d0 81 00       	add    $0x81d084,%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	eb 11                	jmp    80293b <split_page_to_blocks+0xf5>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	c1 e0 04             	shl    $0x4,%eax
  802930:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802936:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802939:	89 02                	mov    %eax,(%edx)
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	c1 e0 04             	shl    $0x4,%eax
  802941:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294a:	89 02                	mov    %eax,(%edx)
  80294c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	c1 e0 04             	shl    $0x4,%eax
  80295b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	8d 50 01             	lea    0x1(%eax),%edx
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	c1 e0 04             	shl    $0x4,%eax
  80296b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802970:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802972:	ff 45 ec             	incl   -0x14(%ebp)
  802975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802978:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80297b:	0f 82 4d ff ff ff    	jb     8028ce <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802981:	90                   	nop
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80298a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802991:	76 19                	jbe    8029ac <alloc_block+0x28>
  802993:	68 14 40 80 00       	push   $0x804014
  802998:	68 da 3f 80 00       	push   $0x803fda
  80299d:	68 8a 00 00 00       	push   $0x8a
  8029a2:	68 77 3f 80 00       	push   $0x803f77
  8029a7:	e8 06 e1 ff ff       	call   800ab2 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8029ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8029b3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8029ba:	eb 19                	jmp    8029d5 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8029c4:	88 c1                	mov    %al,%cl
  8029c6:	d3 e2                	shl    %cl,%edx
  8029c8:	89 d0                	mov    %edx,%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	73 0e                	jae    8029dd <alloc_block+0x59>
		idx++;
  8029cf:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8029d2:	ff 45 f0             	incl   -0x10(%ebp)
  8029d5:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8029d9:	7e e1                	jle    8029bc <alloc_block+0x38>
  8029db:	eb 01                	jmp    8029de <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8029dd:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	c1 e0 04             	shl    $0x4,%eax
  8029e4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	0f 84 df 00 00 00    	je     802ad2 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c1 e0 04             	shl    $0x4,%eax
  8029f9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a07:	75 17                	jne    802a20 <alloc_block+0x9c>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 35 40 80 00       	push   $0x804035
  802a11:	68 9e 00 00 00       	push   $0x9e
  802a16:	68 77 3f 80 00       	push   $0x803f77
  802a1b:	e8 92 e0 ff ff       	call   800ab2 <_panic>
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 10                	je     802a39 <alloc_block+0xb5>
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a31:	8b 52 04             	mov    0x4(%edx),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 14                	jmp    802a4d <alloc_block+0xc9>
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	c1 e2 04             	shl    $0x4,%edx
  802a45:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802a4b:	89 02                	mov    %eax,(%edx)
  802a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0f                	je     802a66 <alloc_block+0xe2>
  802a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a60:	8b 12                	mov    (%edx),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 13                	jmp    802a79 <alloc_block+0xf5>
  802a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6e:	c1 e2 04             	shl    $0x4,%edx
  802a71:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802a77:	89 02                	mov    %eax,(%edx)
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	c1 e0 04             	shl    $0x4,%eax
  802a92:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	c1 e0 04             	shl    $0x4,%eax
  802aa2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802aa7:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	83 ec 0c             	sub    $0xc,%esp
  802aaf:	50                   	push   %eax
  802ab0:	e8 8b fb ff ff       	call   802640 <to_page_info>
  802ab5:	83 c4 10             	add    $0x10,%esp
  802ab8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802abb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abe:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ac2:	48                   	dec    %eax
  802ac3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac6:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	e9 bc 02 00 00       	jmp    802d8e <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802ad2:	a1 54 50 80 00       	mov    0x805054,%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	0f 84 7d 02 00 00    	je     802d5c <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802adf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802ae7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aeb:	75 17                	jne    802b04 <alloc_block+0x180>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 35 40 80 00       	push   $0x804035
  802af5:	68 a9 00 00 00       	push   $0xa9
  802afa:	68 77 3f 80 00       	push   $0x803f77
  802aff:	e8 ae df ff ff       	call   800ab2 <_panic>
  802b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 10                	je     802b1d <alloc_block+0x199>
  802b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b15:	8b 52 04             	mov    0x4(%edx),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 0b                	jmp    802b28 <alloc_block+0x1a4>
  802b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 0f                	je     802b41 <alloc_block+0x1bd>
  802b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b3b:	8b 12                	mov    (%edx),%edx
  802b3d:	89 10                	mov    %edx,(%eax)
  802b3f:	eb 0a                	jmp    802b4b <alloc_block+0x1c7>
  802b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	a3 48 50 80 00       	mov    %eax,0x805048
  802b4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5e:	a1 54 50 80 00       	mov    0x805054,%eax
  802b63:	48                   	dec    %eax
  802b64:	a3 54 50 80 00       	mov    %eax,0x805054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	83 c0 03             	add    $0x3,%eax
  802b6f:	ba 01 00 00 00       	mov    $0x1,%edx
  802b74:	88 c1                	mov    %al,%cl
  802b76:	d3 e2                	shl    %cl,%edx
  802b78:	89 d0                	mov    %edx,%eax
  802b7a:	83 ec 08             	sub    $0x8,%esp
  802b7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b80:	50                   	push   %eax
  802b81:	e8 c0 fc ff ff       	call   802846 <split_page_to_blocks>
  802b86:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c1 e0 04             	shl    $0x4,%eax
  802b8f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802b99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b9d:	75 17                	jne    802bb6 <alloc_block+0x232>
  802b9f:	83 ec 04             	sub    $0x4,%esp
  802ba2:	68 35 40 80 00       	push   $0x804035
  802ba7:	68 b0 00 00 00       	push   $0xb0
  802bac:	68 77 3f 80 00       	push   $0x803f77
  802bb1:	e8 fc de ff ff       	call   800ab2 <_panic>
  802bb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb9:	8b 00                	mov    (%eax),%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	74 10                	je     802bcf <alloc_block+0x24b>
  802bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc7:	8b 52 04             	mov    0x4(%edx),%edx
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
  802bcd:	eb 14                	jmp    802be3 <alloc_block+0x25f>
  802bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd2:	8b 40 04             	mov    0x4(%eax),%eax
  802bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd8:	c1 e2 04             	shl    $0x4,%edx
  802bdb:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802be1:	89 02                	mov    %eax,(%edx)
  802be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0f                	je     802bfc <alloc_block+0x278>
  802bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf6:	8b 12                	mov    (%edx),%edx
  802bf8:	89 10                	mov    %edx,(%eax)
  802bfa:	eb 13                	jmp    802c0f <alloc_block+0x28b>
  802bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c04:	c1 e2 04             	shl    $0x4,%edx
  802c07:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802c0d:	89 02                	mov    %eax,(%edx)
  802c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	c1 e0 04             	shl    $0x4,%eax
  802c28:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	c1 e0 04             	shl    $0x4,%eax
  802c38:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c3d:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	50                   	push   %eax
  802c46:	e8 f5 f9 ff ff       	call   802640 <to_page_info>
  802c4b:	83 c4 10             	add    $0x10,%esp
  802c4e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802c51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c54:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c58:	48                   	dec    %eax
  802c59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c5c:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c63:	e9 26 01 00 00       	jmp    802d8e <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802c68:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	c1 e0 04             	shl    $0x4,%eax
  802c71:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	0f 84 dc 00 00 00    	je     802d5c <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	c1 e0 04             	shl    $0x4,%eax
  802c86:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802c90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c94:	75 17                	jne    802cad <alloc_block+0x329>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 35 40 80 00       	push   $0x804035
  802c9e:	68 be 00 00 00       	push   $0xbe
  802ca3:	68 77 3f 80 00       	push   $0x803f77
  802ca8:	e8 05 de ff ff       	call   800ab2 <_panic>
  802cad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 10                	je     802cc6 <alloc_block+0x342>
  802cb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802cbe:	8b 52 04             	mov    0x4(%edx),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 14                	jmp    802cda <alloc_block+0x356>
  802cc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccf:	c1 e2 04             	shl    $0x4,%edx
  802cd2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802cd8:	89 02                	mov    %eax,(%edx)
  802cda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block+0x36f>
  802ce4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 13                	jmp    802d06 <alloc_block+0x382>
  802cf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfb:	c1 e2 04             	shl    $0x4,%edx
  802cfe:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d04:	89 02                	mov    %eax,(%edx)
  802d06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	c1 e0 04             	shl    $0x4,%eax
  802d1f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	c1 e0 04             	shl    $0x4,%eax
  802d2f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d34:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802d36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	50                   	push   %eax
  802d3d:	e8 fe f8 ff ff       	call   802640 <to_page_info>
  802d42:	83 c4 10             	add    $0x10,%esp
  802d45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802d48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d4b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802d4f:	48                   	dec    %eax
  802d50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d53:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802d57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d5a:	eb 32                	jmp    802d8e <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802d5c:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802d60:	77 15                	ja     802d77 <alloc_block+0x3f3>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	c1 e0 04             	shl    $0x4,%eax
  802d68:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	0f 84 f1 fe ff ff    	je     802c68 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802d77:	83 ec 04             	sub    $0x4,%esp
  802d7a:	68 53 40 80 00       	push   $0x804053
  802d7f:	68 c8 00 00 00       	push   $0xc8
  802d84:	68 77 3f 80 00       	push   $0x803f77
  802d89:	e8 24 dd ff ff       	call   800ab2 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802d8e:	c9                   	leave  
  802d8f:	c3                   	ret    

00802d90 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802d90:	55                   	push   %ebp
  802d91:	89 e5                	mov    %esp,%ebp
  802d93:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802d96:	8b 55 08             	mov    0x8(%ebp),%edx
  802d99:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d9e:	39 c2                	cmp    %eax,%edx
  802da0:	72 0c                	jb     802dae <free_block+0x1e>
  802da2:	8b 55 08             	mov    0x8(%ebp),%edx
  802da5:	a1 40 50 80 00       	mov    0x805040,%eax
  802daa:	39 c2                	cmp    %eax,%edx
  802dac:	72 19                	jb     802dc7 <free_block+0x37>
  802dae:	68 64 40 80 00       	push   $0x804064
  802db3:	68 da 3f 80 00       	push   $0x803fda
  802db8:	68 d7 00 00 00       	push   $0xd7
  802dbd:	68 77 3f 80 00       	push   $0x803f77
  802dc2:	e8 eb dc ff ff       	call   800ab2 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	83 ec 0c             	sub    $0xc,%esp
  802dd3:	50                   	push   %eax
  802dd4:	e8 67 f8 ff ff       	call   802640 <to_page_info>
  802dd9:	83 c4 10             	add    $0x10,%esp
  802ddc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	0f b7 c0             	movzwl %ax,%eax
  802de8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802df2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802df9:	eb 19                	jmp    802e14 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	ba 01 00 00 00       	mov    $0x1,%edx
  802e03:	88 c1                	mov    %al,%cl
  802e05:	d3 e2                	shl    %cl,%edx
  802e07:	89 d0                	mov    %edx,%eax
  802e09:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e0c:	74 0e                	je     802e1c <free_block+0x8c>
	        break;
	    idx++;
  802e0e:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802e11:	ff 45 f0             	incl   -0x10(%ebp)
  802e14:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802e18:	7e e1                	jle    802dfb <free_block+0x6b>
  802e1a:	eb 01                	jmp    802e1d <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802e1c:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e20:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802e24:	40                   	inc    %eax
  802e25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e28:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802e2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e30:	75 17                	jne    802e49 <free_block+0xb9>
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	68 f0 3f 80 00       	push   $0x803ff0
  802e3a:	68 ee 00 00 00       	push   $0xee
  802e3f:	68 77 3f 80 00       	push   $0x803f77
  802e44:	e8 69 dc ff ff       	call   800ab2 <_panic>
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	c1 e0 04             	shl    $0x4,%eax
  802e4f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e54:	8b 10                	mov    (%eax),%edx
  802e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 14                	je     802e7a <free_block+0xea>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	c1 e0 04             	shl    $0x4,%eax
  802e6c:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	eb 11                	jmp    802e8b <free_block+0xfb>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	c1 e0 04             	shl    $0x4,%eax
  802e80:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	89 02                	mov    %eax,(%edx)
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	c1 e0 04             	shl    $0x4,%eax
  802e91:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9a:	89 02                	mov    %eax,(%edx)
  802e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	c1 e0 04             	shl    $0x4,%eax
  802eab:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	8d 50 01             	lea    0x1(%eax),%edx
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	c1 e0 04             	shl    $0x4,%eax
  802ebb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ec0:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802ec2:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ec7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ecc:	f7 75 e0             	divl   -0x20(%ebp)
  802ecf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ed9:	0f b7 c0             	movzwl %ax,%eax
  802edc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802edf:	0f 85 70 01 00 00    	jne    803055 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802ee5:	83 ec 0c             	sub    $0xc,%esp
  802ee8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eeb:	e8 de f6 ff ff       	call   8025ce <to_page_va>
  802ef0:	83 c4 10             	add    $0x10,%esp
  802ef3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802ef6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802efd:	e9 b7 00 00 00       	jmp    802fb9 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802f02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f08:	01 d0                	add    %edx,%eax
  802f0a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802f0d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f11:	75 17                	jne    802f2a <free_block+0x19a>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 35 40 80 00       	push   $0x804035
  802f1b:	68 f8 00 00 00       	push   $0xf8
  802f20:	68 77 3f 80 00       	push   $0x803f77
  802f25:	e8 88 db ff ff       	call   800ab2 <_panic>
  802f2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <free_block+0x1b3>
  802f33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 14                	jmp    802f57 <free_block+0x1c7>
  802f43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4c:	c1 e2 04             	shl    $0x4,%edx
  802f4f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f55:	89 02                	mov    %eax,(%edx)
  802f57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 0f                	je     802f70 <free_block+0x1e0>
  802f61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f64:	8b 40 04             	mov    0x4(%eax),%eax
  802f67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f6a:	8b 12                	mov    (%edx),%edx
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	eb 13                	jmp    802f83 <free_block+0x1f3>
  802f70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f78:	c1 e2 04             	shl    $0x4,%edx
  802f7b:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f81:	89 02                	mov    %eax,(%edx)
  802f83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	c1 e0 04             	shl    $0x4,%eax
  802f9c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	8d 50 ff             	lea    -0x1(%eax),%edx
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	c1 e0 04             	shl    $0x4,%eax
  802fac:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fb1:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb6:	01 45 ec             	add    %eax,-0x14(%ebp)
  802fb9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802fc0:	0f 86 3c ff ff ff    	jbe    802f02 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802fd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fdc:	75 17                	jne    802ff5 <free_block+0x265>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 f0 3f 80 00       	push   $0x803ff0
  802fe6:	68 fe 00 00 00       	push   $0xfe
  802feb:	68 77 3f 80 00       	push   $0x803f77
  802ff0:	e8 bd da ff ff       	call   800ab2 <_panic>
  802ff5:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	74 0c                	je     803017 <free_block+0x287>
  80300b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803010:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803013:	89 10                	mov    %edx,(%eax)
  803015:	eb 08                	jmp    80301f <free_block+0x28f>
  803017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301a:	a3 48 50 80 00       	mov    %eax,0x805048
  80301f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803022:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803030:	a1 54 50 80 00       	mov    0x805054,%eax
  803035:	40                   	inc    %eax
  803036:	a3 54 50 80 00       	mov    %eax,0x805054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80303b:	83 ec 0c             	sub    $0xc,%esp
  80303e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803041:	e8 88 f5 ff ff       	call   8025ce <to_page_va>
  803046:	83 c4 10             	add    $0x10,%esp
  803049:	83 ec 0c             	sub    $0xc,%esp
  80304c:	50                   	push   %eax
  80304d:	e8 b8 ee ff ff       	call   801f0a <return_page>
  803052:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803055:	90                   	nop
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	68 9c 40 80 00       	push   $0x80409c
  803066:	68 11 01 00 00       	push   $0x111
  80306b:	68 77 3f 80 00       	push   $0x803f77
  803070:	e8 3d da ff ff       	call   800ab2 <_panic>

00803075 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
  803078:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 c0 40 80 00       	push   $0x8040c0
  803083:	6a 07                	push   $0x7
  803085:	68 ef 40 80 00       	push   $0x8040ef
  80308a:	e8 23 da ff ff       	call   800ab2 <_panic>

0080308f <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
  803092:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 00 41 80 00       	push   $0x804100
  80309d:	6a 0b                	push   $0xb
  80309f:	68 ef 40 80 00       	push   $0x8040ef
  8030a4:	e8 09 da ff ff       	call   800ab2 <_panic>

008030a9 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
  8030ac:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 2c 41 80 00       	push   $0x80412c
  8030b7:	6a 10                	push   $0x10
  8030b9:	68 ef 40 80 00       	push   $0x8040ef
  8030be:	e8 ef d9 ff ff       	call   800ab2 <_panic>

008030c3 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
  8030c6:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 5c 41 80 00       	push   $0x80415c
  8030d1:	6a 15                	push   $0x15
  8030d3:	68 ef 40 80 00       	push   $0x8040ef
  8030d8:	e8 d5 d9 ff ff       	call   800ab2 <_panic>

008030dd <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8030dd:	55                   	push   %ebp
  8030de:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 40 10             	mov    0x10(%eax),%eax
}
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    

008030e8 <__divdi3>:
  8030e8:	55                   	push   %ebp
  8030e9:	57                   	push   %edi
  8030ea:	56                   	push   %esi
  8030eb:	53                   	push   %ebx
  8030ec:	83 ec 1c             	sub    $0x1c,%esp
  8030ef:	8b 44 24 30          	mov    0x30(%esp),%eax
  8030f3:	8b 54 24 34          	mov    0x34(%esp),%edx
  8030f7:	8b 74 24 38          	mov    0x38(%esp),%esi
  8030fb:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8030ff:	89 f9                	mov    %edi,%ecx
  803101:	85 d2                	test   %edx,%edx
  803103:	0f 88 bb 00 00 00    	js     8031c4 <__divdi3+0xdc>
  803109:	31 ed                	xor    %ebp,%ebp
  80310b:	85 c9                	test   %ecx,%ecx
  80310d:	0f 88 99 00 00 00    	js     8031ac <__divdi3+0xc4>
  803113:	89 34 24             	mov    %esi,(%esp)
  803116:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80311a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80311e:	89 d3                	mov    %edx,%ebx
  803120:	8b 34 24             	mov    (%esp),%esi
  803123:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803127:	89 74 24 08          	mov    %esi,0x8(%esp)
  80312b:	8b 34 24             	mov    (%esp),%esi
  80312e:	89 c1                	mov    %eax,%ecx
  803130:	85 ff                	test   %edi,%edi
  803132:	75 10                	jne    803144 <__divdi3+0x5c>
  803134:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803138:	39 d7                	cmp    %edx,%edi
  80313a:	76 4c                	jbe    803188 <__divdi3+0xa0>
  80313c:	f7 f7                	div    %edi
  80313e:	89 c1                	mov    %eax,%ecx
  803140:	31 f6                	xor    %esi,%esi
  803142:	eb 08                	jmp    80314c <__divdi3+0x64>
  803144:	39 d7                	cmp    %edx,%edi
  803146:	76 1c                	jbe    803164 <__divdi3+0x7c>
  803148:	31 f6                	xor    %esi,%esi
  80314a:	31 c9                	xor    %ecx,%ecx
  80314c:	89 c8                	mov    %ecx,%eax
  80314e:	89 f2                	mov    %esi,%edx
  803150:	85 ed                	test   %ebp,%ebp
  803152:	74 07                	je     80315b <__divdi3+0x73>
  803154:	f7 d8                	neg    %eax
  803156:	83 d2 00             	adc    $0x0,%edx
  803159:	f7 da                	neg    %edx
  80315b:	83 c4 1c             	add    $0x1c,%esp
  80315e:	5b                   	pop    %ebx
  80315f:	5e                   	pop    %esi
  803160:	5f                   	pop    %edi
  803161:	5d                   	pop    %ebp
  803162:	c3                   	ret    
  803163:	90                   	nop
  803164:	0f bd f7             	bsr    %edi,%esi
  803167:	83 f6 1f             	xor    $0x1f,%esi
  80316a:	75 6c                	jne    8031d8 <__divdi3+0xf0>
  80316c:	39 d7                	cmp    %edx,%edi
  80316e:	72 0e                	jb     80317e <__divdi3+0x96>
  803170:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  803174:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  803178:	0f 87 ca 00 00 00    	ja     803248 <__divdi3+0x160>
  80317e:	b9 01 00 00 00       	mov    $0x1,%ecx
  803183:	eb c7                	jmp    80314c <__divdi3+0x64>
  803185:	8d 76 00             	lea    0x0(%esi),%esi
  803188:	85 f6                	test   %esi,%esi
  80318a:	75 0b                	jne    803197 <__divdi3+0xaf>
  80318c:	b8 01 00 00 00       	mov    $0x1,%eax
  803191:	31 d2                	xor    %edx,%edx
  803193:	f7 f6                	div    %esi
  803195:	89 c6                	mov    %eax,%esi
  803197:	31 d2                	xor    %edx,%edx
  803199:	89 d8                	mov    %ebx,%eax
  80319b:	f7 f6                	div    %esi
  80319d:	89 c7                	mov    %eax,%edi
  80319f:	89 c8                	mov    %ecx,%eax
  8031a1:	f7 f6                	div    %esi
  8031a3:	89 c1                	mov    %eax,%ecx
  8031a5:	89 fe                	mov    %edi,%esi
  8031a7:	eb a3                	jmp    80314c <__divdi3+0x64>
  8031a9:	8d 76 00             	lea    0x0(%esi),%esi
  8031ac:	f7 d5                	not    %ebp
  8031ae:	f7 de                	neg    %esi
  8031b0:	83 d7 00             	adc    $0x0,%edi
  8031b3:	f7 df                	neg    %edi
  8031b5:	89 34 24             	mov    %esi,(%esp)
  8031b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8031bc:	e9 59 ff ff ff       	jmp    80311a <__divdi3+0x32>
  8031c1:	8d 76 00             	lea    0x0(%esi),%esi
  8031c4:	f7 d8                	neg    %eax
  8031c6:	83 d2 00             	adc    $0x0,%edx
  8031c9:	f7 da                	neg    %edx
  8031cb:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8031d0:	e9 36 ff ff ff       	jmp    80310b <__divdi3+0x23>
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	b8 20 00 00 00       	mov    $0x20,%eax
  8031dd:	29 f0                	sub    %esi,%eax
  8031df:	89 f1                	mov    %esi,%ecx
  8031e1:	d3 e7                	shl    %cl,%edi
  8031e3:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031e7:	88 c1                	mov    %al,%cl
  8031e9:	d3 ea                	shr    %cl,%edx
  8031eb:	89 d1                	mov    %edx,%ecx
  8031ed:	09 f9                	or     %edi,%ecx
  8031ef:	89 0c 24             	mov    %ecx,(%esp)
  8031f2:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f6:	89 f1                	mov    %esi,%ecx
  8031f8:	d3 e2                	shl    %cl,%edx
  8031fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031fe:	89 df                	mov    %ebx,%edi
  803200:	88 c1                	mov    %al,%cl
  803202:	d3 ef                	shr    %cl,%edi
  803204:	89 f1                	mov    %esi,%ecx
  803206:	d3 e3                	shl    %cl,%ebx
  803208:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80320c:	88 c1                	mov    %al,%cl
  80320e:	d3 ea                	shr    %cl,%edx
  803210:	09 d3                	or     %edx,%ebx
  803212:	89 d8                	mov    %ebx,%eax
  803214:	89 fa                	mov    %edi,%edx
  803216:	f7 34 24             	divl   (%esp)
  803219:	89 d1                	mov    %edx,%ecx
  80321b:	89 c3                	mov    %eax,%ebx
  80321d:	f7 64 24 08          	mull   0x8(%esp)
  803221:	39 d1                	cmp    %edx,%ecx
  803223:	72 17                	jb     80323c <__divdi3+0x154>
  803225:	74 09                	je     803230 <__divdi3+0x148>
  803227:	89 d9                	mov    %ebx,%ecx
  803229:	31 f6                	xor    %esi,%esi
  80322b:	e9 1c ff ff ff       	jmp    80314c <__divdi3+0x64>
  803230:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803234:	89 f1                	mov    %esi,%ecx
  803236:	d3 e2                	shl    %cl,%edx
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	73 eb                	jae    803227 <__divdi3+0x13f>
  80323c:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  80323f:	31 f6                	xor    %esi,%esi
  803241:	e9 06 ff ff ff       	jmp    80314c <__divdi3+0x64>
  803246:	66 90                	xchg   %ax,%ax
  803248:	31 c9                	xor    %ecx,%ecx
  80324a:	e9 fd fe ff ff       	jmp    80314c <__divdi3+0x64>
  80324f:	90                   	nop

00803250 <__udivdi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80325b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80325f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803263:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803267:	89 ca                	mov    %ecx,%edx
  803269:	89 f8                	mov    %edi,%eax
  80326b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80326f:	85 f6                	test   %esi,%esi
  803271:	75 2d                	jne    8032a0 <__udivdi3+0x50>
  803273:	39 cf                	cmp    %ecx,%edi
  803275:	77 65                	ja     8032dc <__udivdi3+0x8c>
  803277:	89 fd                	mov    %edi,%ebp
  803279:	85 ff                	test   %edi,%edi
  80327b:	75 0b                	jne    803288 <__udivdi3+0x38>
  80327d:	b8 01 00 00 00       	mov    $0x1,%eax
  803282:	31 d2                	xor    %edx,%edx
  803284:	f7 f7                	div    %edi
  803286:	89 c5                	mov    %eax,%ebp
  803288:	31 d2                	xor    %edx,%edx
  80328a:	89 c8                	mov    %ecx,%eax
  80328c:	f7 f5                	div    %ebp
  80328e:	89 c1                	mov    %eax,%ecx
  803290:	89 d8                	mov    %ebx,%eax
  803292:	f7 f5                	div    %ebp
  803294:	89 cf                	mov    %ecx,%edi
  803296:	89 fa                	mov    %edi,%edx
  803298:	83 c4 1c             	add    $0x1c,%esp
  80329b:	5b                   	pop    %ebx
  80329c:	5e                   	pop    %esi
  80329d:	5f                   	pop    %edi
  80329e:	5d                   	pop    %ebp
  80329f:	c3                   	ret    
  8032a0:	39 ce                	cmp    %ecx,%esi
  8032a2:	77 28                	ja     8032cc <__udivdi3+0x7c>
  8032a4:	0f bd fe             	bsr    %esi,%edi
  8032a7:	83 f7 1f             	xor    $0x1f,%edi
  8032aa:	75 40                	jne    8032ec <__udivdi3+0x9c>
  8032ac:	39 ce                	cmp    %ecx,%esi
  8032ae:	72 0a                	jb     8032ba <__udivdi3+0x6a>
  8032b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032b4:	0f 87 9e 00 00 00    	ja     803358 <__udivdi3+0x108>
  8032ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bf:	89 fa                	mov    %edi,%edx
  8032c1:	83 c4 1c             	add    $0x1c,%esp
  8032c4:	5b                   	pop    %ebx
  8032c5:	5e                   	pop    %esi
  8032c6:	5f                   	pop    %edi
  8032c7:	5d                   	pop    %ebp
  8032c8:	c3                   	ret    
  8032c9:	8d 76 00             	lea    0x0(%esi),%esi
  8032cc:	31 ff                	xor    %edi,%edi
  8032ce:	31 c0                	xor    %eax,%eax
  8032d0:	89 fa                	mov    %edi,%edx
  8032d2:	83 c4 1c             	add    $0x1c,%esp
  8032d5:	5b                   	pop    %ebx
  8032d6:	5e                   	pop    %esi
  8032d7:	5f                   	pop    %edi
  8032d8:	5d                   	pop    %ebp
  8032d9:	c3                   	ret    
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	89 d8                	mov    %ebx,%eax
  8032de:	f7 f7                	div    %edi
  8032e0:	31 ff                	xor    %edi,%edi
  8032e2:	89 fa                	mov    %edi,%edx
  8032e4:	83 c4 1c             	add    $0x1c,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    
  8032ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032f1:	89 eb                	mov    %ebp,%ebx
  8032f3:	29 fb                	sub    %edi,%ebx
  8032f5:	89 f9                	mov    %edi,%ecx
  8032f7:	d3 e6                	shl    %cl,%esi
  8032f9:	89 c5                	mov    %eax,%ebp
  8032fb:	88 d9                	mov    %bl,%cl
  8032fd:	d3 ed                	shr    %cl,%ebp
  8032ff:	89 e9                	mov    %ebp,%ecx
  803301:	09 f1                	or     %esi,%ecx
  803303:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803307:	89 f9                	mov    %edi,%ecx
  803309:	d3 e0                	shl    %cl,%eax
  80330b:	89 c5                	mov    %eax,%ebp
  80330d:	89 d6                	mov    %edx,%esi
  80330f:	88 d9                	mov    %bl,%cl
  803311:	d3 ee                	shr    %cl,%esi
  803313:	89 f9                	mov    %edi,%ecx
  803315:	d3 e2                	shl    %cl,%edx
  803317:	8b 44 24 08          	mov    0x8(%esp),%eax
  80331b:	88 d9                	mov    %bl,%cl
  80331d:	d3 e8                	shr    %cl,%eax
  80331f:	09 c2                	or     %eax,%edx
  803321:	89 d0                	mov    %edx,%eax
  803323:	89 f2                	mov    %esi,%edx
  803325:	f7 74 24 0c          	divl   0xc(%esp)
  803329:	89 d6                	mov    %edx,%esi
  80332b:	89 c3                	mov    %eax,%ebx
  80332d:	f7 e5                	mul    %ebp
  80332f:	39 d6                	cmp    %edx,%esi
  803331:	72 19                	jb     80334c <__udivdi3+0xfc>
  803333:	74 0b                	je     803340 <__udivdi3+0xf0>
  803335:	89 d8                	mov    %ebx,%eax
  803337:	31 ff                	xor    %edi,%edi
  803339:	e9 58 ff ff ff       	jmp    803296 <__udivdi3+0x46>
  80333e:	66 90                	xchg   %ax,%ax
  803340:	8b 54 24 08          	mov    0x8(%esp),%edx
  803344:	89 f9                	mov    %edi,%ecx
  803346:	d3 e2                	shl    %cl,%edx
  803348:	39 c2                	cmp    %eax,%edx
  80334a:	73 e9                	jae    803335 <__udivdi3+0xe5>
  80334c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80334f:	31 ff                	xor    %edi,%edi
  803351:	e9 40 ff ff ff       	jmp    803296 <__udivdi3+0x46>
  803356:	66 90                	xchg   %ax,%ax
  803358:	31 c0                	xor    %eax,%eax
  80335a:	e9 37 ff ff ff       	jmp    803296 <__udivdi3+0x46>
  80335f:	90                   	nop

00803360 <__umoddi3>:
  803360:	55                   	push   %ebp
  803361:	57                   	push   %edi
  803362:	56                   	push   %esi
  803363:	53                   	push   %ebx
  803364:	83 ec 1c             	sub    $0x1c,%esp
  803367:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80336b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80336f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803373:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80337b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80337f:	89 f3                	mov    %esi,%ebx
  803381:	89 fa                	mov    %edi,%edx
  803383:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803387:	89 34 24             	mov    %esi,(%esp)
  80338a:	85 c0                	test   %eax,%eax
  80338c:	75 1a                	jne    8033a8 <__umoddi3+0x48>
  80338e:	39 f7                	cmp    %esi,%edi
  803390:	0f 86 a2 00 00 00    	jbe    803438 <__umoddi3+0xd8>
  803396:	89 c8                	mov    %ecx,%eax
  803398:	89 f2                	mov    %esi,%edx
  80339a:	f7 f7                	div    %edi
  80339c:	89 d0                	mov    %edx,%eax
  80339e:	31 d2                	xor    %edx,%edx
  8033a0:	83 c4 1c             	add    $0x1c,%esp
  8033a3:	5b                   	pop    %ebx
  8033a4:	5e                   	pop    %esi
  8033a5:	5f                   	pop    %edi
  8033a6:	5d                   	pop    %ebp
  8033a7:	c3                   	ret    
  8033a8:	39 f0                	cmp    %esi,%eax
  8033aa:	0f 87 ac 00 00 00    	ja     80345c <__umoddi3+0xfc>
  8033b0:	0f bd e8             	bsr    %eax,%ebp
  8033b3:	83 f5 1f             	xor    $0x1f,%ebp
  8033b6:	0f 84 ac 00 00 00    	je     803468 <__umoddi3+0x108>
  8033bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8033c1:	29 ef                	sub    %ebp,%edi
  8033c3:	89 fe                	mov    %edi,%esi
  8033c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033c9:	89 e9                	mov    %ebp,%ecx
  8033cb:	d3 e0                	shl    %cl,%eax
  8033cd:	89 d7                	mov    %edx,%edi
  8033cf:	89 f1                	mov    %esi,%ecx
  8033d1:	d3 ef                	shr    %cl,%edi
  8033d3:	09 c7                	or     %eax,%edi
  8033d5:	89 e9                	mov    %ebp,%ecx
  8033d7:	d3 e2                	shl    %cl,%edx
  8033d9:	89 14 24             	mov    %edx,(%esp)
  8033dc:	89 d8                	mov    %ebx,%eax
  8033de:	d3 e0                	shl    %cl,%eax
  8033e0:	89 c2                	mov    %eax,%edx
  8033e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e6:	d3 e0                	shl    %cl,%eax
  8033e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033f0:	89 f1                	mov    %esi,%ecx
  8033f2:	d3 e8                	shr    %cl,%eax
  8033f4:	09 d0                	or     %edx,%eax
  8033f6:	d3 eb                	shr    %cl,%ebx
  8033f8:	89 da                	mov    %ebx,%edx
  8033fa:	f7 f7                	div    %edi
  8033fc:	89 d3                	mov    %edx,%ebx
  8033fe:	f7 24 24             	mull   (%esp)
  803401:	89 c6                	mov    %eax,%esi
  803403:	89 d1                	mov    %edx,%ecx
  803405:	39 d3                	cmp    %edx,%ebx
  803407:	0f 82 87 00 00 00    	jb     803494 <__umoddi3+0x134>
  80340d:	0f 84 91 00 00 00    	je     8034a4 <__umoddi3+0x144>
  803413:	8b 54 24 04          	mov    0x4(%esp),%edx
  803417:	29 f2                	sub    %esi,%edx
  803419:	19 cb                	sbb    %ecx,%ebx
  80341b:	89 d8                	mov    %ebx,%eax
  80341d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803421:	d3 e0                	shl    %cl,%eax
  803423:	89 e9                	mov    %ebp,%ecx
  803425:	d3 ea                	shr    %cl,%edx
  803427:	09 d0                	or     %edx,%eax
  803429:	89 e9                	mov    %ebp,%ecx
  80342b:	d3 eb                	shr    %cl,%ebx
  80342d:	89 da                	mov    %ebx,%edx
  80342f:	83 c4 1c             	add    $0x1c,%esp
  803432:	5b                   	pop    %ebx
  803433:	5e                   	pop    %esi
  803434:	5f                   	pop    %edi
  803435:	5d                   	pop    %ebp
  803436:	c3                   	ret    
  803437:	90                   	nop
  803438:	89 fd                	mov    %edi,%ebp
  80343a:	85 ff                	test   %edi,%edi
  80343c:	75 0b                	jne    803449 <__umoddi3+0xe9>
  80343e:	b8 01 00 00 00       	mov    $0x1,%eax
  803443:	31 d2                	xor    %edx,%edx
  803445:	f7 f7                	div    %edi
  803447:	89 c5                	mov    %eax,%ebp
  803449:	89 f0                	mov    %esi,%eax
  80344b:	31 d2                	xor    %edx,%edx
  80344d:	f7 f5                	div    %ebp
  80344f:	89 c8                	mov    %ecx,%eax
  803451:	f7 f5                	div    %ebp
  803453:	89 d0                	mov    %edx,%eax
  803455:	e9 44 ff ff ff       	jmp    80339e <__umoddi3+0x3e>
  80345a:	66 90                	xchg   %ax,%ax
  80345c:	89 c8                	mov    %ecx,%eax
  80345e:	89 f2                	mov    %esi,%edx
  803460:	83 c4 1c             	add    $0x1c,%esp
  803463:	5b                   	pop    %ebx
  803464:	5e                   	pop    %esi
  803465:	5f                   	pop    %edi
  803466:	5d                   	pop    %ebp
  803467:	c3                   	ret    
  803468:	3b 04 24             	cmp    (%esp),%eax
  80346b:	72 06                	jb     803473 <__umoddi3+0x113>
  80346d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803471:	77 0f                	ja     803482 <__umoddi3+0x122>
  803473:	89 f2                	mov    %esi,%edx
  803475:	29 f9                	sub    %edi,%ecx
  803477:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80347b:	89 14 24             	mov    %edx,(%esp)
  80347e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803482:	8b 44 24 04          	mov    0x4(%esp),%eax
  803486:	8b 14 24             	mov    (%esp),%edx
  803489:	83 c4 1c             	add    $0x1c,%esp
  80348c:	5b                   	pop    %ebx
  80348d:	5e                   	pop    %esi
  80348e:	5f                   	pop    %edi
  80348f:	5d                   	pop    %ebp
  803490:	c3                   	ret    
  803491:	8d 76 00             	lea    0x0(%esi),%esi
  803494:	2b 04 24             	sub    (%esp),%eax
  803497:	19 fa                	sbb    %edi,%edx
  803499:	89 d1                	mov    %edx,%ecx
  80349b:	89 c6                	mov    %eax,%esi
  80349d:	e9 71 ff ff ff       	jmp    803413 <__umoddi3+0xb3>
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034a8:	72 ea                	jb     803494 <__umoddi3+0x134>
  8034aa:	89 d9                	mov    %ebx,%ecx
  8034ac:	e9 62 ff ff ff       	jmp    803413 <__umoddi3+0xb3>
