
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 2f 07 00 00       	call   800765 <libmain>
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
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_lock_cons();
  800041:	e8 bd 1c 00 00       	call   801d03 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 2f 80 00       	push   $0x802f60
  80004e:	e8 a5 0b 00 00       	call   800bf8 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 2f 80 00       	push   $0x802f62
  80005e:	e8 95 0b 00 00       	call   800bf8 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 2f 80 00       	push   $0x802f78
  80006e:	e8 85 0b 00 00       	call   800bf8 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 2f 80 00       	push   $0x802f62
  80007e:	e8 75 0b 00 00       	call   800bf8 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 2f 80 00       	push   $0x802f60
  80008e:	e8 65 0b 00 00       	call   800bf8 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 90 2f 80 00       	push   $0x802f90
  80009e:	e8 55 0b 00 00       	call   800bf8 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 af 2f 80 00       	push   $0x802faf
  8000b8:	e8 3b 0b 00 00       	call   800bf8 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 eb 1a 00 00       	call   801bba <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 b4 2f 80 00       	push   $0x802fb4
  8000dd:	e8 16 0b 00 00       	call   800bf8 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 d6 2f 80 00       	push   $0x802fd6
  8000ed:	e8 06 0b 00 00       	call   800bf8 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 e4 2f 80 00       	push   $0x802fe4
  8000fd:	e8 f6 0a 00 00       	call   800bf8 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 f3 2f 80 00       	push   $0x802ff3
  80010d:	e8 e6 0a 00 00       	call   800bf8 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 03 30 80 00       	push   $0x803003
  80011d:	e8 d6 0a 00 00       	call   800bf8 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 f3 05 00 00       	call   800729 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 e6 05 00 00       	call   800729 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_unlock_cons();
  800158:	e8 c0 1b 00 00       	call   801d1d <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f5 01 00 00       	call   800373 <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 13 02 00 00       	call   8003a4 <InitializeIdentical>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 35 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 22 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 ee 02 00 00       	call   8004b8 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cd:	e8 31 1b 00 00       	call   801d03 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 0c 30 80 00       	push   $0x80300c
  8001da:	e8 19 0a 00 00       	call   800bf8 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001e2:	e8 36 1b 00 00       	call   801d1d <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d4 00 00 00       	call   8002c9 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 40 30 80 00       	push   $0x803040
  800209:	6a 4e                	push   $0x4e
  80020b:	68 62 30 80 00       	push   $0x803062
  800210:	e8 15 07 00 00       	call   80092a <_panic>
		else
		{
			sys_lock_cons();
  800215:	e8 e9 1a 00 00       	call   801d03 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 80 30 80 00       	push   $0x803080
  800222:	e8 d1 09 00 00       	call   800bf8 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b4 30 80 00       	push   $0x8030b4
  800232:	e8 c1 09 00 00       	call   800bf8 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e8 30 80 00       	push   $0x8030e8
  800242:	e8 b1 09 00 00       	call   800bf8 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80024a:	e8 ce 1a 00 00       	call   801d1d <sys_unlock_cons>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 8e 19 00 00       	call   801be8 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025d:	e8 a1 1a 00 00       	call   801d03 <sys_lock_cons>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 1a 31 80 00       	push   $0x80311a
  800270:	e8 83 09 00 00       	call   800bf8 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 a0 04 00 00       	call   800729 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 93 04 00 00       	call   800729 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 86 04 00 00       	call   800729 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_lock_cons();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_unlock_cons();
  8002b2:	e8 66 1a 00 00       	call   801d1d <sys_unlock_cons>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

	//To indicate that it's completed successfully
	inctst();
  8002c1:	e8 f4 1d 00 00       	call   8020ba <inctst>

}
  8002c6:	90                   	nop
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dd:	eb 33                	jmp    800312 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f3:	40                   	inc    %eax
  8002f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	7e 09                	jle    80030f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030d:	eb 0c                	jmp    80031b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030f:	ff 45 f8             	incl   -0x8(%ebp)
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	48                   	dec    %eax
  800316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800319:	7f c4                	jg     8002df <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800326:	8b 45 0c             	mov    0xc(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 c8                	add    %ecx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 c2                	add    %eax,%edx
  80036b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036e:	89 02                	mov    %eax,(%edx)
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800380:	eb 17                	jmp    800399 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c2                	add    %eax,%edx
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800396:	ff 45 fc             	incl   -0x4(%ebp)
  800399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039f:	7c e1                	jl     800382 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b1:	eb 1b                	jmp    8003ce <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c2                	add    %eax,%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c8:	48                   	dec    %eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c dd                	jl     8003b3 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e7:	f7 e9                	imul   %ecx
  8003e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	29 c8                	sub    %ecx,%eax
  8003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003f7:	75 07                	jne    800400 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003f9:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800407:	eb 1e                	jmp    800427 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	99                   	cltd   
  80041d:	f7 7d f8             	idivl  -0x8(%ebp)
  800420:	89 d0                	mov    %edx,%eax
  800422:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800424:	ff 45 fc             	incl   -0x4(%ebp)
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042d:	7c da                	jl     800409 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800438:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800446:	eb 42                	jmp    80048a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044b:	99                   	cltd   
  80044c:	f7 7d f0             	idivl  -0x10(%ebp)
  80044f:	89 d0                	mov    %edx,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	75 10                	jne    800465 <PrintElements+0x33>
			cprintf("\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 60 2f 80 00       	push   $0x802f60
  80045d:	e8 96 07 00 00       	call   800bf8 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 38 31 80 00       	push   $0x803138
  80047f:	e8 74 07 00 00       	call   800bf8 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800487:	ff 45 f4             	incl   -0xc(%ebp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	48                   	dec    %eax
  80048e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800491:	7f b5                	jg     800448 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 af 2f 80 00       	push   $0x802faf
  8004ad:	e8 46 07 00 00       	call   800bf8 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp

}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c4:	7d 54                	jge    80051a <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 1f             	shr    $0x1f,%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	d1 f8                	sar    %eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 cd ff ff ff       	call   8004b8 <MSort>
  8004eb:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	40                   	inc    %eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 10             	pushl  0x10(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 b7 ff ff ff       	call   8004b8 <MSort>
  800501:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 08             	pushl  0x8(%ebp)
  800510:	e8 08 00 00 00       	call   80051d <Merge>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb 01                	jmp    80051b <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80051a:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	2b 45 0c             	sub    0xc(%ebp),%eax
  800529:	40                   	inc    %eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	2b 45 10             	sub    0x10(%ebp),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	c1 e0 02             	shl    $0x2,%eax
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	50                   	push   %eax
  80054e:	e8 67 16 00 00       	call   801bba <malloc>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	c1 e0 02             	shl    $0x2,%eax
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	50                   	push   %eax
  800563:	e8 52 16 00 00       	call   801bba <malloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800575:	eb 2f                	jmp    8005a6 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800593:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	ff 45 ec             	incl   -0x14(%ebp)
  8005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ac:	7c c9                	jl     800577 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b5:	eb 2a                	jmp    8005e1 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c4:	01 c2                	add    %eax,%edx
  8005c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	01 c8                	add    %ecx,%eax
  8005ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
  8005e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e7:	7c ce                	jl     8005b7 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ef:	e9 0a 01 00 00       	jmp    8006fe <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005fa:	0f 8d 95 00 00 00    	jge    800695 <Merge+0x178>
  800600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800603:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800606:	0f 8d 89 00 00 00    	jge    800695 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	7d 33                	jge    800665 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800635:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800660:	e9 96 00 00 00       	jmp    8006fb <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800668:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800693:	eb 66                	jmp    8006fb <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80069b:	7d 30                	jge    8006cd <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b5:	8d 50 01             	lea    0x1(%eax),%edx
  8006b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 01                	mov    %eax,(%ecx)
  8006cb:	eb 2e                	jmp    8006fb <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	3b 45 14             	cmp    0x14(%ebp),%eax
  800704:	0f 8e ea fe ff ff    	jle    8005f4 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d8             	pushl  -0x28(%ebp)
  800710:	e8 d3 14 00 00       	call   801be8 <free>
  800715:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071e:	e8 c5 14 00 00       	call   801be8 <free>
  800723:	83 c4 10             	add    $0x10,%esp

}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800735:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	50                   	push   %eax
  80073d:	e8 09 17 00 00       	call   801e4b <sys_cputc>
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <getchar>:


int
getchar(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80074e:	e8 97 15 00 00       	call   801cea <sys_cgetc>
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <iscons>:

int iscons(int fdnum)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80076e:	e8 09 18 00 00       	call   801f7c <sys_getenvindex>
  800773:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800779:	89 d0                	mov    %edx,%eax
  80077b:	c1 e0 06             	shl    $0x6,%eax
  80077e:	29 d0                	sub    %edx,%eax
  800780:	c1 e0 02             	shl    $0x2,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80078c:	01 c8                	add    %ecx,%eax
  80078e:	c1 e0 03             	shl    $0x3,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079a:	29 c2                	sub    %eax,%edx
  80079c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8007a3:	89 c2                	mov    %eax,%edx
  8007a5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007ab:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007b0:	a1 24 40 80 00       	mov    0x804024,%eax
  8007b5:	8a 40 20             	mov    0x20(%eax),%al
  8007b8:	84 c0                	test   %al,%al
  8007ba:	74 0d                	je     8007c9 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8007bc:	a1 24 40 80 00       	mov    0x804024,%eax
  8007c1:	83 c0 20             	add    $0x20,%eax
  8007c4:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007cd:	7e 0a                	jle    8007d9 <libmain+0x74>
		binaryname = argv[0];
  8007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 0c             	pushl  0xc(%ebp)
  8007df:	ff 75 08             	pushl  0x8(%ebp)
  8007e2:	e8 51 f8 ff ff       	call   800038 <_main>
  8007e7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007ea:	a1 00 40 80 00       	mov    0x804000,%eax
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	0f 84 01 01 00 00    	je     8008f8 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007f7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007fd:	bb 38 32 80 00       	mov    $0x803238,%ebx
  800802:	ba 0e 00 00 00       	mov    $0xe,%edx
  800807:	89 c7                	mov    %eax,%edi
  800809:	89 de                	mov    %ebx,%esi
  80080b:	89 d1                	mov    %edx,%ecx
  80080d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80080f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800812:	b9 56 00 00 00       	mov    $0x56,%ecx
  800817:	b0 00                	mov    $0x0,%al
  800819:	89 d7                	mov    %edx,%edi
  80081b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80081d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800824:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	50                   	push   %eax
  80082b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800831:	50                   	push   %eax
  800832:	e8 7b 19 00 00       	call   8021b2 <sys_utilities>
  800837:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80083a:	e8 c4 14 00 00       	call   801d03 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	68 58 31 80 00       	push   $0x803158
  800847:	e8 ac 03 00 00       	call   800bf8 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80084f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800852:	85 c0                	test   %eax,%eax
  800854:	74 18                	je     80086e <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800856:	e8 75 19 00 00       	call   8021d0 <sys_get_optimal_num_faults>
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	50                   	push   %eax
  80085f:	68 80 31 80 00       	push   $0x803180
  800864:	e8 8f 03 00 00       	call   800bf8 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	eb 59                	jmp    8008c7 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80086e:	a1 24 40 80 00       	mov    0x804024,%eax
  800873:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800879:	a1 24 40 80 00       	mov    0x804024,%eax
  80087e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 a4 31 80 00       	push   $0x8031a4
  80088e:	e8 65 03 00 00       	call   800bf8 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800896:	a1 24 40 80 00       	mov    0x804024,%eax
  80089b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8008a1:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a6:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8008ac:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b1:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8008b7:	51                   	push   %ecx
  8008b8:	52                   	push   %edx
  8008b9:	50                   	push   %eax
  8008ba:	68 cc 31 80 00       	push   $0x8031cc
  8008bf:	e8 34 03 00 00       	call   800bf8 <cprintf>
  8008c4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008c7:	a1 24 40 80 00       	mov    0x804024,%eax
  8008cc:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	50                   	push   %eax
  8008d6:	68 24 32 80 00       	push   $0x803224
  8008db:	e8 18 03 00 00       	call   800bf8 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	68 58 31 80 00       	push   $0x803158
  8008eb:	e8 08 03 00 00       	call   800bf8 <cprintf>
  8008f0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008f3:	e8 25 14 00 00       	call   801d1d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008f8:	e8 1f 00 00 00       	call   80091c <exit>
}
  8008fd:	90                   	nop
  8008fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5f                   	pop    %edi
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80090c:	83 ec 0c             	sub    $0xc,%esp
  80090f:	6a 00                	push   $0x0
  800911:	e8 32 16 00 00       	call   801f48 <sys_destroy_env>
  800916:	83 c4 10             	add    $0x10,%esp
}
  800919:	90                   	nop
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <exit>:

void
exit(void)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800922:	e8 87 16 00 00       	call   801fae <sys_exit_env>
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800930:	8d 45 10             	lea    0x10(%ebp),%eax
  800933:	83 c0 04             	add    $0x4,%eax
  800936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800939:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80093e:	85 c0                	test   %eax,%eax
  800940:	74 16                	je     800958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800942:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	50                   	push   %eax
  80094b:	68 9c 32 80 00       	push   $0x80329c
  800950:	e8 a3 02 00 00       	call   800bf8 <cprintf>
  800955:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800958:	a1 04 40 80 00       	mov    0x804004,%eax
  80095d:	83 ec 0c             	sub    $0xc,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	ff 75 08             	pushl  0x8(%ebp)
  800966:	50                   	push   %eax
  800967:	68 a4 32 80 00       	push   $0x8032a4
  80096c:	6a 74                	push   $0x74
  80096e:	e8 b2 02 00 00       	call   800c25 <cprintf_colored>
  800973:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800976:	8b 45 10             	mov    0x10(%ebp),%eax
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 f4             	pushl  -0xc(%ebp)
  80097f:	50                   	push   %eax
  800980:	e8 04 02 00 00       	call   800b89 <vcprintf>
  800985:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	6a 00                	push   $0x0
  80098d:	68 cc 32 80 00       	push   $0x8032cc
  800992:	e8 f2 01 00 00       	call   800b89 <vcprintf>
  800997:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80099a:	e8 7d ff ff ff       	call   80091c <exit>

	// should not return here
	while (1) ;
  80099f:	eb fe                	jmp    80099f <_panic+0x75>

008009a1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009a7:	a1 24 40 80 00       	mov    0x804024,%eax
  8009ac:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	39 c2                	cmp    %eax,%edx
  8009b7:	74 14                	je     8009cd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009b9:	83 ec 04             	sub    $0x4,%esp
  8009bc:	68 d0 32 80 00       	push   $0x8032d0
  8009c1:	6a 26                	push   $0x26
  8009c3:	68 1c 33 80 00       	push   $0x80331c
  8009c8:	e8 5d ff ff ff       	call   80092a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009db:	e9 c5 00 00 00       	jmp    800aa5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	01 d0                	add    %edx,%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	85 c0                	test   %eax,%eax
  8009f3:	75 08                	jne    8009fd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009f5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009f8:	e9 a5 00 00 00       	jmp    800aa2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a0b:	eb 69                	jmp    800a76 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a0d:	a1 24 40 80 00       	mov    0x804024,%eax
  800a12:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	01 c0                	add    %eax,%eax
  800a1f:	01 d0                	add    %edx,%eax
  800a21:	c1 e0 03             	shl    $0x3,%eax
  800a24:	01 c8                	add    %ecx,%eax
  800a26:	8a 40 04             	mov    0x4(%eax),%al
  800a29:	84 c0                	test   %al,%al
  800a2b:	75 46                	jne    800a73 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a2d:	a1 24 40 80 00       	mov    0x804024,%eax
  800a32:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	01 d0                	add    %edx,%eax
  800a41:	c1 e0 03             	shl    $0x3,%eax
  800a44:	01 c8                	add    %ecx,%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a53:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a58:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	01 c8                	add    %ecx,%eax
  800a64:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	75 09                	jne    800a73 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a6a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a71:	eb 15                	jmp    800a88 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a73:	ff 45 e8             	incl   -0x18(%ebp)
  800a76:	a1 24 40 80 00       	mov    0x804024,%eax
  800a7b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a84:	39 c2                	cmp    %eax,%edx
  800a86:	77 85                	ja     800a0d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a8c:	75 14                	jne    800aa2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 28 33 80 00       	push   $0x803328
  800a96:	6a 3a                	push   $0x3a
  800a98:	68 1c 33 80 00       	push   $0x80331c
  800a9d:	e8 88 fe ff ff       	call   80092a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aa2:	ff 45 f0             	incl   -0x10(%ebp)
  800aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800aab:	0f 8c 2f ff ff ff    	jl     8009e0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ab1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800abf:	eb 26                	jmp    800ae7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ac1:	a1 24 40 80 00       	mov    0x804024,%eax
  800ac6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800acc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d0                	add    %edx,%eax
  800ad5:	c1 e0 03             	shl    $0x3,%eax
  800ad8:	01 c8                	add    %ecx,%eax
  800ada:	8a 40 04             	mov    0x4(%eax),%al
  800add:	3c 01                	cmp    $0x1,%al
  800adf:	75 03                	jne    800ae4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ae1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae4:	ff 45 e0             	incl   -0x20(%ebp)
  800ae7:	a1 24 40 80 00       	mov    0x804024,%eax
  800aec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af5:	39 c2                	cmp    %eax,%edx
  800af7:	77 c8                	ja     800ac1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800afc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aff:	74 14                	je     800b15 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b01:	83 ec 04             	sub    $0x4,%esp
  800b04:	68 7c 33 80 00       	push   $0x80337c
  800b09:	6a 44                	push   $0x44
  800b0b:	68 1c 33 80 00       	push   $0x80331c
  800b10:	e8 15 fe ff ff       	call   80092a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b15:	90                   	nop
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	53                   	push   %ebx
  800b1c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	8d 48 01             	lea    0x1(%eax),%ecx
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	89 0a                	mov    %ecx,(%edx)
  800b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2f:	88 d1                	mov    %dl,%cl
  800b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b34:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b42:	75 30                	jne    800b74 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b44:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b4a:	a0 44 40 80 00       	mov    0x804044,%al
  800b4f:	0f b6 c0             	movzbl %al,%eax
  800b52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b55:	8b 09                	mov    (%ecx),%ecx
  800b57:	89 cb                	mov    %ecx,%ebx
  800b59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5c:	83 c1 08             	add    $0x8,%ecx
  800b5f:	52                   	push   %edx
  800b60:	50                   	push   %eax
  800b61:	53                   	push   %ebx
  800b62:	51                   	push   %ecx
  800b63:	e8 57 11 00 00       	call   801cbf <sys_cputs>
  800b68:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8b 40 04             	mov    0x4(%eax),%eax
  800b7a:	8d 50 01             	lea    0x1(%eax),%edx
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b83:	90                   	nop
  800b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b92:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b99:	00 00 00 
	b.cnt = 0;
  800b9c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ba3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bb2:	50                   	push   %eax
  800bb3:	68 18 0b 80 00       	push   $0x800b18
  800bb8:	e8 5a 02 00 00       	call   800e17 <vprintfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bc0:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bc6:	a0 44 40 80 00       	mov    0x804044,%al
  800bcb:	0f b6 c0             	movzbl %al,%eax
  800bce:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bd4:	52                   	push   %edx
  800bd5:	50                   	push   %eax
  800bd6:	51                   	push   %ecx
  800bd7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bdd:	83 c0 08             	add    $0x8,%eax
  800be0:	50                   	push   %eax
  800be1:	e8 d9 10 00 00       	call   801cbf <sys_cputs>
  800be6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800be9:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bf0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bfe:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 f4             	pushl  -0xc(%ebp)
  800c14:	50                   	push   %eax
  800c15:	e8 6f ff ff ff       	call   800b89 <vcprintf>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c2b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	c1 e0 08             	shl    $0x8,%eax
  800c38:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c3d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c40:	83 c0 04             	add    $0x4,%eax
  800c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	50                   	push   %eax
  800c50:	e8 34 ff ff ff       	call   800b89 <vcprintf>
  800c55:	83 c4 10             	add    $0x10,%esp
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c5b:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c62:	07 00 00 

	return cnt;
  800c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c70:	e8 8e 10 00 00       	call   801d03 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c75:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	e8 ff fe ff ff       	call   800b89 <vcprintf>
  800c8a:	83 c4 10             	add    $0x10,%esp
  800c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c90:	e8 88 10 00 00       	call   801d1d <sys_unlock_cons>
	return cnt;
  800c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	53                   	push   %ebx
  800c9e:	83 ec 14             	sub    $0x14,%esp
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cad:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cb8:	77 55                	ja     800d0f <printnum+0x75>
  800cba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cbd:	72 05                	jb     800cc4 <printnum+0x2a>
  800cbf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cc2:	77 4b                	ja     800d0f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cc4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cc7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cca:	8b 45 18             	mov    0x18(%ebp),%eax
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd2:	52                   	push   %edx
  800cd3:	50                   	push   %eax
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cda:	e8 09 20 00 00       	call   802ce8 <__udivdi3>
  800cdf:	83 c4 10             	add    $0x10,%esp
  800ce2:	83 ec 04             	sub    $0x4,%esp
  800ce5:	ff 75 20             	pushl  0x20(%ebp)
  800ce8:	53                   	push   %ebx
  800ce9:	ff 75 18             	pushl  0x18(%ebp)
  800cec:	52                   	push   %edx
  800ced:	50                   	push   %eax
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 a1 ff ff ff       	call   800c9a <printnum>
  800cf9:	83 c4 20             	add    $0x20,%esp
  800cfc:	eb 1a                	jmp    800d18 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 20             	pushl  0x20(%ebp)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	ff d0                	call   *%eax
  800d0c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d0f:	ff 4d 1c             	decl   0x1c(%ebp)
  800d12:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d16:	7f e6                	jg     800cfe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d18:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d26:	53                   	push   %ebx
  800d27:	51                   	push   %ecx
  800d28:	52                   	push   %edx
  800d29:	50                   	push   %eax
  800d2a:	e8 c9 20 00 00       	call   802df8 <__umoddi3>
  800d2f:	83 c4 10             	add    $0x10,%esp
  800d32:	05 f4 35 80 00       	add    $0x8035f4,%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f be c0             	movsbl %al,%eax
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	ff d0                	call   *%eax
  800d48:	83 c4 10             	add    $0x10,%esp
}
  800d4b:	90                   	nop
  800d4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d54:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d58:	7e 1c                	jle    800d76 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 50 08             	lea    0x8(%eax),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	89 10                	mov    %edx,(%eax)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	83 e8 08             	sub    $0x8,%eax
  800d6f:	8b 50 04             	mov    0x4(%eax),%edx
  800d72:	8b 00                	mov    (%eax),%eax
  800d74:	eb 40                	jmp    800db6 <getuint+0x65>
	else if (lflag)
  800d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7a:	74 1e                	je     800d9a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	8d 50 04             	lea    0x4(%eax),%edx
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	89 10                	mov    %edx,(%eax)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	83 e8 04             	sub    $0x4,%eax
  800d91:	8b 00                	mov    (%eax),%eax
  800d93:	ba 00 00 00 00       	mov    $0x0,%edx
  800d98:	eb 1c                	jmp    800db6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8b 00                	mov    (%eax),%eax
  800d9f:	8d 50 04             	lea    0x4(%eax),%edx
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 10                	mov    %edx,(%eax)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	83 e8 04             	sub    $0x4,%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dbb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dbf:	7e 1c                	jle    800ddd <getint+0x25>
		return va_arg(*ap, long long);
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8b 00                	mov    (%eax),%eax
  800dc6:	8d 50 08             	lea    0x8(%eax),%edx
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 10                	mov    %edx,(%eax)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	83 e8 08             	sub    $0x8,%eax
  800dd6:	8b 50 04             	mov    0x4(%eax),%edx
  800dd9:	8b 00                	mov    (%eax),%eax
  800ddb:	eb 38                	jmp    800e15 <getint+0x5d>
	else if (lflag)
  800ddd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de1:	74 1a                	je     800dfd <getint+0x45>
		return va_arg(*ap, long);
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	8d 50 04             	lea    0x4(%eax),%edx
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	89 10                	mov    %edx,(%eax)
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8b 00                	mov    (%eax),%eax
  800df5:	83 e8 04             	sub    $0x4,%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	99                   	cltd   
  800dfb:	eb 18                	jmp    800e15 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8b 00                	mov    (%eax),%eax
  800e02:	8d 50 04             	lea    0x4(%eax),%edx
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	89 10                	mov    %edx,(%eax)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8b 00                	mov    (%eax),%eax
  800e0f:	83 e8 04             	sub    $0x4,%eax
  800e12:	8b 00                	mov    (%eax),%eax
  800e14:	99                   	cltd   
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e1f:	eb 17                	jmp    800e38 <vprintfmt+0x21>
			if (ch == '\0')
  800e21:	85 db                	test   %ebx,%ebx
  800e23:	0f 84 c1 03 00 00    	je     8011ea <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	53                   	push   %ebx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8d 50 01             	lea    0x1(%eax),%edx
  800e3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	0f b6 d8             	movzbl %al,%ebx
  800e46:	83 fb 25             	cmp    $0x25,%ebx
  800e49:	75 d6                	jne    800e21 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e4b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e4f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e56:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 01             	lea    0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 d8             	movzbl %al,%ebx
  800e79:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e7c:	83 f8 5b             	cmp    $0x5b,%eax
  800e7f:	0f 87 3d 03 00 00    	ja     8011c2 <vprintfmt+0x3ab>
  800e85:	8b 04 85 18 36 80 00 	mov    0x803618(,%eax,4),%eax
  800e8c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e8e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e92:	eb d7                	jmp    800e6b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e94:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e98:	eb d1                	jmp    800e6b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ea1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ea4:	89 d0                	mov    %edx,%eax
  800ea6:	c1 e0 02             	shl    $0x2,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	01 c0                	add    %eax,%eax
  800ead:	01 d8                	add    %ebx,%eax
  800eaf:	83 e8 30             	sub    $0x30,%eax
  800eb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ebd:	83 fb 2f             	cmp    $0x2f,%ebx
  800ec0:	7e 3e                	jle    800f00 <vprintfmt+0xe9>
  800ec2:	83 fb 39             	cmp    $0x39,%ebx
  800ec5:	7f 39                	jg     800f00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ec7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eca:	eb d5                	jmp    800ea1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ee0:	eb 1f                	jmp    800f01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ee2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee6:	79 83                	jns    800e6b <vprintfmt+0x54>
				width = 0;
  800ee8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eef:	e9 77 ff ff ff       	jmp    800e6b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ef4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800efb:	e9 6b ff ff ff       	jmp    800e6b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f05:	0f 89 60 ff ff ff    	jns    800e6b <vprintfmt+0x54>
				width = precision, precision = -1;
  800f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f18:	e9 4e ff ff ff       	jmp    800e6b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f20:	e9 46 ff ff ff       	jmp    800e6b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	83 c0 04             	add    $0x4,%eax
  800f2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 e8 04             	sub    $0x4,%eax
  800f34:	8b 00                	mov    (%eax),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 0c             	pushl  0xc(%ebp)
  800f3c:	50                   	push   %eax
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 9b 02 00 00       	jmp    8011e5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	83 c0 04             	add    $0x4,%eax
  800f50:	89 45 14             	mov    %eax,0x14(%ebp)
  800f53:	8b 45 14             	mov    0x14(%ebp),%eax
  800f56:	83 e8 04             	sub    $0x4,%eax
  800f59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f5b:	85 db                	test   %ebx,%ebx
  800f5d:	79 02                	jns    800f61 <vprintfmt+0x14a>
				err = -err;
  800f5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f61:	83 fb 64             	cmp    $0x64,%ebx
  800f64:	7f 0b                	jg     800f71 <vprintfmt+0x15a>
  800f66:	8b 34 9d 60 34 80 00 	mov    0x803460(,%ebx,4),%esi
  800f6d:	85 f6                	test   %esi,%esi
  800f6f:	75 19                	jne    800f8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f71:	53                   	push   %ebx
  800f72:	68 05 36 80 00       	push   $0x803605
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	ff 75 08             	pushl  0x8(%ebp)
  800f7d:	e8 70 02 00 00       	call   8011f2 <printfmt>
  800f82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f85:	e9 5b 02 00 00       	jmp    8011e5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f8a:	56                   	push   %esi
  800f8b:	68 0e 36 80 00       	push   $0x80360e
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 57 02 00 00       	call   8011f2 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			break;
  800f9e:	e9 42 02 00 00       	jmp    8011e5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa6:	83 c0 04             	add    $0x4,%eax
  800fa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	83 e8 04             	sub    $0x4,%eax
  800fb2:	8b 30                	mov    (%eax),%esi
  800fb4:	85 f6                	test   %esi,%esi
  800fb6:	75 05                	jne    800fbd <vprintfmt+0x1a6>
				p = "(null)";
  800fb8:	be 11 36 80 00       	mov    $0x803611,%esi
			if (width > 0 && padc != '-')
  800fbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc1:	7e 6d                	jle    801030 <vprintfmt+0x219>
  800fc3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fc7:	74 67                	je     801030 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	50                   	push   %eax
  800fd0:	56                   	push   %esi
  800fd1:	e8 1e 03 00 00       	call   8012f4 <strnlen>
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fdc:	eb 16                	jmp    800ff4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fde:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	ff d0                	call   *%eax
  800fee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ff1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff8:	7f e4                	jg     800fde <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ffa:	eb 34                	jmp    801030 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ffc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801000:	74 1c                	je     80101e <vprintfmt+0x207>
  801002:	83 fb 1f             	cmp    $0x1f,%ebx
  801005:	7e 05                	jle    80100c <vprintfmt+0x1f5>
  801007:	83 fb 7e             	cmp    $0x7e,%ebx
  80100a:	7e 12                	jle    80101e <vprintfmt+0x207>
					putch('?', putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	6a 3f                	push   $0x3f
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	ff d0                	call   *%eax
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	eb 0f                	jmp    80102d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	53                   	push   %ebx
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	ff d0                	call   *%eax
  80102a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80102d:	ff 4d e4             	decl   -0x1c(%ebp)
  801030:	89 f0                	mov    %esi,%eax
  801032:	8d 70 01             	lea    0x1(%eax),%esi
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be d8             	movsbl %al,%ebx
  80103a:	85 db                	test   %ebx,%ebx
  80103c:	74 24                	je     801062 <vprintfmt+0x24b>
  80103e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801042:	78 b8                	js     800ffc <vprintfmt+0x1e5>
  801044:	ff 4d e0             	decl   -0x20(%ebp)
  801047:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104b:	79 af                	jns    800ffc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80104d:	eb 13                	jmp    801062 <vprintfmt+0x24b>
				putch(' ', putdat);
  80104f:	83 ec 08             	sub    $0x8,%esp
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	6a 20                	push   $0x20
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	ff d0                	call   *%eax
  80105c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80105f:	ff 4d e4             	decl   -0x1c(%ebp)
  801062:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801066:	7f e7                	jg     80104f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801068:	e9 78 01 00 00       	jmp    8011e5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	ff 75 e8             	pushl  -0x18(%ebp)
  801073:	8d 45 14             	lea    0x14(%ebp),%eax
  801076:	50                   	push   %eax
  801077:	e8 3c fd ff ff       	call   800db8 <getint>
  80107c:	83 c4 10             	add    $0x10,%esp
  80107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801082:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108b:	85 d2                	test   %edx,%edx
  80108d:	79 23                	jns    8010b2 <vprintfmt+0x29b>
				putch('-', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 2d                	push   $0x2d
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80109f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a5:	f7 d8                	neg    %eax
  8010a7:	83 d2 00             	adc    $0x0,%edx
  8010aa:	f7 da                	neg    %edx
  8010ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010b2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010b9:	e9 bc 00 00 00       	jmp    80117a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010c7:	50                   	push   %eax
  8010c8:	e8 84 fc ff ff       	call   800d51 <getuint>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010dd:	e9 98 00 00 00       	jmp    80117a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	ff 75 0c             	pushl  0xc(%ebp)
  8010e8:	6a 58                	push   $0x58
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	ff d0                	call   *%eax
  8010ef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	6a 58                	push   $0x58
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	ff d0                	call   *%eax
  8010ff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	6a 58                	push   $0x58
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
			break;
  801112:	e9 ce 00 00 00       	jmp    8011e5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	6a 30                	push   $0x30
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	ff d0                	call   *%eax
  801124:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	6a 78                	push   $0x78
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	ff d0                	call   *%eax
  801134:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801137:	8b 45 14             	mov    0x14(%ebp),%eax
  80113a:	83 c0 04             	add    $0x4,%eax
  80113d:	89 45 14             	mov    %eax,0x14(%ebp)
  801140:	8b 45 14             	mov    0x14(%ebp),%eax
  801143:	83 e8 04             	sub    $0x4,%eax
  801146:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801148:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801152:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801159:	eb 1f                	jmp    80117a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80115b:	83 ec 08             	sub    $0x8,%esp
  80115e:	ff 75 e8             	pushl  -0x18(%ebp)
  801161:	8d 45 14             	lea    0x14(%ebp),%eax
  801164:	50                   	push   %eax
  801165:	e8 e7 fb ff ff       	call   800d51 <getuint>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801170:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801173:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80117a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80117e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	52                   	push   %edx
  801185:	ff 75 e4             	pushl  -0x1c(%ebp)
  801188:	50                   	push   %eax
  801189:	ff 75 f4             	pushl  -0xc(%ebp)
  80118c:	ff 75 f0             	pushl  -0x10(%ebp)
  80118f:	ff 75 0c             	pushl  0xc(%ebp)
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	e8 00 fb ff ff       	call   800c9a <printnum>
  80119a:	83 c4 20             	add    $0x20,%esp
			break;
  80119d:	eb 46                	jmp    8011e5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	53                   	push   %ebx
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
			break;
  8011ae:	eb 35                	jmp    8011e5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011b0:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011b7:	eb 2c                	jmp    8011e5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011b9:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011c0:	eb 23                	jmp    8011e5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c2:	83 ec 08             	sub    $0x8,%esp
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	6a 25                	push   $0x25
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	ff d0                	call   *%eax
  8011cf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d2:	ff 4d 10             	decl   0x10(%ebp)
  8011d5:	eb 03                	jmp    8011da <vprintfmt+0x3c3>
  8011d7:	ff 4d 10             	decl   0x10(%ebp)
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	48                   	dec    %eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 25                	cmp    $0x25,%al
  8011e2:	75 f3                	jne    8011d7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011e4:	90                   	nop
		}
	}
  8011e5:	e9 35 fc ff ff       	jmp    800e1f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011ea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8011fb:	83 c0 04             	add    $0x4,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	ff 75 f4             	pushl  -0xc(%ebp)
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	ff 75 08             	pushl  0x8(%ebp)
  80120e:	e8 04 fc ff ff       	call   800e17 <vprintfmt>
  801213:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801216:	90                   	nop
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8b 40 08             	mov    0x8(%eax),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	8b 10                	mov    (%eax),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	8b 40 04             	mov    0x4(%eax),%eax
  801236:	39 c2                	cmp    %eax,%edx
  801238:	73 12                	jae    80124c <sprintputch+0x33>
		*b->buf++ = ch;
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	8b 00                	mov    (%eax),%eax
  80123f:	8d 48 01             	lea    0x1(%eax),%ecx
  801242:	8b 55 0c             	mov    0xc(%ebp),%edx
  801245:	89 0a                	mov    %ecx,(%edx)
  801247:	8b 55 08             	mov    0x8(%ebp),%edx
  80124a:	88 10                	mov    %dl,(%eax)
}
  80124c:	90                   	nop
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801274:	74 06                	je     80127c <vsnprintf+0x2d>
  801276:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127a:	7f 07                	jg     801283 <vsnprintf+0x34>
		return -E_INVAL;
  80127c:	b8 03 00 00 00       	mov    $0x3,%eax
  801281:	eb 20                	jmp    8012a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801283:	ff 75 14             	pushl  0x14(%ebp)
  801286:	ff 75 10             	pushl  0x10(%ebp)
  801289:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	68 19 12 80 00       	push   $0x801219
  801292:	e8 80 fb ff ff       	call   800e17 <vprintfmt>
  801297:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80129a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ae:	83 c0 04             	add    $0x4,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ba:	50                   	push   %eax
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 89 ff ff ff       	call   80124f <vsnprintf>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012de:	eb 06                	jmp    8012e6 <strlen+0x15>
		n++;
  8012e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e3:	ff 45 08             	incl   0x8(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	84 c0                	test   %al,%al
  8012ed:	75 f1                	jne    8012e0 <strlen+0xf>
		n++;
	return n;
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801301:	eb 09                	jmp    80130c <strnlen+0x18>
		n++;
  801303:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801306:	ff 45 08             	incl   0x8(%ebp)
  801309:	ff 4d 0c             	decl   0xc(%ebp)
  80130c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801310:	74 09                	je     80131b <strnlen+0x27>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	75 e8                	jne    801303 <strnlen+0xf>
		n++;
	return n;
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80132c:	90                   	nop
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8d 50 01             	lea    0x1(%eax),%edx
  801333:	89 55 08             	mov    %edx,0x8(%ebp)
  801336:	8b 55 0c             	mov    0xc(%ebp),%edx
  801339:	8d 4a 01             	lea    0x1(%edx),%ecx
  80133c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133f:	8a 12                	mov    (%edx),%dl
  801341:	88 10                	mov    %dl,(%eax)
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	75 e4                	jne    80132d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80135a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801361:	eb 1f                	jmp    801382 <strncpy+0x34>
		*dst++ = *src;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8d 50 01             	lea    0x1(%eax),%edx
  801369:	89 55 08             	mov    %edx,0x8(%ebp)
  80136c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136f:	8a 12                	mov    (%edx),%dl
  801371:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	84 c0                	test   %al,%al
  80137a:	74 03                	je     80137f <strncpy+0x31>
			src++;
  80137c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137f:	ff 45 fc             	incl   -0x4(%ebp)
  801382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801385:	3b 45 10             	cmp    0x10(%ebp),%eax
  801388:	72 d9                	jb     801363 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80139b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139f:	74 30                	je     8013d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013a1:	eb 16                	jmp    8013b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b5:	8a 12                	mov    (%edx),%dl
  8013b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b9:	ff 4d 10             	decl   0x10(%ebp)
  8013bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c0:	74 09                	je     8013cb <strlcpy+0x3c>
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 d8                	jne    8013a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d7:	29 c2                	sub    %eax,%edx
  8013d9:	89 d0                	mov    %edx,%eax
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013e0:	eb 06                	jmp    8013e8 <strcmp+0xb>
		p++, q++;
  8013e2:	ff 45 08             	incl   0x8(%ebp)
  8013e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	84 c0                	test   %al,%al
  8013ef:	74 0e                	je     8013ff <strcmp+0x22>
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 10                	mov    (%eax),%dl
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	38 c2                	cmp    %al,%dl
  8013fd:	74 e3                	je     8013e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	0f b6 d0             	movzbl %al,%edx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	0f b6 c0             	movzbl %al,%eax
  80140f:	29 c2                	sub    %eax,%edx
  801411:	89 d0                	mov    %edx,%eax
}
  801413:	5d                   	pop    %ebp
  801414:	c3                   	ret    

00801415 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801418:	eb 09                	jmp    801423 <strncmp+0xe>
		n--, p++, q++;
  80141a:	ff 4d 10             	decl   0x10(%ebp)
  80141d:	ff 45 08             	incl   0x8(%ebp)
  801420:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801423:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801427:	74 17                	je     801440 <strncmp+0x2b>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	84 c0                	test   %al,%al
  801430:	74 0e                	je     801440 <strncmp+0x2b>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 10                	mov    (%eax),%dl
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	38 c2                	cmp    %al,%dl
  80143e:	74 da                	je     80141a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801440:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801444:	75 07                	jne    80144d <strncmp+0x38>
		return 0;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	eb 14                	jmp    801461 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	0f b6 c0             	movzbl %al,%eax
  80145d:	29 c2                	sub    %eax,%edx
  80145f:	89 d0                	mov    %edx,%eax
}
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146f:	eb 12                	jmp    801483 <strchr+0x20>
		if (*s == c)
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801479:	75 05                	jne    801480 <strchr+0x1d>
			return (char *) s;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	eb 11                	jmp    801491 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801480:	ff 45 08             	incl   0x8(%ebp)
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	84 c0                	test   %al,%al
  80148a:	75 e5                	jne    801471 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149f:	eb 0d                	jmp    8014ae <strfind+0x1b>
		if (*s == c)
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a9:	74 0e                	je     8014b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ab:	ff 45 08             	incl   0x8(%ebp)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	75 ea                	jne    8014a1 <strfind+0xe>
  8014b7:	eb 01                	jmp    8014ba <strfind+0x27>
		if (*s == c)
			break;
  8014b9:	90                   	nop
	return (char *) s;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014cb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014cf:	76 63                	jbe    801534 <memset+0x75>
		uint64 data_block = c;
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	99                   	cltd   
  8014d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014e5:	c1 e0 08             	shl    $0x8,%eax
  8014e8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014eb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014f8:	c1 e0 10             	shl    $0x10,%eax
  8014fb:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014fe:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801507:	89 c2                	mov    %eax,%edx
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
  80150e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801511:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801514:	eb 18                	jmp    80152e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801516:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801519:	8d 41 08             	lea    0x8(%ecx),%eax
  80151c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801525:	89 01                	mov    %eax,(%ecx)
  801527:	89 51 04             	mov    %edx,0x4(%ecx)
  80152a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80152e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801532:	77 e2                	ja     801516 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801538:	74 23                	je     80155d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801540:	eb 0e                	jmp    801550 <memset+0x91>
			*p8++ = (uint8)c;
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8d 50 01             	lea    0x1(%eax),%edx
  801548:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	8d 50 ff             	lea    -0x1(%eax),%edx
  801556:	89 55 10             	mov    %edx,0x10(%ebp)
  801559:	85 c0                	test   %eax,%eax
  80155b:	75 e5                	jne    801542 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801574:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801578:	76 24                	jbe    80159e <memcpy+0x3c>
		while(n >= 8){
  80157a:	eb 1c                	jmp    801598 <memcpy+0x36>
			*d64 = *s64;
  80157c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157f:	8b 50 04             	mov    0x4(%eax),%edx
  801582:	8b 00                	mov    (%eax),%eax
  801584:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801587:	89 01                	mov    %eax,(%ecx)
  801589:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80158c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801590:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801594:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801598:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80159c:	77 de                	ja     80157c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80159e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a2:	74 31                	je     8015d5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015b0:	eb 16                	jmp    8015c8 <memcpy+0x66>
			*d8++ = *s8++;
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015c4:	8a 12                	mov    (%edx),%dl
  8015c6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	75 dd                	jne    8015b2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015f2:	73 50                	jae    801644 <memmove+0x6a>
  8015f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fa:	01 d0                	add    %edx,%eax
  8015fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ff:	76 43                	jbe    801644 <memmove+0x6a>
		s += n;
  801601:	8b 45 10             	mov    0x10(%ebp),%eax
  801604:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801607:	8b 45 10             	mov    0x10(%ebp),%eax
  80160a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80160d:	eb 10                	jmp    80161f <memmove+0x45>
			*--d = *--s;
  80160f:	ff 4d f8             	decl   -0x8(%ebp)
  801612:	ff 4d fc             	decl   -0x4(%ebp)
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8a 10                	mov    (%eax),%dl
  80161a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	8d 50 ff             	lea    -0x1(%eax),%edx
  801625:	89 55 10             	mov    %edx,0x10(%ebp)
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 e3                	jne    80160f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80162c:	eb 23                	jmp    801651 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80162e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801631:	8d 50 01             	lea    0x1(%eax),%edx
  801634:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80163d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801640:	8a 12                	mov    (%edx),%dl
  801642:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	8d 50 ff             	lea    -0x1(%eax),%edx
  80164a:	89 55 10             	mov    %edx,0x10(%ebp)
  80164d:	85 c0                	test   %eax,%eax
  80164f:	75 dd                	jne    80162e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801668:	eb 2a                	jmp    801694 <memcmp+0x3e>
		if (*s1 != *s2)
  80166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166d:	8a 10                	mov    (%eax),%dl
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	38 c2                	cmp    %al,%dl
  801676:	74 16                	je     80168e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	0f b6 d0             	movzbl %al,%edx
  801680:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	0f b6 c0             	movzbl %al,%eax
  801688:	29 c2                	sub    %eax,%edx
  80168a:	89 d0                	mov    %edx,%eax
  80168c:	eb 18                	jmp    8016a6 <memcmp+0x50>
		s1++, s2++;
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169a:	89 55 10             	mov    %edx,0x10(%ebp)
  80169d:	85 c0                	test   %eax,%eax
  80169f:	75 c9                	jne    80166a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	01 d0                	add    %edx,%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016b9:	eb 15                	jmp    8016d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f b6 d0             	movzbl %al,%edx
  8016c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c6:	0f b6 c0             	movzbl %al,%eax
  8016c9:	39 c2                	cmp    %eax,%edx
  8016cb:	74 0d                	je     8016da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016cd:	ff 45 08             	incl   0x8(%ebp)
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016d6:	72 e3                	jb     8016bb <memfind+0x13>
  8016d8:	eb 01                	jmp    8016db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016da:	90                   	nop
	return (void *) s;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f4:	eb 03                	jmp    8016f9 <strtol+0x19>
		s++;
  8016f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8a 00                	mov    (%eax),%al
  8016fe:	3c 20                	cmp    $0x20,%al
  801700:	74 f4                	je     8016f6 <strtol+0x16>
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 09                	cmp    $0x9,%al
  801709:	74 eb                	je     8016f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	3c 2b                	cmp    $0x2b,%al
  801712:	75 05                	jne    801719 <strtol+0x39>
		s++;
  801714:	ff 45 08             	incl   0x8(%ebp)
  801717:	eb 13                	jmp    80172c <strtol+0x4c>
	else if (*s == '-')
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3c 2d                	cmp    $0x2d,%al
  801720:	75 0a                	jne    80172c <strtol+0x4c>
		s++, neg = 1;
  801722:	ff 45 08             	incl   0x8(%ebp)
  801725:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	74 06                	je     801738 <strtol+0x58>
  801732:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801736:	75 20                	jne    801758 <strtol+0x78>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	3c 30                	cmp    $0x30,%al
  80173f:	75 17                	jne    801758 <strtol+0x78>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	40                   	inc    %eax
  801745:	8a 00                	mov    (%eax),%al
  801747:	3c 78                	cmp    $0x78,%al
  801749:	75 0d                	jne    801758 <strtol+0x78>
		s += 2, base = 16;
  80174b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80174f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801756:	eb 28                	jmp    801780 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801758:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80175c:	75 15                	jne    801773 <strtol+0x93>
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	3c 30                	cmp    $0x30,%al
  801765:	75 0c                	jne    801773 <strtol+0x93>
		s++, base = 8;
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801771:	eb 0d                	jmp    801780 <strtol+0xa0>
	else if (base == 0)
  801773:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801777:	75 07                	jne    801780 <strtol+0xa0>
		base = 10;
  801779:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3c 2f                	cmp    $0x2f,%al
  801787:	7e 19                	jle    8017a2 <strtol+0xc2>
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8a 00                	mov    (%eax),%al
  80178e:	3c 39                	cmp    $0x39,%al
  801790:	7f 10                	jg     8017a2 <strtol+0xc2>
			dig = *s - '0';
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f be c0             	movsbl %al,%eax
  80179a:	83 e8 30             	sub    $0x30,%eax
  80179d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017a0:	eb 42                	jmp    8017e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	3c 60                	cmp    $0x60,%al
  8017a9:	7e 19                	jle    8017c4 <strtol+0xe4>
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	3c 7a                	cmp    $0x7a,%al
  8017b2:	7f 10                	jg     8017c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	0f be c0             	movsbl %al,%eax
  8017bc:	83 e8 57             	sub    $0x57,%eax
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c2:	eb 20                	jmp    8017e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	3c 40                	cmp    $0x40,%al
  8017cb:	7e 39                	jle    801806 <strtol+0x126>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 5a                	cmp    $0x5a,%al
  8017d4:	7f 30                	jg     801806 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be c0             	movsbl %al,%eax
  8017de:	83 e8 37             	sub    $0x37,%eax
  8017e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017ea:	7d 19                	jge    801805 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017ec:	ff 45 08             	incl   0x8(%ebp)
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017f6:	89 c2                	mov    %eax,%edx
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	01 d0                	add    %edx,%eax
  8017fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801800:	e9 7b ff ff ff       	jmp    801780 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801805:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801806:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80180a:	74 08                	je     801814 <strtol+0x134>
		*endptr = (char *) s;
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	8b 55 08             	mov    0x8(%ebp),%edx
  801812:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801814:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801818:	74 07                	je     801821 <strtol+0x141>
  80181a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181d:	f7 d8                	neg    %eax
  80181f:	eb 03                	jmp    801824 <strtol+0x144>
  801821:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <ltostr>:

void
ltostr(long value, char *str)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80182c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801833:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80183a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80183e:	79 13                	jns    801853 <ltostr+0x2d>
	{
		neg = 1;
  801840:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80184d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801850:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80185b:	99                   	cltd   
  80185c:	f7 f9                	idiv   %ecx
  80185e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801861:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186f:	01 d0                	add    %edx,%eax
  801871:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801874:	83 c2 30             	add    $0x30,%edx
  801877:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801881:	f7 e9                	imul   %ecx
  801883:	c1 fa 02             	sar    $0x2,%edx
  801886:	89 c8                	mov    %ecx,%eax
  801888:	c1 f8 1f             	sar    $0x1f,%eax
  80188b:	29 c2                	sub    %eax,%edx
  80188d:	89 d0                	mov    %edx,%eax
  80188f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801892:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801896:	75 bb                	jne    801853 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a2:	48                   	dec    %eax
  8018a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018aa:	74 3d                	je     8018e9 <ltostr+0xc3>
		start = 1 ;
  8018ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018b3:	eb 34                	jmp    8018e9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 c2                	add    %eax,%edx
  8018ca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	01 c8                	add    %ecx,%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	01 c2                	add    %eax,%edx
  8018de:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018e1:	88 02                	mov    %al,(%edx)
		start++ ;
  8018e3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018ef:	7c c4                	jl     8018b5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	e8 c4 f9 ff ff       	call   8012d1 <strlen>
  80190d:	83 c4 04             	add    $0x4,%esp
  801910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	e8 b6 f9 ff ff       	call   8012d1 <strlen>
  80191b:	83 c4 04             	add    $0x4,%esp
  80191e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801921:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801928:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192f:	eb 17                	jmp    801948 <strcconcat+0x49>
		final[s] = str1[s] ;
  801931:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801934:	8b 45 10             	mov    0x10(%ebp),%eax
  801937:	01 c2                	add    %eax,%edx
  801939:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	01 c8                	add    %ecx,%eax
  801941:	8a 00                	mov    (%eax),%al
  801943:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801945:	ff 45 fc             	incl   -0x4(%ebp)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194e:	7c e1                	jl     801931 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801950:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801957:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195e:	eb 1f                	jmp    80197f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801963:	8d 50 01             	lea    0x1(%eax),%edx
  801966:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801969:	89 c2                	mov    %eax,%edx
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	01 c2                	add    %eax,%edx
  801970:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	01 c8                	add    %ecx,%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80197c:	ff 45 f8             	incl   -0x8(%ebp)
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801982:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801985:	7c d9                	jl     801960 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801987:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198a:	8b 45 10             	mov    0x10(%ebp),%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c6 00 00             	movb   $0x0,(%eax)
}
  801992:	90                   	nop
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801998:	8b 45 14             	mov    0x14(%ebp),%eax
  80199b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a4:	8b 00                	mov    (%eax),%eax
  8019a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b8:	eb 0c                	jmp    8019c6 <strsplit+0x31>
			*string++ = 0;
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8d 50 01             	lea    0x1(%eax),%edx
  8019c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8019c3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	84 c0                	test   %al,%al
  8019cd:	74 18                	je     8019e7 <strsplit+0x52>
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	50                   	push   %eax
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	e8 83 fa ff ff       	call   801463 <strchr>
  8019e0:	83 c4 08             	add    $0x8,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	75 d3                	jne    8019ba <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8a 00                	mov    (%eax),%al
  8019ec:	84 c0                	test   %al,%al
  8019ee:	74 5a                	je     801a4a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f3:	8b 00                	mov    (%eax),%eax
  8019f5:	83 f8 0f             	cmp    $0xf,%eax
  8019f8:	75 07                	jne    801a01 <strsplit+0x6c>
		{
			return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	eb 66                	jmp    801a67 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a01:	8b 45 14             	mov    0x14(%ebp),%eax
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	8d 48 01             	lea    0x1(%eax),%ecx
  801a09:	8b 55 14             	mov    0x14(%ebp),%edx
  801a0c:	89 0a                	mov    %ecx,(%edx)
  801a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a15:	8b 45 10             	mov    0x10(%ebp),%eax
  801a18:	01 c2                	add    %eax,%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1f:	eb 03                	jmp    801a24 <strsplit+0x8f>
			string++;
  801a21:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	84 c0                	test   %al,%al
  801a2b:	74 8b                	je     8019b8 <strsplit+0x23>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	0f be c0             	movsbl %al,%eax
  801a35:	50                   	push   %eax
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	e8 25 fa ff ff       	call   801463 <strchr>
  801a3e:	83 c4 08             	add    $0x8,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	74 dc                	je     801a21 <strsplit+0x8c>
			string++;
	}
  801a45:	e9 6e ff ff ff       	jmp    8019b8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a4a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4e:	8b 00                	mov    (%eax),%eax
  801a50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a57:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5a:	01 d0                	add    %edx,%eax
  801a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a62:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a7c:	eb 4a                	jmp    801ac8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	01 c2                	add    %eax,%edx
  801a86:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8c:	01 c8                	add    %ecx,%eax
  801a8e:	8a 00                	mov    (%eax),%al
  801a90:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a98:	01 d0                	add    %edx,%eax
  801a9a:	8a 00                	mov    (%eax),%al
  801a9c:	3c 40                	cmp    $0x40,%al
  801a9e:	7e 25                	jle    801ac5 <str2lower+0x5c>
  801aa0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa6:	01 d0                	add    %edx,%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	3c 5a                	cmp    $0x5a,%al
  801aac:	7f 17                	jg     801ac5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	01 d0                	add    %edx,%eax
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  801abc:	01 ca                	add    %ecx,%edx
  801abe:	8a 12                	mov    (%edx),%dl
  801ac0:	83 c2 20             	add    $0x20,%edx
  801ac3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ac5:	ff 45 fc             	incl   -0x4(%ebp)
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	e8 01 f8 ff ff       	call   8012d1 <strlen>
  801ad0:	83 c4 04             	add    $0x4,%esp
  801ad3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ad6:	7f a6                	jg     801a7e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ae3:	a1 08 40 80 00       	mov    0x804008,%eax
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	74 42                	je     801b2e <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	68 00 00 00 82       	push   $0x82000000
  801af4:	68 00 00 00 80       	push   $0x80000000
  801af9:	e8 00 08 00 00       	call   8022fe <initialize_dynamic_allocator>
  801afe:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b01:	e8 e7 05 00 00       	call   8020ed <sys_get_uheap_strategy>
  801b06:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b0b:	a1 40 40 80 00       	mov    0x804040,%eax
  801b10:	05 00 10 00 00       	add    $0x1000,%eax
  801b15:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b1a:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b1f:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b24:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b2b:	00 00 00 
	}
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	68 06 04 00 00       	push   $0x406
  801b4d:	50                   	push   %eax
  801b4e:	e8 e4 01 00 00       	call   801d37 <__sys_allocate_page>
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b5d:	79 14                	jns    801b73 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	68 88 37 80 00       	push   $0x803788
  801b67:	6a 1f                	push   $0x1f
  801b69:	68 c4 37 80 00       	push   $0x8037c4
  801b6e:	e8 b7 ed ff ff       	call   80092a <_panic>
	return 0;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b8e:	83 ec 0c             	sub    $0xc,%esp
  801b91:	50                   	push   %eax
  801b92:	e8 e7 01 00 00       	call   801d7e <__sys_unmap_frame>
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba1:	79 14                	jns    801bb7 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	68 d0 37 80 00       	push   $0x8037d0
  801bab:	6a 2a                	push   $0x2a
  801bad:	68 c4 37 80 00       	push   $0x8037c4
  801bb2:	e8 73 ed ff ff       	call   80092a <_panic>
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bc0:	e8 18 ff ff ff       	call   801add <uheap_init>
	if (size == 0) return NULL ;
  801bc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bc9:	75 07                	jne    801bd2 <malloc+0x18>
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd0:	eb 14                	jmp    801be6 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	68 10 38 80 00       	push   $0x803810
  801bda:	6a 3e                	push   $0x3e
  801bdc:	68 c4 37 80 00       	push   $0x8037c4
  801be1:	e8 44 ed ff ff       	call   80092a <_panic>
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	68 38 38 80 00       	push   $0x803838
  801bf6:	6a 49                	push   $0x49
  801bf8:	68 c4 37 80 00       	push   $0x8037c4
  801bfd:	e8 28 ed ff ff       	call   80092a <_panic>

00801c02 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 18             	sub    $0x18,%esp
  801c08:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c0e:	e8 ca fe ff ff       	call   801add <uheap_init>
	if (size == 0) return NULL ;
  801c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c17:	75 07                	jne    801c20 <smalloc+0x1e>
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1e:	eb 14                	jmp    801c34 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	68 5c 38 80 00       	push   $0x80385c
  801c28:	6a 5a                	push   $0x5a
  801c2a:	68 c4 37 80 00       	push   $0x8037c4
  801c2f:	e8 f6 ec ff ff       	call   80092a <_panic>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c3c:	e8 9c fe ff ff       	call   801add <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	68 84 38 80 00       	push   $0x803884
  801c49:	6a 6a                	push   $0x6a
  801c4b:	68 c4 37 80 00       	push   $0x8037c4
  801c50:	e8 d5 ec ff ff       	call   80092a <_panic>

00801c55 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5b:	e8 7d fe ff ff       	call   801add <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	68 a8 38 80 00       	push   $0x8038a8
  801c68:	68 88 00 00 00       	push   $0x88
  801c6d:	68 c4 37 80 00       	push   $0x8037c4
  801c72:	e8 b3 ec ff ff       	call   80092a <_panic>

00801c77 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	68 d0 38 80 00       	push   $0x8038d0
  801c85:	68 9b 00 00 00       	push   $0x9b
  801c8a:	68 c4 37 80 00       	push   $0x8037c4
  801c8f:	e8 96 ec ff ff       	call   80092a <_panic>

00801c94 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	57                   	push   %edi
  801c98:	56                   	push   %esi
  801c99:	53                   	push   %ebx
  801c9a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801caf:	cd 30                	int    $0x30
  801cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	5b                   	pop    %ebx
  801cbb:	5e                   	pop    %esi
  801cbc:	5f                   	pop    %edi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    

00801cbf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ccb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	51                   	push   %ecx
  801cd8:	52                   	push   %edx
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	50                   	push   %eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	e8 b0 ff ff ff       	call   801c94 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_cgetc>:

int
sys_cgetc(void)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 02                	push   $0x2
  801cf9:	e8 96 ff ff ff       	call   801c94 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 03                	push   $0x3
  801d12:	e8 7d ff ff ff       	call   801c94 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	90                   	nop
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 04                	push   $0x4
  801d2c:	e8 63 ff ff ff       	call   801c94 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	90                   	nop
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	6a 08                	push   $0x8
  801d4a:	e8 45 ff ff ff       	call   801c94 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	56                   	push   %esi
  801d58:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d59:	8b 75 18             	mov    0x18(%ebp),%esi
  801d5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	51                   	push   %ecx
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	6a 09                	push   $0x9
  801d6f:	e8 20 ff ff ff       	call   801c94 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5d                   	pop    %ebp
  801d7d:	c3                   	ret    

00801d7e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	6a 0a                	push   $0xa
  801d8e:	e8 01 ff ff ff       	call   801c94 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 0b                	push   $0xb
  801da9:	e8 e6 fe ff ff       	call   801c94 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 0c                	push   $0xc
  801dc2:	e8 cd fe ff ff       	call   801c94 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 0d                	push   $0xd
  801ddb:	e8 b4 fe ff ff       	call   801c94 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 0e                	push   $0xe
  801df4:	e8 9b fe ff ff       	call   801c94 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 0f                	push   $0xf
  801e0d:	e8 82 fe ff ff       	call   801c94 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	6a 10                	push   $0x10
  801e27:	e8 68 fe ff ff       	call   801c94 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 11                	push   $0x11
  801e40:	e8 4f fe ff ff       	call   801c94 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	90                   	nop
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_cputc>:

void
sys_cputc(const char c)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e57:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	50                   	push   %eax
  801e64:	6a 01                	push   $0x1
  801e66:	e8 29 fe ff ff       	call   801c94 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	90                   	nop
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 14                	push   $0x14
  801e80:	e8 0f fe ff ff       	call   801c94 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	90                   	nop
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	8b 45 10             	mov    0x10(%ebp),%eax
  801e94:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e97:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e9a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	51                   	push   %ecx
  801ea4:	52                   	push   %edx
  801ea5:	ff 75 0c             	pushl  0xc(%ebp)
  801ea8:	50                   	push   %eax
  801ea9:	6a 15                	push   $0x15
  801eab:	e8 e4 fd ff ff       	call   801c94 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	6a 16                	push   $0x16
  801ec8:	e8 c7 fd ff ff       	call   801c94 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ed5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	51                   	push   %ecx
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 17                	push   $0x17
  801ee7:	e8 a8 fd ff ff       	call   801c94 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	6a 18                	push   $0x18
  801f04:	e8 8b fd ff ff       	call   801c94 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 14             	pushl  0x14(%ebp)
  801f19:	ff 75 10             	pushl  0x10(%ebp)
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	50                   	push   %eax
  801f20:	6a 19                	push   $0x19
  801f22:	e8 6d fd ff ff       	call   801c94 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	50                   	push   %eax
  801f3b:	6a 1a                	push   $0x1a
  801f3d:	e8 52 fd ff ff       	call   801c94 <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	90                   	nop
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	50                   	push   %eax
  801f57:	6a 1b                	push   $0x1b
  801f59:	e8 36 fd ff ff       	call   801c94 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 05                	push   $0x5
  801f72:	e8 1d fd ff ff       	call   801c94 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 06                	push   $0x6
  801f8b:	e8 04 fd ff ff       	call   801c94 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 07                	push   $0x7
  801fa4:	e8 eb fc ff ff       	call   801c94 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_exit_env>:


void sys_exit_env(void)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 1c                	push   $0x1c
  801fbd:	e8 d2 fc ff ff       	call   801c94 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	90                   	nop
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd1:	8d 50 04             	lea    0x4(%eax),%edx
  801fd4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	52                   	push   %edx
  801fde:	50                   	push   %eax
  801fdf:	6a 1d                	push   $0x1d
  801fe1:	e8 ae fc ff ff       	call   801c94 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
	return result;
  801fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff2:	89 01                	mov    %eax,(%ecx)
  801ff4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	c9                   	leave  
  801ffb:	c2 04 00             	ret    $0x4

00801ffe <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	ff 75 10             	pushl  0x10(%ebp)
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 13                	push   $0x13
  802010:	e8 7f fc ff ff       	call   801c94 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_rcr2>:
uint32 sys_rcr2()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 1e                	push   $0x1e
  80202a:	e8 65 fc ff ff       	call   801c94 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802040:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	50                   	push   %eax
  80204d:	6a 1f                	push   $0x1f
  80204f:	e8 40 fc ff ff       	call   801c94 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
	return ;
  802057:	90                   	nop
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <rsttst>:
void rsttst()
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 21                	push   $0x21
  802069:	e8 26 fc ff ff       	call   801c94 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
	return ;
  802071:	90                   	nop
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	8b 45 14             	mov    0x14(%ebp),%eax
  80207d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802080:	8b 55 18             	mov    0x18(%ebp),%edx
  802083:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	ff 75 10             	pushl  0x10(%ebp)
  80208c:	ff 75 0c             	pushl  0xc(%ebp)
  80208f:	ff 75 08             	pushl  0x8(%ebp)
  802092:	6a 20                	push   $0x20
  802094:	e8 fb fb ff ff       	call   801c94 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
	return ;
  80209c:	90                   	nop
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <chktst>:
void chktst(uint32 n)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	ff 75 08             	pushl  0x8(%ebp)
  8020ad:	6a 22                	push   $0x22
  8020af:	e8 e0 fb ff ff       	call   801c94 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b7:	90                   	nop
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <inctst>:

void inctst()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 23                	push   $0x23
  8020c9:	e8 c6 fb ff ff       	call   801c94 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d1:	90                   	nop
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <gettst>:
uint32 gettst()
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 24                	push   $0x24
  8020e3:	e8 ac fb ff ff       	call   801c94 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 25                	push   $0x25
  8020fc:	e8 93 fb ff ff       	call   801c94 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
  802104:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802109:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	ff 75 08             	pushl  0x8(%ebp)
  802126:	6a 26                	push   $0x26
  802128:	e8 67 fb ff ff       	call   801c94 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
	return ;
  802130:	90                   	nop
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802137:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	53                   	push   %ebx
  802146:	51                   	push   %ecx
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 27                	push   $0x27
  80214b:	e8 44 fb ff ff       	call   801c94 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80215b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	52                   	push   %edx
  802168:	50                   	push   %eax
  802169:	6a 28                	push   $0x28
  80216b:	e8 24 fb ff ff       	call   801c94 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802178:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80217b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	6a 00                	push   $0x0
  802183:	51                   	push   %ecx
  802184:	ff 75 10             	pushl  0x10(%ebp)
  802187:	52                   	push   %edx
  802188:	50                   	push   %eax
  802189:	6a 29                	push   $0x29
  80218b:	e8 04 fb ff ff       	call   801c94 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	ff 75 10             	pushl  0x10(%ebp)
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	ff 75 08             	pushl  0x8(%ebp)
  8021a5:	6a 12                	push   $0x12
  8021a7:	e8 e8 fa ff ff       	call   801c94 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 2a                	push   $0x2a
  8021c5:	e8 ca fa ff ff       	call   801c94 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 2b                	push   $0x2b
  8021df:	e8 b0 fa ff ff       	call   801c94 <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	ff 75 0c             	pushl  0xc(%ebp)
  8021f5:	ff 75 08             	pushl  0x8(%ebp)
  8021f8:	6a 2d                	push   $0x2d
  8021fa:	e8 95 fa ff ff       	call   801c94 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
	return;
  802202:	90                   	nop
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 0c             	pushl  0xc(%ebp)
  802211:	ff 75 08             	pushl  0x8(%ebp)
  802214:	6a 2c                	push   $0x2c
  802216:	e8 79 fa ff ff       	call   801c94 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
	return ;
  80221e:	90                   	nop
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	68 f4 38 80 00       	push   $0x8038f4
  80222f:	68 25 01 00 00       	push   $0x125
  802234:	68 27 39 80 00       	push   $0x803927
  802239:	e8 ec e6 ff ff       	call   80092a <_panic>

0080223e <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802244:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  80224b:	72 09                	jb     802256 <to_page_va+0x18>
  80224d:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  802254:	72 14                	jb     80226a <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 38 39 80 00       	push   $0x803938
  80225e:	6a 15                	push   $0x15
  802260:	68 63 39 80 00       	push   $0x803963
  802265:	e8 c0 e6 ff ff       	call   80092a <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	ba 60 40 80 00       	mov    $0x804060,%edx
  802272:	29 d0                	sub    %edx,%eax
  802274:	c1 f8 02             	sar    $0x2,%eax
  802277:	89 c2                	mov    %eax,%edx
  802279:	89 d0                	mov    %edx,%eax
  80227b:	c1 e0 02             	shl    $0x2,%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	c1 e0 02             	shl    $0x2,%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	c1 e0 02             	shl    $0x2,%eax
  802288:	01 d0                	add    %edx,%eax
  80228a:	89 c1                	mov    %eax,%ecx
  80228c:	c1 e1 08             	shl    $0x8,%ecx
  80228f:	01 c8                	add    %ecx,%eax
  802291:	89 c1                	mov    %eax,%ecx
  802293:	c1 e1 10             	shl    $0x10,%ecx
  802296:	01 c8                	add    %ecx,%eax
  802298:	01 c0                	add    %eax,%eax
  80229a:	01 d0                	add    %edx,%eax
  80229c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	c1 e0 0c             	shl    $0xc,%eax
  8022a5:	89 c2                	mov    %eax,%edx
  8022a7:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022ac:	01 d0                	add    %edx,%eax
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8022b6:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	29 c2                	sub    %eax,%edx
  8022c0:	89 d0                	mov    %edx,%eax
  8022c2:	c1 e8 0c             	shr    $0xc,%eax
  8022c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8022c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cc:	78 09                	js     8022d7 <to_page_info+0x27>
  8022ce:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8022d5:	7e 14                	jle    8022eb <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 7c 39 80 00       	push   $0x80397c
  8022df:	6a 22                	push   $0x22
  8022e1:	68 63 39 80 00       	push   $0x803963
  8022e6:	e8 3f e6 ff ff       	call   80092a <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8022eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ee:	89 d0                	mov    %edx,%eax
  8022f0:	01 c0                	add    %eax,%eax
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	c1 e0 02             	shl    $0x2,%eax
  8022f7:	05 60 40 80 00       	add    $0x804060,%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	05 00 00 00 02       	add    $0x2000000,%eax
  80230c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80230f:	73 16                	jae    802327 <initialize_dynamic_allocator+0x29>
  802311:	68 a0 39 80 00       	push   $0x8039a0
  802316:	68 c6 39 80 00       	push   $0x8039c6
  80231b:	6a 34                	push   $0x34
  80231d:	68 63 39 80 00       	push   $0x803963
  802322:	e8 03 e6 ff ff       	call   80092a <_panic>
		is_initialized = 1;
  802327:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80232e:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233c:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802341:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802348:	00 00 00 
  80234b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802352:	00 00 00 
  802355:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  80235c:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80235f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802362:	2b 45 08             	sub    0x8(%ebp),%eax
  802365:	c1 e8 0c             	shr    $0xc,%eax
  802368:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80236b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802372:	e9 c8 00 00 00       	jmp    80243f <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	01 c0                	add    %eax,%eax
  80237e:	01 d0                	add    %edx,%eax
  802380:	c1 e0 02             	shl    $0x2,%eax
  802383:	05 68 40 80 00       	add    $0x804068,%eax
  802388:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80238d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802390:	89 d0                	mov    %edx,%eax
  802392:	01 c0                	add    %eax,%eax
  802394:	01 d0                	add    %edx,%eax
  802396:	c1 e0 02             	shl    $0x2,%eax
  802399:	05 6a 40 80 00       	add    $0x80406a,%eax
  80239e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8023a3:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023a9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023ac:	89 c8                	mov    %ecx,%eax
  8023ae:	01 c0                	add    %eax,%eax
  8023b0:	01 c8                	add    %ecx,%eax
  8023b2:	c1 e0 02             	shl    $0x2,%eax
  8023b5:	05 64 40 80 00       	add    $0x804064,%eax
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bf:	89 d0                	mov    %edx,%eax
  8023c1:	01 c0                	add    %eax,%eax
  8023c3:	01 d0                	add    %edx,%eax
  8023c5:	c1 e0 02             	shl    $0x2,%eax
  8023c8:	05 64 40 80 00       	add    $0x804064,%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 1b                	je     8023ee <initialize_dynamic_allocator+0xf0>
  8023d3:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023dc:	89 c8                	mov    %ecx,%eax
  8023de:	01 c0                	add    %eax,%eax
  8023e0:	01 c8                	add    %ecx,%eax
  8023e2:	c1 e0 02             	shl    $0x2,%eax
  8023e5:	05 60 40 80 00       	add    $0x804060,%eax
  8023ea:	89 02                	mov    %eax,(%edx)
  8023ec:	eb 16                	jmp    802404 <initialize_dynamic_allocator+0x106>
  8023ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f1:	89 d0                	mov    %edx,%eax
  8023f3:	01 c0                	add    %eax,%eax
  8023f5:	01 d0                	add    %edx,%eax
  8023f7:	c1 e0 02             	shl    $0x2,%eax
  8023fa:	05 60 40 80 00       	add    $0x804060,%eax
  8023ff:	a3 48 40 80 00       	mov    %eax,0x804048
  802404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802407:	89 d0                	mov    %edx,%eax
  802409:	01 c0                	add    %eax,%eax
  80240b:	01 d0                	add    %edx,%eax
  80240d:	c1 e0 02             	shl    $0x2,%eax
  802410:	05 60 40 80 00       	add    $0x804060,%eax
  802415:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	89 d0                	mov    %edx,%eax
  80241f:	01 c0                	add    %eax,%eax
  802421:	01 d0                	add    %edx,%eax
  802423:	c1 e0 02             	shl    $0x2,%eax
  802426:	05 60 40 80 00       	add    $0x804060,%eax
  80242b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802431:	a1 54 40 80 00       	mov    0x804054,%eax
  802436:	40                   	inc    %eax
  802437:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80243c:	ff 45 f4             	incl   -0xc(%ebp)
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802445:	0f 8c 2c ff ff ff    	jl     802377 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80244b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802452:	eb 36                	jmp    80248a <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	c1 e0 04             	shl    $0x4,%eax
  80245a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80245f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	c1 e0 04             	shl    $0x4,%eax
  80246b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	c1 e0 04             	shl    $0x4,%eax
  80247c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802487:	ff 45 f0             	incl   -0x10(%ebp)
  80248a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80248e:	7e c4                	jle    802454 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802490:	90                   	nop
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	50                   	push   %eax
  8024a0:	e8 0b fe ff ff       	call   8022b0 <to_page_info>
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 08             	mov    0x8(%eax),%eax
  8024b1:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	ff 75 0c             	pushl  0xc(%ebp)
  8024c2:	e8 77 fd ff ff       	call   80223e <to_page_va>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8024cd:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d7:	f7 75 08             	divl   0x8(%ebp)
  8024da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8024dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e0:	83 ec 0c             	sub    $0xc,%esp
  8024e3:	50                   	push   %eax
  8024e4:	e8 48 f6 ff ff       	call   801b31 <get_page>
  8024e9:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f2:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802500:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802507:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80250e:	eb 19                	jmp    802529 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802513:	ba 01 00 00 00       	mov    $0x1,%edx
  802518:	88 c1                	mov    %al,%cl
  80251a:	d3 e2                	shl    %cl,%edx
  80251c:	89 d0                	mov    %edx,%eax
  80251e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802521:	74 0e                	je     802531 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802523:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802526:	ff 45 f0             	incl   -0x10(%ebp)
  802529:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80252d:	7e e1                	jle    802510 <split_page_to_blocks+0x5a>
  80252f:	eb 01                	jmp    802532 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802531:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802532:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802539:	e9 a7 00 00 00       	jmp    8025e5 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	0f af 45 08          	imul   0x8(%ebp),%eax
  802545:	89 c2                	mov    %eax,%edx
  802547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254a:	01 d0                	add    %edx,%eax
  80254c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80254f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802553:	75 14                	jne    802569 <split_page_to_blocks+0xb3>
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 dc 39 80 00       	push   $0x8039dc
  80255d:	6a 7c                	push   $0x7c
  80255f:	68 63 39 80 00       	push   $0x803963
  802564:	e8 c1 e3 ff ff       	call   80092a <_panic>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c1 e0 04             	shl    $0x4,%eax
  80256f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802574:	8b 10                	mov    (%eax),%edx
  802576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802579:	89 50 04             	mov    %edx,0x4(%eax)
  80257c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	74 14                	je     80259a <split_page_to_blocks+0xe4>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	c1 e0 04             	shl    $0x4,%eax
  80258c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 11                	jmp    8025ab <split_page_to_blocks+0xf5>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	c1 e0 04             	shl    $0x4,%eax
  8025a0:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8025a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a9:	89 02                	mov    %eax,(%edx)
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	c1 e0 04             	shl    $0x4,%eax
  8025b1:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	89 02                	mov    %eax,(%edx)
  8025bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	c1 e0 04             	shl    $0x4,%eax
  8025cb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8d 50 01             	lea    0x1(%eax),%edx
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c1 e0 04             	shl    $0x4,%eax
  8025db:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025e0:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8025e2:	ff 45 ec             	incl   -0x14(%ebp)
  8025e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8025eb:	0f 82 4d ff ff ff    	jb     80253e <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8025f1:	90                   	nop
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8025fa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802601:	76 19                	jbe    80261c <alloc_block+0x28>
  802603:	68 00 3a 80 00       	push   $0x803a00
  802608:	68 c6 39 80 00       	push   $0x8039c6
  80260d:	68 8a 00 00 00       	push   $0x8a
  802612:	68 63 39 80 00       	push   $0x803963
  802617:	e8 0e e3 ff ff       	call   80092a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80261c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802623:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80262a:	eb 19                	jmp    802645 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80262c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262f:	ba 01 00 00 00       	mov    $0x1,%edx
  802634:	88 c1                	mov    %al,%cl
  802636:	d3 e2                	shl    %cl,%edx
  802638:	89 d0                	mov    %edx,%eax
  80263a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263d:	73 0e                	jae    80264d <alloc_block+0x59>
		idx++;
  80263f:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802642:	ff 45 f0             	incl   -0x10(%ebp)
  802645:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802649:	7e e1                	jle    80262c <alloc_block+0x38>
  80264b:	eb 01                	jmp    80264e <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80264d:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c1 e0 04             	shl    $0x4,%eax
  802654:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	0f 84 df 00 00 00    	je     802742 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	c1 e0 04             	shl    $0x4,%eax
  802669:	05 80 c0 81 00       	add    $0x81c080,%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802673:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802677:	75 17                	jne    802690 <alloc_block+0x9c>
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	68 21 3a 80 00       	push   $0x803a21
  802681:	68 9e 00 00 00       	push   $0x9e
  802686:	68 63 39 80 00       	push   $0x803963
  80268b:	e8 9a e2 ff ff       	call   80092a <_panic>
  802690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 10                	je     8026a9 <alloc_block+0xb5>
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a1:	8b 52 04             	mov    0x4(%edx),%edx
  8026a4:	89 50 04             	mov    %edx,0x4(%eax)
  8026a7:	eb 14                	jmp    8026bd <alloc_block+0xc9>
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b2:	c1 e2 04             	shl    $0x4,%edx
  8026b5:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026bb:	89 02                	mov    %eax,(%edx)
  8026bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0f                	je     8026d6 <alloc_block+0xe2>
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d0:	8b 12                	mov    (%edx),%edx
  8026d2:	89 10                	mov    %edx,(%eax)
  8026d4:	eb 13                	jmp    8026e9 <alloc_block+0xf5>
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	c1 e2 04             	shl    $0x4,%edx
  8026e1:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8026e7:	89 02                	mov    %eax,(%edx)
  8026e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	c1 e0 04             	shl    $0x4,%eax
  802702:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8d 50 ff             	lea    -0x1(%eax),%edx
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c1 e0 04             	shl    $0x4,%eax
  802712:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802717:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	50                   	push   %eax
  802720:	e8 8b fb ff ff       	call   8022b0 <to_page_info>
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802732:	48                   	dec    %eax
  802733:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802736:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	e9 bc 02 00 00       	jmp    8029fe <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802742:	a1 54 40 80 00       	mov    0x804054,%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	0f 84 7d 02 00 00    	je     8029cc <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80274f:	a1 48 40 80 00       	mov    0x804048,%eax
  802754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80275b:	75 17                	jne    802774 <alloc_block+0x180>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 21 3a 80 00       	push   $0x803a21
  802765:	68 a9 00 00 00       	push   $0xa9
  80276a:	68 63 39 80 00       	push   $0x803963
  80276f:	e8 b6 e1 ff ff       	call   80092a <_panic>
  802774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 10                	je     80278d <alloc_block+0x199>
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802785:	8b 52 04             	mov    0x4(%edx),%edx
  802788:	89 50 04             	mov    %edx,0x4(%eax)
  80278b:	eb 0b                	jmp    802798 <alloc_block+0x1a4>
  80278d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0f                	je     8027b1 <alloc_block+0x1bd>
  8027a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ab:	8b 12                	mov    (%edx),%edx
  8027ad:	89 10                	mov    %edx,(%eax)
  8027af:	eb 0a                	jmp    8027bb <alloc_block+0x1c7>
  8027b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	a3 48 40 80 00       	mov    %eax,0x804048
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ce:	a1 54 40 80 00       	mov    0x804054,%eax
  8027d3:	48                   	dec    %eax
  8027d4:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	83 c0 03             	add    $0x3,%eax
  8027df:	ba 01 00 00 00       	mov    $0x1,%edx
  8027e4:	88 c1                	mov    %al,%cl
  8027e6:	d3 e2                	shl    %cl,%edx
  8027e8:	89 d0                	mov    %edx,%eax
  8027ea:	83 ec 08             	sub    $0x8,%esp
  8027ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027f0:	50                   	push   %eax
  8027f1:	e8 c0 fc ff ff       	call   8024b6 <split_page_to_blocks>
  8027f6:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	c1 e0 04             	shl    $0x4,%eax
  8027ff:	05 80 c0 81 00       	add    $0x81c080,%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802809:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80280d:	75 17                	jne    802826 <alloc_block+0x232>
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 21 3a 80 00       	push   $0x803a21
  802817:	68 b0 00 00 00       	push   $0xb0
  80281c:	68 63 39 80 00       	push   $0x803963
  802821:	e8 04 e1 ff ff       	call   80092a <_panic>
  802826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 10                	je     80283f <alloc_block+0x24b>
  80282f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802837:	8b 52 04             	mov    0x4(%edx),%edx
  80283a:	89 50 04             	mov    %edx,0x4(%eax)
  80283d:	eb 14                	jmp    802853 <alloc_block+0x25f>
  80283f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802848:	c1 e2 04             	shl    $0x4,%edx
  80284b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802851:	89 02                	mov    %eax,(%edx)
  802853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	74 0f                	je     80286c <alloc_block+0x278>
  80285d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802866:	8b 12                	mov    (%edx),%edx
  802868:	89 10                	mov    %edx,(%eax)
  80286a:	eb 13                	jmp    80287f <alloc_block+0x28b>
  80286c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802874:	c1 e2 04             	shl    $0x4,%edx
  802877:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80287d:	89 02                	mov    %eax,(%edx)
  80287f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802882:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	c1 e0 04             	shl    $0x4,%eax
  802898:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	c1 e0 04             	shl    $0x4,%eax
  8028a8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028ad:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8028af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b2:	83 ec 0c             	sub    $0xc,%esp
  8028b5:	50                   	push   %eax
  8028b6:	e8 f5 f9 ff ff       	call   8022b0 <to_page_info>
  8028bb:	83 c4 10             	add    $0x10,%esp
  8028be:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8028c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8028c8:	48                   	dec    %eax
  8028c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028cc:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	e9 26 01 00 00       	jmp    8029fe <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8028d8:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	c1 e0 04             	shl    $0x4,%eax
  8028e1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	0f 84 dc 00 00 00    	je     8029cc <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	c1 e0 04             	shl    $0x4,%eax
  8028f6:	05 80 c0 81 00       	add    $0x81c080,%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802900:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802904:	75 17                	jne    80291d <alloc_block+0x329>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 21 3a 80 00       	push   $0x803a21
  80290e:	68 be 00 00 00       	push   $0xbe
  802913:	68 63 39 80 00       	push   $0x803963
  802918:	e8 0d e0 ff ff       	call   80092a <_panic>
  80291d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 10                	je     802936 <alloc_block+0x342>
  802926:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80292e:	8b 52 04             	mov    0x4(%edx),%edx
  802931:	89 50 04             	mov    %edx,0x4(%eax)
  802934:	eb 14                	jmp    80294a <alloc_block+0x356>
  802936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	c1 e2 04             	shl    $0x4,%edx
  802942:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802948:	89 02                	mov    %eax,(%edx)
  80294a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 0f                	je     802963 <alloc_block+0x36f>
  802954:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80295d:	8b 12                	mov    (%edx),%edx
  80295f:	89 10                	mov    %edx,(%eax)
  802961:	eb 13                	jmp    802976 <alloc_block+0x382>
  802963:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296b:	c1 e2 04             	shl    $0x4,%edx
  80296e:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802974:	89 02                	mov    %eax,(%edx)
  802976:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802979:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802982:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	c1 e0 04             	shl    $0x4,%eax
  80298f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	8d 50 ff             	lea    -0x1(%eax),%edx
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	c1 e0 04             	shl    $0x4,%eax
  80299f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029a4:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029a9:	83 ec 0c             	sub    $0xc,%esp
  8029ac:	50                   	push   %eax
  8029ad:	e8 fe f8 ff ff       	call   8022b0 <to_page_info>
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8029b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029bb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029bf:	48                   	dec    %eax
  8029c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029c3:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8029c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ca:	eb 32                	jmp    8029fe <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8029cc:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8029d0:	77 15                	ja     8029e7 <alloc_block+0x3f3>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	c1 e0 04             	shl    $0x4,%eax
  8029d8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	0f 84 f1 fe ff ff    	je     8028d8 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8029e7:	83 ec 04             	sub    $0x4,%esp
  8029ea:	68 3f 3a 80 00       	push   $0x803a3f
  8029ef:	68 c8 00 00 00       	push   $0xc8
  8029f4:	68 63 39 80 00       	push   $0x803963
  8029f9:	e8 2c df ff ff       	call   80092a <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802a06:	8b 55 08             	mov    0x8(%ebp),%edx
  802a09:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802a0e:	39 c2                	cmp    %eax,%edx
  802a10:	72 0c                	jb     802a1e <free_block+0x1e>
  802a12:	8b 55 08             	mov    0x8(%ebp),%edx
  802a15:	a1 40 40 80 00       	mov    0x804040,%eax
  802a1a:	39 c2                	cmp    %eax,%edx
  802a1c:	72 19                	jb     802a37 <free_block+0x37>
  802a1e:	68 50 3a 80 00       	push   $0x803a50
  802a23:	68 c6 39 80 00       	push   $0x8039c6
  802a28:	68 d7 00 00 00       	push   $0xd7
  802a2d:	68 63 39 80 00       	push   $0x803963
  802a32:	e8 f3 de ff ff       	call   80092a <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	83 ec 0c             	sub    $0xc,%esp
  802a43:	50                   	push   %eax
  802a44:	e8 67 f8 ff ff       	call   8022b0 <to_page_info>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a52:	8b 40 08             	mov    0x8(%eax),%eax
  802a55:	0f b7 c0             	movzwl %ax,%eax
  802a58:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802a5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a62:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802a69:	eb 19                	jmp    802a84 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	ba 01 00 00 00       	mov    $0x1,%edx
  802a73:	88 c1                	mov    %al,%cl
  802a75:	d3 e2                	shl    %cl,%edx
  802a77:	89 d0                	mov    %edx,%eax
  802a79:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802a7c:	74 0e                	je     802a8c <free_block+0x8c>
	        break;
	    idx++;
  802a7e:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a81:	ff 45 f0             	incl   -0x10(%ebp)
  802a84:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802a88:	7e e1                	jle    802a6b <free_block+0x6b>
  802a8a:	eb 01                	jmp    802a8d <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802a8c:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802a94:	40                   	inc    %eax
  802a95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a98:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa0:	75 17                	jne    802ab9 <free_block+0xb9>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 dc 39 80 00       	push   $0x8039dc
  802aaa:	68 ee 00 00 00       	push   $0xee
  802aaf:	68 63 39 80 00       	push   $0x803963
  802ab4:	e8 71 de ff ff       	call   80092a <_panic>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	c1 e0 04             	shl    $0x4,%eax
  802abf:	05 84 c0 81 00       	add    $0x81c084,%eax
  802ac4:	8b 10                	mov    (%eax),%edx
  802ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac9:	89 50 04             	mov    %edx,0x4(%eax)
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 14                	je     802aea <free_block+0xea>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	c1 e0 04             	shl    $0x4,%eax
  802adc:	05 84 c0 81 00       	add    $0x81c084,%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	eb 11                	jmp    802afb <free_block+0xfb>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	c1 e0 04             	shl    $0x4,%eax
  802af0:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	89 02                	mov    %eax,(%edx)
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	c1 e0 04             	shl    $0x4,%eax
  802b01:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0a:	89 02                	mov    %eax,(%edx)
  802b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	c1 e0 04             	shl    $0x4,%eax
  802b1b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8d 50 01             	lea    0x1(%eax),%edx
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	c1 e0 04             	shl    $0x4,%eax
  802b2b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b30:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802b32:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b37:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3c:	f7 75 e0             	divl   -0x20(%ebp)
  802b3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b45:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b49:	0f b7 c0             	movzwl %ax,%eax
  802b4c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b4f:	0f 85 70 01 00 00    	jne    802cc5 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b5b:	e8 de f6 ff ff       	call   80223e <to_page_va>
  802b60:	83 c4 10             	add    $0x10,%esp
  802b63:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802b66:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b6d:	e9 b7 00 00 00       	jmp    802c29 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802b72:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802b7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b81:	75 17                	jne    802b9a <free_block+0x19a>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 21 3a 80 00       	push   $0x803a21
  802b8b:	68 f8 00 00 00       	push   $0xf8
  802b90:	68 63 39 80 00       	push   $0x803963
  802b95:	e8 90 dd ff ff       	call   80092a <_panic>
  802b9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 10                	je     802bb3 <free_block+0x1b3>
  802ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bab:	8b 52 04             	mov    0x4(%edx),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	eb 14                	jmp    802bc7 <free_block+0x1c7>
  802bb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbc:	c1 e2 04             	shl    $0x4,%edx
  802bbf:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802bc5:	89 02                	mov    %eax,(%edx)
  802bc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 0f                	je     802be0 <free_block+0x1e0>
  802bd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bda:	8b 12                	mov    (%edx),%edx
  802bdc:	89 10                	mov    %edx,(%eax)
  802bde:	eb 13                	jmp    802bf3 <free_block+0x1f3>
  802be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be8:	c1 e2 04             	shl    $0x4,%edx
  802beb:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802bf1:	89 02                	mov    %eax,(%edx)
  802bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	c1 e0 04             	shl    $0x4,%eax
  802c0c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	c1 e0 04             	shl    $0x4,%eax
  802c1c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c21:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c26:	01 45 ec             	add    %eax,-0x14(%ebp)
  802c29:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c30:	0f 86 3c ff ff ff    	jbe    802b72 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c39:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c42:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802c48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c4c:	75 17                	jne    802c65 <free_block+0x265>
  802c4e:	83 ec 04             	sub    $0x4,%esp
  802c51:	68 dc 39 80 00       	push   $0x8039dc
  802c56:	68 fe 00 00 00       	push   $0xfe
  802c5b:	68 63 39 80 00       	push   $0x803963
  802c60:	e8 c5 dc ff ff       	call   80092a <_panic>
  802c65:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	89 50 04             	mov    %edx,0x4(%eax)
  802c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c74:	8b 40 04             	mov    0x4(%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 0c                	je     802c87 <free_block+0x287>
  802c7b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802c80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c83:	89 10                	mov    %edx,(%eax)
  802c85:	eb 08                	jmp    802c8f <free_block+0x28f>
  802c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8a:	a3 48 40 80 00       	mov    %eax,0x804048
  802c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c92:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca0:	a1 54 40 80 00       	mov    0x804054,%eax
  802ca5:	40                   	inc    %eax
  802ca6:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802cab:	83 ec 0c             	sub    $0xc,%esp
  802cae:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cb1:	e8 88 f5 ff ff       	call   80223e <to_page_va>
  802cb6:	83 c4 10             	add    $0x10,%esp
  802cb9:	83 ec 0c             	sub    $0xc,%esp
  802cbc:	50                   	push   %eax
  802cbd:	e8 b8 ee ff ff       	call   801b7a <return_page>
  802cc2:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802cc5:	90                   	nop
  802cc6:	c9                   	leave  
  802cc7:	c3                   	ret    

00802cc8 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802cc8:	55                   	push   %ebp
  802cc9:	89 e5                	mov    %esp,%ebp
  802ccb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 88 3a 80 00       	push   $0x803a88
  802cd6:	68 11 01 00 00       	push   $0x111
  802cdb:	68 63 39 80 00       	push   $0x803963
  802ce0:	e8 45 dc ff ff       	call   80092a <_panic>
  802ce5:	66 90                	xchg   %ax,%ax
  802ce7:	90                   	nop

00802ce8 <__udivdi3>:
  802ce8:	55                   	push   %ebp
  802ce9:	57                   	push   %edi
  802cea:	56                   	push   %esi
  802ceb:	53                   	push   %ebx
  802cec:	83 ec 1c             	sub    $0x1c,%esp
  802cef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802cf3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802cf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802cfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802cff:	89 ca                	mov    %ecx,%edx
  802d01:	89 f8                	mov    %edi,%eax
  802d03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d07:	85 f6                	test   %esi,%esi
  802d09:	75 2d                	jne    802d38 <__udivdi3+0x50>
  802d0b:	39 cf                	cmp    %ecx,%edi
  802d0d:	77 65                	ja     802d74 <__udivdi3+0x8c>
  802d0f:	89 fd                	mov    %edi,%ebp
  802d11:	85 ff                	test   %edi,%edi
  802d13:	75 0b                	jne    802d20 <__udivdi3+0x38>
  802d15:	b8 01 00 00 00       	mov    $0x1,%eax
  802d1a:	31 d2                	xor    %edx,%edx
  802d1c:	f7 f7                	div    %edi
  802d1e:	89 c5                	mov    %eax,%ebp
  802d20:	31 d2                	xor    %edx,%edx
  802d22:	89 c8                	mov    %ecx,%eax
  802d24:	f7 f5                	div    %ebp
  802d26:	89 c1                	mov    %eax,%ecx
  802d28:	89 d8                	mov    %ebx,%eax
  802d2a:	f7 f5                	div    %ebp
  802d2c:	89 cf                	mov    %ecx,%edi
  802d2e:	89 fa                	mov    %edi,%edx
  802d30:	83 c4 1c             	add    $0x1c,%esp
  802d33:	5b                   	pop    %ebx
  802d34:	5e                   	pop    %esi
  802d35:	5f                   	pop    %edi
  802d36:	5d                   	pop    %ebp
  802d37:	c3                   	ret    
  802d38:	39 ce                	cmp    %ecx,%esi
  802d3a:	77 28                	ja     802d64 <__udivdi3+0x7c>
  802d3c:	0f bd fe             	bsr    %esi,%edi
  802d3f:	83 f7 1f             	xor    $0x1f,%edi
  802d42:	75 40                	jne    802d84 <__udivdi3+0x9c>
  802d44:	39 ce                	cmp    %ecx,%esi
  802d46:	72 0a                	jb     802d52 <__udivdi3+0x6a>
  802d48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802d4c:	0f 87 9e 00 00 00    	ja     802df0 <__udivdi3+0x108>
  802d52:	b8 01 00 00 00       	mov    $0x1,%eax
  802d57:	89 fa                	mov    %edi,%edx
  802d59:	83 c4 1c             	add    $0x1c,%esp
  802d5c:	5b                   	pop    %ebx
  802d5d:	5e                   	pop    %esi
  802d5e:	5f                   	pop    %edi
  802d5f:	5d                   	pop    %ebp
  802d60:	c3                   	ret    
  802d61:	8d 76 00             	lea    0x0(%esi),%esi
  802d64:	31 ff                	xor    %edi,%edi
  802d66:	31 c0                	xor    %eax,%eax
  802d68:	89 fa                	mov    %edi,%edx
  802d6a:	83 c4 1c             	add    $0x1c,%esp
  802d6d:	5b                   	pop    %ebx
  802d6e:	5e                   	pop    %esi
  802d6f:	5f                   	pop    %edi
  802d70:	5d                   	pop    %ebp
  802d71:	c3                   	ret    
  802d72:	66 90                	xchg   %ax,%ax
  802d74:	89 d8                	mov    %ebx,%eax
  802d76:	f7 f7                	div    %edi
  802d78:	31 ff                	xor    %edi,%edi
  802d7a:	89 fa                	mov    %edi,%edx
  802d7c:	83 c4 1c             	add    $0x1c,%esp
  802d7f:	5b                   	pop    %ebx
  802d80:	5e                   	pop    %esi
  802d81:	5f                   	pop    %edi
  802d82:	5d                   	pop    %ebp
  802d83:	c3                   	ret    
  802d84:	bd 20 00 00 00       	mov    $0x20,%ebp
  802d89:	89 eb                	mov    %ebp,%ebx
  802d8b:	29 fb                	sub    %edi,%ebx
  802d8d:	89 f9                	mov    %edi,%ecx
  802d8f:	d3 e6                	shl    %cl,%esi
  802d91:	89 c5                	mov    %eax,%ebp
  802d93:	88 d9                	mov    %bl,%cl
  802d95:	d3 ed                	shr    %cl,%ebp
  802d97:	89 e9                	mov    %ebp,%ecx
  802d99:	09 f1                	or     %esi,%ecx
  802d9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d9f:	89 f9                	mov    %edi,%ecx
  802da1:	d3 e0                	shl    %cl,%eax
  802da3:	89 c5                	mov    %eax,%ebp
  802da5:	89 d6                	mov    %edx,%esi
  802da7:	88 d9                	mov    %bl,%cl
  802da9:	d3 ee                	shr    %cl,%esi
  802dab:	89 f9                	mov    %edi,%ecx
  802dad:	d3 e2                	shl    %cl,%edx
  802daf:	8b 44 24 08          	mov    0x8(%esp),%eax
  802db3:	88 d9                	mov    %bl,%cl
  802db5:	d3 e8                	shr    %cl,%eax
  802db7:	09 c2                	or     %eax,%edx
  802db9:	89 d0                	mov    %edx,%eax
  802dbb:	89 f2                	mov    %esi,%edx
  802dbd:	f7 74 24 0c          	divl   0xc(%esp)
  802dc1:	89 d6                	mov    %edx,%esi
  802dc3:	89 c3                	mov    %eax,%ebx
  802dc5:	f7 e5                	mul    %ebp
  802dc7:	39 d6                	cmp    %edx,%esi
  802dc9:	72 19                	jb     802de4 <__udivdi3+0xfc>
  802dcb:	74 0b                	je     802dd8 <__udivdi3+0xf0>
  802dcd:	89 d8                	mov    %ebx,%eax
  802dcf:	31 ff                	xor    %edi,%edi
  802dd1:	e9 58 ff ff ff       	jmp    802d2e <__udivdi3+0x46>
  802dd6:	66 90                	xchg   %ax,%ax
  802dd8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802ddc:	89 f9                	mov    %edi,%ecx
  802dde:	d3 e2                	shl    %cl,%edx
  802de0:	39 c2                	cmp    %eax,%edx
  802de2:	73 e9                	jae    802dcd <__udivdi3+0xe5>
  802de4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802de7:	31 ff                	xor    %edi,%edi
  802de9:	e9 40 ff ff ff       	jmp    802d2e <__udivdi3+0x46>
  802dee:	66 90                	xchg   %ax,%ax
  802df0:	31 c0                	xor    %eax,%eax
  802df2:	e9 37 ff ff ff       	jmp    802d2e <__udivdi3+0x46>
  802df7:	90                   	nop

00802df8 <__umoddi3>:
  802df8:	55                   	push   %ebp
  802df9:	57                   	push   %edi
  802dfa:	56                   	push   %esi
  802dfb:	53                   	push   %ebx
  802dfc:	83 ec 1c             	sub    $0x1c,%esp
  802dff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e03:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e17:	89 f3                	mov    %esi,%ebx
  802e19:	89 fa                	mov    %edi,%edx
  802e1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e1f:	89 34 24             	mov    %esi,(%esp)
  802e22:	85 c0                	test   %eax,%eax
  802e24:	75 1a                	jne    802e40 <__umoddi3+0x48>
  802e26:	39 f7                	cmp    %esi,%edi
  802e28:	0f 86 a2 00 00 00    	jbe    802ed0 <__umoddi3+0xd8>
  802e2e:	89 c8                	mov    %ecx,%eax
  802e30:	89 f2                	mov    %esi,%edx
  802e32:	f7 f7                	div    %edi
  802e34:	89 d0                	mov    %edx,%eax
  802e36:	31 d2                	xor    %edx,%edx
  802e38:	83 c4 1c             	add    $0x1c,%esp
  802e3b:	5b                   	pop    %ebx
  802e3c:	5e                   	pop    %esi
  802e3d:	5f                   	pop    %edi
  802e3e:	5d                   	pop    %ebp
  802e3f:	c3                   	ret    
  802e40:	39 f0                	cmp    %esi,%eax
  802e42:	0f 87 ac 00 00 00    	ja     802ef4 <__umoddi3+0xfc>
  802e48:	0f bd e8             	bsr    %eax,%ebp
  802e4b:	83 f5 1f             	xor    $0x1f,%ebp
  802e4e:	0f 84 ac 00 00 00    	je     802f00 <__umoddi3+0x108>
  802e54:	bf 20 00 00 00       	mov    $0x20,%edi
  802e59:	29 ef                	sub    %ebp,%edi
  802e5b:	89 fe                	mov    %edi,%esi
  802e5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e61:	89 e9                	mov    %ebp,%ecx
  802e63:	d3 e0                	shl    %cl,%eax
  802e65:	89 d7                	mov    %edx,%edi
  802e67:	89 f1                	mov    %esi,%ecx
  802e69:	d3 ef                	shr    %cl,%edi
  802e6b:	09 c7                	or     %eax,%edi
  802e6d:	89 e9                	mov    %ebp,%ecx
  802e6f:	d3 e2                	shl    %cl,%edx
  802e71:	89 14 24             	mov    %edx,(%esp)
  802e74:	89 d8                	mov    %ebx,%eax
  802e76:	d3 e0                	shl    %cl,%eax
  802e78:	89 c2                	mov    %eax,%edx
  802e7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e7e:	d3 e0                	shl    %cl,%eax
  802e80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e84:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e88:	89 f1                	mov    %esi,%ecx
  802e8a:	d3 e8                	shr    %cl,%eax
  802e8c:	09 d0                	or     %edx,%eax
  802e8e:	d3 eb                	shr    %cl,%ebx
  802e90:	89 da                	mov    %ebx,%edx
  802e92:	f7 f7                	div    %edi
  802e94:	89 d3                	mov    %edx,%ebx
  802e96:	f7 24 24             	mull   (%esp)
  802e99:	89 c6                	mov    %eax,%esi
  802e9b:	89 d1                	mov    %edx,%ecx
  802e9d:	39 d3                	cmp    %edx,%ebx
  802e9f:	0f 82 87 00 00 00    	jb     802f2c <__umoddi3+0x134>
  802ea5:	0f 84 91 00 00 00    	je     802f3c <__umoddi3+0x144>
  802eab:	8b 54 24 04          	mov    0x4(%esp),%edx
  802eaf:	29 f2                	sub    %esi,%edx
  802eb1:	19 cb                	sbb    %ecx,%ebx
  802eb3:	89 d8                	mov    %ebx,%eax
  802eb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802eb9:	d3 e0                	shl    %cl,%eax
  802ebb:	89 e9                	mov    %ebp,%ecx
  802ebd:	d3 ea                	shr    %cl,%edx
  802ebf:	09 d0                	or     %edx,%eax
  802ec1:	89 e9                	mov    %ebp,%ecx
  802ec3:	d3 eb                	shr    %cl,%ebx
  802ec5:	89 da                	mov    %ebx,%edx
  802ec7:	83 c4 1c             	add    $0x1c,%esp
  802eca:	5b                   	pop    %ebx
  802ecb:	5e                   	pop    %esi
  802ecc:	5f                   	pop    %edi
  802ecd:	5d                   	pop    %ebp
  802ece:	c3                   	ret    
  802ecf:	90                   	nop
  802ed0:	89 fd                	mov    %edi,%ebp
  802ed2:	85 ff                	test   %edi,%edi
  802ed4:	75 0b                	jne    802ee1 <__umoddi3+0xe9>
  802ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  802edb:	31 d2                	xor    %edx,%edx
  802edd:	f7 f7                	div    %edi
  802edf:	89 c5                	mov    %eax,%ebp
  802ee1:	89 f0                	mov    %esi,%eax
  802ee3:	31 d2                	xor    %edx,%edx
  802ee5:	f7 f5                	div    %ebp
  802ee7:	89 c8                	mov    %ecx,%eax
  802ee9:	f7 f5                	div    %ebp
  802eeb:	89 d0                	mov    %edx,%eax
  802eed:	e9 44 ff ff ff       	jmp    802e36 <__umoddi3+0x3e>
  802ef2:	66 90                	xchg   %ax,%ax
  802ef4:	89 c8                	mov    %ecx,%eax
  802ef6:	89 f2                	mov    %esi,%edx
  802ef8:	83 c4 1c             	add    $0x1c,%esp
  802efb:	5b                   	pop    %ebx
  802efc:	5e                   	pop    %esi
  802efd:	5f                   	pop    %edi
  802efe:	5d                   	pop    %ebp
  802eff:	c3                   	ret    
  802f00:	3b 04 24             	cmp    (%esp),%eax
  802f03:	72 06                	jb     802f0b <__umoddi3+0x113>
  802f05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f09:	77 0f                	ja     802f1a <__umoddi3+0x122>
  802f0b:	89 f2                	mov    %esi,%edx
  802f0d:	29 f9                	sub    %edi,%ecx
  802f0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f13:	89 14 24             	mov    %edx,(%esp)
  802f16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f1e:	8b 14 24             	mov    (%esp),%edx
  802f21:	83 c4 1c             	add    $0x1c,%esp
  802f24:	5b                   	pop    %ebx
  802f25:	5e                   	pop    %esi
  802f26:	5f                   	pop    %edi
  802f27:	5d                   	pop    %ebp
  802f28:	c3                   	ret    
  802f29:	8d 76 00             	lea    0x0(%esi),%esi
  802f2c:	2b 04 24             	sub    (%esp),%eax
  802f2f:	19 fa                	sbb    %edi,%edx
  802f31:	89 d1                	mov    %edx,%ecx
  802f33:	89 c6                	mov    %eax,%esi
  802f35:	e9 71 ff ff ff       	jmp    802eab <__umoddi3+0xb3>
  802f3a:	66 90                	xchg   %ax,%ax
  802f3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802f40:	72 ea                	jb     802f2c <__umoddi3+0x134>
  802f42:	89 d9                	mov    %ebx,%ecx
  802f44:	e9 62 ff ff ff       	jmp    802eab <__umoddi3+0xb3>
