
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 48 07 00 00       	call   80077e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 cc 1c 00 00       	call   801d1c <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 80 2f 80 00       	push   $0x802f80
  800058:	e8 b4 0b 00 00       	call   800c11 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 82 2f 80 00       	push   $0x802f82
  800068:	e8 a4 0b 00 00       	call   800c11 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 98 2f 80 00       	push   $0x802f98
  800078:	e8 94 0b 00 00       	call   800c11 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 82 2f 80 00       	push   $0x802f82
  800088:	e8 84 0b 00 00       	call   800c11 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 80 2f 80 00       	push   $0x802f80
  800098:	e8 74 0b 00 00       	call   800c11 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 b0 2f 80 00       	push   $0x802fb0
  8000a8:	e8 64 0b 00 00       	call   800c11 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 cf 2f 80 00       	push   $0x802fcf
  8000d7:	e8 35 0b 00 00       	call   800c11 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 e5 1a 00 00       	call   801bd3 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 d4 2f 80 00       	push   $0x802fd4
  8000fc:	e8 10 0b 00 00       	call   800c11 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 f6 2f 80 00       	push   $0x802ff6
  80010c:	e8 00 0b 00 00       	call   800c11 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 04 30 80 00       	push   $0x803004
  80011c:	e8 f0 0a 00 00       	call   800c11 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 13 30 80 00       	push   $0x803013
  80012c:	e8 e0 0a 00 00       	call   800c11 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 23 30 80 00       	push   $0x803023
  80013c:	e8 d0 0a 00 00       	call   800c11 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 db 05 00 00       	call   800742 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 ce 05 00 00       	call   800742 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_unlock_cons();
  800189:	e8 a8 1b 00 00       	call   801d36 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f9 01 00 00       	call   8003a8 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 17 02 00 00       	call   8003d9 <InitializeIdentical>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 39 02 00 00       	call   80040e <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 26 02 00 00       	call   80040e <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 f2 02 00 00       	call   8004ed <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fe:	e8 19 1b 00 00       	call   801d1c <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 2c 30 80 00       	push   $0x80302c
  80020b:	e8 01 0a 00 00       	call   800c11 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  800213:	e8 1e 1b 00 00       	call   801d36 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d8 00 00 00       	call   8002fe <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 60 30 80 00       	push   $0x803060
  80023a:	6a 58                	push   $0x58
  80023c:	68 82 30 80 00       	push   $0x803082
  800241:	e8 fd 06 00 00       	call   800943 <_panic>
		else
		{
			sys_lock_cons();
  800246:	e8 d1 1a 00 00       	call   801d1c <sys_lock_cons>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 a0 30 80 00       	push   $0x8030a0
  800253:	e8 b9 09 00 00       	call   800c11 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 d4 30 80 00       	push   $0x8030d4
  800263:	e8 a9 09 00 00       	call   800c11 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 08 31 80 00       	push   $0x803108
  800273:	e8 99 09 00 00       	call   800c11 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80027b:	e8 b6 1a 00 00       	call   801d36 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  800280:	e8 97 1a 00 00       	call   801d1c <sys_lock_cons>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 3a 31 80 00       	push   $0x80313a
  800293:	e8 79 09 00 00       	call   800c11 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 84 04 00 00       	call   800742 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 77 04 00 00       	call   800742 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 6a 04 00 00       	call   800742 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  8002e7:	e8 4a 1a 00 00       	call   801d36 <sys_unlock_cons>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  8002f6:	e8 d8 1d 00 00       	call   8020d3 <inctst>

}
  8002fb:	90                   	nop
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800304:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800312:	eb 33                	jmp    800347 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800328:	40                   	inc    %eax
  800329:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	7e 09                	jle    800344 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80033b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800342:	eb 0c                	jmp    800350 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800344:	ff 45 f8             	incl   -0x8(%ebp)
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	48                   	dec    %eax
  80034b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80034e:	7f c4                	jg     800314 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 c2                	add    %eax,%edx
  80037e:	8b 45 10             	mov    0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a3:	89 02                	mov    %eax,(%edx)
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b5:	eb 17                	jmp    8003ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c e1                	jl     8003b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e6:	eb 1b                	jmp    800403 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c2                	add    %eax,%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003fd:	48                   	dec    %eax
  8003fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	ff 45 fc             	incl   -0x4(%ebp)
  800403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800406:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800409:	7c dd                	jl     8003e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800417:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80041c:	f7 e9                	imul   %ecx
  80041e:	c1 f9 1f             	sar    $0x1f,%ecx
  800421:	89 d0                	mov    %edx,%eax
  800423:	29 c8                	sub    %ecx,%eax
  800425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800428:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80042c:	75 07                	jne    800435 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80042e:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1e                	jmp    80045c <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800451:	99                   	cltd   
  800452:	f7 7d f8             	idivl  -0x8(%ebp)
  800455:	89 d0                	mov    %edx,%eax
  800457:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	ff 45 fc             	incl   -0x4(%ebp)
  80045c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800462:	7c da                	jl     80043e <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80046d:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 42                	jmp    8004bf <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80047d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800480:	99                   	cltd   
  800481:	f7 7d f0             	idivl  -0x10(%ebp)
  800484:	89 d0                	mov    %edx,%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	75 10                	jne    80049a <PrintElements+0x33>
			cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 80 2f 80 00       	push   $0x802f80
  800492:	e8 7a 07 00 00       	call   800c11 <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 58 31 80 00       	push   $0x803158
  8004b4:	e8 58 07 00 00       	call   800c11 <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bc:	ff 45 f4             	incl   -0xc(%ebp)
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	48                   	dec    %eax
  8004c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004c6:	7f b5                	jg     80047d <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 cf 2f 80 00       	push   $0x802fcf
  8004e2:	e8 2a 07 00 00       	call   800c11 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp

}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <MSort>:


void MSort(int* A, int p, int r)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004f9:	7d 54                	jge    80054f <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 1f             	shr    $0x1f,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	d1 f8                	sar    %eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	ff 75 f4             	pushl  -0xc(%ebp)
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 08             	pushl  0x8(%ebp)
  80051b:	e8 cd ff ff ff       	call   8004ed <MSort>
  800520:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	40                   	inc    %eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	ff 75 10             	pushl  0x10(%ebp)
  80052d:	50                   	push   %eax
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	e8 b7 ff ff ff       	call   8004ed <MSort>
  800536:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800539:	ff 75 10             	pushl  0x10(%ebp)
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 08 00 00 00       	call   800552 <Merge>
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb 01                	jmp    800550 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80054f:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80055e:	40                   	inc    %eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	2b 45 10             	sub    0x10(%ebp),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80056b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	c1 e0 02             	shl    $0x2,%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	50                   	push   %eax
  800583:	e8 4b 16 00 00       	call   801bd3 <malloc>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 36 16 00 00       	call   801bd3 <malloc>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8005aa:	eb 2f                	jmp    8005db <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	01 c2                	add    %eax,%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005d8:	ff 45 ec             	incl   -0x14(%ebp)
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e1:	7c c9                	jl     8005ac <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ea:	eb 2a                	jmp    800616 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f9:	01 c2                	add    %eax,%edx
  8005fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800613:	ff 45 e8             	incl   -0x18(%ebp)
  800616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	7c ce                	jl     8005ec <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800624:	e9 0a 01 00 00       	jmp    800733 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80062f:	0f 8d 95 00 00 00    	jge    8006ca <Merge+0x178>
  800635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800638:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80063b:	0f 8d 89 00 00 00    	jge    8006ca <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800655:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	01 c8                	add    %ecx,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	7d 33                	jge    80069a <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800685:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800695:	e9 96 00 00 00       	jmp    800730 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006c8:	eb 66                	jmp    800730 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006d0:	7d 30                	jge    800702 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 01                	mov    %eax,(%ecx)
  800700:	eb 2e                	jmp    800730 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800705:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072a:	01 d0                	add    %edx,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800730:	ff 45 e4             	incl   -0x1c(%ebp)
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	3b 45 14             	cmp    0x14(%ebp),%eax
  800739:	0f 8e ea fe ff ff    	jle    800629 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80074e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 09 17 00 00       	call   801e64 <sys_cputc>
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getchar>:


int
getchar(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800767:	e8 97 15 00 00       	call   801d03 <sys_cgetc>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <iscons>:

int iscons(int fdnum)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800787:	e8 09 18 00 00       	call   801f95 <sys_getenvindex>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80078f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 06             	shl    $0x6,%eax
  800797:	29 d0                	sub    %edx,%eax
  800799:	c1 e0 02             	shl    $0x2,%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	c1 e0 03             	shl    $0x3,%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8007bc:	89 c2                	mov    %eax,%edx
  8007be:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007c4:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c9:	a1 24 40 80 00       	mov    0x804024,%eax
  8007ce:	8a 40 20             	mov    0x20(%eax),%al
  8007d1:	84 c0                	test   %al,%al
  8007d3:	74 0d                	je     8007e2 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8007d5:	a1 24 40 80 00       	mov    0x804024,%eax
  8007da:	83 c0 20             	add    $0x20,%eax
  8007dd:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e6:	7e 0a                	jle    8007f2 <libmain+0x74>
		binaryname = argv[0];
  8007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	ff 75 08             	pushl  0x8(%ebp)
  8007fb:	e8 38 f8 ff ff       	call   800038 <_main>
  800800:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800803:	a1 00 40 80 00       	mov    0x804000,%eax
  800808:	85 c0                	test   %eax,%eax
  80080a:	0f 84 01 01 00 00    	je     800911 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800810:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800816:	bb 58 32 80 00       	mov    $0x803258,%ebx
  80081b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800820:	89 c7                	mov    %eax,%edi
  800822:	89 de                	mov    %ebx,%esi
  800824:	89 d1                	mov    %edx,%ecx
  800826:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800828:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80082b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800830:	b0 00                	mov    $0x0,%al
  800832:	89 d7                	mov    %edx,%edi
  800834:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80083d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	50                   	push   %eax
  800844:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	e8 7b 19 00 00       	call   8021cb <sys_utilities>
  800850:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800853:	e8 c4 14 00 00       	call   801d1c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800858:	83 ec 0c             	sub    $0xc,%esp
  80085b:	68 78 31 80 00       	push   $0x803178
  800860:	e8 ac 03 00 00       	call   800c11 <cprintf>
  800865:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086b:	85 c0                	test   %eax,%eax
  80086d:	74 18                	je     800887 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80086f:	e8 75 19 00 00       	call   8021e9 <sys_get_optimal_num_faults>
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	50                   	push   %eax
  800878:	68 a0 31 80 00       	push   $0x8031a0
  80087d:	e8 8f 03 00 00       	call   800c11 <cprintf>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	eb 59                	jmp    8008e0 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800887:	a1 24 40 80 00       	mov    0x804024,%eax
  80088c:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800892:	a1 24 40 80 00       	mov    0x804024,%eax
  800897:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80089d:	83 ec 04             	sub    $0x4,%esp
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 c4 31 80 00       	push   $0x8031c4
  8008a7:	e8 65 03 00 00       	call   800c11 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008af:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b4:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8008ba:	a1 24 40 80 00       	mov    0x804024,%eax
  8008bf:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8008c5:	a1 24 40 80 00       	mov    0x804024,%eax
  8008ca:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8008d0:	51                   	push   %ecx
  8008d1:	52                   	push   %edx
  8008d2:	50                   	push   %eax
  8008d3:	68 ec 31 80 00       	push   $0x8031ec
  8008d8:	e8 34 03 00 00       	call   800c11 <cprintf>
  8008dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008e0:	a1 24 40 80 00       	mov    0x804024,%eax
  8008e5:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	50                   	push   %eax
  8008ef:	68 44 32 80 00       	push   $0x803244
  8008f4:	e8 18 03 00 00       	call   800c11 <cprintf>
  8008f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008fc:	83 ec 0c             	sub    $0xc,%esp
  8008ff:	68 78 31 80 00       	push   $0x803178
  800904:	e8 08 03 00 00       	call   800c11 <cprintf>
  800909:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80090c:	e8 25 14 00 00       	call   801d36 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800911:	e8 1f 00 00 00       	call   800935 <exit>
}
  800916:	90                   	nop
  800917:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5f                   	pop    %edi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800925:	83 ec 0c             	sub    $0xc,%esp
  800928:	6a 00                	push   $0x0
  80092a:	e8 32 16 00 00       	call   801f61 <sys_destroy_env>
  80092f:	83 c4 10             	add    $0x10,%esp
}
  800932:	90                   	nop
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <exit>:

void
exit(void)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80093b:	e8 87 16 00 00       	call   801fc7 <sys_exit_env>
}
  800940:	90                   	nop
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800949:	8d 45 10             	lea    0x10(%ebp),%eax
  80094c:	83 c0 04             	add    $0x4,%eax
  80094f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800952:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800957:	85 c0                	test   %eax,%eax
  800959:	74 16                	je     800971 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80095b:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	50                   	push   %eax
  800964:	68 bc 32 80 00       	push   $0x8032bc
  800969:	e8 a3 02 00 00       	call   800c11 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800971:	a1 04 40 80 00       	mov    0x804004,%eax
  800976:	83 ec 0c             	sub    $0xc,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	50                   	push   %eax
  800980:	68 c4 32 80 00       	push   $0x8032c4
  800985:	6a 74                	push   $0x74
  800987:	e8 b2 02 00 00       	call   800c3e <cprintf_colored>
  80098c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80098f:	8b 45 10             	mov    0x10(%ebp),%eax
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 f4             	pushl  -0xc(%ebp)
  800998:	50                   	push   %eax
  800999:	e8 04 02 00 00       	call   800ba2 <vcprintf>
  80099e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	6a 00                	push   $0x0
  8009a6:	68 ec 32 80 00       	push   $0x8032ec
  8009ab:	e8 f2 01 00 00       	call   800ba2 <vcprintf>
  8009b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009b3:	e8 7d ff ff ff       	call   800935 <exit>

	// should not return here
	while (1) ;
  8009b8:	eb fe                	jmp    8009b8 <_panic+0x75>

008009ba <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009c0:	a1 24 40 80 00       	mov    0x804024,%eax
  8009c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ce:	39 c2                	cmp    %eax,%edx
  8009d0:	74 14                	je     8009e6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009d2:	83 ec 04             	sub    $0x4,%esp
  8009d5:	68 f0 32 80 00       	push   $0x8032f0
  8009da:	6a 26                	push   $0x26
  8009dc:	68 3c 33 80 00       	push   $0x80333c
  8009e1:	e8 5d ff ff ff       	call   800943 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f4:	e9 c5 00 00 00       	jmp    800abe <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	01 d0                	add    %edx,%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	85 c0                	test   %eax,%eax
  800a0c:	75 08                	jne    800a16 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a0e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a11:	e9 a5 00 00 00       	jmp    800abb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a16:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a24:	eb 69                	jmp    800a8f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a26:	a1 24 40 80 00       	mov    0x804024,%eax
  800a2b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a34:	89 d0                	mov    %edx,%eax
  800a36:	01 c0                	add    %eax,%eax
  800a38:	01 d0                	add    %edx,%eax
  800a3a:	c1 e0 03             	shl    $0x3,%eax
  800a3d:	01 c8                	add    %ecx,%eax
  800a3f:	8a 40 04             	mov    0x4(%eax),%al
  800a42:	84 c0                	test   %al,%al
  800a44:	75 46                	jne    800a8c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a46:	a1 24 40 80 00       	mov    0x804024,%eax
  800a4b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a54:	89 d0                	mov    %edx,%eax
  800a56:	01 c0                	add    %eax,%eax
  800a58:	01 d0                	add    %edx,%eax
  800a5a:	c1 e0 03             	shl    $0x3,%eax
  800a5d:	01 c8                	add    %ecx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a6c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a71:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	01 c8                	add    %ecx,%eax
  800a7d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a7f:	39 c2                	cmp    %eax,%edx
  800a81:	75 09                	jne    800a8c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a83:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a8a:	eb 15                	jmp    800aa1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8c:	ff 45 e8             	incl   -0x18(%ebp)
  800a8f:	a1 24 40 80 00       	mov    0x804024,%eax
  800a94:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a9d:	39 c2                	cmp    %eax,%edx
  800a9f:	77 85                	ja     800a26 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa5:	75 14                	jne    800abb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800aa7:	83 ec 04             	sub    $0x4,%esp
  800aaa:	68 48 33 80 00       	push   $0x803348
  800aaf:	6a 3a                	push   $0x3a
  800ab1:	68 3c 33 80 00       	push   $0x80333c
  800ab6:	e8 88 fe ff ff       	call   800943 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800abb:	ff 45 f0             	incl   -0x10(%ebp)
  800abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ac4:	0f 8c 2f ff ff ff    	jl     8009f9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800aca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ad8:	eb 26                	jmp    800b00 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ada:	a1 24 40 80 00       	mov    0x804024,%eax
  800adf:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	01 c0                	add    %eax,%eax
  800aec:	01 d0                	add    %edx,%eax
  800aee:	c1 e0 03             	shl    $0x3,%eax
  800af1:	01 c8                	add    %ecx,%eax
  800af3:	8a 40 04             	mov    0x4(%eax),%al
  800af6:	3c 01                	cmp    $0x1,%al
  800af8:	75 03                	jne    800afd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800afa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800afd:	ff 45 e0             	incl   -0x20(%ebp)
  800b00:	a1 24 40 80 00       	mov    0x804024,%eax
  800b05:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0e:	39 c2                	cmp    %eax,%edx
  800b10:	77 c8                	ja     800ada <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b15:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b18:	74 14                	je     800b2e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b1a:	83 ec 04             	sub    $0x4,%esp
  800b1d:	68 9c 33 80 00       	push   $0x80339c
  800b22:	6a 44                	push   $0x44
  800b24:	68 3c 33 80 00       	push   $0x80333c
  800b29:	e8 15 fe ff ff       	call   800943 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b2e:	90                   	nop
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	53                   	push   %ebx
  800b35:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b43:	89 0a                	mov    %ecx,(%edx)
  800b45:	8b 55 08             	mov    0x8(%ebp),%edx
  800b48:	88 d1                	mov    %dl,%cl
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b5b:	75 30                	jne    800b8d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b5d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b63:	a0 44 40 80 00       	mov    0x804044,%al
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6e:	8b 09                	mov    (%ecx),%ecx
  800b70:	89 cb                	mov    %ecx,%ebx
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b75:	83 c1 08             	add    $0x8,%ecx
  800b78:	52                   	push   %edx
  800b79:	50                   	push   %eax
  800b7a:	53                   	push   %ebx
  800b7b:	51                   	push   %ecx
  800b7c:	e8 57 11 00 00       	call   801cd8 <sys_cputs>
  800b81:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b90:	8b 40 04             	mov    0x4(%eax),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b9c:	90                   	nop
  800b9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bb2:	00 00 00 
	b.cnt = 0;
  800bb5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bbc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bcb:	50                   	push   %eax
  800bcc:	68 31 0b 80 00       	push   $0x800b31
  800bd1:	e8 5a 02 00 00       	call   800e30 <vprintfmt>
  800bd6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bd9:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bdf:	a0 44 40 80 00       	mov    0x804044,%al
  800be4:	0f b6 c0             	movzbl %al,%eax
  800be7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bed:	52                   	push   %edx
  800bee:	50                   	push   %eax
  800bef:	51                   	push   %ecx
  800bf0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bf6:	83 c0 08             	add    $0x8,%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 d9 10 00 00       	call   801cd8 <sys_cputs>
  800bff:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c02:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c09:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c17:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c1e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2d:	50                   	push   %eax
  800c2e:	e8 6f ff ff ff       	call   800ba2 <vcprintf>
  800c33:	83 c4 10             	add    $0x10,%esp
  800c36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3c:	c9                   	leave  
  800c3d:	c3                   	ret    

00800c3e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c44:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	c1 e0 08             	shl    $0x8,%eax
  800c51:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c56:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c59:	83 c0 04             	add    $0x4,%eax
  800c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	e8 34 ff ff ff       	call   800ba2 <vcprintf>
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c74:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c7b:	07 00 00 

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c89:	e8 8e 10 00 00       	call   801d1c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 ff fe ff ff       	call   800ba2 <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ca9:	e8 88 10 00 00       	call   801d36 <sys_unlock_cons>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 08 20 00 00       	call   802d00 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 c8 20 00 00       	call   802e10 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 14 36 80 00       	add    $0x803614,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 c1 03 00 00    	je     801203 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 5b             	cmp    $0x5b,%eax
  800e98:	0f 87 3d 03 00 00    	ja     8011db <vprintfmt+0x3ab>
  800e9e:	8b 04 85 38 36 80 00 	mov    0x803638(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 9b 02 00 00       	jmp    8011fe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d 80 34 80 00 	mov    0x803480(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 25 36 80 00       	push   $0x803625
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 70 02 00 00       	call   80120b <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 5b 02 00 00       	jmp    8011fe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 2e 36 80 00       	push   $0x80362e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 57 02 00 00       	call   80120b <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 42 02 00 00       	jmp    8011fe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 31 36 80 00       	mov    $0x803631,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 1e 03 00 00       	call   80130d <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 78 01 00 00       	jmp    8011fe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 ce 00 00 00       	jmp    8011fe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 46                	jmp    8011fe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 35                	jmp    8011fe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011c9:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011d0:	eb 2c                	jmp    8011fe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011d2:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011d9:	eb 23                	jmp    8011fe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	6a 25                	push   $0x25
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	ff d0                	call   *%eax
  8011e8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011eb:	ff 4d 10             	decl   0x10(%ebp)
  8011ee:	eb 03                	jmp    8011f3 <vprintfmt+0x3c3>
  8011f0:	ff 4d 10             	decl   0x10(%ebp)
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	48                   	dec    %eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 25                	cmp    $0x25,%al
  8011fb:	75 f3                	jne    8011f0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011fd:	90                   	nop
		}
	}
  8011fe:	e9 35 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801203:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801204:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 04 fc ff ff       	call   800e30 <vprintfmt>
  80122c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	8b 40 08             	mov    0x8(%eax),%eax
  80123b:	8d 50 01             	lea    0x1(%eax),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	8b 10                	mov    (%eax),%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	8b 40 04             	mov    0x4(%eax),%eax
  80124f:	39 c2                	cmp    %eax,%edx
  801251:	73 12                	jae    801265 <sprintputch+0x33>
		*b->buf++ = ch;
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	8b 00                	mov    (%eax),%eax
  801258:	8d 48 01             	lea    0x1(%eax),%ecx
  80125b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125e:	89 0a                	mov    %ecx,(%edx)
  801260:	8b 55 08             	mov    0x8(%ebp),%edx
  801263:	88 10                	mov    %dl,(%eax)
}
  801265:	90                   	nop
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801274:	8b 45 0c             	mov    0xc(%ebp),%eax
  801277:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801282:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	74 06                	je     801295 <vsnprintf+0x2d>
  80128f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801293:	7f 07                	jg     80129c <vsnprintf+0x34>
		return -E_INVAL;
  801295:	b8 03 00 00 00       	mov    $0x3,%eax
  80129a:	eb 20                	jmp    8012bc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80129c:	ff 75 14             	pushl  0x14(%ebp)
  80129f:	ff 75 10             	pushl  0x10(%ebp)
  8012a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	68 32 12 80 00       	push   $0x801232
  8012ab:	e8 80 fb ff ff       	call   800e30 <vprintfmt>
  8012b0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d3:	50                   	push   %eax
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	ff 75 08             	pushl  0x8(%ebp)
  8012da:	e8 89 ff ff ff       	call   801268 <vsnprintf>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f7:	eb 06                	jmp    8012ff <strlen+0x15>
		n++;
  8012f9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012fc:	ff 45 08             	incl   0x8(%ebp)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	84 c0                	test   %al,%al
  801306:	75 f1                	jne    8012f9 <strlen+0xf>
		n++;
	return n;
  801308:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131a:	eb 09                	jmp    801325 <strnlen+0x18>
		n++;
  80131c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131f:	ff 45 08             	incl   0x8(%ebp)
  801322:	ff 4d 0c             	decl   0xc(%ebp)
  801325:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801329:	74 09                	je     801334 <strnlen+0x27>
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e8                	jne    80131c <strnlen+0xf>
		n++;
	return n;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801345:	90                   	nop
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8d 50 01             	lea    0x1(%eax),%edx
  80134c:	89 55 08             	mov    %edx,0x8(%ebp)
  80134f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801352:	8d 4a 01             	lea    0x1(%edx),%ecx
  801355:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801358:	8a 12                	mov    (%edx),%dl
  80135a:	88 10                	mov    %dl,(%eax)
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	75 e4                	jne    801346 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137a:	eb 1f                	jmp    80139b <strncpy+0x34>
		*dst++ = *src;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 08             	mov    %edx,0x8(%ebp)
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	8a 12                	mov    (%edx),%dl
  80138a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	84 c0                	test   %al,%al
  801393:	74 03                	je     801398 <strncpy+0x31>
			src++;
  801395:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801398:	ff 45 fc             	incl   -0x4(%ebp)
  80139b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139e:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a1:	72 d9                	jb     80137c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 30                	je     8013ea <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013ba:	eb 16                	jmp    8013d2 <strlcpy+0x2a>
			*dst++ = *src++;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8d 50 01             	lea    0x1(%eax),%edx
  8013c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ce:	8a 12                	mov    (%edx),%dl
  8013d0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013d2:	ff 4d 10             	decl   0x10(%ebp)
  8013d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d9:	74 09                	je     8013e4 <strlcpy+0x3c>
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 d8                	jne    8013bc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013f9:	eb 06                	jmp    801401 <strcmp+0xb>
		p++, q++;
  8013fb:	ff 45 08             	incl   0x8(%ebp)
  8013fe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	84 c0                	test   %al,%al
  801408:	74 0e                	je     801418 <strcmp+0x22>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 10                	mov    (%eax),%dl
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	38 c2                	cmp    %al,%dl
  801416:	74 e3                	je     8013fb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	0f b6 d0             	movzbl %al,%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 c0             	movzbl %al,%eax
  801428:	29 c2                	sub    %eax,%edx
  80142a:	89 d0                	mov    %edx,%eax
}
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801431:	eb 09                	jmp    80143c <strncmp+0xe>
		n--, p++, q++;
  801433:	ff 4d 10             	decl   0x10(%ebp)
  801436:	ff 45 08             	incl   0x8(%ebp)
  801439:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	74 17                	je     801459 <strncmp+0x2b>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 0e                	je     801459 <strncmp+0x2b>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 10                	mov    (%eax),%dl
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	38 c2                	cmp    %al,%dl
  801457:	74 da                	je     801433 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801459:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145d:	75 07                	jne    801466 <strncmp+0x38>
		return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
  801464:	eb 14                	jmp    80147a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f b6 d0             	movzbl %al,%edx
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	0f b6 c0             	movzbl %al,%eax
  801476:	29 c2                	sub    %eax,%edx
  801478:	89 d0                	mov    %edx,%eax
}
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801488:	eb 12                	jmp    80149c <strchr+0x20>
		if (*s == c)
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801492:	75 05                	jne    801499 <strchr+0x1d>
			return (char *) s;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	eb 11                	jmp    8014aa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801499:	ff 45 08             	incl   0x8(%ebp)
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	84 c0                	test   %al,%al
  8014a3:	75 e5                	jne    80148a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014b8:	eb 0d                	jmp    8014c7 <strfind+0x1b>
		if (*s == c)
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014c2:	74 0e                	je     8014d2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c4:	ff 45 08             	incl   0x8(%ebp)
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	84 c0                	test   %al,%al
  8014ce:	75 ea                	jne    8014ba <strfind+0xe>
  8014d0:	eb 01                	jmp    8014d3 <strfind+0x27>
		if (*s == c)
			break;
  8014d2:	90                   	nop
	return (char *) s;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014e4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014e8:	76 63                	jbe    80154d <memset+0x75>
		uint64 data_block = c;
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	99                   	cltd   
  8014ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fa:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014fe:	c1 e0 08             	shl    $0x8,%eax
  801501:	09 45 f0             	or     %eax,-0x10(%ebp)
  801504:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801511:	c1 e0 10             	shl    $0x10,%eax
  801514:	09 45 f0             	or     %eax,-0x10(%ebp)
  801517:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801520:	89 c2                	mov    %eax,%edx
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
  801527:	09 45 f0             	or     %eax,-0x10(%ebp)
  80152a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80152d:	eb 18                	jmp    801547 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80152f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801532:	8d 41 08             	lea    0x8(%ecx),%eax
  801535:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153e:	89 01                	mov    %eax,(%ecx)
  801540:	89 51 04             	mov    %edx,0x4(%ecx)
  801543:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801547:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80154b:	77 e2                	ja     80152f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80154d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801551:	74 23                	je     801576 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801553:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801556:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801559:	eb 0e                	jmp    801569 <memset+0x91>
			*p8++ = (uint8)c;
  80155b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155e:	8d 50 01             	lea    0x1(%eax),%edx
  801561:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801569:	8b 45 10             	mov    0x10(%ebp),%eax
  80156c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156f:	89 55 10             	mov    %edx,0x10(%ebp)
  801572:	85 c0                	test   %eax,%eax
  801574:	75 e5                	jne    80155b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80158d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801591:	76 24                	jbe    8015b7 <memcpy+0x3c>
		while(n >= 8){
  801593:	eb 1c                	jmp    8015b1 <memcpy+0x36>
			*d64 = *s64;
  801595:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801598:	8b 50 04             	mov    0x4(%eax),%edx
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a0:	89 01                	mov    %eax,(%ecx)
  8015a2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015a5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015a9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015ad:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015b1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015b5:	77 de                	ja     801595 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bb:	74 31                	je     8015ee <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015c9:	eb 16                	jmp    8015e1 <memcpy+0x66>
			*d8++ = *s8++;
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	8d 50 01             	lea    0x1(%eax),%edx
  8015d1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015da:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015dd:	8a 12                	mov    (%edx),%dl
  8015df:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 dd                	jne    8015cb <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80160b:	73 50                	jae    80165d <memmove+0x6a>
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801618:	76 43                	jbe    80165d <memmove+0x6a>
		s += n;
  80161a:	8b 45 10             	mov    0x10(%ebp),%eax
  80161d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801620:	8b 45 10             	mov    0x10(%ebp),%eax
  801623:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801626:	eb 10                	jmp    801638 <memmove+0x45>
			*--d = *--s;
  801628:	ff 4d f8             	decl   -0x8(%ebp)
  80162b:	ff 4d fc             	decl   -0x4(%ebp)
  80162e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801631:	8a 10                	mov    (%eax),%dl
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801636:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801638:	8b 45 10             	mov    0x10(%ebp),%eax
  80163b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163e:	89 55 10             	mov    %edx,0x10(%ebp)
  801641:	85 c0                	test   %eax,%eax
  801643:	75 e3                	jne    801628 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801645:	eb 23                	jmp    80166a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801647:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164a:	8d 50 01             	lea    0x1(%eax),%edx
  80164d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801650:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801653:	8d 4a 01             	lea    0x1(%edx),%ecx
  801656:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801659:	8a 12                	mov    (%edx),%dl
  80165b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	8d 50 ff             	lea    -0x1(%eax),%edx
  801663:	89 55 10             	mov    %edx,0x10(%ebp)
  801666:	85 c0                	test   %eax,%eax
  801668:	75 dd                	jne    801647 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801681:	eb 2a                	jmp    8016ad <memcmp+0x3e>
		if (*s1 != *s2)
  801683:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801686:	8a 10                	mov    (%eax),%dl
  801688:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	38 c2                	cmp    %al,%dl
  80168f:	74 16                	je     8016a7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	0f b6 d0             	movzbl %al,%edx
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	0f b6 c0             	movzbl %al,%eax
  8016a1:	29 c2                	sub    %eax,%edx
  8016a3:	89 d0                	mov    %edx,%eax
  8016a5:	eb 18                	jmp    8016bf <memcmp+0x50>
		s1++, s2++;
  8016a7:	ff 45 fc             	incl   -0x4(%ebp)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	75 c9                	jne    801683 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016d2:	eb 15                	jmp    8016e9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	0f b6 d0             	movzbl %al,%edx
  8016dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016df:	0f b6 c0             	movzbl %al,%eax
  8016e2:	39 c2                	cmp    %eax,%edx
  8016e4:	74 0d                	je     8016f3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e6:	ff 45 08             	incl   0x8(%ebp)
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ef:	72 e3                	jb     8016d4 <memfind+0x13>
  8016f1:	eb 01                	jmp    8016f4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016f3:	90                   	nop
	return (void *) s;
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801706:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170d:	eb 03                	jmp    801712 <strtol+0x19>
		s++;
  80170f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	3c 20                	cmp    $0x20,%al
  801719:	74 f4                	je     80170f <strtol+0x16>
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8a 00                	mov    (%eax),%al
  801720:	3c 09                	cmp    $0x9,%al
  801722:	74 eb                	je     80170f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	3c 2b                	cmp    $0x2b,%al
  80172b:	75 05                	jne    801732 <strtol+0x39>
		s++;
  80172d:	ff 45 08             	incl   0x8(%ebp)
  801730:	eb 13                	jmp    801745 <strtol+0x4c>
	else if (*s == '-')
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	3c 2d                	cmp    $0x2d,%al
  801739:	75 0a                	jne    801745 <strtol+0x4c>
		s++, neg = 1;
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801745:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801749:	74 06                	je     801751 <strtol+0x58>
  80174b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80174f:	75 20                	jne    801771 <strtol+0x78>
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	3c 30                	cmp    $0x30,%al
  801758:	75 17                	jne    801771 <strtol+0x78>
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	40                   	inc    %eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 78                	cmp    $0x78,%al
  801762:	75 0d                	jne    801771 <strtol+0x78>
		s += 2, base = 16;
  801764:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801768:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80176f:	eb 28                	jmp    801799 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801771:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801775:	75 15                	jne    80178c <strtol+0x93>
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	3c 30                	cmp    $0x30,%al
  80177e:	75 0c                	jne    80178c <strtol+0x93>
		s++, base = 8;
  801780:	ff 45 08             	incl   0x8(%ebp)
  801783:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80178a:	eb 0d                	jmp    801799 <strtol+0xa0>
	else if (base == 0)
  80178c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801790:	75 07                	jne    801799 <strtol+0xa0>
		base = 10;
  801792:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	3c 2f                	cmp    $0x2f,%al
  8017a0:	7e 19                	jle    8017bb <strtol+0xc2>
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	3c 39                	cmp    $0x39,%al
  8017a9:	7f 10                	jg     8017bb <strtol+0xc2>
			dig = *s - '0';
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	0f be c0             	movsbl %al,%eax
  8017b3:	83 e8 30             	sub    $0x30,%eax
  8017b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b9:	eb 42                	jmp    8017fd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	3c 60                	cmp    $0x60,%al
  8017c2:	7e 19                	jle    8017dd <strtol+0xe4>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	3c 7a                	cmp    $0x7a,%al
  8017cb:	7f 10                	jg     8017dd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	0f be c0             	movsbl %al,%eax
  8017d5:	83 e8 57             	sub    $0x57,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017db:	eb 20                	jmp    8017fd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	3c 40                	cmp    $0x40,%al
  8017e4:	7e 39                	jle    80181f <strtol+0x126>
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8a 00                	mov    (%eax),%al
  8017eb:	3c 5a                	cmp    $0x5a,%al
  8017ed:	7f 30                	jg     80181f <strtol+0x126>
			dig = *s - 'A' + 10;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	0f be c0             	movsbl %al,%eax
  8017f7:	83 e8 37             	sub    $0x37,%eax
  8017fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801800:	3b 45 10             	cmp    0x10(%ebp),%eax
  801803:	7d 19                	jge    80181e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801805:	ff 45 08             	incl   0x8(%ebp)
  801808:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80180f:	89 c2                	mov    %eax,%edx
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	01 d0                	add    %edx,%eax
  801816:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801819:	e9 7b ff ff ff       	jmp    801799 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80181e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80181f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801823:	74 08                	je     80182d <strtol+0x134>
		*endptr = (char *) s;
  801825:	8b 45 0c             	mov    0xc(%ebp),%eax
  801828:	8b 55 08             	mov    0x8(%ebp),%edx
  80182b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80182d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801831:	74 07                	je     80183a <strtol+0x141>
  801833:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801836:	f7 d8                	neg    %eax
  801838:	eb 03                	jmp    80183d <strtol+0x144>
  80183a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <ltostr>:

void
ltostr(long value, char *str)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80184c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801853:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801857:	79 13                	jns    80186c <ltostr+0x2d>
	{
		neg = 1;
  801859:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801866:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801869:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801874:	99                   	cltd   
  801875:	f7 f9                	idiv   %ecx
  801877:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8d 50 01             	lea    0x1(%eax),%edx
  801880:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801883:	89 c2                	mov    %eax,%edx
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188d:	83 c2 30             	add    $0x30,%edx
  801890:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801892:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801895:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80189a:	f7 e9                	imul   %ecx
  80189c:	c1 fa 02             	sar    $0x2,%edx
  80189f:	89 c8                	mov    %ecx,%eax
  8018a1:	c1 f8 1f             	sar    $0x1f,%eax
  8018a4:	29 c2                	sub    %eax,%edx
  8018a6:	89 d0                	mov    %edx,%eax
  8018a8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018af:	75 bb                	jne    80186c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bb:	48                   	dec    %eax
  8018bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c3:	74 3d                	je     801902 <ltostr+0xc3>
		start = 1 ;
  8018c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018cc:	eb 34                	jmp    801902 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	01 c2                	add    %eax,%edx
  8018e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	01 c8                	add    %ecx,%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	01 c2                	add    %eax,%edx
  8018f7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018fa:	88 02                	mov    %al,(%edx)
		start++ ;
  8018fc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018ff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801905:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801908:	7c c4                	jl     8018ce <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80190a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80190d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	e8 c4 f9 ff ff       	call   8012ea <strlen>
  801926:	83 c4 04             	add    $0x4,%esp
  801929:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	e8 b6 f9 ff ff       	call   8012ea <strlen>
  801934:	83 c4 04             	add    $0x4,%esp
  801937:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80193a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801948:	eb 17                	jmp    801961 <strcconcat+0x49>
		final[s] = str1[s] ;
  80194a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194d:	8b 45 10             	mov    0x10(%ebp),%eax
  801950:	01 c2                	add    %eax,%edx
  801952:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	01 c8                	add    %ecx,%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80195e:	ff 45 fc             	incl   -0x4(%ebp)
  801961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801964:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801967:	7c e1                	jl     80194a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801969:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801970:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801977:	eb 1f                	jmp    801998 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197c:	8d 50 01             	lea    0x1(%eax),%edx
  80197f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801982:	89 c2                	mov    %eax,%edx
  801984:	8b 45 10             	mov    0x10(%ebp),%eax
  801987:	01 c2                	add    %eax,%edx
  801989:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80198c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198f:	01 c8                	add    %ecx,%eax
  801991:	8a 00                	mov    (%eax),%al
  801993:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801995:	ff 45 f8             	incl   -0x8(%ebp)
  801998:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80199b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199e:	7c d9                	jl     801979 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	01 d0                	add    %edx,%eax
  8019a8:	c6 00 00             	movb   $0x0,(%eax)
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d1:	eb 0c                	jmp    8019df <strsplit+0x31>
			*string++ = 0;
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8d 50 01             	lea    0x1(%eax),%edx
  8019d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8019dc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	84 c0                	test   %al,%al
  8019e6:	74 18                	je     801a00 <strsplit+0x52>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	0f be c0             	movsbl %al,%eax
  8019f0:	50                   	push   %eax
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	e8 83 fa ff ff       	call   80147c <strchr>
  8019f9:	83 c4 08             	add    $0x8,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	75 d3                	jne    8019d3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	8a 00                	mov    (%eax),%al
  801a05:	84 c0                	test   %al,%al
  801a07:	74 5a                	je     801a63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a09:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	83 f8 0f             	cmp    $0xf,%eax
  801a11:	75 07                	jne    801a1a <strsplit+0x6c>
		{
			return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 66                	jmp    801a80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801a22:	8b 55 14             	mov    0x14(%ebp),%edx
  801a25:	89 0a                	mov    %ecx,(%edx)
  801a27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a31:	01 c2                	add    %eax,%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a38:	eb 03                	jmp    801a3d <strsplit+0x8f>
			string++;
  801a3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	84 c0                	test   %al,%al
  801a44:	74 8b                	je     8019d1 <strsplit+0x23>
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	0f be c0             	movsbl %al,%eax
  801a4e:	50                   	push   %eax
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	e8 25 fa ff ff       	call   80147c <strchr>
  801a57:	83 c4 08             	add    $0x8,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	74 dc                	je     801a3a <strsplit+0x8c>
			string++;
	}
  801a5e:	e9 6e ff ff ff       	jmp    8019d1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a64:	8b 45 14             	mov    0x14(%ebp),%eax
  801a67:	8b 00                	mov    (%eax),%eax
  801a69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a70:	8b 45 10             	mov    0x10(%ebp),%eax
  801a73:	01 d0                	add    %edx,%eax
  801a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a95:	eb 4a                	jmp    801ae1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	01 c2                	add    %eax,%edx
  801a9f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	01 c8                	add    %ecx,%eax
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801aab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	8a 00                	mov    (%eax),%al
  801ab5:	3c 40                	cmp    $0x40,%al
  801ab7:	7e 25                	jle    801ade <str2lower+0x5c>
  801ab9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abf:	01 d0                	add    %edx,%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	3c 5a                	cmp    $0x5a,%al
  801ac5:	7f 17                	jg     801ade <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ac7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	01 d0                	add    %edx,%eax
  801acf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad5:	01 ca                	add    %ecx,%edx
  801ad7:	8a 12                	mov    (%edx),%dl
  801ad9:	83 c2 20             	add    $0x20,%edx
  801adc:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ade:	ff 45 fc             	incl   -0x4(%ebp)
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	e8 01 f8 ff ff       	call   8012ea <strlen>
  801ae9:	83 c4 04             	add    $0x4,%esp
  801aec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801aef:	7f a6                	jg     801a97 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801af1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801afc:	a1 08 40 80 00       	mov    0x804008,%eax
  801b01:	85 c0                	test   %eax,%eax
  801b03:	74 42                	je     801b47 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	68 00 00 00 82       	push   $0x82000000
  801b0d:	68 00 00 00 80       	push   $0x80000000
  801b12:	e8 00 08 00 00       	call   802317 <initialize_dynamic_allocator>
  801b17:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b1a:	e8 e7 05 00 00       	call   802106 <sys_get_uheap_strategy>
  801b1f:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b24:	a1 40 40 80 00       	mov    0x804040,%eax
  801b29:	05 00 10 00 00       	add    $0x1000,%eax
  801b2e:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b33:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b38:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b3d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b44:	00 00 00 
	}
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	68 06 04 00 00       	push   $0x406
  801b66:	50                   	push   %eax
  801b67:	e8 e4 01 00 00       	call   801d50 <__sys_allocate_page>
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b76:	79 14                	jns    801b8c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	68 a8 37 80 00       	push   $0x8037a8
  801b80:	6a 1f                	push   $0x1f
  801b82:	68 e4 37 80 00       	push   $0x8037e4
  801b87:	e8 b7 ed ff ff       	call   800943 <_panic>
	return 0;
  801b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	50                   	push   %eax
  801bab:	e8 e7 01 00 00       	call   801d97 <__sys_unmap_frame>
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bba:	79 14                	jns    801bd0 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	68 f0 37 80 00       	push   $0x8037f0
  801bc4:	6a 2a                	push   $0x2a
  801bc6:	68 e4 37 80 00       	push   $0x8037e4
  801bcb:	e8 73 ed ff ff       	call   800943 <_panic>
}
  801bd0:	90                   	nop
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bd9:	e8 18 ff ff ff       	call   801af6 <uheap_init>
	if (size == 0) return NULL ;
  801bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be2:	75 07                	jne    801beb <malloc+0x18>
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
  801be9:	eb 14                	jmp    801bff <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 30 38 80 00       	push   $0x803830
  801bf3:	6a 3e                	push   $0x3e
  801bf5:	68 e4 37 80 00       	push   $0x8037e4
  801bfa:	e8 44 ed ff ff       	call   800943 <_panic>
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	68 58 38 80 00       	push   $0x803858
  801c0f:	6a 49                	push   $0x49
  801c11:	68 e4 37 80 00       	push   $0x8037e4
  801c16:	e8 28 ed ff ff       	call   800943 <_panic>

00801c1b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 18             	sub    $0x18,%esp
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c27:	e8 ca fe ff ff       	call   801af6 <uheap_init>
	if (size == 0) return NULL ;
  801c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c30:	75 07                	jne    801c39 <smalloc+0x1e>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 14                	jmp    801c4d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	68 7c 38 80 00       	push   $0x80387c
  801c41:	6a 5a                	push   $0x5a
  801c43:	68 e4 37 80 00       	push   $0x8037e4
  801c48:	e8 f6 ec ff ff       	call   800943 <_panic>
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c55:	e8 9c fe ff ff       	call   801af6 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	68 a4 38 80 00       	push   $0x8038a4
  801c62:	6a 6a                	push   $0x6a
  801c64:	68 e4 37 80 00       	push   $0x8037e4
  801c69:	e8 d5 ec ff ff       	call   800943 <_panic>

00801c6e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c74:	e8 7d fe ff ff       	call   801af6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	68 c8 38 80 00       	push   $0x8038c8
  801c81:	68 88 00 00 00       	push   $0x88
  801c86:	68 e4 37 80 00       	push   $0x8037e4
  801c8b:	e8 b3 ec ff ff       	call   800943 <_panic>

00801c90 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 f0 38 80 00       	push   $0x8038f0
  801c9e:	68 9b 00 00 00       	push   $0x9b
  801ca3:	68 e4 37 80 00       	push   $0x8037e4
  801ca8:	e8 96 ec ff ff       	call   800943 <_panic>

00801cad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	57                   	push   %edi
  801cb1:	56                   	push   %esi
  801cb2:	53                   	push   %ebx
  801cb3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cc5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cc8:	cd 30                	int    $0x30
  801cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ce4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	51                   	push   %ecx
  801cf1:	52                   	push   %edx
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	50                   	push   %eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	e8 b0 ff ff ff       	call   801cad <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	90                   	nop
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 02                	push   $0x2
  801d12:	e8 96 ff ff ff       	call   801cad <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 03                	push   $0x3
  801d2b:	e8 7d ff ff ff       	call   801cad <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 04                	push   $0x4
  801d45:	e8 63 ff ff ff       	call   801cad <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 08                	push   $0x8
  801d63:	e8 45 ff ff ff       	call   801cad <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	56                   	push   %esi
  801d71:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d72:	8b 75 18             	mov    0x18(%ebp),%esi
  801d75:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	56                   	push   %esi
  801d82:	53                   	push   %ebx
  801d83:	51                   	push   %ecx
  801d84:	52                   	push   %edx
  801d85:	50                   	push   %eax
  801d86:	6a 09                	push   $0x9
  801d88:	e8 20 ff ff ff       	call   801cad <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	6a 0a                	push   $0xa
  801da7:	e8 01 ff ff ff       	call   801cad <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	6a 0b                	push   $0xb
  801dc2:	e8 e6 fe ff ff       	call   801cad <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 0c                	push   $0xc
  801ddb:	e8 cd fe ff ff       	call   801cad <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 0d                	push   $0xd
  801df4:	e8 b4 fe ff ff       	call   801cad <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 0e                	push   $0xe
  801e0d:	e8 9b fe ff ff       	call   801cad <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 0f                	push   $0xf
  801e26:	e8 82 fe ff ff       	call   801cad <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 10                	push   $0x10
  801e40:	e8 68 fe ff ff       	call   801cad <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 11                	push   $0x11
  801e59:	e8 4f fe ff ff       	call   801cad <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	90                   	nop
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e70:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	50                   	push   %eax
  801e7d:	6a 01                	push   $0x1
  801e7f:	e8 29 fe ff ff       	call   801cad <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 14                	push   $0x14
  801e99:	e8 0f fe ff ff       	call   801cad <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	90                   	nop
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eb0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	51                   	push   %ecx
  801ebd:	52                   	push   %edx
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	6a 15                	push   $0x15
  801ec4:	e8 e4 fd ff ff       	call   801cad <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	52                   	push   %edx
  801ede:	50                   	push   %eax
  801edf:	6a 16                	push   $0x16
  801ee1:	e8 c7 fd ff ff       	call   801cad <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	51                   	push   %ecx
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	6a 17                	push   $0x17
  801f00:	e8 a8 fd ff ff       	call   801cad <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 18                	push   $0x18
  801f1d:	e8 8b fd ff ff       	call   801cad <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	ff 75 14             	pushl  0x14(%ebp)
  801f32:	ff 75 10             	pushl  0x10(%ebp)
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	50                   	push   %eax
  801f39:	6a 19                	push   $0x19
  801f3b:	e8 6d fd ff ff       	call   801cad <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	50                   	push   %eax
  801f54:	6a 1a                	push   $0x1a
  801f56:	e8 52 fd ff ff       	call   801cad <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	50                   	push   %eax
  801f70:	6a 1b                	push   $0x1b
  801f72:	e8 36 fd ff ff       	call   801cad <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 05                	push   $0x5
  801f8b:	e8 1d fd ff ff       	call   801cad <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 06                	push   $0x6
  801fa4:	e8 04 fd ff ff       	call   801cad <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 07                	push   $0x7
  801fbd:	e8 eb fc ff ff       	call   801cad <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_exit_env>:


void sys_exit_env(void)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 1c                	push   $0x1c
  801fd6:	e8 d2 fc ff ff       	call   801cad <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fe7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fea:	8d 50 04             	lea    0x4(%eax),%edx
  801fed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	52                   	push   %edx
  801ff7:	50                   	push   %eax
  801ff8:	6a 1d                	push   $0x1d
  801ffa:	e8 ae fc ff ff       	call   801cad <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
	return result;
  802002:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802008:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80200b:	89 01                	mov    %eax,(%ecx)
  80200d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	c9                   	leave  
  802014:	c2 04 00             	ret    $0x4

00802017 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 10             	pushl  0x10(%ebp)
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	6a 13                	push   $0x13
  802029:	e8 7f fc ff ff       	call   801cad <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
	return ;
  802031:	90                   	nop
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_rcr2>:
uint32 sys_rcr2()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 1e                	push   $0x1e
  802043:	e8 65 fc ff ff       	call   801cad <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802059:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	50                   	push   %eax
  802066:	6a 1f                	push   $0x1f
  802068:	e8 40 fc ff ff       	call   801cad <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
	return ;
  802070:	90                   	nop
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <rsttst>:
void rsttst()
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 21                	push   $0x21
  802082:	e8 26 fc ff ff       	call   801cad <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
	return ;
  80208a:	90                   	nop
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	8b 45 14             	mov    0x14(%ebp),%eax
  802096:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802099:	8b 55 18             	mov    0x18(%ebp),%edx
  80209c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a0:	52                   	push   %edx
  8020a1:	50                   	push   %eax
  8020a2:	ff 75 10             	pushl  0x10(%ebp)
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	6a 20                	push   $0x20
  8020ad:	e8 fb fb ff ff       	call   801cad <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b5:	90                   	nop
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <chktst>:
void chktst(uint32 n)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	ff 75 08             	pushl  0x8(%ebp)
  8020c6:	6a 22                	push   $0x22
  8020c8:	e8 e0 fb ff ff       	call   801cad <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d0:	90                   	nop
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <inctst>:

void inctst()
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 23                	push   $0x23
  8020e2:	e8 c6 fb ff ff       	call   801cad <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ea:	90                   	nop
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <gettst>:
uint32 gettst()
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 24                	push   $0x24
  8020fc:	e8 ac fb ff ff       	call   801cad <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 25                	push   $0x25
  802115:	e8 93 fb ff ff       	call   801cad <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
  80211d:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802122:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	6a 26                	push   $0x26
  802141:	e8 67 fb ff ff       	call   801cad <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
	return ;
  802149:	90                   	nop
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802150:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802153:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802156:	8b 55 0c             	mov    0xc(%ebp),%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	6a 00                	push   $0x0
  80215e:	53                   	push   %ebx
  80215f:	51                   	push   %ecx
  802160:	52                   	push   %edx
  802161:	50                   	push   %eax
  802162:	6a 27                	push   $0x27
  802164:	e8 44 fb ff ff       	call   801cad <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802174:	8b 55 0c             	mov    0xc(%ebp),%edx
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	52                   	push   %edx
  802181:	50                   	push   %eax
  802182:	6a 28                	push   $0x28
  802184:	e8 24 fb ff ff       	call   801cad <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802191:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802194:	8b 55 0c             	mov    0xc(%ebp),%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	6a 00                	push   $0x0
  80219c:	51                   	push   %ecx
  80219d:	ff 75 10             	pushl  0x10(%ebp)
  8021a0:	52                   	push   %edx
  8021a1:	50                   	push   %eax
  8021a2:	6a 29                	push   $0x29
  8021a4:	e8 04 fb ff ff       	call   801cad <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	ff 75 10             	pushl  0x10(%ebp)
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	ff 75 08             	pushl  0x8(%ebp)
  8021be:	6a 12                	push   $0x12
  8021c0:	e8 e8 fa ff ff       	call   801cad <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c8:	90                   	nop
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	52                   	push   %edx
  8021db:	50                   	push   %eax
  8021dc:	6a 2a                	push   $0x2a
  8021de:	e8 ca fa ff ff       	call   801cad <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
	return;
  8021e6:	90                   	nop
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 2b                	push   $0x2b
  8021f8:	e8 b0 fa ff ff       	call   801cad <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	6a 2d                	push   $0x2d
  802213:	e8 95 fa ff ff       	call   801cad <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
	return;
  80221b:	90                   	nop
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	ff 75 0c             	pushl  0xc(%ebp)
  80222a:	ff 75 08             	pushl  0x8(%ebp)
  80222d:	6a 2c                	push   $0x2c
  80222f:	e8 79 fa ff ff       	call   801cad <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
	return ;
  802237:	90                   	nop
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 14 39 80 00       	push   $0x803914
  802248:	68 25 01 00 00       	push   $0x125
  80224d:	68 47 39 80 00       	push   $0x803947
  802252:	e8 ec e6 ff ff       	call   800943 <_panic>

00802257 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80225d:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802264:	72 09                	jb     80226f <to_page_va+0x18>
  802266:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  80226d:	72 14                	jb     802283 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 58 39 80 00       	push   $0x803958
  802277:	6a 15                	push   $0x15
  802279:	68 83 39 80 00       	push   $0x803983
  80227e:	e8 c0 e6 ff ff       	call   800943 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	ba 60 40 80 00       	mov    $0x804060,%edx
  80228b:	29 d0                	sub    %edx,%eax
  80228d:	c1 f8 02             	sar    $0x2,%eax
  802290:	89 c2                	mov    %eax,%edx
  802292:	89 d0                	mov    %edx,%eax
  802294:	c1 e0 02             	shl    $0x2,%eax
  802297:	01 d0                	add    %edx,%eax
  802299:	c1 e0 02             	shl    $0x2,%eax
  80229c:	01 d0                	add    %edx,%eax
  80229e:	c1 e0 02             	shl    $0x2,%eax
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	89 c1                	mov    %eax,%ecx
  8022a5:	c1 e1 08             	shl    $0x8,%ecx
  8022a8:	01 c8                	add    %ecx,%eax
  8022aa:	89 c1                	mov    %eax,%ecx
  8022ac:	c1 e1 10             	shl    $0x10,%ecx
  8022af:	01 c8                	add    %ecx,%eax
  8022b1:	01 c0                	add    %eax,%eax
  8022b3:	01 d0                	add    %edx,%eax
  8022b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	c1 e0 0c             	shl    $0xc,%eax
  8022be:	89 c2                	mov    %eax,%edx
  8022c0:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022c5:	01 d0                	add    %edx,%eax
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8022cf:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d7:	29 c2                	sub    %eax,%edx
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	c1 e8 0c             	shr    $0xc,%eax
  8022de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	78 09                	js     8022f0 <to_page_info+0x27>
  8022e7:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8022ee:	7e 14                	jle    802304 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 9c 39 80 00       	push   $0x80399c
  8022f8:	6a 22                	push   $0x22
  8022fa:	68 83 39 80 00       	push   $0x803983
  8022ff:	e8 3f e6 ff ff       	call   800943 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	89 d0                	mov    %edx,%eax
  802309:	01 c0                	add    %eax,%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	c1 e0 02             	shl    $0x2,%eax
  802310:	05 60 40 80 00       	add    $0x804060,%eax
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	05 00 00 00 02       	add    $0x2000000,%eax
  802325:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802328:	73 16                	jae    802340 <initialize_dynamic_allocator+0x29>
  80232a:	68 c0 39 80 00       	push   $0x8039c0
  80232f:	68 e6 39 80 00       	push   $0x8039e6
  802334:	6a 34                	push   $0x34
  802336:	68 83 39 80 00       	push   $0x803983
  80233b:	e8 03 e6 ff ff       	call   800943 <_panic>
		is_initialized = 1;
  802340:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802347:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802352:	8b 45 0c             	mov    0xc(%ebp),%eax
  802355:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80235a:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802361:	00 00 00 
  802364:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80236b:	00 00 00 
  80236e:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802375:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	2b 45 08             	sub    0x8(%ebp),%eax
  80237e:	c1 e8 0c             	shr    $0xc,%eax
  802381:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80238b:	e9 c8 00 00 00       	jmp    802458 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802393:	89 d0                	mov    %edx,%eax
  802395:	01 c0                	add    %eax,%eax
  802397:	01 d0                	add    %edx,%eax
  802399:	c1 e0 02             	shl    $0x2,%eax
  80239c:	05 68 40 80 00       	add    $0x804068,%eax
  8023a1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8023a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a9:	89 d0                	mov    %edx,%eax
  8023ab:	01 c0                	add    %eax,%eax
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	c1 e0 02             	shl    $0x2,%eax
  8023b2:	05 6a 40 80 00       	add    $0x80406a,%eax
  8023b7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8023bc:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023c5:	89 c8                	mov    %ecx,%eax
  8023c7:	01 c0                	add    %eax,%eax
  8023c9:	01 c8                	add    %ecx,%eax
  8023cb:	c1 e0 02             	shl    $0x2,%eax
  8023ce:	05 64 40 80 00       	add    $0x804064,%eax
  8023d3:	89 10                	mov    %edx,(%eax)
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 d0                	mov    %edx,%eax
  8023da:	01 c0                	add    %eax,%eax
  8023dc:	01 d0                	add    %edx,%eax
  8023de:	c1 e0 02             	shl    $0x2,%eax
  8023e1:	05 64 40 80 00       	add    $0x804064,%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 1b                	je     802407 <initialize_dynamic_allocator+0xf0>
  8023ec:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023f5:	89 c8                	mov    %ecx,%eax
  8023f7:	01 c0                	add    %eax,%eax
  8023f9:	01 c8                	add    %ecx,%eax
  8023fb:	c1 e0 02             	shl    $0x2,%eax
  8023fe:	05 60 40 80 00       	add    $0x804060,%eax
  802403:	89 02                	mov    %eax,(%edx)
  802405:	eb 16                	jmp    80241d <initialize_dynamic_allocator+0x106>
  802407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240a:	89 d0                	mov    %edx,%eax
  80240c:	01 c0                	add    %eax,%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	c1 e0 02             	shl    $0x2,%eax
  802413:	05 60 40 80 00       	add    $0x804060,%eax
  802418:	a3 48 40 80 00       	mov    %eax,0x804048
  80241d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802420:	89 d0                	mov    %edx,%eax
  802422:	01 c0                	add    %eax,%eax
  802424:	01 d0                	add    %edx,%eax
  802426:	c1 e0 02             	shl    $0x2,%eax
  802429:	05 60 40 80 00       	add    $0x804060,%eax
  80242e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802436:	89 d0                	mov    %edx,%eax
  802438:	01 c0                	add    %eax,%eax
  80243a:	01 d0                	add    %edx,%eax
  80243c:	c1 e0 02             	shl    $0x2,%eax
  80243f:	05 60 40 80 00       	add    $0x804060,%eax
  802444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244a:	a1 54 40 80 00       	mov    0x804054,%eax
  80244f:	40                   	inc    %eax
  802450:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802455:	ff 45 f4             	incl   -0xc(%ebp)
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80245e:	0f 8c 2c ff ff ff    	jl     802390 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802464:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80246b:	eb 36                	jmp    8024a3 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	c1 e0 04             	shl    $0x4,%eax
  802473:	05 80 c0 81 00       	add    $0x81c080,%eax
  802478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802481:	c1 e0 04             	shl    $0x4,%eax
  802484:	05 84 c0 81 00       	add    $0x81c084,%eax
  802489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	c1 e0 04             	shl    $0x4,%eax
  802495:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80249a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024a0:	ff 45 f0             	incl   -0x10(%ebp)
  8024a3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8024a7:	7e c4                	jle    80246d <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8024a9:	90                   	nop
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	83 ec 0c             	sub    $0xc,%esp
  8024b8:	50                   	push   %eax
  8024b9:	e8 0b fe ff ff       	call   8022c9 <to_page_info>
  8024be:	83 c4 10             	add    $0x10,%esp
  8024c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ca:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8024d5:	83 ec 0c             	sub    $0xc,%esp
  8024d8:	ff 75 0c             	pushl  0xc(%ebp)
  8024db:	e8 77 fd ff ff       	call   802257 <to_page_va>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8024e6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f0:	f7 75 08             	divl   0x8(%ebp)
  8024f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8024f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	50                   	push   %eax
  8024fd:	e8 48 f6 ff ff       	call   801b4a <get_page>
  802502:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802520:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802527:	eb 19                	jmp    802542 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252c:	ba 01 00 00 00       	mov    $0x1,%edx
  802531:	88 c1                	mov    %al,%cl
  802533:	d3 e2                	shl    %cl,%edx
  802535:	89 d0                	mov    %edx,%eax
  802537:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253a:	74 0e                	je     80254a <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80253c:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80253f:	ff 45 f0             	incl   -0x10(%ebp)
  802542:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802546:	7e e1                	jle    802529 <split_page_to_blocks+0x5a>
  802548:	eb 01                	jmp    80254b <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80254a:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80254b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802552:	e9 a7 00 00 00       	jmp    8025fe <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	0f af 45 08          	imul   0x8(%ebp),%eax
  80255e:	89 c2                	mov    %eax,%edx
  802560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802563:	01 d0                	add    %edx,%eax
  802565:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802568:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80256c:	75 14                	jne    802582 <split_page_to_blocks+0xb3>
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	68 fc 39 80 00       	push   $0x8039fc
  802576:	6a 7c                	push   $0x7c
  802578:	68 83 39 80 00       	push   $0x803983
  80257d:	e8 c1 e3 ff ff       	call   800943 <_panic>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	c1 e0 04             	shl    $0x4,%eax
  802588:	05 84 c0 81 00       	add    $0x81c084,%eax
  80258d:	8b 10                	mov    (%eax),%edx
  80258f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802592:	89 50 04             	mov    %edx,0x4(%eax)
  802595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 14                	je     8025b3 <split_page_to_blocks+0xe4>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c1 e0 04             	shl    $0x4,%eax
  8025a5:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	eb 11                	jmp    8025c4 <split_page_to_blocks+0xf5>
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	c1 e0 04             	shl    $0x4,%eax
  8025b9:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8025bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c2:	89 02                	mov    %eax,(%edx)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	c1 e0 04             	shl    $0x4,%eax
  8025ca:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8025d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d3:	89 02                	mov    %eax,(%edx)
  8025d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c1 e0 04             	shl    $0x4,%eax
  8025e4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	8d 50 01             	lea    0x1(%eax),%edx
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c1 e0 04             	shl    $0x4,%eax
  8025f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025f9:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8025fb:	ff 45 ec             	incl   -0x14(%ebp)
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802604:	0f 82 4d ff ff ff    	jb     802557 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80260a:	90                   	nop
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802613:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80261a:	76 19                	jbe    802635 <alloc_block+0x28>
  80261c:	68 20 3a 80 00       	push   $0x803a20
  802621:	68 e6 39 80 00       	push   $0x8039e6
  802626:	68 8a 00 00 00       	push   $0x8a
  80262b:	68 83 39 80 00       	push   $0x803983
  802630:	e8 0e e3 ff ff       	call   800943 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80263c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802643:	eb 19                	jmp    80265e <alloc_block+0x51>
		if((1 << i) >= size) break;
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	ba 01 00 00 00       	mov    $0x1,%edx
  80264d:	88 c1                	mov    %al,%cl
  80264f:	d3 e2                	shl    %cl,%edx
  802651:	89 d0                	mov    %edx,%eax
  802653:	3b 45 08             	cmp    0x8(%ebp),%eax
  802656:	73 0e                	jae    802666 <alloc_block+0x59>
		idx++;
  802658:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80265b:	ff 45 f0             	incl   -0x10(%ebp)
  80265e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802662:	7e e1                	jle    802645 <alloc_block+0x38>
  802664:	eb 01                	jmp    802667 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802666:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	c1 e0 04             	shl    $0x4,%eax
  80266d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	0f 84 df 00 00 00    	je     80275b <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	c1 e0 04             	shl    $0x4,%eax
  802682:	05 80 c0 81 00       	add    $0x81c080,%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80268c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802690:	75 17                	jne    8026a9 <alloc_block+0x9c>
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	68 41 3a 80 00       	push   $0x803a41
  80269a:	68 9e 00 00 00       	push   $0x9e
  80269f:	68 83 39 80 00       	push   $0x803983
  8026a4:	e8 9a e2 ff ff       	call   800943 <_panic>
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 10                	je     8026c2 <alloc_block+0xb5>
  8026b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ba:	8b 52 04             	mov    0x4(%edx),%edx
  8026bd:	89 50 04             	mov    %edx,0x4(%eax)
  8026c0:	eb 14                	jmp    8026d6 <alloc_block+0xc9>
  8026c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c5:	8b 40 04             	mov    0x4(%eax),%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	c1 e2 04             	shl    $0x4,%edx
  8026ce:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026d4:	89 02                	mov    %eax,(%edx)
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	8b 40 04             	mov    0x4(%eax),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 0f                	je     8026ef <alloc_block+0xe2>
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e9:	8b 12                	mov    (%edx),%edx
  8026eb:	89 10                	mov    %edx,(%eax)
  8026ed:	eb 13                	jmp    802702 <alloc_block+0xf5>
  8026ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	c1 e2 04             	shl    $0x4,%edx
  8026fa:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802700:	89 02                	mov    %eax,(%edx)
  802702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	c1 e0 04             	shl    $0x4,%eax
  80271b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	8d 50 ff             	lea    -0x1(%eax),%edx
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	c1 e0 04             	shl    $0x4,%eax
  80272b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802730:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	83 ec 0c             	sub    $0xc,%esp
  802738:	50                   	push   %eax
  802739:	e8 8b fb ff ff       	call   8022c9 <to_page_info>
  80273e:	83 c4 10             	add    $0x10,%esp
  802741:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802747:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80274b:	48                   	dec    %eax
  80274c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802753:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802756:	e9 bc 02 00 00       	jmp    802a17 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80275b:	a1 54 40 80 00       	mov    0x804054,%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	0f 84 7d 02 00 00    	je     8029e5 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802768:	a1 48 40 80 00       	mov    0x804048,%eax
  80276d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802774:	75 17                	jne    80278d <alloc_block+0x180>
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 41 3a 80 00       	push   $0x803a41
  80277e:	68 a9 00 00 00       	push   $0xa9
  802783:	68 83 39 80 00       	push   $0x803983
  802788:	e8 b6 e1 ff ff       	call   800943 <_panic>
  80278d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	74 10                	je     8027a6 <alloc_block+0x199>
  802796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279e:	8b 52 04             	mov    0x4(%edx),%edx
  8027a1:	89 50 04             	mov    %edx,0x4(%eax)
  8027a4:	eb 0b                	jmp    8027b1 <alloc_block+0x1a4>
  8027a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 0f                	je     8027ca <alloc_block+0x1bd>
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c4:	8b 12                	mov    (%edx),%edx
  8027c6:	89 10                	mov    %edx,(%eax)
  8027c8:	eb 0a                	jmp    8027d4 <alloc_block+0x1c7>
  8027ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	a3 48 40 80 00       	mov    %eax,0x804048
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e7:	a1 54 40 80 00       	mov    0x804054,%eax
  8027ec:	48                   	dec    %eax
  8027ed:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	83 c0 03             	add    $0x3,%eax
  8027f8:	ba 01 00 00 00       	mov    $0x1,%edx
  8027fd:	88 c1                	mov    %al,%cl
  8027ff:	d3 e2                	shl    %cl,%edx
  802801:	89 d0                	mov    %edx,%eax
  802803:	83 ec 08             	sub    $0x8,%esp
  802806:	ff 75 e4             	pushl  -0x1c(%ebp)
  802809:	50                   	push   %eax
  80280a:	e8 c0 fc ff ff       	call   8024cf <split_page_to_blocks>
  80280f:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	c1 e0 04             	shl    $0x4,%eax
  802818:	05 80 c0 81 00       	add    $0x81c080,%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802822:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802826:	75 17                	jne    80283f <alloc_block+0x232>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 41 3a 80 00       	push   $0x803a41
  802830:	68 b0 00 00 00       	push   $0xb0
  802835:	68 83 39 80 00       	push   $0x803983
  80283a:	e8 04 e1 ff ff       	call   800943 <_panic>
  80283f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 10                	je     802858 <alloc_block+0x24b>
  802848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802850:	8b 52 04             	mov    0x4(%edx),%edx
  802853:	89 50 04             	mov    %edx,0x4(%eax)
  802856:	eb 14                	jmp    80286c <alloc_block+0x25f>
  802858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	c1 e2 04             	shl    $0x4,%edx
  802864:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80286a:	89 02                	mov    %eax,(%edx)
  80286c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 0f                	je     802885 <alloc_block+0x278>
  802876:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80287f:	8b 12                	mov    (%edx),%edx
  802881:	89 10                	mov    %edx,(%eax)
  802883:	eb 13                	jmp    802898 <alloc_block+0x28b>
  802885:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288d:	c1 e2 04             	shl    $0x4,%edx
  802890:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802896:	89 02                	mov    %eax,(%edx)
  802898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c1 e0 04             	shl    $0x4,%eax
  8028b1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	c1 e0 04             	shl    $0x4,%eax
  8028c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028c6:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8028c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	50                   	push   %eax
  8028cf:	e8 f5 f9 ff ff       	call   8022c9 <to_page_info>
  8028d4:	83 c4 10             	add    $0x10,%esp
  8028d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8028da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028dd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8028e1:	48                   	dec    %eax
  8028e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028e5:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8028e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ec:	e9 26 01 00 00       	jmp    802a17 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8028f1:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	c1 e0 04             	shl    $0x4,%eax
  8028fa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	0f 84 dc 00 00 00    	je     8029e5 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	c1 e0 04             	shl    $0x4,%eax
  80290f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802919:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80291d:	75 17                	jne    802936 <alloc_block+0x329>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 41 3a 80 00       	push   $0x803a41
  802927:	68 be 00 00 00       	push   $0xbe
  80292c:	68 83 39 80 00       	push   $0x803983
  802931:	e8 0d e0 ff ff       	call   800943 <_panic>
  802936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 10                	je     80294f <alloc_block+0x342>
  80293f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802947:	8b 52 04             	mov    0x4(%edx),%edx
  80294a:	89 50 04             	mov    %edx,0x4(%eax)
  80294d:	eb 14                	jmp    802963 <alloc_block+0x356>
  80294f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802958:	c1 e2 04             	shl    $0x4,%edx
  80295b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802961:	89 02                	mov    %eax,(%edx)
  802963:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802966:	8b 40 04             	mov    0x4(%eax),%eax
  802969:	85 c0                	test   %eax,%eax
  80296b:	74 0f                	je     80297c <alloc_block+0x36f>
  80296d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802970:	8b 40 04             	mov    0x4(%eax),%eax
  802973:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802976:	8b 12                	mov    (%edx),%edx
  802978:	89 10                	mov    %edx,(%eax)
  80297a:	eb 13                	jmp    80298f <alloc_block+0x382>
  80297c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802984:	c1 e2 04             	shl    $0x4,%edx
  802987:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80298d:	89 02                	mov    %eax,(%edx)
  80298f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802998:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80299b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	c1 e0 04             	shl    $0x4,%eax
  8029a8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	c1 e0 04             	shl    $0x4,%eax
  8029b8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029bd:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	50                   	push   %eax
  8029c6:	e8 fe f8 ff ff       	call   8022c9 <to_page_info>
  8029cb:	83 c4 10             	add    $0x10,%esp
  8029ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8029d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029d4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029d8:	48                   	dec    %eax
  8029d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029dc:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8029e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e3:	eb 32                	jmp    802a17 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8029e5:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8029e9:	77 15                	ja     802a00 <alloc_block+0x3f3>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	c1 e0 04             	shl    $0x4,%eax
  8029f1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	0f 84 f1 fe ff ff    	je     8028f1 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 5f 3a 80 00       	push   $0x803a5f
  802a08:	68 c8 00 00 00       	push   $0xc8
  802a0d:	68 83 39 80 00       	push   $0x803983
  802a12:	e8 2c df ff ff       	call   800943 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a22:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802a27:	39 c2                	cmp    %eax,%edx
  802a29:	72 0c                	jb     802a37 <free_block+0x1e>
  802a2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2e:	a1 40 40 80 00       	mov    0x804040,%eax
  802a33:	39 c2                	cmp    %eax,%edx
  802a35:	72 19                	jb     802a50 <free_block+0x37>
  802a37:	68 70 3a 80 00       	push   $0x803a70
  802a3c:	68 e6 39 80 00       	push   $0x8039e6
  802a41:	68 d7 00 00 00       	push   $0xd7
  802a46:	68 83 39 80 00       	push   $0x803983
  802a4b:	e8 f3 de ff ff       	call   800943 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	83 ec 0c             	sub    $0xc,%esp
  802a5c:	50                   	push   %eax
  802a5d:	e8 67 f8 ff ff       	call   8022c9 <to_page_info>
  802a62:	83 c4 10             	add    $0x10,%esp
  802a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6b:	8b 40 08             	mov    0x8(%eax),%eax
  802a6e:	0f b7 c0             	movzwl %ax,%eax
  802a71:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a7b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802a82:	eb 19                	jmp    802a9d <free_block+0x84>
	    if ((1 << i) == blk_size)
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	ba 01 00 00 00       	mov    $0x1,%edx
  802a8c:	88 c1                	mov    %al,%cl
  802a8e:	d3 e2                	shl    %cl,%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802a95:	74 0e                	je     802aa5 <free_block+0x8c>
	        break;
	    idx++;
  802a97:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a9a:	ff 45 f0             	incl   -0x10(%ebp)
  802a9d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802aa1:	7e e1                	jle    802a84 <free_block+0x6b>
  802aa3:	eb 01                	jmp    802aa6 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802aa5:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802aad:	40                   	inc    %eax
  802aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ab1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802ab5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab9:	75 17                	jne    802ad2 <free_block+0xb9>
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 fc 39 80 00       	push   $0x8039fc
  802ac3:	68 ee 00 00 00       	push   $0xee
  802ac8:	68 83 39 80 00       	push   $0x803983
  802acd:	e8 71 de ff ff       	call   800943 <_panic>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	c1 e0 04             	shl    $0x4,%eax
  802ad8:	05 84 c0 81 00       	add    $0x81c084,%eax
  802add:	8b 10                	mov    (%eax),%edx
  802adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae2:	89 50 04             	mov    %edx,0x4(%eax)
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 14                	je     802b03 <free_block+0xea>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c1 e0 04             	shl    $0x4,%eax
  802af5:	05 84 c0 81 00       	add    $0x81c084,%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aff:	89 10                	mov    %edx,(%eax)
  802b01:	eb 11                	jmp    802b14 <free_block+0xfb>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	c1 e0 04             	shl    $0x4,%eax
  802b09:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b12:	89 02                	mov    %eax,(%edx)
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	c1 e0 04             	shl    $0x4,%eax
  802b1a:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b23:	89 02                	mov    %eax,(%edx)
  802b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	c1 e0 04             	shl    $0x4,%eax
  802b34:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	8d 50 01             	lea    0x1(%eax),%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	c1 e0 04             	shl    $0x4,%eax
  802b44:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b49:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802b4b:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b50:	ba 00 00 00 00       	mov    $0x0,%edx
  802b55:	f7 75 e0             	divl   -0x20(%ebp)
  802b58:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b62:	0f b7 c0             	movzwl %ax,%eax
  802b65:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b68:	0f 85 70 01 00 00    	jne    802cde <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802b6e:	83 ec 0c             	sub    $0xc,%esp
  802b71:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b74:	e8 de f6 ff ff       	call   802257 <to_page_va>
  802b79:	83 c4 10             	add    $0x10,%esp
  802b7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802b7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b86:	e9 b7 00 00 00       	jmp    802c42 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802b8b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b91:	01 d0                	add    %edx,%eax
  802b93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802b96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b9a:	75 17                	jne    802bb3 <free_block+0x19a>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 41 3a 80 00       	push   $0x803a41
  802ba4:	68 f8 00 00 00       	push   $0xf8
  802ba9:	68 83 39 80 00       	push   $0x803983
  802bae:	e8 90 dd ff ff       	call   800943 <_panic>
  802bb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 10                	je     802bcc <free_block+0x1b3>
  802bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bc4:	8b 52 04             	mov    0x4(%edx),%edx
  802bc7:	89 50 04             	mov    %edx,0x4(%eax)
  802bca:	eb 14                	jmp    802be0 <free_block+0x1c7>
  802bcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd5:	c1 e2 04             	shl    $0x4,%edx
  802bd8:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802bde:	89 02                	mov    %eax,(%edx)
  802be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0f                	je     802bf9 <free_block+0x1e0>
  802bea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bf3:	8b 12                	mov    (%edx),%edx
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	eb 13                	jmp    802c0c <free_block+0x1f3>
  802bf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c01:	c1 e2 04             	shl    $0x4,%edx
  802c04:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c0a:	89 02                	mov    %eax,(%edx)
  802c0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	c1 e0 04             	shl    $0x4,%eax
  802c25:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c2a:	8b 00                	mov    (%eax),%eax
  802c2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	c1 e0 04             	shl    $0x4,%eax
  802c35:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c3a:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3f:	01 45 ec             	add    %eax,-0x14(%ebp)
  802c42:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c49:	0f 86 3c ff ff ff    	jbe    802b8b <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802c61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c65:	75 17                	jne    802c7e <free_block+0x265>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 fc 39 80 00       	push   $0x8039fc
  802c6f:	68 fe 00 00 00       	push   $0xfe
  802c74:	68 83 39 80 00       	push   $0x803983
  802c79:	e8 c5 dc ff ff       	call   800943 <_panic>
  802c7e:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c87:	89 50 04             	mov    %edx,0x4(%eax)
  802c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 0c                	je     802ca0 <free_block+0x287>
  802c94:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802c99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c9c:	89 10                	mov    %edx,(%eax)
  802c9e:	eb 08                	jmp    802ca8 <free_block+0x28f>
  802ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca3:	a3 48 40 80 00       	mov    %eax,0x804048
  802ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cab:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb9:	a1 54 40 80 00       	mov    0x804054,%eax
  802cbe:	40                   	inc    %eax
  802cbf:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802cc4:	83 ec 0c             	sub    $0xc,%esp
  802cc7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cca:	e8 88 f5 ff ff       	call   802257 <to_page_va>
  802ccf:	83 c4 10             	add    $0x10,%esp
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	50                   	push   %eax
  802cd6:	e8 b8 ee ff ff       	call   801b93 <return_page>
  802cdb:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802cde:	90                   	nop
  802cdf:	c9                   	leave  
  802ce0:	c3                   	ret    

00802ce1 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802ce1:	55                   	push   %ebp
  802ce2:	89 e5                	mov    %esp,%ebp
  802ce4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 a8 3a 80 00       	push   $0x803aa8
  802cef:	68 11 01 00 00       	push   $0x111
  802cf4:	68 83 39 80 00       	push   $0x803983
  802cf9:	e8 45 dc ff ff       	call   800943 <_panic>
  802cfe:	66 90                	xchg   %ax,%ax

00802d00 <__udivdi3>:
  802d00:	55                   	push   %ebp
  802d01:	57                   	push   %edi
  802d02:	56                   	push   %esi
  802d03:	53                   	push   %ebx
  802d04:	83 ec 1c             	sub    $0x1c,%esp
  802d07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d17:	89 ca                	mov    %ecx,%edx
  802d19:	89 f8                	mov    %edi,%eax
  802d1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d1f:	85 f6                	test   %esi,%esi
  802d21:	75 2d                	jne    802d50 <__udivdi3+0x50>
  802d23:	39 cf                	cmp    %ecx,%edi
  802d25:	77 65                	ja     802d8c <__udivdi3+0x8c>
  802d27:	89 fd                	mov    %edi,%ebp
  802d29:	85 ff                	test   %edi,%edi
  802d2b:	75 0b                	jne    802d38 <__udivdi3+0x38>
  802d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d32:	31 d2                	xor    %edx,%edx
  802d34:	f7 f7                	div    %edi
  802d36:	89 c5                	mov    %eax,%ebp
  802d38:	31 d2                	xor    %edx,%edx
  802d3a:	89 c8                	mov    %ecx,%eax
  802d3c:	f7 f5                	div    %ebp
  802d3e:	89 c1                	mov    %eax,%ecx
  802d40:	89 d8                	mov    %ebx,%eax
  802d42:	f7 f5                	div    %ebp
  802d44:	89 cf                	mov    %ecx,%edi
  802d46:	89 fa                	mov    %edi,%edx
  802d48:	83 c4 1c             	add    $0x1c,%esp
  802d4b:	5b                   	pop    %ebx
  802d4c:	5e                   	pop    %esi
  802d4d:	5f                   	pop    %edi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    
  802d50:	39 ce                	cmp    %ecx,%esi
  802d52:	77 28                	ja     802d7c <__udivdi3+0x7c>
  802d54:	0f bd fe             	bsr    %esi,%edi
  802d57:	83 f7 1f             	xor    $0x1f,%edi
  802d5a:	75 40                	jne    802d9c <__udivdi3+0x9c>
  802d5c:	39 ce                	cmp    %ecx,%esi
  802d5e:	72 0a                	jb     802d6a <__udivdi3+0x6a>
  802d60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802d64:	0f 87 9e 00 00 00    	ja     802e08 <__udivdi3+0x108>
  802d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d6f:	89 fa                	mov    %edi,%edx
  802d71:	83 c4 1c             	add    $0x1c,%esp
  802d74:	5b                   	pop    %ebx
  802d75:	5e                   	pop    %esi
  802d76:	5f                   	pop    %edi
  802d77:	5d                   	pop    %ebp
  802d78:	c3                   	ret    
  802d79:	8d 76 00             	lea    0x0(%esi),%esi
  802d7c:	31 ff                	xor    %edi,%edi
  802d7e:	31 c0                	xor    %eax,%eax
  802d80:	89 fa                	mov    %edi,%edx
  802d82:	83 c4 1c             	add    $0x1c,%esp
  802d85:	5b                   	pop    %ebx
  802d86:	5e                   	pop    %esi
  802d87:	5f                   	pop    %edi
  802d88:	5d                   	pop    %ebp
  802d89:	c3                   	ret    
  802d8a:	66 90                	xchg   %ax,%ax
  802d8c:	89 d8                	mov    %ebx,%eax
  802d8e:	f7 f7                	div    %edi
  802d90:	31 ff                	xor    %edi,%edi
  802d92:	89 fa                	mov    %edi,%edx
  802d94:	83 c4 1c             	add    $0x1c,%esp
  802d97:	5b                   	pop    %ebx
  802d98:	5e                   	pop    %esi
  802d99:	5f                   	pop    %edi
  802d9a:	5d                   	pop    %ebp
  802d9b:	c3                   	ret    
  802d9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802da1:	89 eb                	mov    %ebp,%ebx
  802da3:	29 fb                	sub    %edi,%ebx
  802da5:	89 f9                	mov    %edi,%ecx
  802da7:	d3 e6                	shl    %cl,%esi
  802da9:	89 c5                	mov    %eax,%ebp
  802dab:	88 d9                	mov    %bl,%cl
  802dad:	d3 ed                	shr    %cl,%ebp
  802daf:	89 e9                	mov    %ebp,%ecx
  802db1:	09 f1                	or     %esi,%ecx
  802db3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802db7:	89 f9                	mov    %edi,%ecx
  802db9:	d3 e0                	shl    %cl,%eax
  802dbb:	89 c5                	mov    %eax,%ebp
  802dbd:	89 d6                	mov    %edx,%esi
  802dbf:	88 d9                	mov    %bl,%cl
  802dc1:	d3 ee                	shr    %cl,%esi
  802dc3:	89 f9                	mov    %edi,%ecx
  802dc5:	d3 e2                	shl    %cl,%edx
  802dc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dcb:	88 d9                	mov    %bl,%cl
  802dcd:	d3 e8                	shr    %cl,%eax
  802dcf:	09 c2                	or     %eax,%edx
  802dd1:	89 d0                	mov    %edx,%eax
  802dd3:	89 f2                	mov    %esi,%edx
  802dd5:	f7 74 24 0c          	divl   0xc(%esp)
  802dd9:	89 d6                	mov    %edx,%esi
  802ddb:	89 c3                	mov    %eax,%ebx
  802ddd:	f7 e5                	mul    %ebp
  802ddf:	39 d6                	cmp    %edx,%esi
  802de1:	72 19                	jb     802dfc <__udivdi3+0xfc>
  802de3:	74 0b                	je     802df0 <__udivdi3+0xf0>
  802de5:	89 d8                	mov    %ebx,%eax
  802de7:	31 ff                	xor    %edi,%edi
  802de9:	e9 58 ff ff ff       	jmp    802d46 <__udivdi3+0x46>
  802dee:	66 90                	xchg   %ax,%ax
  802df0:	8b 54 24 08          	mov    0x8(%esp),%edx
  802df4:	89 f9                	mov    %edi,%ecx
  802df6:	d3 e2                	shl    %cl,%edx
  802df8:	39 c2                	cmp    %eax,%edx
  802dfa:	73 e9                	jae    802de5 <__udivdi3+0xe5>
  802dfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802dff:	31 ff                	xor    %edi,%edi
  802e01:	e9 40 ff ff ff       	jmp    802d46 <__udivdi3+0x46>
  802e06:	66 90                	xchg   %ax,%ax
  802e08:	31 c0                	xor    %eax,%eax
  802e0a:	e9 37 ff ff ff       	jmp    802d46 <__udivdi3+0x46>
  802e0f:	90                   	nop

00802e10 <__umoddi3>:
  802e10:	55                   	push   %ebp
  802e11:	57                   	push   %edi
  802e12:	56                   	push   %esi
  802e13:	53                   	push   %ebx
  802e14:	83 ec 1c             	sub    $0x1c,%esp
  802e17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e2f:	89 f3                	mov    %esi,%ebx
  802e31:	89 fa                	mov    %edi,%edx
  802e33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e37:	89 34 24             	mov    %esi,(%esp)
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	75 1a                	jne    802e58 <__umoddi3+0x48>
  802e3e:	39 f7                	cmp    %esi,%edi
  802e40:	0f 86 a2 00 00 00    	jbe    802ee8 <__umoddi3+0xd8>
  802e46:	89 c8                	mov    %ecx,%eax
  802e48:	89 f2                	mov    %esi,%edx
  802e4a:	f7 f7                	div    %edi
  802e4c:	89 d0                	mov    %edx,%eax
  802e4e:	31 d2                	xor    %edx,%edx
  802e50:	83 c4 1c             	add    $0x1c,%esp
  802e53:	5b                   	pop    %ebx
  802e54:	5e                   	pop    %esi
  802e55:	5f                   	pop    %edi
  802e56:	5d                   	pop    %ebp
  802e57:	c3                   	ret    
  802e58:	39 f0                	cmp    %esi,%eax
  802e5a:	0f 87 ac 00 00 00    	ja     802f0c <__umoddi3+0xfc>
  802e60:	0f bd e8             	bsr    %eax,%ebp
  802e63:	83 f5 1f             	xor    $0x1f,%ebp
  802e66:	0f 84 ac 00 00 00    	je     802f18 <__umoddi3+0x108>
  802e6c:	bf 20 00 00 00       	mov    $0x20,%edi
  802e71:	29 ef                	sub    %ebp,%edi
  802e73:	89 fe                	mov    %edi,%esi
  802e75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e79:	89 e9                	mov    %ebp,%ecx
  802e7b:	d3 e0                	shl    %cl,%eax
  802e7d:	89 d7                	mov    %edx,%edi
  802e7f:	89 f1                	mov    %esi,%ecx
  802e81:	d3 ef                	shr    %cl,%edi
  802e83:	09 c7                	or     %eax,%edi
  802e85:	89 e9                	mov    %ebp,%ecx
  802e87:	d3 e2                	shl    %cl,%edx
  802e89:	89 14 24             	mov    %edx,(%esp)
  802e8c:	89 d8                	mov    %ebx,%eax
  802e8e:	d3 e0                	shl    %cl,%eax
  802e90:	89 c2                	mov    %eax,%edx
  802e92:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e96:	d3 e0                	shl    %cl,%eax
  802e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ea0:	89 f1                	mov    %esi,%ecx
  802ea2:	d3 e8                	shr    %cl,%eax
  802ea4:	09 d0                	or     %edx,%eax
  802ea6:	d3 eb                	shr    %cl,%ebx
  802ea8:	89 da                	mov    %ebx,%edx
  802eaa:	f7 f7                	div    %edi
  802eac:	89 d3                	mov    %edx,%ebx
  802eae:	f7 24 24             	mull   (%esp)
  802eb1:	89 c6                	mov    %eax,%esi
  802eb3:	89 d1                	mov    %edx,%ecx
  802eb5:	39 d3                	cmp    %edx,%ebx
  802eb7:	0f 82 87 00 00 00    	jb     802f44 <__umoddi3+0x134>
  802ebd:	0f 84 91 00 00 00    	je     802f54 <__umoddi3+0x144>
  802ec3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ec7:	29 f2                	sub    %esi,%edx
  802ec9:	19 cb                	sbb    %ecx,%ebx
  802ecb:	89 d8                	mov    %ebx,%eax
  802ecd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ed1:	d3 e0                	shl    %cl,%eax
  802ed3:	89 e9                	mov    %ebp,%ecx
  802ed5:	d3 ea                	shr    %cl,%edx
  802ed7:	09 d0                	or     %edx,%eax
  802ed9:	89 e9                	mov    %ebp,%ecx
  802edb:	d3 eb                	shr    %cl,%ebx
  802edd:	89 da                	mov    %ebx,%edx
  802edf:	83 c4 1c             	add    $0x1c,%esp
  802ee2:	5b                   	pop    %ebx
  802ee3:	5e                   	pop    %esi
  802ee4:	5f                   	pop    %edi
  802ee5:	5d                   	pop    %ebp
  802ee6:	c3                   	ret    
  802ee7:	90                   	nop
  802ee8:	89 fd                	mov    %edi,%ebp
  802eea:	85 ff                	test   %edi,%edi
  802eec:	75 0b                	jne    802ef9 <__umoddi3+0xe9>
  802eee:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef3:	31 d2                	xor    %edx,%edx
  802ef5:	f7 f7                	div    %edi
  802ef7:	89 c5                	mov    %eax,%ebp
  802ef9:	89 f0                	mov    %esi,%eax
  802efb:	31 d2                	xor    %edx,%edx
  802efd:	f7 f5                	div    %ebp
  802eff:	89 c8                	mov    %ecx,%eax
  802f01:	f7 f5                	div    %ebp
  802f03:	89 d0                	mov    %edx,%eax
  802f05:	e9 44 ff ff ff       	jmp    802e4e <__umoddi3+0x3e>
  802f0a:	66 90                	xchg   %ax,%ax
  802f0c:	89 c8                	mov    %ecx,%eax
  802f0e:	89 f2                	mov    %esi,%edx
  802f10:	83 c4 1c             	add    $0x1c,%esp
  802f13:	5b                   	pop    %ebx
  802f14:	5e                   	pop    %esi
  802f15:	5f                   	pop    %edi
  802f16:	5d                   	pop    %ebp
  802f17:	c3                   	ret    
  802f18:	3b 04 24             	cmp    (%esp),%eax
  802f1b:	72 06                	jb     802f23 <__umoddi3+0x113>
  802f1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f21:	77 0f                	ja     802f32 <__umoddi3+0x122>
  802f23:	89 f2                	mov    %esi,%edx
  802f25:	29 f9                	sub    %edi,%ecx
  802f27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f2b:	89 14 24             	mov    %edx,(%esp)
  802f2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f32:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f36:	8b 14 24             	mov    (%esp),%edx
  802f39:	83 c4 1c             	add    $0x1c,%esp
  802f3c:	5b                   	pop    %ebx
  802f3d:	5e                   	pop    %esi
  802f3e:	5f                   	pop    %edi
  802f3f:	5d                   	pop    %ebp
  802f40:	c3                   	ret    
  802f41:	8d 76 00             	lea    0x0(%esi),%esi
  802f44:	2b 04 24             	sub    (%esp),%eax
  802f47:	19 fa                	sbb    %edi,%edx
  802f49:	89 d1                	mov    %edx,%ecx
  802f4b:	89 c6                	mov    %eax,%esi
  802f4d:	e9 71 ff ff ff       	jmp    802ec3 <__umoddi3+0xb3>
  802f52:	66 90                	xchg   %ax,%ax
  802f54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802f58:	72 ea                	jb     802f44 <__umoddi3+0x134>
  802f5a:	89 d9                	mov    %ebx,%ecx
  802f5c:	e9 62 ff ff ff       	jmp    802ec3 <__umoddi3+0xb3>
