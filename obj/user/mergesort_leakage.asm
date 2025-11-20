
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
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
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 97 1e 00 00       	call   801edd <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 31 80 00       	push   $0x803140
  80004e:	e8 77 0b 00 00       	call   800bca <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 31 80 00       	push   $0x803142
  80005e:	e8 67 0b 00 00       	call   800bca <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 31 80 00       	push   $0x803158
  80006e:	e8 57 0b 00 00       	call   800bca <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 31 80 00       	push   $0x803142
  80007e:	e8 47 0b 00 00       	call   800bca <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 31 80 00       	push   $0x803140
  80008e:	e8 37 0b 00 00       	call   800bca <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 31 80 00       	push   $0x803170
  8000a5:	e8 f9 11 00 00       	call   8012a3 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 fa 17 00 00       	call   8018ba <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 bf 1c 00 00       	call   801d94 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 31 80 00       	push   $0x803190
  8000e3:	e8 e2 0a 00 00       	call   800bca <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 31 80 00       	push   $0x8031b2
  8000f3:	e8 d2 0a 00 00       	call   800bca <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 31 80 00       	push   $0x8031c0
  800103:	e8 c2 0a 00 00       	call   800bca <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 31 80 00       	push   $0x8031cf
  800113:	e8 b2 0a 00 00       	call   800bca <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 31 80 00       	push   $0x8031df
  800123:	e8 a2 0a 00 00       	call   800bca <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 90 1d 00 00       	call   801ef7 <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 01 1d 00 00       	call   801edd <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 31 80 00       	push   $0x8031e8
  8001e4:	e8 e1 09 00 00       	call   800bca <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 06 1d 00 00       	call   801ef7 <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 1c 32 80 00       	push   $0x80321c
  800213:	6a 51                	push   $0x51
  800215:	68 3e 32 80 00       	push   $0x80323e
  80021a:	e8 dd 06 00 00       	call   8008fc <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 b9 1c 00 00       	call   801edd <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 58 32 80 00       	push   $0x803258
  80022c:	e8 99 09 00 00       	call   800bca <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 8c 32 80 00       	push   $0x80328c
  80023c:	e8 89 09 00 00       	call   800bca <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c0 32 80 00       	push   $0x8032c0
  80024c:	e8 79 09 00 00       	call   800bca <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 9e 1c 00 00       	call   801ef7 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 7f 1c 00 00       	call   801edd <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f2 32 80 00       	push   $0x8032f2
  80026c:	e8 59 09 00 00       	call   800bca <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 40 1c 00 00       	call   801ef7 <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 40 31 80 00       	push   $0x803140
  80044b:	e8 7a 07 00 00       	call   800bca <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 10 33 80 00       	push   $0x803310
  80046d:	e8 58 07 00 00       	call   800bca <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 15 33 80 00       	push   $0x803315
  80049b:	e8 2a 07 00 00       	call   800bca <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 53 18 00 00       	call   801d94 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 3e 18 00 00       	call   801d94 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 11 19 00 00       	call   802025 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 9f 17 00 00       	call   801ec4 <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800740:	e8 11 1a 00 00       	call   802156 <sys_getenvindex>
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	c1 e0 06             	shl    $0x6,%eax
  800750:	29 d0                	sub    %edx,%eax
  800752:	c1 e0 02             	shl    $0x2,%eax
  800755:	01 d0                	add    %edx,%eax
  800757:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80075e:	01 c8                	add    %ecx,%eax
  800760:	c1 e0 03             	shl    $0x3,%eax
  800763:	01 d0                	add    %edx,%eax
  800765:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076c:	29 c2                	sub    %eax,%edx
  80076e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800775:	89 c2                	mov    %eax,%edx
  800777:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80077d:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800782:	a1 24 40 80 00       	mov    0x804024,%eax
  800787:	8a 40 20             	mov    0x20(%eax),%al
  80078a:	84 c0                	test   %al,%al
  80078c:	74 0d                	je     80079b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80078e:	a1 24 40 80 00       	mov    0x804024,%eax
  800793:	83 c0 20             	add    $0x20,%eax
  800796:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80079b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80079f:	7e 0a                	jle    8007ab <libmain+0x74>
		binaryname = argv[0];
  8007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 7f f8 ff ff       	call   800038 <_main>
  8007b9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007bc:	a1 00 40 80 00       	mov    0x804000,%eax
  8007c1:	85 c0                	test   %eax,%eax
  8007c3:	0f 84 01 01 00 00    	je     8008ca <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007c9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007cf:	bb 14 34 80 00       	mov    $0x803414,%ebx
  8007d4:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007d9:	89 c7                	mov    %eax,%edi
  8007db:	89 de                	mov    %ebx,%esi
  8007dd:	89 d1                	mov    %edx,%ecx
  8007df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007e1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007e4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007e9:	b0 00                	mov    $0x0,%al
  8007eb:	89 d7                	mov    %edx,%edi
  8007ed:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	50                   	push   %eax
  8007fd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	e8 83 1b 00 00       	call   80238c <sys_utilities>
  800809:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80080c:	e8 cc 16 00 00       	call   801edd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 34 33 80 00       	push   $0x803334
  800819:	e8 ac 03 00 00       	call   800bca <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800824:	85 c0                	test   %eax,%eax
  800826:	74 18                	je     800840 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800828:	e8 7d 1b 00 00       	call   8023aa <sys_get_optimal_num_faults>
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	50                   	push   %eax
  800831:	68 5c 33 80 00       	push   $0x80335c
  800836:	e8 8f 03 00 00       	call   800bca <cprintf>
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	eb 59                	jmp    800899 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800840:	a1 24 40 80 00       	mov    0x804024,%eax
  800845:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80084b:	a1 24 40 80 00       	mov    0x804024,%eax
  800850:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800856:	83 ec 04             	sub    $0x4,%esp
  800859:	52                   	push   %edx
  80085a:	50                   	push   %eax
  80085b:	68 80 33 80 00       	push   $0x803380
  800860:	e8 65 03 00 00       	call   800bca <cprintf>
  800865:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800868:	a1 24 40 80 00       	mov    0x804024,%eax
  80086d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800873:	a1 24 40 80 00       	mov    0x804024,%eax
  800878:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80087e:	a1 24 40 80 00       	mov    0x804024,%eax
  800883:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800889:	51                   	push   %ecx
  80088a:	52                   	push   %edx
  80088b:	50                   	push   %eax
  80088c:	68 a8 33 80 00       	push   $0x8033a8
  800891:	e8 34 03 00 00       	call   800bca <cprintf>
  800896:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800899:	a1 24 40 80 00       	mov    0x804024,%eax
  80089e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	50                   	push   %eax
  8008a8:	68 00 34 80 00       	push   $0x803400
  8008ad:	e8 18 03 00 00       	call   800bca <cprintf>
  8008b2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008b5:	83 ec 0c             	sub    $0xc,%esp
  8008b8:	68 34 33 80 00       	push   $0x803334
  8008bd:	e8 08 03 00 00       	call   800bca <cprintf>
  8008c2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008c5:	e8 2d 16 00 00       	call   801ef7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008ca:	e8 1f 00 00 00       	call   8008ee <exit>
}
  8008cf:	90                   	nop
  8008d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d3:	5b                   	pop    %ebx
  8008d4:	5e                   	pop    %esi
  8008d5:	5f                   	pop    %edi
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008de:	83 ec 0c             	sub    $0xc,%esp
  8008e1:	6a 00                	push   $0x0
  8008e3:	e8 3a 18 00 00       	call   802122 <sys_destroy_env>
  8008e8:	83 c4 10             	add    $0x10,%esp
}
  8008eb:	90                   	nop
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <exit>:

void
exit(void)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f4:	e8 8f 18 00 00       	call   802188 <sys_exit_env>
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800902:	8d 45 10             	lea    0x10(%ebp),%eax
  800905:	83 c0 04             	add    $0x4,%eax
  800908:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80090b:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800910:	85 c0                	test   %eax,%eax
  800912:	74 16                	je     80092a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800914:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	50                   	push   %eax
  80091d:	68 78 34 80 00       	push   $0x803478
  800922:	e8 a3 02 00 00       	call   800bca <cprintf>
  800927:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80092a:	a1 04 40 80 00       	mov    0x804004,%eax
  80092f:	83 ec 0c             	sub    $0xc,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	50                   	push   %eax
  800939:	68 80 34 80 00       	push   $0x803480
  80093e:	6a 74                	push   $0x74
  800940:	e8 b2 02 00 00       	call   800bf7 <cprintf_colored>
  800945:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 04 02 00 00       	call   800b5b <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 a8 34 80 00       	push   $0x8034a8
  800964:	e8 f2 01 00 00       	call   800b5b <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 7d ff ff ff       	call   8008ee <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x75>

00800973 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 40 80 00       	mov    0x804024,%eax
  80097e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	39 c2                	cmp    %eax,%edx
  800989:	74 14                	je     80099f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80098b:	83 ec 04             	sub    $0x4,%esp
  80098e:	68 ac 34 80 00       	push   $0x8034ac
  800993:	6a 26                	push   $0x26
  800995:	68 f8 34 80 00       	push   $0x8034f8
  80099a:	e8 5d ff ff ff       	call   8008fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009ad:	e9 c5 00 00 00       	jmp    800a77 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	01 d0                	add    %edx,%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	85 c0                	test   %eax,%eax
  8009c5:	75 08                	jne    8009cf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009c7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009ca:	e9 a5 00 00 00       	jmp    800a74 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009dd:	eb 69                	jmp    800a48 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009df:	a1 24 40 80 00       	mov    0x804024,%eax
  8009e4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ed:	89 d0                	mov    %edx,%eax
  8009ef:	01 c0                	add    %eax,%eax
  8009f1:	01 d0                	add    %edx,%eax
  8009f3:	c1 e0 03             	shl    $0x3,%eax
  8009f6:	01 c8                	add    %ecx,%eax
  8009f8:	8a 40 04             	mov    0x4(%eax),%al
  8009fb:	84 c0                	test   %al,%al
  8009fd:	75 46                	jne    800a45 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ff:	a1 24 40 80 00       	mov    0x804024,%eax
  800a04:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	01 c0                	add    %eax,%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	c1 e0 03             	shl    $0x3,%eax
  800a16:	01 c8                	add    %ecx,%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a25:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	01 c8                	add    %ecx,%eax
  800a36:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a38:	39 c2                	cmp    %eax,%edx
  800a3a:	75 09                	jne    800a45 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a3c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a43:	eb 15                	jmp    800a5a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a45:	ff 45 e8             	incl   -0x18(%ebp)
  800a48:	a1 24 40 80 00       	mov    0x804024,%eax
  800a4d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a56:	39 c2                	cmp    %eax,%edx
  800a58:	77 85                	ja     8009df <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a5e:	75 14                	jne    800a74 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a60:	83 ec 04             	sub    $0x4,%esp
  800a63:	68 04 35 80 00       	push   $0x803504
  800a68:	6a 3a                	push   $0x3a
  800a6a:	68 f8 34 80 00       	push   $0x8034f8
  800a6f:	e8 88 fe ff ff       	call   8008fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a74:	ff 45 f0             	incl   -0x10(%ebp)
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a7d:	0f 8c 2f ff ff ff    	jl     8009b2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a91:	eb 26                	jmp    800ab9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a93:	a1 24 40 80 00       	mov    0x804024,%eax
  800a98:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	01 c0                	add    %eax,%eax
  800aa5:	01 d0                	add    %edx,%eax
  800aa7:	c1 e0 03             	shl    $0x3,%eax
  800aaa:	01 c8                	add    %ecx,%eax
  800aac:	8a 40 04             	mov    0x4(%eax),%al
  800aaf:	3c 01                	cmp    $0x1,%al
  800ab1:	75 03                	jne    800ab6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ab3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab6:	ff 45 e0             	incl   -0x20(%ebp)
  800ab9:	a1 24 40 80 00       	mov    0x804024,%eax
  800abe:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac7:	39 c2                	cmp    %eax,%edx
  800ac9:	77 c8                	ja     800a93 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ace:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad1:	74 14                	je     800ae7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ad3:	83 ec 04             	sub    $0x4,%esp
  800ad6:	68 58 35 80 00       	push   $0x803558
  800adb:	6a 44                	push   $0x44
  800add:	68 f8 34 80 00       	push   $0x8034f8
  800ae2:	e8 15 fe ff ff       	call   8008fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae7:	90                   	nop
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	53                   	push   %ebx
  800aee:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	8d 48 01             	lea    0x1(%eax),%ecx
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 0a                	mov    %ecx,(%edx)
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	88 d1                	mov    %dl,%cl
  800b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b06:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b14:	75 30                	jne    800b46 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b16:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b1c:	a0 44 40 80 00       	mov    0x804044,%al
  800b21:	0f b6 c0             	movzbl %al,%eax
  800b24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b27:	8b 09                	mov    (%ecx),%ecx
  800b29:	89 cb                	mov    %ecx,%ebx
  800b2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2e:	83 c1 08             	add    $0x8,%ecx
  800b31:	52                   	push   %edx
  800b32:	50                   	push   %eax
  800b33:	53                   	push   %ebx
  800b34:	51                   	push   %ecx
  800b35:	e8 5f 13 00 00       	call   801e99 <sys_cputs>
  800b3a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 40 04             	mov    0x4(%eax),%eax
  800b4c:	8d 50 01             	lea    0x1(%eax),%edx
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b55:	90                   	nop
  800b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b64:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b6b:	00 00 00 
	b.cnt = 0;
  800b6e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b75:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	ff 75 08             	pushl  0x8(%ebp)
  800b7e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b84:	50                   	push   %eax
  800b85:	68 ea 0a 80 00       	push   $0x800aea
  800b8a:	e8 5a 02 00 00       	call   800de9 <vprintfmt>
  800b8f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b92:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b98:	a0 44 40 80 00       	mov    0x804044,%al
  800b9d:	0f b6 c0             	movzbl %al,%eax
  800ba0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800ba6:	52                   	push   %edx
  800ba7:	50                   	push   %eax
  800ba8:	51                   	push   %ecx
  800ba9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800baf:	83 c0 08             	add    $0x8,%eax
  800bb2:	50                   	push   %eax
  800bb3:	e8 e1 12 00 00       	call   801e99 <sys_cputs>
  800bb8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bbb:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bc2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bd0:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800bd7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	e8 6f ff ff ff       	call   800b5b <vcprintf>
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bfd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	c1 e0 08             	shl    $0x8,%eax
  800c0a:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c0f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c12:	83 c0 04             	add    $0x4,%eax
  800c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c21:	50                   	push   %eax
  800c22:	e8 34 ff ff ff       	call   800b5b <vcprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c2d:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c34:	07 00 00 

	return cnt;
  800c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c42:	e8 96 12 00 00       	call   801edd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c47:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 f4             	pushl  -0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	e8 ff fe ff ff       	call   800b5b <vcprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c62:	e8 90 12 00 00       	call   801ef7 <sys_unlock_cons>
	return cnt;
  800c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 14             	sub    $0x14,%esp
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c79:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c7f:	8b 45 18             	mov    0x18(%ebp),%eax
  800c82:	ba 00 00 00 00       	mov    $0x0,%edx
  800c87:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c8a:	77 55                	ja     800ce1 <printnum+0x75>
  800c8c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c8f:	72 05                	jb     800c96 <printnum+0x2a>
  800c91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c94:	77 4b                	ja     800ce1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c96:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c99:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c9c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	52                   	push   %edx
  800ca5:	50                   	push   %eax
  800ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cac:	e8 0f 22 00 00       	call   802ec0 <__udivdi3>
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	83 ec 04             	sub    $0x4,%esp
  800cb7:	ff 75 20             	pushl  0x20(%ebp)
  800cba:	53                   	push   %ebx
  800cbb:	ff 75 18             	pushl  0x18(%ebp)
  800cbe:	52                   	push   %edx
  800cbf:	50                   	push   %eax
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	ff 75 08             	pushl  0x8(%ebp)
  800cc6:	e8 a1 ff ff ff       	call   800c6c <printnum>
  800ccb:	83 c4 20             	add    $0x20,%esp
  800cce:	eb 1a                	jmp    800cea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	ff 75 20             	pushl  0x20(%ebp)
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	ff d0                	call   *%eax
  800cde:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ce1:	ff 4d 1c             	decl   0x1c(%ebp)
  800ce4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ce8:	7f e6                	jg     800cd0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf8:	53                   	push   %ebx
  800cf9:	51                   	push   %ecx
  800cfa:	52                   	push   %edx
  800cfb:	50                   	push   %eax
  800cfc:	e8 cf 22 00 00       	call   802fd0 <__umoddi3>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	05 d4 37 80 00       	add    $0x8037d4,%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f be c0             	movsbl %al,%eax
  800d0e:	83 ec 08             	sub    $0x8,%esp
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	50                   	push   %eax
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	ff d0                	call   *%eax
  800d1a:	83 c4 10             	add    $0x10,%esp
}
  800d1d:	90                   	nop
  800d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d26:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d2a:	7e 1c                	jle    800d48 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	8d 50 08             	lea    0x8(%eax),%edx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 10                	mov    %edx,(%eax)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 e8 08             	sub    $0x8,%eax
  800d41:	8b 50 04             	mov    0x4(%eax),%edx
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	eb 40                	jmp    800d88 <getuint+0x65>
	else if (lflag)
  800d48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4c:	74 1e                	je     800d6c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	8d 50 04             	lea    0x4(%eax),%edx
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 10                	mov    %edx,(%eax)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	83 e8 04             	sub    $0x4,%eax
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6a:	eb 1c                	jmp    800d88 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	8d 50 04             	lea    0x4(%eax),%edx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 10                	mov    %edx,(%eax)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	83 e8 04             	sub    $0x4,%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d8d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d91:	7e 1c                	jle    800daf <getint+0x25>
		return va_arg(*ap, long long);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	8d 50 08             	lea    0x8(%eax),%edx
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 10                	mov    %edx,(%eax)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	83 e8 08             	sub    $0x8,%eax
  800da8:	8b 50 04             	mov    0x4(%eax),%edx
  800dab:	8b 00                	mov    (%eax),%eax
  800dad:	eb 38                	jmp    800de7 <getint+0x5d>
	else if (lflag)
  800daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db3:	74 1a                	je     800dcf <getint+0x45>
		return va_arg(*ap, long);
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	8d 50 04             	lea    0x4(%eax),%edx
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 10                	mov    %edx,(%eax)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8b 00                	mov    (%eax),%eax
  800dc7:	83 e8 04             	sub    $0x4,%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	99                   	cltd   
  800dcd:	eb 18                	jmp    800de7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 00                	mov    (%eax),%eax
  800dd4:	8d 50 04             	lea    0x4(%eax),%edx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 10                	mov    %edx,(%eax)
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	83 e8 04             	sub    $0x4,%eax
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	99                   	cltd   
}
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df1:	eb 17                	jmp    800e0a <vprintfmt+0x21>
			if (ch == '\0')
  800df3:	85 db                	test   %ebx,%ebx
  800df5:	0f 84 c1 03 00 00    	je     8011bc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800dfb:	83 ec 08             	sub    $0x8,%esp
  800dfe:	ff 75 0c             	pushl  0xc(%ebp)
  800e01:	53                   	push   %ebx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	89 55 10             	mov    %edx,0x10(%ebp)
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f b6 d8             	movzbl %al,%ebx
  800e18:	83 fb 25             	cmp    $0x25,%ebx
  800e1b:	75 d6                	jne    800df3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e1d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e21:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e2f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e36:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	8d 50 01             	lea    0x1(%eax),%edx
  800e43:	89 55 10             	mov    %edx,0x10(%ebp)
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	0f b6 d8             	movzbl %al,%ebx
  800e4b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e4e:	83 f8 5b             	cmp    $0x5b,%eax
  800e51:	0f 87 3d 03 00 00    	ja     801194 <vprintfmt+0x3ab>
  800e57:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  800e5e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e60:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e64:	eb d7                	jmp    800e3d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e66:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e6a:	eb d1                	jmp    800e3d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e6c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e76:	89 d0                	mov    %edx,%eax
  800e78:	c1 e0 02             	shl    $0x2,%eax
  800e7b:	01 d0                	add    %edx,%eax
  800e7d:	01 c0                	add    %eax,%eax
  800e7f:	01 d8                	add    %ebx,%eax
  800e81:	83 e8 30             	sub    $0x30,%eax
  800e84:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e8f:	83 fb 2f             	cmp    $0x2f,%ebx
  800e92:	7e 3e                	jle    800ed2 <vprintfmt+0xe9>
  800e94:	83 fb 39             	cmp    $0x39,%ebx
  800e97:	7f 39                	jg     800ed2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e99:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e9c:	eb d5                	jmp    800e73 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea1:	83 c0 04             	add    $0x4,%eax
  800ea4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eaa:	83 e8 04             	sub    $0x4,%eax
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eb2:	eb 1f                	jmp    800ed3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb8:	79 83                	jns    800e3d <vprintfmt+0x54>
				width = 0;
  800eba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ec1:	e9 77 ff ff ff       	jmp    800e3d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ec6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ecd:	e9 6b ff ff ff       	jmp    800e3d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ed2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ed3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed7:	0f 89 60 ff ff ff    	jns    800e3d <vprintfmt+0x54>
				width = precision, precision = -1;
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ee3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800eea:	e9 4e ff ff ff       	jmp    800e3d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ef2:	e9 46 ff ff ff       	jmp    800e3d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ef7:	8b 45 14             	mov    0x14(%ebp),%eax
  800efa:	83 c0 04             	add    $0x4,%eax
  800efd:	89 45 14             	mov    %eax,0x14(%ebp)
  800f00:	8b 45 14             	mov    0x14(%ebp),%eax
  800f03:	83 e8 04             	sub    $0x4,%eax
  800f06:	8b 00                	mov    (%eax),%eax
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	50                   	push   %eax
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	ff d0                	call   *%eax
  800f14:	83 c4 10             	add    $0x10,%esp
			break;
  800f17:	e9 9b 02 00 00       	jmp    8011b7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1f:	83 c0 04             	add    $0x4,%eax
  800f22:	89 45 14             	mov    %eax,0x14(%ebp)
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	83 e8 04             	sub    $0x4,%eax
  800f2b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f2d:	85 db                	test   %ebx,%ebx
  800f2f:	79 02                	jns    800f33 <vprintfmt+0x14a>
				err = -err;
  800f31:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f33:	83 fb 64             	cmp    $0x64,%ebx
  800f36:	7f 0b                	jg     800f43 <vprintfmt+0x15a>
  800f38:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  800f3f:	85 f6                	test   %esi,%esi
  800f41:	75 19                	jne    800f5c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f43:	53                   	push   %ebx
  800f44:	68 e5 37 80 00       	push   $0x8037e5
  800f49:	ff 75 0c             	pushl  0xc(%ebp)
  800f4c:	ff 75 08             	pushl  0x8(%ebp)
  800f4f:	e8 70 02 00 00       	call   8011c4 <printfmt>
  800f54:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f57:	e9 5b 02 00 00       	jmp    8011b7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f5c:	56                   	push   %esi
  800f5d:	68 ee 37 80 00       	push   $0x8037ee
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	ff 75 08             	pushl  0x8(%ebp)
  800f68:	e8 57 02 00 00       	call   8011c4 <printfmt>
  800f6d:	83 c4 10             	add    $0x10,%esp
			break;
  800f70:	e9 42 02 00 00       	jmp    8011b7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	83 c0 04             	add    $0x4,%eax
  800f7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	83 e8 04             	sub    $0x4,%eax
  800f84:	8b 30                	mov    (%eax),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 05                	jne    800f8f <vprintfmt+0x1a6>
				p = "(null)";
  800f8a:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  800f8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f93:	7e 6d                	jle    801002 <vprintfmt+0x219>
  800f95:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f99:	74 67                	je     801002 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	50                   	push   %eax
  800fa2:	56                   	push   %esi
  800fa3:	e8 26 05 00 00       	call   8014ce <strnlen>
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fae:	eb 16                	jmp    800fc6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fb0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	50                   	push   %eax
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	ff d0                	call   *%eax
  800fc0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fc3:	ff 4d e4             	decl   -0x1c(%ebp)
  800fc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fca:	7f e4                	jg     800fb0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fcc:	eb 34                	jmp    801002 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fd2:	74 1c                	je     800ff0 <vprintfmt+0x207>
  800fd4:	83 fb 1f             	cmp    $0x1f,%ebx
  800fd7:	7e 05                	jle    800fde <vprintfmt+0x1f5>
  800fd9:	83 fb 7e             	cmp    $0x7e,%ebx
  800fdc:	7e 12                	jle    800ff0 <vprintfmt+0x207>
					putch('?', putdat);
  800fde:	83 ec 08             	sub    $0x8,%esp
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	6a 3f                	push   $0x3f
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	ff d0                	call   *%eax
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	eb 0f                	jmp    800fff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	53                   	push   %ebx
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	ff d0                	call   *%eax
  800ffc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fff:	ff 4d e4             	decl   -0x1c(%ebp)
  801002:	89 f0                	mov    %esi,%eax
  801004:	8d 70 01             	lea    0x1(%eax),%esi
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f be d8             	movsbl %al,%ebx
  80100c:	85 db                	test   %ebx,%ebx
  80100e:	74 24                	je     801034 <vprintfmt+0x24b>
  801010:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801014:	78 b8                	js     800fce <vprintfmt+0x1e5>
  801016:	ff 4d e0             	decl   -0x20(%ebp)
  801019:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80101d:	79 af                	jns    800fce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80101f:	eb 13                	jmp    801034 <vprintfmt+0x24b>
				putch(' ', putdat);
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	6a 20                	push   $0x20
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801031:	ff 4d e4             	decl   -0x1c(%ebp)
  801034:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801038:	7f e7                	jg     801021 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80103a:	e9 78 01 00 00       	jmp    8011b7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	ff 75 e8             	pushl  -0x18(%ebp)
  801045:	8d 45 14             	lea    0x14(%ebp),%eax
  801048:	50                   	push   %eax
  801049:	e8 3c fd ff ff       	call   800d8a <getint>
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801054:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	85 d2                	test   %edx,%edx
  80105f:	79 23                	jns    801084 <vprintfmt+0x29b>
				putch('-', putdat);
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 0c             	pushl  0xc(%ebp)
  801067:	6a 2d                	push   $0x2d
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801077:	f7 d8                	neg    %eax
  801079:	83 d2 00             	adc    $0x0,%edx
  80107c:	f7 da                	neg    %edx
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801081:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801084:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80108b:	e9 bc 00 00 00       	jmp    80114c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801090:	83 ec 08             	sub    $0x8,%esp
  801093:	ff 75 e8             	pushl  -0x18(%ebp)
  801096:	8d 45 14             	lea    0x14(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	e8 84 fc ff ff       	call   800d23 <getuint>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010af:	e9 98 00 00 00       	jmp    80114c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	6a 58                	push   $0x58
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	ff d0                	call   *%eax
  8010c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 58                	push   $0x58
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	6a 58                	push   $0x58
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	ff d0                	call   *%eax
  8010e1:	83 c4 10             	add    $0x10,%esp
			break;
  8010e4:	e9 ce 00 00 00       	jmp    8011b7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	ff 75 0c             	pushl  0xc(%ebp)
  8010ef:	6a 30                	push   $0x30
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	ff d0                	call   *%eax
  8010f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	ff 75 0c             	pushl  0xc(%ebp)
  8010ff:	6a 78                	push   $0x78
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	ff d0                	call   *%eax
  801106:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801109:	8b 45 14             	mov    0x14(%ebp),%eax
  80110c:	83 c0 04             	add    $0x4,%eax
  80110f:	89 45 14             	mov    %eax,0x14(%ebp)
  801112:	8b 45 14             	mov    0x14(%ebp),%eax
  801115:	83 e8 04             	sub    $0x4,%eax
  801118:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80111a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80111d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801124:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80112b:	eb 1f                	jmp    80114c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 e8             	pushl  -0x18(%ebp)
  801133:	8d 45 14             	lea    0x14(%ebp),%eax
  801136:	50                   	push   %eax
  801137:	e8 e7 fb ff ff       	call   800d23 <getuint>
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801142:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801145:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80114c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801153:	83 ec 04             	sub    $0x4,%esp
  801156:	52                   	push   %edx
  801157:	ff 75 e4             	pushl  -0x1c(%ebp)
  80115a:	50                   	push   %eax
  80115b:	ff 75 f4             	pushl  -0xc(%ebp)
  80115e:	ff 75 f0             	pushl  -0x10(%ebp)
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	e8 00 fb ff ff       	call   800c6c <printnum>
  80116c:	83 c4 20             	add    $0x20,%esp
			break;
  80116f:	eb 46                	jmp    8011b7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	ff 75 0c             	pushl  0xc(%ebp)
  801177:	53                   	push   %ebx
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	ff d0                	call   *%eax
  80117d:	83 c4 10             	add    $0x10,%esp
			break;
  801180:	eb 35                	jmp    8011b7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801182:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801189:	eb 2c                	jmp    8011b7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80118b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801192:	eb 23                	jmp    8011b7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	ff 75 0c             	pushl  0xc(%ebp)
  80119a:	6a 25                	push   $0x25
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	ff d0                	call   *%eax
  8011a1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011a4:	ff 4d 10             	decl   0x10(%ebp)
  8011a7:	eb 03                	jmp    8011ac <vprintfmt+0x3c3>
  8011a9:	ff 4d 10             	decl   0x10(%ebp)
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	48                   	dec    %eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 25                	cmp    $0x25,%al
  8011b4:	75 f3                	jne    8011a9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011b6:	90                   	nop
		}
	}
  8011b7:	e9 35 fc ff ff       	jmp    800df1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011bc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c0:	5b                   	pop    %ebx
  8011c1:	5e                   	pop    %esi
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d9:	50                   	push   %eax
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	ff 75 08             	pushl  0x8(%ebp)
  8011e0:	e8 04 fc ff ff       	call   800de9 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011e8:	90                   	nop
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	8b 40 08             	mov    0x8(%eax),%eax
  8011f4:	8d 50 01             	lea    0x1(%eax),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	8b 10                	mov    (%eax),%edx
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	8b 40 04             	mov    0x4(%eax),%eax
  801208:	39 c2                	cmp    %eax,%edx
  80120a:	73 12                	jae    80121e <sprintputch+0x33>
		*b->buf++ = ch;
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	8b 00                	mov    (%eax),%eax
  801211:	8d 48 01             	lea    0x1(%eax),%ecx
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	89 0a                	mov    %ecx,(%edx)
  801219:	8b 55 08             	mov    0x8(%ebp),%edx
  80121c:	88 10                	mov    %dl,(%eax)
}
  80121e:	90                   	nop
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	8d 50 ff             	lea    -0x1(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801246:	74 06                	je     80124e <vsnprintf+0x2d>
  801248:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124c:	7f 07                	jg     801255 <vsnprintf+0x34>
		return -E_INVAL;
  80124e:	b8 03 00 00 00       	mov    $0x3,%eax
  801253:	eb 20                	jmp    801275 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801255:	ff 75 14             	pushl  0x14(%ebp)
  801258:	ff 75 10             	pushl  0x10(%ebp)
  80125b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80125e:	50                   	push   %eax
  80125f:	68 eb 11 80 00       	push   $0x8011eb
  801264:	e8 80 fb ff ff       	call   800de9 <vprintfmt>
  801269:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80126c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80126f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80127d:	8d 45 10             	lea    0x10(%ebp),%eax
  801280:	83 c0 04             	add    $0x4,%eax
  801283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	ff 75 f4             	pushl  -0xc(%ebp)
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	ff 75 08             	pushl  0x8(%ebp)
  801293:	e8 89 ff ff ff       	call   801221 <vsnprintf>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80129e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ad:	74 13                	je     8012c2 <readline+0x1f>
		cprintf("%s", prompt);
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	ff 75 08             	pushl  0x8(%ebp)
  8012b5:	68 68 39 80 00       	push   $0x803968
  8012ba:	e8 0b f9 ff ff       	call   800bca <cprintf>
  8012bf:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	6a 00                	push   $0x0
  8012ce:	e8 5a f4 ff ff       	call   80072d <iscons>
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012d9:	e8 3c f4 ff ff       	call   80071a <getchar>
  8012de:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012e5:	79 22                	jns    801309 <readline+0x66>
			if (c != -E_EOF)
  8012e7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012eb:	0f 84 ad 00 00 00    	je     80139e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f7:	68 6b 39 80 00       	push   $0x80396b
  8012fc:	e8 c9 f8 ff ff       	call   800bca <cprintf>
  801301:	83 c4 10             	add    $0x10,%esp
			break;
  801304:	e9 95 00 00 00       	jmp    80139e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801309:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80130d:	7e 34                	jle    801343 <readline+0xa0>
  80130f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801316:	7f 2b                	jg     801343 <readline+0xa0>
			if (echoing)
  801318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80131c:	74 0e                	je     80132c <readline+0x89>
				cputchar(c);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	ff 75 ec             	pushl  -0x14(%ebp)
  801324:	e8 d2 f3 ff ff       	call   8006fb <cputchar>
  801329:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801335:	89 c2                	mov    %eax,%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80133f:	88 10                	mov    %dl,(%eax)
  801341:	eb 56                	jmp    801399 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801343:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801347:	75 1f                	jne    801368 <readline+0xc5>
  801349:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80134d:	7e 19                	jle    801368 <readline+0xc5>
			if (echoing)
  80134f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801353:	74 0e                	je     801363 <readline+0xc0>
				cputchar(c);
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	ff 75 ec             	pushl  -0x14(%ebp)
  80135b:	e8 9b f3 ff ff       	call   8006fb <cputchar>
  801360:	83 c4 10             	add    $0x10,%esp

			i--;
  801363:	ff 4d f4             	decl   -0xc(%ebp)
  801366:	eb 31                	jmp    801399 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801368:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80136c:	74 0a                	je     801378 <readline+0xd5>
  80136e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801372:	0f 85 61 ff ff ff    	jne    8012d9 <readline+0x36>
			if (echoing)
  801378:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137c:	74 0e                	je     80138c <readline+0xe9>
				cputchar(c);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 ec             	pushl  -0x14(%ebp)
  801384:	e8 72 f3 ff ff       	call   8006fb <cputchar>
  801389:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80138c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801397:	eb 06                	jmp    80139f <readline+0xfc>
		}
	}
  801399:	e9 3b ff ff ff       	jmp    8012d9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80139e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80139f:	90                   	nop
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013a8:	e8 30 0b 00 00       	call   801edd <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b1:	74 13                	je     8013c6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	68 68 39 80 00       	push   $0x803968
  8013be:	e8 07 f8 ff ff       	call   800bca <cprintf>
  8013c3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013cd:	83 ec 0c             	sub    $0xc,%esp
  8013d0:	6a 00                	push   $0x0
  8013d2:	e8 56 f3 ff ff       	call   80072d <iscons>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013dd:	e8 38 f3 ff ff       	call   80071a <getchar>
  8013e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013e9:	79 22                	jns    80140d <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013eb:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013ef:	0f 84 ad 00 00 00    	je     8014a2 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8013fb:	68 6b 39 80 00       	push   $0x80396b
  801400:	e8 c5 f7 ff ff       	call   800bca <cprintf>
  801405:	83 c4 10             	add    $0x10,%esp
				break;
  801408:	e9 95 00 00 00       	jmp    8014a2 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80140d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801411:	7e 34                	jle    801447 <atomic_readline+0xa5>
  801413:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80141a:	7f 2b                	jg     801447 <atomic_readline+0xa5>
				if (echoing)
  80141c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801420:	74 0e                	je     801430 <atomic_readline+0x8e>
					cputchar(c);
  801422:	83 ec 0c             	sub    $0xc,%esp
  801425:	ff 75 ec             	pushl  -0x14(%ebp)
  801428:	e8 ce f2 ff ff       	call   8006fb <cputchar>
  80142d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801439:	89 c2                	mov    %eax,%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801443:	88 10                	mov    %dl,(%eax)
  801445:	eb 56                	jmp    80149d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801447:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80144b:	75 1f                	jne    80146c <atomic_readline+0xca>
  80144d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801451:	7e 19                	jle    80146c <atomic_readline+0xca>
				if (echoing)
  801453:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801457:	74 0e                	je     801467 <atomic_readline+0xc5>
					cputchar(c);
  801459:	83 ec 0c             	sub    $0xc,%esp
  80145c:	ff 75 ec             	pushl  -0x14(%ebp)
  80145f:	e8 97 f2 ff ff       	call   8006fb <cputchar>
  801464:	83 c4 10             	add    $0x10,%esp
				i--;
  801467:	ff 4d f4             	decl   -0xc(%ebp)
  80146a:	eb 31                	jmp    80149d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80146c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801470:	74 0a                	je     80147c <atomic_readline+0xda>
  801472:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801476:	0f 85 61 ff ff ff    	jne    8013dd <atomic_readline+0x3b>
				if (echoing)
  80147c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801480:	74 0e                	je     801490 <atomic_readline+0xee>
					cputchar(c);
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	ff 75 ec             	pushl  -0x14(%ebp)
  801488:	e8 6e f2 ff ff       	call   8006fb <cputchar>
  80148d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	01 d0                	add    %edx,%eax
  801498:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80149b:	eb 06                	jmp    8014a3 <atomic_readline+0x101>
			}
		}
  80149d:	e9 3b ff ff ff       	jmp    8013dd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014a2:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014a3:	e8 4f 0a 00 00       	call   801ef7 <sys_unlock_cons>
}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b8:	eb 06                	jmp    8014c0 <strlen+0x15>
		n++;
  8014ba:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bd:	ff 45 08             	incl   0x8(%ebp)
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	84 c0                	test   %al,%al
  8014c7:	75 f1                	jne    8014ba <strlen+0xf>
		n++;
	return n;
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014db:	eb 09                	jmp    8014e6 <strnlen+0x18>
		n++;
  8014dd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014e0:	ff 45 08             	incl   0x8(%ebp)
  8014e3:	ff 4d 0c             	decl   0xc(%ebp)
  8014e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ea:	74 09                	je     8014f5 <strnlen+0x27>
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	84 c0                	test   %al,%al
  8014f3:	75 e8                	jne    8014dd <strnlen+0xf>
		n++;
	return n;
  8014f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801506:	90                   	nop
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8d 50 01             	lea    0x1(%eax),%edx
  80150d:	89 55 08             	mov    %edx,0x8(%ebp)
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8d 4a 01             	lea    0x1(%edx),%ecx
  801516:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801519:	8a 12                	mov    (%edx),%dl
  80151b:	88 10                	mov    %dl,(%eax)
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	84 c0                	test   %al,%al
  801521:	75 e4                	jne    801507 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801523:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80153b:	eb 1f                	jmp    80155c <strncpy+0x34>
		*dst++ = *src;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8d 50 01             	lea    0x1(%eax),%edx
  801543:	89 55 08             	mov    %edx,0x8(%ebp)
  801546:	8b 55 0c             	mov    0xc(%ebp),%edx
  801549:	8a 12                	mov    (%edx),%dl
  80154b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	74 03                	je     801559 <strncpy+0x31>
			src++;
  801556:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801559:	ff 45 fc             	incl   -0x4(%ebp)
  80155c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801562:	72 d9                	jb     80153d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801575:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801579:	74 30                	je     8015ab <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80157b:	eb 16                	jmp    801593 <strlcpy+0x2a>
			*dst++ = *src++;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8d 50 01             	lea    0x1(%eax),%edx
  801583:	89 55 08             	mov    %edx,0x8(%ebp)
  801586:	8b 55 0c             	mov    0xc(%ebp),%edx
  801589:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80158f:	8a 12                	mov    (%edx),%dl
  801591:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801593:	ff 4d 10             	decl   0x10(%ebp)
  801596:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80159a:	74 09                	je     8015a5 <strlcpy+0x3c>
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	84 c0                	test   %al,%al
  8015a3:	75 d8                	jne    80157d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b1:	29 c2                	sub    %eax,%edx
  8015b3:	89 d0                	mov    %edx,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ba:	eb 06                	jmp    8015c2 <strcmp+0xb>
		p++, q++;
  8015bc:	ff 45 08             	incl   0x8(%ebp)
  8015bf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	84 c0                	test   %al,%al
  8015c9:	74 0e                	je     8015d9 <strcmp+0x22>
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8a 10                	mov    (%eax),%dl
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	38 c2                	cmp    %al,%dl
  8015d7:	74 e3                	je     8015bc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8a 00                	mov    (%eax),%al
  8015de:	0f b6 d0             	movzbl %al,%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	0f b6 c0             	movzbl %al,%eax
  8015e9:	29 c2                	sub    %eax,%edx
  8015eb:	89 d0                	mov    %edx,%eax
}
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015f2:	eb 09                	jmp    8015fd <strncmp+0xe>
		n--, p++, q++;
  8015f4:	ff 4d 10             	decl   0x10(%ebp)
  8015f7:	ff 45 08             	incl   0x8(%ebp)
  8015fa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801601:	74 17                	je     80161a <strncmp+0x2b>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	84 c0                	test   %al,%al
  80160a:	74 0e                	je     80161a <strncmp+0x2b>
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 10                	mov    (%eax),%dl
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	38 c2                	cmp    %al,%dl
  801618:	74 da                	je     8015f4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 07                	jne    801627 <strncmp+0x38>
		return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	eb 14                	jmp    80163b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	0f b6 d0             	movzbl %al,%edx
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	0f b6 c0             	movzbl %al,%eax
  801637:	29 c2                	sub    %eax,%edx
  801639:	89 d0                	mov    %edx,%eax
}
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801649:	eb 12                	jmp    80165d <strchr+0x20>
		if (*s == c)
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801653:	75 05                	jne    80165a <strchr+0x1d>
			return (char *) s;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	eb 11                	jmp    80166b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80165a:	ff 45 08             	incl   0x8(%ebp)
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	84 c0                	test   %al,%al
  801664:	75 e5                	jne    80164b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801679:	eb 0d                	jmp    801688 <strfind+0x1b>
		if (*s == c)
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801683:	74 0e                	je     801693 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801685:	ff 45 08             	incl   0x8(%ebp)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	84 c0                	test   %al,%al
  80168f:	75 ea                	jne    80167b <strfind+0xe>
  801691:	eb 01                	jmp    801694 <strfind+0x27>
		if (*s == c)
			break;
  801693:	90                   	nop
	return (char *) s;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016a5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016a9:	76 63                	jbe    80170e <memset+0x75>
		uint64 data_block = c;
  8016ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ae:	99                   	cltd   
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bb:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016bf:	c1 e0 08             	shl    $0x8,%eax
  8016c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016c5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016d2:	c1 e0 10             	shl    $0x10,%eax
  8016d5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	89 c2                	mov    %eax,%edx
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016eb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016ee:	eb 18                	jmp    801708 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016f3:	8d 41 08             	lea    0x8(%ecx),%eax
  8016f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8016f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ff:	89 01                	mov    %eax,(%ecx)
  801701:	89 51 04             	mov    %edx,0x4(%ecx)
  801704:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801708:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80170c:	77 e2                	ja     8016f0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80170e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801712:	74 23                	je     801737 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801714:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801717:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80171a:	eb 0e                	jmp    80172a <memset+0x91>
			*p8++ = (uint8)c;
  80171c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171f:	8d 50 01             	lea    0x1(%eax),%edx
  801722:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80172a:	8b 45 10             	mov    0x10(%ebp),%eax
  80172d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801730:	89 55 10             	mov    %edx,0x10(%ebp)
  801733:	85 c0                	test   %eax,%eax
  801735:	75 e5                	jne    80171c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80174e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801752:	76 24                	jbe    801778 <memcpy+0x3c>
		while(n >= 8){
  801754:	eb 1c                	jmp    801772 <memcpy+0x36>
			*d64 = *s64;
  801756:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801759:	8b 50 04             	mov    0x4(%eax),%edx
  80175c:	8b 00                	mov    (%eax),%eax
  80175e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801761:	89 01                	mov    %eax,(%ecx)
  801763:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801766:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80176a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80176e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801772:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801776:	77 de                	ja     801756 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801778:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177c:	74 31                	je     8017af <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80177e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801781:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801784:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801787:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80178a:	eb 16                	jmp    8017a2 <memcpy+0x66>
			*d8++ = *s8++;
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801795:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017cc:	73 50                	jae    80181e <memmove+0x6a>
  8017ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	01 d0                	add    %edx,%eax
  8017d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d9:	76 43                	jbe    80181e <memmove+0x6a>
		s += n;
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017e7:	eb 10                	jmp    8017f9 <memmove+0x45>
			*--d = *--s;
  8017e9:	ff 4d f8             	decl   -0x8(%ebp)
  8017ec:	ff 4d fc             	decl   -0x4(%ebp)
  8017ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f2:	8a 10                	mov    (%eax),%dl
  8017f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8017f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801802:	85 c0                	test   %eax,%eax
  801804:	75 e3                	jne    8017e9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801806:	eb 23                	jmp    80182b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801808:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180b:	8d 50 01             	lea    0x1(%eax),%edx
  80180e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801811:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801814:	8d 4a 01             	lea    0x1(%edx),%ecx
  801817:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80181a:	8a 12                	mov    (%edx),%dl
  80181c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80181e:	8b 45 10             	mov    0x10(%ebp),%eax
  801821:	8d 50 ff             	lea    -0x1(%eax),%edx
  801824:	89 55 10             	mov    %edx,0x10(%ebp)
  801827:	85 c0                	test   %eax,%eax
  801829:	75 dd                	jne    801808 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80183c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801842:	eb 2a                	jmp    80186e <memcmp+0x3e>
		if (*s1 != *s2)
  801844:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801847:	8a 10                	mov    (%eax),%dl
  801849:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	38 c2                	cmp    %al,%dl
  801850:	74 16                	je     801868 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 00                	mov    (%eax),%al
  801857:	0f b6 d0             	movzbl %al,%edx
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	0f b6 c0             	movzbl %al,%eax
  801862:	29 c2                	sub    %eax,%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	eb 18                	jmp    801880 <memcmp+0x50>
		s1++, s2++;
  801868:	ff 45 fc             	incl   -0x4(%ebp)
  80186b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80186e:	8b 45 10             	mov    0x10(%ebp),%eax
  801871:	8d 50 ff             	lea    -0x1(%eax),%edx
  801874:	89 55 10             	mov    %edx,0x10(%ebp)
  801877:	85 c0                	test   %eax,%eax
  801879:	75 c9                	jne    801844 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801893:	eb 15                	jmp    8018aa <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8a 00                	mov    (%eax),%al
  80189a:	0f b6 d0             	movzbl %al,%edx
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	0f b6 c0             	movzbl %al,%eax
  8018a3:	39 c2                	cmp    %eax,%edx
  8018a5:	74 0d                	je     8018b4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018a7:	ff 45 08             	incl   0x8(%ebp)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018b0:	72 e3                	jb     801895 <memfind+0x13>
  8018b2:	eb 01                	jmp    8018b5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018b4:	90                   	nop
	return (void *) s;
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ce:	eb 03                	jmp    8018d3 <strtol+0x19>
		s++;
  8018d0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	3c 20                	cmp    $0x20,%al
  8018da:	74 f4                	je     8018d0 <strtol+0x16>
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8a 00                	mov    (%eax),%al
  8018e1:	3c 09                	cmp    $0x9,%al
  8018e3:	74 eb                	je     8018d0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	8a 00                	mov    (%eax),%al
  8018ea:	3c 2b                	cmp    $0x2b,%al
  8018ec:	75 05                	jne    8018f3 <strtol+0x39>
		s++;
  8018ee:	ff 45 08             	incl   0x8(%ebp)
  8018f1:	eb 13                	jmp    801906 <strtol+0x4c>
	else if (*s == '-')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 2d                	cmp    $0x2d,%al
  8018fa:	75 0a                	jne    801906 <strtol+0x4c>
		s++, neg = 1;
  8018fc:	ff 45 08             	incl   0x8(%ebp)
  8018ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801906:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80190a:	74 06                	je     801912 <strtol+0x58>
  80190c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801910:	75 20                	jne    801932 <strtol+0x78>
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	3c 30                	cmp    $0x30,%al
  801919:	75 17                	jne    801932 <strtol+0x78>
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	40                   	inc    %eax
  80191f:	8a 00                	mov    (%eax),%al
  801921:	3c 78                	cmp    $0x78,%al
  801923:	75 0d                	jne    801932 <strtol+0x78>
		s += 2, base = 16;
  801925:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801929:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801930:	eb 28                	jmp    80195a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801932:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801936:	75 15                	jne    80194d <strtol+0x93>
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	3c 30                	cmp    $0x30,%al
  80193f:	75 0c                	jne    80194d <strtol+0x93>
		s++, base = 8;
  801941:	ff 45 08             	incl   0x8(%ebp)
  801944:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80194b:	eb 0d                	jmp    80195a <strtol+0xa0>
	else if (base == 0)
  80194d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801951:	75 07                	jne    80195a <strtol+0xa0>
		base = 10;
  801953:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	8a 00                	mov    (%eax),%al
  80195f:	3c 2f                	cmp    $0x2f,%al
  801961:	7e 19                	jle    80197c <strtol+0xc2>
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8a 00                	mov    (%eax),%al
  801968:	3c 39                	cmp    $0x39,%al
  80196a:	7f 10                	jg     80197c <strtol+0xc2>
			dig = *s - '0';
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	0f be c0             	movsbl %al,%eax
  801974:	83 e8 30             	sub    $0x30,%eax
  801977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80197a:	eb 42                	jmp    8019be <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	3c 60                	cmp    $0x60,%al
  801983:	7e 19                	jle    80199e <strtol+0xe4>
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	3c 7a                	cmp    $0x7a,%al
  80198c:	7f 10                	jg     80199e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	8a 00                	mov    (%eax),%al
  801993:	0f be c0             	movsbl %al,%eax
  801996:	83 e8 57             	sub    $0x57,%eax
  801999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199c:	eb 20                	jmp    8019be <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8a 00                	mov    (%eax),%al
  8019a3:	3c 40                	cmp    $0x40,%al
  8019a5:	7e 39                	jle    8019e0 <strtol+0x126>
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	3c 5a                	cmp    $0x5a,%al
  8019ae:	7f 30                	jg     8019e0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8a 00                	mov    (%eax),%al
  8019b5:	0f be c0             	movsbl %al,%eax
  8019b8:	83 e8 37             	sub    $0x37,%eax
  8019bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019c4:	7d 19                	jge    8019df <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019c6:	ff 45 08             	incl   0x8(%ebp)
  8019c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019cc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d5:	01 d0                	add    %edx,%eax
  8019d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019da:	e9 7b ff ff ff       	jmp    80195a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019df:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e4:	74 08                	je     8019ee <strtol+0x134>
		*endptr = (char *) s;
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ec:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f2:	74 07                	je     8019fb <strtol+0x141>
  8019f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f7:	f7 d8                	neg    %eax
  8019f9:	eb 03                	jmp    8019fe <strtol+0x144>
  8019fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <ltostr>:

void
ltostr(long value, char *str)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a18:	79 13                	jns    801a2d <ltostr+0x2d>
	{
		neg = 1;
  801a1a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a27:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a2a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a35:	99                   	cltd   
  801a36:	f7 f9                	idiv   %ecx
  801a38:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3e:	8d 50 01             	lea    0x1(%eax),%edx
  801a41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a4e:	83 c2 30             	add    $0x30,%edx
  801a51:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a56:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a5b:	f7 e9                	imul   %ecx
  801a5d:	c1 fa 02             	sar    $0x2,%edx
  801a60:	89 c8                	mov    %ecx,%eax
  801a62:	c1 f8 1f             	sar    $0x1f,%eax
  801a65:	29 c2                	sub    %eax,%edx
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a70:	75 bb                	jne    801a2d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7c:	48                   	dec    %eax
  801a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a84:	74 3d                	je     801ac3 <ltostr+0xc3>
		start = 1 ;
  801a86:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a8d:	eb 34                	jmp    801ac3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	01 d0                	add    %edx,%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	01 c8                	add    %ecx,%eax
  801aac:	8a 00                	mov    (%eax),%al
  801aae:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ab0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab6:	01 c2                	add    %eax,%edx
  801ab8:	8a 45 eb             	mov    -0x15(%ebp),%al
  801abb:	88 02                	mov    %al,(%edx)
		start++ ;
  801abd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ac0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ac9:	7c c4                	jl     801a8f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801acb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	e8 c4 f9 ff ff       	call   8014ab <strlen>
  801ae7:	83 c4 04             	add    $0x4,%esp
  801aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	e8 b6 f9 ff ff       	call   8014ab <strlen>
  801af5:	83 c4 04             	add    $0x4,%esp
  801af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801afb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b09:	eb 17                	jmp    801b22 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b11:	01 c2                	add    %eax,%edx
  801b13:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	01 c8                	add    %ecx,%eax
  801b1b:	8a 00                	mov    (%eax),%al
  801b1d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b1f:	ff 45 fc             	incl   -0x4(%ebp)
  801b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b28:	7c e1                	jl     801b0b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b38:	eb 1f                	jmp    801b59 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b3d:	8d 50 01             	lea    0x1(%eax),%edx
  801b40:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b43:	89 c2                	mov    %eax,%edx
  801b45:	8b 45 10             	mov    0x10(%ebp),%eax
  801b48:	01 c2                	add    %eax,%edx
  801b4a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b50:	01 c8                	add    %ecx,%eax
  801b52:	8a 00                	mov    (%eax),%al
  801b54:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b56:	ff 45 f8             	incl   -0x8(%ebp)
  801b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b5f:	7c d9                	jl     801b3a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b64:	8b 45 10             	mov    0x10(%ebp),%eax
  801b67:	01 d0                	add    %edx,%eax
  801b69:	c6 00 00             	movb   $0x0,(%eax)
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b72:	8b 45 14             	mov    0x14(%ebp),%eax
  801b75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7e:	8b 00                	mov    (%eax),%eax
  801b80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	01 d0                	add    %edx,%eax
  801b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b92:	eb 0c                	jmp    801ba0 <strsplit+0x31>
			*string++ = 0;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8d 50 01             	lea    0x1(%eax),%edx
  801b9a:	89 55 08             	mov    %edx,0x8(%ebp)
  801b9d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	8a 00                	mov    (%eax),%al
  801ba5:	84 c0                	test   %al,%al
  801ba7:	74 18                	je     801bc1 <strsplit+0x52>
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	8a 00                	mov    (%eax),%al
  801bae:	0f be c0             	movsbl %al,%eax
  801bb1:	50                   	push   %eax
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	e8 83 fa ff ff       	call   80163d <strchr>
  801bba:	83 c4 08             	add    $0x8,%esp
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	75 d3                	jne    801b94 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	8a 00                	mov    (%eax),%al
  801bc6:	84 c0                	test   %al,%al
  801bc8:	74 5a                	je     801c24 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bca:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcd:	8b 00                	mov    (%eax),%eax
  801bcf:	83 f8 0f             	cmp    $0xf,%eax
  801bd2:	75 07                	jne    801bdb <strsplit+0x6c>
		{
			return 0;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	eb 66                	jmp    801c41 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	8d 48 01             	lea    0x1(%eax),%ecx
  801be3:	8b 55 14             	mov    0x14(%ebp),%edx
  801be6:	89 0a                	mov    %ecx,(%edx)
  801be8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bef:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf2:	01 c2                	add    %eax,%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801bf9:	eb 03                	jmp    801bfe <strsplit+0x8f>
			string++;
  801bfb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	8a 00                	mov    (%eax),%al
  801c03:	84 c0                	test   %al,%al
  801c05:	74 8b                	je     801b92 <strsplit+0x23>
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	8a 00                	mov    (%eax),%al
  801c0c:	0f be c0             	movsbl %al,%eax
  801c0f:	50                   	push   %eax
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 25 fa ff ff       	call   80163d <strchr>
  801c18:	83 c4 08             	add    $0x8,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	74 dc                	je     801bfb <strsplit+0x8c>
			string++;
	}
  801c1f:	e9 6e ff ff ff       	jmp    801b92 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c24:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c25:	8b 45 14             	mov    0x14(%ebp),%eax
  801c28:	8b 00                	mov    (%eax),%eax
  801c2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 d0                	add    %edx,%eax
  801c36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c56:	eb 4a                	jmp    801ca2 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	01 c2                	add    %eax,%edx
  801c60:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c66:	01 c8                	add    %ecx,%eax
  801c68:	8a 00                	mov    (%eax),%al
  801c6a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	01 d0                	add    %edx,%eax
  801c74:	8a 00                	mov    (%eax),%al
  801c76:	3c 40                	cmp    $0x40,%al
  801c78:	7e 25                	jle    801c9f <str2lower+0x5c>
  801c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	8a 00                	mov    (%eax),%al
  801c84:	3c 5a                	cmp    $0x5a,%al
  801c86:	7f 17                	jg     801c9f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	01 d0                	add    %edx,%eax
  801c90:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c93:	8b 55 08             	mov    0x8(%ebp),%edx
  801c96:	01 ca                	add    %ecx,%edx
  801c98:	8a 12                	mov    (%edx),%dl
  801c9a:	83 c2 20             	add    $0x20,%edx
  801c9d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801c9f:	ff 45 fc             	incl   -0x4(%ebp)
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	e8 01 f8 ff ff       	call   8014ab <strlen>
  801caa:	83 c4 04             	add    $0x4,%esp
  801cad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cb0:	7f a6                	jg     801c58 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801cbd:	a1 08 40 80 00       	mov    0x804008,%eax
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	74 42                	je     801d08 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	68 00 00 00 82       	push   $0x82000000
  801cce:	68 00 00 00 80       	push   $0x80000000
  801cd3:	e8 00 08 00 00       	call   8024d8 <initialize_dynamic_allocator>
  801cd8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cdb:	e8 e7 05 00 00       	call   8022c7 <sys_get_uheap_strategy>
  801ce0:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ce5:	a1 40 40 80 00       	mov    0x804040,%eax
  801cea:	05 00 10 00 00       	add    $0x1000,%eax
  801cef:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cf4:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801cf9:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801cfe:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801d05:	00 00 00 
	}
}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	68 06 04 00 00       	push   $0x406
  801d27:	50                   	push   %eax
  801d28:	e8 e4 01 00 00       	call   801f11 <__sys_allocate_page>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d37:	79 14                	jns    801d4d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d39:	83 ec 04             	sub    $0x4,%esp
  801d3c:	68 7c 39 80 00       	push   $0x80397c
  801d41:	6a 1f                	push   $0x1f
  801d43:	68 b8 39 80 00       	push   $0x8039b8
  801d48:	e8 af eb ff ff       	call   8008fc <_panic>
	return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	50                   	push   %eax
  801d6c:	e8 e7 01 00 00       	call   801f58 <__sys_unmap_frame>
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7b:	79 14                	jns    801d91 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	68 c4 39 80 00       	push   $0x8039c4
  801d85:	6a 2a                	push   $0x2a
  801d87:	68 b8 39 80 00       	push   $0x8039b8
  801d8c:	e8 6b eb ff ff       	call   8008fc <_panic>
}
  801d91:	90                   	nop
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d9a:	e8 18 ff ff ff       	call   801cb7 <uheap_init>
	if (size == 0) return NULL ;
  801d9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801da3:	75 07                	jne    801dac <malloc+0x18>
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
  801daa:	eb 14                	jmp    801dc0 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 04 3a 80 00       	push   $0x803a04
  801db4:	6a 3e                	push   $0x3e
  801db6:	68 b8 39 80 00       	push   $0x8039b8
  801dbb:	e8 3c eb ff ff       	call   8008fc <_panic>
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	68 2c 3a 80 00       	push   $0x803a2c
  801dd0:	6a 49                	push   $0x49
  801dd2:	68 b8 39 80 00       	push   $0x8039b8
  801dd7:	e8 20 eb ff ff       	call   8008fc <_panic>

00801ddc <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 18             	sub    $0x18,%esp
  801de2:	8b 45 10             	mov    0x10(%ebp),%eax
  801de5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801de8:	e8 ca fe ff ff       	call   801cb7 <uheap_init>
	if (size == 0) return NULL ;
  801ded:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801df1:	75 07                	jne    801dfa <smalloc+0x1e>
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
  801df8:	eb 14                	jmp    801e0e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 50 3a 80 00       	push   $0x803a50
  801e02:	6a 5a                	push   $0x5a
  801e04:	68 b8 39 80 00       	push   $0x8039b8
  801e09:	e8 ee ea ff ff       	call   8008fc <_panic>
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e16:	e8 9c fe ff ff       	call   801cb7 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801e1b:	83 ec 04             	sub    $0x4,%esp
  801e1e:	68 78 3a 80 00       	push   $0x803a78
  801e23:	6a 6a                	push   $0x6a
  801e25:	68 b8 39 80 00       	push   $0x8039b8
  801e2a:	e8 cd ea ff ff       	call   8008fc <_panic>

00801e2f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e35:	e8 7d fe ff ff       	call   801cb7 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 9c 3a 80 00       	push   $0x803a9c
  801e42:	68 88 00 00 00       	push   $0x88
  801e47:	68 b8 39 80 00       	push   $0x8039b8
  801e4c:	e8 ab ea ff ff       	call   8008fc <_panic>

00801e51 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 c4 3a 80 00       	push   $0x803ac4
  801e5f:	68 9b 00 00 00       	push   $0x9b
  801e64:	68 b8 39 80 00       	push   $0x8039b8
  801e69:	e8 8e ea ff ff       	call   8008fc <_panic>

00801e6e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	57                   	push   %edi
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
  801e74:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e83:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e86:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e89:	cd 30                	int    $0x30
  801e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ea5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	51                   	push   %ecx
  801eb2:	52                   	push   %edx
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	50                   	push   %eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	e8 b0 ff ff ff       	call   801e6e <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 02                	push   $0x2
  801ed3:	e8 96 ff ff ff       	call   801e6e <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_lock_cons>:

void sys_lock_cons(void)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 03                	push   $0x3
  801eec:	e8 7d ff ff ff       	call   801e6e <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	90                   	nop
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 04                	push   $0x4
  801f06:	e8 63 ff ff ff       	call   801e6e <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	90                   	nop
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	52                   	push   %edx
  801f21:	50                   	push   %eax
  801f22:	6a 08                	push   $0x8
  801f24:	e8 45 ff ff ff       	call   801e6e <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	56                   	push   %esi
  801f32:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f33:	8b 75 18             	mov    0x18(%ebp),%esi
  801f36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
  801f44:	51                   	push   %ecx
  801f45:	52                   	push   %edx
  801f46:	50                   	push   %eax
  801f47:	6a 09                	push   $0x9
  801f49:	e8 20 ff ff ff       	call   801e6e <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	ff 75 08             	pushl  0x8(%ebp)
  801f66:	6a 0a                	push   $0xa
  801f68:	e8 01 ff ff ff       	call   801e6e <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	6a 0b                	push   $0xb
  801f83:	e8 e6 fe ff ff       	call   801e6e <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 0c                	push   $0xc
  801f9c:	e8 cd fe ff ff       	call   801e6e <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 0d                	push   $0xd
  801fb5:	e8 b4 fe ff ff       	call   801e6e <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 0e                	push   $0xe
  801fce:	e8 9b fe ff ff       	call   801e6e <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 0f                	push   $0xf
  801fe7:	e8 82 fe ff ff       	call   801e6e <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	6a 10                	push   $0x10
  802001:	e8 68 fe ff ff       	call   801e6e <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 11                	push   $0x11
  80201a:	e8 4f fe ff ff       	call   801e6e <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	90                   	nop
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_cputc>:

void
sys_cputc(const char c)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802031:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	50                   	push   %eax
  80203e:	6a 01                	push   $0x1
  802040:	e8 29 fe ff ff       	call   801e6e <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	90                   	nop
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 14                	push   $0x14
  80205a:	e8 0f fe ff ff       	call   801e6e <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	8b 45 10             	mov    0x10(%ebp),%eax
  80206e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802071:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802074:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	6a 00                	push   $0x0
  80207d:	51                   	push   %ecx
  80207e:	52                   	push   %edx
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	50                   	push   %eax
  802083:	6a 15                	push   $0x15
  802085:	e8 e4 fd ff ff       	call   801e6e <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	6a 16                	push   $0x16
  8020a2:	e8 c7 fd ff ff       	call   801e6e <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	51                   	push   %ecx
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 17                	push   $0x17
  8020c1:	e8 a8 fd ff ff       	call   801e6e <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	52                   	push   %edx
  8020db:	50                   	push   %eax
  8020dc:	6a 18                	push   $0x18
  8020de:	e8 8b fd ff ff       	call   801e6e <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	ff 75 14             	pushl  0x14(%ebp)
  8020f3:	ff 75 10             	pushl  0x10(%ebp)
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	50                   	push   %eax
  8020fa:	6a 19                	push   $0x19
  8020fc:	e8 6d fd ff ff       	call   801e6e <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	50                   	push   %eax
  802115:	6a 1a                	push   $0x1a
  802117:	e8 52 fd ff ff       	call   801e6e <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	50                   	push   %eax
  802131:	6a 1b                	push   $0x1b
  802133:	e8 36 fd ff ff       	call   801e6e <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 05                	push   $0x5
  80214c:	e8 1d fd ff ff       	call   801e6e <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 06                	push   $0x6
  802165:	e8 04 fd ff ff       	call   801e6e <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 07                	push   $0x7
  80217e:	e8 eb fc ff ff       	call   801e6e <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_exit_env>:


void sys_exit_env(void)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 1c                	push   $0x1c
  802197:	e8 d2 fc ff ff       	call   801e6e <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	90                   	nop
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021ab:	8d 50 04             	lea    0x4(%eax),%edx
  8021ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	52                   	push   %edx
  8021b8:	50                   	push   %eax
  8021b9:	6a 1d                	push   $0x1d
  8021bb:	e8 ae fc ff ff       	call   801e6e <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
	return result;
  8021c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021cc:	89 01                	mov    %eax,(%ecx)
  8021ce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	c9                   	leave  
  8021d5:	c2 04 00             	ret    $0x4

008021d8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 10             	pushl  0x10(%ebp)
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	6a 13                	push   $0x13
  8021ea:	e8 7f fc ff ff       	call   801e6e <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f2:	90                   	nop
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 1e                	push   $0x1e
  802204:	e8 65 fc ff ff       	call   801e6e <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80221a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	50                   	push   %eax
  802227:	6a 1f                	push   $0x1f
  802229:	e8 40 fc ff ff       	call   801e6e <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
	return ;
  802231:	90                   	nop
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <rsttst>:
void rsttst()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 21                	push   $0x21
  802243:	e8 26 fc ff ff       	call   801e6e <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
	return ;
  80224b:	90                   	nop
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	8b 45 14             	mov    0x14(%ebp),%eax
  802257:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80225a:	8b 55 18             	mov    0x18(%ebp),%edx
  80225d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802261:	52                   	push   %edx
  802262:	50                   	push   %eax
  802263:	ff 75 10             	pushl  0x10(%ebp)
  802266:	ff 75 0c             	pushl  0xc(%ebp)
  802269:	ff 75 08             	pushl  0x8(%ebp)
  80226c:	6a 20                	push   $0x20
  80226e:	e8 fb fb ff ff       	call   801e6e <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
	return ;
  802276:	90                   	nop
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <chktst>:
void chktst(uint32 n)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	6a 22                	push   $0x22
  802289:	e8 e0 fb ff ff       	call   801e6e <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
	return ;
  802291:	90                   	nop
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <inctst>:

void inctst()
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 23                	push   $0x23
  8022a3:	e8 c6 fb ff ff       	call   801e6e <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ab:	90                   	nop
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <gettst>:
uint32 gettst()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 24                	push   $0x24
  8022bd:	e8 ac fb ff ff       	call   801e6e <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 25                	push   $0x25
  8022d6:	e8 93 fb ff ff       	call   801e6e <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
  8022de:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8022e3:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	ff 75 08             	pushl  0x8(%ebp)
  802300:	6a 26                	push   $0x26
  802302:	e8 67 fb ff ff       	call   801e6e <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
	return ;
  80230a:	90                   	nop
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802311:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802314:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	53                   	push   %ebx
  802320:	51                   	push   %ecx
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	6a 27                	push   $0x27
  802325:	e8 44 fb ff ff       	call   801e6e <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802335:	8b 55 0c             	mov    0xc(%ebp),%edx
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	52                   	push   %edx
  802342:	50                   	push   %eax
  802343:	6a 28                	push   $0x28
  802345:	e8 24 fb ff ff       	call   801e6e <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802352:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802355:	8b 55 0c             	mov    0xc(%ebp),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	51                   	push   %ecx
  80235e:	ff 75 10             	pushl  0x10(%ebp)
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	6a 29                	push   $0x29
  802365:	e8 04 fb ff ff       	call   801e6e <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	ff 75 10             	pushl  0x10(%ebp)
  802379:	ff 75 0c             	pushl  0xc(%ebp)
  80237c:	ff 75 08             	pushl  0x8(%ebp)
  80237f:	6a 12                	push   $0x12
  802381:	e8 e8 fa ff ff       	call   801e6e <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
	return ;
  802389:	90                   	nop
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80238f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	52                   	push   %edx
  80239c:	50                   	push   %eax
  80239d:	6a 2a                	push   $0x2a
  80239f:	e8 ca fa ff ff       	call   801e6e <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
	return;
  8023a7:	90                   	nop
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 2b                	push   $0x2b
  8023b9:	e8 b0 fa ff ff       	call   801e6e <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	ff 75 0c             	pushl  0xc(%ebp)
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	6a 2d                	push   $0x2d
  8023d4:	e8 95 fa ff ff       	call   801e6e <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	6a 2c                	push   $0x2c
  8023f0:	e8 79 fa ff ff       	call   801e6e <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f8:	90                   	nop
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 e8 3a 80 00       	push   $0x803ae8
  802409:	68 25 01 00 00       	push   $0x125
  80240e:	68 1b 3b 80 00       	push   $0x803b1b
  802413:	e8 e4 e4 ff ff       	call   8008fc <_panic>

00802418 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80241e:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802425:	72 09                	jb     802430 <to_page_va+0x18>
  802427:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  80242e:	72 14                	jb     802444 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 2c 3b 80 00       	push   $0x803b2c
  802438:	6a 15                	push   $0x15
  80243a:	68 57 3b 80 00       	push   $0x803b57
  80243f:	e8 b8 e4 ff ff       	call   8008fc <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	ba 60 40 80 00       	mov    $0x804060,%edx
  80244c:	29 d0                	sub    %edx,%eax
  80244e:	c1 f8 02             	sar    $0x2,%eax
  802451:	89 c2                	mov    %eax,%edx
  802453:	89 d0                	mov    %edx,%eax
  802455:	c1 e0 02             	shl    $0x2,%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c1 e0 02             	shl    $0x2,%eax
  80245d:	01 d0                	add    %edx,%eax
  80245f:	c1 e0 02             	shl    $0x2,%eax
  802462:	01 d0                	add    %edx,%eax
  802464:	89 c1                	mov    %eax,%ecx
  802466:	c1 e1 08             	shl    $0x8,%ecx
  802469:	01 c8                	add    %ecx,%eax
  80246b:	89 c1                	mov    %eax,%ecx
  80246d:	c1 e1 10             	shl    $0x10,%ecx
  802470:	01 c8                	add    %ecx,%eax
  802472:	01 c0                	add    %eax,%eax
  802474:	01 d0                	add    %edx,%eax
  802476:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	c1 e0 0c             	shl    $0xc,%eax
  80247f:	89 c2                	mov    %eax,%edx
  802481:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802486:	01 d0                	add    %edx,%eax
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802490:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802495:	8b 55 08             	mov    0x8(%ebp),%edx
  802498:	29 c2                	sub    %eax,%edx
  80249a:	89 d0                	mov    %edx,%eax
  80249c:	c1 e8 0c             	shr    $0xc,%eax
  80249f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	78 09                	js     8024b1 <to_page_info+0x27>
  8024a8:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8024af:	7e 14                	jle    8024c5 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8024b1:	83 ec 04             	sub    $0x4,%esp
  8024b4:	68 70 3b 80 00       	push   $0x803b70
  8024b9:	6a 22                	push   $0x22
  8024bb:	68 57 3b 80 00       	push   $0x803b57
  8024c0:	e8 37 e4 ff ff       	call   8008fc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8024c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	01 c0                	add    %eax,%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c1 e0 02             	shl    $0x2,%eax
  8024d1:	05 60 40 80 00       	add    $0x804060,%eax
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	05 00 00 00 02       	add    $0x2000000,%eax
  8024e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024e9:	73 16                	jae    802501 <initialize_dynamic_allocator+0x29>
  8024eb:	68 94 3b 80 00       	push   $0x803b94
  8024f0:	68 ba 3b 80 00       	push   $0x803bba
  8024f5:	6a 34                	push   $0x34
  8024f7:	68 57 3b 80 00       	push   $0x803b57
  8024fc:	e8 fb e3 ff ff       	call   8008fc <_panic>
		is_initialized = 1;
  802501:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802508:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802513:	8b 45 0c             	mov    0xc(%ebp),%eax
  802516:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80251b:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802522:	00 00 00 
  802525:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80252c:	00 00 00 
  80252f:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802536:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253c:	2b 45 08             	sub    0x8(%ebp),%eax
  80253f:	c1 e8 0c             	shr    $0xc,%eax
  802542:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802545:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80254c:	e9 c8 00 00 00       	jmp    802619 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	89 d0                	mov    %edx,%eax
  802556:	01 c0                	add    %eax,%eax
  802558:	01 d0                	add    %edx,%eax
  80255a:	c1 e0 02             	shl    $0x2,%eax
  80255d:	05 68 40 80 00       	add    $0x804068,%eax
  802562:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	01 c0                	add    %eax,%eax
  80256e:	01 d0                	add    %edx,%eax
  802570:	c1 e0 02             	shl    $0x2,%eax
  802573:	05 6a 40 80 00       	add    $0x80406a,%eax
  802578:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80257d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802583:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802586:	89 c8                	mov    %ecx,%eax
  802588:	01 c0                	add    %eax,%eax
  80258a:	01 c8                	add    %ecx,%eax
  80258c:	c1 e0 02             	shl    $0x2,%eax
  80258f:	05 64 40 80 00       	add    $0x804064,%eax
  802594:	89 10                	mov    %edx,(%eax)
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	89 d0                	mov    %edx,%eax
  80259b:	01 c0                	add    %eax,%eax
  80259d:	01 d0                	add    %edx,%eax
  80259f:	c1 e0 02             	shl    $0x2,%eax
  8025a2:	05 64 40 80 00       	add    $0x804064,%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 1b                	je     8025c8 <initialize_dynamic_allocator+0xf0>
  8025ad:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025b6:	89 c8                	mov    %ecx,%eax
  8025b8:	01 c0                	add    %eax,%eax
  8025ba:	01 c8                	add    %ecx,%eax
  8025bc:	c1 e0 02             	shl    $0x2,%eax
  8025bf:	05 60 40 80 00       	add    $0x804060,%eax
  8025c4:	89 02                	mov    %eax,(%edx)
  8025c6:	eb 16                	jmp    8025de <initialize_dynamic_allocator+0x106>
  8025c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	01 c0                	add    %eax,%eax
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	c1 e0 02             	shl    $0x2,%eax
  8025d4:	05 60 40 80 00       	add    $0x804060,%eax
  8025d9:	a3 48 40 80 00       	mov    %eax,0x804048
  8025de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e1:	89 d0                	mov    %edx,%eax
  8025e3:	01 c0                	add    %eax,%eax
  8025e5:	01 d0                	add    %edx,%eax
  8025e7:	c1 e0 02             	shl    $0x2,%eax
  8025ea:	05 60 40 80 00       	add    $0x804060,%eax
  8025ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8025f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f7:	89 d0                	mov    %edx,%eax
  8025f9:	01 c0                	add    %eax,%eax
  8025fb:	01 d0                	add    %edx,%eax
  8025fd:	c1 e0 02             	shl    $0x2,%eax
  802600:	05 60 40 80 00       	add    $0x804060,%eax
  802605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260b:	a1 54 40 80 00       	mov    0x804054,%eax
  802610:	40                   	inc    %eax
  802611:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802616:	ff 45 f4             	incl   -0xc(%ebp)
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80261f:	0f 8c 2c ff ff ff    	jl     802551 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802625:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80262c:	eb 36                	jmp    802664 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	c1 e0 04             	shl    $0x4,%eax
  802634:	05 80 c0 81 00       	add    $0x81c080,%eax
  802639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	c1 e0 04             	shl    $0x4,%eax
  802645:	05 84 c0 81 00       	add    $0x81c084,%eax
  80264a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802653:	c1 e0 04             	shl    $0x4,%eax
  802656:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80265b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802661:	ff 45 f0             	incl   -0x10(%ebp)
  802664:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802668:	7e c4                	jle    80262e <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80266a:	90                   	nop
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	83 ec 0c             	sub    $0xc,%esp
  802679:	50                   	push   %eax
  80267a:	e8 0b fe ff ff       	call   80248a <to_page_info>
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 08             	mov    0x8(%eax),%eax
  80268b:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802696:	83 ec 0c             	sub    $0xc,%esp
  802699:	ff 75 0c             	pushl  0xc(%ebp)
  80269c:	e8 77 fd ff ff       	call   802418 <to_page_va>
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8026a7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b1:	f7 75 08             	divl   0x8(%ebp)
  8026b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8026b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ba:	83 ec 0c             	sub    $0xc,%esp
  8026bd:	50                   	push   %eax
  8026be:	e8 48 f6 ff ff       	call   801d0b <get_page>
  8026c3:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8026c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cc:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d6:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8026da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8026e1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8026e8:	eb 19                	jmp    802703 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ed:	ba 01 00 00 00       	mov    $0x1,%edx
  8026f2:	88 c1                	mov    %al,%cl
  8026f4:	d3 e2                	shl    %cl,%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fb:	74 0e                	je     80270b <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8026fd:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802700:	ff 45 f0             	incl   -0x10(%ebp)
  802703:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802707:	7e e1                	jle    8026ea <split_page_to_blocks+0x5a>
  802709:	eb 01                	jmp    80270c <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80270b:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80270c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802713:	e9 a7 00 00 00       	jmp    8027bf <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	0f af 45 08          	imul   0x8(%ebp),%eax
  80271f:	89 c2                	mov    %eax,%edx
  802721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802724:	01 d0                	add    %edx,%eax
  802726:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802729:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80272d:	75 14                	jne    802743 <split_page_to_blocks+0xb3>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 d0 3b 80 00       	push   $0x803bd0
  802737:	6a 7c                	push   $0x7c
  802739:	68 57 3b 80 00       	push   $0x803b57
  80273e:	e8 b9 e1 ff ff       	call   8008fc <_panic>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	c1 e0 04             	shl    $0x4,%eax
  802749:	05 84 c0 81 00       	add    $0x81c084,%eax
  80274e:	8b 10                	mov    (%eax),%edx
  802750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802753:	89 50 04             	mov    %edx,0x4(%eax)
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 14                	je     802774 <split_page_to_blocks+0xe4>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	c1 e0 04             	shl    $0x4,%eax
  802766:	05 84 c0 81 00       	add    $0x81c084,%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802770:	89 10                	mov    %edx,(%eax)
  802772:	eb 11                	jmp    802785 <split_page_to_blocks+0xf5>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	c1 e0 04             	shl    $0x4,%eax
  80277a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802783:	89 02                	mov    %eax,(%edx)
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	c1 e0 04             	shl    $0x4,%eax
  80278b:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802794:	89 02                	mov    %eax,(%edx)
  802796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c1 e0 04             	shl    $0x4,%eax
  8027a5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	8d 50 01             	lea    0x1(%eax),%edx
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c1 e0 04             	shl    $0x4,%eax
  8027b5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027ba:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8027bc:	ff 45 ec             	incl   -0x14(%ebp)
  8027bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8027c5:	0f 82 4d ff ff ff    	jb     802718 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8027cb:	90                   	nop
  8027cc:	c9                   	leave  
  8027cd:	c3                   	ret    

008027ce <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8027d4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8027db:	76 19                	jbe    8027f6 <alloc_block+0x28>
  8027dd:	68 f4 3b 80 00       	push   $0x803bf4
  8027e2:	68 ba 3b 80 00       	push   $0x803bba
  8027e7:	68 8a 00 00 00       	push   $0x8a
  8027ec:	68 57 3b 80 00       	push   $0x803b57
  8027f1:	e8 06 e1 ff ff       	call   8008fc <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8027f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8027fd:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802804:	eb 19                	jmp    80281f <alloc_block+0x51>
		if((1 << i) >= size) break;
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	ba 01 00 00 00       	mov    $0x1,%edx
  80280e:	88 c1                	mov    %al,%cl
  802810:	d3 e2                	shl    %cl,%edx
  802812:	89 d0                	mov    %edx,%eax
  802814:	3b 45 08             	cmp    0x8(%ebp),%eax
  802817:	73 0e                	jae    802827 <alloc_block+0x59>
		idx++;
  802819:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80281c:	ff 45 f0             	incl   -0x10(%ebp)
  80281f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802823:	7e e1                	jle    802806 <alloc_block+0x38>
  802825:	eb 01                	jmp    802828 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802827:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	c1 e0 04             	shl    $0x4,%eax
  80282e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	0f 84 df 00 00 00    	je     80291c <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	c1 e0 04             	shl    $0x4,%eax
  802843:	05 80 c0 81 00       	add    $0x81c080,%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80284d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802851:	75 17                	jne    80286a <alloc_block+0x9c>
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	68 15 3c 80 00       	push   $0x803c15
  80285b:	68 9e 00 00 00       	push   $0x9e
  802860:	68 57 3b 80 00       	push   $0x803b57
  802865:	e8 92 e0 ff ff       	call   8008fc <_panic>
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 10                	je     802883 <alloc_block+0xb5>
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287b:	8b 52 04             	mov    0x4(%edx),%edx
  80287e:	89 50 04             	mov    %edx,0x4(%eax)
  802881:	eb 14                	jmp    802897 <alloc_block+0xc9>
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	8b 40 04             	mov    0x4(%eax),%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	c1 e2 04             	shl    $0x4,%edx
  80288f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802895:	89 02                	mov    %eax,(%edx)
  802897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0f                	je     8028b0 <alloc_block+0xe2>
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028aa:	8b 12                	mov    (%edx),%edx
  8028ac:	89 10                	mov    %edx,(%eax)
  8028ae:	eb 13                	jmp    8028c3 <alloc_block+0xf5>
  8028b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	c1 e2 04             	shl    $0x4,%edx
  8028bb:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8028c1:	89 02                	mov    %eax,(%edx)
  8028c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c1 e0 04             	shl    $0x4,%eax
  8028dc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c1 e0 04             	shl    $0x4,%eax
  8028ec:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028f1:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	83 ec 0c             	sub    $0xc,%esp
  8028f9:	50                   	push   %eax
  8028fa:	e8 8b fb ff ff       	call   80248a <to_page_info>
  8028ff:	83 c4 10             	add    $0x10,%esp
  802902:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802908:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80290c:	48                   	dec    %eax
  80290d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802910:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802917:	e9 bc 02 00 00       	jmp    802bd8 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80291c:	a1 54 40 80 00       	mov    0x804054,%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	0f 84 7d 02 00 00    	je     802ba6 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802929:	a1 48 40 80 00       	mov    0x804048,%eax
  80292e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802935:	75 17                	jne    80294e <alloc_block+0x180>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 15 3c 80 00       	push   $0x803c15
  80293f:	68 a9 00 00 00       	push   $0xa9
  802944:	68 57 3b 80 00       	push   $0x803b57
  802949:	e8 ae df ff ff       	call   8008fc <_panic>
  80294e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block+0x199>
  802957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block+0x1a4>
  802967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block+0x1bd>
  80297c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block+0x1c7>
  80298b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 48 40 80 00       	mov    %eax,0x804048
  802995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 54 40 80 00       	mov    0x804054,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	83 c0 03             	add    $0x3,%eax
  8029b9:	ba 01 00 00 00       	mov    $0x1,%edx
  8029be:	88 c1                	mov    %al,%cl
  8029c0:	d3 e2                	shl    %cl,%edx
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	83 ec 08             	sub    $0x8,%esp
  8029c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ca:	50                   	push   %eax
  8029cb:	e8 c0 fc ff ff       	call   802690 <split_page_to_blocks>
  8029d0:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	c1 e0 04             	shl    $0x4,%eax
  8029d9:	05 80 c0 81 00       	add    $0x81c080,%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8029e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029e7:	75 17                	jne    802a00 <alloc_block+0x232>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 15 3c 80 00       	push   $0x803c15
  8029f1:	68 b0 00 00 00       	push   $0xb0
  8029f6:	68 57 3b 80 00       	push   $0x803b57
  8029fb:	e8 fc de ff ff       	call   8008fc <_panic>
  802a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 10                	je     802a19 <alloc_block+0x24b>
  802a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a11:	8b 52 04             	mov    0x4(%edx),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	eb 14                	jmp    802a2d <alloc_block+0x25f>
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a22:	c1 e2 04             	shl    $0x4,%edx
  802a25:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802a2b:	89 02                	mov    %eax,(%edx)
  802a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0f                	je     802a46 <alloc_block+0x278>
  802a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a40:	8b 12                	mov    (%edx),%edx
  802a42:	89 10                	mov    %edx,(%eax)
  802a44:	eb 13                	jmp    802a59 <alloc_block+0x28b>
  802a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4e:	c1 e2 04             	shl    $0x4,%edx
  802a51:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802a57:	89 02                	mov    %eax,(%edx)
  802a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	c1 e0 04             	shl    $0x4,%eax
  802a72:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	c1 e0 04             	shl    $0x4,%eax
  802a82:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a87:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8c:	83 ec 0c             	sub    $0xc,%esp
  802a8f:	50                   	push   %eax
  802a90:	e8 f5 f9 ff ff       	call   80248a <to_page_info>
  802a95:	83 c4 10             	add    $0x10,%esp
  802a98:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802a9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802aa2:	48                   	dec    %eax
  802aa3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aa6:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aad:	e9 26 01 00 00       	jmp    802bd8 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802ab2:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	c1 e0 04             	shl    $0x4,%eax
  802abb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	0f 84 dc 00 00 00    	je     802ba6 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	c1 e0 04             	shl    $0x4,%eax
  802ad0:	05 80 c0 81 00       	add    $0x81c080,%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802ada:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ade:	75 17                	jne    802af7 <alloc_block+0x329>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 15 3c 80 00       	push   $0x803c15
  802ae8:	68 be 00 00 00       	push   $0xbe
  802aed:	68 57 3b 80 00       	push   $0x803b57
  802af2:	e8 05 de ff ff       	call   8008fc <_panic>
  802af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	74 10                	je     802b10 <alloc_block+0x342>
  802b00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b08:	8b 52 04             	mov    0x4(%edx),%edx
  802b0b:	89 50 04             	mov    %edx,0x4(%eax)
  802b0e:	eb 14                	jmp    802b24 <alloc_block+0x356>
  802b10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b19:	c1 e2 04             	shl    $0x4,%edx
  802b1c:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802b22:	89 02                	mov    %eax,(%edx)
  802b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 0f                	je     802b3d <alloc_block+0x36f>
  802b2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b37:	8b 12                	mov    (%edx),%edx
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	eb 13                	jmp    802b50 <alloc_block+0x382>
  802b3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b45:	c1 e2 04             	shl    $0x4,%edx
  802b48:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802b4e:	89 02                	mov    %eax,(%edx)
  802b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	c1 e0 04             	shl    $0x4,%eax
  802b69:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	c1 e0 04             	shl    $0x4,%eax
  802b79:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b7e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802b80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	50                   	push   %eax
  802b87:	e8 fe f8 ff ff       	call   80248a <to_page_info>
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b95:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b99:	48                   	dec    %eax
  802b9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b9d:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802ba1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba4:	eb 32                	jmp    802bd8 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802ba6:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802baa:	77 15                	ja     802bc1 <alloc_block+0x3f3>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	c1 e0 04             	shl    $0x4,%eax
  802bb2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	0f 84 f1 fe ff ff    	je     802ab2 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	68 33 3c 80 00       	push   $0x803c33
  802bc9:	68 c8 00 00 00       	push   $0xc8
  802bce:	68 57 3b 80 00       	push   $0x803b57
  802bd3:	e8 24 dd ff ff       	call   8008fc <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802bd8:	c9                   	leave  
  802bd9:	c3                   	ret    

00802bda <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802bda:	55                   	push   %ebp
  802bdb:	89 e5                	mov    %esp,%ebp
  802bdd:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802be8:	39 c2                	cmp    %eax,%edx
  802bea:	72 0c                	jb     802bf8 <free_block+0x1e>
  802bec:	8b 55 08             	mov    0x8(%ebp),%edx
  802bef:	a1 40 40 80 00       	mov    0x804040,%eax
  802bf4:	39 c2                	cmp    %eax,%edx
  802bf6:	72 19                	jb     802c11 <free_block+0x37>
  802bf8:	68 44 3c 80 00       	push   $0x803c44
  802bfd:	68 ba 3b 80 00       	push   $0x803bba
  802c02:	68 d7 00 00 00       	push   $0xd7
  802c07:	68 57 3b 80 00       	push   $0x803b57
  802c0c:	e8 eb dc ff ff       	call   8008fc <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	50                   	push   %eax
  802c1e:	e8 67 f8 ff ff       	call   80248a <to_page_info>
  802c23:	83 c4 10             	add    $0x10,%esp
  802c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	0f b7 c0             	movzwl %ax,%eax
  802c32:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802c35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802c3c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802c43:	eb 19                	jmp    802c5e <free_block+0x84>
	    if ((1 << i) == blk_size)
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	ba 01 00 00 00       	mov    $0x1,%edx
  802c4d:	88 c1                	mov    %al,%cl
  802c4f:	d3 e2                	shl    %cl,%edx
  802c51:	89 d0                	mov    %edx,%eax
  802c53:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c56:	74 0e                	je     802c66 <free_block+0x8c>
	        break;
	    idx++;
  802c58:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802c5b:	ff 45 f0             	incl   -0x10(%ebp)
  802c5e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802c62:	7e e1                	jle    802c45 <free_block+0x6b>
  802c64:	eb 01                	jmp    802c67 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802c66:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c6e:	40                   	inc    %eax
  802c6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c72:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802c76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c7a:	75 17                	jne    802c93 <free_block+0xb9>
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	68 d0 3b 80 00       	push   $0x803bd0
  802c84:	68 ee 00 00 00       	push   $0xee
  802c89:	68 57 3b 80 00       	push   $0x803b57
  802c8e:	e8 69 dc ff ff       	call   8008fc <_panic>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	c1 e0 04             	shl    $0x4,%eax
  802c99:	05 84 c0 81 00       	add    $0x81c084,%eax
  802c9e:	8b 10                	mov    (%eax),%edx
  802ca0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca3:	89 50 04             	mov    %edx,0x4(%eax)
  802ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 14                	je     802cc4 <free_block+0xea>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c1 e0 04             	shl    $0x4,%eax
  802cb6:	05 84 c0 81 00       	add    $0x81c084,%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 11                	jmp    802cd5 <free_block+0xfb>
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	c1 e0 04             	shl    $0x4,%eax
  802cca:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd3:	89 02                	mov    %eax,(%edx)
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	c1 e0 04             	shl    $0x4,%eax
  802cdb:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce4:	89 02                	mov    %eax,(%edx)
  802ce6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	c1 e0 04             	shl    $0x4,%eax
  802cf5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	8d 50 01             	lea    0x1(%eax),%edx
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	c1 e0 04             	shl    $0x4,%eax
  802d05:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802d0a:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802d0c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d11:	ba 00 00 00 00       	mov    $0x0,%edx
  802d16:	f7 75 e0             	divl   -0x20(%ebp)
  802d19:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802d23:	0f b7 c0             	movzwl %ax,%eax
  802d26:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d29:	0f 85 70 01 00 00    	jne    802e9f <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802d2f:	83 ec 0c             	sub    $0xc,%esp
  802d32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d35:	e8 de f6 ff ff       	call   802418 <to_page_va>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802d40:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d47:	e9 b7 00 00 00       	jmp    802e03 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802d4c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802d57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d5b:	75 17                	jne    802d74 <free_block+0x19a>
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 15 3c 80 00       	push   $0x803c15
  802d65:	68 f8 00 00 00       	push   $0xf8
  802d6a:	68 57 3b 80 00       	push   $0x803b57
  802d6f:	e8 88 db ff ff       	call   8008fc <_panic>
  802d74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 10                	je     802d8d <free_block+0x1b3>
  802d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d85:	8b 52 04             	mov    0x4(%edx),%edx
  802d88:	89 50 04             	mov    %edx,0x4(%eax)
  802d8b:	eb 14                	jmp    802da1 <free_block+0x1c7>
  802d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d96:	c1 e2 04             	shl    $0x4,%edx
  802d99:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802d9f:	89 02                	mov    %eax,(%edx)
  802da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0f                	je     802dba <free_block+0x1e0>
  802dab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802db4:	8b 12                	mov    (%edx),%edx
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	eb 13                	jmp    802dcd <free_block+0x1f3>
  802dba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc2:	c1 e2 04             	shl    $0x4,%edx
  802dc5:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802dcb:	89 02                	mov    %eax,(%edx)
  802dcd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	c1 e0 04             	shl    $0x4,%eax
  802de6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	8d 50 ff             	lea    -0x1(%eax),%edx
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	c1 e0 04             	shl    $0x4,%eax
  802df6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802dfb:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e00:	01 45 ec             	add    %eax,-0x14(%ebp)
  802e03:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802e0a:	0f 86 3c ff ff ff    	jbe    802d4c <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e13:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802e22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e26:	75 17                	jne    802e3f <free_block+0x265>
  802e28:	83 ec 04             	sub    $0x4,%esp
  802e2b:	68 d0 3b 80 00       	push   $0x803bd0
  802e30:	68 fe 00 00 00       	push   $0xfe
  802e35:	68 57 3b 80 00       	push   $0x803b57
  802e3a:	e8 bd da ff ff       	call   8008fc <_panic>
  802e3f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 0c                	je     802e61 <free_block+0x287>
  802e55:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802e5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e5d:	89 10                	mov    %edx,(%eax)
  802e5f:	eb 08                	jmp    802e69 <free_block+0x28f>
  802e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e64:	a3 48 40 80 00       	mov    %eax,0x804048
  802e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7a:	a1 54 40 80 00       	mov    0x804054,%eax
  802e7f:	40                   	inc    %eax
  802e80:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802e85:	83 ec 0c             	sub    $0xc,%esp
  802e88:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e8b:	e8 88 f5 ff ff       	call   802418 <to_page_va>
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	50                   	push   %eax
  802e97:	e8 b8 ee ff ff       	call   801d54 <return_page>
  802e9c:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802e9f:	90                   	nop
  802ea0:	c9                   	leave  
  802ea1:	c3                   	ret    

00802ea2 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 7c 3c 80 00       	push   $0x803c7c
  802eb0:	68 11 01 00 00       	push   $0x111
  802eb5:	68 57 3b 80 00       	push   $0x803b57
  802eba:	e8 3d da ff ff       	call   8008fc <_panic>
  802ebf:	90                   	nop

00802ec0 <__udivdi3>:
  802ec0:	55                   	push   %ebp
  802ec1:	57                   	push   %edi
  802ec2:	56                   	push   %esi
  802ec3:	53                   	push   %ebx
  802ec4:	83 ec 1c             	sub    $0x1c,%esp
  802ec7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802ecb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802ecf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ed3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ed7:	89 ca                	mov    %ecx,%edx
  802ed9:	89 f8                	mov    %edi,%eax
  802edb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802edf:	85 f6                	test   %esi,%esi
  802ee1:	75 2d                	jne    802f10 <__udivdi3+0x50>
  802ee3:	39 cf                	cmp    %ecx,%edi
  802ee5:	77 65                	ja     802f4c <__udivdi3+0x8c>
  802ee7:	89 fd                	mov    %edi,%ebp
  802ee9:	85 ff                	test   %edi,%edi
  802eeb:	75 0b                	jne    802ef8 <__udivdi3+0x38>
  802eed:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef2:	31 d2                	xor    %edx,%edx
  802ef4:	f7 f7                	div    %edi
  802ef6:	89 c5                	mov    %eax,%ebp
  802ef8:	31 d2                	xor    %edx,%edx
  802efa:	89 c8                	mov    %ecx,%eax
  802efc:	f7 f5                	div    %ebp
  802efe:	89 c1                	mov    %eax,%ecx
  802f00:	89 d8                	mov    %ebx,%eax
  802f02:	f7 f5                	div    %ebp
  802f04:	89 cf                	mov    %ecx,%edi
  802f06:	89 fa                	mov    %edi,%edx
  802f08:	83 c4 1c             	add    $0x1c,%esp
  802f0b:	5b                   	pop    %ebx
  802f0c:	5e                   	pop    %esi
  802f0d:	5f                   	pop    %edi
  802f0e:	5d                   	pop    %ebp
  802f0f:	c3                   	ret    
  802f10:	39 ce                	cmp    %ecx,%esi
  802f12:	77 28                	ja     802f3c <__udivdi3+0x7c>
  802f14:	0f bd fe             	bsr    %esi,%edi
  802f17:	83 f7 1f             	xor    $0x1f,%edi
  802f1a:	75 40                	jne    802f5c <__udivdi3+0x9c>
  802f1c:	39 ce                	cmp    %ecx,%esi
  802f1e:	72 0a                	jb     802f2a <__udivdi3+0x6a>
  802f20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f24:	0f 87 9e 00 00 00    	ja     802fc8 <__udivdi3+0x108>
  802f2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f2f:	89 fa                	mov    %edi,%edx
  802f31:	83 c4 1c             	add    $0x1c,%esp
  802f34:	5b                   	pop    %ebx
  802f35:	5e                   	pop    %esi
  802f36:	5f                   	pop    %edi
  802f37:	5d                   	pop    %ebp
  802f38:	c3                   	ret    
  802f39:	8d 76 00             	lea    0x0(%esi),%esi
  802f3c:	31 ff                	xor    %edi,%edi
  802f3e:	31 c0                	xor    %eax,%eax
  802f40:	89 fa                	mov    %edi,%edx
  802f42:	83 c4 1c             	add    $0x1c,%esp
  802f45:	5b                   	pop    %ebx
  802f46:	5e                   	pop    %esi
  802f47:	5f                   	pop    %edi
  802f48:	5d                   	pop    %ebp
  802f49:	c3                   	ret    
  802f4a:	66 90                	xchg   %ax,%ax
  802f4c:	89 d8                	mov    %ebx,%eax
  802f4e:	f7 f7                	div    %edi
  802f50:	31 ff                	xor    %edi,%edi
  802f52:	89 fa                	mov    %edi,%edx
  802f54:	83 c4 1c             	add    $0x1c,%esp
  802f57:	5b                   	pop    %ebx
  802f58:	5e                   	pop    %esi
  802f59:	5f                   	pop    %edi
  802f5a:	5d                   	pop    %ebp
  802f5b:	c3                   	ret    
  802f5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f61:	89 eb                	mov    %ebp,%ebx
  802f63:	29 fb                	sub    %edi,%ebx
  802f65:	89 f9                	mov    %edi,%ecx
  802f67:	d3 e6                	shl    %cl,%esi
  802f69:	89 c5                	mov    %eax,%ebp
  802f6b:	88 d9                	mov    %bl,%cl
  802f6d:	d3 ed                	shr    %cl,%ebp
  802f6f:	89 e9                	mov    %ebp,%ecx
  802f71:	09 f1                	or     %esi,%ecx
  802f73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f77:	89 f9                	mov    %edi,%ecx
  802f79:	d3 e0                	shl    %cl,%eax
  802f7b:	89 c5                	mov    %eax,%ebp
  802f7d:	89 d6                	mov    %edx,%esi
  802f7f:	88 d9                	mov    %bl,%cl
  802f81:	d3 ee                	shr    %cl,%esi
  802f83:	89 f9                	mov    %edi,%ecx
  802f85:	d3 e2                	shl    %cl,%edx
  802f87:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f8b:	88 d9                	mov    %bl,%cl
  802f8d:	d3 e8                	shr    %cl,%eax
  802f8f:	09 c2                	or     %eax,%edx
  802f91:	89 d0                	mov    %edx,%eax
  802f93:	89 f2                	mov    %esi,%edx
  802f95:	f7 74 24 0c          	divl   0xc(%esp)
  802f99:	89 d6                	mov    %edx,%esi
  802f9b:	89 c3                	mov    %eax,%ebx
  802f9d:	f7 e5                	mul    %ebp
  802f9f:	39 d6                	cmp    %edx,%esi
  802fa1:	72 19                	jb     802fbc <__udivdi3+0xfc>
  802fa3:	74 0b                	je     802fb0 <__udivdi3+0xf0>
  802fa5:	89 d8                	mov    %ebx,%eax
  802fa7:	31 ff                	xor    %edi,%edi
  802fa9:	e9 58 ff ff ff       	jmp    802f06 <__udivdi3+0x46>
  802fae:	66 90                	xchg   %ax,%ax
  802fb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  802fb4:	89 f9                	mov    %edi,%ecx
  802fb6:	d3 e2                	shl    %cl,%edx
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	73 e9                	jae    802fa5 <__udivdi3+0xe5>
  802fbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fbf:	31 ff                	xor    %edi,%edi
  802fc1:	e9 40 ff ff ff       	jmp    802f06 <__udivdi3+0x46>
  802fc6:	66 90                	xchg   %ax,%ax
  802fc8:	31 c0                	xor    %eax,%eax
  802fca:	e9 37 ff ff ff       	jmp    802f06 <__udivdi3+0x46>
  802fcf:	90                   	nop

00802fd0 <__umoddi3>:
  802fd0:	55                   	push   %ebp
  802fd1:	57                   	push   %edi
  802fd2:	56                   	push   %esi
  802fd3:	53                   	push   %ebx
  802fd4:	83 ec 1c             	sub    $0x1c,%esp
  802fd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802fdb:	8b 74 24 34          	mov    0x34(%esp),%esi
  802fdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fe3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802fef:	89 f3                	mov    %esi,%ebx
  802ff1:	89 fa                	mov    %edi,%edx
  802ff3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ff7:	89 34 24             	mov    %esi,(%esp)
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	75 1a                	jne    803018 <__umoddi3+0x48>
  802ffe:	39 f7                	cmp    %esi,%edi
  803000:	0f 86 a2 00 00 00    	jbe    8030a8 <__umoddi3+0xd8>
  803006:	89 c8                	mov    %ecx,%eax
  803008:	89 f2                	mov    %esi,%edx
  80300a:	f7 f7                	div    %edi
  80300c:	89 d0                	mov    %edx,%eax
  80300e:	31 d2                	xor    %edx,%edx
  803010:	83 c4 1c             	add    $0x1c,%esp
  803013:	5b                   	pop    %ebx
  803014:	5e                   	pop    %esi
  803015:	5f                   	pop    %edi
  803016:	5d                   	pop    %ebp
  803017:	c3                   	ret    
  803018:	39 f0                	cmp    %esi,%eax
  80301a:	0f 87 ac 00 00 00    	ja     8030cc <__umoddi3+0xfc>
  803020:	0f bd e8             	bsr    %eax,%ebp
  803023:	83 f5 1f             	xor    $0x1f,%ebp
  803026:	0f 84 ac 00 00 00    	je     8030d8 <__umoddi3+0x108>
  80302c:	bf 20 00 00 00       	mov    $0x20,%edi
  803031:	29 ef                	sub    %ebp,%edi
  803033:	89 fe                	mov    %edi,%esi
  803035:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803039:	89 e9                	mov    %ebp,%ecx
  80303b:	d3 e0                	shl    %cl,%eax
  80303d:	89 d7                	mov    %edx,%edi
  80303f:	89 f1                	mov    %esi,%ecx
  803041:	d3 ef                	shr    %cl,%edi
  803043:	09 c7                	or     %eax,%edi
  803045:	89 e9                	mov    %ebp,%ecx
  803047:	d3 e2                	shl    %cl,%edx
  803049:	89 14 24             	mov    %edx,(%esp)
  80304c:	89 d8                	mov    %ebx,%eax
  80304e:	d3 e0                	shl    %cl,%eax
  803050:	89 c2                	mov    %eax,%edx
  803052:	8b 44 24 08          	mov    0x8(%esp),%eax
  803056:	d3 e0                	shl    %cl,%eax
  803058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80305c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803060:	89 f1                	mov    %esi,%ecx
  803062:	d3 e8                	shr    %cl,%eax
  803064:	09 d0                	or     %edx,%eax
  803066:	d3 eb                	shr    %cl,%ebx
  803068:	89 da                	mov    %ebx,%edx
  80306a:	f7 f7                	div    %edi
  80306c:	89 d3                	mov    %edx,%ebx
  80306e:	f7 24 24             	mull   (%esp)
  803071:	89 c6                	mov    %eax,%esi
  803073:	89 d1                	mov    %edx,%ecx
  803075:	39 d3                	cmp    %edx,%ebx
  803077:	0f 82 87 00 00 00    	jb     803104 <__umoddi3+0x134>
  80307d:	0f 84 91 00 00 00    	je     803114 <__umoddi3+0x144>
  803083:	8b 54 24 04          	mov    0x4(%esp),%edx
  803087:	29 f2                	sub    %esi,%edx
  803089:	19 cb                	sbb    %ecx,%ebx
  80308b:	89 d8                	mov    %ebx,%eax
  80308d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803091:	d3 e0                	shl    %cl,%eax
  803093:	89 e9                	mov    %ebp,%ecx
  803095:	d3 ea                	shr    %cl,%edx
  803097:	09 d0                	or     %edx,%eax
  803099:	89 e9                	mov    %ebp,%ecx
  80309b:	d3 eb                	shr    %cl,%ebx
  80309d:	89 da                	mov    %ebx,%edx
  80309f:	83 c4 1c             	add    $0x1c,%esp
  8030a2:	5b                   	pop    %ebx
  8030a3:	5e                   	pop    %esi
  8030a4:	5f                   	pop    %edi
  8030a5:	5d                   	pop    %ebp
  8030a6:	c3                   	ret    
  8030a7:	90                   	nop
  8030a8:	89 fd                	mov    %edi,%ebp
  8030aa:	85 ff                	test   %edi,%edi
  8030ac:	75 0b                	jne    8030b9 <__umoddi3+0xe9>
  8030ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b3:	31 d2                	xor    %edx,%edx
  8030b5:	f7 f7                	div    %edi
  8030b7:	89 c5                	mov    %eax,%ebp
  8030b9:	89 f0                	mov    %esi,%eax
  8030bb:	31 d2                	xor    %edx,%edx
  8030bd:	f7 f5                	div    %ebp
  8030bf:	89 c8                	mov    %ecx,%eax
  8030c1:	f7 f5                	div    %ebp
  8030c3:	89 d0                	mov    %edx,%eax
  8030c5:	e9 44 ff ff ff       	jmp    80300e <__umoddi3+0x3e>
  8030ca:	66 90                	xchg   %ax,%ax
  8030cc:	89 c8                	mov    %ecx,%eax
  8030ce:	89 f2                	mov    %esi,%edx
  8030d0:	83 c4 1c             	add    $0x1c,%esp
  8030d3:	5b                   	pop    %ebx
  8030d4:	5e                   	pop    %esi
  8030d5:	5f                   	pop    %edi
  8030d6:	5d                   	pop    %ebp
  8030d7:	c3                   	ret    
  8030d8:	3b 04 24             	cmp    (%esp),%eax
  8030db:	72 06                	jb     8030e3 <__umoddi3+0x113>
  8030dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8030e1:	77 0f                	ja     8030f2 <__umoddi3+0x122>
  8030e3:	89 f2                	mov    %esi,%edx
  8030e5:	29 f9                	sub    %edi,%ecx
  8030e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8030eb:	89 14 24             	mov    %edx,(%esp)
  8030ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8030f6:	8b 14 24             	mov    (%esp),%edx
  8030f9:	83 c4 1c             	add    $0x1c,%esp
  8030fc:	5b                   	pop    %ebx
  8030fd:	5e                   	pop    %esi
  8030fe:	5f                   	pop    %edi
  8030ff:	5d                   	pop    %ebp
  803100:	c3                   	ret    
  803101:	8d 76 00             	lea    0x0(%esi),%esi
  803104:	2b 04 24             	sub    (%esp),%eax
  803107:	19 fa                	sbb    %edi,%edx
  803109:	89 d1                	mov    %edx,%ecx
  80310b:	89 c6                	mov    %eax,%esi
  80310d:	e9 71 ff ff ff       	jmp    803083 <__umoddi3+0xb3>
  803112:	66 90                	xchg   %ax,%ax
  803114:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803118:	72 ea                	jb     803104 <__umoddi3+0x134>
  80311a:	89 d9                	mov    %ebx,%ecx
  80311c:	e9 62 ff ff ff       	jmp    803083 <__umoddi3+0xb3>
