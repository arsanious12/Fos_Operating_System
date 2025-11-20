
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 b7 1e 00 00       	call   801efd <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 31 80 00       	push   $0x803160
  80004e:	e8 97 0b 00 00       	call   800bea <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 31 80 00       	push   $0x803162
  80005e:	e8 87 0b 00 00       	call   800bea <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 31 80 00       	push   $0x803178
  80006e:	e8 77 0b 00 00       	call   800bea <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 31 80 00       	push   $0x803162
  80007e:	e8 67 0b 00 00       	call   800bea <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 31 80 00       	push   $0x803160
  80008e:	e8 57 0b 00 00       	call   800bea <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 31 80 00       	push   $0x803190
  8000a5:	e8 19 12 00 00       	call   8012c3 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 b0 31 80 00       	push   $0x8031b0
  8000b5:	e8 30 0b 00 00       	call   800bea <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 d2 31 80 00       	push   $0x8031d2
  8000c5:	e8 20 0b 00 00       	call   800bea <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 e0 31 80 00       	push   $0x8031e0
  8000d5:	e8 10 0b 00 00       	call   800bea <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 ef 31 80 00       	push   $0x8031ef
  8000e5:	e8 00 0b 00 00       	call   800bea <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 ff 31 80 00       	push   $0x8031ff
  8000f5:	e8 f0 0a 00 00       	call   800bea <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 de 1d 00 00       	call   801f17 <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 8e 17 00 00       	call   8018da <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 53 1c 00 00       	call   801db4 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 08 32 80 00       	push   $0x803208
  8001df:	e8 78 0a 00 00       	call   800c5c <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 3c 32 80 00       	push   $0x80323c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 5e 32 80 00       	push   $0x80325e
  800210:	e8 07 07 00 00       	call   80091c <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 e3 1c 00 00       	call   801efd <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 7c 32 80 00       	push   $0x80327c
  800222:	e8 c3 09 00 00       	call   800bea <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b0 32 80 00       	push   $0x8032b0
  800232:	e8 b3 09 00 00       	call   800bea <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e4 32 80 00       	push   $0x8032e4
  800242:	e8 a3 09 00 00       	call   800bea <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 c8 1c 00 00       	call   801f17 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 88 1b 00 00       	call   801de2 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 9b 1c 00 00       	call   801efd <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 16 33 80 00       	push   $0x803316
  800270:	e8 75 09 00 00       	call   800bea <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 5c 1c 00 00       	call   801f17 <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 60 31 80 00       	push   $0x803160
  80044f:	e8 96 07 00 00       	call   800bea <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 34 33 80 00       	push   $0x803334
  800471:	e8 74 07 00 00       	call   800bea <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 39 33 80 00       	push   $0x803339
  80049f:	e8 46 07 00 00       	call   800bea <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 6f 18 00 00       	call   801db4 <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 5a 18 00 00       	call   801db4 <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 db 16 00 00       	call   801de2 <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 cd 16 00 00       	call   801de2 <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 11 19 00 00       	call   802045 <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 9f 17 00 00       	call   801ee4 <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	57                   	push   %edi
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800760:	e8 11 1a 00 00       	call   802176 <sys_getenvindex>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	c1 e0 06             	shl    $0x6,%eax
  800770:	29 d0                	sub    %edx,%eax
  800772:	c1 e0 02             	shl    $0x2,%eax
  800775:	01 d0                	add    %edx,%eax
  800777:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80077e:	01 c8                	add    %ecx,%eax
  800780:	c1 e0 03             	shl    $0x3,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078c:	29 c2                	sub    %eax,%edx
  80078e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800795:	89 c2                	mov    %eax,%edx
  800797:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80079d:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007a2:	a1 24 40 80 00       	mov    0x804024,%eax
  8007a7:	8a 40 20             	mov    0x20(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	74 0d                	je     8007bb <libmain+0x64>
		binaryname = myEnv->prog_name;
  8007ae:	a1 24 40 80 00       	mov    0x804024,%eax
  8007b3:	83 c0 20             	add    $0x20,%eax
  8007b6:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007bf:	7e 0a                	jle    8007cb <libmain+0x74>
		binaryname = argv[0];
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	e8 5f f8 ff ff       	call   800038 <_main>
  8007d9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007dc:	a1 00 40 80 00       	mov    0x804000,%eax
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	0f 84 01 01 00 00    	je     8008ea <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ef:	bb 38 34 80 00       	mov    $0x803438,%ebx
  8007f4:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007f9:	89 c7                	mov    %eax,%edi
  8007fb:	89 de                	mov    %ebx,%esi
  8007fd:	89 d1                	mov    %edx,%ecx
  8007ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800801:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800804:	b9 56 00 00 00       	mov    $0x56,%ecx
  800809:	b0 00                	mov    $0x0,%al
  80080b:	89 d7                	mov    %edx,%edi
  80080d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80080f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800816:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	50                   	push   %eax
  80081d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800823:	50                   	push   %eax
  800824:	e8 83 1b 00 00       	call   8023ac <sys_utilities>
  800829:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80082c:	e8 cc 16 00 00       	call   801efd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800831:	83 ec 0c             	sub    $0xc,%esp
  800834:	68 58 33 80 00       	push   $0x803358
  800839:	e8 ac 03 00 00       	call   800bea <cprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800844:	85 c0                	test   %eax,%eax
  800846:	74 18                	je     800860 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800848:	e8 7d 1b 00 00       	call   8023ca <sys_get_optimal_num_faults>
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	50                   	push   %eax
  800851:	68 80 33 80 00       	push   $0x803380
  800856:	e8 8f 03 00 00       	call   800bea <cprintf>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	eb 59                	jmp    8008b9 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800860:	a1 24 40 80 00       	mov    0x804024,%eax
  800865:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80086b:	a1 24 40 80 00       	mov    0x804024,%eax
  800870:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	52                   	push   %edx
  80087a:	50                   	push   %eax
  80087b:	68 a4 33 80 00       	push   $0x8033a4
  800880:	e8 65 03 00 00       	call   800bea <cprintf>
  800885:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800888:	a1 24 40 80 00       	mov    0x804024,%eax
  80088d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800893:	a1 24 40 80 00       	mov    0x804024,%eax
  800898:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80089e:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a3:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8008a9:	51                   	push   %ecx
  8008aa:	52                   	push   %edx
  8008ab:	50                   	push   %eax
  8008ac:	68 cc 33 80 00       	push   $0x8033cc
  8008b1:	e8 34 03 00 00       	call   800bea <cprintf>
  8008b6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008b9:	a1 24 40 80 00       	mov    0x804024,%eax
  8008be:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	50                   	push   %eax
  8008c8:	68 24 34 80 00       	push   $0x803424
  8008cd:	e8 18 03 00 00       	call   800bea <cprintf>
  8008d2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	68 58 33 80 00       	push   $0x803358
  8008dd:	e8 08 03 00 00       	call   800bea <cprintf>
  8008e2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008e5:	e8 2d 16 00 00       	call   801f17 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008ea:	e8 1f 00 00 00       	call   80090e <exit>
}
  8008ef:	90                   	nop
  8008f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f3:	5b                   	pop    %ebx
  8008f4:	5e                   	pop    %esi
  8008f5:	5f                   	pop    %edi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008fe:	83 ec 0c             	sub    $0xc,%esp
  800901:	6a 00                	push   $0x0
  800903:	e8 3a 18 00 00       	call   802142 <sys_destroy_env>
  800908:	83 c4 10             	add    $0x10,%esp
}
  80090b:	90                   	nop
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <exit>:

void
exit(void)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800914:	e8 8f 18 00 00       	call   8021a8 <sys_exit_env>
}
  800919:	90                   	nop
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800922:	8d 45 10             	lea    0x10(%ebp),%eax
  800925:	83 c0 04             	add    $0x4,%eax
  800928:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80092b:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800930:	85 c0                	test   %eax,%eax
  800932:	74 16                	je     80094a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800934:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	50                   	push   %eax
  80093d:	68 9c 34 80 00       	push   $0x80349c
  800942:	e8 a3 02 00 00       	call   800bea <cprintf>
  800947:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80094a:	a1 04 40 80 00       	mov    0x804004,%eax
  80094f:	83 ec 0c             	sub    $0xc,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	ff 75 08             	pushl  0x8(%ebp)
  800958:	50                   	push   %eax
  800959:	68 a4 34 80 00       	push   $0x8034a4
  80095e:	6a 74                	push   $0x74
  800960:	e8 b2 02 00 00       	call   800c17 <cprintf_colored>
  800965:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800968:	8b 45 10             	mov    0x10(%ebp),%eax
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 f4             	pushl  -0xc(%ebp)
  800971:	50                   	push   %eax
  800972:	e8 04 02 00 00       	call   800b7b <vcprintf>
  800977:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	6a 00                	push   $0x0
  80097f:	68 cc 34 80 00       	push   $0x8034cc
  800984:	e8 f2 01 00 00       	call   800b7b <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80098c:	e8 7d ff ff ff       	call   80090e <exit>

	// should not return here
	while (1) ;
  800991:	eb fe                	jmp    800991 <_panic+0x75>

00800993 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800999:	a1 24 40 80 00       	mov    0x804024,%eax
  80099e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	39 c2                	cmp    %eax,%edx
  8009a9:	74 14                	je     8009bf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009ab:	83 ec 04             	sub    $0x4,%esp
  8009ae:	68 d0 34 80 00       	push   $0x8034d0
  8009b3:	6a 26                	push   $0x26
  8009b5:	68 1c 35 80 00       	push   $0x80351c
  8009ba:	e8 5d ff ff ff       	call   80091c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009cd:	e9 c5 00 00 00       	jmp    800a97 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	75 08                	jne    8009ef <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009e7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009ea:	e9 a5 00 00 00       	jmp    800a94 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009fd:	eb 69                	jmp    800a68 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ff:	a1 24 40 80 00       	mov    0x804024,%eax
  800a04:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	01 c0                	add    %eax,%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	c1 e0 03             	shl    $0x3,%eax
  800a16:	01 c8                	add    %ecx,%eax
  800a18:	8a 40 04             	mov    0x4(%eax),%al
  800a1b:	84 c0                	test   %al,%al
  800a1d:	75 46                	jne    800a65 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a1f:	a1 24 40 80 00       	mov    0x804024,%eax
  800a24:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	01 c0                	add    %eax,%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	c1 e0 03             	shl    $0x3,%eax
  800a36:	01 c8                	add    %ecx,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a45:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	01 c8                	add    %ecx,%eax
  800a56:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a58:	39 c2                	cmp    %eax,%edx
  800a5a:	75 09                	jne    800a65 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a5c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a63:	eb 15                	jmp    800a7a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a65:	ff 45 e8             	incl   -0x18(%ebp)
  800a68:	a1 24 40 80 00       	mov    0x804024,%eax
  800a6d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a76:	39 c2                	cmp    %eax,%edx
  800a78:	77 85                	ja     8009ff <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a7e:	75 14                	jne    800a94 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a80:	83 ec 04             	sub    $0x4,%esp
  800a83:	68 28 35 80 00       	push   $0x803528
  800a88:	6a 3a                	push   $0x3a
  800a8a:	68 1c 35 80 00       	push   $0x80351c
  800a8f:	e8 88 fe ff ff       	call   80091c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a94:	ff 45 f0             	incl   -0x10(%ebp)
  800a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a9d:	0f 8c 2f ff ff ff    	jl     8009d2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800aa3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aaa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ab1:	eb 26                	jmp    800ad9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ab3:	a1 24 40 80 00       	mov    0x804024,%eax
  800ab8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800abe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ac1:	89 d0                	mov    %edx,%eax
  800ac3:	01 c0                	add    %eax,%eax
  800ac5:	01 d0                	add    %edx,%eax
  800ac7:	c1 e0 03             	shl    $0x3,%eax
  800aca:	01 c8                	add    %ecx,%eax
  800acc:	8a 40 04             	mov    0x4(%eax),%al
  800acf:	3c 01                	cmp    $0x1,%al
  800ad1:	75 03                	jne    800ad6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ad3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad6:	ff 45 e0             	incl   -0x20(%ebp)
  800ad9:	a1 24 40 80 00       	mov    0x804024,%eax
  800ade:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae7:	39 c2                	cmp    %eax,%edx
  800ae9:	77 c8                	ja     800ab3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800af1:	74 14                	je     800b07 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	68 7c 35 80 00       	push   $0x80357c
  800afb:	6a 44                	push   $0x44
  800afd:	68 1c 35 80 00       	push   $0x80351c
  800b02:	e8 15 fe ff ff       	call   80091c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b07:	90                   	nop
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 48 01             	lea    0x1(%eax),%ecx
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 0a                	mov    %ecx,(%edx)
  800b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b21:	88 d1                	mov    %dl,%cl
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b34:	75 30                	jne    800b66 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b36:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b3c:	a0 44 40 80 00       	mov    0x804044,%al
  800b41:	0f b6 c0             	movzbl %al,%eax
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	8b 09                	mov    (%ecx),%ecx
  800b49:	89 cb                	mov    %ecx,%ebx
  800b4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4e:	83 c1 08             	add    $0x8,%ecx
  800b51:	52                   	push   %edx
  800b52:	50                   	push   %eax
  800b53:	53                   	push   %ebx
  800b54:	51                   	push   %ecx
  800b55:	e8 5f 13 00 00       	call   801eb9 <sys_cputs>
  800b5a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b75:	90                   	nop
  800b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b84:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b8b:	00 00 00 
	b.cnt = 0;
  800b8e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b95:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba4:	50                   	push   %eax
  800ba5:	68 0a 0b 80 00       	push   $0x800b0a
  800baa:	e8 5a 02 00 00       	call   800e09 <vprintfmt>
  800baf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bb2:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bb8:	a0 44 40 80 00       	mov    0x804044,%al
  800bbd:	0f b6 c0             	movzbl %al,%eax
  800bc0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bc6:	52                   	push   %edx
  800bc7:	50                   	push   %eax
  800bc8:	51                   	push   %ecx
  800bc9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bcf:	83 c0 08             	add    $0x8,%eax
  800bd2:	50                   	push   %eax
  800bd3:	e8 e1 12 00 00       	call   801eb9 <sys_cputs>
  800bd8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bdb:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800be2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bf0:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800bf7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	50                   	push   %eax
  800c07:	e8 6f ff ff ff       	call   800b7b <vcprintf>
  800c0c:	83 c4 10             	add    $0x10,%esp
  800c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c1d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	c1 e0 08             	shl    $0x8,%eax
  800c2a:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c2f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c32:	83 c0 04             	add    $0x4,%eax
  800c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	e8 34 ff ff ff       	call   800b7b <vcprintf>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c4d:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c54:	07 00 00 

	return cnt;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c62:	e8 96 12 00 00       	call   801efd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c67:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 f4             	pushl  -0xc(%ebp)
  800c76:	50                   	push   %eax
  800c77:	e8 ff fe ff ff       	call   800b7b <vcprintf>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c82:	e8 90 12 00 00       	call   801f17 <sys_unlock_cons>
	return cnt;
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 14             	sub    $0x14,%esp
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c9f:	8b 45 18             	mov    0x18(%ebp),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800caa:	77 55                	ja     800d01 <printnum+0x75>
  800cac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800caf:	72 05                	jb     800cb6 <printnum+0x2a>
  800cb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cb4:	77 4b                	ja     800d01 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cb6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cbc:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	52                   	push   %edx
  800cc5:	50                   	push   %eax
  800cc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccc:	e8 0f 22 00 00       	call   802ee0 <__udivdi3>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	83 ec 04             	sub    $0x4,%esp
  800cd7:	ff 75 20             	pushl  0x20(%ebp)
  800cda:	53                   	push   %ebx
  800cdb:	ff 75 18             	pushl  0x18(%ebp)
  800cde:	52                   	push   %edx
  800cdf:	50                   	push   %eax
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	ff 75 08             	pushl  0x8(%ebp)
  800ce6:	e8 a1 ff ff ff       	call   800c8c <printnum>
  800ceb:	83 c4 20             	add    $0x20,%esp
  800cee:	eb 1a                	jmp    800d0a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	ff 75 20             	pushl  0x20(%ebp)
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d01:	ff 4d 1c             	decl   0x1c(%ebp)
  800d04:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d08:	7f e6                	jg     800cf0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d0a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d18:	53                   	push   %ebx
  800d19:	51                   	push   %ecx
  800d1a:	52                   	push   %edx
  800d1b:	50                   	push   %eax
  800d1c:	e8 cf 22 00 00       	call   802ff0 <__umoddi3>
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	05 f4 37 80 00       	add    $0x8037f4,%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f be c0             	movsbl %al,%eax
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	50                   	push   %eax
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	ff d0                	call   *%eax
  800d3a:	83 c4 10             	add    $0x10,%esp
}
  800d3d:	90                   	nop
  800d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d4a:	7e 1c                	jle    800d68 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	8d 50 08             	lea    0x8(%eax),%edx
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 10                	mov    %edx,(%eax)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	83 e8 08             	sub    $0x8,%eax
  800d61:	8b 50 04             	mov    0x4(%eax),%edx
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	eb 40                	jmp    800da8 <getuint+0x65>
	else if (lflag)
  800d68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6c:	74 1e                	je     800d8c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8b 00                	mov    (%eax),%eax
  800d73:	8d 50 04             	lea    0x4(%eax),%edx
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 10                	mov    %edx,(%eax)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8b 00                	mov    (%eax),%eax
  800d80:	83 e8 04             	sub    $0x4,%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8a:	eb 1c                	jmp    800da8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	8d 50 04             	lea    0x4(%eax),%edx
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 10                	mov    %edx,(%eax)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	83 e8 04             	sub    $0x4,%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800db1:	7e 1c                	jle    800dcf <getint+0x25>
		return va_arg(*ap, long long);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 08             	lea    0x8(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 08             	sub    $0x8,%eax
  800dc8:	8b 50 04             	mov    0x4(%eax),%edx
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	eb 38                	jmp    800e07 <getint+0x5d>
	else if (lflag)
  800dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd3:	74 1a                	je     800def <getint+0x45>
		return va_arg(*ap, long);
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8b 00                	mov    (%eax),%eax
  800dda:	8d 50 04             	lea    0x4(%eax),%edx
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 10                	mov    %edx,(%eax)
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	99                   	cltd   
  800ded:	eb 18                	jmp    800e07 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	8d 50 04             	lea    0x4(%eax),%edx
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 10                	mov    %edx,(%eax)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	83 e8 04             	sub    $0x4,%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	99                   	cltd   
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e11:	eb 17                	jmp    800e2a <vprintfmt+0x21>
			if (ch == '\0')
  800e13:	85 db                	test   %ebx,%ebx
  800e15:	0f 84 c1 03 00 00    	je     8011dc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	53                   	push   %ebx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	8d 50 01             	lea    0x1(%eax),%edx
  800e30:	89 55 10             	mov    %edx,0x10(%ebp)
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d8             	movzbl %al,%ebx
  800e38:	83 fb 25             	cmp    $0x25,%ebx
  800e3b:	75 d6                	jne    800e13 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e3d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e41:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e4f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e60:	8d 50 01             	lea    0x1(%eax),%edx
  800e63:	89 55 10             	mov    %edx,0x10(%ebp)
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	0f b6 d8             	movzbl %al,%ebx
  800e6b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e6e:	83 f8 5b             	cmp    $0x5b,%eax
  800e71:	0f 87 3d 03 00 00    	ja     8011b4 <vprintfmt+0x3ab>
  800e77:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  800e7e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e80:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e84:	eb d7                	jmp    800e5d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e86:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e8a:	eb d1                	jmp    800e5d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	c1 e0 02             	shl    $0x2,%eax
  800e9b:	01 d0                	add    %edx,%eax
  800e9d:	01 c0                	add    %eax,%eax
  800e9f:	01 d8                	add    %ebx,%eax
  800ea1:	83 e8 30             	sub    $0x30,%eax
  800ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eaf:	83 fb 2f             	cmp    $0x2f,%ebx
  800eb2:	7e 3e                	jle    800ef2 <vprintfmt+0xe9>
  800eb4:	83 fb 39             	cmp    $0x39,%ebx
  800eb7:	7f 39                	jg     800ef2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ebc:	eb d5                	jmp    800e93 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec1:	83 c0 04             	add    $0x4,%eax
  800ec4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eca:	83 e8 04             	sub    $0x4,%eax
  800ecd:	8b 00                	mov    (%eax),%eax
  800ecf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ed2:	eb 1f                	jmp    800ef3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ed4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed8:	79 83                	jns    800e5d <vprintfmt+0x54>
				width = 0;
  800eda:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ee1:	e9 77 ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ee6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eed:	e9 6b ff ff ff       	jmp    800e5d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ef2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef7:	0f 89 60 ff ff ff    	jns    800e5d <vprintfmt+0x54>
				width = precision, precision = -1;
  800efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f03:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f0a:	e9 4e ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f0f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f12:	e9 46 ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	83 c0 04             	add    $0x4,%eax
  800f1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f20:	8b 45 14             	mov    0x14(%ebp),%eax
  800f23:	83 e8 04             	sub    $0x4,%eax
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	50                   	push   %eax
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	ff d0                	call   *%eax
  800f34:	83 c4 10             	add    $0x10,%esp
			break;
  800f37:	e9 9b 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 14             	mov    %eax,0x14(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 e8 04             	sub    $0x4,%eax
  800f4b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	79 02                	jns    800f53 <vprintfmt+0x14a>
				err = -err;
  800f51:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f53:	83 fb 64             	cmp    $0x64,%ebx
  800f56:	7f 0b                	jg     800f63 <vprintfmt+0x15a>
  800f58:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800f5f:	85 f6                	test   %esi,%esi
  800f61:	75 19                	jne    800f7c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f63:	53                   	push   %ebx
  800f64:	68 05 38 80 00       	push   $0x803805
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	ff 75 08             	pushl  0x8(%ebp)
  800f6f:	e8 70 02 00 00       	call   8011e4 <printfmt>
  800f74:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f77:	e9 5b 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f7c:	56                   	push   %esi
  800f7d:	68 0e 38 80 00       	push   $0x80380e
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 57 02 00 00       	call   8011e4 <printfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
			break;
  800f90:	e9 42 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	83 c0 04             	add    $0x4,%eax
  800f9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	83 e8 04             	sub    $0x4,%eax
  800fa4:	8b 30                	mov    (%eax),%esi
  800fa6:	85 f6                	test   %esi,%esi
  800fa8:	75 05                	jne    800faf <vprintfmt+0x1a6>
				p = "(null)";
  800faa:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  800faf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb3:	7e 6d                	jle    801022 <vprintfmt+0x219>
  800fb5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb9:	74 67                	je     801022 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	50                   	push   %eax
  800fc2:	56                   	push   %esi
  800fc3:	e8 26 05 00 00       	call   8014ee <strnlen>
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fce:	eb 16                	jmp    800fe6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fd0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe3:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fea:	7f e4                	jg     800fd0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fec:	eb 34                	jmp    801022 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff2:	74 1c                	je     801010 <vprintfmt+0x207>
  800ff4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff7:	7e 05                	jle    800ffe <vprintfmt+0x1f5>
  800ff9:	83 fb 7e             	cmp    $0x7e,%ebx
  800ffc:	7e 12                	jle    801010 <vprintfmt+0x207>
					putch('?', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 3f                	push   $0x3f
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	eb 0f                	jmp    80101f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	53                   	push   %ebx
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	ff d0                	call   *%eax
  80101c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80101f:	ff 4d e4             	decl   -0x1c(%ebp)
  801022:	89 f0                	mov    %esi,%eax
  801024:	8d 70 01             	lea    0x1(%eax),%esi
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f be d8             	movsbl %al,%ebx
  80102c:	85 db                	test   %ebx,%ebx
  80102e:	74 24                	je     801054 <vprintfmt+0x24b>
  801030:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801034:	78 b8                	js     800fee <vprintfmt+0x1e5>
  801036:	ff 4d e0             	decl   -0x20(%ebp)
  801039:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80103d:	79 af                	jns    800fee <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103f:	eb 13                	jmp    801054 <vprintfmt+0x24b>
				putch(' ', putdat);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 0c             	pushl  0xc(%ebp)
  801047:	6a 20                	push   $0x20
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	ff d0                	call   *%eax
  80104e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801051:	ff 4d e4             	decl   -0x1c(%ebp)
  801054:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801058:	7f e7                	jg     801041 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80105a:	e9 78 01 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80105f:	83 ec 08             	sub    $0x8,%esp
  801062:	ff 75 e8             	pushl  -0x18(%ebp)
  801065:	8d 45 14             	lea    0x14(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	e8 3c fd ff ff       	call   800daa <getint>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107d:	85 d2                	test   %edx,%edx
  80107f:	79 23                	jns    8010a4 <vprintfmt+0x29b>
				putch('-', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 2d                	push   $0x2d
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801097:	f7 d8                	neg    %eax
  801099:	83 d2 00             	adc    $0x0,%edx
  80109c:	f7 da                	neg    %edx
  80109e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ab:	e9 bc 00 00 00       	jmp    80116c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	e8 84 fc ff ff       	call   800d43 <getuint>
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010cf:	e9 98 00 00 00       	jmp    80116c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	6a 58                	push   $0x58
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	ff d0                	call   *%eax
  8010e1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	6a 58                	push   $0x58
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	ff d0                	call   *%eax
  8010f1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	6a 58                	push   $0x58
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	ff d0                	call   *%eax
  801101:	83 c4 10             	add    $0x10,%esp
			break;
  801104:	e9 ce 00 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	6a 30                	push   $0x30
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	ff d0                	call   *%eax
  801116:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	6a 78                	push   $0x78
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	ff d0                	call   *%eax
  801126:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801129:	8b 45 14             	mov    0x14(%ebp),%eax
  80112c:	83 c0 04             	add    $0x4,%eax
  80112f:	89 45 14             	mov    %eax,0x14(%ebp)
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	83 e8 04             	sub    $0x4,%eax
  801138:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80113a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801144:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80114b:	eb 1f                	jmp    80116c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	ff 75 e8             	pushl  -0x18(%ebp)
  801153:	8d 45 14             	lea    0x14(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	e8 e7 fb ff ff       	call   800d43 <getuint>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801162:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801165:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80116c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	52                   	push   %edx
  801177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117a:	50                   	push   %eax
  80117b:	ff 75 f4             	pushl  -0xc(%ebp)
  80117e:	ff 75 f0             	pushl  -0x10(%ebp)
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	ff 75 08             	pushl  0x8(%ebp)
  801187:	e8 00 fb ff ff       	call   800c8c <printnum>
  80118c:	83 c4 20             	add    $0x20,%esp
			break;
  80118f:	eb 46                	jmp    8011d7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801191:	83 ec 08             	sub    $0x8,%esp
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	53                   	push   %ebx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			break;
  8011a0:	eb 35                	jmp    8011d7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011a2:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011a9:	eb 2c                	jmp    8011d7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011ab:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011b2:	eb 23                	jmp    8011d7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	6a 25                	push   $0x25
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	ff d0                	call   *%eax
  8011c1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011c4:	ff 4d 10             	decl   0x10(%ebp)
  8011c7:	eb 03                	jmp    8011cc <vprintfmt+0x3c3>
  8011c9:	ff 4d 10             	decl   0x10(%ebp)
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	48                   	dec    %eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 25                	cmp    $0x25,%al
  8011d4:	75 f3                	jne    8011c9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011d6:	90                   	nop
		}
	}
  8011d7:	e9 35 fc ff ff       	jmp    800e11 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011dc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e0:	5b                   	pop    %ebx
  8011e1:	5e                   	pop    %esi
  8011e2:	5d                   	pop    %ebp
  8011e3:	c3                   	ret    

008011e4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ea:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ed:	83 c0 04             	add    $0x4,%eax
  8011f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f9:	50                   	push   %eax
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 04 fc ff ff       	call   800e09 <vprintfmt>
  801205:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	8b 40 08             	mov    0x8(%eax),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	8b 10                	mov    (%eax),%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	8b 40 04             	mov    0x4(%eax),%eax
  801228:	39 c2                	cmp    %eax,%edx
  80122a:	73 12                	jae    80123e <sprintputch+0x33>
		*b->buf++ = ch;
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 48 01             	lea    0x1(%eax),%ecx
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	89 0a                	mov    %ecx,(%edx)
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	88 10                	mov    %dl,(%eax)
}
  80123e:	90                   	nop
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    

00801241 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801262:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801266:	74 06                	je     80126e <vsnprintf+0x2d>
  801268:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126c:	7f 07                	jg     801275 <vsnprintf+0x34>
		return -E_INVAL;
  80126e:	b8 03 00 00 00       	mov    $0x3,%eax
  801273:	eb 20                	jmp    801295 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801275:	ff 75 14             	pushl  0x14(%ebp)
  801278:	ff 75 10             	pushl  0x10(%ebp)
  80127b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	68 0b 12 80 00       	push   $0x80120b
  801284:	e8 80 fb ff ff       	call   800e09 <vprintfmt>
  801289:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80128c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80128f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801292:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80129d:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a0:	83 c0 04             	add    $0x4,%eax
  8012a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ac:	50                   	push   %eax
  8012ad:	ff 75 0c             	pushl  0xc(%ebp)
  8012b0:	ff 75 08             	pushl  0x8(%ebp)
  8012b3:	e8 89 ff ff ff       	call   801241 <vsnprintf>
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012cd:	74 13                	je     8012e2 <readline+0x1f>
		cprintf("%s", prompt);
  8012cf:	83 ec 08             	sub    $0x8,%esp
  8012d2:	ff 75 08             	pushl  0x8(%ebp)
  8012d5:	68 88 39 80 00       	push   $0x803988
  8012da:	e8 0b f9 ff ff       	call   800bea <cprintf>
  8012df:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	6a 00                	push   $0x0
  8012ee:	e8 5a f4 ff ff       	call   80074d <iscons>
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012f9:	e8 3c f4 ff ff       	call   80073a <getchar>
  8012fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801301:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801305:	79 22                	jns    801329 <readline+0x66>
			if (c != -E_EOF)
  801307:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80130b:	0f 84 ad 00 00 00    	je     8013be <readline+0xfb>
				cprintf("read error: %e\n", c);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 ec             	pushl  -0x14(%ebp)
  801317:	68 8b 39 80 00       	push   $0x80398b
  80131c:	e8 c9 f8 ff ff       	call   800bea <cprintf>
  801321:	83 c4 10             	add    $0x10,%esp
			break;
  801324:	e9 95 00 00 00       	jmp    8013be <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801329:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80132d:	7e 34                	jle    801363 <readline+0xa0>
  80132f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801336:	7f 2b                	jg     801363 <readline+0xa0>
			if (echoing)
  801338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133c:	74 0e                	je     80134c <readline+0x89>
				cputchar(c);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	ff 75 ec             	pushl  -0x14(%ebp)
  801344:	e8 d2 f3 ff ff       	call   80071b <cputchar>
  801349:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134f:	8d 50 01             	lea    0x1(%eax),%edx
  801352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80135f:	88 10                	mov    %dl,(%eax)
  801361:	eb 56                	jmp    8013b9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801363:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801367:	75 1f                	jne    801388 <readline+0xc5>
  801369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80136d:	7e 19                	jle    801388 <readline+0xc5>
			if (echoing)
  80136f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801373:	74 0e                	je     801383 <readline+0xc0>
				cputchar(c);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 ec             	pushl  -0x14(%ebp)
  80137b:	e8 9b f3 ff ff       	call   80071b <cputchar>
  801380:	83 c4 10             	add    $0x10,%esp

			i--;
  801383:	ff 4d f4             	decl   -0xc(%ebp)
  801386:	eb 31                	jmp    8013b9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801388:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80138c:	74 0a                	je     801398 <readline+0xd5>
  80138e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801392:	0f 85 61 ff ff ff    	jne    8012f9 <readline+0x36>
			if (echoing)
  801398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139c:	74 0e                	je     8013ac <readline+0xe9>
				cputchar(c);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a4:	e8 72 f3 ff ff       	call   80071b <cputchar>
  8013a9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013b7:	eb 06                	jmp    8013bf <readline+0xfc>
		}
	}
  8013b9:	e9 3b ff ff ff       	jmp    8012f9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013be:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013bf:	90                   	nop
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013c8:	e8 30 0b 00 00       	call   801efd <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d1:	74 13                	je     8013e6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	68 88 39 80 00       	push   $0x803988
  8013de:	e8 07 f8 ff ff       	call   800bea <cprintf>
  8013e3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	6a 00                	push   $0x0
  8013f2:	e8 56 f3 ff ff       	call   80074d <iscons>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013fd:	e8 38 f3 ff ff       	call   80073a <getchar>
  801402:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801409:	79 22                	jns    80142d <atomic_readline+0x6b>
				if (c != -E_EOF)
  80140b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80140f:	0f 84 ad 00 00 00    	je     8014c2 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 ec             	pushl  -0x14(%ebp)
  80141b:	68 8b 39 80 00       	push   $0x80398b
  801420:	e8 c5 f7 ff ff       	call   800bea <cprintf>
  801425:	83 c4 10             	add    $0x10,%esp
				break;
  801428:	e9 95 00 00 00       	jmp    8014c2 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80142d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801431:	7e 34                	jle    801467 <atomic_readline+0xa5>
  801433:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80143a:	7f 2b                	jg     801467 <atomic_readline+0xa5>
				if (echoing)
  80143c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801440:	74 0e                	je     801450 <atomic_readline+0x8e>
					cputchar(c);
  801442:	83 ec 0c             	sub    $0xc,%esp
  801445:	ff 75 ec             	pushl  -0x14(%ebp)
  801448:	e8 ce f2 ff ff       	call   80071b <cputchar>
  80144d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801453:	8d 50 01             	lea    0x1(%eax),%edx
  801456:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801459:	89 c2                	mov    %eax,%edx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801463:	88 10                	mov    %dl,(%eax)
  801465:	eb 56                	jmp    8014bd <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801467:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80146b:	75 1f                	jne    80148c <atomic_readline+0xca>
  80146d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801471:	7e 19                	jle    80148c <atomic_readline+0xca>
				if (echoing)
  801473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801477:	74 0e                	je     801487 <atomic_readline+0xc5>
					cputchar(c);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	ff 75 ec             	pushl  -0x14(%ebp)
  80147f:	e8 97 f2 ff ff       	call   80071b <cputchar>
  801484:	83 c4 10             	add    $0x10,%esp
				i--;
  801487:	ff 4d f4             	decl   -0xc(%ebp)
  80148a:	eb 31                	jmp    8014bd <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80148c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801490:	74 0a                	je     80149c <atomic_readline+0xda>
  801492:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801496:	0f 85 61 ff ff ff    	jne    8013fd <atomic_readline+0x3b>
				if (echoing)
  80149c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a0:	74 0e                	je     8014b0 <atomic_readline+0xee>
					cputchar(c);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8014a8:	e8 6e f2 ff ff       	call   80071b <cputchar>
  8014ad:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8014b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014bb:	eb 06                	jmp    8014c3 <atomic_readline+0x101>
			}
		}
  8014bd:	e9 3b ff ff ff       	jmp    8013fd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014c2:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014c3:	e8 4f 0a 00 00       	call   801f17 <sys_unlock_cons>
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d8:	eb 06                	jmp    8014e0 <strlen+0x15>
		n++;
  8014da:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014dd:	ff 45 08             	incl   0x8(%ebp)
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	75 f1                	jne    8014da <strlen+0xf>
		n++;
	return n;
  8014e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fb:	eb 09                	jmp    801506 <strnlen+0x18>
		n++;
  8014fd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	ff 4d 0c             	decl   0xc(%ebp)
  801506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80150a:	74 09                	je     801515 <strnlen+0x27>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	84 c0                	test   %al,%al
  801513:	75 e8                	jne    8014fd <strnlen+0xf>
		n++;
	return n;
  801515:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801526:	90                   	nop
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8d 50 01             	lea    0x1(%eax),%edx
  80152d:	89 55 08             	mov    %edx,0x8(%ebp)
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8d 4a 01             	lea    0x1(%edx),%ecx
  801536:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801539:	8a 12                	mov    (%edx),%dl
  80153b:	88 10                	mov    %dl,(%eax)
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 e4                	jne    801527 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155b:	eb 1f                	jmp    80157c <strncpy+0x34>
		*dst++ = *src;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8d 50 01             	lea    0x1(%eax),%edx
  801563:	89 55 08             	mov    %edx,0x8(%ebp)
  801566:	8b 55 0c             	mov    0xc(%ebp),%edx
  801569:	8a 12                	mov    (%edx),%dl
  80156b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	84 c0                	test   %al,%al
  801574:	74 03                	je     801579 <strncpy+0x31>
			src++;
  801576:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801579:	ff 45 fc             	incl   -0x4(%ebp)
  80157c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801582:	72 d9                	jb     80155d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801584:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801595:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801599:	74 30                	je     8015cb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80159b:	eb 16                	jmp    8015b3 <strlcpy+0x2a>
			*dst++ = *src++;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8d 50 01             	lea    0x1(%eax),%edx
  8015a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015af:	8a 12                	mov    (%edx),%dl
  8015b1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015b3:	ff 4d 10             	decl   0x10(%ebp)
  8015b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ba:	74 09                	je     8015c5 <strlcpy+0x3c>
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	84 c0                	test   %al,%al
  8015c3:	75 d8                	jne    80159d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d1:	29 c2                	sub    %eax,%edx
  8015d3:	89 d0                	mov    %edx,%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015da:	eb 06                	jmp    8015e2 <strcmp+0xb>
		p++, q++;
  8015dc:	ff 45 08             	incl   0x8(%ebp)
  8015df:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	84 c0                	test   %al,%al
  8015e9:	74 0e                	je     8015f9 <strcmp+0x22>
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8a 10                	mov    (%eax),%dl
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	38 c2                	cmp    %al,%dl
  8015f7:	74 e3                	je     8015dc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	0f b6 d0             	movzbl %al,%edx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	0f b6 c0             	movzbl %al,%eax
  801609:	29 c2                	sub    %eax,%edx
  80160b:	89 d0                	mov    %edx,%eax
}
  80160d:	5d                   	pop    %ebp
  80160e:	c3                   	ret    

0080160f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801612:	eb 09                	jmp    80161d <strncmp+0xe>
		n--, p++, q++;
  801614:	ff 4d 10             	decl   0x10(%ebp)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80161d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801621:	74 17                	je     80163a <strncmp+0x2b>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	74 0e                	je     80163a <strncmp+0x2b>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 10                	mov    (%eax),%dl
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	38 c2                	cmp    %al,%dl
  801638:	74 da                	je     801614 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 07                	jne    801647 <strncmp+0x38>
		return 0;
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
  801645:	eb 14                	jmp    80165b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	0f b6 d0             	movzbl %al,%edx
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	0f b6 c0             	movzbl %al,%eax
  801657:	29 c2                	sub    %eax,%edx
  801659:	89 d0                	mov    %edx,%eax
}
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801669:	eb 12                	jmp    80167d <strchr+0x20>
		if (*s == c)
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801673:	75 05                	jne    80167a <strchr+0x1d>
			return (char *) s;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	eb 11                	jmp    80168b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80167a:	ff 45 08             	incl   0x8(%ebp)
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	84 c0                	test   %al,%al
  801684:	75 e5                	jne    80166b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801699:	eb 0d                	jmp    8016a8 <strfind+0x1b>
		if (*s == c)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016a3:	74 0e                	je     8016b3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016a5:	ff 45 08             	incl   0x8(%ebp)
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	84 c0                	test   %al,%al
  8016af:	75 ea                	jne    80169b <strfind+0xe>
  8016b1:	eb 01                	jmp    8016b4 <strfind+0x27>
		if (*s == c)
			break;
  8016b3:	90                   	nop
	return (char *) s;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016c5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016c9:	76 63                	jbe    80172e <memset+0x75>
		uint64 data_block = c;
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	99                   	cltd   
  8016cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016db:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016df:	c1 e0 08             	shl    $0x8,%eax
  8016e2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016e5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ee:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016f2:	c1 e0 10             	shl    $0x10,%eax
  8016f5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016f8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801701:	89 c2                	mov    %eax,%edx
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	09 45 f0             	or     %eax,-0x10(%ebp)
  80170b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80170e:	eb 18                	jmp    801728 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801710:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801713:	8d 41 08             	lea    0x8(%ecx),%eax
  801716:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171f:	89 01                	mov    %eax,(%ecx)
  801721:	89 51 04             	mov    %edx,0x4(%ecx)
  801724:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801728:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80172c:	77 e2                	ja     801710 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80172e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801732:	74 23                	je     801757 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801734:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801737:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80173a:	eb 0e                	jmp    80174a <memset+0x91>
			*p8++ = (uint8)c;
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	8d 50 01             	lea    0x1(%eax),%edx
  801742:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801750:	89 55 10             	mov    %edx,0x10(%ebp)
  801753:	85 c0                	test   %eax,%eax
  801755:	75 e5                	jne    80173c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80176e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801772:	76 24                	jbe    801798 <memcpy+0x3c>
		while(n >= 8){
  801774:	eb 1c                	jmp    801792 <memcpy+0x36>
			*d64 = *s64;
  801776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801779:	8b 50 04             	mov    0x4(%eax),%edx
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801781:	89 01                	mov    %eax,(%ecx)
  801783:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801786:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80178a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80178e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801792:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801796:	77 de                	ja     801776 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801798:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179c:	74 31                	je     8017cf <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80179e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8017a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x66>
			*d8++ = *s8++;
  8017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8017b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a90:	75 bb                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9c:	48                   	dec    %eax
  801a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801aa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aa4:	74 3d                	je     801ae3 <ltostr+0xc3>
		start = 1 ;
  801aa6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801aad:	eb 34                	jmp    801ae3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	01 d0                	add    %edx,%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac2:	01 c2                	add    %eax,%edx
  801ac4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	01 c8                	add    %ecx,%eax
  801acc:	8a 00                	mov    (%eax),%al
  801ace:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad6:	01 c2                	add    %eax,%edx
  801ad8:	8a 45 eb             	mov    -0x15(%ebp),%al
  801adb:	88 02                	mov    %al,(%edx)
		start++ ;
  801add:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ae0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ae9:	7c c4                	jl     801aaf <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801aeb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af1:	01 d0                	add    %edx,%eax
  801af3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801af6:	90                   	nop
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	e8 c4 f9 ff ff       	call   8014cb <strlen>
  801b07:	83 c4 04             	add    $0x4,%esp
  801b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	e8 b6 f9 ff ff       	call   8014cb <strlen>
  801b15:	83 c4 04             	add    $0x4,%esp
  801b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b29:	eb 17                	jmp    801b42 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b31:	01 c2                	add    %eax,%edx
  801b33:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	01 c8                	add    %ecx,%eax
  801b3b:	8a 00                	mov    (%eax),%al
  801b3d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b3f:	ff 45 fc             	incl   -0x4(%ebp)
  801b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b48:	7c e1                	jl     801b2b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b58:	eb 1f                	jmp    801b79 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5d:	8d 50 01             	lea    0x1(%eax),%edx
  801b60:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b63:	89 c2                	mov    %eax,%edx
  801b65:	8b 45 10             	mov    0x10(%ebp),%eax
  801b68:	01 c2                	add    %eax,%edx
  801b6a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b70:	01 c8                	add    %ecx,%eax
  801b72:	8a 00                	mov    (%eax),%al
  801b74:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b76:	ff 45 f8             	incl   -0x8(%ebp)
  801b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b7f:	7c d9                	jl     801b5a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 d0                	add    %edx,%eax
  801b89:	c6 00 00             	movb   $0x0,(%eax)
}
  801b8c:	90                   	nop
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b92:	8b 45 14             	mov    0x14(%ebp),%eax
  801b95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  801baa:	01 d0                	add    %edx,%eax
  801bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bb2:	eb 0c                	jmp    801bc0 <strsplit+0x31>
			*string++ = 0;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8d 50 01             	lea    0x1(%eax),%edx
  801bba:	89 55 08             	mov    %edx,0x8(%ebp)
  801bbd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	8a 00                	mov    (%eax),%al
  801bc5:	84 c0                	test   %al,%al
  801bc7:	74 18                	je     801be1 <strsplit+0x52>
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8a 00                	mov    (%eax),%al
  801bce:	0f be c0             	movsbl %al,%eax
  801bd1:	50                   	push   %eax
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	e8 83 fa ff ff       	call   80165d <strchr>
  801bda:	83 c4 08             	add    $0x8,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	75 d3                	jne    801bb4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	8a 00                	mov    (%eax),%al
  801be6:	84 c0                	test   %al,%al
  801be8:	74 5a                	je     801c44 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	8b 00                	mov    (%eax),%eax
  801bef:	83 f8 0f             	cmp    $0xf,%eax
  801bf2:	75 07                	jne    801bfb <strsplit+0x6c>
		{
			return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	eb 66                	jmp    801c61 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	8d 48 01             	lea    0x1(%eax),%ecx
  801c03:	8b 55 14             	mov    0x14(%ebp),%edx
  801c06:	89 0a                	mov    %ecx,(%edx)
  801c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	01 c2                	add    %eax,%edx
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c19:	eb 03                	jmp    801c1e <strsplit+0x8f>
			string++;
  801c1b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	8a 00                	mov    (%eax),%al
  801c23:	84 c0                	test   %al,%al
  801c25:	74 8b                	je     801bb2 <strsplit+0x23>
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	8a 00                	mov    (%eax),%al
  801c2c:	0f be c0             	movsbl %al,%eax
  801c2f:	50                   	push   %eax
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	e8 25 fa ff ff       	call   80165d <strchr>
  801c38:	83 c4 08             	add    $0x8,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 dc                	je     801c1b <strsplit+0x8c>
			string++;
	}
  801c3f:	e9 6e ff ff ff       	jmp    801bb2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c44:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c45:	8b 45 14             	mov    0x14(%ebp),%eax
  801c48:	8b 00                	mov    (%eax),%eax
  801c4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c5c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c76:	eb 4a                	jmp    801cc2 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	01 c2                	add    %eax,%edx
  801c80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c86:	01 c8                	add    %ecx,%eax
  801c88:	8a 00                	mov    (%eax),%al
  801c8a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	8a 00                	mov    (%eax),%al
  801c96:	3c 40                	cmp    $0x40,%al
  801c98:	7e 25                	jle    801cbf <str2lower+0x5c>
  801c9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca0:	01 d0                	add    %edx,%eax
  801ca2:	8a 00                	mov    (%eax),%al
  801ca4:	3c 5a                	cmp    $0x5a,%al
  801ca6:	7f 17                	jg     801cbf <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ca8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	01 d0                	add    %edx,%eax
  801cb0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb6:	01 ca                	add    %ecx,%edx
  801cb8:	8a 12                	mov    (%edx),%dl
  801cba:	83 c2 20             	add    $0x20,%edx
  801cbd:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801cbf:	ff 45 fc             	incl   -0x4(%ebp)
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	e8 01 f8 ff ff       	call   8014cb <strlen>
  801cca:	83 c4 04             	add    $0x4,%esp
  801ccd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cd0:	7f a6                	jg     801c78 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801cdd:	a1 08 40 80 00       	mov    0x804008,%eax
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	74 42                	je     801d28 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	68 00 00 00 82       	push   $0x82000000
  801cee:	68 00 00 00 80       	push   $0x80000000
  801cf3:	e8 00 08 00 00       	call   8024f8 <initialize_dynamic_allocator>
  801cf8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cfb:	e8 e7 05 00 00       	call   8022e7 <sys_get_uheap_strategy>
  801d00:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801d05:	a1 40 40 80 00       	mov    0x804040,%eax
  801d0a:	05 00 10 00 00       	add    $0x1000,%eax
  801d0f:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801d14:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801d19:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801d1e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801d25:	00 00 00 
	}
}
  801d28:	90                   	nop
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	68 06 04 00 00       	push   $0x406
  801d47:	50                   	push   %eax
  801d48:	e8 e4 01 00 00       	call   801f31 <__sys_allocate_page>
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d57:	79 14                	jns    801d6d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	68 9c 39 80 00       	push   $0x80399c
  801d61:	6a 1f                	push   $0x1f
  801d63:	68 d8 39 80 00       	push   $0x8039d8
  801d68:	e8 af eb ff ff       	call   80091c <_panic>
	return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d88:	83 ec 0c             	sub    $0xc,%esp
  801d8b:	50                   	push   %eax
  801d8c:	e8 e7 01 00 00       	call   801f78 <__sys_unmap_frame>
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9b:	79 14                	jns    801db1 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	68 e4 39 80 00       	push   $0x8039e4
  801da5:	6a 2a                	push   $0x2a
  801da7:	68 d8 39 80 00       	push   $0x8039d8
  801dac:	e8 6b eb ff ff       	call   80091c <_panic>
}
  801db1:	90                   	nop
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801dba:	e8 18 ff ff ff       	call   801cd7 <uheap_init>
	if (size == 0) return NULL ;
  801dbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dc3:	75 07                	jne    801dcc <malloc+0x18>
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	eb 14                	jmp    801de0 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	68 24 3a 80 00       	push   $0x803a24
  801dd4:	6a 3e                	push   $0x3e
  801dd6:	68 d8 39 80 00       	push   $0x8039d8
  801ddb:	e8 3c eb ff ff       	call   80091c <_panic>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 4c 3a 80 00       	push   $0x803a4c
  801df0:	6a 49                	push   $0x49
  801df2:	68 d8 39 80 00       	push   $0x8039d8
  801df7:	e8 20 eb ff ff       	call   80091c <_panic>

00801dfc <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e08:	e8 ca fe ff ff       	call   801cd7 <uheap_init>
	if (size == 0) return NULL ;
  801e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e11:	75 07                	jne    801e1a <smalloc+0x1e>
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
  801e18:	eb 14                	jmp    801e2e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 70 3a 80 00       	push   $0x803a70
  801e22:	6a 5a                	push   $0x5a
  801e24:	68 d8 39 80 00       	push   $0x8039d8
  801e29:	e8 ee ea ff ff       	call   80091c <_panic>
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e36:	e8 9c fe ff ff       	call   801cd7 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 98 3a 80 00       	push   $0x803a98
  801e43:	6a 6a                	push   $0x6a
  801e45:	68 d8 39 80 00       	push   $0x8039d8
  801e4a:	e8 cd ea ff ff       	call   80091c <_panic>

00801e4f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e55:	e8 7d fe ff ff       	call   801cd7 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801e5a:	83 ec 04             	sub    $0x4,%esp
  801e5d:	68 bc 3a 80 00       	push   $0x803abc
  801e62:	68 88 00 00 00       	push   $0x88
  801e67:	68 d8 39 80 00       	push   $0x8039d8
  801e6c:	e8 ab ea ff ff       	call   80091c <_panic>

00801e71 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 e4 3a 80 00       	push   $0x803ae4
  801e7f:	68 9b 00 00 00       	push   $0x9b
  801e84:	68 d8 39 80 00       	push   $0x8039d8
  801e89:	e8 8e ea ff ff       	call   80091c <_panic>

00801e8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	57                   	push   %edi
  801e92:	56                   	push   %esi
  801e93:	53                   	push   %ebx
  801e94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ea9:	cd 30                	int    $0x30
  801eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	5b                   	pop    %ebx
  801eb5:	5e                   	pop    %esi
  801eb6:	5f                   	pop    %edi
  801eb7:	5d                   	pop    %ebp
  801eb8:	c3                   	ret    

00801eb9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ec5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	51                   	push   %ecx
  801ed2:	52                   	push   %edx
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	50                   	push   %eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 b0 ff ff ff       	call   801e8e <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	90                   	nop
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 02                	push   $0x2
  801ef3:	e8 96 ff ff ff       	call   801e8e <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_lock_cons>:

void sys_lock_cons(void)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 03                	push   $0x3
  801f0c:	e8 7d ff ff ff       	call   801e8e <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	90                   	nop
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 04                	push   $0x4
  801f26:	e8 63 ff ff ff       	call   801e8e <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 08                	push   $0x8
  801f44:	e8 45 ff ff ff       	call   801e8e <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f53:	8b 75 18             	mov    0x18(%ebp),%esi
  801f56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	51                   	push   %ecx
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	6a 09                	push   $0x9
  801f69:	e8 20 ff ff ff       	call   801e8e <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f74:	5b                   	pop    %ebx
  801f75:	5e                   	pop    %esi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    

00801f78 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	6a 0a                	push   $0xa
  801f88:	e8 01 ff ff ff       	call   801e8e <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	6a 0b                	push   $0xb
  801fa3:	e8 e6 fe ff ff       	call   801e8e <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 0c                	push   $0xc
  801fbc:	e8 cd fe ff ff       	call   801e8e <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 0d                	push   $0xd
  801fd5:	e8 b4 fe ff ff       	call   801e8e <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 0e                	push   $0xe
  801fee:	e8 9b fe ff ff       	call   801e8e <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 0f                	push   $0xf
  802007:	e8 82 fe ff ff       	call   801e8e <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	6a 10                	push   $0x10
  802021:	e8 68 fe ff ff       	call   801e8e <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 11                	push   $0x11
  80203a:	e8 4f fe ff ff       	call   801e8e <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	90                   	nop
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_cputc>:

void
sys_cputc(const char c)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802051:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	50                   	push   %eax
  80205e:	6a 01                	push   $0x1
  802060:	e8 29 fe ff ff       	call   801e8e <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 14                	push   $0x14
  80207a:	e8 0f fe ff ff       	call   801e8e <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	8b 45 10             	mov    0x10(%ebp),%eax
  80208e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802091:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802094:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	51                   	push   %ecx
  80209e:	52                   	push   %edx
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	50                   	push   %eax
  8020a3:	6a 15                	push   $0x15
  8020a5:	e8 e4 fd ff ff       	call   801e8e <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 16                	push   $0x16
  8020c2:	e8 c7 fd ff ff       	call   801e8e <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	51                   	push   %ecx
  8020dd:	52                   	push   %edx
  8020de:	50                   	push   %eax
  8020df:	6a 17                	push   $0x17
  8020e1:	e8 a8 fd ff ff       	call   801e8e <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	6a 18                	push   $0x18
  8020fe:	e8 8b fd ff ff       	call   801e8e <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	6a 00                	push   $0x0
  802110:	ff 75 14             	pushl  0x14(%ebp)
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	50                   	push   %eax
  80211a:	6a 19                	push   $0x19
  80211c:	e8 6d fd ff ff       	call   801e8e <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	50                   	push   %eax
  802135:	6a 1a                	push   $0x1a
  802137:	e8 52 fd ff ff       	call   801e8e <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	90                   	nop
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	50                   	push   %eax
  802151:	6a 1b                	push   $0x1b
  802153:	e8 36 fd ff ff       	call   801e8e <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 05                	push   $0x5
  80216c:	e8 1d fd ff ff       	call   801e8e <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 06                	push   $0x6
  802185:	e8 04 fd ff ff       	call   801e8e <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 07                	push   $0x7
  80219e:	e8 eb fc ff ff       	call   801e8e <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_exit_env>:


void sys_exit_env(void)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 1c                	push   $0x1c
  8021b7:	e8 d2 fc ff ff       	call   801e8e <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	90                   	nop
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021cb:	8d 50 04             	lea    0x4(%eax),%edx
  8021ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 1d                	push   $0x1d
  8021db:	e8 ae fc ff ff       	call   801e8e <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return result;
  8021e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021ec:	89 01                	mov    %eax,(%ecx)
  8021ee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	c9                   	leave  
  8021f5:	c2 04 00             	ret    $0x4

008021f8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 13                	push   $0x13
  80220a:	e8 7f fc ff ff       	call   801e8e <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_rcr2>:
uint32 sys_rcr2()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 1e                	push   $0x1e
  802224:	e8 65 fc ff ff       	call   801e8e <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80223a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	50                   	push   %eax
  802247:	6a 1f                	push   $0x1f
  802249:	e8 40 fc ff ff       	call   801e8e <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
	return ;
  802251:	90                   	nop
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <rsttst>:
void rsttst()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 21                	push   $0x21
  802263:	e8 26 fc ff ff       	call   801e8e <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80227a:	8b 55 18             	mov    0x18(%ebp),%edx
  80227d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	ff 75 10             	pushl  0x10(%ebp)
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	ff 75 08             	pushl  0x8(%ebp)
  80228c:	6a 20                	push   $0x20
  80228e:	e8 fb fb ff ff       	call   801e8e <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <chktst>:
void chktst(uint32 n)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 22                	push   $0x22
  8022a9:	e8 e0 fb ff ff       	call   801e8e <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <inctst>:

void inctst()
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 23                	push   $0x23
  8022c3:	e8 c6 fb ff ff       	call   801e8e <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cb:	90                   	nop
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <gettst>:
uint32 gettst()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 24                	push   $0x24
  8022dd:	e8 ac fb ff ff       	call   801e8e <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 25                	push   $0x25
  8022f6:	e8 93 fb ff ff       	call   801e8e <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
  8022fe:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802303:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	ff 75 08             	pushl  0x8(%ebp)
  802320:	6a 26                	push   $0x26
  802322:	e8 67 fb ff ff       	call   801e8e <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
	return ;
  80232a:	90                   	nop
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802331:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	6a 00                	push   $0x0
  80233f:	53                   	push   %ebx
  802340:	51                   	push   %ecx
  802341:	52                   	push   %edx
  802342:	50                   	push   %eax
  802343:	6a 27                	push   $0x27
  802345:	e8 44 fb ff ff       	call   801e8e <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802355:	8b 55 0c             	mov    0xc(%ebp),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	6a 28                	push   $0x28
  802365:	e8 24 fb ff ff       	call   801e8e <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802372:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802375:	8b 55 0c             	mov    0xc(%ebp),%edx
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	51                   	push   %ecx
  80237e:	ff 75 10             	pushl  0x10(%ebp)
  802381:	52                   	push   %edx
  802382:	50                   	push   %eax
  802383:	6a 29                	push   $0x29
  802385:	e8 04 fb ff ff       	call   801e8e <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	ff 75 10             	pushl  0x10(%ebp)
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	ff 75 08             	pushl  0x8(%ebp)
  80239f:	6a 12                	push   $0x12
  8023a1:	e8 e8 fa ff ff       	call   801e8e <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	52                   	push   %edx
  8023bc:	50                   	push   %eax
  8023bd:	6a 2a                	push   $0x2a
  8023bf:	e8 ca fa ff ff       	call   801e8e <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
	return;
  8023c7:	90                   	nop
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 2b                	push   $0x2b
  8023d9:	e8 b0 fa ff ff       	call   801e8e <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	ff 75 0c             	pushl  0xc(%ebp)
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	6a 2d                	push   $0x2d
  8023f4:	e8 95 fa ff ff       	call   801e8e <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
	return;
  8023fc:	90                   	nop
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	ff 75 0c             	pushl  0xc(%ebp)
  80240b:	ff 75 08             	pushl  0x8(%ebp)
  80240e:	6a 2c                	push   $0x2c
  802410:	e8 79 fa ff ff       	call   801e8e <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 08 3b 80 00       	push   $0x803b08
  802429:	68 25 01 00 00       	push   $0x125
  80242e:	68 3b 3b 80 00       	push   $0x803b3b
  802433:	e8 e4 e4 ff ff       	call   80091c <_panic>

00802438 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80243e:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802445:	72 09                	jb     802450 <to_page_va+0x18>
  802447:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  80244e:	72 14                	jb     802464 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 4c 3b 80 00       	push   $0x803b4c
  802458:	6a 15                	push   $0x15
  80245a:	68 77 3b 80 00       	push   $0x803b77
  80245f:	e8 b8 e4 ff ff       	call   80091c <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	ba 60 40 80 00       	mov    $0x804060,%edx
  80246c:	29 d0                	sub    %edx,%eax
  80246e:	c1 f8 02             	sar    $0x2,%eax
  802471:	89 c2                	mov    %eax,%edx
  802473:	89 d0                	mov    %edx,%eax
  802475:	c1 e0 02             	shl    $0x2,%eax
  802478:	01 d0                	add    %edx,%eax
  80247a:	c1 e0 02             	shl    $0x2,%eax
  80247d:	01 d0                	add    %edx,%eax
  80247f:	c1 e0 02             	shl    $0x2,%eax
  802482:	01 d0                	add    %edx,%eax
  802484:	89 c1                	mov    %eax,%ecx
  802486:	c1 e1 08             	shl    $0x8,%ecx
  802489:	01 c8                	add    %ecx,%eax
  80248b:	89 c1                	mov    %eax,%ecx
  80248d:	c1 e1 10             	shl    $0x10,%ecx
  802490:	01 c8                	add    %ecx,%eax
  802492:	01 c0                	add    %eax,%eax
  802494:	01 d0                	add    %edx,%eax
  802496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	c1 e0 0c             	shl    $0xc,%eax
  80249f:	89 c2                	mov    %eax,%edx
  8024a1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8024a6:	01 d0                	add    %edx,%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8024b0:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8024b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b8:	29 c2                	sub    %eax,%edx
  8024ba:	89 d0                	mov    %edx,%eax
  8024bc:	c1 e8 0c             	shr    $0xc,%eax
  8024bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8024c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c6:	78 09                	js     8024d1 <to_page_info+0x27>
  8024c8:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8024cf:	7e 14                	jle    8024e5 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	68 90 3b 80 00       	push   $0x803b90
  8024d9:	6a 22                	push   $0x22
  8024db:	68 77 3b 80 00       	push   $0x803b77
  8024e0:	e8 37 e4 ff ff       	call   80091c <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8024e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e8:	89 d0                	mov    %edx,%eax
  8024ea:	01 c0                	add    %eax,%eax
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	c1 e0 02             	shl    $0x2,%eax
  8024f1:	05 60 40 80 00       	add    $0x804060,%eax
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	05 00 00 00 02       	add    $0x2000000,%eax
  802506:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802509:	73 16                	jae    802521 <initialize_dynamic_allocator+0x29>
  80250b:	68 b4 3b 80 00       	push   $0x803bb4
  802510:	68 da 3b 80 00       	push   $0x803bda
  802515:	6a 34                	push   $0x34
  802517:	68 77 3b 80 00       	push   $0x803b77
  80251c:	e8 fb e3 ff ff       	call   80091c <_panic>
		is_initialized = 1;
  802521:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802528:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802533:	8b 45 0c             	mov    0xc(%ebp),%eax
  802536:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80253b:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802542:	00 00 00 
  802545:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80254c:	00 00 00 
  80254f:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802556:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255c:	2b 45 08             	sub    0x8(%ebp),%eax
  80255f:	c1 e8 0c             	shr    $0xc,%eax
  802562:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802565:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80256c:	e9 c8 00 00 00       	jmp    802639 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	89 d0                	mov    %edx,%eax
  802576:	01 c0                	add    %eax,%eax
  802578:	01 d0                	add    %edx,%eax
  80257a:	c1 e0 02             	shl    $0x2,%eax
  80257d:	05 68 40 80 00       	add    $0x804068,%eax
  802582:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802587:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	01 c0                	add    %eax,%eax
  80258e:	01 d0                	add    %edx,%eax
  802590:	c1 e0 02             	shl    $0x2,%eax
  802593:	05 6a 40 80 00       	add    $0x80406a,%eax
  802598:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80259d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025a6:	89 c8                	mov    %ecx,%eax
  8025a8:	01 c0                	add    %eax,%eax
  8025aa:	01 c8                	add    %ecx,%eax
  8025ac:	c1 e0 02             	shl    $0x2,%eax
  8025af:	05 64 40 80 00       	add    $0x804064,%eax
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b9:	89 d0                	mov    %edx,%eax
  8025bb:	01 c0                	add    %eax,%eax
  8025bd:	01 d0                	add    %edx,%eax
  8025bf:	c1 e0 02             	shl    $0x2,%eax
  8025c2:	05 64 40 80 00       	add    $0x804064,%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 1b                	je     8025e8 <initialize_dynamic_allocator+0xf0>
  8025cd:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025d6:	89 c8                	mov    %ecx,%eax
  8025d8:	01 c0                	add    %eax,%eax
  8025da:	01 c8                	add    %ecx,%eax
  8025dc:	c1 e0 02             	shl    $0x2,%eax
  8025df:	05 60 40 80 00       	add    $0x804060,%eax
  8025e4:	89 02                	mov    %eax,(%edx)
  8025e6:	eb 16                	jmp    8025fe <initialize_dynamic_allocator+0x106>
  8025e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025eb:	89 d0                	mov    %edx,%eax
  8025ed:	01 c0                	add    %eax,%eax
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	c1 e0 02             	shl    $0x2,%eax
  8025f4:	05 60 40 80 00       	add    $0x804060,%eax
  8025f9:	a3 48 40 80 00       	mov    %eax,0x804048
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	89 d0                	mov    %edx,%eax
  802603:	01 c0                	add    %eax,%eax
  802605:	01 d0                	add    %edx,%eax
  802607:	c1 e0 02             	shl    $0x2,%eax
  80260a:	05 60 40 80 00       	add    $0x804060,%eax
  80260f:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802617:	89 d0                	mov    %edx,%eax
  802619:	01 c0                	add    %eax,%eax
  80261b:	01 d0                	add    %edx,%eax
  80261d:	c1 e0 02             	shl    $0x2,%eax
  802620:	05 60 40 80 00       	add    $0x804060,%eax
  802625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262b:	a1 54 40 80 00       	mov    0x804054,%eax
  802630:	40                   	inc    %eax
  802631:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802636:	ff 45 f4             	incl   -0xc(%ebp)
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80263f:	0f 8c 2c ff ff ff    	jl     802571 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802645:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80264c:	eb 36                	jmp    802684 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	c1 e0 04             	shl    $0x4,%eax
  802654:	05 80 c0 81 00       	add    $0x81c080,%eax
  802659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	c1 e0 04             	shl    $0x4,%eax
  802665:	05 84 c0 81 00       	add    $0x81c084,%eax
  80266a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	c1 e0 04             	shl    $0x4,%eax
  802676:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80267b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802681:	ff 45 f0             	incl   -0x10(%ebp)
  802684:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802688:	7e c4                	jle    80264e <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80268a:	90                   	nop
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
  802690:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	83 ec 0c             	sub    $0xc,%esp
  802699:	50                   	push   %eax
  80269a:	e8 0b fe ff ff       	call   8024aa <to_page_info>
  80269f:	83 c4 10             	add    $0x10,%esp
  8026a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 08             	mov    0x8(%eax),%eax
  8026ab:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	ff 75 0c             	pushl  0xc(%ebp)
  8026bc:	e8 77 fd ff ff       	call   802438 <to_page_va>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8026c7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d1:	f7 75 08             	divl   0x8(%ebp)
  8026d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8026d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	50                   	push   %eax
  8026de:	e8 48 f6 ff ff       	call   801d2b <get_page>
  8026e3:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8026e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ec:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f6:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8026fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802701:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802708:	eb 19                	jmp    802723 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	ba 01 00 00 00       	mov    $0x1,%edx
  802712:	88 c1                	mov    %al,%cl
  802714:	d3 e2                	shl    %cl,%edx
  802716:	89 d0                	mov    %edx,%eax
  802718:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271b:	74 0e                	je     80272b <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80271d:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802720:	ff 45 f0             	incl   -0x10(%ebp)
  802723:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802727:	7e e1                	jle    80270a <split_page_to_blocks+0x5a>
  802729:	eb 01                	jmp    80272c <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80272b:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80272c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802733:	e9 a7 00 00 00       	jmp    8027df <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273b:	0f af 45 08          	imul   0x8(%ebp),%eax
  80273f:	89 c2                	mov    %eax,%edx
  802741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80274d:	75 14                	jne    802763 <split_page_to_blocks+0xb3>
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 f0 3b 80 00       	push   $0x803bf0
  802757:	6a 7c                	push   $0x7c
  802759:	68 77 3b 80 00       	push   $0x803b77
  80275e:	e8 b9 e1 ff ff       	call   80091c <_panic>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	c1 e0 04             	shl    $0x4,%eax
  802769:	05 84 c0 81 00       	add    $0x81c084,%eax
  80276e:	8b 10                	mov    (%eax),%edx
  802770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 14                	je     802794 <split_page_to_blocks+0xe4>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	c1 e0 04             	shl    $0x4,%eax
  802786:	05 84 c0 81 00       	add    $0x81c084,%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802790:	89 10                	mov    %edx,(%eax)
  802792:	eb 11                	jmp    8027a5 <split_page_to_blocks+0xf5>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	c1 e0 04             	shl    $0x4,%eax
  80279a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8027a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a3:	89 02                	mov    %eax,(%edx)
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	c1 e0 04             	shl    $0x4,%eax
  8027ab:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	89 02                	mov    %eax,(%edx)
  8027b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c1 e0 04             	shl    $0x4,%eax
  8027c5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	8d 50 01             	lea    0x1(%eax),%edx
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c1 e0 04             	shl    $0x4,%eax
  8027d5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027da:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8027dc:	ff 45 ec             	incl   -0x14(%ebp)
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8027e5:	0f 82 4d ff ff ff    	jb     802738 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8027eb:	90                   	nop
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8027f4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8027fb:	76 19                	jbe    802816 <alloc_block+0x28>
  8027fd:	68 14 3c 80 00       	push   $0x803c14
  802802:	68 da 3b 80 00       	push   $0x803bda
  802807:	68 8a 00 00 00       	push   $0x8a
  80280c:	68 77 3b 80 00       	push   $0x803b77
  802811:	e8 06 e1 ff ff       	call   80091c <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80281d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802824:	eb 19                	jmp    80283f <alloc_block+0x51>
		if((1 << i) >= size) break;
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	ba 01 00 00 00       	mov    $0x1,%edx
  80282e:	88 c1                	mov    %al,%cl
  802830:	d3 e2                	shl    %cl,%edx
  802832:	89 d0                	mov    %edx,%eax
  802834:	3b 45 08             	cmp    0x8(%ebp),%eax
  802837:	73 0e                	jae    802847 <alloc_block+0x59>
		idx++;
  802839:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80283c:	ff 45 f0             	incl   -0x10(%ebp)
  80283f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802843:	7e e1                	jle    802826 <alloc_block+0x38>
  802845:	eb 01                	jmp    802848 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802847:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	c1 e0 04             	shl    $0x4,%eax
  80284e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	0f 84 df 00 00 00    	je     80293c <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	c1 e0 04             	shl    $0x4,%eax
  802863:	05 80 c0 81 00       	add    $0x81c080,%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80286d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802871:	75 17                	jne    80288a <alloc_block+0x9c>
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 35 3c 80 00       	push   $0x803c35
  80287b:	68 9e 00 00 00       	push   $0x9e
  802880:	68 77 3b 80 00       	push   $0x803b77
  802885:	e8 92 e0 ff ff       	call   80091c <_panic>
  80288a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 10                	je     8028a3 <alloc_block+0xb5>
  802893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289b:	8b 52 04             	mov    0x4(%edx),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 14                	jmp    8028b7 <alloc_block+0xc9>
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	c1 e2 04             	shl    $0x4,%edx
  8028af:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8028b5:	89 02                	mov    %eax,(%edx)
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 0f                	je     8028d0 <alloc_block+0xe2>
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ca:	8b 12                	mov    (%edx),%edx
  8028cc:	89 10                	mov    %edx,(%eax)
  8028ce:	eb 13                	jmp    8028e3 <alloc_block+0xf5>
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	c1 e2 04             	shl    $0x4,%edx
  8028db:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8028e1:	89 02                	mov    %eax,(%edx)
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	c1 e0 04             	shl    $0x4,%eax
  8028fc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8d 50 ff             	lea    -0x1(%eax),%edx
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	c1 e0 04             	shl    $0x4,%eax
  80290c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802911:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	83 ec 0c             	sub    $0xc,%esp
  802919:	50                   	push   %eax
  80291a:	e8 8b fb ff ff       	call   8024aa <to_page_info>
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802928:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80292c:	48                   	dec    %eax
  80292d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802930:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	e9 bc 02 00 00       	jmp    802bf8 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80293c:	a1 54 40 80 00       	mov    0x804054,%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	0f 84 7d 02 00 00    	je     802bc6 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802949:	a1 48 40 80 00       	mov    0x804048,%eax
  80294e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802955:	75 17                	jne    80296e <alloc_block+0x180>
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 35 3c 80 00       	push   $0x803c35
  80295f:	68 a9 00 00 00       	push   $0xa9
  802964:	68 77 3b 80 00       	push   $0x803b77
  802969:	e8 ae df ff ff       	call   80091c <_panic>
  80296e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 10                	je     802987 <alloc_block+0x199>
  802977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80297f:	8b 52 04             	mov    0x4(%edx),%edx
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	eb 0b                	jmp    802992 <alloc_block+0x1a4>
  802987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 0f                	je     8029ab <alloc_block+0x1bd>
  80299c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029a5:	8b 12                	mov    (%edx),%edx
  8029a7:	89 10                	mov    %edx,(%eax)
  8029a9:	eb 0a                	jmp    8029b5 <alloc_block+0x1c7>
  8029ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	a3 48 40 80 00       	mov    %eax,0x804048
  8029b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c8:	a1 54 40 80 00       	mov    0x804054,%eax
  8029cd:	48                   	dec    %eax
  8029ce:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	83 c0 03             	add    $0x3,%eax
  8029d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8029de:	88 c1                	mov    %al,%cl
  8029e0:	d3 e2                	shl    %cl,%edx
  8029e2:	89 d0                	mov    %edx,%eax
  8029e4:	83 ec 08             	sub    $0x8,%esp
  8029e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ea:	50                   	push   %eax
  8029eb:	e8 c0 fc ff ff       	call   8026b0 <split_page_to_blocks>
  8029f0:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c1 e0 04             	shl    $0x4,%eax
  8029f9:	05 80 c0 81 00       	add    $0x81c080,%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802a03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a07:	75 17                	jne    802a20 <alloc_block+0x232>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 35 3c 80 00       	push   $0x803c35
  802a11:	68 b0 00 00 00       	push   $0xb0
  802a16:	68 77 3b 80 00       	push   $0x803b77
  802a1b:	e8 fc de ff ff       	call   80091c <_panic>
  802a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 10                	je     802a39 <alloc_block+0x24b>
  802a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a31:	8b 52 04             	mov    0x4(%edx),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 14                	jmp    802a4d <alloc_block+0x25f>
  802a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	c1 e2 04             	shl    $0x4,%edx
  802a45:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802a4b:	89 02                	mov    %eax,(%edx)
  802a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0f                	je     802a66 <alloc_block+0x278>
  802a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a60:	8b 12                	mov    (%edx),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 13                	jmp    802a79 <alloc_block+0x28b>
  802a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6e:	c1 e2 04             	shl    $0x4,%edx
  802a71:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802a77:	89 02                	mov    %eax,(%edx)
  802a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	c1 e0 04             	shl    $0x4,%eax
  802a92:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	c1 e0 04             	shl    $0x4,%eax
  802aa2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802aa7:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aac:	83 ec 0c             	sub    $0xc,%esp
  802aaf:	50                   	push   %eax
  802ab0:	e8 f5 f9 ff ff       	call   8024aa <to_page_info>
  802ab5:	83 c4 10             	add    $0x10,%esp
  802ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802abe:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ac2:	48                   	dec    %eax
  802ac3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac6:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acd:	e9 26 01 00 00       	jmp    802bf8 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802ad2:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	c1 e0 04             	shl    $0x4,%eax
  802adb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	0f 84 dc 00 00 00    	je     802bc6 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	c1 e0 04             	shl    $0x4,%eax
  802af0:	05 80 c0 81 00       	add    $0x81c080,%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802afa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802afe:	75 17                	jne    802b17 <alloc_block+0x329>
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	68 35 3c 80 00       	push   $0x803c35
  802b08:	68 be 00 00 00       	push   $0xbe
  802b0d:	68 77 3b 80 00       	push   $0x803b77
  802b12:	e8 05 de ff ff       	call   80091c <_panic>
  802b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 10                	je     802b30 <alloc_block+0x342>
  802b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b28:	8b 52 04             	mov    0x4(%edx),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 14                	jmp    802b44 <alloc_block+0x356>
  802b30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b39:	c1 e2 04             	shl    $0x4,%edx
  802b3c:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802b42:	89 02                	mov    %eax,(%edx)
  802b44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b47:	8b 40 04             	mov    0x4(%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 0f                	je     802b5d <alloc_block+0x36f>
  802b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b57:	8b 12                	mov    (%edx),%edx
  802b59:	89 10                	mov    %edx,(%eax)
  802b5b:	eb 13                	jmp    802b70 <alloc_block+0x382>
  802b5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b65:	c1 e2 04             	shl    $0x4,%edx
  802b68:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802b6e:	89 02                	mov    %eax,(%edx)
  802b70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	c1 e0 04             	shl    $0x4,%eax
  802b89:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	c1 e0 04             	shl    $0x4,%eax
  802b99:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b9e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802ba0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	50                   	push   %eax
  802ba7:	e8 fe f8 ff ff       	call   8024aa <to_page_info>
  802bac:	83 c4 10             	add    $0x10,%esp
  802baf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802bb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bb5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802bb9:	48                   	dec    %eax
  802bba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bbd:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc4:	eb 32                	jmp    802bf8 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802bc6:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802bca:	77 15                	ja     802be1 <alloc_block+0x3f3>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	c1 e0 04             	shl    $0x4,%eax
  802bd2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	0f 84 f1 fe ff ff    	je     802ad2 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 53 3c 80 00       	push   $0x803c53
  802be9:	68 c8 00 00 00       	push   $0xc8
  802bee:	68 77 3b 80 00       	push   $0x803b77
  802bf3:	e8 24 dd ff ff       	call   80091c <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802bf8:	c9                   	leave  
  802bf9:	c3                   	ret    

00802bfa <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802bfa:	55                   	push   %ebp
  802bfb:	89 e5                	mov    %esp,%ebp
  802bfd:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802c08:	39 c2                	cmp    %eax,%edx
  802c0a:	72 0c                	jb     802c18 <free_block+0x1e>
  802c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0f:	a1 40 40 80 00       	mov    0x804040,%eax
  802c14:	39 c2                	cmp    %eax,%edx
  802c16:	72 19                	jb     802c31 <free_block+0x37>
  802c18:	68 64 3c 80 00       	push   $0x803c64
  802c1d:	68 da 3b 80 00       	push   $0x803bda
  802c22:	68 d7 00 00 00       	push   $0xd7
  802c27:	68 77 3b 80 00       	push   $0x803b77
  802c2c:	e8 eb dc ff ff       	call   80091c <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	83 ec 0c             	sub    $0xc,%esp
  802c3d:	50                   	push   %eax
  802c3e:	e8 67 f8 ff ff       	call   8024aa <to_page_info>
  802c43:	83 c4 10             	add    $0x10,%esp
  802c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	0f b7 c0             	movzwl %ax,%eax
  802c52:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802c55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802c5c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802c63:	eb 19                	jmp    802c7e <free_block+0x84>
	    if ((1 << i) == blk_size)
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	ba 01 00 00 00       	mov    $0x1,%edx
  802c6d:	88 c1                	mov    %al,%cl
  802c6f:	d3 e2                	shl    %cl,%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c76:	74 0e                	je     802c86 <free_block+0x8c>
	        break;
	    idx++;
  802c78:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802c7b:	ff 45 f0             	incl   -0x10(%ebp)
  802c7e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802c82:	7e e1                	jle    802c65 <free_block+0x6b>
  802c84:	eb 01                	jmp    802c87 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802c86:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c8e:	40                   	inc    %eax
  802c8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c92:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802c96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c9a:	75 17                	jne    802cb3 <free_block+0xb9>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 f0 3b 80 00       	push   $0x803bf0
  802ca4:	68 ee 00 00 00       	push   $0xee
  802ca9:	68 77 3b 80 00       	push   $0x803b77
  802cae:	e8 69 dc ff ff       	call   80091c <_panic>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	c1 e0 04             	shl    $0x4,%eax
  802cb9:	05 84 c0 81 00       	add    $0x81c084,%eax
  802cbe:	8b 10                	mov    (%eax),%edx
  802cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	74 14                	je     802ce4 <free_block+0xea>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	c1 e0 04             	shl    $0x4,%eax
  802cd6:	05 84 c0 81 00       	add    $0x81c084,%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	eb 11                	jmp    802cf5 <free_block+0xfb>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	c1 e0 04             	shl    $0x4,%eax
  802cea:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf3:	89 02                	mov    %eax,(%edx)
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	c1 e0 04             	shl    $0x4,%eax
  802cfb:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	89 02                	mov    %eax,(%edx)
  802d06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c1 e0 04             	shl    $0x4,%eax
  802d15:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	8d 50 01             	lea    0x1(%eax),%edx
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	c1 e0 04             	shl    $0x4,%eax
  802d25:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802d2a:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802d2c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d31:	ba 00 00 00 00       	mov    $0x0,%edx
  802d36:	f7 75 e0             	divl   -0x20(%ebp)
  802d39:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802d3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802d43:	0f b7 c0             	movzwl %ax,%eax
  802d46:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d49:	0f 85 70 01 00 00    	jne    802ebf <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802d4f:	83 ec 0c             	sub    $0xc,%esp
  802d52:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d55:	e8 de f6 ff ff       	call   802438 <to_page_va>
  802d5a:	83 c4 10             	add    $0x10,%esp
  802d5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802d60:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d67:	e9 b7 00 00 00       	jmp    802e23 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802d6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	01 d0                	add    %edx,%eax
  802d74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802d77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d7b:	75 17                	jne    802d94 <free_block+0x19a>
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 35 3c 80 00       	push   $0x803c35
  802d85:	68 f8 00 00 00       	push   $0xf8
  802d8a:	68 77 3b 80 00       	push   $0x803b77
  802d8f:	e8 88 db ff ff       	call   80091c <_panic>
  802d94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 10                	je     802dad <free_block+0x1b3>
  802d9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802da5:	8b 52 04             	mov    0x4(%edx),%edx
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	eb 14                	jmp    802dc1 <free_block+0x1c7>
  802dad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db6:	c1 e2 04             	shl    $0x4,%edx
  802db9:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802dbf:	89 02                	mov    %eax,(%edx)
  802dc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0f                	je     802dda <free_block+0x1e0>
  802dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802dd4:	8b 12                	mov    (%edx),%edx
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	eb 13                	jmp    802ded <free_block+0x1f3>
  802dda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de2:	c1 e2 04             	shl    $0x4,%edx
  802de5:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802deb:	89 02                	mov    %eax,(%edx)
  802ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802df0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802df9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	c1 e0 04             	shl    $0x4,%eax
  802e06:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	c1 e0 04             	shl    $0x4,%eax
  802e16:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802e1b:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e20:	01 45 ec             	add    %eax,-0x14(%ebp)
  802e23:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802e2a:	0f 86 3c ff ff ff    	jbe    802d6c <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e33:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802e42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e46:	75 17                	jne    802e5f <free_block+0x265>
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	68 f0 3b 80 00       	push   $0x803bf0
  802e50:	68 fe 00 00 00       	push   $0xfe
  802e55:	68 77 3b 80 00       	push   $0x803b77
  802e5a:	e8 bd da ff ff       	call   80091c <_panic>
  802e5f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802e65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e68:	89 50 04             	mov    %edx,0x4(%eax)
  802e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 0c                	je     802e81 <free_block+0x287>
  802e75:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802e7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	eb 08                	jmp    802e89 <free_block+0x28f>
  802e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e84:	a3 48 40 80 00       	mov    %eax,0x804048
  802e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9a:	a1 54 40 80 00       	mov    0x804054,%eax
  802e9f:	40                   	inc    %eax
  802ea0:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802ea5:	83 ec 0c             	sub    $0xc,%esp
  802ea8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eab:	e8 88 f5 ff ff       	call   802438 <to_page_va>
  802eb0:	83 c4 10             	add    $0x10,%esp
  802eb3:	83 ec 0c             	sub    $0xc,%esp
  802eb6:	50                   	push   %eax
  802eb7:	e8 b8 ee ff ff       	call   801d74 <return_page>
  802ebc:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802ebf:	90                   	nop
  802ec0:	c9                   	leave  
  802ec1:	c3                   	ret    

00802ec2 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802ec2:	55                   	push   %ebp
  802ec3:	89 e5                	mov    %esp,%ebp
  802ec5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 9c 3c 80 00       	push   $0x803c9c
  802ed0:	68 11 01 00 00       	push   $0x111
  802ed5:	68 77 3b 80 00       	push   $0x803b77
  802eda:	e8 3d da ff ff       	call   80091c <_panic>
  802edf:	90                   	nop

00802ee0 <__udivdi3>:
  802ee0:	55                   	push   %ebp
  802ee1:	57                   	push   %edi
  802ee2:	56                   	push   %esi
  802ee3:	53                   	push   %ebx
  802ee4:	83 ec 1c             	sub    $0x1c,%esp
  802ee7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802eeb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802eef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ef3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ef7:	89 ca                	mov    %ecx,%edx
  802ef9:	89 f8                	mov    %edi,%eax
  802efb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802eff:	85 f6                	test   %esi,%esi
  802f01:	75 2d                	jne    802f30 <__udivdi3+0x50>
  802f03:	39 cf                	cmp    %ecx,%edi
  802f05:	77 65                	ja     802f6c <__udivdi3+0x8c>
  802f07:	89 fd                	mov    %edi,%ebp
  802f09:	85 ff                	test   %edi,%edi
  802f0b:	75 0b                	jne    802f18 <__udivdi3+0x38>
  802f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f12:	31 d2                	xor    %edx,%edx
  802f14:	f7 f7                	div    %edi
  802f16:	89 c5                	mov    %eax,%ebp
  802f18:	31 d2                	xor    %edx,%edx
  802f1a:	89 c8                	mov    %ecx,%eax
  802f1c:	f7 f5                	div    %ebp
  802f1e:	89 c1                	mov    %eax,%ecx
  802f20:	89 d8                	mov    %ebx,%eax
  802f22:	f7 f5                	div    %ebp
  802f24:	89 cf                	mov    %ecx,%edi
  802f26:	89 fa                	mov    %edi,%edx
  802f28:	83 c4 1c             	add    $0x1c,%esp
  802f2b:	5b                   	pop    %ebx
  802f2c:	5e                   	pop    %esi
  802f2d:	5f                   	pop    %edi
  802f2e:	5d                   	pop    %ebp
  802f2f:	c3                   	ret    
  802f30:	39 ce                	cmp    %ecx,%esi
  802f32:	77 28                	ja     802f5c <__udivdi3+0x7c>
  802f34:	0f bd fe             	bsr    %esi,%edi
  802f37:	83 f7 1f             	xor    $0x1f,%edi
  802f3a:	75 40                	jne    802f7c <__udivdi3+0x9c>
  802f3c:	39 ce                	cmp    %ecx,%esi
  802f3e:	72 0a                	jb     802f4a <__udivdi3+0x6a>
  802f40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f44:	0f 87 9e 00 00 00    	ja     802fe8 <__udivdi3+0x108>
  802f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4f:	89 fa                	mov    %edi,%edx
  802f51:	83 c4 1c             	add    $0x1c,%esp
  802f54:	5b                   	pop    %ebx
  802f55:	5e                   	pop    %esi
  802f56:	5f                   	pop    %edi
  802f57:	5d                   	pop    %ebp
  802f58:	c3                   	ret    
  802f59:	8d 76 00             	lea    0x0(%esi),%esi
  802f5c:	31 ff                	xor    %edi,%edi
  802f5e:	31 c0                	xor    %eax,%eax
  802f60:	89 fa                	mov    %edi,%edx
  802f62:	83 c4 1c             	add    $0x1c,%esp
  802f65:	5b                   	pop    %ebx
  802f66:	5e                   	pop    %esi
  802f67:	5f                   	pop    %edi
  802f68:	5d                   	pop    %ebp
  802f69:	c3                   	ret    
  802f6a:	66 90                	xchg   %ax,%ax
  802f6c:	89 d8                	mov    %ebx,%eax
  802f6e:	f7 f7                	div    %edi
  802f70:	31 ff                	xor    %edi,%edi
  802f72:	89 fa                	mov    %edi,%edx
  802f74:	83 c4 1c             	add    $0x1c,%esp
  802f77:	5b                   	pop    %ebx
  802f78:	5e                   	pop    %esi
  802f79:	5f                   	pop    %edi
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    
  802f7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f81:	89 eb                	mov    %ebp,%ebx
  802f83:	29 fb                	sub    %edi,%ebx
  802f85:	89 f9                	mov    %edi,%ecx
  802f87:	d3 e6                	shl    %cl,%esi
  802f89:	89 c5                	mov    %eax,%ebp
  802f8b:	88 d9                	mov    %bl,%cl
  802f8d:	d3 ed                	shr    %cl,%ebp
  802f8f:	89 e9                	mov    %ebp,%ecx
  802f91:	09 f1                	or     %esi,%ecx
  802f93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f97:	89 f9                	mov    %edi,%ecx
  802f99:	d3 e0                	shl    %cl,%eax
  802f9b:	89 c5                	mov    %eax,%ebp
  802f9d:	89 d6                	mov    %edx,%esi
  802f9f:	88 d9                	mov    %bl,%cl
  802fa1:	d3 ee                	shr    %cl,%esi
  802fa3:	89 f9                	mov    %edi,%ecx
  802fa5:	d3 e2                	shl    %cl,%edx
  802fa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fab:	88 d9                	mov    %bl,%cl
  802fad:	d3 e8                	shr    %cl,%eax
  802faf:	09 c2                	or     %eax,%edx
  802fb1:	89 d0                	mov    %edx,%eax
  802fb3:	89 f2                	mov    %esi,%edx
  802fb5:	f7 74 24 0c          	divl   0xc(%esp)
  802fb9:	89 d6                	mov    %edx,%esi
  802fbb:	89 c3                	mov    %eax,%ebx
  802fbd:	f7 e5                	mul    %ebp
  802fbf:	39 d6                	cmp    %edx,%esi
  802fc1:	72 19                	jb     802fdc <__udivdi3+0xfc>
  802fc3:	74 0b                	je     802fd0 <__udivdi3+0xf0>
  802fc5:	89 d8                	mov    %ebx,%eax
  802fc7:	31 ff                	xor    %edi,%edi
  802fc9:	e9 58 ff ff ff       	jmp    802f26 <__udivdi3+0x46>
  802fce:	66 90                	xchg   %ax,%ax
  802fd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  802fd4:	89 f9                	mov    %edi,%ecx
  802fd6:	d3 e2                	shl    %cl,%edx
  802fd8:	39 c2                	cmp    %eax,%edx
  802fda:	73 e9                	jae    802fc5 <__udivdi3+0xe5>
  802fdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fdf:	31 ff                	xor    %edi,%edi
  802fe1:	e9 40 ff ff ff       	jmp    802f26 <__udivdi3+0x46>
  802fe6:	66 90                	xchg   %ax,%ax
  802fe8:	31 c0                	xor    %eax,%eax
  802fea:	e9 37 ff ff ff       	jmp    802f26 <__udivdi3+0x46>
  802fef:	90                   	nop

00802ff0 <__umoddi3>:
  802ff0:	55                   	push   %ebp
  802ff1:	57                   	push   %edi
  802ff2:	56                   	push   %esi
  802ff3:	53                   	push   %ebx
  802ff4:	83 ec 1c             	sub    $0x1c,%esp
  802ff7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802ffb:	8b 74 24 34          	mov    0x34(%esp),%esi
  802fff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803003:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803007:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80300b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80300f:	89 f3                	mov    %esi,%ebx
  803011:	89 fa                	mov    %edi,%edx
  803013:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803017:	89 34 24             	mov    %esi,(%esp)
  80301a:	85 c0                	test   %eax,%eax
  80301c:	75 1a                	jne    803038 <__umoddi3+0x48>
  80301e:	39 f7                	cmp    %esi,%edi
  803020:	0f 86 a2 00 00 00    	jbe    8030c8 <__umoddi3+0xd8>
  803026:	89 c8                	mov    %ecx,%eax
  803028:	89 f2                	mov    %esi,%edx
  80302a:	f7 f7                	div    %edi
  80302c:	89 d0                	mov    %edx,%eax
  80302e:	31 d2                	xor    %edx,%edx
  803030:	83 c4 1c             	add    $0x1c,%esp
  803033:	5b                   	pop    %ebx
  803034:	5e                   	pop    %esi
  803035:	5f                   	pop    %edi
  803036:	5d                   	pop    %ebp
  803037:	c3                   	ret    
  803038:	39 f0                	cmp    %esi,%eax
  80303a:	0f 87 ac 00 00 00    	ja     8030ec <__umoddi3+0xfc>
  803040:	0f bd e8             	bsr    %eax,%ebp
  803043:	83 f5 1f             	xor    $0x1f,%ebp
  803046:	0f 84 ac 00 00 00    	je     8030f8 <__umoddi3+0x108>
  80304c:	bf 20 00 00 00       	mov    $0x20,%edi
  803051:	29 ef                	sub    %ebp,%edi
  803053:	89 fe                	mov    %edi,%esi
  803055:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803059:	89 e9                	mov    %ebp,%ecx
  80305b:	d3 e0                	shl    %cl,%eax
  80305d:	89 d7                	mov    %edx,%edi
  80305f:	89 f1                	mov    %esi,%ecx
  803061:	d3 ef                	shr    %cl,%edi
  803063:	09 c7                	or     %eax,%edi
  803065:	89 e9                	mov    %ebp,%ecx
  803067:	d3 e2                	shl    %cl,%edx
  803069:	89 14 24             	mov    %edx,(%esp)
  80306c:	89 d8                	mov    %ebx,%eax
  80306e:	d3 e0                	shl    %cl,%eax
  803070:	89 c2                	mov    %eax,%edx
  803072:	8b 44 24 08          	mov    0x8(%esp),%eax
  803076:	d3 e0                	shl    %cl,%eax
  803078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80307c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803080:	89 f1                	mov    %esi,%ecx
  803082:	d3 e8                	shr    %cl,%eax
  803084:	09 d0                	or     %edx,%eax
  803086:	d3 eb                	shr    %cl,%ebx
  803088:	89 da                	mov    %ebx,%edx
  80308a:	f7 f7                	div    %edi
  80308c:	89 d3                	mov    %edx,%ebx
  80308e:	f7 24 24             	mull   (%esp)
  803091:	89 c6                	mov    %eax,%esi
  803093:	89 d1                	mov    %edx,%ecx
  803095:	39 d3                	cmp    %edx,%ebx
  803097:	0f 82 87 00 00 00    	jb     803124 <__umoddi3+0x134>
  80309d:	0f 84 91 00 00 00    	je     803134 <__umoddi3+0x144>
  8030a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030a7:	29 f2                	sub    %esi,%edx
  8030a9:	19 cb                	sbb    %ecx,%ebx
  8030ab:	89 d8                	mov    %ebx,%eax
  8030ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030b1:	d3 e0                	shl    %cl,%eax
  8030b3:	89 e9                	mov    %ebp,%ecx
  8030b5:	d3 ea                	shr    %cl,%edx
  8030b7:	09 d0                	or     %edx,%eax
  8030b9:	89 e9                	mov    %ebp,%ecx
  8030bb:	d3 eb                	shr    %cl,%ebx
  8030bd:	89 da                	mov    %ebx,%edx
  8030bf:	83 c4 1c             	add    $0x1c,%esp
  8030c2:	5b                   	pop    %ebx
  8030c3:	5e                   	pop    %esi
  8030c4:	5f                   	pop    %edi
  8030c5:	5d                   	pop    %ebp
  8030c6:	c3                   	ret    
  8030c7:	90                   	nop
  8030c8:	89 fd                	mov    %edi,%ebp
  8030ca:	85 ff                	test   %edi,%edi
  8030cc:	75 0b                	jne    8030d9 <__umoddi3+0xe9>
  8030ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d3:	31 d2                	xor    %edx,%edx
  8030d5:	f7 f7                	div    %edi
  8030d7:	89 c5                	mov    %eax,%ebp
  8030d9:	89 f0                	mov    %esi,%eax
  8030db:	31 d2                	xor    %edx,%edx
  8030dd:	f7 f5                	div    %ebp
  8030df:	89 c8                	mov    %ecx,%eax
  8030e1:	f7 f5                	div    %ebp
  8030e3:	89 d0                	mov    %edx,%eax
  8030e5:	e9 44 ff ff ff       	jmp    80302e <__umoddi3+0x3e>
  8030ea:	66 90                	xchg   %ax,%ax
  8030ec:	89 c8                	mov    %ecx,%eax
  8030ee:	89 f2                	mov    %esi,%edx
  8030f0:	83 c4 1c             	add    $0x1c,%esp
  8030f3:	5b                   	pop    %ebx
  8030f4:	5e                   	pop    %esi
  8030f5:	5f                   	pop    %edi
  8030f6:	5d                   	pop    %ebp
  8030f7:	c3                   	ret    
  8030f8:	3b 04 24             	cmp    (%esp),%eax
  8030fb:	72 06                	jb     803103 <__umoddi3+0x113>
  8030fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803101:	77 0f                	ja     803112 <__umoddi3+0x122>
  803103:	89 f2                	mov    %esi,%edx
  803105:	29 f9                	sub    %edi,%ecx
  803107:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80310b:	89 14 24             	mov    %edx,(%esp)
  80310e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803112:	8b 44 24 04          	mov    0x4(%esp),%eax
  803116:	8b 14 24             	mov    (%esp),%edx
  803119:	83 c4 1c             	add    $0x1c,%esp
  80311c:	5b                   	pop    %ebx
  80311d:	5e                   	pop    %esi
  80311e:	5f                   	pop    %edi
  80311f:	5d                   	pop    %ebp
  803120:	c3                   	ret    
  803121:	8d 76 00             	lea    0x0(%esi),%esi
  803124:	2b 04 24             	sub    (%esp),%eax
  803127:	19 fa                	sbb    %edi,%edx
  803129:	89 d1                	mov    %edx,%ecx
  80312b:	89 c6                	mov    %eax,%esi
  80312d:	e9 71 ff ff ff       	jmp    8030a3 <__umoddi3+0xb3>
  803132:	66 90                	xchg   %ax,%ax
  803134:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803138:	72 ea                	jb     803124 <__umoddi3+0x134>
  80313a:	89 d9                	mov    %ebx,%ecx
  80313c:	e9 62 ff ff ff       	jmp    8030a3 <__umoddi3+0xb3>
